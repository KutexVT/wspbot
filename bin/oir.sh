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
MAX_SEG=180   # 3 min: mas que eso se corta, para no colgar la iteracion del bot

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

recortado=""
if [ "$dur" -gt "$MAX_SEG" ] 2>/dev/null; then
  recortado=" [audio de ${dur}s, transcrito solo los primeros $((MAX_SEG/60)) min]"
  ffmpeg -nostdin -v error -i "$AUDIO" -t "$MAX_SEG" -ar 16000 -ac 1 -c:a pcm_s16le "$WAV" 2>/dev/null
else
  ffmpeg -nostdin -v error -i "$AUDIO" -ar 16000 -ac 1 -c:a pcm_s16le "$WAV" 2>/dev/null
fi

if [ ! -s "$WAV" ]; then
  echo "ERROR: ffmpeg no pudo convertir el audio" >&2
  exit 3
fi

# -l es es obligatorio: sin idioma fijo, los audios cortos a veces los detecta como portugues.
# -nt sin timestamps, -np sin banner de progreso.
TEXTO="$("$WHISPER" -m "$MODELO" -f "$WAV" -l es -nt -np 2>/dev/null | tr -s '[:space:]' ' ' | sed 's/^ *//;s/ *$//')"

if [ -z "$TEXTO" ]; then
  # Distinguir "no se entendio" de "fallo el proceso" importa: el bot no debe leer un
  # error como si ella hubiera mandado un audio en silencio.
  echo "[audio sin habla reconocible]"
  exit 0
fi

TEXTO="$TEXTO$recortado"

if [ -n "$MSG_ID" ]; then
  mkdir -p "$CACHE"
  printf '%s\n' "$TEXTO" > "$CACHE/$MSG_ID.txt"
fi

printf '%s\n' "$TEXTO"
