# Prompts de cenários e ambientação · v1.1

*v1.1 (04/11/2026): mapa de escolha dos círculos refeito em faixas horizontais largas (seção Interface).*

Base: Direção de Arte v1.1 (§9 cenários, §10 Pouso, §11 almas, §12 interface) e `docs/art/asset-pipeline.md`. Os cenários da DA continuam valendo como **referência de composição**; aqui eles viram camadas separadas para parallax e corredores de caminhada.

## 1. Como funciona o parallax

Cada cenário (3 trechos e o chefe de cada círculo) tem **4 imagens**:

| Imagem | O que tem | Move na tela | Arquivo final |
| --- | --- | --- | --- |
| `_ref` | Cena completa (só referência de estilo e composição, não entra no jogo) | — | PNG 2560 × 1080 |
| `_back` | Céu, horizonte e pontos de referência distantes; ocupa a imagem inteira | Devagar (≈ 20%) | PNG **opaco**, **2560 × 1080 px** |
| `_mid` | Estruturas e o **chão onde os santos andam**; acima delas, fundo cinza para remover | Velocidade da câmera (100%) | PNG RGBA, **2560 × 1080 px**, bordas esquerda e direita emendáveis |
| `_front` | Silhuetas escuras só nas bordas e embaixo; centro vazio | Mais rápido (≈ 130%) | PNG RGBA, **3240 × 1080 px** |

**Linha do chão:** a superfície onde os pés pisam fica a **≈ 83% da altura (y ≈ 900 px)** no `_mid`. É a mesma linha em todos os cenários; o Claude Code posiciona os santos sobre ela.

**Corredor de caminhada:** o `_mid` precisa emendar à esquerda e à direita para os santos andarem entre os nós. Gerar perfeito é raro: depois de escolher, o Claude Code (ou você, no editor) desloca a imagem pela metade e corrige a emenda. O `_back` não precisa emendar (move pouco); o `_front` usa peças soltas repetidas.

**Ordem de geração:**
1. Gere o `_ref` e escolha o melhor.
2. Gere `_back`, `_mid` e `_front` usando o `_ref` aprovado como referência de estilo (`--sref`) e de imagem.
3. Remova o fundo cinza do `_mid` e do `_front`.

**Pixels:** o Midjourney não lê pixels no texto; ele segue `--ar` e o Upscale. Gere em 21:9 (ou 3:1 para o `_front`) com Upscale 2× (≈ 3360 × 1440 px) e reduza ao tamanho final. Todos os arquivos: PNG 8 bits, sRGB, 72 ppi. A vinheta escura é aplicada pelo motor, por isso as camadas pedem *sem vinheta*.

**Nomes:** `env_<círculo>_<trecho>_<camada>.png`, por exemplo `env_circle_02_t1_mid.png`. Pasta: `assets/environments/circles/<círculo>/<trecho>/`. O Antinferno e o Limbo usam `circle_01`, como no glossário.

## Antinferno e Limbo (`circle_01`) · cor `pale pearl grey`

### T1 · Campo dos ignavos

**`env_circle_01_t1_ref`** — Referência completa

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** · só referência (guardar em `art_source/`)

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, full scene, a starless black sky over a barren endless plain, a colossal dark gate faintly visible on the far horizon, a barren cracked plain with dead grass, a tattered empty banner on a tall leaning pole, scattered broken spears, dead thorny bushes and a broken fence post, a cloud of wasps at the edges, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and pale pearl grey, distressed print texture, dark vignette --ar 21:9 --no characters, people, large creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_01_t1_back`** — Camada de fundo

> **Gerar:** `--ar 21:9` + Upscale 2× (≈ 3360 × 1440 px)  
> **Arquivo final:** PNG RGB opaco, **2560 × 1080 px**, 72 ppi, sRGB

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, far background layer only for parallax, a starless black sky over a barren endless plain, a colossal dark gate faintly visible on the far horizon, distant, low contrast, atmospheric haze, no foreground objects and no near ground, fills the whole frame edge to edge, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and pale pearl grey, distressed print texture --ar 21:9 --no characters, people, large creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, foreground, frame
```

**`env_circle_01_t1_mid`** — Camada do meio (chão de caminhada)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px**, 72 ppi, sRGB · superfície do chão em **y ≈ 900 px** · bordas laterais emendáveis  
> Remover o cinza acima das estruturas

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, middle layer only for parallax, a barren cracked plain with dead grass, a tattered empty banner on a tall leaning pole, scattered broken spears, a continuous flat walkable ground strip along the bottom of the image with the ground surface at about 83 percent of the image height, structures standing on the ground, empty plain flat solid light grey background above and behind the structures instead of sky, seamless left and right edges for horizontal tiling, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and pale pearl grey, distressed print texture --ar 21:9 --no sky, clouds, characters, people, large creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

**`env_circle_01_t1_front`** — Camada da frente

> **Gerar:** `--ar 3:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **3240 × 1080 px**, 72 ppi, sRGB · centro livre entre x ≈ 600 e x ≈ 2640 px  
> Remover o cinza

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, foreground layer only for parallax, dead thorny bushes and a broken fence post, a cloud of wasps, dark near-black silhouettes only at the far left edge, the far right edge and along the very bottom edge, the whole center of the image completely empty, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and pale pearl grey, distressed print texture --ar 3:1 --no sky, ground in the center, characters, people, large creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

### T2 · Margem do Aqueronte

**`env_circle_01_t2_ref`** — Referência completa

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** · só referência (guardar em `art_source/`)

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, full scene, a wide black river under eternal night, the far shore lost in mist, a dark muddy riverbank with dead reeds and a rotting wooden jetty, tall dead reeds and a mooring post with rotten rope at the edges, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and pale pearl grey, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_01_t2_back`** — Camada de fundo

> **Gerar:** `--ar 21:9` + Upscale 2× (≈ 3360 × 1440 px)  
> **Arquivo final:** PNG RGB opaco, **2560 × 1080 px**, 72 ppi, sRGB

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, far background layer only for parallax, a wide black river under eternal night, the far shore lost in mist, distant, low contrast, atmospheric haze, no foreground objects and no near ground, fills the whole frame edge to edge, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and pale pearl grey, distressed print texture --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, foreground, frame
```

**`env_circle_01_t2_mid`** — Camada do meio (chão de caminhada)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px**, 72 ppi, sRGB · superfície do chão em **y ≈ 900 px** · bordas laterais emendáveis  
> Remover o cinza acima das estruturas

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, middle layer only for parallax, a dark muddy riverbank with dead reeds and a rotting wooden jetty, a continuous flat walkable ground strip along the bottom of the image with the ground surface at about 83 percent of the image height, structures standing on the ground, empty plain flat solid light grey background above and behind the structures instead of sky, seamless left and right edges for horizontal tiling, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and pale pearl grey, distressed print texture --ar 21:9 --no sky, clouds, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

**`env_circle_01_t2_front`** — Camada da frente

> **Gerar:** `--ar 3:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **3240 × 1080 px**, 72 ppi, sRGB · centro livre entre x ≈ 600 e x ≈ 2640 px  
> Remover o cinza

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, foreground layer only for parallax, tall dead reeds and a mooring post with rotten rope, dark near-black silhouettes only at the far left edge, the far right edge and along the very bottom edge, the whole center of the image completely empty, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and pale pearl grey, distressed print texture --ar 3:1 --no sky, ground in the center, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

### T3 · Castelo do Limbo

**`env_circle_01_t3_ref`** — Referência completa

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** · só referência (guardar em `art_source/`)

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, full scene, a dim pearly sky, a noble castle with seven high walls in the distance encircled by a small stream, a pale green meadow with low old stone walls, quiet and melancholic, no fire and no torment, tall pale grass and the edge of a crumbling low wall at the edges, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and pale pearl grey, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, fire
```

**`env_circle_01_t3_back`** — Camada de fundo

> **Gerar:** `--ar 21:9` + Upscale 2× (≈ 3360 × 1440 px)  
> **Arquivo final:** PNG RGB opaco, **2560 × 1080 px**, 72 ppi, sRGB

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, far background layer only for parallax, a dim pearly sky, a noble castle with seven high walls in the distance encircled by a small stream, distant, low contrast, atmospheric haze, no foreground objects and no near ground, fills the whole frame edge to edge, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and pale pearl grey, distressed print texture --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, foreground, frame, fire
```

**`env_circle_01_t3_mid`** — Camada do meio (chão de caminhada)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px**, 72 ppi, sRGB · superfície do chão em **y ≈ 900 px** · bordas laterais emendáveis  
> Remover o cinza acima das estruturas

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, middle layer only for parallax, a pale green meadow with low old stone walls, quiet and melancholic, no fire and no torment, a continuous flat walkable ground strip along the bottom of the image with the ground surface at about 83 percent of the image height, structures standing on the ground, empty plain flat solid light grey background above and behind the structures instead of sky, seamless left and right edges for horizontal tiling, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and pale pearl grey, distressed print texture --ar 21:9 --no sky, clouds, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame, fire
```

**`env_circle_01_t3_front`** — Camada da frente

> **Gerar:** `--ar 3:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **3240 × 1080 px**, 72 ppi, sRGB · centro livre entre x ≈ 600 e x ≈ 2640 px  
> Remover o cinza

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, foreground layer only for parallax, tall pale grass and the edge of a crumbling low wall, dark near-black silhouettes only at the far left edge, the far right edge and along the very bottom edge, the whole center of the image completely empty, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and pale pearl grey, distressed print texture --ar 3:1 --no sky, ground in the center, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame, fire
```

### Chefe · A barca

**`env_circle_01_boss_ref`** — Referência completa

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** · só referência (guardar em `art_source/`)

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, full scene, the wide river Acheron in eternal night, the far shore lost in fog, a rotten landing stage of black planks over black water, posts with iron rings, rotten pilings and drifting fog over the water at the edges, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and pale pearl grey, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, boat
```

**`env_circle_01_boss_back`** — Camada de fundo

> **Gerar:** `--ar 21:9` + Upscale 2× (≈ 3360 × 1440 px)  
> **Arquivo final:** PNG RGB opaco, **2560 × 1080 px**, 72 ppi, sRGB

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, far background layer only for parallax, the wide river Acheron in eternal night, the far shore lost in fog, distant, low contrast, atmospheric haze, no foreground objects and no near ground, fills the whole frame edge to edge, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and pale pearl grey, distressed print texture --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, foreground, frame, boat
```

**`env_circle_01_boss_mid`** — Camada do meio (chão de caminhada)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px**, 72 ppi, sRGB · superfície do chão em **y ≈ 900 px** · bordas laterais emendáveis  
> Remover o cinza acima das estruturas

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, middle layer only for parallax, a rotten landing stage of black planks over black water, posts with iron rings, a continuous flat walkable ground strip along the bottom of the image with the ground surface at about 83 percent of the image height, structures standing on the ground, empty plain flat solid light grey background above and behind the structures instead of sky, seamless left and right edges for horizontal tiling, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and pale pearl grey, distressed print texture --ar 21:9 --no sky, clouds, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame, boat
```

**`env_circle_01_boss_front`** — Camada da frente

> **Gerar:** `--ar 3:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **3240 × 1080 px**, 72 ppi, sRGB · centro livre entre x ≈ 600 e x ≈ 2640 px  
> Remover o cinza

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, foreground layer only for parallax, rotten pilings and drifting fog over the water, dark near-black silhouettes only at the far left edge, the far right edge and along the very bottom edge, the whole center of the image completely empty, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and pale pearl grey, distressed print texture --ar 3:1 --no sky, ground in the center, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame, boat
```

### Almas atormentadas

**`env_circle_01_souls_crowd`** — Multidão distante (camada animada entre `_back` e `_mid`)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px** · figuras pequenas (≈ 80–160 px de altura) · fundo removido  
> O motor anima com balanço, deriva e transparência; não é preciso quadro a quadro

```text
Dark gothic 2D side-view game background layer in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, a restless crowd of pale souls in torn grey shrouds running endlessly after a blank tattered banner, harassed by swarms of wasps; further away, calm sighing souls of Limbo sitting in a pale meadow, many small distant figures in the middle distance, readable silhouettes, all figures shrouded, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and pale pearl grey, distressed print texture --ar 21:9 --no nudity, sexual, children, gore close-up, ground, sky, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_01_souls_sheet`** — Folha de 3 almas para animação (perto da câmera)

> **Gerar:** `--ar 3:2` + Upscale 2×  
> **Arquivo final:** Matriz PNG RGBA **3072 × 2048 px** em `art_source/`; cada alma recortada em PNG RGBA com **≈ 600 px** de altura  
> Para animação simples por rig ou deformação no Godot; recortar membros se necessário

```text
Dark gothic 2D game character sheet in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, three tormented damned souls of the same kind wrapped in torn grey shrouds, side view facing left, pose 1: running forward chasing an unseen banner; pose 2: swatting at wasps around the head; pose 3: sitting with bowed head, quietly sighing (Limbo, no torment), the three figures separated by wide empty space, same scale, full figures inside the frame, anguished faces, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors, palette of black, bone, ash grey and pale pearl grey, isolated on a plain flat solid light grey background --ar 3:2 --no nudity, sexual, children, text, letters, UI, halo, cartoon, anime, glossy, 3D, photorealistic, white background
```

### Ambientação

**`fx_circle_01_ambient`** — Partículas do ambiente (folha de sprites)

> **Gerar:** `--ar 1:1` + Upscale 2×  
> **Arquivo final:** Matriz PNG RGBA **2048 × 2048 px**; cada sprite recortado em PNG RGBA de **64–256 px**  
> O motor espalha e anima as partículas

```text
2D game VFX sprite sheet in the style of Darkest Dungeon, hand-inked comic art, a grid of separate small particle sprites: swarming wasps, small tattered banner scraps, drifting pale dust, each sprite isolated with empty space around it, varied sizes, thick ink edges, palette of black, bone, ash grey and pale pearl grey, isolated on a plain flat solid light grey background --ar 1:1 --no text, letters, numbers, grid lines, characters, cartoon, glossy, 3D, photorealistic, white background
```

**`env_circle_01_camp`** — Pouso deste círculo

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** (pode ser dividido em camadas como os trechos)

```text
Darkest Dungeon style 2D side-view camp background, hand-painted gothic horror, hand-inked comic art, a small campfire under a dead tree on the barren plain, a few candles placed on a stone, bedrolls, the surrounding darkness of the circle pressing in, warm firelight in a small circle against cold shadow, empty flat floor strip in the foreground for characters, palette of black, bone, ash grey, warm amber and pale pearl grey, thick black ink outlines, heavy black shadows, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_01_vigil`** — Vigília (antes do chefe)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px**

```text
Darkest Dungeon style 2D side-view background, hand-painted gothic horror, hand-inked comic art, a last quiet resting spot under a dead tree on the barren plain, a single tall candle on a flat rock, the entrance to the boss lair looming in the darkness ahead, tense silence, empty flat floor strip in the foreground for characters, palette of black, bone, ash grey, warm amber and pale pearl grey, thick black ink outlines, heavy black shadows, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_01_arrival`** — Chegada ao círculo (tela de transição e carregamento)

> **Gerar:** `--ar 16:9` + Upscale 2×  
> **Arquivo final:** PNG **1920 × 1080 px** (guardar a matriz em 3840 × 2160 em `art_source/`)  
> O motor coloca o nome do círculo por cima

```text
Dark gothic panoramic illustration in the style of Darkest Dungeon, hand-inked comic art, in the spirit of Gustave Dore engravings of the Inferno, the vestibule of Hell seen from above the great gate, a barren plain, a black river beyond and a pale castle in the far distance, seen from a high rocky ledge, tiny distant figures, immense scale, thick black ink outlines, heavy black shadows, crosshatched engraving texture, muted desaturated palette of black, bone, ash grey and pale pearl grey, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, close-up characters, cartoon, glossy, 3D, photorealistic
```

## Luxúria (`circle_02`) · cor `stormy violet`

### T1 · Penhasco de Minos

**`env_circle_02_t1_ref`** — Referência completa

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** · só referência (guardar em `art_source/`)

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, full scene, howling violet-black darkness and storm clouds, a rocky cliff ledge with a jagged stone seat of judgment carved into the rock wall, jagged rocks and torn cloth caught on thorns at the edges, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_02_t1_back`** — Camada de fundo

> **Gerar:** `--ar 21:9` + Upscale 2× (≈ 3360 × 1440 px)  
> **Arquivo final:** PNG RGB opaco, **2560 × 1080 px**, 72 ppi, sRGB

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, far background layer only for parallax, howling violet-black darkness and storm clouds, distant, low contrast, atmospheric haze, no foreground objects and no near ground, fills the whole frame edge to edge, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, foreground, frame
```

**`env_circle_02_t1_mid`** — Camada do meio (chão de caminhada)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px**, 72 ppi, sRGB · superfície do chão em **y ≈ 900 px** · bordas laterais emendáveis  
> Remover o cinza acima das estruturas

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, middle layer only for parallax, a rocky cliff ledge with a jagged stone seat of judgment carved into the rock wall, a continuous flat walkable ground strip along the bottom of the image with the ground surface at about 83 percent of the image height, structures standing on the ground, empty plain flat solid light grey background above and behind the structures instead of sky, seamless left and right edges for horizontal tiling, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture --ar 21:9 --no sky, clouds, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

**`env_circle_02_t1_front`** — Camada da frente

> **Gerar:** `--ar 3:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **3240 × 1080 px**, 72 ppi, sRGB · centro livre entre x ≈ 600 e x ≈ 2640 px  
> Remover o cinza

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, foreground layer only for parallax, jagged rocks and torn cloth caught on thorns, dark near-black silhouettes only at the far left edge, the far right edge and along the very bottom edge, the whole center of the image completely empty, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture --ar 3:1 --no sky, ground in the center, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

### T2 · Furacão

**`env_circle_02_t2_ref`** — Referência completa

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** · só referência (guardar em `art_source/`)

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, full scene, an endless spinning hurricane filling the whole sky, a broken rocky ledge swept by wind, scattered debris, whirling torn cloth and dust at the edges, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_02_t2_back`** — Camada de fundo

> **Gerar:** `--ar 21:9` + Upscale 2× (≈ 3360 × 1440 px)  
> **Arquivo final:** PNG RGB opaco, **2560 × 1080 px**, 72 ppi, sRGB

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, far background layer only for parallax, an endless spinning hurricane filling the whole sky, distant, low contrast, atmospheric haze, no foreground objects and no near ground, fills the whole frame edge to edge, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, foreground, frame
```

**`env_circle_02_t2_mid`** — Camada do meio (chão de caminhada)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px**, 72 ppi, sRGB · superfície do chão em **y ≈ 900 px** · bordas laterais emendáveis  
> Remover o cinza acima das estruturas

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, middle layer only for parallax, a broken rocky ledge swept by wind, scattered debris, a continuous flat walkable ground strip along the bottom of the image with the ground surface at about 83 percent of the image height, structures standing on the ground, empty plain flat solid light grey background above and behind the structures instead of sky, seamless left and right edges for horizontal tiling, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture --ar 21:9 --no sky, clouds, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

**`env_circle_02_t2_front`** — Camada da frente

> **Gerar:** `--ar 3:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **3240 × 1080 px**, 72 ppi, sRGB · centro livre entre x ≈ 600 e x ≈ 2640 px  
> Remover o cinza

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, foreground layer only for parallax, whirling torn cloth and dust, dark near-black silhouettes only at the far left edge, the far right edge and along the very bottom edge, the whole center of the image completely empty, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture --ar 3:1 --no sky, ground in the center, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

### T3 · Ruínas varridas pelo vento

**`env_circle_02_t3_ref`** — Referência completa

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** · só referência (guardar em `art_source/`)

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, full scene, a storm sky with distant broken spires, ruins of a gothic cloister, leaning arches, torn curtains frozen in motion, a fallen column and fluttering curtain fragments at the edges, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_02_t3_back`** — Camada de fundo

> **Gerar:** `--ar 21:9` + Upscale 2× (≈ 3360 × 1440 px)  
> **Arquivo final:** PNG RGB opaco, **2560 × 1080 px**, 72 ppi, sRGB

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, far background layer only for parallax, a storm sky with distant broken spires, distant, low contrast, atmospheric haze, no foreground objects and no near ground, fills the whole frame edge to edge, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, foreground, frame
```

**`env_circle_02_t3_mid`** — Camada do meio (chão de caminhada)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px**, 72 ppi, sRGB · superfície do chão em **y ≈ 900 px** · bordas laterais emendáveis  
> Remover o cinza acima das estruturas

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, middle layer only for parallax, ruins of a gothic cloister, leaning arches, torn curtains frozen in motion, a continuous flat walkable ground strip along the bottom of the image with the ground surface at about 83 percent of the image height, structures standing on the ground, empty plain flat solid light grey background above and behind the structures instead of sky, seamless left and right edges for horizontal tiling, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture --ar 21:9 --no sky, clouds, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

**`env_circle_02_t3_front`** — Camada da frente

> **Gerar:** `--ar 3:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **3240 × 1080 px**, 72 ppi, sRGB · centro livre entre x ≈ 600 e x ≈ 2640 px  
> Remover o cinza

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, foreground layer only for parallax, a fallen column and fluttering curtain fragments, dark near-black silhouettes only at the far left edge, the far right edge and along the very bottom edge, the whole center of the image completely empty, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture --ar 3:1 --no sky, ground in the center, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

### Chefe · Olho da tempestade

**`env_circle_02_boss_ref`** — Referência completa

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** · só referência (guardar em `art_source/`)

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, full scene, a ring of spinning walls of wind, a calm dark center above, a calm circular platform of black stone, the edge of the platform with wind-torn debris at the edges, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_02_boss_back`** — Camada de fundo

> **Gerar:** `--ar 21:9` + Upscale 2× (≈ 3360 × 1440 px)  
> **Arquivo final:** PNG RGB opaco, **2560 × 1080 px**, 72 ppi, sRGB

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, far background layer only for parallax, a ring of spinning walls of wind, a calm dark center above, distant, low contrast, atmospheric haze, no foreground objects and no near ground, fills the whole frame edge to edge, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, foreground, frame
```

**`env_circle_02_boss_mid`** — Camada do meio (chão de caminhada)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px**, 72 ppi, sRGB · superfície do chão em **y ≈ 900 px** · bordas laterais emendáveis  
> Remover o cinza acima das estruturas

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, middle layer only for parallax, a calm circular platform of black stone, a continuous flat walkable ground strip along the bottom of the image with the ground surface at about 83 percent of the image height, structures standing on the ground, empty plain flat solid light grey background above and behind the structures instead of sky, seamless left and right edges for horizontal tiling, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture --ar 21:9 --no sky, clouds, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

**`env_circle_02_boss_front`** — Camada da frente

> **Gerar:** `--ar 3:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **3240 × 1080 px**, 72 ppi, sRGB · centro livre entre x ≈ 600 e x ≈ 2640 px  
> Remover o cinza

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, foreground layer only for parallax, the edge of the platform with wind-torn debris, dark near-black silhouettes only at the far left edge, the far right edge and along the very bottom edge, the whole center of the image completely empty, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture --ar 3:1 --no sky, ground in the center, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

### Almas atormentadas

**`env_circle_02_souls_crowd`** — Multidão distante (camada animada entre `_back` e `_mid`)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px** · figuras pequenas (≈ 80–160 px de altura) · fundo removido  
> O motor anima com balanço, deriva e transparência; não é preciso quadro a quadro

```text
Dark gothic 2D side-view game background layer in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, souls in torn grey shrouds swept through the dark air by the hurricane like a great flock of starlings, endlessly tumbling, non-sexual, many small distant figures in the middle distance, readable silhouettes, all figures shrouded, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture --ar 21:9 --no nudity, sexual, children, gore close-up, ground, sky, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_02_souls_sheet`** — Folha de 3 almas para animação (perto da câmera)

> **Gerar:** `--ar 3:2` + Upscale 2×  
> **Arquivo final:** Matriz PNG RGBA **3072 × 2048 px** em `art_source/`; cada alma recortada em PNG RGBA com **≈ 600 px** de altura  
> Para animação simples por rig ou deformação no Godot; recortar membros se necessário

```text
Dark gothic 2D game character sheet in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, three tormented damned souls of the same kind wrapped in torn grey shrouds, side view facing left, pose 1: tumbling head over heels in the wind; pose 2: reaching out a hand against the wind; pose 3: two souls clinging to each other in sorrow, fully shrouded, non-sexual, the three figures separated by wide empty space, same scale, full figures inside the frame, anguished faces, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors, palette of black, bone, ash grey and stormy violet, isolated on a plain flat solid light grey background --ar 3:2 --no nudity, sexual, children, text, letters, UI, halo, cartoon, anime, glossy, 3D, photorealistic, white background
```

### Ambientação

**`fx_circle_02_ambient`** — Partículas do ambiente (folha de sprites)

> **Gerar:** `--ar 1:1` + Upscale 2×  
> **Arquivo final:** Matriz PNG RGBA **2048 × 2048 px**; cada sprite recortado em PNG RGBA de **64–256 px**  
> O motor espalha e anima as partículas

```text
2D game VFX sprite sheet in the style of Darkest Dungeon, hand-inked comic art, a grid of separate small particle sprites: wind-blown debris, long torn cloth strips, dust streaks, each sprite isolated with empty space around it, varied sizes, thick ink edges, palette of black, bone, ash grey and stormy violet, isolated on a plain flat solid light grey background --ar 1:1 --no text, letters, numbers, grid lines, characters, cartoon, glossy, 3D, photorealistic, white background
```

**`env_circle_02_camp`** — Pouso deste círculo

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** (pode ser dividido em camadas como os trechos)

```text
Darkest Dungeon style 2D side-view camp background, hand-painted gothic horror, hand-inked comic art, a small campfire behind a tall rock that breaks the wind, a few candles placed on a stone, bedrolls, the surrounding darkness of the circle pressing in, warm firelight in a small circle against cold shadow, empty flat floor strip in the foreground for characters, palette of black, bone, ash grey, warm amber and stormy violet, thick black ink outlines, heavy black shadows, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_02_vigil`** — Vigília (antes do chefe)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px**

```text
Darkest Dungeon style 2D side-view background, hand-painted gothic horror, hand-inked comic art, a last quiet resting spot behind a tall rock that breaks the wind, a single tall candle on a flat rock, the entrance to the boss lair looming in the darkness ahead, tense silence, empty flat floor strip in the foreground for characters, palette of black, bone, ash grey, warm amber and stormy violet, thick black ink outlines, heavy black shadows, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_02_arrival`** — Chegada ao círculo (tela de transição e carregamento)

> **Gerar:** `--ar 16:9` + Upscale 2×  
> **Arquivo final:** PNG **1920 × 1080 px** (guardar a matriz em 3840 × 2160 em `art_source/`)  
> O motor coloca o nome do círculo por cima

```text
Dark gothic panoramic illustration in the style of Darkest Dungeon, hand-inked comic art, in the spirit of Gustave Dore engravings of the Inferno, a vast dark abyss filled by a spinning hurricane of tiny shrouded souls, a cliff ledge in the foreground, seen from a high rocky ledge, tiny distant figures, immense scale, thick black ink outlines, heavy black shadows, crosshatched engraving texture, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, close-up characters, cartoon, glossy, 3D, photorealistic
```

## Gula (`circle_03`) · cor `sickly olive green`

### T1 · Lamaçal

**`env_circle_03_t1_ref`** — Referência completa

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** · só referência (guardar em `art_source/`)

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, full scene, a low filthy sky with heavy curtains of rain, a vast swamp of black stinking mud, sunken carts and broken barrels, mud mounds, broken barrel staves and puddles at the edges, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and sickly olive green, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_03_t1_back`** — Camada de fundo

> **Gerar:** `--ar 21:9` + Upscale 2× (≈ 3360 × 1440 px)  
> **Arquivo final:** PNG RGB opaco, **2560 × 1080 px**, 72 ppi, sRGB

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, far background layer only for parallax, a low filthy sky with heavy curtains of rain, distant, low contrast, atmospheric haze, no foreground objects and no near ground, fills the whole frame edge to edge, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and sickly olive green, distressed print texture --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, foreground, frame
```

**`env_circle_03_t1_mid`** — Camada do meio (chão de caminhada)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px**, 72 ppi, sRGB · superfície do chão em **y ≈ 900 px** · bordas laterais emendáveis  
> Remover o cinza acima das estruturas

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, middle layer only for parallax, a vast swamp of black stinking mud, sunken carts and broken barrels, a continuous flat walkable ground strip along the bottom of the image with the ground surface at about 83 percent of the image height, structures standing on the ground, empty plain flat solid light grey background above and behind the structures instead of sky, seamless left and right edges for horizontal tiling, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and sickly olive green, distressed print texture --ar 21:9 --no sky, clouds, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

**`env_circle_03_t1_front`** — Camada da frente

> **Gerar:** `--ar 3:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **3240 × 1080 px**, 72 ppi, sRGB · centro livre entre x ≈ 600 e x ≈ 2640 px  
> Remover o cinza

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, foreground layer only for parallax, mud mounds, broken barrel staves and puddles, dark near-black silhouettes only at the far left edge, the far right edge and along the very bottom edge, the whole center of the image completely empty, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and sickly olive green, distressed print texture --ar 3:1 --no sky, ground in the center, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

### T2 · Ruínas sob chuva imunda

**`env_circle_03_t2_ref`** — Referência completa

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** · só referência (guardar em `art_source/`)

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, full scene, sickly fog and rain, distant collapsed arches, ruined gothic stone arches sinking into black mud, broken columns, scattered bones, a broken column stump and bones in the mud at the edges, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and sickly olive green, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_03_t2_back`** — Camada de fundo

> **Gerar:** `--ar 21:9` + Upscale 2× (≈ 3360 × 1440 px)  
> **Arquivo final:** PNG RGB opaco, **2560 × 1080 px**, 72 ppi, sRGB

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, far background layer only for parallax, sickly fog and rain, distant collapsed arches, distant, low contrast, atmospheric haze, no foreground objects and no near ground, fills the whole frame edge to edge, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and sickly olive green, distressed print texture --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, foreground, frame
```

**`env_circle_03_t2_mid`** — Camada do meio (chão de caminhada)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px**, 72 ppi, sRGB · superfície do chão em **y ≈ 900 px** · bordas laterais emendáveis  
> Remover o cinza acima das estruturas

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, middle layer only for parallax, ruined gothic stone arches sinking into black mud, broken columns, scattered bones, a continuous flat walkable ground strip along the bottom of the image with the ground surface at about 83 percent of the image height, structures standing on the ground, empty plain flat solid light grey background above and behind the structures instead of sky, seamless left and right edges for horizontal tiling, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and sickly olive green, distressed print texture --ar 21:9 --no sky, clouds, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

**`env_circle_03_t2_front`** — Camada da frente

> **Gerar:** `--ar 3:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **3240 × 1080 px**, 72 ppi, sRGB · centro livre entre x ≈ 600 e x ≈ 2640 px  
> Remover o cinza

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, foreground layer only for parallax, a broken column stump and bones in the mud, dark near-black silhouettes only at the far left edge, the far right edge and along the very bottom edge, the whole center of the image completely empty, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and sickly olive green, distressed print texture --ar 3:1 --no sky, ground in the center, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

### T3 · Covil de Cérbero

**`env_circle_03_t3_ref`** — Referência completa

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** · só referência (guardar em `art_source/`)

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, full scene, a great rotten archway in the distance with darkness beyond, a hollow of mud and gnawed bones, heavy chains on the ground, huge gnawed bones and chain links at the edges, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and sickly olive green, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_03_t3_back`** — Camada de fundo

> **Gerar:** `--ar 21:9` + Upscale 2× (≈ 3360 × 1440 px)  
> **Arquivo final:** PNG RGB opaco, **2560 × 1080 px**, 72 ppi, sRGB

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, far background layer only for parallax, a great rotten archway in the distance with darkness beyond, distant, low contrast, atmospheric haze, no foreground objects and no near ground, fills the whole frame edge to edge, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and sickly olive green, distressed print texture --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, foreground, frame
```

**`env_circle_03_t3_mid`** — Camada do meio (chão de caminhada)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px**, 72 ppi, sRGB · superfície do chão em **y ≈ 900 px** · bordas laterais emendáveis  
> Remover o cinza acima das estruturas

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, middle layer only for parallax, a hollow of mud and gnawed bones, heavy chains on the ground, a continuous flat walkable ground strip along the bottom of the image with the ground surface at about 83 percent of the image height, structures standing on the ground, empty plain flat solid light grey background above and behind the structures instead of sky, seamless left and right edges for horizontal tiling, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and sickly olive green, distressed print texture --ar 21:9 --no sky, clouds, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

**`env_circle_03_t3_front`** — Camada da frente

> **Gerar:** `--ar 3:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **3240 × 1080 px**, 72 ppi, sRGB · centro livre entre x ≈ 600 e x ≈ 2640 px  
> Remover o cinza

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, foreground layer only for parallax, huge gnawed bones and chain links, dark near-black silhouettes only at the far left edge, the far right edge and along the very bottom edge, the whole center of the image completely empty, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and sickly olive green, distressed print texture --ar 3:1 --no sky, ground in the center, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

### Chefe · Salão das moscas

**`env_circle_03_boss_ref`** — Referência completa

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** · só referência (guardar em `art_source/`)

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, full scene, a cavernous rotten hall whose ceiling is lost in darkness, clouds of flies, collapsed long banquet tables with rotting food, overturned goblets and rotten platters with flies at the edges, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and sickly olive green, distressed print texture, dark vignette --ar 21:9 --no characters, people, large creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_03_boss_back`** — Camada de fundo

> **Gerar:** `--ar 21:9` + Upscale 2× (≈ 3360 × 1440 px)  
> **Arquivo final:** PNG RGB opaco, **2560 × 1080 px**, 72 ppi, sRGB

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, far background layer only for parallax, a cavernous rotten hall whose ceiling is lost in darkness, clouds of flies, distant, low contrast, atmospheric haze, no foreground objects and no near ground, fills the whole frame edge to edge, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and sickly olive green, distressed print texture --ar 21:9 --no characters, people, large creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, foreground, frame
```

**`env_circle_03_boss_mid`** — Camada do meio (chão de caminhada)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px**, 72 ppi, sRGB · superfície do chão em **y ≈ 900 px** · bordas laterais emendáveis  
> Remover o cinza acima das estruturas

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, middle layer only for parallax, collapsed long banquet tables with rotting food, a continuous flat walkable ground strip along the bottom of the image with the ground surface at about 83 percent of the image height, structures standing on the ground, empty plain flat solid light grey background above and behind the structures instead of sky, seamless left and right edges for horizontal tiling, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and sickly olive green, distressed print texture --ar 21:9 --no sky, clouds, characters, people, large creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

**`env_circle_03_boss_front`** — Camada da frente

> **Gerar:** `--ar 3:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **3240 × 1080 px**, 72 ppi, sRGB · centro livre entre x ≈ 600 e x ≈ 2640 px  
> Remover o cinza

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, foreground layer only for parallax, overturned goblets and rotten platters with flies, dark near-black silhouettes only at the far left edge, the far right edge and along the very bottom edge, the whole center of the image completely empty, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and sickly olive green, distressed print texture --ar 3:1 --no sky, ground in the center, characters, people, large creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

### Almas atormentadas

**`env_circle_03_souls_crowd`** — Multidão distante (camada animada entre `_back` e `_mid`)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px** · figuras pequenas (≈ 80–160 px de altura) · fundo removido  
> O motor anima com balanço, deriva e transparência; não é preciso quadro a quadro

```text
Dark gothic 2D side-view game background layer in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, damned gluttons lying in black filthy mud under heavy freezing rain, bodies half covered in mud, howling, many small distant figures in the middle distance, readable silhouettes, all figures shrouded, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and sickly olive green, distressed print texture --ar 21:9 --no nudity, sexual, children, gore close-up, ground, sky, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_03_souls_sheet`** — Folha de 3 almas para animação (perto da câmera)

> **Gerar:** `--ar 3:2` + Upscale 2×  
> **Arquivo final:** Matriz PNG RGBA **3072 × 2048 px** em `art_source/`; cada alma recortada em PNG RGBA com **≈ 600 px** de altura  
> Para animação simples por rig ou deformação no Godot; recortar membros se necessário

```text
Dark gothic 2D game character sheet in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, three tormented damned souls of the same kind wrapped in torn grey shrouds, side view facing left, pose 1: lying face down in the mud; pose 2: lifting the head from the mud to moan; pose 3: rolling over in the mud, shielding from the rain, the three figures separated by wide empty space, same scale, full figures inside the frame, anguished faces, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors, palette of black, bone, ash grey and sickly olive green, isolated on a plain flat solid light grey background --ar 3:2 --no nudity, sexual, children, text, letters, UI, halo, cartoon, anime, glossy, 3D, photorealistic, white background
```

### Ambientação

**`fx_circle_03_ambient`** — Partículas do ambiente (folha de sprites)

> **Gerar:** `--ar 1:1` + Upscale 2×  
> **Arquivo final:** Matriz PNG RGBA **2048 × 2048 px**; cada sprite recortado em PNG RGBA de **64–256 px**  
> O motor espalha e anima as partículas

```text
2D game VFX sprite sheet in the style of Darkest Dungeon, hand-inked comic art, a grid of separate small particle sprites: diagonal rain streaks, mud splashes, small flies, each sprite isolated with empty space around it, varied sizes, thick ink edges, palette of black, bone, ash grey and sickly olive green, isolated on a plain flat solid light grey background --ar 1:1 --no text, letters, numbers, grid lines, characters, cartoon, glossy, 3D, photorealistic, white background
```

**`env_circle_03_camp`** — Pouso deste círculo

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** (pode ser dividido em camadas como os trechos)

```text
Darkest Dungeon style 2D side-view camp background, hand-painted gothic horror, hand-inked comic art, a small campfire on a raised dry stone above the mud, a few candles placed on a stone, bedrolls, the surrounding darkness of the circle pressing in, warm firelight in a small circle against cold shadow, empty flat floor strip in the foreground for characters, palette of black, bone, ash grey, warm amber and sickly olive green, thick black ink outlines, heavy black shadows, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_03_vigil`** — Vigília (antes do chefe)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px**

```text
Darkest Dungeon style 2D side-view background, hand-painted gothic horror, hand-inked comic art, a last quiet resting spot on a raised dry stone above the mud, a single tall candle on a flat rock, the entrance to the boss lair looming in the darkness ahead, tense silence, empty flat floor strip in the foreground for characters, palette of black, bone, ash grey, warm amber and sickly olive green, thick black ink outlines, heavy black shadows, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_03_arrival`** — Chegada ao círculo (tela de transição e carregamento)

> **Gerar:** `--ar 16:9` + Upscale 2×  
> **Arquivo final:** PNG **1920 × 1080 px** (guardar a matriz em 3840 × 2160 em `art_source/`)  
> O motor coloca o nome do círculo por cima

```text
Dark gothic panoramic illustration in the style of Darkest Dungeon, hand-inked comic art, in the spirit of Gustave Dore engravings of the Inferno, a vast swamp under endless filthy rain, ruined arches sinking, a monstrous archway on the horizon, seen from a high rocky ledge, tiny distant figures, immense scale, thick black ink outlines, heavy black shadows, crosshatched engraving texture, muted desaturated palette of black, bone, ash grey and sickly olive green, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, close-up characters, cartoon, glossy, 3D, photorealistic
```

## Avareza e Prodigalidade (`circle_04`) · cor `tarnished oxidized brass`

### T1 · Vale dos pesos

**`env_circle_04_t1_ref`** — Referência completa

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** · só referência (guardar em `art_source/`)

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, full scene, a dull heavy sky over a barren valley, cracked earth with deep grooves carved by enormous abandoned stone and metal weights, the edge of a huge stone weight and cracked ground at the edges, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and tarnished oxidized brass, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_04_t1_back`** — Camada de fundo

> **Gerar:** `--ar 21:9` + Upscale 2× (≈ 3360 × 1440 px)  
> **Arquivo final:** PNG RGB opaco, **2560 × 1080 px**, 72 ppi, sRGB

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, far background layer only for parallax, a dull heavy sky over a barren valley, distant, low contrast, atmospheric haze, no foreground objects and no near ground, fills the whole frame edge to edge, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and tarnished oxidized brass, distressed print texture --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, foreground, frame
```

**`env_circle_04_t1_mid`** — Camada do meio (chão de caminhada)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px**, 72 ppi, sRGB · superfície do chão em **y ≈ 900 px** · bordas laterais emendáveis  
> Remover o cinza acima das estruturas

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, middle layer only for parallax, cracked earth with deep grooves carved by enormous abandoned stone and metal weights, a continuous flat walkable ground strip along the bottom of the image with the ground surface at about 83 percent of the image height, structures standing on the ground, empty plain flat solid light grey background above and behind the structures instead of sky, seamless left and right edges for horizontal tiling, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and tarnished oxidized brass, distressed print texture --ar 21:9 --no sky, clouds, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

**`env_circle_04_t1_front`** — Camada da frente

> **Gerar:** `--ar 3:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **3240 × 1080 px**, 72 ppi, sRGB · centro livre entre x ≈ 600 e x ≈ 2640 px  
> Remover o cinza

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, foreground layer only for parallax, the edge of a huge stone weight and cracked ground, dark near-black silhouettes only at the far left edge, the far right edge and along the very bottom edge, the whole center of the image completely empty, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and tarnished oxidized brass, distressed print texture --ar 3:1 --no sky, ground in the center, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

### T2 · Montes de moedas

**`env_circle_04_t2_ref`** — Referência completa

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** · só referência (guardar em `art_source/`)

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, full scene, a dull sky over dunes of tarnished coins, dunes of tarnished coins and broken treasure chests, spilled tarnished coins and a cracked chest lid at the edges, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and tarnished oxidized brass, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, shiny gold
```

**`env_circle_04_t2_back`** — Camada de fundo

> **Gerar:** `--ar 21:9` + Upscale 2× (≈ 3360 × 1440 px)  
> **Arquivo final:** PNG RGB opaco, **2560 × 1080 px**, 72 ppi, sRGB

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, far background layer only for parallax, a dull sky over dunes of tarnished coins, distant, low contrast, atmospheric haze, no foreground objects and no near ground, fills the whole frame edge to edge, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and tarnished oxidized brass, distressed print texture --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, foreground, frame, shiny gold
```

**`env_circle_04_t2_mid`** — Camada do meio (chão de caminhada)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px**, 72 ppi, sRGB · superfície do chão em **y ≈ 900 px** · bordas laterais emendáveis  
> Remover o cinza acima das estruturas

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, middle layer only for parallax, dunes of tarnished coins and broken treasure chests, a continuous flat walkable ground strip along the bottom of the image with the ground surface at about 83 percent of the image height, structures standing on the ground, empty plain flat solid light grey background above and behind the structures instead of sky, seamless left and right edges for horizontal tiling, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and tarnished oxidized brass, distressed print texture --ar 21:9 --no sky, clouds, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame, shiny gold
```

**`env_circle_04_t2_front`** — Camada da frente

> **Gerar:** `--ar 3:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **3240 × 1080 px**, 72 ppi, sRGB · centro livre entre x ≈ 600 e x ≈ 2640 px  
> Remover o cinza

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, foreground layer only for parallax, spilled tarnished coins and a cracked chest lid, dark near-black silhouettes only at the far left edge, the far right edge and along the very bottom edge, the whole center of the image completely empty, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and tarnished oxidized brass, distressed print texture --ar 3:1 --no sky, ground in the center, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame, shiny gold
```

### T3 · Rochas de Pluto

**`env_circle_04_t3_ref`** — Referência completa

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** · só referência (guardar em `art_source/`)

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, full scene, jagged rock spires at the edge of the circle, jagged rocks and a crude altar of coins topped by a wolf skull, rocks and scattered coins at the edges, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and tarnished oxidized brass, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, shiny gold
```

**`env_circle_04_t3_back`** — Camada de fundo

> **Gerar:** `--ar 21:9` + Upscale 2× (≈ 3360 × 1440 px)  
> **Arquivo final:** PNG RGB opaco, **2560 × 1080 px**, 72 ppi, sRGB

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, far background layer only for parallax, jagged rock spires at the edge of the circle, distant, low contrast, atmospheric haze, no foreground objects and no near ground, fills the whole frame edge to edge, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and tarnished oxidized brass, distressed print texture --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, foreground, frame, shiny gold
```

**`env_circle_04_t3_mid`** — Camada do meio (chão de caminhada)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px**, 72 ppi, sRGB · superfície do chão em **y ≈ 900 px** · bordas laterais emendáveis  
> Remover o cinza acima das estruturas

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, middle layer only for parallax, jagged rocks and a crude altar of coins topped by a wolf skull, a continuous flat walkable ground strip along the bottom of the image with the ground surface at about 83 percent of the image height, structures standing on the ground, empty plain flat solid light grey background above and behind the structures instead of sky, seamless left and right edges for horizontal tiling, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and tarnished oxidized brass, distressed print texture --ar 21:9 --no sky, clouds, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame, shiny gold
```

**`env_circle_04_t3_front`** — Camada da frente

> **Gerar:** `--ar 3:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **3240 × 1080 px**, 72 ppi, sRGB · centro livre entre x ≈ 600 e x ≈ 2640 px  
> Remover o cinza

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, foreground layer only for parallax, rocks and scattered coins, dark near-black silhouettes only at the far left edge, the far right edge and along the very bottom edge, the whole center of the image completely empty, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and tarnished oxidized brass, distressed print texture --ar 3:1 --no sky, ground in the center, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame, shiny gold
```

### Chefe · Tesouraria de Mamom

**`env_circle_04_boss_ref`** — Referência completa

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** · só referência (guardar em `art_source/`)

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, full scene, a vault ceiling with heavy hanging chains, towering stacks of tarnished coins in a vast underground vault, chains and coin heaps at the edges, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and tarnished oxidized brass, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, shiny gold
```

**`env_circle_04_boss_back`** — Camada de fundo

> **Gerar:** `--ar 21:9` + Upscale 2× (≈ 3360 × 1440 px)  
> **Arquivo final:** PNG RGB opaco, **2560 × 1080 px**, 72 ppi, sRGB

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, far background layer only for parallax, a vault ceiling with heavy hanging chains, distant, low contrast, atmospheric haze, no foreground objects and no near ground, fills the whole frame edge to edge, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and tarnished oxidized brass, distressed print texture --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, foreground, frame, shiny gold
```

**`env_circle_04_boss_mid`** — Camada do meio (chão de caminhada)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px**, 72 ppi, sRGB · superfície do chão em **y ≈ 900 px** · bordas laterais emendáveis  
> Remover o cinza acima das estruturas

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, middle layer only for parallax, towering stacks of tarnished coins in a vast underground vault, a continuous flat walkable ground strip along the bottom of the image with the ground surface at about 83 percent of the image height, structures standing on the ground, empty plain flat solid light grey background above and behind the structures instead of sky, seamless left and right edges for horizontal tiling, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and tarnished oxidized brass, distressed print texture --ar 21:9 --no sky, clouds, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame, shiny gold
```

**`env_circle_04_boss_front`** — Camada da frente

> **Gerar:** `--ar 3:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **3240 × 1080 px**, 72 ppi, sRGB · centro livre entre x ≈ 600 e x ≈ 2640 px  
> Remover o cinza

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, foreground layer only for parallax, chains and coin heaps, dark near-black silhouettes only at the far left edge, the far right edge and along the very bottom edge, the whole center of the image completely empty, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and tarnished oxidized brass, distressed print texture --ar 3:1 --no sky, ground in the center, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame, shiny gold
```

### Almas atormentadas

**`env_circle_04_souls_crowd`** — Multidão distante (camada animada entre `_back` e `_mid`)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px** · figuras pequenas (≈ 80–160 px de altura) · fundo removido  
> O motor anima com balanço, deriva e transparência; não é preciso quadro a quadro

```text
Dark gothic 2D side-view game background layer in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, two endless lines of damned souls in torn grey shrouds pushing enormous weights with their chests toward each other, clashing and shouting, then turning back, many small distant figures in the middle distance, readable silhouettes, all figures shrouded, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and tarnished oxidized brass, distressed print texture --ar 21:9 --no nudity, sexual, children, gore close-up, ground, sky, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_04_souls_sheet`** — Folha de 3 almas para animação (perto da câmera)

> **Gerar:** `--ar 3:2` + Upscale 2×  
> **Arquivo final:** Matriz PNG RGBA **3072 × 2048 px** em `art_source/`; cada alma recortada em PNG RGBA com **≈ 600 px** de altura  
> Para animação simples por rig ou deformação no Godot; recortar membros se necessário

```text
Dark gothic 2D game character sheet in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, three tormented damned souls of the same kind wrapped in torn grey shrouds, side view facing left, pose 1: pushing a huge stone weight with the chest; pose 2: two souls clashing weights, shouting; pose 3: turning back with the weight, exhausted, the three figures separated by wide empty space, same scale, full figures inside the frame, anguished faces, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors, palette of black, bone, ash grey and tarnished oxidized brass, isolated on a plain flat solid light grey background --ar 3:2 --no nudity, sexual, children, text, letters, UI, halo, cartoon, anime, glossy, 3D, photorealistic, white background
```

### Ambientação

**`fx_circle_04_ambient`** — Partículas do ambiente (folha de sprites)

> **Gerar:** `--ar 1:1` + Upscale 2×  
> **Arquivo final:** Matriz PNG RGBA **2048 × 2048 px**; cada sprite recortado em PNG RGBA de **64–256 px**  
> O motor espalha e anima as partículas

```text
2D game VFX sprite sheet in the style of Darkest Dungeon, hand-inked comic art, a grid of separate small particle sprites: dull tarnished coin glints, drifting dust, small pebbles, each sprite isolated with empty space around it, varied sizes, thick ink edges, palette of black, bone, ash grey and tarnished oxidized brass, isolated on a plain flat solid light grey background --ar 1:1 --no text, letters, numbers, grid lines, characters, cartoon, glossy, 3D, photorealistic, white background
```

**`env_circle_04_camp`** — Pouso deste círculo

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** (pode ser dividido em camadas como os trechos)

```text
Darkest Dungeon style 2D side-view camp background, hand-painted gothic horror, hand-inked comic art, a small campfire in a hollow among great abandoned weights, a few candles placed on a stone, bedrolls, the surrounding darkness of the circle pressing in, warm firelight in a small circle against cold shadow, empty flat floor strip in the foreground for characters, palette of black, bone, ash grey, warm amber and tarnished oxidized brass, thick black ink outlines, heavy black shadows, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_04_vigil`** — Vigília (antes do chefe)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px**

```text
Darkest Dungeon style 2D side-view background, hand-painted gothic horror, hand-inked comic art, a last quiet resting spot in a hollow among great abandoned weights, a single tall candle on a flat rock, the entrance to the boss lair looming in the darkness ahead, tense silence, empty flat floor strip in the foreground for characters, palette of black, bone, ash grey, warm amber and tarnished oxidized brass, thick black ink outlines, heavy black shadows, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_04_arrival`** — Chegada ao círculo (tela de transição e carregamento)

> **Gerar:** `--ar 16:9` + Upscale 2×  
> **Arquivo final:** PNG **1920 × 1080 px** (guardar a matriz em 3840 × 2160 em `art_source/`)  
> O motor coloca o nome do círculo por cima

```text
Dark gothic panoramic illustration in the style of Darkest Dungeon, hand-inked comic art, in the spirit of Gustave Dore engravings of the Inferno, a barren funnel valley where two rings of tiny souls push great weights against each other, seen from a high rocky ledge, tiny distant figures, immense scale, thick black ink outlines, heavy black shadows, crosshatched engraving texture, muted desaturated palette of black, bone, ash grey and tarnished oxidized brass, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, close-up characters, cartoon, glossy, 3D, photorealistic
```

## Ira e Acídia (`circle_05`) · cor `muddy dark red`

### T1 · Pântano do Estige

**`env_circle_05_t1_ref`** — Referência completa

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** · só referência (guardar em `art_source/`)

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, full scene, a low red-black sky over a marsh, black bubbling water, dead trees and mud banks, dead tree roots and bubbling mud at the edges, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and muddy dark red, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_05_t1_back`** — Camada de fundo

> **Gerar:** `--ar 21:9` + Upscale 2× (≈ 3360 × 1440 px)  
> **Arquivo final:** PNG RGB opaco, **2560 × 1080 px**, 72 ppi, sRGB

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, far background layer only for parallax, a low red-black sky over a marsh, distant, low contrast, atmospheric haze, no foreground objects and no near ground, fills the whole frame edge to edge, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and muddy dark red, distressed print texture --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, foreground, frame
```

**`env_circle_05_t1_mid`** — Camada do meio (chão de caminhada)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px**, 72 ppi, sRGB · superfície do chão em **y ≈ 900 px** · bordas laterais emendáveis  
> Remover o cinza acima das estruturas

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, middle layer only for parallax, black bubbling water, dead trees and mud banks, a continuous flat walkable ground strip along the bottom of the image with the ground surface at about 83 percent of the image height, structures standing on the ground, empty plain flat solid light grey background above and behind the structures instead of sky, seamless left and right edges for horizontal tiling, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and muddy dark red, distressed print texture --ar 21:9 --no sky, clouds, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

**`env_circle_05_t1_front`** — Camada da frente

> **Gerar:** `--ar 3:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **3240 × 1080 px**, 72 ppi, sRGB · centro livre entre x ≈ 600 e x ≈ 2640 px  
> Remover o cinza

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, foreground layer only for parallax, dead tree roots and bubbling mud, dark near-black silhouettes only at the far left edge, the far right edge and along the very bottom edge, the whole center of the image completely empty, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and muddy dark red, distressed print texture --ar 3:1 --no sky, ground in the center, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

### T2 · Barca de Flégias

**`env_circle_05_t2_ref`** — Referência completa

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** · só referência (guardar em `art_source/`)

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, full scene, the distant towers of the city of Dis glowing faintly across the Styx, a narrow muddy causeway beside the open black water, reeds and mud at the edges, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and muddy dark red, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_05_t2_back`** — Camada de fundo

> **Gerar:** `--ar 21:9` + Upscale 2× (≈ 3360 × 1440 px)  
> **Arquivo final:** PNG RGB opaco, **2560 × 1080 px**, 72 ppi, sRGB

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, far background layer only for parallax, the distant towers of the city of Dis glowing faintly across the Styx, distant, low contrast, atmospheric haze, no foreground objects and no near ground, fills the whole frame edge to edge, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and muddy dark red, distressed print texture --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, foreground, frame
```

**`env_circle_05_t2_mid`** — Camada do meio (chão de caminhada)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px**, 72 ppi, sRGB · superfície do chão em **y ≈ 900 px** · bordas laterais emendáveis  
> Remover o cinza acima das estruturas

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, middle layer only for parallax, a narrow muddy causeway beside the open black water, a continuous flat walkable ground strip along the bottom of the image with the ground surface at about 83 percent of the image height, structures standing on the ground, empty plain flat solid light grey background above and behind the structures instead of sky, seamless left and right edges for horizontal tiling, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and muddy dark red, distressed print texture --ar 21:9 --no sky, clouds, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

**`env_circle_05_t2_front`** — Camada da frente

> **Gerar:** `--ar 3:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **3240 × 1080 px**, 72 ppi, sRGB · centro livre entre x ≈ 600 e x ≈ 2640 px  
> Remover o cinza

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, foreground layer only for parallax, reeds and mud, dark near-black silhouettes only at the far left edge, the far right edge and along the very bottom edge, the whole center of the image completely empty, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and muddy dark red, distressed print texture --ar 3:1 --no sky, ground in the center, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

### T3 · Lodo profundo

**`env_circle_05_t3_ref`** — Referência completa

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** · só referência (guardar em `art_source/`)

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, full scene, heavy fog, fields of deep sucking mud with half-sunken shapes and rising bubbles, half-sunken broken shapes and mud at the edges, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and muddy dark red, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_05_t3_back`** — Camada de fundo

> **Gerar:** `--ar 21:9` + Upscale 2× (≈ 3360 × 1440 px)  
> **Arquivo final:** PNG RGB opaco, **2560 × 1080 px**, 72 ppi, sRGB

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, far background layer only for parallax, heavy fog, distant, low contrast, atmospheric haze, no foreground objects and no near ground, fills the whole frame edge to edge, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and muddy dark red, distressed print texture --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, foreground, frame
```

**`env_circle_05_t3_mid`** — Camada do meio (chão de caminhada)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px**, 72 ppi, sRGB · superfície do chão em **y ≈ 900 px** · bordas laterais emendáveis  
> Remover o cinza acima das estruturas

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, middle layer only for parallax, fields of deep sucking mud with half-sunken shapes and rising bubbles, a continuous flat walkable ground strip along the bottom of the image with the ground surface at about 83 percent of the image height, structures standing on the ground, empty plain flat solid light grey background above and behind the structures instead of sky, seamless left and right edges for horizontal tiling, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and muddy dark red, distressed print texture --ar 21:9 --no sky, clouds, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

**`env_circle_05_t3_front`** — Camada da frente

> **Gerar:** `--ar 3:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **3240 × 1080 px**, 72 ppi, sRGB · centro livre entre x ≈ 600 e x ≈ 2640 px  
> Remover o cinza

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, foreground layer only for parallax, half-sunken broken shapes and mud, dark near-black silhouettes only at the far left edge, the far right edge and along the very bottom edge, the whole center of the image completely empty, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and muddy dark red, distressed print texture --ar 3:1 --no sky, ground in the center, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

### Chefe · Muralhas de Dite

**`env_circle_05_boss_ref`** — Referência completa

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** · só referência (guardar em `art_source/`)

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, full scene, towering red-hot iron walls of the city of Dis rising into the sky, the foot of the walls with closed iron gates, the Styx lapping at their base, rubble and dark water at the edges, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and muddy dark red, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_05_boss_back`** — Camada de fundo

> **Gerar:** `--ar 21:9` + Upscale 2× (≈ 3360 × 1440 px)  
> **Arquivo final:** PNG RGB opaco, **2560 × 1080 px**, 72 ppi, sRGB

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, far background layer only for parallax, towering red-hot iron walls of the city of Dis rising into the sky, distant, low contrast, atmospheric haze, no foreground objects and no near ground, fills the whole frame edge to edge, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and muddy dark red, distressed print texture --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, foreground, frame
```

**`env_circle_05_boss_mid`** — Camada do meio (chão de caminhada)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px**, 72 ppi, sRGB · superfície do chão em **y ≈ 900 px** · bordas laterais emendáveis  
> Remover o cinza acima das estruturas

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, middle layer only for parallax, the foot of the walls with closed iron gates, the Styx lapping at their base, a continuous flat walkable ground strip along the bottom of the image with the ground surface at about 83 percent of the image height, structures standing on the ground, empty plain flat solid light grey background above and behind the structures instead of sky, seamless left and right edges for horizontal tiling, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and muddy dark red, distressed print texture --ar 21:9 --no sky, clouds, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

**`env_circle_05_boss_front`** — Camada da frente

> **Gerar:** `--ar 3:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **3240 × 1080 px**, 72 ppi, sRGB · centro livre entre x ≈ 600 e x ≈ 2640 px  
> Remover o cinza

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, foreground layer only for parallax, rubble and dark water, dark near-black silhouettes only at the far left edge, the far right edge and along the very bottom edge, the whole center of the image completely empty, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and muddy dark red, distressed print texture --ar 3:1 --no sky, ground in the center, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

### Almas atormentadas

**`env_circle_05_souls_crowd`** — Multidão distante (camada animada entre `_back` e `_mid`)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px** · figuras pequenas (≈ 80–160 px de altura) · fundo removido  
> O motor anima com balanço, deriva e transparência; não é preciso quadro a quadro

```text
Dark gothic 2D side-view game background layer in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, wrathful souls in torn shrouds fighting each other in the mud of the Styx, striking and grappling; bubbles rising where the sullen lie submerged, many small distant figures in the middle distance, readable silhouettes, all figures shrouded, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and muddy dark red, distressed print texture --ar 21:9 --no nudity, sexual, children, gore close-up, ground, sky, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_05_souls_sheet`** — Folha de 3 almas para animação (perto da câmera)

> **Gerar:** `--ar 3:2` + Upscale 2×  
> **Arquivo final:** Matriz PNG RGBA **3072 × 2048 px** em `art_source/`; cada alma recortada em PNG RGBA com **≈ 600 px** de altura  
> Para animação simples por rig ou deformação no Godot; recortar membros se necessário

```text
Dark gothic 2D game character sheet in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, three tormented damned souls of the same kind wrapped in torn grey shrouds, side view facing left, pose 1: striking another soul with both fists; pose 2: grappling and pulling in the mud; pose 3: only head and shoulders above the mud, sullen, bubbles around, the three figures separated by wide empty space, same scale, full figures inside the frame, anguished faces, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors, palette of black, bone, ash grey and muddy dark red, isolated on a plain flat solid light grey background --ar 3:2 --no nudity, sexual, children, text, letters, UI, halo, cartoon, anime, glossy, 3D, photorealistic, white background
```

### Ambientação

**`fx_circle_05_ambient`** — Partículas do ambiente (folha de sprites)

> **Gerar:** `--ar 1:1` + Upscale 2×  
> **Arquivo final:** Matriz PNG RGBA **2048 × 2048 px**; cada sprite recortado em PNG RGBA de **64–256 px**  
> O motor espalha e anima as partículas

```text
2D game VFX sprite sheet in the style of Darkest Dungeon, hand-inked comic art, a grid of separate small particle sprites: mud bubbles, red mist puffs, splashes, each sprite isolated with empty space around it, varied sizes, thick ink edges, palette of black, bone, ash grey and muddy dark red, isolated on a plain flat solid light grey background --ar 1:1 --no text, letters, numbers, grid lines, characters, cartoon, glossy, 3D, photorealistic, white background
```

**`env_circle_05_camp`** — Pouso deste círculo

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** (pode ser dividido em camadas como os trechos)

```text
Darkest Dungeon style 2D side-view camp background, hand-painted gothic horror, hand-inked comic art, a small campfire on a mud bank by the Styx, a few candles placed on a stone, bedrolls, the surrounding darkness of the circle pressing in, warm firelight in a small circle against cold shadow, empty flat floor strip in the foreground for characters, palette of black, bone, ash grey, warm amber and muddy dark red, thick black ink outlines, heavy black shadows, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_05_vigil`** — Vigília (antes do chefe)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px**

```text
Darkest Dungeon style 2D side-view background, hand-painted gothic horror, hand-inked comic art, a last quiet resting spot on a mud bank by the Styx, a single tall candle on a flat rock, the entrance to the boss lair looming in the darkness ahead, tense silence, empty flat floor strip in the foreground for characters, palette of black, bone, ash grey, warm amber and muddy dark red, thick black ink outlines, heavy black shadows, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_05_arrival`** — Chegada ao círculo (tela de transição e carregamento)

> **Gerar:** `--ar 16:9` + Upscale 2×  
> **Arquivo final:** PNG **1920 × 1080 px** (guardar a matriz em 3840 × 2160 em `art_source/`)  
> O motor coloca o nome do círculo por cima

```text
Dark gothic panoramic illustration in the style of Darkest Dungeon, hand-inked comic art, in the spirit of Gustave Dore engravings of the Inferno, a vast black marsh, a small boat crossing, the red-hot walls of a city on the horizon, seen from a high rocky ledge, tiny distant figures, immense scale, thick black ink outlines, heavy black shadows, crosshatched engraving texture, muted desaturated palette of black, bone, ash grey and muddy dark red, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, close-up characters, cartoon, glossy, 3D, photorealistic
```

## Heresia (`circle_06`) · cor `ember orange`

### T1 · Portões de Dite

**`env_circle_06_t1_ref`** — Referência completa

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** · só referência (guardar em `art_source/`)

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, full scene, burning streets and towers of the city of Dis, massive iron gate doors hanging torn open from broken hinges, broken hinge debris and embers at the edges, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and ember orange, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_06_t1_back`** — Camada de fundo

> **Gerar:** `--ar 21:9` + Upscale 2× (≈ 3360 × 1440 px)  
> **Arquivo final:** PNG RGB opaco, **2560 × 1080 px**, 72 ppi, sRGB

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, far background layer only for parallax, burning streets and towers of the city of Dis, distant, low contrast, atmospheric haze, no foreground objects and no near ground, fills the whole frame edge to edge, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and ember orange, distressed print texture --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, foreground, frame
```

**`env_circle_06_t1_mid`** — Camada do meio (chão de caminhada)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px**, 72 ppi, sRGB · superfície do chão em **y ≈ 900 px** · bordas laterais emendáveis  
> Remover o cinza acima das estruturas

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, middle layer only for parallax, massive iron gate doors hanging torn open from broken hinges, a continuous flat walkable ground strip along the bottom of the image with the ground surface at about 83 percent of the image height, structures standing on the ground, empty plain flat solid light grey background above and behind the structures instead of sky, seamless left and right edges for horizontal tiling, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and ember orange, distressed print texture --ar 21:9 --no sky, clouds, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

**`env_circle_06_t1_front`** — Camada da frente

> **Gerar:** `--ar 3:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **3240 × 1080 px**, 72 ppi, sRGB · centro livre entre x ≈ 600 e x ≈ 2640 px  
> Remover o cinza

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, foreground layer only for parallax, broken hinge debris and embers, dark near-black silhouettes only at the far left edge, the far right edge and along the very bottom edge, the whole center of the image completely empty, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and ember orange, distressed print texture --ar 3:1 --no sky, ground in the center, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

### T2 · Campo de túmulos

**`env_circle_06_t2_ref`** — Referência completa

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** · só referência (guardar em `art_source/`)

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, full scene, an endless field of burning tombs to the horizon, open stone sarcophagi with flames rising from inside, heavy lids leaning against them, a sarcophagus lid and low flames at the edges, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and ember orange, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_06_t2_back`** — Camada de fundo

> **Gerar:** `--ar 21:9` + Upscale 2× (≈ 3360 × 1440 px)  
> **Arquivo final:** PNG RGB opaco, **2560 × 1080 px**, 72 ppi, sRGB

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, far background layer only for parallax, an endless field of burning tombs to the horizon, distant, low contrast, atmospheric haze, no foreground objects and no near ground, fills the whole frame edge to edge, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and ember orange, distressed print texture --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, foreground, frame
```

**`env_circle_06_t2_mid`** — Camada do meio (chão de caminhada)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px**, 72 ppi, sRGB · superfície do chão em **y ≈ 900 px** · bordas laterais emendáveis  
> Remover o cinza acima das estruturas

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, middle layer only for parallax, open stone sarcophagi with flames rising from inside, heavy lids leaning against them, a continuous flat walkable ground strip along the bottom of the image with the ground surface at about 83 percent of the image height, structures standing on the ground, empty plain flat solid light grey background above and behind the structures instead of sky, seamless left and right edges for horizontal tiling, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and ember orange, distressed print texture --ar 21:9 --no sky, clouds, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

**`env_circle_06_t2_front`** — Camada da frente

> **Gerar:** `--ar 3:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **3240 × 1080 px**, 72 ppi, sRGB · centro livre entre x ≈ 600 e x ≈ 2640 px  
> Remover o cinza

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, foreground layer only for parallax, a sarcophagus lid and low flames, dark near-black silhouettes only at the far left edge, the far right edge and along the very bottom edge, the whole center of the image completely empty, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and ember orange, distressed print texture --ar 3:1 --no sky, ground in the center, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

### T3 · Necrópole em chamas

**`env_circle_06_t3_ref`** — Referência completa

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** · só referência (guardar em `art_source/`)

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, full scene, collapsed domes and burning mausoleums in the distance, a burning necropolis street of gothic mausoleums, broken tombstones and embers at the edges, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and ember orange, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_06_t3_back`** — Camada de fundo

> **Gerar:** `--ar 21:9` + Upscale 2× (≈ 3360 × 1440 px)  
> **Arquivo final:** PNG RGB opaco, **2560 × 1080 px**, 72 ppi, sRGB

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, far background layer only for parallax, collapsed domes and burning mausoleums in the distance, distant, low contrast, atmospheric haze, no foreground objects and no near ground, fills the whole frame edge to edge, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and ember orange, distressed print texture --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, foreground, frame
```

**`env_circle_06_t3_mid`** — Camada do meio (chão de caminhada)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px**, 72 ppi, sRGB · superfície do chão em **y ≈ 900 px** · bordas laterais emendáveis  
> Remover o cinza acima das estruturas

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, middle layer only for parallax, a burning necropolis street of gothic mausoleums, a continuous flat walkable ground strip along the bottom of the image with the ground surface at about 83 percent of the image height, structures standing on the ground, empty plain flat solid light grey background above and behind the structures instead of sky, seamless left and right edges for horizontal tiling, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and ember orange, distressed print texture --ar 21:9 --no sky, clouds, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

**`env_circle_06_t3_front`** — Camada da frente

> **Gerar:** `--ar 3:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **3240 × 1080 px**, 72 ppi, sRGB · centro livre entre x ≈ 600 e x ≈ 2640 px  
> Remover o cinza

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, foreground layer only for parallax, broken tombstones and embers, dark near-black silhouettes only at the far left edge, the far right edge and along the very bottom edge, the whole center of the image completely empty, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and ember orange, distressed print texture --ar 3:1 --no sky, ground in the center, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

### Chefe · Trono de Belial

**`env_circle_06_boss_ref`** — Referência completa

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** · só referência (guardar em `art_source/`)

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, full scene, a vast black hall with inverted columns hanging from the ceiling, a throne of fused tombstones, fire glowing through cracks in the floor, cracked glowing floor slabs at the edges, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and ember orange, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, crosses, altar
```

**`env_circle_06_boss_back`** — Camada de fundo

> **Gerar:** `--ar 21:9` + Upscale 2× (≈ 3360 × 1440 px)  
> **Arquivo final:** PNG RGB opaco, **2560 × 1080 px**, 72 ppi, sRGB

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, far background layer only for parallax, a vast black hall with inverted columns hanging from the ceiling, distant, low contrast, atmospheric haze, no foreground objects and no near ground, fills the whole frame edge to edge, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and ember orange, distressed print texture --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, foreground, frame, crosses, altar
```

**`env_circle_06_boss_mid`** — Camada do meio (chão de caminhada)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px**, 72 ppi, sRGB · superfície do chão em **y ≈ 900 px** · bordas laterais emendáveis  
> Remover o cinza acima das estruturas

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, middle layer only for parallax, a throne of fused tombstones, fire glowing through cracks in the floor, a continuous flat walkable ground strip along the bottom of the image with the ground surface at about 83 percent of the image height, structures standing on the ground, empty plain flat solid light grey background above and behind the structures instead of sky, seamless left and right edges for horizontal tiling, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and ember orange, distressed print texture --ar 21:9 --no sky, clouds, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame, crosses, altar
```

**`env_circle_06_boss_front`** — Camada da frente

> **Gerar:** `--ar 3:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **3240 × 1080 px**, 72 ppi, sRGB · centro livre entre x ≈ 600 e x ≈ 2640 px  
> Remover o cinza

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, foreground layer only for parallax, cracked glowing floor slabs, dark near-black silhouettes only at the far left edge, the far right edge and along the very bottom edge, the whole center of the image completely empty, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and ember orange, distressed print texture --ar 3:1 --no sky, ground in the center, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame, crosses, altar
```

### Almas atormentadas

**`env_circle_06_souls_crowd`** — Multidão distante (camada animada entre `_back` e `_mid`)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px** · figuras pequenas (≈ 80–160 px de altura) · fundo removido  
> O motor anima com balanço, deriva e transparência; não é preciso quadro a quadro

```text
Dark gothic 2D side-view game background layer in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, heretic souls rising half out of open burning tombs, wailing, then sinking back into the flames, many small distant figures in the middle distance, readable silhouettes, all figures shrouded, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and ember orange, distressed print texture --ar 21:9 --no nudity, sexual, children, gore close-up, ground, sky, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_06_souls_sheet`** — Folha de 3 almas para animação (perto da câmera)

> **Gerar:** `--ar 3:2` + Upscale 2×  
> **Arquivo final:** Matriz PNG RGBA **3072 × 2048 px** em `art_source/`; cada alma recortada em PNG RGBA com **≈ 600 px** de altura  
> Para animação simples por rig ou deformação no Godot; recortar membros se necessário

```text
Dark gothic 2D game character sheet in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, three tormented damned souls of the same kind wrapped in torn grey shrouds, side view facing left, pose 1: rising half out of a burning tomb; pose 2: one arm raised from the tomb, wailing; pose 3: sinking back into the tomb, the three figures separated by wide empty space, same scale, full figures inside the frame, anguished faces, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors, palette of black, bone, ash grey and ember orange, isolated on a plain flat solid light grey background --ar 3:2 --no nudity, sexual, children, text, letters, UI, halo, cartoon, anime, glossy, 3D, photorealistic, white background
```

### Ambientação

**`fx_circle_06_ambient`** — Partículas do ambiente (folha de sprites)

> **Gerar:** `--ar 1:1` + Upscale 2×  
> **Arquivo final:** Matriz PNG RGBA **2048 × 2048 px**; cada sprite recortado em PNG RGBA de **64–256 px**  
> O motor espalha e anima as partículas

```text
2D game VFX sprite sheet in the style of Darkest Dungeon, hand-inked comic art, a grid of separate small particle sprites: embers, small flame tongues, smoke wisps, each sprite isolated with empty space around it, varied sizes, thick ink edges, palette of black, bone, ash grey and ember orange, isolated on a plain flat solid light grey background --ar 1:1 --no text, letters, numbers, grid lines, characters, cartoon, glossy, 3D, photorealistic, white background
```

**`env_circle_06_camp`** — Pouso deste círculo

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** (pode ser dividido em camadas como os trechos)

```text
Darkest Dungeon style 2D side-view camp background, hand-painted gothic horror, hand-inked comic art, a small campfire inside a cold, empty tomb chamber, a few candles placed on a stone, bedrolls, the surrounding darkness of the circle pressing in, warm firelight in a small circle against cold shadow, empty flat floor strip in the foreground for characters, palette of black, bone, ash grey, warm amber and ember orange, thick black ink outlines, heavy black shadows, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_06_vigil`** — Vigília (antes do chefe)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px**

```text
Darkest Dungeon style 2D side-view background, hand-painted gothic horror, hand-inked comic art, a last quiet resting spot inside a cold, empty tomb chamber, a single tall candle on a flat rock, the entrance to the boss lair looming in the darkness ahead, tense silence, empty flat floor strip in the foreground for characters, palette of black, bone, ash grey, warm amber and ember orange, thick black ink outlines, heavy black shadows, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_06_arrival`** — Chegada ao círculo (tela de transição e carregamento)

> **Gerar:** `--ar 16:9` + Upscale 2×  
> **Arquivo final:** PNG **1920 × 1080 px** (guardar a matriz em 3840 × 2160 em `art_source/`)  
> O motor coloca o nome do círculo por cima

```text
Dark gothic panoramic illustration in the style of Darkest Dungeon, hand-inked comic art, in the spirit of Gustave Dore engravings of the Inferno, a burning city of iron walls and towers, an endless field of open flaming tombs inside, seen from a high rocky ledge, tiny distant figures, immense scale, thick black ink outlines, heavy black shadows, crosshatched engraving texture, muted desaturated palette of black, bone, ash grey and ember orange, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, close-up characters, cartoon, glossy, 3D, photorealistic
```

## Violência (`circle_07`) · cor `deep crimson`

### T1 · Flegetonte

**`env_circle_07_t1_ref`** — Referência completa

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** · só referência (guardar em `art_source/`)

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, full scene, red rocks and steam rising over the river, the bank of a wide river of boiling blood steaming between red rocks, red rocks and steam at the edges, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and deep crimson, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_07_t1_back`** — Camada de fundo

> **Gerar:** `--ar 21:9` + Upscale 2× (≈ 3360 × 1440 px)  
> **Arquivo final:** PNG RGB opaco, **2560 × 1080 px**, 72 ppi, sRGB

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, far background layer only for parallax, red rocks and steam rising over the river, distant, low contrast, atmospheric haze, no foreground objects and no near ground, fills the whole frame edge to edge, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and deep crimson, distressed print texture --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, foreground, frame
```

**`env_circle_07_t1_mid`** — Camada do meio (chão de caminhada)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px**, 72 ppi, sRGB · superfície do chão em **y ≈ 900 px** · bordas laterais emendáveis  
> Remover o cinza acima das estruturas

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, middle layer only for parallax, the bank of a wide river of boiling blood steaming between red rocks, a continuous flat walkable ground strip along the bottom of the image with the ground surface at about 83 percent of the image height, structures standing on the ground, empty plain flat solid light grey background above and behind the structures instead of sky, seamless left and right edges for horizontal tiling, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and deep crimson, distressed print texture --ar 21:9 --no sky, clouds, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

**`env_circle_07_t1_front`** — Camada da frente

> **Gerar:** `--ar 3:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **3240 × 1080 px**, 72 ppi, sRGB · centro livre entre x ≈ 600 e x ≈ 2640 px  
> Remover o cinza

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, foreground layer only for parallax, red rocks and steam, dark near-black silhouettes only at the far left edge, the far right edge and along the very bottom edge, the whole center of the image completely empty, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and deep crimson, distressed print texture --ar 3:1 --no sky, ground in the center, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

### T2 · Selva escura

**`env_circle_07_t2_ref`** — Referência completa

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** · só referência (guardar em `art_source/`)

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, full scene, the dense gloom of twisted trees, a dark forest of gnarled leafless trees with knotted black bark and thorny branches, thorny branches framing the edges at the edges, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and deep crimson, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, hanging, rope
```

**`env_circle_07_t2_back`** — Camada de fundo

> **Gerar:** `--ar 21:9` + Upscale 2× (≈ 3360 × 1440 px)  
> **Arquivo final:** PNG RGB opaco, **2560 × 1080 px**, 72 ppi, sRGB

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, far background layer only for parallax, the dense gloom of twisted trees, distant, low contrast, atmospheric haze, no foreground objects and no near ground, fills the whole frame edge to edge, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and deep crimson, distressed print texture --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, foreground, frame, hanging, rope
```

**`env_circle_07_t2_mid`** — Camada do meio (chão de caminhada)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px**, 72 ppi, sRGB · superfície do chão em **y ≈ 900 px** · bordas laterais emendáveis  
> Remover o cinza acima das estruturas

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, middle layer only for parallax, a dark forest of gnarled leafless trees with knotted black bark and thorny branches, a continuous flat walkable ground strip along the bottom of the image with the ground surface at about 83 percent of the image height, structures standing on the ground, empty plain flat solid light grey background above and behind the structures instead of sky, seamless left and right edges for horizontal tiling, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and deep crimson, distressed print texture --ar 21:9 --no sky, clouds, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame, hanging, rope
```

**`env_circle_07_t2_front`** — Camada da frente

> **Gerar:** `--ar 3:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **3240 × 1080 px**, 72 ppi, sRGB · centro livre entre x ≈ 600 e x ≈ 2640 px  
> Remover o cinza

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, foreground layer only for parallax, thorny branches framing the edges, dark near-black silhouettes only at the far left edge, the far right edge and along the very bottom edge, the whole center of the image completely empty, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and deep crimson, distressed print texture --ar 3:1 --no sky, ground in the center, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame, hanging, rope
```

### T3 · Areia ardente

**`env_circle_07_t3_ref`** — Referência completa

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** · só referência (guardar em `art_source/`)

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, full scene, a slow rain of falling fire flakes in a dark sky, a desert of burning sand with scorched rocks, scorched rocks and falling fire flakes at the edges, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and deep crimson, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_07_t3_back`** — Camada de fundo

> **Gerar:** `--ar 21:9` + Upscale 2× (≈ 3360 × 1440 px)  
> **Arquivo final:** PNG RGB opaco, **2560 × 1080 px**, 72 ppi, sRGB

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, far background layer only for parallax, a slow rain of falling fire flakes in a dark sky, distant, low contrast, atmospheric haze, no foreground objects and no near ground, fills the whole frame edge to edge, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and deep crimson, distressed print texture --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, foreground, frame
```

**`env_circle_07_t3_mid`** — Camada do meio (chão de caminhada)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px**, 72 ppi, sRGB · superfície do chão em **y ≈ 900 px** · bordas laterais emendáveis  
> Remover o cinza acima das estruturas

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, middle layer only for parallax, a desert of burning sand with scorched rocks, a continuous flat walkable ground strip along the bottom of the image with the ground surface at about 83 percent of the image height, structures standing on the ground, empty plain flat solid light grey background above and behind the structures instead of sky, seamless left and right edges for horizontal tiling, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and deep crimson, distressed print texture --ar 21:9 --no sky, clouds, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

**`env_circle_07_t3_front`** — Camada da frente

> **Gerar:** `--ar 3:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **3240 × 1080 px**, 72 ppi, sRGB · centro livre entre x ≈ 600 e x ≈ 2640 px  
> Remover o cinza

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, foreground layer only for parallax, scorched rocks and falling fire flakes, dark near-black silhouettes only at the far left edge, the far right edge and along the very bottom edge, the whole center of the image completely empty, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and deep crimson, distressed print texture --ar 3:1 --no sky, ground in the center, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

### Chefe · Fornalha de Moloque

**`env_circle_07_boss_ref`** — Referência completa

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** · só referência (guardar em `art_source/`)

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, full scene, a colossal furnace chamber filled with thick smoke, a bronze and stone floor with glowing grates, chains and pipes, pipes and chains at the edges, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and deep crimson, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, children
```

**`env_circle_07_boss_back`** — Camada de fundo

> **Gerar:** `--ar 21:9` + Upscale 2× (≈ 3360 × 1440 px)  
> **Arquivo final:** PNG RGB opaco, **2560 × 1080 px**, 72 ppi, sRGB

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, far background layer only for parallax, a colossal furnace chamber filled with thick smoke, distant, low contrast, atmospheric haze, no foreground objects and no near ground, fills the whole frame edge to edge, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and deep crimson, distressed print texture --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, foreground, frame, children
```

**`env_circle_07_boss_mid`** — Camada do meio (chão de caminhada)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px**, 72 ppi, sRGB · superfície do chão em **y ≈ 900 px** · bordas laterais emendáveis  
> Remover o cinza acima das estruturas

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, middle layer only for parallax, a bronze and stone floor with glowing grates, chains and pipes, a continuous flat walkable ground strip along the bottom of the image with the ground surface at about 83 percent of the image height, structures standing on the ground, empty plain flat solid light grey background above and behind the structures instead of sky, seamless left and right edges for horizontal tiling, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and deep crimson, distressed print texture --ar 21:9 --no sky, clouds, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame, children
```

**`env_circle_07_boss_front`** — Camada da frente

> **Gerar:** `--ar 3:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **3240 × 1080 px**, 72 ppi, sRGB · centro livre entre x ≈ 600 e x ≈ 2640 px  
> Remover o cinza

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, foreground layer only for parallax, pipes and chains, dark near-black silhouettes only at the far left edge, the far right edge and along the very bottom edge, the whole center of the image completely empty, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and deep crimson, distressed print texture --ar 3:1 --no sky, ground in the center, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame, children
```

### Almas atormentadas

**`env_circle_07_souls_crowd`** — Multidão distante (camada animada entre `_back` e `_mid`)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px** · figuras pequenas (≈ 80–160 px de altura) · fundo removido  
> O motor anima com balanço, deriva e transparência; não é preciso quadro a quadro

```text
Dark gothic 2D side-view game background layer in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, damned souls in torn shrouds submerged to the chest in a river of boiling blood, and souls lying on burning sand under a slow rain of fire, many small distant figures in the middle distance, readable silhouettes, all figures shrouded, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and deep crimson, distressed print texture --ar 21:9 --no nudity, sexual, children, gore close-up, ground, sky, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_07_souls_sheet`** — Folha de 3 almas para animação (perto da câmera)

> **Gerar:** `--ar 3:2` + Upscale 2×  
> **Arquivo final:** Matriz PNG RGBA **3072 × 2048 px** em `art_source/`; cada alma recortada em PNG RGBA com **≈ 600 px** de altura  
> Para animação simples por rig ou deformação no Godot; recortar membros se necessário

```text
Dark gothic 2D game character sheet in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, three tormented damned souls of the same kind wrapped in torn grey shrouds, side view facing left, pose 1: submerged to the chest in boiling blood, reaching out; pose 2: lying on burning sand, shielding the face from falling fire; pose 3: crouched on the sand, hunched and tormented, the three figures separated by wide empty space, same scale, full figures inside the frame, anguished faces, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors, palette of black, bone, ash grey and deep crimson, isolated on a plain flat solid light grey background --ar 3:2 --no nudity, sexual, children, text, letters, UI, halo, cartoon, anime, glossy, 3D, photorealistic, white background
```

### Ambientação

**`fx_circle_07_ambient`** — Partículas do ambiente (folha de sprites)

> **Gerar:** `--ar 1:1` + Upscale 2×  
> **Arquivo final:** Matriz PNG RGBA **2048 × 2048 px**; cada sprite recortado em PNG RGBA de **64–256 px**  
> O motor espalha e anima as partículas

```text
2D game VFX sprite sheet in the style of Darkest Dungeon, hand-inked comic art, a grid of separate small particle sprites: falling fire flakes, blood-red steam, ash, each sprite isolated with empty space around it, varied sizes, thick ink edges, palette of black, bone, ash grey and deep crimson, isolated on a plain flat solid light grey background --ar 1:1 --no text, letters, numbers, grid lines, characters, cartoon, glossy, 3D, photorealistic, white background
```

**`env_circle_07_camp`** — Pouso deste círculo

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** (pode ser dividido em camadas como os trechos)

```text
Darkest Dungeon style 2D side-view camp background, hand-painted gothic horror, hand-inked comic art, a small campfire in the lee of red rocks, a few candles placed on a stone, bedrolls, the surrounding darkness of the circle pressing in, warm firelight in a small circle against cold shadow, empty flat floor strip in the foreground for characters, palette of black, bone, ash grey, warm amber and deep crimson, thick black ink outlines, heavy black shadows, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_07_vigil`** — Vigília (antes do chefe)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px**

```text
Darkest Dungeon style 2D side-view background, hand-painted gothic horror, hand-inked comic art, a last quiet resting spot in the lee of red rocks, a single tall candle on a flat rock, the entrance to the boss lair looming in the darkness ahead, tense silence, empty flat floor strip in the foreground for characters, palette of black, bone, ash grey, warm amber and deep crimson, thick black ink outlines, heavy black shadows, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_07_arrival`** — Chegada ao círculo (tela de transição e carregamento)

> **Gerar:** `--ar 16:9` + Upscale 2×  
> **Arquivo final:** PNG **1920 × 1080 px** (guardar a matriz em 3840 × 2160 em `art_source/`)  
> O motor coloca o nome do círculo por cima

```text
Dark gothic panoramic illustration in the style of Darkest Dungeon, hand-inked comic art, in the spirit of Gustave Dore engravings of the Inferno, a river of blood, a dark thorny wood and a burning desert in concentric rings, seen from a high rocky ledge, tiny distant figures, immense scale, thick black ink outlines, heavy black shadows, crosshatched engraving texture, muted desaturated palette of black, bone, ash grey and deep crimson, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, close-up characters, cartoon, glossy, 3D, photorealistic
```

## Fraude (`circle_08`) · cor `poison green`

### T1 · Pontes sobre as valas

**`env_circle_08_t1_ref`** — Referência completa

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** · só referência (guardar em `art_source/`)

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, full scene, a vast funnel of grey rock with concentric ditches and poisonous mist, the deck of a crumbling stone bridge at the edge of a ditch, bridge parapet fragments at the edges, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and poison green, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_08_t1_back`** — Camada de fundo

> **Gerar:** `--ar 21:9` + Upscale 2× (≈ 3360 × 1440 px)  
> **Arquivo final:** PNG RGB opaco, **2560 × 1080 px**, 72 ppi, sRGB

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, far background layer only for parallax, a vast funnel of grey rock with concentric ditches and poisonous mist, distant, low contrast, atmospheric haze, no foreground objects and no near ground, fills the whole frame edge to edge, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and poison green, distressed print texture --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, foreground, frame
```

**`env_circle_08_t1_mid`** — Camada do meio (chão de caminhada)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px**, 72 ppi, sRGB · superfície do chão em **y ≈ 900 px** · bordas laterais emendáveis  
> Remover o cinza acima das estruturas

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, middle layer only for parallax, the deck of a crumbling stone bridge at the edge of a ditch, a continuous flat walkable ground strip along the bottom of the image with the ground surface at about 83 percent of the image height, structures standing on the ground, empty plain flat solid light grey background above and behind the structures instead of sky, seamless left and right edges for horizontal tiling, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and poison green, distressed print texture --ar 21:9 --no sky, clouds, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

**`env_circle_08_t1_front`** — Camada da frente

> **Gerar:** `--ar 3:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **3240 × 1080 px**, 72 ppi, sRGB · centro livre entre x ≈ 600 e x ≈ 2640 px  
> Remover o cinza

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, foreground layer only for parallax, bridge parapet fragments, dark near-black silhouettes only at the far left edge, the far right edge and along the very bottom edge, the whole center of the image completely empty, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and poison green, distressed print texture --ar 3:1 --no sky, ground in the center, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

### T2 · Vala de piche

**`env_circle_08_t2_ref`** — Referência completa

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** · só referência (guardar em `art_source/`)

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, full scene, the dark rock walls of the ditch, the bank of a ditch of boiling black pitch, wooden planks and iron hooks, iron hooks, planks and tar bubbles at the edges, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and poison green, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_08_t2_back`** — Camada de fundo

> **Gerar:** `--ar 21:9` + Upscale 2× (≈ 3360 × 1440 px)  
> **Arquivo final:** PNG RGB opaco, **2560 × 1080 px**, 72 ppi, sRGB

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, far background layer only for parallax, the dark rock walls of the ditch, distant, low contrast, atmospheric haze, no foreground objects and no near ground, fills the whole frame edge to edge, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and poison green, distressed print texture --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, foreground, frame
```

**`env_circle_08_t2_mid`** — Camada do meio (chão de caminhada)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px**, 72 ppi, sRGB · superfície do chão em **y ≈ 900 px** · bordas laterais emendáveis  
> Remover o cinza acima das estruturas

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, middle layer only for parallax, the bank of a ditch of boiling black pitch, wooden planks and iron hooks, a continuous flat walkable ground strip along the bottom of the image with the ground surface at about 83 percent of the image height, structures standing on the ground, empty plain flat solid light grey background above and behind the structures instead of sky, seamless left and right edges for horizontal tiling, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and poison green, distressed print texture --ar 21:9 --no sky, clouds, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

**`env_circle_08_t2_front`** — Camada da frente

> **Gerar:** `--ar 3:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **3240 × 1080 px**, 72 ppi, sRGB · centro livre entre x ≈ 600 e x ≈ 2640 px  
> Remover o cinza

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, foreground layer only for parallax, iron hooks, planks and tar bubbles, dark near-black silhouettes only at the far left edge, the far right edge and along the very bottom edge, the whole center of the image completely empty, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and poison green, distressed print texture --ar 3:1 --no sky, ground in the center, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

### T3 · Poço dos Gigantes

**`env_circle_08_t3_ref`** — Referência completa

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** · só referência (guardar em `art_source/`)

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, full scene, gigantic stone pillars like towers looming in fog, the rim of a colossal pit with a sheer drop, rocks at the edge of the pit at the edges, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and poison green, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_08_t3_back`** — Camada de fundo

> **Gerar:** `--ar 21:9` + Upscale 2× (≈ 3360 × 1440 px)  
> **Arquivo final:** PNG RGB opaco, **2560 × 1080 px**, 72 ppi, sRGB

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, far background layer only for parallax, gigantic stone pillars like towers looming in fog, distant, low contrast, atmospheric haze, no foreground objects and no near ground, fills the whole frame edge to edge, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and poison green, distressed print texture --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, foreground, frame
```

**`env_circle_08_t3_mid`** — Camada do meio (chão de caminhada)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px**, 72 ppi, sRGB · superfície do chão em **y ≈ 900 px** · bordas laterais emendáveis  
> Remover o cinza acima das estruturas

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, middle layer only for parallax, the rim of a colossal pit with a sheer drop, a continuous flat walkable ground strip along the bottom of the image with the ground surface at about 83 percent of the image height, structures standing on the ground, empty plain flat solid light grey background above and behind the structures instead of sky, seamless left and right edges for horizontal tiling, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and poison green, distressed print texture --ar 21:9 --no sky, clouds, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

**`env_circle_08_t3_front`** — Camada da frente

> **Gerar:** `--ar 3:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **3240 × 1080 px**, 72 ppi, sRGB · centro livre entre x ≈ 600 e x ≈ 2640 px  
> Remover o cinza

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, foreground layer only for parallax, rocks at the edge of the pit, dark near-black silhouettes only at the far left edge, the far right edge and along the very bottom edge, the whole center of the image completely empty, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and poison green, distressed print texture --ar 3:1 --no sky, ground in the center, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

### Chefe · Oficina de Azazel

**`env_circle_08_boss_ref`** — Referência completa

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** · só referência (guardar em `art_source/`)

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, full scene, walls of cracked mirrors and porcelain masks, a cluttered infernal workshop with dark forges, weapons on racks and green flames, workbench clutter at the edges, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and poison green, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_08_boss_back`** — Camada de fundo

> **Gerar:** `--ar 21:9` + Upscale 2× (≈ 3360 × 1440 px)  
> **Arquivo final:** PNG RGB opaco, **2560 × 1080 px**, 72 ppi, sRGB

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, far background layer only for parallax, walls of cracked mirrors and porcelain masks, distant, low contrast, atmospheric haze, no foreground objects and no near ground, fills the whole frame edge to edge, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and poison green, distressed print texture --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, foreground, frame
```

**`env_circle_08_boss_mid`** — Camada do meio (chão de caminhada)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px**, 72 ppi, sRGB · superfície do chão em **y ≈ 900 px** · bordas laterais emendáveis  
> Remover o cinza acima das estruturas

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, middle layer only for parallax, a cluttered infernal workshop with dark forges, weapons on racks and green flames, a continuous flat walkable ground strip along the bottom of the image with the ground surface at about 83 percent of the image height, structures standing on the ground, empty plain flat solid light grey background above and behind the structures instead of sky, seamless left and right edges for horizontal tiling, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and poison green, distressed print texture --ar 21:9 --no sky, clouds, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

**`env_circle_08_boss_front`** — Camada da frente

> **Gerar:** `--ar 3:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **3240 × 1080 px**, 72 ppi, sRGB · centro livre entre x ≈ 600 e x ≈ 2640 px  
> Remover o cinza

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, foreground layer only for parallax, workbench clutter, dark near-black silhouettes only at the far left edge, the far right edge and along the very bottom edge, the whole center of the image completely empty, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and poison green, distressed print texture --ar 3:1 --no sky, ground in the center, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

### Almas atormentadas

**`env_circle_08_souls_crowd`** — Multidão distante (camada animada entre `_back` e `_mid`)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px** · figuras pequenas (≈ 80–160 px de altura) · fundo removido  
> O motor anima com balanço, deriva e transparência; não é preciso quadro a quadro

```text
Dark gothic 2D side-view game background layer in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, hypocrite souls walking slowly in heavy hooded cloaks of dull tarnished brass, never gold; thieves entangled by serpents; a counselor wrapped in a tongue of flame, many small distant figures in the middle distance, readable silhouettes, all figures shrouded, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and poison green, distressed print texture --ar 21:9 --no nudity, sexual, children, gore close-up, ground, sky, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_08_souls_sheet`** — Folha de 3 almas para animação (perto da câmera)

> **Gerar:** `--ar 3:2` + Upscale 2×  
> **Arquivo final:** Matriz PNG RGBA **3072 × 2048 px** em `art_source/`; cada alma recortada em PNG RGBA com **≈ 600 px** de altura  
> Para animação simples por rig ou deformação no Godot; recortar membros se necessário

```text
Dark gothic 2D game character sheet in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, three tormented damned souls of the same kind wrapped in torn grey shrouds, side view facing left, pose 1: walking slowly bent under a heavy hooded brass cloak; pose 2: entangled by serpents, struggling; pose 3: wrapped inside a tall tongue of green-tinged flame, the three figures separated by wide empty space, same scale, full figures inside the frame, anguished faces, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors, palette of black, bone, ash grey and poison green, isolated on a plain flat solid light grey background --ar 3:2 --no nudity, sexual, children, text, letters, UI, halo, cartoon, anime, glossy, 3D, photorealistic, white background
```

### Ambientação

**`fx_circle_08_ambient`** — Partículas do ambiente (folha de sprites)

> **Gerar:** `--ar 1:1` + Upscale 2×  
> **Arquivo final:** Matriz PNG RGBA **2048 × 2048 px**; cada sprite recortado em PNG RGBA de **64–256 px**  
> O motor espalha e anima as partículas

```text
2D game VFX sprite sheet in the style of Darkest Dungeon, hand-inked comic art, a grid of separate small particle sprites: poison mist puffs, tar bubbles, small green flames, each sprite isolated with empty space around it, varied sizes, thick ink edges, palette of black, bone, ash grey and poison green, isolated on a plain flat solid light grey background --ar 1:1 --no text, letters, numbers, grid lines, characters, cartoon, glossy, 3D, photorealistic, white background
```

**`env_circle_08_camp`** — Pouso deste círculo

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** (pode ser dividido em camadas como os trechos)

```text
Darkest Dungeon style 2D side-view camp background, hand-painted gothic horror, hand-inked comic art, a small campfire under a stone bridge arch, a few candles placed on a stone, bedrolls, the surrounding darkness of the circle pressing in, warm firelight in a small circle against cold shadow, empty flat floor strip in the foreground for characters, palette of black, bone, ash grey, warm amber and poison green, thick black ink outlines, heavy black shadows, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_08_vigil`** — Vigília (antes do chefe)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px**

```text
Darkest Dungeon style 2D side-view background, hand-painted gothic horror, hand-inked comic art, a last quiet resting spot under a stone bridge arch, a single tall candle on a flat rock, the entrance to the boss lair looming in the darkness ahead, tense silence, empty flat floor strip in the foreground for characters, palette of black, bone, ash grey, warm amber and poison green, thick black ink outlines, heavy black shadows, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_08_arrival`** — Chegada ao círculo (tela de transição e carregamento)

> **Gerar:** `--ar 16:9` + Upscale 2×  
> **Arquivo final:** PNG **1920 × 1080 px** (guardar a matriz em 3840 × 2160 em `art_source/`)  
> O motor coloca o nome do círculo por cima

```text
Dark gothic panoramic illustration in the style of Darkest Dungeon, hand-inked comic art, in the spirit of Gustave Dore engravings of the Inferno, ten concentric stone ditches crossed by bridges, poisonous mist, giant towers on the far rim, seen from a high rocky ledge, tiny distant figures, immense scale, thick black ink outlines, heavy black shadows, crosshatched engraving texture, muted desaturated palette of black, bone, ash grey and poison green, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, close-up characters, cartoon, glossy, 3D, photorealistic
```

## Traição (`circle_09`) · cor `icy pale blue`

### T1 · Caína

**`env_circle_09_t1_ref`** — Referência completa

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** · só referência (guardar em `art_source/`)

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, full scene, total darkness over a vast frozen lake, a grey-blue ice surface with dim shapes frozen beneath, ice shards at the edges, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and icy pale blue, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_09_t1_back`** — Camada de fundo

> **Gerar:** `--ar 21:9` + Upscale 2× (≈ 3360 × 1440 px)  
> **Arquivo final:** PNG RGB opaco, **2560 × 1080 px**, 72 ppi, sRGB

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, far background layer only for parallax, total darkness over a vast frozen lake, distant, low contrast, atmospheric haze, no foreground objects and no near ground, fills the whole frame edge to edge, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and icy pale blue, distressed print texture --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, foreground, frame
```

**`env_circle_09_t1_mid`** — Camada do meio (chão de caminhada)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px**, 72 ppi, sRGB · superfície do chão em **y ≈ 900 px** · bordas laterais emendáveis  
> Remover o cinza acima das estruturas

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, middle layer only for parallax, a grey-blue ice surface with dim shapes frozen beneath, a continuous flat walkable ground strip along the bottom of the image with the ground surface at about 83 percent of the image height, structures standing on the ground, empty plain flat solid light grey background above and behind the structures instead of sky, seamless left and right edges for horizontal tiling, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and icy pale blue, distressed print texture --ar 21:9 --no sky, clouds, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

**`env_circle_09_t1_front`** — Camada da frente

> **Gerar:** `--ar 3:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **3240 × 1080 px**, 72 ppi, sRGB · centro livre entre x ≈ 600 e x ≈ 2640 px  
> Remover o cinza

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, foreground layer only for parallax, ice shards, dark near-black silhouettes only at the far left edge, the far right edge and along the very bottom edge, the whole center of the image completely empty, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and icy pale blue, distressed print texture --ar 3:1 --no sky, ground in the center, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

### T2 · Antenora e Ptolomeia

**`env_circle_09_t2_ref`** — Referência completa

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** · só referência (guardar em `art_source/`)

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, full scene, a frozen lake stretching into darkness, jagged ice ridges and frozen crevasses, wind-blown frost, ice ridges at the edges, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and icy pale blue, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_09_t2_back`** — Camada de fundo

> **Gerar:** `--ar 21:9` + Upscale 2× (≈ 3360 × 1440 px)  
> **Arquivo final:** PNG RGB opaco, **2560 × 1080 px**, 72 ppi, sRGB

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, far background layer only for parallax, a frozen lake stretching into darkness, distant, low contrast, atmospheric haze, no foreground objects and no near ground, fills the whole frame edge to edge, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and icy pale blue, distressed print texture --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, foreground, frame
```

**`env_circle_09_t2_mid`** — Camada do meio (chão de caminhada)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px**, 72 ppi, sRGB · superfície do chão em **y ≈ 900 px** · bordas laterais emendáveis  
> Remover o cinza acima das estruturas

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, middle layer only for parallax, jagged ice ridges and frozen crevasses, wind-blown frost, a continuous flat walkable ground strip along the bottom of the image with the ground surface at about 83 percent of the image height, structures standing on the ground, empty plain flat solid light grey background above and behind the structures instead of sky, seamless left and right edges for horizontal tiling, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and icy pale blue, distressed print texture --ar 21:9 --no sky, clouds, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

**`env_circle_09_t2_front`** — Camada da frente

> **Gerar:** `--ar 3:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **3240 × 1080 px**, 72 ppi, sRGB · centro livre entre x ≈ 600 e x ≈ 2640 px  
> Remover o cinza

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, foreground layer only for parallax, ice ridges, dark near-black silhouettes only at the far left edge, the far right edge and along the very bottom edge, the whole center of the image completely empty, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and icy pale blue, distressed print texture --ar 3:1 --no sky, ground in the center, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

### T3 · Judeca

**`env_circle_09_t3_ref`** — Referência completa

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** · só referência (guardar em `art_source/`)

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, full scene, freezing mist, a perfectly smooth sheet of ice with contorted human figures entirely frozen inside it, the edge of an ice crust at the edges, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and icy pale blue, distressed print texture, dark vignette --ar 21:9 --no standing characters, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, standing characters
```

**`env_circle_09_t3_back`** — Camada de fundo

> **Gerar:** `--ar 21:9` + Upscale 2× (≈ 3360 × 1440 px)  
> **Arquivo final:** PNG RGB opaco, **2560 × 1080 px**, 72 ppi, sRGB

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, far background layer only for parallax, freezing mist, distant, low contrast, atmospheric haze, no foreground objects and no near ground, fills the whole frame edge to edge, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and icy pale blue, distressed print texture --ar 21:9 --no standing characters, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, foreground, frame, standing characters
```

**`env_circle_09_t3_mid`** — Camada do meio (chão de caminhada)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px**, 72 ppi, sRGB · superfície do chão em **y ≈ 900 px** · bordas laterais emendáveis  
> Remover o cinza acima das estruturas

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, middle layer only for parallax, a perfectly smooth sheet of ice with contorted human figures entirely frozen inside it, a continuous flat walkable ground strip along the bottom of the image with the ground surface at about 83 percent of the image height, structures standing on the ground, empty plain flat solid light grey background above and behind the structures instead of sky, seamless left and right edges for horizontal tiling, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and icy pale blue, distressed print texture --ar 21:9 --no sky, clouds, standing characters, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame, standing characters
```

**`env_circle_09_t3_front`** — Camada da frente

> **Gerar:** `--ar 3:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **3240 × 1080 px**, 72 ppi, sRGB · centro livre entre x ≈ 600 e x ≈ 2640 px  
> Remover o cinza

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, foreground layer only for parallax, the edge of an ice crust, dark near-black silhouettes only at the far left edge, the far right edge and along the very bottom edge, the whole center of the image completely empty, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and icy pale blue, distressed print texture --ar 3:1 --no sky, ground in the center, standing characters, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame, standing characters
```

### Chefe · Centro do Inferno

**`env_circle_09_boss_ref`** — Referência completa

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** · só referência (guardar em `art_source/`)

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, full scene, a towering wall of ice and darkness where a colossal figure will stand, an immense lake of ice swept by howling wind, ice shards blown by the wind at the edges, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and icy pale blue, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_09_boss_back`** — Camada de fundo

> **Gerar:** `--ar 21:9` + Upscale 2× (≈ 3360 × 1440 px)  
> **Arquivo final:** PNG RGB opaco, **2560 × 1080 px**, 72 ppi, sRGB

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, far background layer only for parallax, a towering wall of ice and darkness where a colossal figure will stand, distant, low contrast, atmospheric haze, no foreground objects and no near ground, fills the whole frame edge to edge, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and icy pale blue, distressed print texture --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, foreground, frame
```

**`env_circle_09_boss_mid`** — Camada do meio (chão de caminhada)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px**, 72 ppi, sRGB · superfície do chão em **y ≈ 900 px** · bordas laterais emendáveis  
> Remover o cinza acima das estruturas

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, middle layer only for parallax, an immense lake of ice swept by howling wind, a continuous flat walkable ground strip along the bottom of the image with the ground surface at about 83 percent of the image height, structures standing on the ground, empty plain flat solid light grey background above and behind the structures instead of sky, seamless left and right edges for horizontal tiling, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and icy pale blue, distressed print texture --ar 21:9 --no sky, clouds, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

**`env_circle_09_boss_front`** — Camada da frente

> **Gerar:** `--ar 3:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **3240 × 1080 px**, 72 ppi, sRGB · centro livre entre x ≈ 600 e x ≈ 2640 px  
> Remover o cinza

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, foreground layer only for parallax, ice shards blown by the wind, dark near-black silhouettes only at the far left edge, the far right edge and along the very bottom edge, the whole center of the image completely empty, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and icy pale blue, distressed print texture --ar 3:1 --no sky, ground in the center, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

### Almas atormentadas

**`env_circle_09_souls_crowd`** — Multidão distante (camada animada entre `_back` e `_mid`)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px** · figuras pequenas (≈ 80–160 px de altura) · fundo removido  
> O motor anima com balanço, deriva e transparência; não é preciso quadro a quadro

```text
Dark gothic 2D side-view game background layer in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, traitor souls frozen in the ice up to their necks, faces turned down, tears frozen on their cheeks, many small distant figures in the middle distance, readable silhouettes, all figures shrouded, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and icy pale blue, distressed print texture --ar 21:9 --no nudity, sexual, children, gore close-up, ground, sky, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_09_souls_sheet`** — Folha de 3 almas para animação (perto da câmera)

> **Gerar:** `--ar 3:2` + Upscale 2×  
> **Arquivo final:** Matriz PNG RGBA **3072 × 2048 px** em `art_source/`; cada alma recortada em PNG RGBA com **≈ 600 px** de altura  
> Para animação simples por rig ou deformação no Godot; recortar membros se necessário

```text
Dark gothic 2D game character sheet in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, three tormented damned souls of the same kind wrapped in torn grey shrouds, side view facing left, pose 1: frozen in the ice up to the neck, face turned down; pose 2: frozen bent over, half out of the ice; pose 3: entirely encased in clear ice, contorted, the three figures separated by wide empty space, same scale, full figures inside the frame, anguished faces, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors, palette of black, bone, ash grey and icy pale blue, isolated on a plain flat solid light grey background --ar 3:2 --no nudity, sexual, children, text, letters, UI, halo, cartoon, anime, glossy, 3D, photorealistic, white background
```

### Ambientação

**`fx_circle_09_ambient`** — Partículas do ambiente (folha de sprites)

> **Gerar:** `--ar 1:1` + Upscale 2×  
> **Arquivo final:** Matriz PNG RGBA **2048 × 2048 px**; cada sprite recortado em PNG RGBA de **64–256 px**  
> O motor espalha e anima as partículas

```text
2D game VFX sprite sheet in the style of Darkest Dungeon, hand-inked comic art, a grid of separate small particle sprites: frost snow, ice crystals, freezing mist puffs, each sprite isolated with empty space around it, varied sizes, thick ink edges, palette of black, bone, ash grey and icy pale blue, isolated on a plain flat solid light grey background --ar 1:1 --no text, letters, numbers, grid lines, characters, cartoon, glossy, 3D, photorealistic, white background
```

**`env_circle_09_camp`** — Pouso deste círculo

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** (pode ser dividido em camadas como os trechos)

```text
Darkest Dungeon style 2D side-view camp background, hand-painted gothic horror, hand-inked comic art, a small campfire in a wind-sheltered ice cave, a few candles placed on a stone, bedrolls, the surrounding darkness of the circle pressing in, warm firelight in a small circle against cold shadow, empty flat floor strip in the foreground for characters, palette of black, bone, ash grey, warm amber and icy pale blue, thick black ink outlines, heavy black shadows, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_09_vigil`** — Vigília (antes do chefe)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px**

```text
Darkest Dungeon style 2D side-view background, hand-painted gothic horror, hand-inked comic art, a last quiet resting spot in a wind-sheltered ice cave, a single tall candle on a flat rock, the entrance to the boss lair looming in the darkness ahead, tense silence, empty flat floor strip in the foreground for characters, palette of black, bone, ash grey, warm amber and icy pale blue, thick black ink outlines, heavy black shadows, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`env_circle_09_arrival`** — Chegada ao círculo (tela de transição e carregamento)

> **Gerar:** `--ar 16:9` + Upscale 2×  
> **Arquivo final:** PNG **1920 × 1080 px** (guardar a matriz em 3840 × 2160 em `art_source/`)  
> O motor coloca o nome do círculo por cima

```text
Dark gothic panoramic illustration in the style of Darkest Dungeon, hand-inked comic art, in the spirit of Gustave Dore engravings of the Inferno, a frozen lake at the bottom of a vast funnel, darkness and ice, a colossal shape in the far center, seen from a high rocky ledge, tiny distant figures, immense scale, thick black ink outlines, heavy black shadows, crosshatched engraving texture, muted desaturated palette of black, bone, ash grey and icy pale blue, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, close-up characters, cartoon, glossy, 3D, photorealistic
```

## Interface · escolha do círculo (Mapa do Inferno) · v2

**O que mudou (v2, 04/11/2026):** cada círculo agora é uma **faixa horizontal larga**, que ocupa a tela de ponta a ponta. O jogador toca em qualquer ponto da faixa para escolher o círculo. As faixas ficam empilhadas de cima para baixo e mantêm o desenho do funil: a abertura vai se estreitando a cada círculo. A tela rola na vertical, e os medalhões continuam como o rótulo de cada faixa.

### Como a tela funciona

```text
┌──────────────────────────── 1920 px ────────────────────────────┐
│  [borda da vila]  a vila no topo do abismo (prólogo)            │ 480 px
├──\──────────────────────────────────────────────────────────//──┤
│ (◎)  \        Círculo 1 · Antinferno e Limbo              //    │ 480 px  ← toque em qualquer ponto
├───────\──────────────────────────────────────────────────//─────┤
│ (◎)     \         Círculo 2 · Luxúria                    //      │ 480 px
├───────────\──────────────────────────────────────────//─────────┤
│                 ... até o Círculo 9 (ponta do funil)             │
└──────────────────────────────────────────────────────────────────┘
(◎) = medalhão · a tela mostra ≈ 2 faixas por vez e rola na vertical
```

- **Cada faixa é uma imagem própria**, de 1920 × 480 px. É mais fácil de gerar com qualidade, de recortar a área de toque e de acender ou apagar um círculo sozinho.
- **Funil:** a abertura de cada faixa tem uma largura na borda de cima e outra na borda de baixo (tabela abaixo). A faixa seguinte começa exatamente com a largura em que a anterior terminou. Fora do funil fica a terra escura em corte, com camadas de rocha e raízes.
- **Estados (feitos pelo motor, sem imagem nova):** liberado = cor normal e leve brilho de vela nas bordas; bloqueado = coberto pela névoa de tinta e dessaturado; selecionado = moldura de cinábrio e o medalhão aceso; em expedição = o marcador da companhia sobre a faixa.
- **Medalhão:** à esquerda de cada faixa, com o número e o nome escritos pelo motor ao lado.
- **Encaixe das faixas:** a IA não acerta a largura exata do funil. Por isso, use a **guia do funil** de cada faixa, que já está pronta em `docs/art/guides/guide_ui_circle_map_slice_<círculo>.png` (3840 × 960 px: cinza claro = abertura do funil, escuro = terra). A prévia `guide_funnel_preview.png` mostra as faixas empilhadas. Use essa guia como imagem de referência de composição (no Midjourney, a imagem no início do prompt com `--iw 0.5` a `1`). O ajuste fino da emenda entre as faixas é feito depois no editor ou pelo Claude Code.

| Faixa | Largura da abertura na borda de cima | Largura na borda de baixo |
| --- | --- | --- |
| `rim` (vila, prólogo) | 100% (sem paredes) | 100% |
| `circle_01` · Antinferno e Limbo | 100% | 91% |
| `circle_02` · Luxúria | 91% | 82% |
| `circle_03` · Gula | 82% | 73% |
| `circle_04` · Avareza e Prodigalidade | 73% | 64% |
| `circle_05` · Ira e Acídia | 64% | 56% |
| `circle_06` · Heresia | 56% | 47% |
| `circle_07` · Violência | 47% | 38% |
| `circle_08` · Fraude | 38% | 29% |
| `circle_09` · Traição | 29% | 20% |

| Peça | Arquivo final |
| --- | --- |
| Faixa de cada círculo (9) + faixa da vila | PNG RGB, **1920 × 480 px** (matriz 3840 × 960 em `art_source/`), bordas de cima e de baixo emendáveis |
| Névoa de bloqueio | PNG RGBA, **1920 × 480 px** |
| Medalhões (10) | PNG RGBA, **512 × 512 px** (gerar 1024 × 1024), exibidos a ≈ 220 px |
| Marcador da companhia | PNG RGBA, **256 × 256 px** |
| Moldura lateral da tela | PNG RGBA, **1920 × 1080 px**, centro transparente |
| Referência geral do funil | PNG **2048 × 4096 px**, só referência de estilo |

**`ui_circle_map_reference`** — Referência geral do funil (gere primeiro, use como `--sref` das faixas)

> **Gerar:** `--ar 1:2` + Upscale 2×  
> **Arquivo final:** PNG **2048 × 4096 px**, só referência (guardar em `art_source/`)

```text
2D gothic horror game map illustration in the style of Darkest Dungeon, hand-inked comic art, inspired by Botticelli's Map of Hell and Gustave Dore engravings, a tall vertical cross-section of an immense inverted cone funnel descending into the earth, ten wide horizontal terraces stacked from top to bottom, each terrace a broad band spanning the funnel, the funnel walls sloping inward evenly so each band is narrower than the one above, ending in a frozen point at the bottom, a small fortified monastery village on the rim at the very top under a pale dawn, outside the funnel dark earth in cross-section with rock strata and roots, thick black ink outlines, heavy black shadows, crosshatched engraving texture, muted desaturated palette of black, bone, ash grey and small cinnabar red accents, aged parchment tone, distressed print texture --ar 1:2 --no text, letters, numbers, labels, flat gold, characters in close-up, frame, border, vignette, cartoon, glossy, 3D, photorealistic
```

**`ui_circle_map_slice_rim`** — Faixa da vila (topo, prólogo)

> **Gerar:** `--ar 4:1` + Upscale 2× (matriz 3840 × 960)  
> **Arquivo final:** PNG RGB, **1920 × 480 px**, borda de baixo emendável com a faixa do Círculo 1

```text
2D gothic horror game map band in the style of Darkest Dungeon, hand-inked comic art, one wide horizontal slice of a cross-section map of Hell, the top rim of the abyss: a small fortified monastery village with a chapel bell tower and candlelit windows on the cliff edge at the left, a pale gold dawn sky above, the dark mouth of an immense funnel opening below across almost the whole width, a narrow stair descending into it, the bottom edge of the image continuous and seamless for stacking, thick black ink outlines, heavy black shadows, crosshatched engraving texture, muted desaturated palette of black, bone, ash grey and warm amber, aged parchment tone, distressed print texture --ar 4:1 --no text, letters, numbers, labels, flat gold, characters in close-up, frame, border, vignette, cartoon, glossy, 3D, photorealistic
```

**`ui_circle_map_slice_circle_01`** — Faixa do círculo · Antinferno e Limbo

> **Gerar:** `--ar 4:1` + Upscale 2× (matriz 3840 × 960) · usar a guia do funil desta faixa como imagem de composição  
> **Arquivo final:** PNG RGB, **1920 × 480 px** · abertura do funil com **100%** da largura na borda de cima e **91%** na de baixo, centralizada · bordas de cima e de baixo emendáveis  
> Área de toque: a faixa inteira

```text
2D gothic horror game map band in the style of Darkest Dungeon, hand-inked comic art, inspired by Botticelli's Map of Hell, one wide horizontal slice of a cross-section of the funnel of Hell, a single terrace of the antinferno e limbo circle seen from the side, the funnel opening centered and spanning about 100 percent of the image width at the top edge narrowing evenly to about 91 percent at the bottom edge, steep sloped rock walls on both sides, inside the terrace: a barren vestibule plain with a tattered empty banner and swarms of wasps on the left, the black river Acheron in the middle, a pale castle with seven walls in a quiet meadow on the right, tiny distant figures only, outside the funnel on the left and right dark earth in cross-section with rock strata and roots, the top and bottom edges continuous and seamless for stacking with the bands above and below, an empty quiet area at the far left inside the band for a medallion, thick black ink outlines, heavy black shadows, crosshatched engraving texture, muted desaturated palette of black, bone, ash grey and pale pearl grey, aged parchment tone, distressed print texture --ar 4:1 --no text, letters, numbers, labels, flat gold, characters in close-up, frame, border, vignette, cartoon, glossy, 3D, photorealistic
```

**`ui_circle_map_slice_circle_02`** — Faixa do círculo · Luxúria

> **Gerar:** `--ar 4:1` + Upscale 2× (matriz 3840 × 960) · usar a guia do funil desta faixa como imagem de composição  
> **Arquivo final:** PNG RGB, **1920 × 480 px** · abertura do funil com **91%** da largura na borda de cima e **82%** na de baixo, centralizada · bordas de cima e de baixo emendáveis  
> Área de toque: a faixa inteira

```text
2D gothic horror game map band in the style of Darkest Dungeon, hand-inked comic art, inspired by Botticelli's Map of Hell, one wide horizontal slice of a cross-section of the funnel of Hell, a single terrace of the luxúria circle seen from the side, the funnel opening centered and spanning about 91 percent of the image width at the top edge narrowing evenly to about 82 percent at the bottom edge, steep sloped rock walls on both sides, inside the terrace: a howling hurricane filling the whole band, tiny shrouded souls tumbling in a spiral of wind, a stone seat of judgment carved into the left wall, tiny distant figures only, outside the funnel on the left and right dark earth in cross-section with rock strata and roots, the top and bottom edges continuous and seamless for stacking with the bands above and below, an empty quiet area at the far left inside the band for a medallion, thick black ink outlines, heavy black shadows, crosshatched engraving texture, muted desaturated palette of black, bone, ash grey and stormy violet, aged parchment tone, distressed print texture --ar 4:1 --no text, letters, numbers, labels, flat gold, characters in close-up, frame, border, vignette, cartoon, glossy, 3D, photorealistic
```

**`ui_circle_map_slice_circle_03`** — Faixa do círculo · Gula

> **Gerar:** `--ar 4:1` + Upscale 2× (matriz 3840 × 960) · usar a guia do funil desta faixa como imagem de composição  
> **Arquivo final:** PNG RGB, **1920 × 480 px** · abertura do funil com **82%** da largura na borda de cima e **73%** na de baixo, centralizada · bordas de cima e de baixo emendáveis  
> Área de toque: a faixa inteira

```text
2D gothic horror game map band in the style of Darkest Dungeon, hand-inked comic art, inspired by Botticelli's Map of Hell, one wide horizontal slice of a cross-section of the funnel of Hell, a single terrace of the gula circle seen from the side, the funnel opening centered and spanning about 82 percent of the image width at the top edge narrowing evenly to about 73 percent at the bottom edge, steep sloped rock walls on both sides, inside the terrace: a swamp of black mud under heavy filthy rain, ruined arches sinking, a great rotten archway with gnawed bones, tiny distant figures only, outside the funnel on the left and right dark earth in cross-section with rock strata and roots, the top and bottom edges continuous and seamless for stacking with the bands above and below, an empty quiet area at the far left inside the band for a medallion, thick black ink outlines, heavy black shadows, crosshatched engraving texture, muted desaturated palette of black, bone, ash grey and sickly olive green, aged parchment tone, distressed print texture --ar 4:1 --no text, letters, numbers, labels, flat gold, characters in close-up, frame, border, vignette, cartoon, glossy, 3D, photorealistic
```

**`ui_circle_map_slice_circle_04`** — Faixa do círculo · Avareza e Prodigalidade

> **Gerar:** `--ar 4:1` + Upscale 2× (matriz 3840 × 960) · usar a guia do funil desta faixa como imagem de composição  
> **Arquivo final:** PNG RGB, **1920 × 480 px** · abertura do funil com **73%** da largura na borda de cima e **64%** na de baixo, centralizada · bordas de cima e de baixo emendáveis  
> Área de toque: a faixa inteira

```text
2D gothic horror game map band in the style of Darkest Dungeon, hand-inked comic art, inspired by Botticelli's Map of Hell, one wide horizontal slice of a cross-section of the funnel of Hell, a single terrace of the avareza e prodigalidade circle seen from the side, the funnel opening centered and spanning about 73 percent of the image width at the top edge narrowing evenly to about 64 percent at the bottom edge, steep sloped rock walls on both sides, inside the terrace: a barren valley where two lines of tiny souls push enormous weights against each other, dunes of tarnished coins, tiny distant figures only, outside the funnel on the left and right dark earth in cross-section with rock strata and roots, the top and bottom edges continuous and seamless for stacking with the bands above and below, an empty quiet area at the far left inside the band for a medallion, thick black ink outlines, heavy black shadows, crosshatched engraving texture, muted desaturated palette of black, bone, ash grey and tarnished oxidized brass, aged parchment tone, distressed print texture --ar 4:1 --no text, letters, numbers, labels, flat gold, characters in close-up, frame, border, vignette, cartoon, glossy, 3D, photorealistic
```

**`ui_circle_map_slice_circle_05`** — Faixa do círculo · Ira e Acídia

> **Gerar:** `--ar 4:1` + Upscale 2× (matriz 3840 × 960) · usar a guia do funil desta faixa como imagem de composição  
> **Arquivo final:** PNG RGB, **1920 × 480 px** · abertura do funil com **64%** da largura na borda de cima e **56%** na de baixo, centralizada · bordas de cima e de baixo emendáveis  
> Área de toque: a faixa inteira

```text
2D gothic horror game map band in the style of Darkest Dungeon, hand-inked comic art, inspired by Botticelli's Map of Hell, one wide horizontal slice of a cross-section of the funnel of Hell, a single terrace of the ira e acídia circle seen from the side, the funnel opening centered and spanning about 64 percent of the image width at the top edge narrowing evenly to about 56 percent at the bottom edge, steep sloped rock walls on both sides, inside the terrace: the black marsh of the Styx with a small boat crossing, tiny souls fighting in the mud, the red-hot iron walls of a city rising at the bottom edge, tiny distant figures only, outside the funnel on the left and right dark earth in cross-section with rock strata and roots, the top and bottom edges continuous and seamless for stacking with the bands above and below, an empty quiet area at the far left inside the band for a medallion, thick black ink outlines, heavy black shadows, crosshatched engraving texture, muted desaturated palette of black, bone, ash grey and muddy dark red, aged parchment tone, distressed print texture --ar 4:1 --no text, letters, numbers, labels, flat gold, characters in close-up, frame, border, vignette, cartoon, glossy, 3D, photorealistic
```

**`ui_circle_map_slice_circle_06`** — Faixa do círculo · Heresia

> **Gerar:** `--ar 4:1` + Upscale 2× (matriz 3840 × 960) · usar a guia do funil desta faixa como imagem de composição  
> **Arquivo final:** PNG RGB, **1920 × 480 px** · abertura do funil com **56%** da largura na borda de cima e **47%** na de baixo, centralizada · bordas de cima e de baixo emendáveis  
> Área de toque: a faixa inteira

```text
2D gothic horror game map band in the style of Darkest Dungeon, hand-inked comic art, inspired by Botticelli's Map of Hell, one wide horizontal slice of a cross-section of the funnel of Hell, a single terrace of the heresia circle seen from the side, the funnel opening centered and spanning about 56 percent of the image width at the top edge narrowing evenly to about 47 percent at the bottom edge, steep sloped rock walls on both sides, inside the terrace: inside the iron walls, an endless field of open stone tombs with flames rising from them, burning mausoleums, tiny distant figures only, outside the funnel on the left and right dark earth in cross-section with rock strata and roots, the top and bottom edges continuous and seamless for stacking with the bands above and below, an empty quiet area at the far left inside the band for a medallion, thick black ink outlines, heavy black shadows, crosshatched engraving texture, muted desaturated palette of black, bone, ash grey and ember orange, aged parchment tone, distressed print texture --ar 4:1 --no text, letters, numbers, labels, flat gold, characters in close-up, frame, border, vignette, cartoon, glossy, 3D, photorealistic
```

**`ui_circle_map_slice_circle_07`** — Faixa do círculo · Violência

> **Gerar:** `--ar 4:1` + Upscale 2× (matriz 3840 × 960) · usar a guia do funil desta faixa como imagem de composição  
> **Arquivo final:** PNG RGB, **1920 × 480 px** · abertura do funil com **47%** da largura na borda de cima e **38%** na de baixo, centralizada · bordas de cima e de baixo emendáveis  
> Área de toque: a faixa inteira

```text
2D gothic horror game map band in the style of Darkest Dungeon, hand-inked comic art, inspired by Botticelli's Map of Hell, one wide horizontal slice of a cross-section of the funnel of Hell, a single terrace of the violência circle seen from the side, the funnel opening centered and spanning about 47 percent of the image width at the top edge narrowing evenly to about 38 percent at the bottom edge, steep sloped rock walls on both sides, inside the terrace: three rings side by side: a river of boiling blood, a dark wood of thorny leafless trees, a desert of burning sand under falling fire, tiny distant figures only, outside the funnel on the left and right dark earth in cross-section with rock strata and roots, the top and bottom edges continuous and seamless for stacking with the bands above and below, an empty quiet area at the far left inside the band for a medallion, thick black ink outlines, heavy black shadows, crosshatched engraving texture, muted desaturated palette of black, bone, ash grey and deep crimson, aged parchment tone, distressed print texture --ar 4:1 --no text, letters, numbers, labels, flat gold, characters in close-up, frame, border, vignette, cartoon, glossy, 3D, photorealistic
```

**`ui_circle_map_slice_circle_08`** — Faixa do círculo · Fraude

> **Gerar:** `--ar 4:1` + Upscale 2× (matriz 3840 × 960) · usar a guia do funil desta faixa como imagem de composição  
> **Arquivo final:** PNG RGB, **1920 × 480 px** · abertura do funil com **38%** da largura na borda de cima e **29%** na de baixo, centralizada · bordas de cima e de baixo emendáveis  
> Área de toque: a faixa inteira

```text
2D gothic horror game map band in the style of Darkest Dungeon, hand-inked comic art, inspired by Botticelli's Map of Hell, one wide horizontal slice of a cross-section of the funnel of Hell, a single terrace of the fraude circle seen from the side, the funnel opening centered and spanning about 38 percent of the image width at the top edge narrowing evenly to about 29 percent at the bottom edge, steep sloped rock walls on both sides, inside the terrace: ten small concentric stone ditches crossed by arched bridges, poisonous mist, a ditch of black pitch, giant stone towers at the bottom rim, tiny distant figures only, outside the funnel on the left and right dark earth in cross-section with rock strata and roots, the top and bottom edges continuous and seamless for stacking with the bands above and below, an empty quiet area at the far left inside the band for a medallion, thick black ink outlines, heavy black shadows, crosshatched engraving texture, muted desaturated palette of black, bone, ash grey and poison green, aged parchment tone, distressed print texture --ar 4:1 --no text, letters, numbers, labels, flat gold, characters in close-up, frame, border, vignette, cartoon, glossy, 3D, photorealistic
```

**`ui_circle_map_slice_circle_09`** — Faixa do círculo · Traição

> **Gerar:** `--ar 4:1` + Upscale 2× (matriz 3840 × 960) · usar a guia do funil desta faixa como imagem de composição  
> **Arquivo final:** PNG RGB, **1920 × 480 px** · abertura do funil com **29%** da largura na borda de cima e **20%** na de baixo, centralizada · bordas de cima e de baixo emendáveis  
> Área de toque: a faixa inteira

```text
2D gothic horror game map band in the style of Darkest Dungeon, hand-inked comic art, inspired by Botticelli's Map of Hell, one wide horizontal slice of a cross-section of the funnel of Hell, a single terrace of the traição circle seen from the side, the funnel opening centered and spanning about 29 percent of the image width at the top edge narrowing evenly to about 20 percent at the bottom edge, steep sloped rock walls on both sides, inside the terrace: a frozen lake narrowing to the bottom point of the funnel, faces frozen in the ice, a colossal dim winged shape frozen at the very center bottom, tiny distant figures only, outside the funnel on the left and right dark earth in cross-section with rock strata and roots, the top and bottom edges continuous and seamless for stacking with the bands above and below, an empty quiet area at the far left inside the band for a medallion, thick black ink outlines, heavy black shadows, crosshatched engraving texture, muted desaturated palette of black, bone, ash grey and icy pale blue, aged parchment tone, distressed print texture --ar 4:1 --no text, letters, numbers, labels, flat gold, characters in close-up, frame, border, vignette, cartoon, glossy, 3D, photorealistic
```

**`ui_circle_map_locked_fog`** — Névoa de bloqueio (por faixa)

> **Gerar:** `--ar 4:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **1920 × 480 px**  
> O motor recorta pelo formato da abertura de cada faixa

```text
2D gothic game UI overlay in the style of Darkest Dungeon, hand-inked comic art, a wide horizontal band of drifting thick black ink smoke and fog covering the whole image, slightly thinner toward the left and right edges, seamless top and bottom edges, palette of black and ash grey, isolated on a plain flat solid light grey background --ar 4:1 --no text, letters, shapes, characters, cartoon, glossy, 3D, photorealistic, white background
```

**Medalhões dos círculos** (mantidos da v1) — use o modelo e troque `[CENA]` e `[COR]` pela linha da tabela.

> **Gerar:** `--ar 1:1` · 1024 × 1024 px  
> **Arquivo final:** PNG RGBA, **512 × 512 px**, 72 ppi, sRGB · nome `ui_circle_medallion_<círculo>.png` · exibido a ≈ 220 px à esquerda da faixa

```text
2D gothic horror game UI medallion in the style of Darkest Dungeon, hand-inked comic art, a round carved dark stone roundel with a thick worn rim and small gothic tracery, at its center a small engraved scene of [CENA], bold readable silhouette at small size, thick irregular black ink outlines, angular blocky shading, muted desaturated colors, palette of black, bone, ash grey and [COR], distressed print texture, isolated on a plain flat solid light grey background --ar 1:1 --no text, letters, numbers, flat gold, cartoon, glossy, 3D, photorealistic, white background
```

| Medalhão | [CENA] | [COR] |
| --- | --- | --- |
| `circle_00` | a winding path descending from a cliff-top village into darkness (prologue) | warm amber |
| `circle_01` | a tattered empty banner on a pole above a black river | pale pearl grey |
| `circle_02` | shrouded souls tumbling in a spiral of wind | stormy violet |
| `circle_03` | heavy rain falling on black mud and a broken barrel | sickly olive green |
| `circle_04` | two great round weights clashing | tarnished oxidized brass |
| `circle_05` | a small boat on black water before red-hot walls | muddy dark red |
| `circle_06` | an open stone tomb with flames rising | ember orange |
| `circle_07` | a thorny leafless tree above a river of blood | deep crimson |
| `circle_08` | an arched stone bridge over a ditch of mist | poison green |
| `circle_09` | a face frozen in cracked ice | icy pale blue |

**`ui_circle_map_marker`** — Marcador da companhia

> **Gerar:** `--ar 1:1` · 1024 × 1024 px  
> **Arquivo final:** PNG RGBA, **256 × 256 px**

```text
2D gothic horror game UI icon in the style of Darkest Dungeon, hand-inked comic art, a small hanging iron lantern with a steady flat gold flame inside, bold readable silhouette, thick irregular black ink outlines, angular blocky shading, muted desaturated colors, palette of black, bone, ash grey and flat gold, distressed print texture, isolated on a plain flat solid light grey background --ar 1:1 --no text, letters, numbers, cartoon, glossy, 3D, photorealistic, white background
```

**`ui_circle_map_frame`** — Moldura lateral da tela

> **Gerar:** `--ar 16:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **1920 × 1080 px**, centro transparente  
> Fica fixa enquanto as faixas rolam por baixo; cartucho vazio no topo para o título

```text
2D gothic horror game UI frame in the style of Darkest Dungeon, hand-inked comic art, narrow ornate side borders of dark carved stone with gothic tracery running down the left and right edges, a thin carved top border with an empty parchment cartouche at the top center, small carved demon heads in the top corners, the whole center completely empty, symmetrical, thick irregular black ink outlines, muted desaturated colors, palette of black, bone, ash grey and small cinnabar red accents, distressed print texture, isolated on a plain flat solid light grey background --ar 16:9 --no text, letters, numbers, flat gold, cartoon, glossy, 3D, photorealistic, white background
```

## Extras de imersão

**`env_gate_of_hell`** — Porta do Inferno (entrada da primeira expedição e do prólogo)

> **Gerar:** `--ar 16:9` + Upscale 2×  
> **Arquivo final:** PNG **1920 × 1080 px** (matriz 3840 × 2160)  
> Sem inscrição na pedra: o texto de Dante (Inferno III) é colocado pelo motor

```text
Dark gothic illustration in the style of Darkest Dungeon, hand-inked comic art, in the spirit of Gustave Dore engravings, the colossal Gate of Hell carved into a black cliff, a blank stone lintel above the arch ready for an inscription, darkness and faint red light beyond, a lonely path leading to it, immense scale, thick black ink outlines, heavy black shadows, crosshatched engraving texture, muted desaturated palette of black, bone, ash grey and pale pearl grey, distressed print texture, dark vignette --ar 16:9 --no text, letters, inscription, characters, cartoon, glossy, 3D, photorealistic
```

**`env_descent_stair`** — Descida da vila ao abismo (transição Portão → círculo)

> **Gerar:** `--ar 9:16` + Upscale 2×  
> **Arquivo final:** PNG **1080 × 1920 px** (rolagem vertical na transição)

```text
Dark gothic vertical illustration in the style of Darkest Dungeon, hand-inked comic art, a narrow stone stairway carved into a sheer cliff spiraling down from a small fortified monastery gate lit by warm candlelight at the top into an endless dark abyss at the bottom, faint red glow far below, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey, warm amber at the top fading to deep shadow, distressed print texture --ar 9:16 --no text, letters, characters, cartoon, glossy, 3D, photorealistic
```

**`fx_fog_strip`** — Faixa de névoa (uso geral, sobre o `_mid`)

> **Gerar:** `--ar 4:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 640 px**, bordas emendáveis  
> O motor tinge com a cor do círculo

```text
2D game VFX layer in the style of Darkest Dungeon, hand-inked comic art, a long low horizontal band of soft drifting fog with ink-like wisps, thicker at the bottom and fading upward, seamless left and right edges, neutral pale grey, isolated on a plain flat solid dark grey background --ar 4:1 --no text, objects, characters, cartoon, glossy, 3D, photorealistic
```

**`fx_light_shafts`** — Feixes de luz (Consolação, milagres, Vigília)

> **Gerar:** `--ar 16:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **1920 × 1080 px**  
> Aplicado em modo aditivo; o motor controla a cor e a intensidade

```text
2D game VFX layer in the style of Darkest Dungeon, hand-inked comic art, several straight shafts of soft light falling diagonally from the top left, hand-inked edges, neutral pale warm white, isolated on a plain flat solid black background --ar 16:9 --no text, objects, characters, halo, cartoon, glossy, 3D, photorealistic
```

## Pendências

- Os chefes já têm arena (`_boss`); as cenas narrativas (São Gabriel abrindo Dite, Anteu descendo a companhia) seguem a seção 11 da Direção de Arte.
- O fundo do mapa de nós da expedição continua na seção 12 da Direção de Arte (modelo com `[COR DO CÍRCULO]`).
- O prólogo (`circle_00`) tem só o medalhão e a Porta do Inferno até o roteiro do prólogo definir os cenários.
