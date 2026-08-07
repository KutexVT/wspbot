#!/usr/bin/env bash
# stickers.sh — que stickers se usan de verdad en el chat, ordenados por cuanto se repiten.
#
#   ./bin/stickers.sh              # los que aparecen 3 o mas veces
#   ./bin/stickers.sh 5            # los que aparecen 5 o mas veces
#   ./bin/stickers.sh 3 --md       # en formato de fila para pegar en el INDICE
#
# Al catalogo (media/stickers/INDICE.md) van SOLO los recurrentes, nunca todos: en un
# chat de 140 mil mensajes salen demasiados, y una tabla larga deja de servir para elegir
# — el bot la lee entera cada vez que quiere mandar uno.
#
# Se cuenta por NOMBRE DE ARCHIVO y no por message_id porque el nombre sale del hash del
# sticker (ver stickerFilename en whatsapp-bridge/main.go): el mismo sticker mandado
# veinte veces son veinte mensajes distintos pero un solo archivo.
#
# OJO: hasta el 2026-08-06 el bridge DESCARTABA los stickers entrantes, asi que la base
# arranco de cero ese dia. Las cuentas no valen nada hasta que hayan pasado varios dias
# de chat. No llenes el catalogo el primer dia.

set -uo pipefail
source "$(dirname "$(readlink -f "$0")")/comun.sh"

MINIMO="${1:-3}"
FORMATO="${2:-}"
case "$MINIMO" in
  ''|*[!0-9]*) morir "el minimo tiene que ser un numero: $MINIMO" ;;
esac

TOTAL="$(consulta "select count(*) from messages where media_type='sticker' and chat_jid='$JID';")"
DISTINTOS="$(consulta "select count(distinct filename) from messages where media_type='sticker' and chat_jid='$JID';")"

if [ "${TOTAL:-0}" -eq 0 ]; then
  echo "Todavia no hay ni un sticker en la base de este chat."
  echo "El soporte se activo el 2026-08-06; antes se descartaban. Dale unos dias."
  exit 0
fi

echo "$TOTAL stickers en el chat, $DISTINTOS distintos. Los que salen $MINIMO veces o mas:"
echo

FILAS="$(consulta "
  select
    count(*) as veces,
    filename,
    max(case when is_from_me = 0 then 'ella' else 'yo' end) as quien
  from messages
  where media_type = 'sticker' and chat_jid = '$JID' and coalesce(filename,'') <> ''
  group by filename
  having count(*) >= $MINIMO
  order by veces desc, filename;
")"

if [ -z "$FILAS" ]; then
  echo "(ninguno llega a $MINIMO todavia)"
  exit 0
fi

DIR_MEDIA="$BASE/whatsapp-mcp/whatsapp-bridge/store/$JID"

while IFS="$SEP" read -r veces arch quien; do
  [ -n "$arch" ] || continue
  clave="${arch%.webp}"
  desc="(sin describir — bajalo y miralo)"
  [ -s "$DESCRIPCIONES/$clave.txt" ] && desc="$(tr -d '\n' < "$DESCRIPCIONES/$clave.txt")"
  bajado=""
  [ -f "$DIR_MEDIA/$arch" ] || bajado="  [no descargado]"

  if [ "$FORMATO" = "--md" ]; then
    # Fila lista para pegar en el INDICE. La columna "cuando" se rellena a mano: eso es
    # criterio, no algo que se pueda sacar de un contador.
    printf '| `%s` | %s | _(a mano)_ | %s×, de %s |\n' "$arch" "$desc" "$veces" "$quien"
  else
    printf '%3s×  %-24s  %-5s %s%s\n' "$veces" "$arch" "$quien" "$desc" "$bajado"
  fi
done <<< "$FILAS"

if [ "$FORMATO" != "--md" ]; then
  echo
  echo "Para meterlos en el catalogo:  ./bin/stickers.sh $MINIMO --md"
  echo "Las rutas estan en: $DIR_MEDIA/"
fi
