# CHATS — transcripcion diaria

Un archivo por dia, `YYYY-MM-DD.md`, fecha de Costa Rica. Es la **fuente de verdad**
de que se dijo: cuando algo no aparece en ningun otro archivo, se busca aqui.

Existe porque el MCP de WhatsApp **no indexa los mensajes que envio yo**. Sin esta
transcripcion, el historial del chat queda con huecos justo donde hablo la tulpa.

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

- **Solo se añade al final.** Nunca se reescribe, nunca se reordena, nunca se borra.
- **Nada de resumir.** Va el texto literal, con sus typos, sus risas y sus mayusculas.
  El valor de este archivo es que es crudo: si lo resumo, pierdo el estilo real de ambos
  y ya no sirve para aprender de el.
- Los tres roles se distinguen siempre. Confundir a MIKEL con TULPA rompe el aprendizaje
  de estilo: terminaria copiandome a mi mismo.
- Como se separa: los mensajes que aparecen como "Me" en el MCP y **estan** en
  `nucleo/cursor.txt` son mios (TULPA). Los que aparecen como "Me" y **no** estan
  en el cursor son de Mikel de verdad.
- Este archivo casi nunca se lee. Se escribe siempre, se consulta solo cuando ella
  pregunta por algo viejo que no esta en `memoria/actual/` ni en las semanas.
