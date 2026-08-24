#!/usr/bin/env python3
# estilo-ficha.py — genera estilo/ficha.md: TODO lo cuantitativo del estilo de Mikel,
# sacado de la base en el momento.
#
# Por que existe: los conteos del perfil estaban escritos a mano y se desfasaron todos.
# `encerio` decia 6 usos y son 836; `talvez` decia 2 y son 347; el hook afirmaba
# `para` 1645 (real 2435) y `pa` 0 (real 7). Ninguno reproducia. La causa no es que
# alguien contara mal: es que un numero escrito en prosa sobre una base que crece a
# diario esta desfasado desde el dia siguiente.
#
# El arreglo de raiz es que los numeros no vivan en prosa. El perfil se queda con lo que
# un numero no puede decir (que significa cada tic, cuando se usa); todo lo contable sale
# de aqui y se regenera.

import os, re, sqlite3, statistics, sys, unicodedata
from collections import Counter
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import estilo
from estilo import TOK, desnuda

c = sqlite3.connect(f"file:{estilo.DB}?mode=ro", uri=True)
SUYO = "is_from_me=1 and sender<>'__tulpa__'"
q = lambda cond, chat=None: [r[0] for r in c.execute(
    "select coalesce(content,'') from messages where coalesce(media_type,'')='' "
    "and coalesce(content,'')<>'' and " + cond + (" and chat_jid=?" if chat else ""),
    (chat,) if chat else ())]

todos = q(SUYO)
reg   = q(SUYO, estilo.JID)
voc   = Counter(w for m in todos for w in TOK.findall(m.lower()))
N     = len(reg)
pc    = lambda v, p: sorted(v)[min(len(v)-1, int(len(v)*p))]
L     = [len(m) for m in reg]; W = [len(m.split()) for m in reg]
tasa  = lambda f: sum(1 for m in reg if f(m))*100/N

o = []
w = o.append
from datetime import date
w(f"# Ficha de estilo — GENERADA EL {date.today()} DESDE messages.db")
w("")
w("**NO EDITAR A MANO: este archivo se sobreescribe.** Lo regenera `bin/estilo-ficha.py`.")
w("Todo lo contable vive aqui; `user_messaging_style.md` se queda con lo que un numero no")
w("puede decir. Es el arreglo a que los conteos escritos en prosa se desfasaran todos.")
w("")
w("## Corpus")
w("")
tot_base = c.execute("select count(*) from messages").fetchone()[0]
suyos_tot = c.execute(f"select count(*) from messages where {SUYO}").fetchone()[0]
w(f"- **{tot_base:,}** mensajes en la base · **{suyos_tot:,}** suyos · **{len(todos):,}** suyos con texto")
w(f"- Registro medido (chat de Ginger): **{N:,}** mensajes de texto suyos")
w(f"- Vocabulario: **{sum(voc.values()):,}** tokens, **{len(voc):,}** tipos distintos")
w("")
w("## Longitud — la forma")
w("")
w("| | p25 | mediana | p75 | p90 | p99 |")
w("|---|---|---|---|---|---|")
w(f"| caracteres | {pc(L,.25)} | **{pc(L,.5)}** | {pc(L,.75)} | {pc(L,.9)} | {pc(L,.99)} |")
w(f"| palabras | {pc(W,.25)} | **{pc(W,.5)}** | {pc(W,.75)} | {pc(W,.9)} | {pc(W,.99)} |")
w("")
w(f"- **{tasa(lambda m: len(m.split())==1):.1f}%** de sus mensajes son de UNA sola palabra")
w(f"- **{tasa(lambda m: len(m.split())<=3):.1f}%** son de tres o menos")
w(f"- solo el {tasa(lambda m: len(m.split())>20):.1f}% pasa de veinte palabras")
w("")
w("## Puntuacion y ortotipografia")
w("")
w("| rasgo | tasa | nota |")
w("|---|---|---|")
w(f"| cierra con punto | **{tasa(lambda m: m.rstrip().endswith('.')):.2f}%** | esto SI es decision suya, no autocorrector |")
w(f"| lleva coma | **{tasa(lambda m: ',' in m):.1f}%** | el defecto nº1 de la imitacion: la tulpa iba al 40,8% |")
w(f"| lleva `¿` o `¡` | {tasa(lambda m: '¿' in m or '¡' in m):.2f}% | |")
w(f"| lleva `?` | {tasa(lambda m: '?' in m):.1f}% | |")
w(f"| lleva `??` | {tasa(lambda m: '??' in m):.1f}% | su forma de preguntar con enfasis |")
w(f"| empieza en mayuscula | {tasa(lambda m: m[:1].isupper()):.1f}% | autocapitalizacion del movil |")
w(f"| lleva alguna tilde | {tasa(lambda m: bool(re.search(r'[áéíóúüñ]', m, re.I))):.1f}% | |")
w(f"| letra alargada (3+) | {tasa(lambda m: any(m[i]==m[i+1]==m[i+2] for i in range(len(m)-2))):.1f}% | alarga sobre todo i, e, h, s |")
w(f"| mensaje entero en CAPS | {tasa(lambda m: m.isupper() and len(m)>2):.1f}% | |")
w("")
w("## Tildes — la regla real")
w("")
w("No es 'si' ni 'no'. **Acentua lo ortografico y NO acentua lo diacritico.** Y la tasa")
w("sube con la longitud, porque es el autocorrector del movil y no una decision:")
w("")
por_largo = {}
for m in reg:
    k = len(m.split())
    b = '1' if k==1 else '2' if k==2 else '3' if k==3 else '4-5' if k<=5 else '6-10' if k<=10 else '11-20' if k<=20 else '>20'
    por_largo.setdefault(b, []).append(bool(re.search(r'[áéíóúüñ]', m, re.I)))
w("| palabras | 1 | 2 | 3 | 4-5 | 6-10 | 11-20 | >20 |")
w("|---|---|---|---|---|---|---|---|")
w("| con tilde | " + " | ".join(f"{sum(por_largo[k])*100/len(por_largo[k]):.0f}%"
    for k in ['1','2','3','4-5','6-10','11-20','>20'] if k in por_largo) + " |")
w("")
par = {}
for m in todos:
    for x in TOK.findall(m.lower()):
        d = desnuda(x)
        if d != x: par.setdefault(d, Counter())['con'] += 1
        elif any(ch in 'aeiou' for ch in d): par.setdefault(d, Counter())['sin'] += 1
# Solo entran las formas donde de verdad hay ELECCION: las que escribe de las dos
# maneras con volumen en las dos. Sin ese filtro la tabla se llenaba de `a`, `al` y
# `amor`, que no llevan tilde jamas y no dicen nada.
real_con = {}
for x, n in voc.items():
    d = desnuda(x)
    if d != x and n > real_con.get(d, (0, ''))[0]: real_con[d] = (n, x)
elegibles = [(d, v['con'], v['sin']) for d, v in par.items()
             if v['con'] >= 20 and v['sin'] >= 5 and d in real_con]
si = sorted(((c/(c+sn), real_con[d][1], c+sn) for d, c, sn in elegibles
             if c/(c+sn) > .60), reverse=True)
no = sorted(((c/(c+sn), d, c+sn) for d, c, sn in elegibles if c/(c+sn) < .35))
w("**SI acentua** (tilde ortografica normal): " + " · ".join(f"`{d}` {r*100:.0f}%" for r,d,_ in si[:16]))
w("")
w("**NO acentua** (tilde diacritica): " + " · ".join(f"`{d}` {(1-r)*100:.0f}% sin" for r,d,_ in no[:16]))
w("")
w("## Sus grafias — y las dos que el perfil tenia mal")
w("")
w("| suya | usos | correcta | usos | gana |")
w("|---|---|---|---|---|")
for suya, corr in [("encerio","en serio"),("talvez","tal vez"),("almenos","al menos"),
                   ("aveces","a veces"),("enrelidad","en realidad"),("masomenos","mas o menos"),
                   ("osea","o sea"),("llendo","yendo"),("haber","a ver")]:
    a = voc.get(suya,0); b = sum(1 for m in todos if corr in m.lower())
    gana = "**suya**" if a > b else "**la correcta**"
    w(f"| `{suya}` | {a} | `{corr}` | {b} | {gana} |")
w("")
w("`llendo` y `haber` PIERDEN contra la forma correcta. El perfil las presentaba como su")
w("forma por defecto y es falso. Se mantienen porque hay correccion directa suya")
w("(`llendo`, el 2026-08-06), pero como preferencia declarada y no como hecho medido.")
w("")
w("## Vocabulario — lo que mas lo delata")
w("")
w("| palabra | usos | por mil | nota |")
w("|---|---|---|---|")
tot_tok = sum(voc.values())
for p, nota in [("xq","su palabra nº18 en frecuencia. La tulpa la usaba CERO veces"),
                ("x","= 'por'. Idem: la tulpa 9 veces"),("encerio",""),("shi",""),
                ("ntp",""),("talvez",""),("almenos",""),("osea",""),("alv","con cuentagotas"),
                ("xfis",""),("nop",""),("sip","")]:
    w(f"| `{p}` | {voc.get(p,0)} | {voc.get(p,0)*1000/tot_tok:.2f} | {nota} |")
w("")
w("## Sus mensajes exactos mas repetidos")
w("")
rep = Counter(m.strip() for m in reg)
w("El **{:.1f}%** de sus mensajes es identico a otro suyo. Los mas frecuentes:".format(
    (1 - len(set(m.strip() for m in reg))/N)*100))
w("")
w("  " + " · ".join(f"`{m}`({n})" for m, n in rep.most_common(24) if m))
w("")
w("## Rafagas — el orden en que dice las cosas")
w("")
rows=[(r[0],r[1],r[2]) for r in c.execute("""select is_from_me, sender, coalesce(content,'')
    from messages where chat_jid=? and coalesce(media_type,'')='' and coalesce(content,'')<>''
    order by timestamp""",(estilo.JID,))]
raf=[];cur=[]
for fm,snd,t in rows:
    if fm and snd!='__tulpa__': cur.append(t)
    else:
        if cur: raf.append(cur); 
        cur=[]
d=Counter(len(r) for r in raf); tr=sum(d.values())
w("| mensajes seguidos | 1 | 2 | 3 | 4 | 5+ |")
w("|---|---|---|---|---|---|")
w(f"| frecuencia | **{d[1]*100/tr:.1f}%** | {d[2]*100/tr:.1f}% | {d[3]*100/tr:.1f}% | {d[4]*100/tr:.1f}% | {sum(v for k,v in d.items() if k>=5)*100/tr:.1f}% |")
w("")
w(f"Media {sum(len(r) for r in raf)/tr:.2f} mensajes por turno.")
w("")
w("**Escalera ascendente** — el largo CRECE dentro de la rafaga, no al reves:")
w("")
for n in (2,3):
    sub=[r for r in raf if len(r)==n]
    med=[statistics.median([len(r[i].split()) for r in sub]) for i in range(n)]
    w(f"- rafaga de {n}: " + " -> ".join(f"**{x:.0f}**" for x in med) + " palabras")
w("")
w("Abre con lo corto y cierra con lo desarrollado y con la pregunta.")
w("")
open(f"{estilo.DIR}/ficha.md","w",encoding="utf-8").write("\n".join(o)+"\n")
print(f"escrita estilo/ficha.md — {len(o)} lineas")
