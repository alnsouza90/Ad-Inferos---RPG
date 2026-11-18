"""village_lights.py: the mask of the lit windows, torches, forge and candles of the village picture (D-493). Run from the repository root."""
import numpy as np
from PIL import Image, ImageDraw, ImageFilter
P={
"library":[(283,57),(287,84),(305,84),(305,200),(313,205),(313,222),(267,222),(266,84),(279,84)],
"cathedral":[(378,18),(388,70),(392,95),(415,85),(440,100),(470,92),(466,70),(476,20),(484,70),(492,140),(510,175),(518,200),(520,278),(318,278),(320,200),(336,160),(345,120),(358,110),(368,70)],
"carmel":[(556,136),(566,155),(632,158),(640,185),(640,232),(530,232),(522,222),(530,195),(535,165),(548,158)],
"garden":[(180,262),(210,242),(330,242),(332,262),(332,320),(320,335),(180,315)],
"infirmary":[(110,375),(130,340),(255,337),(282,375),(282,420),(240,440),(115,420)],
"retreat_house":[(160,440),(205,420),(250,420),(312,445),(312,500),(250,515),(165,505)],
"forge":[(460,302),(478,287),(520,290),(535,305),(535,355),(462,355)],
"pantry":[(578,285),(560,320),(552,330),(552,370),(560,392),(660,392),(662,340),(655,290),(605,282)],
"gate":[(705,262),(745,262),(745,290),(800,282),(802,360),(760,368),(702,350)],
"reliquary":[(672,357),(700,400),(702,445),(690,452),(642,452),(640,405)],
"_ambient_house":[(305,335),(345,330),(395,345),(400,400),(310,400)],
"_statue":[(440,360),(480,360),(500,420),(540,450),(420,470),(400,440)],
}
im=Image.open("game/assets/pixel/environments/village/village_hub.png").convert("RGB")
a=np.array(im).astype(float)
r,g,b=a[...,0],a[...,1],a[...,2]
m=Image.new("L",im.size,0); d=ImageDraw.Draw(m)
for k,p in P.items(): d.polygon(p,fill=255)
region=np.array(m)>0
sat=(r-b)/np.maximum(r,1)
light=(sat>0.38)&(r>140)&((g-b)>25)&region
out=Image.fromarray((light*255).astype(np.uint8),"L")
out.save("game/assets/pixel/environments/village/village_hub_lights.png")
print("lit", light.sum())
prev=im.copy(); prev.paste(Image.new("RGB",im.size,(255,0,255)),mask=out); pass
