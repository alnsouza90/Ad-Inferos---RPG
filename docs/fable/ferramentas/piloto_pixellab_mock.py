import sys, math, numpy as np
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
    sp=rim(crop(Image.open(path).convert("RGBA")),AMBAR if side=="left" else VIOL,side); w,h=sp.size; x0=cx-w//2; y0=GROUND-h-lift
    if shadow: d.ellipse((cx-w*0.38,GROUND-5,cx+w*0.38,GROUND+5),fill=(0,0,0,255))
    if halo: d.ellipse((x0+halo[0]-21,y0+halo[1]-21,x0+halo[0]+21,y0+halo[1]+21),fill=OURO+(255,))
    img.alpha_composite(sp,(x0,y0)); return x0,y0,w,h
put(GAL+"/1794528020047.png",150,"left",halo=(60,24))
put(G+"/bento_v1.png",300,"left",halo=(64,36))
put(GAL+"/1794527313629.png",455,"left",halo=(85,24))
e1=put(G+"/mud_devil.png",660,"right")
e2=put(G+"/shade.png",850,"right",shadow=False,lift=6)
font=ImageFont.load_default()
def T(x,y,s,fill=OSSO): d.text((x,y),s,font=font,fill=fill)
for (x0,y0,w,h),kind,val in ((e1,"atk","5"),(e2,"cor","")):
    x,y=x0+w//2,y0-22
    d.ellipse((x-14,y-14,x+14,y+14),fill=FERRO,outline=SANGUE if kind=="atk" else CH2,width=3)
    if kind=="atk": T(x-3,y-6,val)
    else: d.ellipse((x-7,y-4,x+7,y+4),outline=OSSO); d.ellipse((x-2,y-2,x+2,y+2),fill=OSSO)
d.line((24,10,24,230),fill=CH2,width=2); d.rectangle((13,90,35,124),fill=FERRO,outline=CH2,width=2); d.polygon([(24,96),(31,108),(24,119),(17,108)],fill=AMBAR)
T(430,8,"Rodada 1"); T(500,8,"+8",fill=CINZA)
d.rectangle((0,FIELD,W-1,H-1),fill=FERRO,outline=CHUMBO,width=3)
ax,ay=16,376
arch=[(ax,ay+94),(ax,ay+34),(ax+12,ay+12),(ax+33,ay),(ax+54,ay+12),(ax+66,ay+34),(ax+66,ay+94)]
d.polygon(arch,fill=BREU)
head=crop(Image.open(GAL+"/1794527313629.png").convert("RGBA")).crop((54,0,118,86)); img.alpha_composite(head,(ax+2,ay+8)); d=ImageDraw.Draw(img)
d.line(arch+[arch[0]],fill=CH2,width=3)
T(96,372,"Sao Jorge"); T(96,386,"Vida 32/32",fill=CINZA)
def lanceta(x,y,state,icon):
    glass={0:(26,25,30),1:CHUMBO,2:AMBAR}[state]
    pts=[(x,y+54),(x,y+18),(x+8,y+6),(x+17,y),(x+26,y+6),(x+34,y+18),(x+34,y+54)]
    d.polygon(pts,fill=glass)
    for k in range(-2,6): d.line((x+1,y+8+k*12,x+33,y+24+k*12),fill=BREU if state!=2 else (122,61,16))
    d.line(pts+[pts[0]],fill=OSSO if state==2 else CH2,width=2)
    c=BREU if state==2 else (OSSO if state==1 else CH2); cx,cy=x+17,y+30
    if icon=="golpe": d.line((cx-8,cy+9,cx+8,cy-9),fill=c,width=3); d.line((cx+8,cy-9,cx+1,cy-8),fill=c,width=2); d.line((cx+8,cy-9,cx+7,cy-2),fill=c,width=2)
    if icon=="escudo": d.line([(cx,cy-10),(cx+9,cy-6),(cx+9,cy+3),(cx,cy+10),(cx-9,cy+3),(cx-9,cy-6),(cx,cy-10)],fill=c,width=2)
    if icon=="chama": d.line([(cx,cy-10),(cx+6,cy),(cx+3,cy+9),(cx-4,cy+9),(cx-6,cy+2),(cx,cy-10)],fill=c,width=2)
for i,(st,ic) in enumerate([(1,"golpe"),(2,"golpe"),(1,"escudo"),(0,"chama")]): lanceta(96+i*41,404,st,ic)
rx,ry=296,432
d.ellipse((rx-26,ry-26,rx+26,ry+26),fill=FERRO,outline=CH2,width=3)
for k in range(8):
    a0=math.radians(k*45+4); a1=math.radians(k*45+41)
    d.polygon([(rx+8*math.cos(a0),ry+8*math.sin(a0)),(rx+21*math.cos(a0),ry+21*math.sin(a0)),(rx+21*math.cos(a1),ry+21*math.sin(a1)),(rx+8*math.cos(a1),ry+8*math.sin(a1))],fill=OURO)
d.ellipse((rx-5,ry-5,rx+5,ry+5),fill=FERRO,outline=CH2)
d.rectangle((94,520,228,523),fill=CHUMBO)
for k in range(6):
    x=100+k*21; d.rectangle((x,500,x+9,518),fill=(207,199,182),outline=BREU)
    if k<4: d.polygon([(x+4,484),(x+9,494),(x+4,499),(x,494)],fill=AMBAR)
for i,s in enumerate(["Trocar","Passar"]):
    x=244+i*66; d.rectangle((x,478,x+60,498),fill=BREU,outline=CH2,width=2); T(x+10,482,s)
d.rectangle((244,504,370,524),fill=BREU,outline=CH2,width=2); T(254,508,"Interceder",fill=OURO)
for k,(n,on) in enumerate([("2",1),("1",0),("2",1),("1",1),("1",0)]):
    x=402+k*30; d.line((x+10,376,x+10,386),fill=CINZA,width=2)
    d.rounded_rectangle((x,386,x+21,416),radius=6,fill=BREU,outline=CINZA if on else CHUMBO,width=2); T(x+7,394,n,fill=OSSO if on else CH2)
T(402,422,"Alforje",fill=CINZA)
d.polygon([(576,372),(942,368),(951,405),(945,522),(840,528),(828,519),(582,525),(570,450)],fill=BREU,outline=CH2)
mini=crop(Image.open(G+"/mud_devil.png").convert("RGBA")); mini=mini.crop((0,0,mini.width,min(mini.height,140))); img.alpha_composite(mini,(590,378)); d=ImageDraw.Draw(img)
T(790,380,"Diabo de Lodo"); T(790,396,"Vida 36/36",fill=CINZA); T(790,412,"Ataque 5 na posicao 1",fill=CINZA)
d.rectangle((810,492,936,514),fill=FERRO,outline=CH2,width=2); T(822,497,"Encerrar turno")
img.convert("RGB").save(OUT+"/pixellab_piloto_combate_960x540.png")
img.convert("RGB").resize((W*2,H*2),Image.NEAREST).save(OUT+"/pixellab_piloto_combate_x2.png"); print("ok")
