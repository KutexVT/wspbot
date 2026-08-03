# INDICE DE MEMORIA — que existe y CUANDO abrirlo

Este archivo y `nucleo/` son lo unico que se lee siempre. Todo lo demas se abre
**solo si la columna "abrilo cuando" aplica al mensaje que tengo enfrente**.

Abrir un archivo que no hacia falta no es gratis: cuesta tiempo y contexto, y
enterra lo importante entre ruido. Ante la duda, NO lo abras.

---

## Se lee SIEMPRE (obligatorio, en este orden)

| Que | Cuando |
|---|---|
| `bin/pulso.sh` | **Lo primero de todo.** Dice si hay algo que hacer y trae el cursor y los mensajes nuevos ya resueltos. Si contesta `ESTADO: NADA`, la iteracion termina ahi y **no se lee nada mas**. |
| `nucleo/siempre.md` | Solo si hay algo que hacer. Lo que se da por sabido en cualquier mensaje: identidad, limites, reglas de oro. |

`nucleo/cursor.txt` ya no se lee a mano: lo lee `pulso.sh` y lo escribe `registrar.sh`.

## Se lee BAJO DEMANDA

| Archivo | Abrilo cuando | Que hay adentro |
|---|---|---|
| `memoria/actual/bromas_vivas.md` | Ella retoma un chiste, o quiero tirar uno y necesito saber si sigue vivo | Cada broma con su estado: viva, en pausa o quemada. Como se contesta cada una. |
| `memoria/actual/hilos.md` | Hay silencio y voy a sacar tema, o menciona una serie/musica/juego | Conversaciones abiertas: que quedo a medias y donde se retoma. |
| `memoria/actual/pendientes.md` | Menciona un plan, una hora, un "mañana", o me reclama algo prometido | Promesas y planes con fecha. Lo que se cumplio se marca, no se borra. |
| `memoria/actual/momentos.md` | Se pone sensible, nostalgica, o referencia algo emocional del pasado | Conversaciones que pesaron: peleas, momentos tiernos, fechas que importan. |
| `memoria/semanas/YYYY-Www.md` | Referencia algo de hace semanas, o `actual/` se quedo corto | Bitacora congelada de cada semana. Nunca se borra ni se reescribe. |
| `chats/YYYY-MM-DD.md` | Pregunta por algo que se hablo antes y no esta en ningun otro lado | Transcripcion completa del dia, con quien dijo que. Es la fuente de verdad. |

### La diferencia entre `actual/` y `semanas/`

- `memoria/actual/` es **el presente**: chico, se edita, dice como estan las cosas HOY.
  Al enfriarse algo, sale de aqui.
- `memoria/semanas/` es **el pasado**: un archivo por semana ISO, solo se añade, y al
  cerrar la semana queda congelado. **Nada se borra jamas.** Lo que sale de `actual/`
  no se pierde: ya quedo escrito en la semana en que ocurrio.

Sacar algo de `actual/` no es borrarlo. Es dejar de cargarlo todos los dias.

## Memoria permanente (fuera de esta carpeta)

Vive en `/home/kutex/.claude/projects/-home-kutex/memory/`. Es lo que Mikel cura a
mano y sobrevive al bot. **Nunca se lee entero**: se abre la seccion que hace falta.

**Donde escribo yo, en los dos archivos:** solo al final, bajo `## Aprendido en
automatico`. Lo nuevo sobre ella (una comida que le gusta, un apodo, una fecha) va a esa
seccion de `ginger_novia.md`; lo nuevo sobre como escribe Mikel, a la de
`user_messaging_style.md`. **Nunca dentro de las secciones de arriba**: esas son suyas.
Asi se ve de un vistazo que escribio el y que escribi yo, y si alguna vez meto la pata se
limpia mi zona sin tocar la suya.

| Archivo | Abrilo cuando |
|---|---|
| `user_messaging_style.md` | **SIEMPRE, antes de escribir. No es bajo demanda.** Es como escribe Mikel de verdad; el estilo no se saca de memoria ni "a ojo". Su seccion "reglas de naturalidad" manda sobre todo lo demas, incluido el PROMPT. |
| `ginger_novia.md` | Necesito un dato duro sobre ella. **Leer solo la seccion que aplica** (ver abajo) — salvo que este buscando algo que no aparece, ahi se lee entero. **Es tambien donde se guarda todo dato nuevo que dure para siempre.** |

Secciones de `ginger_novia.md`, para abrir solo la que toca:

`Datos basicos` · `Personalidad y forma de ser` · `Gustos — Comida y bebida` ·
`Gustos — Entretenimiento` · `Gustos — Musica` · `Gustos — Estetica y moda` ·
`Gustos — Hobbies y actividades` · `Gustos — Naturaleza, viajes y ambiente` ·
`Redes sociales y tecnologia` · `Relacion con el usuario` · `Jerga y forma de hablar` ·
`Chistes internos y bromas recurrentes` · `Familia y entorno` · `Historial de relaciones` ·
`Salud y bienestar` · `Educacion` · `Creencias y supersticiones` ·
`Detalles pequenos que valen oro` · `Manual practico — que funciona con ella` ·
`Aprendido en automatico`

Como leer una sola seccion sin cargar las 324 lineas:

    awk '/^## Salud y bienestar/,/^## /' "/home/kutex/.claude/projects/-home-kutex/memory/ginger_novia.md"

## Cuando no encuentro algo: BUSCAR EN TODA LA MEMORIA

Si hace falta un dato y no aparece donde deberia estar, **no lo inventes ni digas
que no sabes todavia**. Buscalo primero:

    "/home/kutex/WSP Bot/buscar.sh" alnst
    "/home/kutex/WSP Bot/buscar.sh" "tipo de sangre"

Barre todo: nucleo, memoria actual, las semanas viejas, la memoria permanente de
Claude, las transcripciones, los logs y **el chat entero desde la base** (los 130 mil
mensajes de siempre, no solo los dias con el bot encendido). Ignora mayusculas y
acentos (`musica` encuentra `música`), y devuelve `archivo:linea: texto`, ordenado de
lo mas vigente a lo mas antiguo.

Con ese resultado, abri **solo** el archivo donde aparecio, y solo esas lineas.
El punto de buscar es no tener que leer todo.

Si la busqueda no devuelve nada, **no te rindas todavia** (la escalera completa esta en
el PASO 3 del PROMPT):
  1. Proba con la raiz de la palabra o una forma mas corta (`cumple`, no `cumpleaños`).
  2. Proba como lo escribiria ELLA (`iwal`, `weño`, `ño`).
  3. Abri `ginger_novia.md` **entero**. Cuando estas buscando un dato que no aparece,
     leer de menos deja de ser una virtud: puede estar en una seccion impensada.
  4. Revisa el chat completo por fecha, directo en la base, si sabes mas o menos cuando
     se dijo pero no con que palabras.
  5. Recien ahi, decilo de frente: no sabes. Inventarlo es peor que no saberlo.

## Solo escritura (nunca hace falta leerlos para responder)

| Archivo | Que es |
|---|---|
| `logs/YYYY-MM-DD.txt` | Auditoria: que hice y por que, una linea por iteracion. Para que Mikel revise. |
| `archivo/` | Sistema viejo, ya no se usa. No leer. |

## Herramientas

| Archivo | Para que |
|---|---|
| `bin/pulso.sh` | **Lo primero de cada iteracion.** Dice si hay algo que hacer y muestra los mensajes nuevos, todo en una llamada. Si contesta `ESTADO: NADA`, la vuelta termina ahi. |
| `bin/registrar.sh` | **Lo ultimo de cada iteracion.** Mueve el cursor y escribe el log de una sola vez, bajo lock. |
| `bin/transcribir.sh` | Genera `chats/YYYY-MM-DD.md` desde la base. Ver `chats/FORMATO.md`. |
| `buscar.sh` | Busca un termino en toda la memoria. Ver la seccion de arriba. |
| `bin/oir.sh` | Transcribe una nota de voz: `bin/oir.sh <ruta.ogg> <message_id>`. Ver PASO 1 del PROMPT. |
| `media/transcripciones/` | Cache de audios ya transcritos, uno por message_id. No se lee a mano: lo usa `oir.sh` para no repetir trabajo. `buscar.sh` ya los barre, asi que un audio viejo se puede encontrar por lo que ella dijo en el. |
| `media/descripciones/` | Lo mismo para fotos: que se ve, en una linea, por message_id. Lo escribe la tulpa al ver una foto; `transcribir.sh` lo inyecta en la transcripcion del dia. |
| `bin/comun.sh` | Rutas y helpers compartidos por los tres scripts de arriba. No se ejecuta solo. |
| `bin/models/` | El modelo de whisper (`small`). No tocar. |

### La base de mensajes

La unica base valida es:

    /home/kutex/WSP Bot/whatsapp-mcp/whatsapp-bridge/store/messages.db

El bridge la crea **relativa al directorio desde donde se lanza**, asi que arrancarlo
desde otro lado genera una base vacia en paralelo y el historial se parte en dos (ya
paso: quedo una huerfana en `/home/kutex/store/`). Se lanza siempre con el alias:

    wspbot

---

## Donde va cada cosa que aprendo

Antes de guardar algo, la pregunta es **cuanto va a durar**:

- **Dura para siempre y es sobre ELLA** (tipo de sangre, alergias, familia, un gusto
  confirmado) → `ginger_novia.md`, en su seccion. Es memoria permanente de Claude.
- **Dura para siempre y es sobre COMO ESCRIBE MIKEL** → `user_messaging_style.md`.
- **Esta vivo ahora pero se va a enfriar** (un chiste de esta semana, una serie que
  esta viendo, un plan del viernes) → `memoria/actual/` **y** una linea en la bitacora
  de la semana en curso, `memoria/semanas/YYYY-Www.md`.
- **Hay que saberlo en cada mensaje** (como me llama, que no puedo hacer) → `nucleo/siempre.md`.
- **Solo importa hoy** ("ando cansada", "ya cene") → a ningun lado. Se responde y se olvida.

Regla que no se rompe: un dato vive en **un solo** archivo. Si ya esta en
`ginger_novia.md`, no se copia a `memoria/actual/` — se referencia.
La bitacora semanal es la unica excepcion: ahi va **todo** lo que se aprendio esa
semana, aunque el dato tambien viva en otro lado, porque es el registro historico.

## Cierre de semana

Cuando la fecha de hoy cae en una semana ISO distinta a la del ultimo archivo de
`memoria/semanas/`:

1. Crear `memoria/semanas/YYYY-Www.md` nuevo con su encabezado de fechas.
2. **No tocar el anterior nunca mas.** Queda congelado.
3. Repasar `memoria/actual/` y bajar lo que se enfrio: bromas en PAUSA hace mas de
   2 semanas, hilos sin movimiento hace 2 semanas, pendientes ya CUMPLIDOS.
   "Bajar" = quitarlo de `actual/`, porque ya esta escrito en su semana.
4. `pendientes.md` es la excepcion: **lo PENDIENTE nunca se baja**, por viejo que sea.
   Una promesa sin cumplir sigue viva hasta que se cumple o se cae.

Semana ISO: `date +%G-W%V`.
