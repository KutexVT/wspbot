# STICKERS — catalogo para mandar

Se elige por TEXTO. **No abras las imagenes**: la columna "cuando" es lo unico que hace
falta para decidir, y abrirlas cuesta una vuelta entera.

**Se manda uno SIEMPRE, al final de cada vez que se escribe** (ver PASO 4 del PROMPT). Por
eso importa que la tabla crezca: con pocas filas se repiten los mismos. Si ninguna pega
con el momento, se tira de los que ella ha mandado, que estan en el cache del bridge.

Los archivos de esta tabla estan en `media/stickers/`. Se mandan con
`mcp__whatsapp__send_file(recipient=..., media_path="<ruta>")`.

| archivo | que se ve | cuando lo mando |
|---|---|---|
| `sticker_752ac609.webp` | gato llorando con la boca abierta y texto deformado tipo "HUHHUEHAU HSHUSUAHU AH" y dos emojis de llanto — risa descontrolada, de las de no poder respirar | cuando algo le da mucha risa |
| `sticker_f7fe25e8.webp` | chica de anime (Yui de K-On) sonriendo con el dedo en la barbilla, fondo rosa con fresitas — carita mona, entre tierna y coqueta | cuando lleva rato llamandote y no le contestas, en plan mono |
<!-- fin de las filas -->

## Esta tabla se llena sola

No hay que meter mano. El **pase diario** (PROMPT_MEMORIA.md, PASO 2D) mira los stickers
del dia, y cuando uno se ha usado **3 veces o mas** juzga en que momentos lo mando ella y
lo añade aqui con su "cuando". Maximo 3 nuevos por dia.

**Solo entran los que se usan de verdad**, nunca todos: en este chat salen demasiados y
una tabla larga deja de servir para elegir, que es justo para lo que existe.

A mano, si hace falta:

    ./bin/stickers.sh --aprender          # candidatos, con el contexto de cada uso
    ./bin/stickers.sh --anotar <archivo> "cuando se manda"
    ./bin/stickers.sh --olvidar <archivo>

Ojo con las fechas: hasta el **2026-08-06** el bridge descartaba los stickers entrantes,
asi que la base arranco de cero ese dia. Las cuentas no dicen nada hasta que pasen varios
dias de chat.

## Corregir desde WhatsApp

Mikel puede arreglar la tabla sin salir del chat, escribiendo en la conversacion:

    /sticker cuando algo le da mucha risa     → anota eso del ultimo sticker que salio
    /sticker no                               → lo saca del catalogo

Se refiere siempre **al ultimo sticker del chat**, que es el que se acaba de ver. Sirve
tanto para corregir uno mal catalogado como para enseñar uno nuevo en el momento, sin
esperar a que llegue a los 3 usos.

## Los suyos, sin catalogar

Los stickers que manda ella quedan en
`whatsapp-mcp/whatsapp-bridge/store/237799840162013@lid/sticker_*.webp`.

**Devolverle su propio sticker es lo mas natural de WhatsApp** y no hace falta que este en
la tabla: se manda la ruta directa y ya.

## Como se añade uno nuevo desde una imagen

    ./bin/pegar.sh <imagen>     # la deja en 512x512 WebP, que es lo unico que acepta WhatsApp

Vale png, jpg, gif y mp4. Un `.webp` que ya mida 512x512 se copia tal cual.

## PROHIBIDOS — esto no se manda nunca

- **Nada hecho con fotos de Ginger.** Lo pidio en serio el 2026-08-04: *"me haces un
  stiker y lloro literalmente. Por si acaso"*. Sus fotos son terreno minado y no es una
  broma que se pueda tantear.
- **El sticker de Ximena.** Mikel le pidio que dejara de usarlo porque le trae malos
  recuerdos. Terreno suyo, no se toca.
