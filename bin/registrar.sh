#!/usr/bin/env bash
# registrar.sh — cierra la iteracion: mueve el cursor y escribe el log, de una sola vez.
#
#   ./bin/registrar.sh --log "NO RESPONDI — sin mensajes nuevos"
#   ./bin/registrar.sh --ts "2026-07-30 21:15:02" --log "RESPONDI — despedida"
#
#   --ts   timestamp del ultimo mensaje de Ginger ya procesado. Sin esto el cursor no
#          se mueve (para las vueltas en las que no se respondio nada).
#   --log  una linea de auditoria. Se le antepone la hora sola.
#
# Por que existe: antes esto eran de tres a seis ediciones sueltas del modelo, y entre
# una y otra el chat seguia moviendose. Si la iteracion siguiente arrancaba en medio,
# leia un cursor a medio escribir. Aca las dos escrituras van bajo el mismo flock y el
# cursor se reemplaza entero de golpe, asi que o se ve el estado viejo o el nuevo, nunca
# uno partido.

set -uo pipefail
source "$(dirname "$(readlink -f "$0")")/comun.sh"

TS=""
LINEA_LOG=""

while [ $# -gt 0 ]; do
  case "$1" in
    --ts)  TS="${2:-}";        shift 2 ;;
    --log) LINEA_LOG="${2:-}"; shift 2 ;;
    *) morir "opcion desconocida: $1" ;;
  esac
done

[ -n "$LINEA_LOG" ] || morir "hace falta --log"

# Validar el formato antes de escribir nada: un cursor con basura es peor que uno viejo.
if [ -n "$TS" ]; then
  date -d "$TS" >/dev/null 2>&1 || morir "timestamp invalido: $TS"
fi

LOG="$BASE/logs/$(date +%F).txt"
mkdir -p "$BASE/logs"

exec 9>"$LOCK"
flock 9 || morir "no se pudo tomar el lock"

if [ -n "$TS" ]; then
  TMP="$(mktemp "$CURSOR.XXXXXX")"
  if [ -f "$CURSOR" ]; then
    if grep -q '^LAST_GINGER_TS=' "$CURSOR"; then
      # El valor puede traer barras, asi que se sustituye sin usar sed con /.
      awk -v ts="$TS" '/^LAST_GINGER_TS=/ {print "LAST_GINGER_TS=" ts; next} {print}' \
        "$CURSOR" > "$TMP"
    else
      { echo "LAST_GINGER_TS=$TS"; cat "$CURSOR"; } > "$TMP"
    fi
  else
    echo "LAST_GINGER_TS=$TS" > "$TMP"
  fi
  chmod 644 "$TMP"
  mv -f "$TMP" "$CURSOR"   # el rename es atomico: nadie ve el archivo a medio escribir
fi

printf '[%s] %s\n' "$(date +%H:%M)" "$LINEA_LOG" >> "$LOG"

flock -u 9
exec 9>&-

echo "registrado en $(basename "$LOG")${TS:+ — cursor en $TS}"
