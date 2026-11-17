# Retratos dos santos e cenários do Pouso e da Vigília em pixel art: prompts

Pedido de Alan (17/11/2026, D-429). Montados a partir dos prompts aprovados: retratos de `docs/fable/prompts-pixel-m2.md` §2.7 (modelo) com as descrições de §2.1 a §2.3; cenários de §5.2 (estilo da camada) e §5.3 (lugares do Pouso e da Vigília). Gerar no Meta AI; eu converto para a grade do jogo.

## Retratos (3:4, fundo cinza para recorte)

Usados no Pouso, na Vigília, no arco do retrato da luta e na ficha. Sem auréola (o motor desenha). Para os outros dois estados, troque só a expressão:

- Noite Escura: `anguished exhausted expression, eyes downcast`
- Consolação: `serene peaceful expression`

### São Jorge

```text
dark gothic pixel art portrait, 16-bit style, in the style of Blasphemous with the grim mood of Darkest Dungeon, head and shoulders, three-quarter view facing right, Saint George as a young beardless Roman military officer of the late 3rd century with short curly hair, dark bronze muscle cuirass, not gold, red paludamentum cloak over the shoulders, determined resolute expression, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows engulfing half the face, limited palette of about 24 muted desaturated colors, dark bronze, bone, ash grey, black and deep red, selective dithering only in the shadows, no anti-aliasing, a thin warm amber rim light of single pixels along the back edge, isolated on a plain flat solid light grey background --ar 3:4 --no halo, gold, golden armor, blood, blur, smooth shading, anti-aliasing, gradient, painterly, 3D, photorealistic, cartoon, chibi, anime, text, frame, watermark
```

### São Bento

```text
dark gothic pixel art portrait, 16-bit style, in the style of Blasphemous with the grim mood of Darkest Dungeon, head and shoulders, three-quarter view facing right, Saint Benedict of Nursia as an elderly 6th-century abbot with a long white beard and white hair, black Benedictine habit with the hood down, the black habit drawn in dark charcoal greys so its folds are readable, a raven perched on his shoulder, serene firm expression, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows engulfing half the face, limited palette of about 24 muted desaturated colors, charcoal, bone, ash grey, black and brown, warm natural skin tones, selective dithering only in the shadows, no anti-aliasing, a thin warm amber rim light of single pixels along the back edge, isolated on a plain flat solid light grey background --ar 3:4 --no halo, gold, grey skin, blood, blur, smooth shading, anti-aliasing, gradient, painterly, 3D, photorealistic, cartoon, chibi, anime, text, frame, watermark
```

### Santa Teresinha

```text
dark gothic pixel art portrait, 16-bit style, in the style of Blasphemous with the grim mood of Darkest Dungeon, head and shoulders, three-quarter view facing right, Saint Therese of Lisieux as a young 19th-century Carmelite nun with a gentle round face, black veil over white wimple, brown habit and white mantle, a simple wooden crucifix wrapped in red roses held against her chest, drawn at the same pixel size as the rest, simple confident expression, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows engulfing half the face, limited palette of about 24 muted desaturated colors, brown, bone, ash grey, black and deep rose red, warm natural skin tones, selective dithering only in the shadows, no anti-aliasing, a thin warm amber rim light of single pixels along the back edge, isolated on a plain flat solid light grey background --ar 3:4 --no halo, gold, falling petals, blood, blur, smooth shading, anti-aliasing, gradient, painterly, 3D, photorealistic, cartoon, chibi, anime, text, frame, watermark
```

## Pouso (três camadas para o parallax, 16:9)

Sem fogo e sem santos: a fogueira é efeito do motor e os santos sentados são as poses que você já fez. O centro de baixo fica livre para a fogueira, e as laterais para os santos.

### Fundo

```text
dark gothic pixel art game background, 16-bit style, in the style of Blasphemous with the grim mood of Darkest Dungeon, side view, the far back wall of a shallow cave sheltered from an eternal storm, through a wide cave mouth on the right the howling storm sky of spiralling clouds far away, painted only in black, dark brown, ash grey and bone, the cave wall faintly lit by warm amber light from below, a single consistent pixel size, crisp hard pixel edges, large flat dark shapes, selective dithering in the shadows, no anti-aliasing, the lower third very dark and empty --ar 16:9 --no characters, people, creatures, fire, flames, campfire, bright colors, saturated purple, blur, smooth gradient, painterly, 3D, photorealistic, text, UI, watermark
```

### Meio (onde os santos se sentam)

```text
dark gothic pixel art game background layer, 16-bit style, in the style of Blasphemous with the grim mood of Darkest Dungeon, side view, the inside of a shallow cave sheltered from the storm, a flat dirt floor with a ring of blackened stones empty at the center, bedrolls and a few low stones to sit on against the rock at both sides, the left and right edges drawn so the image can repeat seamlessly, painted in black and dark brown with warm amber light falling on the upper edges of the stones from the center, a flat empty floor strip along the bottom, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, selective dithering in the shadows, no anti-aliasing, isolated on a plain flat solid light grey background above the rocks --ar 16:9 --no characters, people, creatures, fire, flames, campfire, smoke, bright colors, saturated purple, blur, smooth gradient, painterly, 3D, photorealistic, text, UI, watermark
```

### Frente (só nos cantos de baixo)

```text
dark gothic pixel art game foreground layer, 16-bit style, in the style of Blasphemous with the grim mood of Darkest Dungeon, side view, jagged dark rocks of a cave mouth and hanging torn cloth in the two lower corners only, the whole center empty, painted almost black with a faint warm amber edge light, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, no anti-aliasing, isolated on a plain flat solid light grey background --ar 16:9 --no characters, people, creatures, fire, flames, bright colors, blur, smooth gradient, painterly, 3D, photorealistic, text, UI, watermark
```

## Vigília (três camadas, 16:9)

Mesmo jogo de camadas; a Vigília é a última noite antes de Asmodeu.

### Fundo

```text
dark gothic pixel art game background, 16-bit style, in the style of Blasphemous with the grim mood of Darkest Dungeon, side view, a colossal dark gothic gate of black stone rising far away on the right inside the eye of a vast storm, spiralling clouds around it, painted only in black, ash grey and bone, lit by a dim stormy violet glow from the far distance, a single consistent pixel size, crisp hard pixel edges, large flat dark shapes, selective dithering in the clouds, no anti-aliasing, the lower third very dark and empty --ar 16:9 --no characters, people, creatures, fire, flames, bright colors, saturated purple, warm light, blur, smooth gradient, painterly, 3D, photorealistic, text, UI, watermark
```

### Meio (onde os santos velam)

```text
dark gothic pixel art game background layer, 16-bit style, in the style of Blasphemous with the grim mood of Darkest Dungeon, side view, a small rock shelter of leaning black slabs on flat ground, a ring of blackened stones empty at the center, low stones to sit on at both sides, the left and right edges drawn so the image can repeat seamlessly, painted in black and ash grey with one small warm amber light falling on the stones from the center and faint stormy violet light on the upper edges, a flat empty floor strip along the bottom, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, selective dithering in the shadows, no anti-aliasing, isolated on a plain flat solid light grey background above the rocks --ar 16:9 --no characters, people, creatures, fire, flames, campfire, bright colors, saturated purple, blur, smooth gradient, painterly, 3D, photorealistic, text, UI, watermark
```

### Frente (só nos cantos de baixo)

```text
dark gothic pixel art game foreground layer, 16-bit style, in the style of Blasphemous with the grim mood of Darkest Dungeon, side view, broken black rock slabs and dead thorn bushes in the two lower corners only, the whole center empty, painted almost black with faint stormy violet edge light, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, no anti-aliasing, isolated on a plain flat solid light grey background --ar 16:9 --no characters, people, creatures, fire, flames, bright colors, blur, smooth gradient, painterly, 3D, photorealistic, text, UI, watermark
```
