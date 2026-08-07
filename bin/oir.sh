#!/usr/bin/env bash
# oir.sh — transcribe una nota de voz de WhatsApp a texto.
#
#   ./oir.sh /ruta/audio_20260729_171052.ogg
#   ./oir.sh /ruta/audio.ogg ACA3B0947C00127F4760C95AAA5CD9CF   # con message_id → cachea
#
# Escribe la transcripcion en stdout y nada mas. Todo lo demas (avisos, errores) va a
# stderr, para que quien lo llame pueda usar la salida directo.
#
# Si le pasas el message_id, guarda el resultado en media/transcripciones/<id>.txt y la
# proxima vez lo devuelve de ahi sin volver a transcribir. Sin eso, el loop que corre cada
# minuto re-transcribiria el mismo audio en cada vuelta.

set -uo pipefail

BASE="/home/kutex/WSP Bot"
MODELO="$BASE/bin/models/ggml-small.bin"
CACHE="$BASE/media/transcripciones"

# El limite ya no es el largo del audio sino el TIEMPO DE RELOJ que puede costar la
# transcripcion, que es lo que de verdad importa dentro de una vuelta de 1 minuto.
#
# Se transcribe por trozos seguidos y se para al agotar el presupuesto, asi que un audio
# largo devuelve lo que dio tiempo a sacar en vez de quedarse en los primeros 3 minutos
# pasara lo que pasara. El 2026-08-06 ella mando uno de casi 10 minutos y se perdieron 7
# sin que nadie se enterara.
#
# Medido en esta maquina (Ryzen, whisper.cpp con ggml-small en CPU): 102 s de audio en
# 22 s de reloj, o sea unas 4,6 veces mas rapido que el tiempo real. Con 90 s de
# presupuesto entran unos 7 minutos de audio, mas del doble que antes.
# El presupuesto se mira DESPUES de cada pasada, nunca a mitad de una, asi que el techo
# real es PRESUPUESTO mas lo que dure el ultimo trozo: con estos numeros, unos 115 s en
# el peor caso. Por eso el trozo es de 2 minutos y no de 3 — cuanto mas corto, menos se
# pasa de la cuenta, a cambio de unas pocas pasadas mas.
MAX_SEG=1800        # 30 min: tope de cordura, no de rendimiento
TROZO_SEG=120       # cuanto audio entra en cada pasada de whisper
PRESUPUESTO=90      # segundos de reloj como mucho, sumando todas las pasadas

# Medido: 4 y 8 hilos tardan lo mismo y 16 tarda MAS (27 s contra 22). whisper.cpp
# escala mal pasados unos pocos, y ademas conviene dejarle CPU al resto del sistema.
HILOS="${WSP_HILOS:-8}"

if [ $# -eq 0 ]; then
  echo "uso: oir.sh <archivo.ogg> [message_id]" >&2
  exit 1
fi

AUDIO="$1"
MSG_ID="${2:-}"

if [ ! -f "$AUDIO" ]; then
  echo "ERROR: no existe el archivo: $AUDIO" >&2
  exit 1
fi

# --- cache: si ya lo transcribimos, devolverlo y salir ---
if [ -n "$MSG_ID" ]; then
  CACHE_FILE="$CACHE/$MSG_ID.txt"
  if [ -s "$CACHE_FILE" ]; then
    cat "$CACHE_FILE"
    exit 0
  fi
fi

# --- el binario cambia de nombre entre versiones del paquete ---
WHISPER=""
for cand in whisper-cli whisper-cpp whisper main; do
  if command -v "$cand" >/dev/null 2>&1; then
    WHISPER="$(command -v "$cand")"
    break
  fi
done

if [ -z "$WHISPER" ]; then
  echo "ERROR: whisper no esta instalado. Corre:  sudo pacman -S whisper-cpp" >&2
  exit 2
fi

if [ ! -f "$MODELO" ]; then
  echo "ERROR: falta el modelo en $MODELO" >&2
  echo "       bajalo de https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-small.bin" >&2
  exit 2
fi

if ! command -v ffmpeg >/dev/null 2>&1; then
  echo "ERROR: falta ffmpeg" >&2
  exit 2
fi

# --- opus de whatsapp → wav 16kHz mono, que es lo unico que come whisper.cpp ---
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
WAV="$TMP/audio.wav"

dur="$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$AUDIO" 2>/dev/null | cut -d. -f1)"
dur="${dur:-0}"

# Una sola conversion aunque haya varios trozos: whisper acepta offset y duracion sobre
# el mismo archivo, asi que trocear no cuesta ni un ffmpeg de mas.
ffmpeg -nostdin -v error -i "$AUDIO" -t "$MAX_SEG" -ar 16000 -ac 1 -c:a pcm_s16le "$WAV" 2>/dev/null

if [ ! -s "$WAV" ]; then
  echo "ERROR: ffmpeg no pudo convertir el audio" >&2
  exit 3
fi

[ "$dur" -gt "$MAX_SEG" ] 2>/dev/null && dur="$MAX_SEG"

# --- transcribir por trozos hasta que se acabe el audio o el presupuesto ---
# El corte entre trozos es seco, sin solape: puede partir una palabra justo en la
# juntura. Con solape saldrian palabras repetidas, y eso confunde mas que una silaba
# perdida.
TEXTO=""
cubierto=0
ini_reloj=$(date +%s)

while [ "$cubierto" -lt "$dur" ]; do
  # -l es es obligatorio: sin idioma fijo, los audios cortos a veces los detecta como
  # portugues. -nt sin timestamps, -np sin banner de progreso.
  trozo="$("$WHISPER" -m "$MODELO" -f "$WAV" -l es -nt -np -t "$HILOS" \
             -ot "$((cubierto * 1000))" -d "$((TROZO_SEG * 1000))" 2>/dev/null \
           | tr -s '[:space:]' ' ' | sed 's/^ *//;s/ *$//')"
  [ -n "$trozo" ] && TEXTO="${TEXTO:+$TEXTO }$trozo"
  cubierto=$((cubierto + TROZO_SEG))
  [ "$cubierto" -gt "$dur" ] && cubierto="$dur"

  # Se comprueba DESPUES de la pasada: la primera se hace siempre, valga lo que valga.
  # Si no, un audio largo en una maquina cargada podria no devolver nada.
  [ $(( $(date +%s) - ini_reloj )) -ge "$PRESUPUESTO" ] && break
done

if [ -z "$TEXTO" ]; then
  # Distinguir "no se entendio" de "fallo el proceso" importa: el bot no debe leer un
  # error como si ella hubiera mandado un audio en silencio.
  echo "[audio sin habla reconocible]"
  exit 0
fi

# El aviso de recorte va DELANTE del texto, no detras. Pegado al final se lee cuando ya
# te formaste la idea de lo que dijo, que es justo cuando ya no sirve de nada.
if [ "$cubierto" -lt "$dur" ]; then
  TEXTO="[SOLO LOS PRIMEROS $((cubierto / 60)) MIN de un audio de $((dur / 60))m$((dur % 60))s] $TEXTO"
fi

if [ -n "$MSG_ID" ]; then
  mkdir -p "$CACHE"
  printf '%s\n' "$TEXTO" > "$CACHE/$MSG_ID.txt"
fi

printf '%s\n' "$TEXTO"
