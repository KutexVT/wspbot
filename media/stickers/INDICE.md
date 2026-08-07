# STICKERS — catalogo para mandar

Se elige por TEXTO. **No abras las imagenes**: la columna "cuando" es lo unico que hace
falta para decidir, y abrirlas cuesta una vuelta entera.

Uno de vez en cuando, no en cada mensaje. Un sticker cada dos por tres deja de ser
gracioso y pasa a ser un tic.

| archivo | que es | cuando lo mando |
|---|---|---|
| _(vacio todavia — ver abajo)_ | | |

## Como se llena esta tabla

**Solo entran los que se usan de verdad**, nunca todos los que aparezcan: en este chat
salen demasiados y una tabla larga deja de servir para elegir.

El criterio es cuantas veces se repite el mismo sticker, que se cuenta solo:

    ./bin/stickers.sh 3        # los que salen 3 veces o mas
    ./bin/stickers.sh 3 --md   # las mismas filas listas para pegar aqui

La columna "cuando" se escribe **a mano**: eso es criterio, y de un contador no sale.

Ojo con las fechas: hasta el **2026-08-06** el bridge descartaba los stickers entrantes,
asi que la base arranco de cero ese dia. Las cuentas no dicen nada hasta que pasen varios
dias de chat — no llenar esto el primer dia.

## Los suyos

Los stickers que manda ella quedan en
`whatsapp-mcp/whatsapp-bridge/store/237799840162013@lid/sticker_*.webp`.

**Devolverle su propio sticker es lo mas natural de WhatsApp** y no hace falta que este
en esta tabla: se manda la ruta directa y ya. Aqui solo se anotan los que valga la pena
tener a mano por lo que significan, no por existir.

## Como se añade uno nuevo desde una imagen

    ./bin/pegar.sh <imagen>     # la deja en 512x512 WebP, que es lo unico que acepta WhatsApp

Vale png, jpg, gif y mp4. Un `.webp` que ya mida 512x512 se copia tal cual.

## PROHIBIDOS — esto no se manda nunca

- **Nada hecho con fotos de Ginger.** Lo pidio en serio el 2026-08-04: *"me haces un
  stiker y lloro literalmente. Por si acaso"*. Sus fotos son terreno minado y no es una
  broma que se pueda tantear.
- **El sticker de Ximena.** Mikel le pidio que dejara de usarlo porque le trae malos
  recuerdos. Terreno suyo, no se toca.
