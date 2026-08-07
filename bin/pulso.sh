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
#   NADA          — sin mensajes nuevos y sin silencio suficiente. Se corta aqui.
#   NUEVOS        — hay mensajes de Ginger sin responder. Aplican las reglas 2 o 3.
#   REVISAR       — no hay de ella sin responder, pero hay algo que mirar: mensajes
#                   nuevos de Mikel (regla 6) o silencio largo (reglas 4 o 5).
#   BRIDGE_CAIDO  — el bridge no responde. La base esta congelada y todo lo que se
#                   pudiera decir aqui seria mentira. Se corta sin mirar nada mas.

set -uo pipefail
source "$(dirname "$(readlink -f "$0")")/comun.sh"

# Minutos de silencio a partir de los cuales vale la pena plantearse sacar tema (regla 4).
UMBRAL_SILENCIO="${WSP_UMBRAL_SILENCIO:-30}"

# Tope de mensajes nuevos a mostrar. Si el cursor quedo muy atras (el bot estuvo apagado
# un dia), sin tope esto escupe miles de lineas y entierra la iteracion.
#
# Truncar ya no pierde nada: lo de ELLA que se caiga por aqui sigue saliendo en la
# seccion de pendientes hasta que se responda, porque esa se calcula contra el cursor de
# Ginger y no contra el de "ya mire".
TOPE="${WSP_TOPE:-40}"

# Tope de la seccion de pendientes. Se ordena de mas viejo a mas nuevo a proposito: si
# hay que cortar, se corta por el final, que es lo que ya se vio hace un momento.
TOPE_PEND="${WSP_TOPE_PEND:-60}"

# Arranque en frio: cuantos mensajes de contexto leer la primera vuelta de cada encendido,
# y a partir de cuantos minutos sin correr se considera que el bot se acaba de prender.
CONTEXTO_FRIO="${WSP_CONTEXTO_FRIO:-100}"
FRIO_MIN="${WSP_FRIO_MIN:-10}"
MARCA_VUELTA="$BASE/nucleo/.ultima_vuelta"

# Cada cuanto se repite el aviso de escritorio con el bridge caido. Avisar cada minuto
# seria inusable: mako deja las criticas fijas hasta que se cierran a mano.
AVISO_CADA_MIN="${WSP_AVISO_CADA_MIN:-15}"
MARCA_AVISO="$BASE/nucleo/.aviso_bridge"

# ---------------------------------------------------------------------------
# SALUD DEL BRIDGE — antes que ninguna otra cosa
# ---------------------------------------------------------------------------
# Se pregunta al bridge por su endpoint y no por la base, porque la base no sabe
# distinguir "no ha escrito nadie" de "no me estan llegando los mensajes". De noche hay
# huecos legitimos de horas en los que no escribe nadie en ninguno de los 931 chats: con
# un umbral de frescura, el bot daria por caido el bridge todas las madrugadas.
#
# Tampoco basta con que el puerto este abierto: el proceso puede estar vivo, escuchando y
# desconectado de WhatsApp. Es justo lo que pasa despues de un "replaced stream", cuando
# otro cliente se lleva la sesion.
#
# -m 2 no es opcional: sin timeout, un puerto que acepta la conexion y no contesta cuelga
# la vuelta entera.
#
# El 404 NO es un fallo, es el binario viejo — el que no tiene /api/health todavia pero
# esta vivo y sirviendo. Asi este script se puede desplegar antes de recompilar el Go.
salud_bridge() {
  local resp cod cuerpo
  resp="$(curl -s -m 2 -w $'\n%{http_code}' "$SALUD_URL" 2>/dev/null)"
  cod="${resp##*$'\n'}"
  cuerpo="${resp%$'\n'*}"
  case "$cod" in
    200)
      case "$cuerpo" in
        *'"logged_in":false'*) echo "CAIDO la sesion esta cerrada: hay que reescanear el QR (reiniciar no sirve)" ;;
        *'"connected":false'*) echo "CAIDO el bridge corre pero esta desconectado de WhatsApp" ;;
        *)                     echo "VIVO" ;;
      esac ;;
    404)    echo "VIVO" ;;
    000|"") echo "CAIDO el puerto 8080 no responde: el bridge no esta corriendo" ;;
    *)      echo "CAIDO el bridge contesta HTTP $cod" ;;
  esac
}

SALUD="$(salud_bridge)"

if [ "${SALUD%% *}" = "CAIDO" ]; then
  MOTIVO="${SALUD#CAIDO }"

  # Sin systemd detras, nadie va a levantar el bridge solo. El aviso lo manda el script y
  # no el modelo, para que salga aunque la vuelta se muera despues de esta linea.
  avisar=1
  if [ -f "$MARCA_AVISO" ]; then
    edad=$(( ( $(date +%s) - $(stat -c %Y "$MARCA_AVISO" 2>/dev/null || echo 0) ) / 60 ))
    [ "$edad" -lt "$AVISO_CADA_MIN" ] && avisar=0
  fi
  if [ "$avisar" -eq 1 ] && command -v notify-send >/dev/null 2>&1; then
    notify-send -u critical "WSP Bot — bridge caido" \
      "$MOTIVO"$'\n''Levantalo con:  wspbot' 2>/dev/null
    touch "$MARCA_AVISO"
  fi

  # Corte seco. Con el bridge caido la base esta congelada y TODO lo que diria este
  # script es mentira: "no hay mensajes nuevos" no es un hecho, es que no llegan. Es el
  # fallo que mas veces se repitio en este sistema (transcripciones a medias, dias
  # procesados incompletos), y hasta ahora salia en el log como "NO HICE NADA".
  #
  # Aqui NO se toca la marca de vuelta ni se escribe el traspaso, a proposito:
  #   - sin tocar la marca, al volver el bridge la vuelta cuenta como ARRANQUE FRIO y se
  #     vuelca el contexto que se perdio mientras tanto;
  #   - sin traspaso, aunque el modelo llame a registrar.sh, los cursores no se mueven.
  # La proteccion es estructural y no una regla que se pueda olvidar.
  echo "ESTADO: BRIDGE_CAIDO"
  echo "MOTIVO: $MOTIVO"
  echo "ULTIMO_EN_LA_BASE: $(consulta "select max($TS_SQL) from messages;")"
  echo "REGLAS: ninguna. No escribas al chat, no muevas cursores, no transcribas."
  exit 0
fi

rm -f "$MARCA_AVISO"

# ---------------------------------------------------------------------------
# ARRANQUE — solo se llega aqui con el bridge vivo
# ---------------------------------------------------------------------------
ARRANQUE="CALIENTE"
if [ ! -f "$MARCA_VUELTA" ]; then
  ARRANQUE="FRIO"
else
  edad_min=$(( ( $(date +%s) - $(stat -c %Y "$MARCA_VUELTA" 2>/dev/null || echo 0) ) / 60 ))
  [ "$edad_min" -ge "$FRIO_MIN" ] && ARRANQUE="FRIO"
fi
touch "$MARCA_VUELTA"

LAST_VISTO="$(leer_visto)"
LAST_GINGER="$(leer_cursor LAST_GINGER_TS)"
[ -n "$LAST_GINGER" ] || LAST_GINGER="1970-01-01 00:00:00"

ESC_VISTO="${LAST_VISTO//\'/\'\'}"
ESC_GINGER="${LAST_GINGER//\'/\'\'}"

# --- VENTANA 1: lo que entro desde la ultima vuelta ---
# Como LAST_VISTO_TS avanza siempre, en la vuelta normal esto son media docena de lineas
# y no un backlog que crece solo.
TOTAL_NUEVOS="$(consulta "
  select count(*) from messages
  where chat_jid = '$JID' and $TS_SQL > '$ESC_VISTO';
")"

# Se piden los ultimos TOPE y se reordenan ascendente, para quedarse con los mas
# recientes cuando el cursor viene muy atrasado.
FILAS="$(consulta "
  select * from (
    select
      $TS_SQL as ts,
      $ROL_SQL as rol,
      coalesce(media_type,'') as media,
      coalesce(id,'') as mid,
      coalesce(filename,'') as arch,
      replace(replace(coalesce(content,''), char(10), ' '), char(9), ' ') as texto
    from messages
    where chat_jid = '$JID' and $TS_SQL > '$ESC_VISTO'
    order by timestamp desc limit $TOPE
  ) order by ts asc;
")"

# --- VENTANA 2: lo de ELLA que sigue sin responder de vueltas anteriores ---
# Esta es la red de seguridad del sistema entero. Mientras el cursor de Ginger no los
# pase, sus mensajes siguen saliendo aqui aunque la ventana 1 ya haya avanzado por
# encima. Es lo que impide que un mensaje suyo desaparezca en silencio, que es lo que
# pasaba cuando el unico cursor se quedaba clavado y el TOPE se comia lo viejo.
#
# Sale con las mismas columnas que la ventana 1 (el rol es siempre GINGER, pero va igual)
# para que las dos se pinten con la misma funcion y no haya dos formatos que cuadrar.
PENDIENTES="$(consulta "
  select
    $TS_SQL as ts,
    'GINGER' as rol,
    coalesce(media_type,'') as media,
    coalesce(id,'') as mid,
    coalesce(filename,'') as arch,
    replace(replace(coalesce(content,''), char(10), ' '), char(9), ' ') as texto
  from messages
  where chat_jid = '$JID' and is_from_me = 0
    and $TS_SQL > '$ESC_GINGER' and $TS_SQL <= '$ESC_VISTO'
  order by ts asc limit $TOPE_PEND;
")"

# --- estado general del chat, haya o no mensajes nuevos ---
ULTIMO="$(consulta "
  select $TS_SQL, $ROL_SQL
  from messages where chat_jid = '$JID' order by timestamp desc limit 1;
")"
ULTIMO_TS="${ULTIMO%%${SEP}*}"
ULTIMO_ROL="${ULTIMO##*${SEP}}"

SILENCIO_MIN=0
if [ -n "$ULTIMO_TS" ]; then
  ahora=$(date +%s)
  ult="$(a_segundos "$ULTIMO_TS")"
  [ "$ult" -eq 0 ] && ult=$ahora
  SILENCIO_MIN=$(( (ahora - ult) / 60 ))
fi

hay_ginger=0
hay_mikel=0
if [ -n "$FILAS" ]; then
  grep -q "${SEP}GINGER${SEP}" <<< "$FILAS" && hay_ginger=1
  grep -q "${SEP}MIKEL${SEP}"  <<< "$FILAS" && hay_mikel=1
fi

hay_pendientes=0
n_pend=0
if [ -n "$PENDIENTES" ]; then
  hay_pendientes=1
  n_pend="$(grep -c . <<< "$PENDIENTES")"
fi

# Ultimo mensaje MIO en el chat. Si es posterior a todo lo pendiente, esos pendientes ya
# estan contestados y lo unico que quedo sin hacer fue mover el cursor. Decirlo evita que
# el modelo los responda dos veces, que es el riesgo que trae volver a mostrarlos.
YA_CONTESTADOS=0
if [ "$hay_pendientes" -eq 1 ]; then
  ULT_PEND_TS="$(tail -1 <<< "$PENDIENTES" | cut -d"$SEP" -f1)"
  ULT_TULPA_TS="$(consulta "
    select $TS_SQL from messages
    where chat_jid = '$JID' and sender = '$SENDER_TULPA'
    order by timestamp desc limit 1;
  ")"
  if [ -n "$ULT_TULPA_TS" ] && \
     [ "$(a_segundos "$ULT_TULPA_TS")" -gt "$(a_segundos "$ULT_PEND_TS")" ]; then
    YA_CONTESTADOS=1
  fi
fi

# NUEVOS  → hay algo suyo sin responder, sea recien llegado o de antes.
# REVISAR → escribio Mikel, hay silencio, o quedaron pendientes que YA tienen respuesta
#           mia posterior: ahi no se escribe, se pone al dia el cursor y ya.
if [ "$hay_ginger" -eq 1 ] || { [ "$hay_pendientes" -eq 1 ] && [ "$YA_CONTESTADOS" -eq 0 ]; }; then
  ESTADO="NUEVOS"
elif [ "$hay_mikel" -eq 1 ] || [ "$hay_pendientes" -eq 1 ] || [ "$SILENCIO_MIN" -ge "$UMBRAL_SILENCIO" ]; then
  ESTADO="REVISAR"
else
  ESTADO="NADA"
fi

# --- traspaso a registrar.sh ---
# Va el timestamp del ultimo mensaje que este pulso ALCANZO A IMPRIMIR, nunca el ultimo
# de la base: lo que entre despues de las consultas de arriba no lo vio el modelo y tiene
# que volver a salir en la vuelta siguiente.
#
# Con ESTADO NADA las filas no se imprimen, pero el cursor avanza igual: NADA solo puede
# darse cuando lo unico nuevo son mensajes mios, y esos no hace falta enseñarlos.
VISTO_NUEVO="$LAST_VISTO"
[ -n "$FILAS" ] && VISTO_NUEVO="$(tail -1 <<< "$FILAS" | cut -d"$SEP" -f1)"

# Y el ultimo mensaje DE ELLA que se mostro, que es lo que vale `--ts visto`. Si hay
# suyos en la ventana nueva manda el ultimo de esos; si no, el ultimo de los pendientes.
VISTO_GINGER=""
if [ "$hay_ginger" -eq 1 ]; then
  VISTO_GINGER="$(grep "${SEP}GINGER${SEP}" <<< "$FILAS" | tail -1 | cut -d"$SEP" -f1)"
elif [ "$hay_pendientes" -eq 1 ]; then
  VISTO_GINGER="$(tail -1 <<< "$PENDIENTES" | cut -d"$SEP" -f1)"
fi

TMP_T="$(mktemp "$TRASPASO.XXXXXX")"
{
  echo "VISTO=$VISTO_NUEVO"
  echo "VISTO_GINGER=$VISTO_GINGER"
} > "$TMP_T"
chmod 644 "$TMP_T"
mv -f "$TMP_T" "$TRASPASO"

# ---------------------------------------------------------------------------
# SALIDA
# ---------------------------------------------------------------------------
echo "ESTADO: $ESTADO"
echo "ARRANQUE: $ARRANQUE"
echo "BRIDGE: vivo"
echo "LAST_GINGER_TS: $LAST_GINGER"
echo "LAST_VISTO_TS: $LAST_VISTO"
echo "ULTIMO_EN_EL_CHAT: ${ULTIMO_ROL:-ninguno} (${ULTIMO_TS:-sin mensajes})"
echo "SILENCIO_MIN: $SILENCIO_MIN"

# Solo mientras la funcion sea nueva. En cuanto se estrene, la marca existe y esta linea
# no vuelve a salir nunca.
if [ ! -f "$BASE/nucleo/ESTRENO_STICKERS_HECHO" ] && [ "$ESTADO" != "NADA" ]; then
  echo "ESTRENO_STICKERS: pendiente (ver PASO 4)"
fi

# Pinta una tanda de filas del formato ts|rol|media|id|filename|texto, resolviendo la
# media contra la cache. Las dos ventanas salen con las mismas columnas para poder usar
# esto en las dos sin traducir nada.
pintar_filas() {
  local ts rol media id arch texto hora cache clave
  while IFS="$SEP" read -r ts rol media id arch texto; do
    [ -n "$ts" ] || continue
    hora="${ts:11:8}"
    if [ -n "$media" ]; then
      # La media se anuncia con su id para poder bajarla; el contenido se resuelve
      # despues (PASO 1), y si ya se resolvio antes se muestra cacheado.
      #
      # Los stickers se cachean por NOMBRE DE ARCHIVO y no por message_id: el nombre sale
      # del hash del sticker, asi que el mismo sticker mandado veinte veces se describe
      # una sola vez y las otras diecinueve salen de aqui gratis.
      clave="$id"
      [ "$media" = "sticker" ] && [ -n "$arch" ] && clave="${arch%.webp}"
      cache=""
      [ -s "$TRANSCRIPCIONES/$clave.txt" ] && cache="$(head -c 300 "$TRANSCRIPCIONES/$clave.txt")"
      [ -s "$DESCRIPCIONES/$clave.txt" ]   && cache="$(head -c 300 "$DESCRIPCIONES/$clave.txt")"
      if [ -n "$cache" ]; then
        echo "[$hora] $rol: <$media ya resuelto: $cache>"
      else
        echo "[$hora] $rol: <$media PENDIENTE - Message ID: $id>"
      fi
    else
      echo "[$hora] $rol: $texto"
    fi
  done
}

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
        $TS_SQL, $ROL_SQL,
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
  echo "REGLAS: 1 o 5 — nada suyo sin responder y el silencio no llega a $UMBRAL_SILENCIO min. No escribas."
  exit 0
fi

# --- que reglas estan en juego ---
if [ "$hay_ginger" -eq 1 ] || { [ "$hay_pendientes" -eq 1 ] && [ "$YA_CONTESTADOS" -eq 0 ]; }; then
  echo "REGLAS: 2 o 3 — hay mensajes suyos sin responder. Decidi vos si el ultimo es una despedida."
elif [ "$hay_pendientes" -eq 1 ]; then
  echo "REGLAS: ninguna — los pendientes de abajo ya tienen respuesta tuya. Solo hay que poner el cursor al dia."
elif [ "$hay_mikel" -eq 1 ]; then
  echo "REGLAS: 6 — solo escribio Mikel. Meterte es opcional; no le pises una disculpa ni un tema suyo."
else
  echo "REGLAS: 4 o 5 — $SILENCIO_MIN min de silencio. Sacar tema solo si no hubo despedida."
fi

if [ "$hay_pendientes" -eq 1 ]; then
  echo "--- DE ELLA, SIN RESPONDER DE ANTES ($n_pend) ---"
  if [ "$YA_CONTESTADOS" -eq 1 ]; then
    echo "(OJO: hay respuesta tuya posterior a estos. Ya los atendiste y solo falto mover"
    echo " el cursor: cierra con --ts visto y NO los vuelvas a responder.)"
  else
    echo "(ya se mostraron en vueltas anteriores y el cursor no los paso. Siguen sin respuesta.)"
  fi
  pintar_filas <<< "$PENDIENTES"
fi

echo "--- NUEVO DESDE LA ULTIMA VUELTA ---"
if [ "${TOTAL_NUEVOS:-0}" -gt "$TOPE" ]; then
  echo "(entraron $TOTAL_NUEVOS; se muestran los $TOPE mas recientes. Lo suyo que se caiga"
  echo " por el tope vuelve a salir arriba mientras siga sin responder.)"
fi
if [ -z "$FILAS" ]; then
  echo "(ninguno)"
else
  pintar_filas con_rol <<< "$FILAS"
fi
echo "--- FIN ---"
