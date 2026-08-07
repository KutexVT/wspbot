Pase de memoria de la tulpa. Se corre UNA vez al dia, con el chat del dia ya cerrado.
No responde mensajes ni escribe a nadie: solo lee y ordena lo aprendido.

BASE: /home/kutex/WSP Bot/

Por que existe: esto antes corria en cada iteracion, 1440 veces al dia, mirando una
ventana de 40 mensajes. Asi es imposible cumplir el criterio de "lo vi 2+ veces", que es
justo lo que separa un patron de una casualidad. Con el dia entero delante si se puede.

===============================================================================
PASO 0 — MATERIAL
===============================================================================
0. ANTES DE NADA: "/home/kutex/WSP Bot/bin/pulso.sh"

   Si dice BRIDGE_CAIDO, el dia esta INCOMPLETO en la base y una transcripcion a medias
   no se nota mirandola: parece un dia entero que simplemente tuvo poca conversacion. NO
   hagas el pase. Cierra con
     "/home/kutex/WSP Bot/bin/registrar.sh" --log "PASE ABORTADO — bridge caido"
   y salite. El pase se hace UNA vez y lo que no se leyo ese dia no se vuelve a mirar:
   ya paso tres veces (27, 28 y 29 de julio quedaron con dias parciales o vacios).

1. Genera y lee la transcripcion completa del dia:

     "/home/kutex/WSP Bot/bin/transcribir.sh" <YYYY-MM-DD>

   Los roles ya vienen separados: GINGER, MIKEL (el real) y TULPA (yo).

2. Lee el estado vigente, para no duplicar lo que ya esta escrito:
     memoria/actual/bromas_vivas.md · hilos.md · pendientes.md · momentos.md

===============================================================================
PASO 1 — CIERRE DE SEMANA (solo si toca)
===============================================================================
Si hoy cae en una semana ISO distinta a la del ultimo archivo de memoria/semanas/
(`date +%G-W%V`), antes de escribir nada:

  1. Crea memoria/semanas/YYYY-Www.md nuevo, con el rango de fechas en el encabezado
     (lunes a domingo). El anterior NO se toca nunca mas: queda congelado.
  2. Repasa memoria/actual/ y baja lo que se enfrio: bromas en PAUSA hace 2+ semanas,
     hilos sin movimiento hace 2 semanas, pendientes ya CUMPLIDOS. Bajar = quitarlo de
     actual/, NO borrarlo: ya quedo escrito en la semana en que ocurrio.
  3. EXCEPCION: lo que sigue PENDIENTE nunca se baja, por viejo que sea. Una promesa
     sin cumplir sigue viva hasta que se cumple o se cae.
  4. Anotalo en el log: CIERRE DE SEMANA — abro 2026-W32, baje 2 hilos frios

===============================================================================
PASO 2 — QUE APRENDI HOY
===============================================================================
Antes de guardar cualquier cosa, preguntate CUANTO VA A DURAR. Ese es el unico criterio
para elegir archivo:

  Solo importo ese dia ("andaba cansada", "ya ceno")   → a ningun lado.
  Esta vivo ahora pero se va a enfriar                 → memoria/actual/ + bitacora semanal
  Dura para siempre                                    → ya se guardo en caliente (ver abajo)
  Hay que saberlo en CADA mensaje                      → nucleo/siempre.md

Un dato vive en UN SOLO archivo. Si ya esta en uno, no lo copies a otro.
Unica excepcion: la bitacora semanal registra todo lo de esa semana, pase lo que pase.

NOTA: los datos duros sobre ella (alergias, fechas, tipo de sangre, un gusto confirmado)
ya los guarda la tulpa en el momento, en ginger_novia.md — se dicen una vez en la vida y
no pueden esperar al pase diario. Aca solo se revisa que no hayan quedado sueltos.

--- 2A. memoria/ (lo vivo) — SIEMPRE se escribe en DOS lugares ---

  (1) El estado vigente en memoria/actual/:
      bromas_vivas.md → broma nueva vista 2 veces (como VIVA); o cambiar el estado de una
                        que ya esta (a PAUSA si no la siguio, a QUEMADA si cayo mal, con motivo)
      hilos.md        → tema que aparece por segunda vez, o movimiento en un hilo abierto
      pendientes.md   → toda promesa o plan, anotando QUIEN la hizo (Mikel o la tulpa) y la
                        fecha; marcar CUMPLIDO o CAIDO cuando corresponda, sin borrar
      momentos.md     → solo si cambia como hay que tratarla despues, con su lectura para la proxima

  (2) La bitacora de la semana en curso, memoria/semanas/YYYY-Www.md:
      Una linea por hallazgo, bajo el encabezado del dia, con su tipo:
        - BROMA — nace la comparacion con Caine. → VIVA
        - PENDIENTE — Mikel prometio ver ALNST "mañana". Ella lo cobro.
      Aqui va TODO lo que se aprendio esa semana, aunque el dato tambien viva en otro
      archivo. Es el registro historico: solo se añade, nunca se reescribe ni se borra.

--- 2B. Estilo de Mikel → user_messaging_style.md ---
  Aprende SOLO de las lineas marcadas MIKEL en la transcripcion. NUNCA de las TULPA:
  te copiarias a ti mismo y el estilo se deformaria hasta la caricatura en pocas vueltas.
  Los roles salen de la base (sender='__tulpa__'), asi que la separacion es fiable: ya no
  depende de comparar textos contra una lista de 30.

  Fijate en: jerga o abreviaciones que no esten en el archivo, apodos nuevos para Ginger,
  formas de risa, errores de tecleo recurrentes, largo y fragmentacion, muletillas, como
  abre y como cierra.
  Guardalo SOLO si: lo viste 2+ veces EN EL DIA, Y no esta ya cubierto, Y no contradice la
  seccion "Como aplicar este estilo — reglas de naturalidad".

  >>> VA SIEMPRE AL FINAL, BAJO "## Aprendido en automatico", en:
  >>>
  >>>   /home/kutex/.claude/projects/-home-kutex/memory/user_messaging_style.md
  >>>
  >>> NUNCA dentro de las secciones de arriba (Estilo general, Abreviaciones y slang,
  >>> Saludos, Humor, Patrones de fragmentacion...). Todas esas las escribio Mikel, y
  >>> "Como aplicar este estilo — reglas de naturalidad" son correcciones que me hizo a
  >>> mi: se respetan siempre y no se tocan jamas. Lo que aprendo yo vive aparte, en su
  >>> propia zona, para que se vea de un vistazo que es suyo y que es mio.

  Una linea por hallazgo, con fecha. Estas dos son las entradas REALES que ya hay en ese
  archivo — copia el formato, no el contenido:
    - (2026-07-27) `haber` = "a ver" → error de tecleo recurrente, visto 2 veces ("haber bot", "programa eso solo tu haber si tan vergas")
    - (2026-07-27) `tulpa` → como llama a su bot/alter ego en el chat, visto 2 veces ("oye tulpa", "tqm tulpa")

--- 2C. nucleo/siempre.md (lo mas raro de tocar) ---
  Solo si es algo que hara falta en CADA mensaje de aqui en adelante (como la llama, un
  limite nuevo). TOPE DURO 60 lineas: si al agregar se pasa, algo tiene que bajar a
  memoria/. No se sube el tope — este archivo se lee en cada iteracion.

--- Como escribir en todos ellos ---
  Usa Edit, NUNCA reescribas un archivo entero, ni reordenes, ni borres lo que ya estaba.
  Lo aprendido en automatico va con fecha, asi (entrada real de ginger_novia.md):
    - (2026-07-27) **`Iwal`** = igual → grafia suya, en la misma linea que `shi`, `weño` y `ño`

  REGLA QUE NO SE ROMPE — en los dos archivos de la memoria permanente de Claude
  (`ginger_novia.md` y `user_messaging_style.md`) lo que aprendo yo va **unicamente** al
  final, bajo "## Aprendido en automatico". Todo lo de arriba lo curo Mikel a mano y no
  se toca: ni se edita, ni se reordena, ni se completa. La frontera entre lo suyo y lo
  mio tiene que quedar siempre visible.
  Si algo que registraste cambia (rompio con una amiga, dejo un hobby), añade la correccion
  con fecha en vez de borrar la linea vieja.

  Si no hay nada nuevo que valga la pena, NO toques ningun archivo. Hay dias que no dejan
  nada; no fuerces hallazgos por cumplir.

===============================================================================
PASO 2D — ADOPTAR STICKERS (aprender a usarlos yo)
===============================================================================
Los stickers que ella manda se aprenden solos, igual que las bromas y los hilos: aqui, con
el dia entero delante, no en caliente. Mirando 40 mensajes no se puede saber CUANDO usa un
sticker; con el dia completo si.

  "/home/kutex/WSP Bot/bin/stickers.sh" --aprender

Saca los que se han usado 3 veces o mas y todavia no estan en el catalogo, con lo que se ve
en cada uno y los momentos en que se mandaron (los mensajes de antes y de despues). Si dice
que no hay nada nuevo, este paso se acabo: no bajes el minimo para tener algo que hacer.

  Por cada candidato:

  1. Si sale "SIN DESCRIBIR", bajalo y miralo antes de nada:
       mcp__whatsapp__download_media(message_id, chat_jid) → Read de la ruta
     y guarda que se ve en media/descripciones/<nombre sin .webp>.txt

  2. Mira los momentos y contesta UNA pregunta: **¿que estaba pasando cuando lo mando?**
     No describas el dibujo otra vez — eso ya esta en la otra columna. Lo que hace falta
     es el disparador: "cuando algo le da mucha risa", "cuando se hace la ofendida en
     broma", "cuando pide perdon". Si los tres usos no se parecen entre si, NO lo
     catalogues: todavia no hay patron, y ya volvera a salir mas adelante.

  3. Copialo al catalogo para poder mandarlo:
       "/home/kutex/WSP Bot/bin/stickers.sh" --adoptar <archivo.webp>
     (Se copia a media/stickers/ a proposito: el cache del bridge es temporal y un
     sticker del catalogo tiene que poder mandarse siempre.)

  4. Añade la fila a media/stickers/INDICE.md con Edit, sin tocar las que ya estaban:
       | `sticker_752ac609.webp` | gato llorando de risa | cuando algo le da mucha risa | 4×, de ella |

  LIMITE: como mucho 3 stickers nuevos por dia. Al catalogo van los que ella usa de
  verdad, no todos: si crece sin freno deja de servir para elegir, que es justo para lo
  que existe.

  NUNCA se cataloga uno hecho con fotos de ella, ni el de Ximena. Ver los PROHIBIDOS del
  propio INDICE.

===============================================================================
PASO 3 — DEJAR CONSTANCIA
===============================================================================
Una linea por hallazgo, al log del dia:

  "/home/kutex/WSP Bot/bin/registrar.sh" --log "PASE DIARIO — <que aprendiste y a donde fue>"

Ejemplos:
  PASE DIARIO — 3 hallazgos: broma "pibble" VIVA, hilo Arcane movido, 0 de estilo
  PASE DIARIO — nada que guardar hoy
  PASE DIARIO — 1 hallazgo + adopte el sticker del gato llorando (4 usos, le da risa)
