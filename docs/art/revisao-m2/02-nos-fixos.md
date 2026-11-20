# Nós fixos do Círculo 2 · prompts para o Meta AI (revisão do M2, versão 2)

Os lugares sempre iguais no círculo; só as batalhas são sorteadas. Cada nó tem **quatro camadas**, e cada camada leva **só a sua parte**. A coisa principal do nó (a tenda, o trono, a porta) aparece **só na camada "cena"**.

**Para todos os prompts deste arquivo:**
- **Estilo:** o mesmo da vila, do Mapa do Inferno e dos guardiões: pixel art de *Blasphemous* com o gótico de *Darkest Dungeon*, sem o lado contraventor.
- **Uma coisa por camada.** Cada prompt descreve **só** o que pertence àquela camada e **proíbe** o que pertence às outras. O fundo não tem chão; a pista não tem paredes; a cena principal (a tenda, o trono, a ponte) aparece **numa camada só**.
- **Feito pelo motor (não entra na imagem):** o filtro do círculo, a luz das tochas, o vento animado, as almas e as auréolas.
- **Sem pessoas:** santos, inimigos e almas entram separados.
- **Escala:** na tela do jogo (960 × 540), um santo tem **cerca de 166 px de altura** e pisa a **338 px do alto**.
- **Como enviar:** gere, escolha e me envie; eu recorto, reduzo, confiro as emendas e mostro peça por peça.

| Camada | Só isto | Formato |
| --- | --- | --- |
| **Fundo** | Céu e o que está muito longe | 21:9, imagem cheia |
| **Cena** | A coisa principal do nó, sem o chão | 21:9, fundo cinza |
| **Pista** | Só o chão | 21:9, fundo cinza |
| **Primeiro plano** | Duas peças soltas, perto da câmera, uma em cada borda | 21:9, fundo cinza |

## Entrada do Trecho 1 · o trono de Minos ao fundo

*Peça única no começo da expedição.*

**Fundo**

```text
dark gothic pixel art, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, the far background of a side-scrolling game seen from the side, a dark howling hurricane sky of the second circle of Dante's Hell, heavy violet and ash grey storm clouds swirling, streaks of wind, flying ash, far away on the horizon a high cliff with the colossal dark stone throne of Minos, empty, lit by a dim red glow, only what is very far away, the lower fifth fading into dark mist, the left and right edges fading into the storm, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey, warm amber and stormy violet, warm amber light from the left, selective dithering in the shadows, no anti-aliasing --ar 21:9 --no ground, floor, path, tent, stairs, doors, gates, nearby objects, buildings in the front, text, letters, numbers, signs, people, characters, figures, saints, demons, flat gold, blue sky, gore, blood, nudity, grotesque, profane imagery, blur, smooth shading, painterly, 3D, photorealistic, cartoon, watermark, frame, border, vignette
```

**Cena**

```text
dark gothic pixel art, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, a single scene element for a side-scrolling game seen from the side, a dark rocky ledge where the path begins, a few broken stone markers and a low rock arch at the right side, standing centered with empty space around it, its base cut flat along the bottom edge, nothing in front of it, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey, warm amber and stormy violet, warm amber light from the left, selective dithering in the shadows, no anti-aliasing, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal --ar 21:9 --no sky, clouds, storm, ground strip, foreground objects, text, letters, numbers, signs, people, characters, figures, saints, demons, flat gold, blue sky, gore, blood, nudity, grotesque, profane imagery, blur, smooth shading, painterly, 3D, photorealistic, cartoon, watermark, frame, border, vignette
```

**Pista**

```text
dark gothic pixel art, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, only a long horizontal strip of ground seen from the side for a side-scrolling game, the flat rocky floor of the ledge, the walkable top surface flat and level, the strip filling only the lower third of the image, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey, warm amber and stormy violet, warm amber light from the left, selective dithering in the shadows, no anti-aliasing, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal --ar 21:9 --no tent, stairs, doors, gates, arches, columns, walls, rocks standing up, sky, objects above the ground, text, letters, numbers, signs, people, characters, figures, saints, demons, flat gold, blue sky, gore, blood, nudity, grotesque, profane imagery, blur, smooth shading, painterly, 3D, photorealistic, cartoon, watermark, frame, border, vignette
```

**Primeiro plano**

```text
dark gothic pixel art, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, two separate foreground objects for a side-scrolling game, very close to the camera and almost dark silhouettes with a thin warm rim light: a tall dark rock leaning in from the left edge, and a broken stone marker post at the right edge, the center of the image completely empty, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey, warm amber and stormy violet, warm amber light from the left, selective dithering in the shadows, no anti-aliasing, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal --ar 21:9 --no sky, ground strip, tent, stairs, doors, gates, the main building, anything in the center, text, letters, numbers, signs, people, characters, figures, saints, demons, flat gold, blue sky, gore, blood, nudity, grotesque, profane imagery, blur, smooth shading, painterly, 3D, photorealistic, cartoon, watermark, frame, border, vignette
```

## Tentação · a tenda (refeita)

*Igual em todo o círculo. A tenda nova substitui a atual.*

**Fundo**

```text
dark gothic pixel art, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, the far background of a side-scrolling game seen from the side, a dark howling hurricane sky of the second circle of Dante's Hell, heavy violet and ash grey storm clouds swirling, streaks of wind, flying ash, far dark rock walls closing around a hollow, the storm high above, only what is very far away, the lower fifth fading into dark mist, the left and right edges fading into the storm, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey, warm amber and stormy violet, warm amber light from the left, selective dithering in the shadows, no anti-aliasing --ar 21:9 --no ground, floor, path, tent, stairs, doors, gates, nearby objects, buildings in the front, text, letters, numbers, signs, people, characters, figures, saints, demons, flat gold, blue sky, gore, blood, nudity, grotesque, profane imagery, blur, smooth shading, painterly, 3D, photorealistic, cartoon, watermark, frame, border, vignette
```

**Cena**

```text
dark gothic pixel art, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, a single scene element for a side-scrolling game seen from the side, a rich but faded tent of heavy dark red and violet cloth with tattered golden trims, cushions and an unlit brazier at its open front, inviting and wrong at the same time, standing centered with empty space around it, its base cut flat along the bottom edge, nothing in front of it, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey, warm amber and stormy violet, warm amber light from the left, selective dithering in the shadows, no anti-aliasing, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal --ar 21:9 --no sky, clouds, storm, ground strip, foreground objects, text, letters, numbers, signs, people, characters, figures, saints, demons, flat gold, blue sky, gore, blood, nudity, grotesque, profane imagery, blur, smooth shading, painterly, 3D, photorealistic, cartoon, watermark, frame, border, vignette
```

**Pista**

```text
dark gothic pixel art, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, only a long horizontal strip of ground seen from the side for a side-scrolling game, soft dust and scattered fallen petals on the rock floor of a sheltered hollow, the walkable top surface flat and level, the strip filling only the lower third of the image, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey, warm amber and stormy violet, warm amber light from the left, selective dithering in the shadows, no anti-aliasing, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal --ar 21:9 --no tent, stairs, doors, gates, arches, columns, walls, rocks standing up, sky, objects above the ground, text, letters, numbers, signs, people, characters, figures, saints, demons, flat gold, blue sky, gore, blood, nudity, grotesque, profane imagery, blur, smooth shading, painterly, 3D, photorealistic, cartoon, watermark, frame, border, vignette
```

**Primeiro plano**

```text
dark gothic pixel art, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, two separate foreground objects for a side-scrolling game, very close to the camera and almost dark silhouettes with a thin warm rim light: a torn piece of red cloth caught on a rock at the left edge, and a toppled brass lamp at the right edge, the center of the image completely empty, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey, warm amber and stormy violet, warm amber light from the left, selective dithering in the shadows, no anti-aliasing, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal --ar 21:9 --no sky, ground strip, tent, stairs, doors, gates, the main building, anything in the center, text, letters, numbers, signs, people, characters, figures, saints, demons, flat gold, blue sky, gore, blood, nudity, grotesque, profane imagery, blur, smooth shading, painterly, 3D, photorealistic, cartoon, watermark, frame, border, vignette
```

## Encontro com a alma

*Igual em todo o círculo; só a alma muda. As almas do fundo o motor anima.*

**Fundo**

```text
dark gothic pixel art, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, the far background of a side-scrolling game seen from the side, a dark howling hurricane sky of the second circle of Dante's Hell, heavy violet and ash grey storm clouds swirling, streaks of wind, flying ash, a faint pale light falling from a break in the clouds, only what is very far away, the lower fifth fading into dark mist, the left and right edges fading into the storm, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey, warm amber and stormy violet, warm amber light from the left, selective dithering in the shadows, no anti-aliasing --ar 21:9 --no ground, floor, path, tent, stairs, doors, gates, nearby objects, buildings in the front, text, letters, numbers, signs, people, characters, figures, saints, demons, flat gold, blue sky, gore, blood, nudity, grotesque, profane imagery, blur, smooth shading, painterly, 3D, photorealistic, cartoon, watermark, frame, border, vignette
```

**Cena**

```text
dark gothic pixel art, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, a single scene element for a side-scrolling game seen from the side, a leaning natural rock arch over a flat stone where a lost soul can stand, standing centered with empty space around it, its base cut flat along the bottom edge, nothing in front of it, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey, warm amber and stormy violet, warm amber light from the left, selective dithering in the shadows, no anti-aliasing, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal --ar 21:9 --no sky, clouds, storm, ground strip, foreground objects, text, letters, numbers, signs, people, characters, figures, saints, demons, flat gold, blue sky, gore, blood, nudity, grotesque, profane imagery, blur, smooth shading, painterly, 3D, photorealistic, cartoon, watermark, frame, border, vignette
```

**Pista**

```text
dark gothic pixel art, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, only a long horizontal strip of ground seen from the side for a side-scrolling game, a calm patch of rock floor with pale dust lying still, the walkable top surface flat and level, the strip filling only the lower third of the image, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey, warm amber and stormy violet, warm amber light from the left, selective dithering in the shadows, no anti-aliasing, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal --ar 21:9 --no tent, stairs, doors, gates, arches, columns, walls, rocks standing up, sky, objects above the ground, text, letters, numbers, signs, people, characters, figures, saints, demons, flat gold, blue sky, gore, blood, nudity, grotesque, profane imagery, blur, smooth shading, painterly, 3D, photorealistic, cartoon, watermark, frame, border, vignette
```

**Primeiro plano**

```text
dark gothic pixel art, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, two separate foreground objects for a side-scrolling game, very close to the camera and almost dark silhouettes with a thin warm rim light: a thin dead tree at the left edge, and a low pale stone at the right edge, the center of the image completely empty, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey, warm amber and stormy violet, warm amber light from the left, selective dithering in the shadows, no anti-aliasing, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal --ar 21:9 --no sky, ground strip, tent, stairs, doors, gates, the main building, anything in the center, text, letters, numbers, signs, people, characters, figures, saints, demons, flat gold, blue sky, gore, blood, nudity, grotesque, profane imagery, blur, smooth shading, painterly, 3D, photorealistic, cartoon, watermark, frame, border, vignette
```

## Pré-guardião · diante do Júri de Minos

*Fim do Trecho 1, antes de Minos; pode ter uma luta.*

**Fundo**

```text
dark gothic pixel art, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, the far background of a side-scrolling game seen from the side, a dark howling hurricane sky of the second circle of Dante's Hell, heavy violet and ash grey storm clouds swirling, streaks of wind, flying ash, far behind the dark mass of a great hall built into a mountain, only what is very far away, the lower fifth fading into dark mist, the left and right edges fading into the storm, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey, warm amber and stormy violet, warm amber light from the left, selective dithering in the shadows, no anti-aliasing --ar 21:9 --no ground, floor, path, tent, stairs, doors, gates, nearby objects, buildings in the front, text, letters, numbers, signs, people, characters, figures, saints, demons, flat gold, blue sky, gore, blood, nudity, grotesque, profane imagery, blur, smooth shading, painterly, 3D, photorealistic, cartoon, watermark, frame, border, vignette
```

**Cena**

```text
dark gothic pixel art, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, a single scene element for a side-scrolling game seen from the side, a wide stair of dark stone climbing to colossal bronze doors carved with coiled serpents, two tall standing torches beside the doors, standing centered with empty space around it, its base cut flat along the bottom edge, nothing in front of it, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey, warm amber and stormy violet, warm amber light from the left, selective dithering in the shadows, no anti-aliasing, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal --ar 21:9 --no sky, clouds, storm, ground strip, foreground objects, text, letters, numbers, signs, people, characters, figures, saints, demons, flat gold, blue sky, gore, blood, nudity, grotesque, profane imagery, blur, smooth shading, painterly, 3D, photorealistic, cartoon, watermark, frame, border, vignette
```

**Pista**

```text
dark gothic pixel art, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, only a long horizontal strip of ground seen from the side for a side-scrolling game, the flat dark stone forecourt at the foot of the stair, the walkable top surface flat and level, the strip filling only the lower third of the image, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey, warm amber and stormy violet, warm amber light from the left, selective dithering in the shadows, no anti-aliasing, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal --ar 21:9 --no tent, stairs, doors, gates, arches, columns, walls, rocks standing up, sky, objects above the ground, text, letters, numbers, signs, people, characters, figures, saints, demons, flat gold, blue sky, gore, blood, nudity, grotesque, profane imagery, blur, smooth shading, painterly, 3D, photorealistic, cartoon, watermark, frame, border, vignette
```

**Primeiro plano**

```text
dark gothic pixel art, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, two separate foreground objects for a side-scrolling game, very close to the camera and almost dark silhouettes with a thin warm rim light: a broken bronze serpent statue at the left edge, and a fallen torch stand at the right edge, the center of the image completely empty, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey, warm amber and stormy violet, warm amber light from the left, selective dithering in the shadows, no anti-aliasing, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal --ar 21:9 --no sky, ground strip, tent, stairs, doors, gates, the main building, anything in the center, text, letters, numbers, signs, people, characters, figures, saints, demons, flat gold, blue sky, gore, blood, nudity, grotesque, profane imagery, blur, smooth shading, painterly, 3D, photorealistic, cartoon, watermark, frame, border, vignette
```

## Júri de Minos · o salão

*O Júri atual pode ser refeito aqui, se você quiser; senão fica como está.*

**Fundo**

```text
dark gothic pixel art, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, the far background of a side-scrolling game seen from the side, the dark vaulted ceiling of a vast hall disappearing into blackness, chains hanging from the dark, a dim red glow from above, only what is very far away, the lower fifth fading into dark mist, the left and right edges fading into the storm, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey, warm amber and stormy violet, warm amber light from the left, selective dithering in the shadows, no anti-aliasing --ar 21:9 --no ground, floor, path, tent, stairs, doors, gates, nearby objects, buildings in the front, text, letters, numbers, signs, people, characters, figures, saints, demons, flat gold, blue sky, gore, blood, nudity, grotesque, profane imagery, blur, smooth shading, painterly, 3D, photorealistic, cartoon, watermark, frame, border, vignette
```

**Cena**

```text
dark gothic pixel art, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, a single scene element for a side-scrolling game seen from the side, at the back of the hall the high seat of judgment of Minos carved into the rock wall, empty, between tall dark pillars, standing centered with empty space around it, its base cut flat along the bottom edge, nothing in front of it, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey, warm amber and stormy violet, warm amber light from the left, selective dithering in the shadows, no anti-aliasing, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal --ar 21:9 --no sky, clouds, storm, ground strip, foreground objects, text, letters, numbers, signs, people, characters, figures, saints, demons, flat gold, blue sky, gore, blood, nudity, grotesque, profane imagery, blur, smooth shading, painterly, 3D, photorealistic, cartoon, watermark, frame, border, vignette
```

**Pista**

```text
dark gothic pixel art, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, only a long horizontal strip of ground seen from the side for a side-scrolling game, a floor of polished black stone reflecting red light, the walkable top surface flat and level, the strip filling only the lower third of the image, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey, warm amber and stormy violet, warm amber light from the left, selective dithering in the shadows, no anti-aliasing, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal --ar 21:9 --no tent, stairs, doors, gates, arches, columns, walls, rocks standing up, sky, objects above the ground, text, letters, numbers, signs, people, characters, figures, saints, demons, flat gold, blue sky, gore, blood, nudity, grotesque, profane imagery, blur, smooth shading, painterly, 3D, photorealistic, cartoon, watermark, frame, border, vignette
```

**Primeiro plano**

```text
dark gothic pixel art, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, two separate foreground objects for a side-scrolling game, very close to the camera and almost dark silhouettes with a thin warm rim light: a massive dark pillar at the left edge, and a hanging heavy chain at the right edge, the center of the image completely empty, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey, warm amber and stormy violet, warm amber light from the left, selective dithering in the shadows, no anti-aliasing, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal --ar 21:9 --no sky, ground strip, tent, stairs, doors, gates, the main building, anything in the center, text, letters, numbers, signs, people, characters, figures, saints, demons, flat gold, blue sky, gore, blood, nudity, grotesque, profane imagery, blur, smooth shading, painterly, 3D, photorealistic, cartoon, watermark, frame, border, vignette
```

## Pouso dos trechos 1 e 2

*Os santos sentados e a fogueira o motor põe (as poses já existem).*

**Fundo**

```text
dark gothic pixel art, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, the far background of a side-scrolling game seen from the side, a dark howling hurricane sky of the second circle of Dante's Hell, heavy violet and ash grey storm clouds swirling, streaks of wind, flying ash, seen through the mouth of a cave, only what is very far away, the lower fifth fading into dark mist, the left and right edges fading into the storm, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey, warm amber and stormy violet, warm amber light from the left, selective dithering in the shadows, no anti-aliasing --ar 21:9 --no ground, floor, path, tent, stairs, doors, gates, nearby objects, buildings in the front, text, letters, numbers, signs, people, characters, figures, saints, demons, flat gold, blue sky, gore, blood, nudity, grotesque, profane imagery, blur, smooth shading, painterly, 3D, photorealistic, cartoon, watermark, frame, border, vignette
```

**Cena**

```text
dark gothic pixel art, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, a single scene element for a side-scrolling game seen from the side, the inside walls of a sheltered cave with a small carved cross on the rock, worn blankets folded against the wall, standing centered with empty space around it, its base cut flat along the bottom edge, nothing in front of it, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey, warm amber and stormy violet, warm amber light from the left, selective dithering in the shadows, no anti-aliasing, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal --ar 21:9 --no sky, clouds, storm, ground strip, foreground objects, text, letters, numbers, signs, people, characters, figures, saints, demons, flat gold, blue sky, gore, blood, nudity, grotesque, profane imagery, blur, smooth shading, painterly, 3D, photorealistic, cartoon, watermark, frame, border, vignette
```

**Pista**

```text
dark gothic pixel art, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, only a long horizontal strip of ground seen from the side for a side-scrolling game, a sandy cave floor with a ring of stones for a campfire in the middle, unlit, the walkable top surface flat and level, the strip filling only the lower third of the image, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey, warm amber and stormy violet, warm amber light from the left, selective dithering in the shadows, no anti-aliasing, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal --ar 21:9 --no tent, stairs, doors, gates, arches, columns, walls, rocks standing up, sky, objects above the ground, text, letters, numbers, signs, people, characters, figures, saints, demons, flat gold, blue sky, gore, blood, nudity, grotesque, profane imagery, blur, smooth shading, painterly, 3D, photorealistic, cartoon, watermark, frame, border, vignette
```

**Primeiro plano**

```text
dark gothic pixel art, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, two separate foreground objects for a side-scrolling game, very close to the camera and almost dark silhouettes with a thin warm rim light: a fallen column to sit on at the left edge, and a dark rock at the right edge, the center of the image completely empty, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey, warm amber and stormy violet, warm amber light from the left, selective dithering in the shadows, no anti-aliasing, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal --ar 21:9 --no sky, ground strip, tent, stairs, doors, gates, the main building, anything in the center, text, letters, numbers, signs, people, characters, figures, saints, demons, flat gold, blue sky, gore, blood, nudity, grotesque, profane imagery, blur, smooth shading, painterly, 3D, photorealistic, cartoon, watermark, frame, border, vignette
```

## Vigília (refeita)

*Refaz a peça do meio que cobria o portão.*

**Fundo**

```text
dark gothic pixel art, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, the far background of a side-scrolling game seen from the side, a dark howling hurricane sky of the second circle of Dante's Hell, heavy violet and ash grey storm clouds swirling, streaks of wind, flying ash, the violet whirlwind very close and huge, only what is very far away, the lower fifth fading into dark mist, the left and right edges fading into the storm, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey, warm amber and stormy violet, warm amber light from the left, selective dithering in the shadows, no anti-aliasing --ar 21:9 --no ground, floor, path, tent, stairs, doors, gates, nearby objects, buildings in the front, text, letters, numbers, signs, people, characters, figures, saints, demons, flat gold, blue sky, gore, blood, nudity, grotesque, profane imagery, blur, smooth shading, painterly, 3D, photorealistic, cartoon, watermark, frame, border, vignette
```

**Cena**

```text
dark gothic pixel art, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, a single scene element for a side-scrolling game seen from the side, a great dark gate carved in the rock face, fully visible and unobstructed, with two small iron lanterns hanging beside it, standing centered with empty space around it, its base cut flat along the bottom edge, nothing in front of it, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey, warm amber and stormy violet, warm amber light from the left, selective dithering in the shadows, no anti-aliasing, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal --ar 21:9 --no sky, clouds, storm, ground strip, foreground objects, text, letters, numbers, signs, people, characters, figures, saints, demons, flat gold, blue sky, gore, blood, nudity, grotesque, profane imagery, blur, smooth shading, painterly, 3D, photorealistic, cartoon, watermark, frame, border, vignette
```

**Pista**

```text
dark gothic pixel art, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, only a long horizontal strip of ground seen from the side for a side-scrolling game, a narrow stone terrace with a low step to kneel on, the walkable top surface flat and level, the strip filling only the lower third of the image, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey, warm amber and stormy violet, warm amber light from the left, selective dithering in the shadows, no anti-aliasing, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal --ar 21:9 --no tent, stairs, doors, gates, arches, columns, walls, rocks standing up, sky, objects above the ground, text, letters, numbers, signs, people, characters, figures, saints, demons, flat gold, blue sky, gore, blood, nudity, grotesque, profane imagery, blur, smooth shading, painterly, 3D, photorealistic, cartoon, watermark, frame, border, vignette
```

**Primeiro plano**

```text
dark gothic pixel art, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, two separate foreground objects for a side-scrolling game, very close to the camera and almost dark silhouettes with a thin warm rim light: a lone dark boulder at the left edge, and a small iron lantern post at the right edge, the center of the image completely empty, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey, warm amber and stormy violet, warm amber light from the left, selective dithering in the shadows, no anti-aliasing, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal --ar 21:9 --no sky, ground strip, tent, stairs, doors, gates, the main building, anything in the center, text, letters, numbers, signs, people, characters, figures, saints, demons, flat gold, blue sky, gore, blood, nudity, grotesque, profane imagery, blur, smooth shading, painterly, 3D, photorealistic, cartoon, watermark, frame, border, vignette
```

## Arena de Asmodeu (revisão)

*Já existe; gere só se quiser uma versão nova.*

**Fundo**

```text
dark gothic pixel art, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, the far background of a side-scrolling game seen from the side, the eye of the hurricane: the violet whirlwind circling all around like a wall of storm, lightning inside the clouds, only what is very far away, the lower fifth fading into dark mist, the left and right edges fading into the storm, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey, warm amber and stormy violet, warm amber light from the left, selective dithering in the shadows, no anti-aliasing --ar 21:9 --no ground, floor, path, tent, stairs, doors, gates, nearby objects, buildings in the front, text, letters, numbers, signs, people, characters, figures, saints, demons, flat gold, blue sky, gore, blood, nudity, grotesque, profane imagery, blur, smooth shading, painterly, 3D, photorealistic, cartoon, watermark, frame, border, vignette
```

**Cena**

```text
dark gothic pixel art, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, a single scene element for a side-scrolling game seen from the side, a ring of broken pillars standing around the rim of a round platform, standing centered with empty space around it, its base cut flat along the bottom edge, nothing in front of it, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey, warm amber and stormy violet, warm amber light from the left, selective dithering in the shadows, no anti-aliasing, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal --ar 21:9 --no sky, clouds, storm, ground strip, foreground objects, text, letters, numbers, signs, people, characters, figures, saints, demons, flat gold, blue sky, gore, blood, nudity, grotesque, profane imagery, blur, smooth shading, painterly, 3D, photorealistic, cartoon, watermark, frame, border, vignette
```

**Pista**

```text
dark gothic pixel art, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, only a long horizontal strip of ground seen from the side for a side-scrolling game, the wide flat surface of a round stone platform with cracks radiating from its center, the walkable top surface flat and level, the strip filling only the lower third of the image, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey, warm amber and stormy violet, warm amber light from the left, selective dithering in the shadows, no anti-aliasing, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal --ar 21:9 --no tent, stairs, doors, gates, arches, columns, walls, rocks standing up, sky, objects above the ground, text, letters, numbers, signs, people, characters, figures, saints, demons, flat gold, blue sky, gore, blood, nudity, grotesque, profane imagery, blur, smooth shading, painterly, 3D, photorealistic, cartoon, watermark, frame, border, vignette
```

**Primeiro plano**

```text
dark gothic pixel art, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, two separate foreground objects for a side-scrolling game, very close to the camera and almost dark silhouettes with a thin warm rim light: a broken pillar stump at the left edge, and a tilted fallen pillar at the right edge, the center of the image completely empty, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey, warm amber and stormy violet, warm amber light from the left, selective dithering in the shadows, no anti-aliasing, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal --ar 21:9 --no sky, ground strip, tent, stairs, doors, gates, the main building, anything in the center, text, letters, numbers, signs, people, characters, figures, saints, demons, flat gold, blue sky, gore, blood, nudity, grotesque, profane imagery, blur, smooth shading, painterly, 3D, photorealistic, cartoon, watermark, frame, border, vignette
```

