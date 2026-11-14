import sys, numpy as np
from PIL import Image, ImageDraw, ImageFont
from scipy import ndimage as ndi
REPO, OUT = sys.argv[1], sys.argv[2]
A = REPO + "/game/assets/"; P = REPO + "/docs/fable/previas/"
HEX = """0D0C10 1B1A20 33313A 55525D 8A8791 B9B3C2 E4DDCF CFC7B6 9B1C1C 5E1414 3A0D0D D9A520 E07B1F 7A3D10 3A1D08 F1ECE0
E0B89A B98A6E 8A5F48 5C3D30 6B4A35 4A3324 33241A 8A6B4A 8C7240 5F4D2C 7A1E1E A83232 2A2830 44414B 6F6676 D8D2C6 A8A297
5B3F7A 3B2A4D 241A30 8A6BB0 4A5A3A 000000 15121A""".split()
PAL = np.array([[int(h[i:i+2],16) for i in (0,2,4)] for h in HEX], dtype=np.int32)
def C(h): return tuple(int(h[i:i+2],16) for i in (0,2,4))
BREU,FERRO,CHUMBO,CH2,CINZA,OSSO,SANGUE,OURO,AMBAR,VIOL=C("0D0C10"),C("1B1A20"),C("33313A"),C("55525D"),C("8A8791"),C("E4DDCF"),C("9B1C1C"),C("D9A520"),C("E07B1F"),C("8A6BB0")
def quant(rgb, pal=PAL):
    a = rgb.reshape(-1,3).astype(np.int32)
    d = ((a[:,None,:]-pal[None,:,:])**2).sum(2)
    return pal[d.argmin(1)].reshape(rgb.shape).astype(np.uint8)
def cut_meta(path):
    """Imagem do Meta AI em fundo cinza -> RGBA só com a figura principal."""
    im = np.array(Image.open(path).convert("RGB")).astype(np.int32)
    bg = np.median(np.concatenate([im[:20].reshape(-1,3), im[-20:].reshape(-1,3)]),0)
    far = np.abs(im-bg).sum(2) > 45
    lab,n = ndi.label(~far)
    border = set(np.unique(np.concatenate([lab[0],lab[-1],lab[:,0],lab[:,-1]]))) - {0}
    fig = ~np.isin(lab, list(border))
    # sombra de chão desenhada: cinza sem cor, na faixa de baixo
    mx, mn = im.max(2), im.min(2)
    ys = np.where(fig.any(1))[0]; y0,y1 = ys[0], ys[-1]
    grey = ((mx-mn) < 14) & (mx > 70) & (mx < 185)
    band = np.zeros_like(fig); band[int(y1-(y1-y0)*0.07):] = True
    fig &= ~(grey & band)
    fig = ndi.binary_opening(fig, iterations=1)
    lab,n = ndi.label(fig)
    sizes = ndi.sum(fig, lab, range(1,n+1)); keep = 1+int(np.argmax(sizes))
    fig = lab == keep
    ys = np.where(fig.any(1))[0]; xs = np.where(fig.any(0))[0]
    rgba = np.dstack([im.astype(np.uint8), (fig*255).astype(np.uint8)])
    return Image.fromarray(rgba[ys[0]:ys[-1]+1, xs[0]:xs[-1]+1], "RGBA")
def to_sprite(img, height):
    """Leva para a grade real: reduz por média, corta o alfa e aplica a paleta única."""
    w = max(1, round(img.width*height/img.height))
    a = np.array(img).astype(np.float64); al = a[...,3:4]/255.0
    pm = Image.fromarray(np.dstack([a[...,:3]*al, a[...,3:4]]).astype(np.uint8), "RGBA")
    sm = np.array(pm.resize((w,height), Image.BOX)).astype(np.float64)
    alpha = sm[...,3] > 128
    rgb = np.clip(sm[...,:3]/np.maximum(sm[...,3:4]/255.0, 0.01), 0, 255)
    q = quant(rgb.astype(np.uint8))
    return np.dstack([q, (alpha*255).astype(np.uint8)])
def rim(sp, color, side):
    """Fio de 1 pixel na borda de um lado (a luz)."""
    al = sp[...,3] > 0; out = sp.copy()
    nb = np.zeros_like(al)
    if side == "left": nb[:,1:] = al[:,:-1]
    else: nb[:,:-1] = al[:,1:]
    edge = al & ~nb
    edge[int(sp.shape[0]*0.9):] = False
    out[edge,:3] = color
    return out
def paste(canvas, sp, cx, ground):
    h,w = sp.shape[:2]; x0 = int(cx-w//2); y0 = ground-h
    for y in range(h):
        yy = y0+y
        if not (0 <= yy < canvas.shape[0]): continue
        for x in range(w):
            xx = x0+x
            if 0 <= xx < canvas.shape[1] and sp[y,x,3]: canvas[yy,xx] = sp[y,x,:3]
    return x0,y0,w,h
W,H,FIELD,GROUND = 640,360,240,214
# cenário
def layer(path, rgba):
    im = Image.open(path).convert("RGBA" if rgba else "RGB").resize((640,270), Image.BOX).crop((0,24,640,264))
    a = np.array(im); q = quant(a[...,:3])
    return q, (a[...,3] > 128 if rgba else np.ones(q.shape[:2],bool))
canvas = np.zeros((H,W,3), np.uint8); canvas[:] = BREU
bq,_ = layer(A+"environments/circles/circle_02/t1/env_circle_02_t1_back.png", False); canvas[:FIELD] = bq
mq,ma = layer(A+"environments/circles/circle_02/t1/env_circle_02_t1_mid.webp", True)
mq = (mq.astype(np.float64)*0.72).astype(np.uint8); mq = quant(mq)
canvas[:FIELD][ma] = mq[ma]
img = Image.fromarray(canvas); d = ImageDraw.Draw(img)
# personagens
saints = [("pixel_ref_jorge_metaai.jpg",112,262),("pixel_ref_bento_metaai.jpg",112,188),("pixel_ref_teresinha_metaai.jpg",104,118)]
enemies = [("enemy_infernal_scarab",92,372,False),("enemy_mud_devil",116,442,False),("enemy_swarm_mother",118,520,False),("enemy_shade_of_desire",118,592,True)]
canvas = np.array(img); sprites = {}
for f,hh,cx in saints:
    sp = rim(to_sprite(cut_meta(P+f), hh), AMBAR, "left"); sprites[f] = sp
    h,w = sp.shape[:2]
    im2 = Image.fromarray(canvas); d2 = ImageDraw.Draw(im2)
    d2.ellipse((cx-w*0.36, GROUND-3, cx+w*0.36, GROUND+3), fill=(0,0,0))
    top = sp[:14,:,3] > 0; xs = np.where(top.any(0))[0]; hx = cx-w//2+int(xs.mean()); hy = GROUND-h+9
    if "bento" in f: hx = cx-w//2+int(w*0.36); hy = GROUND-h+22
    d2.ellipse((hx-11,hy-11,hx+11,hy+11), fill=OURO)
    canvas = np.array(im2); paste(canvas, sp, cx, GROUND)
tops = {}
for name,hh,cx,spirit in enemies:
    sp = to_sprite(Image.open(A+f"characters/enemies/{name}/frames/{name}_idle.webp").convert("RGBA"), hh)
    sp = rim(sp, VIOL, "right"); sprites[name] = sp; h,w = sp.shape[:2]
    if not spirit:
        im2 = Image.fromarray(canvas); ImageDraw.Draw(im2).ellipse((cx-w*0.36, GROUND-3, cx+w*0.36, GROUND+3), fill=(0,0,0)); canvas = np.array(im2)
    paste(canvas, sp, cx, GROUND - (4 if spirit else 0)); tops[name] = (cx, GROUND-h)
img = Image.fromarray(canvas); d = ImageDraw.Draw(img)
font = ImageFont.load_default()
def T(x,y,s,fill=OSSO): d.text((x,y), s, font=font, fill=fill)
# intenções (óculos)
for (name,hh,cx,spirit),(kind,val) in zip(enemies,[("atk","3"),("atk","5"),("inv",""),("cor","")]):
    x,y = cx, tops[name][1]-14
    d.ellipse((x-9,y-9,x+9,y+9), fill=FERRO, outline=SANGUE if kind=="atk" else CH2, width=2)
    if kind=="atk": T(x-2,y-6,val)
    elif kind=="inv": d.arc((x-4,y-4,x+4,y+4),200,520,fill=OSSO)
    else: d.ellipse((x-4,y-2,x+4,y+2),outline=OSSO); d.point((x,y),fill=OSSO)
# lanterna do Lume
d.line((16,8,16,150), fill=CH2); d.rectangle((9,60,23,82), fill=FERRO, outline=CH2); d.polygon([(16,64),(20,72),(16,79),(12,72)], fill=AMBAR)
T(280,4,"Rodada 1"); T(352,4,"+8", fill=CINZA)
# painel de ferro
d.rectangle((0,FIELD,W-1,H-1), fill=FERRO, outline=CHUMBO, width=2)
for x in (5,W-6):
    for y in (FIELD+5,H-6): d.point((x,y), fill=CINZA)
# retrato em arco
ax,ay = 10,250
d.polygon([(ax,ay+62),(ax,ay+22),(ax+8,ay+8),(ax+22,ay),(ax+36,ay+8),(ax+44,ay+22),(ax+44,ay+62)], fill=BREU, outline=CH2)
head = cut_meta(P+"pixel_ref_jorge_metaai.jpg"); hw = head.width
hc = to_sprite(head.crop((int(hw*0.18),0,int(hw*0.62),int(head.height*0.27))), 50)
pim = np.array(img); 
for y in range(hc.shape[0]):
    for x in range(min(hc.shape[1],38)):
        if hc[y,x,3]: pim[ay+10+y, ax+3+x] = hc[y,x,:3]
img = Image.fromarray(pim); d = ImageDraw.Draw(img)
d.line([(ax,ay+62),(ax,ay+22),(ax+8,ay+8),(ax+22,ay),(ax+36,ay+8),(ax+44,ay+22),(ax+44,ay+62),(ax,ay+62)], fill=CH2, width=2)
T(64,246,"Sao Jorge"); T(64,258,"Vida 32/32", fill=CINZA)
# lancetas (habilidades) com ícones em linha de osso
def lanceta(x,y,state,icon):
    glass = {0:(26,25,30),1:CHUMBO,2:AMBAR}[state]
    pts = [(x,y+36),(x,y+12),(x+5,y+4),(x+11,y),(x+17,y+4),(x+22,y+12),(x+22,y+36)]
    d.polygon(pts, fill=glass, outline=OSSO if state==2 else CH2)
    for k in range(-2,5): 
        d.line((x+1,y+6+k*9,x+21,y+16+k*9), fill=BREU if state!=2 else (122,61,16))
    d.polygon(pts, outline=OSSO if state==2 else CH2)
    c = BREU if state==2 else (OSSO if state==1 else CH2); cx,cy = x+11,y+20
    if icon=="golpe": d.line((cx-5,cy+6,cx+5,cy-6),fill=c,width=2); d.line((cx+5,cy-6,cx+1,cy-5),fill=c); d.line((cx+5,cy-6,cx+4,cy-2),fill=c)
    if icon=="escudo": d.polygon([(cx,cy-7),(cx+6,cy-4),(cx+6,cy+2),(cx,cy+7),(cx-6,cy+2),(cx-6,cy-4)],outline=c)
    if icon=="cruz": d.line((cx,cy-7,cx,cy+7),fill=c,width=2); d.line((cx-5,cy-2,cx+5,cy-2),fill=c,width=2)
    if icon=="chama": d.polygon([(cx,cy-7),(cx+4,cy),(cx+2,cy+6),(cx-3,cy+6),(cx-4,cy+1)],outline=c)
for i,(st,ic) in enumerate([(1,"golpe"),(2,"golpe"),(1,"escudo"),(0,"chama")]): lanceta(64+i*27,274,st,ic)
# rosácea do milagre (acesa)
rx,ry = 196,292
d.ellipse((rx-17,ry-17,rx+17,ry+17), fill=FERRO, outline=CH2, width=2)
for k in range(8):
    import math
    a0 = math.radians(k*45+4); a1 = math.radians(k*45+41)
    d.polygon([(rx+5*math.cos(a0),ry+5*math.sin(a0)),(rx+14*math.cos(a0),ry+14*math.sin(a0)),(rx+14*math.cos(a1),ry+14*math.sin(a1)),(rx+5*math.cos(a1),ry+5*math.sin(a1))], fill=OURO)
d.ellipse((rx-3,ry-3,rx+3,ry+3), fill=FERRO, outline=CH2)
# porta-velas (Fervor 4/6)
d.rectangle((62,346,150,348), fill=CHUMBO)
for k in range(6):
    x = 66+k*14; d.rectangle((x,334,x+6,345), fill=(207,199,182), outline=BREU)
    if k<4: d.polygon([(x+3,324),(x+6,330),(x+3,333),(x,330)], fill=AMBAR)
# botões comuns
for i,s in enumerate(["Trocar","Passar"]):
    x = 162+i*46; d.rectangle((x,318,x+42,332), fill=BREU, outline=CH2); T(x+4,320,s)
d.rectangle((162,336,250,350), fill=BREU, outline=CH2); T(166,338,"Interceder", fill=OURO)
# alforje
for k,(n,on) in enumerate([("2",1),("1",0),("2",1),("1",1),("1",0)]):
    x = 268+k*20; d.line((x+7,250,x+7,256), fill=CINZA)
    d.rounded_rectangle((x,256,x+14,276), radius=4, fill=BREU, outline=CINZA if on else CHUMBO); T(x+4,260,n, fill=OSSO if on else CH2)
T(268,280,"Alforje", fill=CINZA)
# ficha do inimigo: moldura quebrada
d.polygon([(384,248),(628,245),(634,270),(630,348),(560,352),(552,346),(388,350),(380,300)], fill=BREU, outline=CH2)
mini = to_sprite(Image.open(A+"characters/enemies/enemy_mud_devil/frames/enemy_mud_devil_idle.webp").convert("RGBA"), 84)
pim = np.array(img); paste(pim, mini, 422, 344); img = Image.fromarray(pim); d = ImageDraw.Draw(img)
T(466,252,"Diabo de Lodo"); T(466,266,"Vida 36/36", fill=CINZA); T(466,280,"Ataque 5 na posicao 1", fill=CINZA)
d.rectangle((540,328,624,343), fill=FERRO, outline=CH2); T(546,331,"Encerrar turno")
img.save(OUT+"/pixel_piloto_combate_640x360.png")
img.resize((W*3,H*3), Image.NEAREST).save(OUT+"/pixel_piloto_combate_x3.png")
# comparação: desenho do Meta AI x sprite na grade real
sh = Image.new("RGB",(3*440, 400),(44,43,48)); ds = ImageDraw.Draw(sh)
for i,(f,hh,cx) in enumerate(saints):
    o = Image.open(P+f).convert("RGB"); o.thumbnail((200,340)); sh.paste(o,(i*440+10,40))
    sp = Image.fromarray(sprites[f],"RGBA"); big = sp.resize((sp.width*3,sp.height*3), Image.NEAREST)
    sh.paste(big,(i*440+225, 384-big.height), big)
    ds.text((i*440+10,12),"desenho (Meta AI)",fill=(228,221,207)); ds.text((i*440+225,12),"sprite na grade real, 3x",fill=(228,221,207))
sh.save(OUT+"/pixel_piloto_santos_comparacao.png")
print("ok")
