#!/usr/bin/env bash
# comun.sh — rutas y helpers que comparten pulso.sh, registrar.sh y transcribir.sh.
# No se ejecuta solo: se hace `source` desde los otros scripts.

BASE="/home/kutex/WSP Bot"
DB="$BASE/whatsapp-mcp/whatsapp-bridge/store/messages.db"
JID="${WSP_JID:-237799840162013@lid}"
CURSOR="$BASE/nucleo/cursor.txt"
LOCK="$BASE/nucleo/.lock"
TRANSCRIPCIONES="$BASE/media/transcripciones"
DESCRIPCIONES="$BASE/media/descripciones"

# Marca de agua del bot en la base. El bridge guarda con este sender los mensajes que
# se envian por la API, que es lo que separa a la TULPA del MIKEL real sin depender de
# comparar textos. Ver whatsapp-bridge/main.go, handler /api/send.
SENDER_TULPA="__tulpa__"

# Los timestamps de la base son TEXT con offset fijo de Costa Rica
# ("2026-07-29 20:49:16-06:00"). substr(...,1,19) los deja en la misma forma que usa el
# cursor y ya vienen en hora local: NO se convierten ni se les resta nada.
TS_SQL="substr(timestamp,1,19)"

morir() { echo "ERROR: $*" >&2; exit 1; }

[ -f "$DB" ] || morir "no existe la base: $DB"
command -v sqlite3 >/dev/null 2>&1 || morir "falta sqlite3"

# Lee un campo del cursor. Uso: leer_cursor LAST_GINGER_TS
leer_cursor() {
  local clave="$1"
  [ -f "$CURSOR" ] || return 0
  sed -n "s/^${clave}=//p" "$CURSOR" | head -1
}

# Separador de campos para las consultas. Tiene que ser un caracter que NO sea espacio
# en blanco: con IFS de tabulador, `read` colapsa los tabs seguidos y un campo vacio en
# medio (media_type, por ejemplo) corre todas las columnas siguientes. \x1f no aparece
# nunca en un chat.
SEP=$'\x1f'

# Consulta a la base, con separador de campo explicito.
consulta() {
  sqlite3 -separator "$SEP" "$DB" "$1"
}
