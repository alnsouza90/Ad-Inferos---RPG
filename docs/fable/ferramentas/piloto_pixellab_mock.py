import sys, numpy as np
from PIL import Image, ImageDraw, ImageFont, ImageOps
G, GAL, OUT = sys.argv[1], sys.argv[2], sys.argv[3]
def C(h): return tuple(int(h[i:i+2],16) for i in (0,2,4))
BREU,FERRO,CHUMBO,CH2,CINZA,OSSO,SANGUE,OURO,AMBAR,VIOL=C("0D0C10"),C("1B1A20"),C("33313A"),C("55525D"),C("8A8791"),C("E4DDCF"),C("9B1C1C"),C("D9A520"),C("E07B1F"),C("8A6BB0")
W,H,FIELD,GROUND = 960,540,360,338
img = Image.new("RGBA",(W,H),BREU+(255,))
bg = Image.open(G+"/fundo_c2.png").convert("RGBA").crop((0,24,688,384))
img.paste(ImageOps.mirror(bg.crop((0,0,136,360))),(0,0)); img.paste(bg,(136,0)); img.paste(ImageOps.mirror(bg.crop((552,0,688,360))),(824,0))
def crop(im):
    a=np.array(im); ys=np.where((a[...,3]>0).any(1))[0]; xs=np.where((a[...,3]>0).any(0))[0]
    return im.crop((xs[0],ys[0],xs[-1]+1,ys[-1]+1))
def rim(im,color,side):
    a=np.array(im); al=a[...,3]>0; nb=np.zeros_like(al)
    if side=="left": nb[:,1:]=al[:,:-1]
    else: nb[:,:-1]=al[:,1:]
    e=al&~nb; e[int(a.shape[0]*0.93):]=False; a[e,:3]=color; return Image.fromarray(a,"RGBA")
d = ImageDraw.Draw(img)
def put(path,cx,side,halo=None,shadow=True,lift=0):
    global d
    sp=rim(crop(Image.open(path).convert("RGBA")),AMBAR if side=="left" else VIOL,side); w,h=sp.size; x0=cx-w//2; y0=GROUND-h-lift
    if shadow: d.ellipse((cx-w*0.38,GROUND-5,cx+w*0.38,GROUND+5),fill=(0,0,0,255))
    if halo: d.ellipse((x0+halo[0]-22,y0+halo[1]-22,x0+halo[0]+22,y0+halo[1]+22),fill=OURO+(255,))
    img.alpha_composite(sp,(x0,y0)); d=ImageDraw.Draw(img); return x0,y0,w,h
put(G+"/tere_menor.png",150,"left",halo=(48,22))
put(G+"/bento_v1.png",300,"left",halo=(62,26))
put(GAL+"/1794527313629.png",455,"left",halo=(84,22))
e1=put(G+"/mud_devil.png",660,"right")
e2=put(G+"/shade.png",850,"right",shadow=False,lift=6)
font=ImageFont.load_default()
def T(x,y,s,fill=OSSO): d.text((x,y),s,font=font,fill=fill)
UA=Image.open(G+"/ui_a.png").convert("RGBA"); UB=Image.open(G+"/ui_b.png").convert("RGBA")
def piece(sheet,box): x,y,w,h=box; return sheet.crop((x,y,x+w,y+h))
L=[piece(UA,(16,9,65,153)),piece(UA,(96,9,64,153)),piece(UA,(175,9,65,153))]
ROSE_OFF,ROSE_ON=piece(UA,(45,170,79,78)),piece(UA,(132,170,79,78))
ARCH,BROKEN,HOOK,RACK=piece(UB,(17,6,103,169)),piece(UB,(146,16,92,119)),piece(UB,(186,150,34,92)),piece(UB,(14,189,150,53))
oc=piece(UA,(45,170,79,78)).resize((40,40),Image.NEAREST)  # óculo provisório para as intenções
for (x0,y0,w,h),kind,val in ((e1,"atk","5"),(e2,"cor","")):
    x,y=x0+w//2,y0-24
    d.ellipse((x-15,y-15,x+15,y+15),fill=FERRO,outline=SANGUE if kind=="atk" else CH2,width=3)
    if kind=="atk": T(x-3,y-6,val)
    else: d.ellipse((x-7,y-4,x+7,y+4),outline=OSSO); d.ellipse((x-2,y-2,x+2,y+2),fill=OSSO)
d.line((24,10,24,230),fill=CH2,width=2); d.rectangle((13,90,35,124),fill=FERRO,outline=CH2,width=2); d.polygon([(24,96),(31,108),(24,119),(17,108)],fill=AMBAR)
T(430,8,"RODADA 1"); T(500,8,"+8",fill=CINZA)
d.rectangle((0,FIELD,W-1,H-1),fill=FERRO,outline=CHUMBO,width=3)
# retrato no arco
head=crop(Image.open(GAL+"/1794527313629.png").convert("RGBA")).crop((60,0,124,96))
img.alpha_composite(ARCH,(8,366)); img.alpha_composite(head.crop((0,0,60,96)),(8+22,366+62)); d=ImageDraw.Draw(img)
T(122,366,"SAO JORGE"); T(200,366,"Vida 32/32",fill=CINZA)
for i,st in enumerate([1,2,1,0]): img.alpha_composite(L[st],(120+i*68,382))
d=ImageDraw.Draw(img)
img.alpha_composite(ROSE_ON,(404,378)); img.alpha_composite(RACK,(396,476)); d=ImageDraw.Draw(img)
for k,x in enumerate((425,440,458,476)): d.polygon([(x,462),(x+4,470),(x,475),(x-4,470)],fill=AMBAR)
for i,(s,c) in enumerate((("TROCAR",OSSO),("PASSAR",OSSO),("INTERCEDER",OURO))):
    y=370+i*24; d.rectangle((566,y,676,y+20),fill=BREU,outline=CH2,width=2); T(576,y+4,s,fill=c)
for k,n in enumerate(("2","2","1")):
    img.alpha_composite(HOOK,(572+k*38,446)); d=ImageDraw.Draw(img); T(584+k*38,524,n)
dev=crop(Image.open(G+"/mud_devil.png").convert("RGBA")).crop((40,0,108,95))
img.alpha_composite(BROKEN,(712,376)); img.alpha_composite(dev.crop((0,0,64,90)),(712+14,376+14)); d=ImageDraw.Draw(img)
T(816,380,"DIABO DE LODO"); T(816,396,"Vida 36/36",fill=CINZA); T(816,412,"Ataque 5 na posicao 1",fill=CINZA)
d.rectangle((816,500,944,524),fill=BREU,outline=CH2,width=2); T(830,506,"ENCERRAR TURNO")
img.convert("RGB").save(OUT+"/pixellab_piloto_combate_v2_960x540.png")
img.convert("RGB").resize((W*2,H*2),Image.NEAREST).save(OUT+"/pixellab_piloto_combate_v2_x2.png"); print("ok")
