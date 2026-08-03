# CHATS — transcripcion diaria

Un archivo por dia, `YYYY-MM-DD.md`, fecha de Costa Rica. Es la **fuente de verdad**
de que se dijo: cuando algo no aparece en ningun otro archivo, se busca aqui.

**No se escribe a mano: lo genera `bin/transcribir.sh` desde la base de mensajes.**

    "/home/kutex/WSP Bot/bin/transcribir.sh"              # hoy
    "/home/kutex/WSP Bot/bin/transcribir.sh" 2026-07-30   # otro dia

Antes lo iba escribiendo la tulpa, añadiendo al final lo que acababa de leer. Mientras
escribia seguian entrando mensajes con hora anterior, asi que el archivo terminaba
desordenado (el 2026-07-29 quedaron tres lineas fuera de secuencia). Generarlo por
`ORDER BY` lo vuelve imposible.

## Formato

    [HH:MM:SS] GINGER: texto tal cual, sin corregirle nada
    [HH:MM:SS] MIKEL:  texto tal cual
    [HH:MM:SS] TULPA:  texto tal cual (lo que envie yo)
    [HH:MM:SS] GINGER: <audio: "la transcripcion literal, entre comillas">
    [HH:MM:SS] GINGER: <foto: descripcion corta de lo que se ve, una linea>
    [HH:MM:SS] GINGER: <video>            ← este si queda vacio: no lo puedo ver

Ejemplo real:

    [22:54:00] GINGER: Tulpa, no bot
    [22:54:29] GINGER: Amor, es un bot no el pt Caine
    [22:55:10] TULPA:  grashas amor, tulpa suena mas digno
    [22:55:14] TULPA:  y shi, ni de cerca soy caine, ese si tiene presupuesto
    [16:34:21] GINGER: <audio: "no entendi ni que chucha es el dibujo sinceramente y por
               cierto se me va a ir a internet asi que me voy despidiendo">
    [16:33:28] GINGER: <foto: grafiti en una pared de concreto, dice "Get Jinxed" con una
               carita dibujada, y abajo "NANA was Here 07/29">

La transcripcion del audio va literal, tal como la devuelve `bin/oir.sh`. La foto va con
una descripcion de una linea: que se ve, no que opinas.

## Reglas

- **Nada de resumir.** Va el texto literal, con sus typos, sus risas y sus mayusculas.
  El valor de este archivo es que es crudo: si lo resumo, pierdo el estilo real de ambos
  y ya no sirve para aprender de el. Como sale de la base, esto se cumple solo.
- Los tres roles se distinguen siempre. Confundir a MIKEL con TULPA rompe el aprendizaje
  de estilo: terminaria copiandome a mi mismo.
- **Como se separa (desde el 2026-07-31):** el bridge guarda cada mensaje que envio yo
  con `sender = '__tulpa__'`. Eso separa TULPA de MIKEL en la base misma, de forma
  permanente. Ya **no** se compara el texto contra `SENT_BY_BOT`: ese metodo fallaba si
  Mikel escribia lo mismo que yo, o si la lista de 30 se desbordaba en una rafaga.
  El bloque `SENT_BY_BOT` del cursor queda congelado, solo sirve para los dias anteriores.
- Lo unico que la base no sabe es que se ve en una foto y que dice un audio. Eso lo pongo
  yo, en `media/transcripciones/<id>.txt` y `media/descripciones/<id>.txt`, y el script
  los inyecta. Si falta uno, la linea queda como `<foto: sin describir - Message ID: ...>`
  y se puede resolver despues y regenerar el dia.
- Las transcripciones escritas a mano (hasta el 2026-07-30) **no se pisan**: el script se
  niega a sobrescribirlas salvo que se le pase `--forzar`.
- Este archivo casi nunca se lee. Se genera siempre, se consulta solo cuando ella
  pregunta por algo viejo que no esta en `memoria/actual/` ni en las semanas.
