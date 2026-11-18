"""village_outlines.py: separates the outline Alan drew around each building from the village picture and cleans what remains of it (D-495). Paths are of the session that made it; kept to redo the cut."""
import numpy as np
from PIL import Image, ImageFilter
V="/tmp/claude-0/-home-user-Ad-Inferos---RPG/f19b5c26-378f-563c-b3af-ebfc8a79fefe/scratchpad/vila5"
im=Image.open(V+"/v.png").convert("RGBA")
W,H=3840,2160
im2=im.resize((W,H),Image.BOX)
a=np.array(im2).astype(np.float32)
rgb=a[...,:3]; al=a[...,3]
white=(rgb.min(2)>190)&((rgb.max(2)-rgb.min(2))<40)&(al>30)
violet=(rgb[...,2]>rgb[...,1]+30)&(rgb[...,0]>rgb[...,1]+10)&(al>20)
wm=Image.fromarray((white*255).astype(np.uint8))
opened=wm.filter(ImageFilter.MinFilter(7)).filter(ImageFilter.MaxFilter(7))
line=(np.array(wm)>0)&~(np.array(opened)>0)
# Near the outside (transparency), every light pixel is the outline's.
trans=Image.fromarray(((al<40)*255).astype(np.uint8)).filter(ImageFilter.MaxFilter(9))
edge_light=(np.array(trans)>0)&(rgb.min(2)>150)&(al>0)
mask=line|violet|edge_light
Image.fromarray((mask*255).astype(np.uint8)).save(V+"/outline_3840.png")
grow=np.array(Image.fromarray((mask*255).astype(np.uint8)).filter(ImageFilter.MaxFilter(5)))>0
a[...,:3]*=a[...,3:4]/255
known=~grow; val=a.copy(); val[~known]=0
for it in range(16):
    s=np.zeros_like(val); c=np.zeros((H,W),np.float32)
    for dy in (-1,0,1):
        for dx in (-1,0,1):
            if dy==0 and dx==0: continue
            k=np.roll(np.roll(known,dy,0),dx,1)
            s+=np.roll(np.roll(val,dy,0),dx,1)*k[...,None]; c+=k
    fill=(~known)&(c>0)
    val[fill]=s[fill]/c[fill][:,None]; known|=fill
    if known.all(): break
out=val; al2=np.clip(out[...,3],0,255)
out[...,:3]=np.where(al2[...,None]>0,out[...,:3]/np.maximum(al2[...,None],1)*255,0)
clean=Image.fromarray(np.clip(out,0,255).astype(np.uint8),"RGBA")
small=clean.resize((960,540),Image.LANCZOS)
sa=np.array(small); sa[...,3]=np.where(sa[...,3]<110,0,255)
Image.fromarray(sa,"RGBA").save(V+"/out/village.png")
mm=Image.open(V+"/outline_3840.png").resize((960,540),Image.BOX)
Image.fromarray(((np.array(mm)>30)*255).astype(np.uint8)).save(V+"/outline_960.png")
print("ok")
