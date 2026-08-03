#!/usr/bin/env bash
# pulso.sh — ¿hay algo que hacer? Todo el PASO 0 y el PASO 1 en una sola llamada.
#
#   ./bin/pulso.sh
#
# La mayoria de las vueltas del loop no tienen nada que hacer. Antes cada una de esas
# vueltas costaba tres lecturas de archivo mas una consulta al MCP para terminar en
# "NO HICE NADA". Este script contesta lo mismo en una llamada y unos 50 tokens.
#
# NO decide por el bot: da los hechos y dice que reglas del PASO 3 estan en juego.
# Quien elige (y sobre todo, si un mensaje es una despedida) sigue siendo el modelo.
#
# Estados posibles:
#   NADA     — sin mensajes nuevos y sin silencio suficiente. Se corta la iteracion aqui.
#   NUEVOS   — hay mensajes nuevos de Ginger. Aplican las reglas 2 o 3.
#   REVISAR  — no hay de ella, pero hay algo que mirar: mensajes nuevos de Mikel
#              (regla 6) o silencio largo (reglas 4 o 5).

set -uo pipefail
source "$(dirname "$(readlink -f "$0")")/comun.sh"

# Minutos de silencio a partir de los cuales vale la pena plantearse sacar tema (regla 4).
UMBRAL_SILENCIO="${WSP_UMBRAL_SILENCIO:-30}"

# Tope de mensajes a mostrar. Si el cursor quedo muy atras (el bot estuvo apagado un dia),
# sin tope esto escupe miles de lineas y entierra la iteracion.
TOPE="${WSP_TOPE:-40}"

# Arranque en frio: cuantos mensajes de contexto leer la primera vuelta de cada encendido,
# y a partir de cuantos minutos sin correr se considera que el bot se acaba de prender.
CONTEXTO_FRIO="${WSP_CONTEXTO_FRIO:-100}"
FRIO_MIN="${WSP_FRIO_MIN:-10}"
MARCA_VUELTA="$BASE/nucleo/.ultima_vuelta"

# Si no hay marca, o la ultima vuelta fue hace rato, es que el bot estuvo apagado.
ARRANQUE="CALIENTE"
if [ ! -f "$MARCA_VUELTA" ]; then
  ARRANQUE="FRIO"
else
  edad_min=$(( ( $(date +%s) - $(stat -c %Y "$MARCA_VUELTA" 2>/dev/null || echo 0) ) / 60 ))
  [ "$edad_min" -ge "$FRIO_MIN" ] && ARRANQUE="FRIO"
fi
touch "$MARCA_VUELTA"

LAST_TS="$(leer_cursor LAST_GINGER_TS)"
[ -n "$LAST_TS" ] || LAST_TS="1970-01-01 00:00:00"

ESC_LAST="${LAST_TS//\'/\'\'}"

# --- mensajes posteriores al cursor, con su rol ya resuelto ---
# GINGER  = is_from_me 0
# TULPA   = lo mandamos nosotros por la API (sender __tulpa__)
# MIKEL   = is_from_me 1 que no es nuestro (lo escribio el desde el telefono)
TOTAL_NUEVOS="$(consulta "
  select count(*) from messages
  where chat_jid = '$JID' and $TS_SQL > '$ESC_LAST';
")"

# Se piden los ultimos TOPE y se reordenan ascendente, para quedarse con los mas
# recientes cuando el cursor viene muy atrasado.
FILAS="$(consulta "
  select * from (
    select
      $TS_SQL as ts,
      case
        when is_from_me = 0 then 'GINGER'
        when sender = '$SENDER_TULPA' then 'TULPA'
        else 'MIKEL'
      end as rol,
      coalesce(media_type,'') as media,
      coalesce(id,'') as mid,
      replace(replace(coalesce(content,''), char(10), ' '), char(9), ' ') as texto
    from messages
    where chat_jid = '$JID' and $TS_SQL > '$ESC_LAST'
    order by timestamp desc limit $TOPE
  ) order by ts asc;
")"

# --- estado general del chat, haya o no mensajes nuevos ---
ULTIMO="$(consulta "
  select $TS_SQL,
    case
      when is_from_me = 0 then 'GINGER'
      when sender = '$SENDER_TULPA' then 'TULPA'
      else 'MIKEL'
    end
  from messages where chat_jid = '$JID' order by timestamp desc limit 1;
")"
ULTIMO_TS="${ULTIMO%%${SEP}*}"
ULTIMO_ROL="${ULTIMO##*${SEP}}"

SILENCIO_MIN=0
if [ -n "$ULTIMO_TS" ]; then
  ahora=$(date +%s)
  ult=$(date -d "$ULTIMO_TS" +%s 2>/dev/null || echo "$ahora")
  SILENCIO_MIN=$(( (ahora - ult) / 60 ))
fi

hay_ginger=0
hay_mikel=0
if [ -n "$FILAS" ]; then
  grep -q "${SEP}GINGER${SEP}" <<< "$FILAS" && hay_ginger=1
  grep -q "${SEP}MIKEL${SEP}"  <<< "$FILAS" && hay_mikel=1
fi

if [ "$hay_ginger" -eq 1 ]; then
  ESTADO="NUEVOS"
elif [ "$hay_mikel" -eq 1 ] || [ "$SILENCIO_MIN" -ge "$UMBRAL_SILENCIO" ]; then
  ESTADO="REVISAR"
else
  ESTADO="NADA"
fi

echo "ESTADO: $ESTADO"
echo "ARRANQUE: $ARRANQUE"
echo "LAST_GINGER_TS: $LAST_TS"
echo "ULTIMO_EN_EL_CHAT: ${ULTIMO_ROL:-ninguno} (${ULTIMO_TS:-sin mensajes})"
echo "SILENCIO_MIN: $SILENCIO_MIN"

# En el primer pulso de cada encendido se vuelca el chat reciente para no entrar en frio
# a una conversacion que siguio sin la tulpa. Sale una sola vez por encendido: en las
# vueltas siguientes ARRANQUE ya es CALIENTE y esto no se imprime.
if [ "$ARRANQUE" = "FRIO" ]; then
  echo "--- CONTEXTO DE ARRANQUE: ultimos $CONTEXTO_FRIO mensajes ---"
  echo "(el bot estuvo apagado. Leelo entero antes de escribir nada: puede haber pasado"
  echo " cualquier cosa mientras no estabas, y meterte sin saberlo es la peor falla.)"
  consulta "
    select * from (
      select
        $TS_SQL,
        case
          when is_from_me = 0 then 'GINGER'
          when sender = '$SENDER_TULPA' then 'TULPA'
          else 'MIKEL'
        end,
        case
          when coalesce(media_type,'') <> '' then '<' || media_type || '>'
          else replace(replace(coalesce(content,''), char(10), ' '), char(9), ' ')
        end
      from messages
      where chat_jid = '$JID'
      order by timestamp desc limit $CONTEXTO_FRIO
    ) order by 1 asc;
  " | while IFS="$SEP" read -r ts rol cuerpo; do
    [ -n "$ts" ] || continue
    printf '[%s %s] %-7s %s\n' "${ts:5:5}" "${ts:11:5}" "$rol:" "$cuerpo"
  done
  echo "--- FIN DEL CONTEXTO ---"
fi

if [ "$ESTADO" = "NADA" ]; then
  echo "REGLAS: 1 o 5 — nada nuevo de ella y el silencio no llega a $UMBRAL_SILENCIO min. No escribas."
  exit 0
fi

if [ "$hay_ginger" -eq 1 ]; then
  echo "REGLAS: 2 o 3 — hay mensajes suyos sin responder. Decidi vos si el ultimo es una despedida."
elif [ "$hay_mikel" -eq 1 ]; then
  echo "REGLAS: 6 — solo escribio Mikel. Meterte es opcional; no le pises una disculpa ni un tema suyo."
else
  echo "REGLAS: 4 o 5 — $SILENCIO_MIN min de silencio. Sacar tema solo si no hubo despedida."
fi

echo "--- MENSAJES NUEVOS ---"
if [ "${TOTAL_NUEVOS:-0}" -gt "$TOPE" ]; then
  echo "(hay $TOTAL_NUEVOS sin procesar; se muestran los $TOPE mas recientes)"
fi
if [ -z "$FILAS" ]; then
  echo "(ninguno)"
else
  while IFS="$SEP" read -r ts rol media id texto; do
    [ -n "$ts" ] || continue
    hora="${ts:11:8}"
    if [ -n "$media" ]; then
      # La media se anuncia con su id para poder bajarla; el contenido se resuelve
      # despues (PASO 1B), y si ya se resolvio antes se muestra cacheado.
      cache=""
      [ -s "$TRANSCRIPCIONES/$id.txt" ] && cache="$(head -c 300 "$TRANSCRIPCIONES/$id.txt")"
      [ -s "$DESCRIPCIONES/$id.txt" ]   && cache="$(head -c 300 "$DESCRIPCIONES/$id.txt")"
      if [ -n "$cache" ]; then
        echo "[$hora] $rol: <$media ya resuelto: $cache>"
      else
        echo "[$hora] $rol: <$media PENDIENTE - Message ID: $id>"
      fi
    else
      echo "[$hora] $rol: $texto"
    fi
  done <<< "$FILAS"
fi
echo "--- FIN ---"
