# STICKERS — catalogo para mandar

Se elige por TEXTO. **No abras las imagenes**: la columna "cuando" es lo unico que hace
falta para decidir, y abrirlas cuesta una vuelta entera.

**Se manda casi siempre**: el 82,8% de las rafagas de Mikel lleva sticker, y el momento
serio NO es excepcion — ahi sube al 86%. Lo raro es la rafaga sin ninguno (ver PASO 4 del
PROMPT y la seccion "Stickers" de `estilo/ficha.md`). Si ninguna fila pega con el momento,
se tira de los que ella ha mandado, que estan en el cache del bridge — pero se manda.

> Aqui puso "solo el 14%" del 2026-08-24 al 25, y era falso: ese porcentaje salia de
> dividir entre cinco meses de rafagas en los que el bridge ni guardaba stickers.

Y **repetir el mismo no es un fallo**: el sticker se queda pegado al humor mientras dura, y
puede ir varias veces en la misma rafaga y arrastrarse a la siguiente. La tabla existe para
elegir CUAL pega con el momento, no para obligar a variar.

Los archivos de esta tabla estan en `media/stickers/`. Se mandan con
`mcp__whatsapp__send_file(recipient=..., media_path="<ruta>")`.

**El orden es la preferencia, y es la de ESTA SEMANA**: la tabla se ordena por los usos
de Mikel en los ultimos 7 dias, con el total solo como desempate. Se hace asi porque el
sticker que le hace gracia cambia cada pocas semanas, y un contador desde el primer dia
dejaba arriba para siempre al de agosto — que es justo lo que hacia que la tulpa mandara
los mismos cuatro de siempre. Si varios pegan con el momento, se manda el de mas arriba.

Los usos que se cuentan son **solo los suyos**: antes se sumaban los de ella y los que ya
habia mandado la tulpa, asi que el bot se retroalimentaba solo (mandaba uno, subia, y por
subir lo mandaba mas).

**Pero el orden no filtra**: primero manda la columna "cuando". Un sticker con 0 esta
semana se manda igual si es el que pega con el momento — lo reciente decide entre varios
que valgan, no descarta al resto.

| archivo | que se ve | cuando lo mando | usos |
|---|---|---|---|
| `sticker_1444437d.webp` | gatito blanco de dibujo kawaii visto de frente, ojos negros enormes y brillantes, mejillas sonrojadas y una florecita rosa en la oreja, con dos corazones rosas flotando a los lados — cariño tranquilo, "ntp" | cuando le quito peso a algo por lo que se disculpa o se preocupa (va pegado al "ntp mi vida") | 137× esta semana · 227 en total |
| `sticker_c61b1d0c.webp` | gato pixel art de pelo negro puntiagudo con banda celeste en la cabeza y ropa morada, llorando a chorros con la boca muy abierta, con una estrella celeste detras — llanto dramatico, drama de broma | cuando reclamo o hago drama de celos en broma | 126× esta semana · 268 en total |
| `sticker_d430e467.webp` | Frieren chibi (elfa de pelo blanco con coletas y orejas puntiagudas) llorando con lagrimones y la boca temblorosa, fondo crema — tristeza tierna de puchero | otro de tristeza | 123× esta semana · 523 en total |
| `sticker_0cec61a6.webp` | Furina (Genshin) en version gato chibi, blanca con azul, tumbada boca abajo llorando con lagrimones y la boquita temblorosa — tristeza tierna | momentos tristes | 123× esta semana · 295 en total |
| `sticker_99f8e5e5.webp` | dibujo tosco a linea negra sobre blanco de un bicho redondo tipo foca/gato tumbado y aplastado, ojos entrecerrados y boquita minuscula — cara de resignacion, "ahi voy" | cuando estoy hablando en serio: explicandome, aclarando algo o pidiendo perdon | 122× esta semana · 315 en total |
| `sticker_93e7d07f.webp` | Furina (Genshin) en version gatito chibi blanco y azul, sonriendo feliz con los ojos cerrados mientras una mano le acaricia la cabeza — que lo consientan, mimos | cuando cuento algo mio con ilusion o quiero que me consientan | 93× esta semana · 133 en total |
| `sticker_6c8d774d.webp` | Madoka (Madoka Magica) en primer plano con la cara medio en sombra, mirada baja y seria, boca recta — mirada turbia | fastidio seco: algo no coopera, o la pillo en algo | 65× esta semana · 106 en total |
| `sticker_a32cc9ba.webp` | Madoka (Madoka Magica) llorando con la boca apretada y los ojos rojos, con una cenefa arriba de emojis llorando y "UEEEH EEE uUEEE" — llanto exagerado de broma | cuando me quejo de algo con drama de mentira, o compadezco que la sobre exploten | 58× esta semana · 98 en total |
| `sticker_85c86797.webp` | chica anime de pelo gris agarrandose la cabeza con las dos manos, llorando y gritando, con texto de teclado aporreado "gdhhdhdjdjdjjdkfk mgnbdjeif" arriba — desesperacion total | desesperacion | 51× esta semana · 171 en total |
| `sticker_17b9f02f.webp` | Gojo (Jujutsu Kaisen) en blanco y negro estilo manga, con un lazo rosado en el pelo, las manos en las mejillas y sonrisa boba de emocion — ternura tonta, "que lindo" | cuando le digo algo tierno o le pido algo con carita | 49× esta semana · 49 en total |
| `sticker_86cea6ee.webp` | chica de dibujo tipo lineart con coletas rubias y celestes, orejas de gato y guantes de patitas rosadas junto a la cara, fondo rosado — pose de gatita | cuando ando de buen humor jodiendo, entre travieso y contento | 43× esta semana · 59 en total |
| `sticker_d1e63e26.webp` | chica anime de pelo castano con orejas de perro y sudadera oscura con un hueso, cara seria y boca torcida hacia abajo — molestia contenida, puchero de enfado | cuando me niego a algo o me pongo de morros en broma | 43× esta semana · 58 en total |
| `sticker_c66da2d9.webp` | chica anime chibi de pelo rosa largo con cofia de sirvienta, ojos enormes azules llenos de lagrimas a punto de llorar y boquita apretada — carita de pena contenida, dar lastima | cuando pido algo dando penita | 32× esta semana · 90 en total |
| `sticker_f17e2b5e.webp` | chica anime de pelo azul largo con estrellas en los ojos, llorando y gritando emocionada mientras agita un lightstick azul de concierto — emocion desbordada de fan | cuando algo me sale bien y lo presumo emocionado (yaiiiii, gane, me luci) | 28× esta semana · 28 en total |
| `sticker_044bc134.webp` | el Joker de The Dark Knight en primerisimo plano, muy pixelado y oscuro, cara palida verdosa con la sonrisa torcida y la mirada fija — sonrisa siniestra de estar tramando algo | cuando la estoy troleando o le tiro una pulla | 25× esta semana · 125 en total |
| `sticker_5fa84aae.webp` | meme en blanco y negro de dos hombres con cadenas al cuello llorando con los ojos apretados y las manos juntas en oracion — suplica desesperada, "te lo ruego" | cuando ruego algo o me desespero explicandome | 25× esta semana · 25 en total |
| `sticker_c088fb8c.webp` | gato de dibujo celeste con antifaz negro y cara de desconcierto, delante de un incendio con un carro ardiendo — cara de "que acaba de pasar" mientras todo se quema | cuando algo se me sale de las manos o me quedo sin saber que decir (Ehhh, Nou?) | 23× esta semana · 29 en total |
| `sticker_f7081644.webp` | chica anime de pelo azul oscuro largo con flequillo, ojos celestes grandes, ceño fruncido y boca torcida hacia abajo, con gotas de sudor y las mejillas sonrojadas — apuro incomodo, cara de estarse sincerando a la fuerza | cuando me sincero o pido algo pasando verguenza | 23× esta semana · 23 en total |
| `sticker_a85179bc.webp` | personaje animado de piel gris azulada con antifaz oscuro y pelo verde/vinotinto, cara de angustia con los ojos llorosos y la boca torcida — "la cague", susto o culpa | cuando la cague o cuando me van a regañar | 19× esta semana · 87 en total |
| `sticker_33e536e0.webp` | chica anime en blanco y negro con orejas de gato y trenzas, ojos rosas entrecerrados y sonrisa afilada con colmillos — sonrisa siniestra, "estoy tramando algo" | cuando estoy tramando algo o me hace gracia una maldad mia | 18× esta semana · 21 en total |
| `sticker_0a42104a.webp` | gato de dibujo (meme de TikTok) en primerisimo plano con los ojos enormes llorosos, brillos y una lagrima cayendo, sonrojado — carita de suplica, dar pena a proposito | cuando me hago la victima o doy pena en broma | 4× esta semana · 51 en total |
| `sticker_a57c9007.webp` | dibujo simple de un animalito blanco (gato/perro) con los ojos enormes y llorosos de emocion y las patitas juntas al pecho — conmovido, "que lindo" | despues de algo lindo o un iwiwiwi | 3× esta semana · 12 en total |
| `sticker_752ac609.webp` | gato llorando con la boca abierta y texto deformado tipo "HUHHUEHAU HSHUSUAHU AH" y dos emojis de llanto — risa descontrolada, de las de no poder respirar | cuando algo le da mucha risa | 2× esta semana · 138 en total |
| `sticker_64852552.webp` | chico anime de pelo azul oscuro con lentes redondos (Saihara de Danganronpa) junto a un emoji de dedo indice levantado — modo "actually", nerd corrigiendo | cuando digo algo nerd | 2× esta semana · 56 en total |
| `sticker_7c9c562f.webp` | chica chibi de pelo azul oscuro largo y ojos verde agua enormes, con lazo negro y uniforme, levantando el pulgar hacia la camara con la lengua asomando — pulgar arriba, "dale" / "de acuerdo" | un ok | 2× esta semana · 37 en total |
| `sticker_3b028bb0.webp` | carita chibi de pelo negro y ojos grandes asomando desde dentro de una estrella amarilla, expresion neutra y mona — presencia sin decir nada, momento normal | cuando no se que poner y es un momento normal | 2× esta semana · 20 en total |
| `sticker_6736fb7f.webp` | Yui de K-On (pelo castano corto con horquilla amarilla, uniforme del cole) sentada mirando a otra chica rubia de espaldas, sonrisa leve y tranquila — escuchar con calma, presencia relajada | conversaciones casuales | 2× esta semana · 5 en total |
| `sticker_826ebb4d.webp` | gatito blanco de dibujo kawaii a linea negra, tumbado de panza con la carita apoyada y tres corazoncitos rosas flotando encima — cariño derretido, ternura | cuando le digo algo tierno o la halago yo | 1× esta semana · 78 en total |
| `sticker_62446848.webp` | gato muy pixelado con las cejas fruncidas de enojo y un icono rojo de pulgar abajo encima — dislike agresivo, tirar hate | para tirar hate | 1× esta semana · 3 en total |
| `sticker_c63b4d56.webp` | Furina chibi de dibujo simple azul y blanco, derrumbada en el suelo de rodillas con dos baguettes tiradas delante — derrota, se le cayo el mundo | cuando estoy triste | 0× esta semana · 130 en total |
| `sticker_af7cbd35.webp` | Madoka Kaname (Madoka Magica) con casco militar y mirada perdida y vacia, en un campo de batalla arrasado con colores desaturados — clima turbio, "vi cosas" | momentos turbios | 0× esta semana · 60 en total |
| `sticker_536e4c53.webp` | el Joker del comic (The Killing Joke) riendose a carcajadas bajo la lluvia, tapandose media cara con la mano — risa maligna de chiste muy bueno | chistes o humor muy bueno | 0× esta semana · 42 en total |
| `sticker_342e0ede.webp` | gato de perfil mirando una pantalla con la misma imagen repetida dentro (recursiva) y burbujitas — el gato pensando, dandole vueltas a algo | cuando estoy dudando o pensando | 0× esta semana · 23 en total |
| `sticker_f7fe25e8.webp` | chica de anime (Yui de K-On) sonriendo con el dedo en la barbilla, fondo rosa con fresitas — carita mona, entre tierna y coqueta | cuando lleva rato llamandote y no le contestas, en plan mono | 0× esta semana · 20 en total |
| `sticker_1ee20f99.webp` | chica anime de pelo rosa en primerisimo plano, guiñando un ojo, muy sonrojada y con un dedo en los labios — cara sugerente/coqueta | momentos horny | 0× esta semana · 13 en total |
| `sticker_fda166ab.webp` | chica anime rubia de pelo largo con los ojos entrecerrados y cara de agotamiento, sudorcito en la mejilla — cansancio, sueño, ya no puedo | cansancio o sueño | 0× esta semana · 10 en total |
| `sticker_f24e8071.webp` | gatito naranja tecleando en un laptop con un bocadillo que dice "nono dislike" — desaprobacion suave, no me gusta eso | cuando algo me disgusta | 0× esta semana · 4 en total |
| `sticker_a9a85597.webp` | chica anime de pelo azul oscuro con la cara apoyada en la mano, mirada de desgano y cuernitos morados brillando, texto "my honest reaction" arriba — sin palabras, cara de nada | sonrojo | 0× esta semana · 4 en total |
| `sticker_662709df.webp` | chica anime de pelo negro con gafas grandes y el dedo indice levantado explicando algo, con un emoji nerd amarillo encima — modo "actually" pero mas intenso, nerd total | cuando digo algo aun mas nerd | 0× esta semana · 4 en total |
| `sticker_3329dc50.webp` | meme de dos gatitos frente a un laptop con bocadillos: "jajajajajajaja Que buen momichi! Deberias darle like Ramirez :3" y "Jeje Like" — aprobacion, esto me gusta | cuando algo me gusta | 0× esta semana · 3 en total |
| `sticker_5b889520.webp` | meme borroso de dos figuras bailando con el texto "tu manco" arriba y "y yo pro" abajo — burla de gamer, presumir sobre el otro | burla, tu manco y yo pro | 0× esta semana · 2 en total |
| `sticker_8b1edb06.webp` | Furina (Genshin) chibi con sombrero de copa y corona, riendose con los ojos cerrados y la mano en la boca, con rayitas de burla y una gotita — burla tierna, se rie de vos con cariño | burla tierna | 0× esta semana · 1 en total |
| `sticker_524657ab.webp` | collage partido a la mitad: a la izquierda el Joker del comic riendo como maniaco en blanco y negro, a la derecha una chica anime de pelo rosa sonriendo dulce — la dualidad, locura contenida | locura | 0× esta semana · 1 en total |
| `sticker_35396697.webp` | Yui de K-On con los ojos cerrados, sonrisa boba con la boca abierta y las manos juntas al pecho, en el aula — felicidad tonta, contenta | momentos timidos | 0× esta semana · 1 en total |
| `sticker_1ee3f69f.webp` | chica anime de pelo rosa con cara de extasis (ojos entrecerrados, lengua fuera, muy sonrojada) y el texto "*C viene*" abajo — sticker sexual explicito de meme | cuando la cosa se pone caliente | 0× esta semana · 1 en total |
| `sticker_750b329e.webp` | chico moreno joven de pelo negro sonriendo de oreja a oreja a la camara, con cortinas de girasoles detras — el meme del chico turco sonriendo, cara de picardia | despues de algo turbio inesperado | 0× esta semana · 0 en total |
<!-- fin de las filas -->

## Esta tabla se llena sola

No hay que meter mano. El **pase diario** (PROMPT_MEMORIA.md, PASO 2D) mira los stickers
del dia, y cuando uno se ha usado **3 veces o mas** juzga en que momentos se mando y lo
añade aqui con su "cuando". Maximo 3 nuevos por dia.

**Los de Mikel pasan antes que los de Ginger** (lo pidio el 2026-08-06): si hay que elegir
entre candidatos, primero los suyos — son los que yo tengo que saber mandar, porque escribo
como el.

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
