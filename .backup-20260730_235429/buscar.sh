#!/usr/bin/env bash
# buscar.sh — busca un termino en TODA la memoria de la tulpa.
#
#   ./buscar.sh matcha
#   ./buscar.sh "tipo de sangre"
#   ./buscar.sh alnst
#
# Ignora mayusculas y acentos: "musica" encuentra "música", "cumpleanos" encuentra
# "cumpleaños". Busca en orden de vigencia: primero lo que rige ahora, al final el
# historial crudo. Cada resultado sale como  archivo:linea: texto original.

set -uo pipefail

BASE="/home/kutex/WSP Bot"
CLAUDE_MEM="/home/kutex/.claude/projects/-home-kutex/memory"

if [ $# -eq 0 ]; then
  echo "uso: buscar.sh <termino>" >&2
  exit 1
fi
PATRON="$*"

# Quita acentos de un texto para que la busqueda no dependa de ellos.
sin_acentos() {
  sed 'y/áéíóúüñÁÉÍÓÚÜÑ/aeiouunAEIOUUN/'
}
PATRON_N="$(printf '%s' "$PATRON" | sin_acentos)"

total=0

# Busca en un archivo comparando sin acentos, pero imprimiendo la linea original.
buscar_en() {
  local archivo="$1"
  [ -f "$archivo" ] || return 0
  local lineas
  lineas="$(sin_acentos < "$archivo" | grep -in -- "$PATRON_N" | cut -d: -f1)"
  [ -n "$lineas" ] || return 0
  local n
  while read -r n; do
    [ -n "$n" ] || continue
    printf '%s:%s: %s\n' "${archivo#$BASE/}" "$n" "$(sed -n "${n}p" "$archivo" | sed 's/^[[:space:]]*//')"
    total=$((total + 1))
  done <<< "$lineas"
}

seccion() {
  local titulo="$1"; shift
  local salida=""
  for f in "$@"; do
    salida+="$(buscar_en "$f")"$'\n'
  done
  salida="$(printf '%s' "$salida" | grep -v '^$' || true)"
  [ -n "$salida" ] || return 0
  printf '\n=== %s ===\n%s\n' "$titulo" "$salida"
}

echo "buscando: $PATRON"

# 1. Lo que rige ahora mismo.
seccion "VIGENTE (nucleo)" "$BASE/nucleo/siempre.md" "$BASE/nucleo/cursor.txt"
seccion "VIGENTE (memoria actual)" "$BASE"/memoria/actual/*.md

# 2. Memoria permanente curada por Mikel.
seccion "PERMANENTE (memoria de Claude)" "$CLAUDE_MEM/ginger_novia.md" "$CLAUDE_MEM/user_messaging_style.md"

# 3. Historial semanal, de la semana mas reciente hacia atras.
mapfile -t semanas < <(ls -1r "$BASE"/memoria/semanas/*.md 2>/dev/null || true)
[ ${#semanas[@]} -gt 0 ] && seccion "SEMANAS (reciente → antiguo)" "${semanas[@]}"

# 4. Transcripciones crudas: la fuente de verdad, pero la mas ruidosa.
mapfile -t chats < <(ls -1r "$BASE"/chats/*.md 2>/dev/null | grep -v FORMATO || true)
[ ${#chats[@]} -gt 0 ] && seccion "CHATS (reciente → antiguo)" "${chats[@]}"

# 5. Notas de voz transcritas. El nombre del archivo es el message_id, que sirve para
#    volver a bajar el audio original con download_media si hiciera falta.
mapfile -t audios < <(ls -1t "$BASE"/media/transcripciones/*.txt 2>/dev/null || true)
[ ${#audios[@]} -gt 0 ] && seccion "AUDIOS TRANSCRITOS (reciente → antiguo)" "${audios[@]}"

# 6. Auditoria del bot. Solo si se busca que hizo el, no que dijo ella.
mapfile -t logs < <(ls -1r "$BASE"/logs/*.txt 2>/dev/null || true)
[ ${#logs[@]} -gt 0 ] && seccion "LOGS (reciente → antiguo)" "${logs[@]}"

echo
echo "--- fin. si no aparecio nada, proba con una palabra mas corta o la raiz del termino ---"
