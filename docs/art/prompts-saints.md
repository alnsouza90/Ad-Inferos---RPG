# Prompts dos santos jogáveis · folha de produção v1

Base: Direção de Arte v1.1 (estilo, fundo cinza-claro liso, sem auréola) e `docs/art/asset-pipeline.md`. Pedido do Claude Code para o piloto, estendido aos 12 santos. **v1.1 (04/11/2026):** tamanhos em pixels em cada prompt e versão para rig (pose neutra + folha de peças).

## Como usar

1. **Comece pelo `body_idle`** de cada santo. Aprove essa imagem antes de gerar as outras seis.
2. Nas outras seis, use o `body_idle` aprovado como **referência de personagem** (`--cref` ou `--oref` no Midjourney, conforme a versão; *image reference* em outras ferramentas) e a melhor imagem de estilo como `--sref`.
3. **Rostos (`face_*`)**: mesmo ângulo de cabeça do `body_idle` (perfil três-quartos virado para a direita), cabeça e ombros, enquadramento parecido nos dois estados. É isso que permite ao motor trocar só o rosto.
4. **Retrato**: se o `body_idle` tiver boa resolução no rosto, pode ser só um recorte dele (Direção de Arte). Use o prompt quando o recorte ficar pobre.
5. Nada de auréola, texto ou moldura na imagem: a auréola é do motor.
6. Salve o original em `art_source/characters/saints/<id>/` com versão (`_v01`) e entregue ao Claude Code com o nome da tabela.

| Arquivo | Proporção | Tamanho final | Observação |
| --- | --- | --- | --- |
| `<id>_body_idle` | 2:3 | 1024 × 1536 | Pés a 96 px da base, figura ≈ 1200 px |
| `<id>_face_dark_night` | 1:1 | recorte da cabeça | Mesmo ângulo do idle |
| `<id>_face_consolation` | 1:1 | recorte da cabeça | Mesmo ângulo do idle |
| `<id>_portrait` | 3:4 | 768 × 1024 | Do peito para cima |
| `<id>_body_attack` | 2:3 | 1024 × 1536 | Mesmo tamanho de figura do idle |
| `<id>_body_hit` | 2:3 | 1024 × 1536 | Idem |
| `<id>_body_fall` | 2:3 | 1024 × 1536 | De joelhos, caído para a frente (o motor completa a queda) |
| `<id>_rig_base` | 2:3 | matriz 2048 × 3072; peças a 50% | Pose neutra, membros sem sobreposição |
| `<id>_rig_parts` | 1:1 | matriz 2048 × 2048; peças na escala do idle | Peças separadas para o esqueleto |

Todos os arquivos: **PNG com transparência (RGBA), 8 bits, sRGB, 72 ppi**. Em jogo o ppi não importa; o que vale é a medida em pixels.

**Sobre os pixels:** o Midjourney não obedece números de pixels escritos no prompt; ele usa a proporção (`--ar`) e o Upscale. Por isso cada prompt traz, acima dele, como gerar e qual o tamanho final, e o próprio texto do prompt diz quanto da imagem a figura ocupa (78% da altura, pés a 6% da base), que é o que garante a escala certa. O redimensionamento final para os pixels exatos é feito depois (por você ou pelo Claude Code com `tools/art/`). No GPT Image, 1024 × 1536 é um tamanho nativo.

**Rig:** a folha de peças (`rig_parts`) gerada por IA costuma sair inconsistente (peças faltando ou em escalas diferentes). O caminho seguro é recortar as peças da pose neutra (`rig_base`) num editor (Krita, GIMP, Photoshop), completando as juntas à mão; a folha de peças serve como atalho e referência. Partes que devem ser peças separadas: cabeça, tronco com quadril, braço, antebraço e mão (dos dois lados), coxa e perna com pé (dos dois lados), roupas soltas e cada objeto.

**Prioridade:** Jorge primeiro (piloto, as 7 imagens + rig). Para os outros santos, as 4 essenciais (idle, dois rostos, retrato) bastam até o piloto decidir a animação; as três poses ficam para depois.

## São Jorge (`saint_george`)

**`saint_george_body_idle`** — Corpo inteiro, pose padrão · essencial

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint George as a young Roman military officer of the late 3rd century, beardless with short curly hair as in Eastern icons, bronze muscle cuirass with pteruges, flowing red paludamentum cloak, Roman military boots, long spear and round shield bearing a cross, spear held low ready to strike, broad heroic silhouette, determined resolute expression, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, medieval knight, plate armor, great helm, tabard
```

**`saint_george_face_dark_night`** — Rosto em Noite Escura · essencial

> **Gerar:** proporção 1:1 · **1024 × 1024 px** (Midjourney: `--ar 1:1` + Upscale)  
> **Arquivo final:** PNG RGBA, **1024 × 1024 px**, 72 ppi, sRGB · o Claude Code reduz ao tamanho da cabeça do `body_idle` (≈ 170 px)

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, close-up head and shoulders portrait, side three-quarter view facing right, same head angle as the full body reference, head and shoulders filling about 70 percent of the frame, head centered, Saint George, a young beardless Roman officer with short curly hair as in Eastern icons, bronze muscle cuirass and red paludamentum cloak at the shoulders, anguished exhausted expression, eyes downcast, brow furrowed, deep shadows under the eyes, face drained of color, thick irregular black ink outlines, heavy black shadows engulfing half the face, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 1:1 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, medieval knight, plate armor, great helm, tabard
```

**`saint_george_face_consolation`** — Rosto em Consolação · essencial

> **Gerar:** proporção 1:1 · **1024 × 1024 px** (Midjourney: `--ar 1:1` + Upscale)  
> **Arquivo final:** PNG RGBA, **1024 × 1024 px**, 72 ppi, sRGB · o Claude Code reduz ao tamanho da cabeça do `body_idle` (≈ 170 px)

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, close-up head and shoulders portrait, side three-quarter view facing right, same head angle as the full body reference, head and shoulders filling about 70 percent of the frame, head centered, Saint George, a young beardless Roman officer with short curly hair as in Eastern icons, bronze muscle cuirass and red paludamentum cloak at the shoulders, peaceful serene radiant expression, eyes softly lifted, faint warm gold light on the face, thick irregular black ink outlines, heavy black shadows engulfing half the face, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 1:1 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, medieval knight, plate armor, great helm, tabard
```

**`saint_george_portrait`** — Retrato · essencial

> **Gerar:** proporção 3:4 · Midjourney: `--ar 3:4` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **768 × 1024 px**, 72 ppi, sRGB · do peito para cima

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, bust portrait from the chest up, three-quarter view facing right, framed from the chest up, eyes in the upper third of the frame, Saint George, a young beardless Roman officer with short curly hair as in Eastern icons, bronze muscle cuirass and red paludamentum cloak at the shoulders, determined resolute expression, strong readable silhouette, thick irregular black ink outlines, heavy black shadows engulfing half the face, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 3:4 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, medieval knight, plate armor, great helm, tabard
```

**`saint_george_body_attack`** — Pose de ataque · piloto

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint George as a young Roman military officer of the late 3rd century, beardless with short curly hair as in Eastern icons, bronze muscle cuirass with pteruges, flowing red paludamentum cloak, Roman military boots, long spear and round shield bearing a cross, lunging forward in a powerful spear thrust, shield braced in front, cloak swept back, fierce determined expression, dynamic action pose, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, medieval knight, plate armor, great helm, tabard
```

**`saint_george_body_hit`** — Pose de golpe recebido · piloto

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint George as a young Roman military officer of the late 3rd century, beardless with short curly hair as in Eastern icons, bronze muscle cuirass with pteruges, flowing red paludamentum cloak, Roman military boots, long spear and round shield bearing a cross, recoiling backward from a heavy blow, body twisted, one arm thrown up, still holding the spear and the shield, grimacing in pain, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, medieval knight, plate armor, great helm, tabard
```

**`saint_george_body_fall`** — Pose de queda · piloto

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint George as a young Roman military officer of the late 3rd century, beardless with short curly hair as in Eastern icons, bronze muscle cuirass with pteruges, flowing red paludamentum cloak, Roman military boots, long spear and round shield bearing a cross, collapsed onto both knees and slumped forward, head bowed, the spear and the round shield fallen at his side on the ground, utterly exhausted but not dead, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, medieval knight, plate armor, great helm, tabard, blood pool, corpse, gore
```

**`saint_george_rig_base`** — Pose neutra para o rig · animação no Godot

> **Gerar:** proporção 2:3 na **maior resolução possível** · Midjourney: `--ar 2:3` + Upscale 2× (≥ 1792 × 2688 px) · GPT Image: 1024 × 1536 px e ampliar 2×  
> **Matriz:** PNG RGBA **2048 × 3072 px**, 72 ppi, sRGB, guardada em `art_source/` (figura ≈ 2400 px)  
> **Peças finais:** recortadas e exportadas a **50%**, na escala do `body_idle` (figura ≈ 1200 px), em `assets/characters/saints/<id>/rig/`

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body strict side profile view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint George as a young Roman military officer of the late 3rd century, beardless with short curly hair as in Eastern icons, bronze muscle cuirass with pteruges, flowing red paludamentum cloak, Roman military boots, long spear and round shield bearing a cross, neutral rigging pose for 2D skeletal animation: standing straight, arms held slightly away from the torso, legs slightly apart, no limb overlapping the torso or another limb, the spear and the round shield held clearly apart from the body, loose garments hanging straight without wrapping around the limbs, clearly readable joints at the neck, shoulders, elbows, wrists, hips, knees and ankles, calm neutral expression, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, medieval knight, plate armor, great helm, tabard, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`saint_george_rig_parts`** — Folha de peças separadas · animação no Godot

> **Gerar:** proporção 1:1 na **maior resolução possível** · Midjourney: `--ar 1:1` + Upscale 2× (≥ 2048 × 2048 px)  
> **Matriz:** PNG RGBA **2048 × 2048 px**, 72 ppi, sRGB, em `art_source/`  
> **Peças finais:** uma PNG RGBA por peça, mesma escala do `body_idle` (figura ≈ 1200 px), em `assets/characters/saints/<id>/rig/`

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, character parts sheet for 2D cutout skeletal animation, Saint George as a young Roman military officer of the late 3rd century, beardless with short curly hair as in Eastern icons, bronze muscle cuirass with pteruges, flowing red paludamentum cloak, Roman military boots, long spear and round shield bearing a cross, the same character disassembled into separate pieces laid out in a tidy grid with wide empty space between every piece: head with neck facing right, torso with hips, upper arm, forearm and hand for the near and far arm, thigh and lower leg with foot for the near and far leg, loose garments such as cloak, veil and lower robe as separate pieces, the spear and the round shield as separate pieces, every limb piece with extra rounded overlap at the joint ends, no piece touching another, all pieces at the same scale, side view facing right, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 1:1 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, medieval knight, plate armor, great helm, tabard, assembled character, overlapping pieces, labels, text, numbers, grid lines, arrows
```

## São Bento (`saint_benedict`)

**`saint_benedict_body_idle`** — Corpo inteiro, pose padrão · essencial

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Benedict of Nursia as an elderly 6th-century abbot with a long white beard, black Benedictine habit with hood and scapular, abbot's crozier, book of the Rule at his belt, a raven on his shoulder, a chalice with a small serpent rising from it, raising the crozier in a warding gesture, determined resolute expression, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

**`saint_benedict_face_dark_night`** — Rosto em Noite Escura · essencial

> **Gerar:** proporção 1:1 · **1024 × 1024 px** (Midjourney: `--ar 1:1` + Upscale)  
> **Arquivo final:** PNG RGBA, **1024 × 1024 px**, 72 ppi, sRGB · o Claude Code reduz ao tamanho da cabeça do `body_idle` (≈ 170 px)

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, close-up head and shoulders portrait, side three-quarter view facing right, same head angle as the full body reference, head and shoulders filling about 70 percent of the frame, head centered, Saint Benedict of Nursia, an elderly abbot with a long white beard, black Benedictine hood and habit, anguished exhausted expression, eyes downcast, brow furrowed, deep shadows under the eyes, face drained of color, thick irregular black ink outlines, heavy black shadows engulfing half the face, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 1:1 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

**`saint_benedict_face_consolation`** — Rosto em Consolação · essencial

> **Gerar:** proporção 1:1 · **1024 × 1024 px** (Midjourney: `--ar 1:1` + Upscale)  
> **Arquivo final:** PNG RGBA, **1024 × 1024 px**, 72 ppi, sRGB · o Claude Code reduz ao tamanho da cabeça do `body_idle` (≈ 170 px)

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, close-up head and shoulders portrait, side three-quarter view facing right, same head angle as the full body reference, head and shoulders filling about 70 percent of the frame, head centered, Saint Benedict of Nursia, an elderly abbot with a long white beard, black Benedictine hood and habit, peaceful serene radiant expression, eyes softly lifted, faint warm gold light on the face, thick irregular black ink outlines, heavy black shadows engulfing half the face, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 1:1 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

**`saint_benedict_portrait`** — Retrato · essencial

> **Gerar:** proporção 3:4 · Midjourney: `--ar 3:4` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **768 × 1024 px**, 72 ppi, sRGB · do peito para cima

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, bust portrait from the chest up, three-quarter view facing right, framed from the chest up, eyes in the upper third of the frame, Saint Benedict of Nursia, an elderly abbot with a long white beard, black Benedictine hood and habit, determined resolute expression, strong readable silhouette, thick irregular black ink outlines, heavy black shadows engulfing half the face, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 3:4 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

**`saint_benedict_body_attack`** — Pose de ataque · piloto

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Benedict of Nursia as an elderly 6th-century abbot with a long white beard, black Benedictine habit with hood and scapular, abbot's crozier, book of the Rule at his belt, a raven on his shoulder, a chalice with a small serpent rising from it, stepping forward and thrusting the crozier at the enemy, free hand raised in a commanding gesture of exorcism, the raven taking flight from his shoulder, fierce determined expression, dynamic action pose, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

**`saint_benedict_body_hit`** — Pose de golpe recebido · piloto

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Benedict of Nursia as an elderly 6th-century abbot with a long white beard, black Benedictine habit with hood and scapular, abbot's crozier, book of the Rule at his belt, a raven on his shoulder, a chalice with a small serpent rising from it, recoiling backward from a heavy blow, body twisted, one arm thrown up, still holding the crozier, grimacing in pain, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

**`saint_benedict_body_fall`** — Pose de queda · piloto

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Benedict of Nursia as an elderly 6th-century abbot with a long white beard, black Benedictine habit with hood and scapular, abbot's crozier, book of the Rule at his belt, a raven on his shoulder, a chalice with a small serpent rising from it, collapsed onto both knees and slumped forward, head bowed, the crozier and the chalice fallen at his side on the ground, utterly exhausted but not dead, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, blood pool, corpse, gore
```

**`saint_benedict_rig_base`** — Pose neutra para o rig · animação no Godot

> **Gerar:** proporção 2:3 na **maior resolução possível** · Midjourney: `--ar 2:3` + Upscale 2× (≥ 1792 × 2688 px) · GPT Image: 1024 × 1536 px e ampliar 2×  
> **Matriz:** PNG RGBA **2048 × 3072 px**, 72 ppi, sRGB, guardada em `art_source/` (figura ≈ 2400 px)  
> **Peças finais:** recortadas e exportadas a **50%**, na escala do `body_idle` (figura ≈ 1200 px), em `assets/characters/saints/<id>/rig/`

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body strict side profile view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Benedict of Nursia as an elderly 6th-century abbot with a long white beard, black Benedictine habit with hood and scapular, abbot's crozier, book of the Rule at his belt, a raven on his shoulder, a chalice with a small serpent rising from it, neutral rigging pose for 2D skeletal animation: standing straight, arms held slightly away from the torso, legs slightly apart, no limb overlapping the torso or another limb, the crozier and the chalice held clearly apart from the body, loose garments hanging straight without wrapping around the limbs, clearly readable joints at the neck, shoulders, elbows, wrists, hips, knees and ankles, calm neutral expression, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`saint_benedict_rig_parts`** — Folha de peças separadas · animação no Godot

> **Gerar:** proporção 1:1 na **maior resolução possível** · Midjourney: `--ar 1:1` + Upscale 2× (≥ 2048 × 2048 px)  
> **Matriz:** PNG RGBA **2048 × 2048 px**, 72 ppi, sRGB, em `art_source/`  
> **Peças finais:** uma PNG RGBA por peça, mesma escala do `body_idle` (figura ≈ 1200 px), em `assets/characters/saints/<id>/rig/`

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, character parts sheet for 2D cutout skeletal animation, Saint Benedict of Nursia as an elderly 6th-century abbot with a long white beard, black Benedictine habit with hood and scapular, abbot's crozier, book of the Rule at his belt, a raven on his shoulder, a chalice with a small serpent rising from it, the same character disassembled into separate pieces laid out in a tidy grid with wide empty space between every piece: head with neck facing right, torso with hips, upper arm, forearm and hand for the near and far arm, thigh and lower leg with foot for the near and far leg, loose garments such as cloak, veil and lower robe as separate pieces, the crozier and the chalice as separate pieces, every limb piece with extra rounded overlap at the joint ends, no piece touching another, all pieces at the same scale, side view facing right, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 1:1 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, assembled character, overlapping pieces, labels, text, numbers, grid lines, arrows
```

## Santa Teresinha (`saint_therese`)

**`saint_therese_body_idle`** — Corpo inteiro, pose padrão · essencial

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Therese of Lisieux as a young 19th-century Carmelite nun with a gentle round face, brown Carmelite habit and scapular, white mantle, black veil over white wimple, a crucifix wrapped in roses, the crucifix held against her chest, rose petals falling, one hand extended in blessing, determined resolute expression, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

**`saint_therese_face_dark_night`** — Rosto em Noite Escura · essencial

> **Gerar:** proporção 1:1 · **1024 × 1024 px** (Midjourney: `--ar 1:1` + Upscale)  
> **Arquivo final:** PNG RGBA, **1024 × 1024 px**, 72 ppi, sRGB · o Claude Code reduz ao tamanho da cabeça do `body_idle` (≈ 170 px)

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, close-up head and shoulders portrait, side three-quarter view facing right, same head angle as the full body reference, head and shoulders filling about 70 percent of the frame, head centered, Saint Therese of Lisieux, a young Carmelite nun with a gentle round face, black veil over white wimple, white mantle, anguished exhausted expression, eyes downcast, brow furrowed, deep shadows under the eyes, face drained of color, thick irregular black ink outlines, heavy black shadows engulfing half the face, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 1:1 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

**`saint_therese_face_consolation`** — Rosto em Consolação · essencial

> **Gerar:** proporção 1:1 · **1024 × 1024 px** (Midjourney: `--ar 1:1` + Upscale)  
> **Arquivo final:** PNG RGBA, **1024 × 1024 px**, 72 ppi, sRGB · o Claude Code reduz ao tamanho da cabeça do `body_idle` (≈ 170 px)

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, close-up head and shoulders portrait, side three-quarter view facing right, same head angle as the full body reference, head and shoulders filling about 70 percent of the frame, head centered, Saint Therese of Lisieux, a young Carmelite nun with a gentle round face, black veil over white wimple, white mantle, peaceful serene radiant expression, eyes softly lifted, faint warm gold light on the face, thick irregular black ink outlines, heavy black shadows engulfing half the face, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 1:1 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

**`saint_therese_portrait`** — Retrato · essencial

> **Gerar:** proporção 3:4 · Midjourney: `--ar 3:4` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **768 × 1024 px**, 72 ppi, sRGB · do peito para cima

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, bust portrait from the chest up, three-quarter view facing right, framed from the chest up, eyes in the upper third of the frame, Saint Therese of Lisieux, a young Carmelite nun with a gentle round face, black veil over white wimple, white mantle, determined resolute expression, strong readable silhouette, thick irregular black ink outlines, heavy black shadows engulfing half the face, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 3:4 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

**`saint_therese_body_attack`** — Pose de ataque · piloto

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Therese of Lisieux as a young 19th-century Carmelite nun with a gentle round face, brown Carmelite habit and scapular, white mantle, black veil over white wimple, a crucifix wrapped in roses, thrusting one open hand forward releasing a burst of rose petals, the crucifix raised high in the other hand, fierce determined expression, dynamic action pose, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

**`saint_therese_body_hit`** — Pose de golpe recebido · piloto

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Therese of Lisieux as a young 19th-century Carmelite nun with a gentle round face, brown Carmelite habit and scapular, white mantle, black veil over white wimple, a crucifix wrapped in roses, recoiling backward from a heavy blow, body twisted, one arm thrown up, still holding the crucifix wrapped in roses, grimacing in pain, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

**`saint_therese_body_fall`** — Pose de queda · piloto

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Therese of Lisieux as a young 19th-century Carmelite nun with a gentle round face, brown Carmelite habit and scapular, white mantle, black veil over white wimple, a crucifix wrapped in roses, collapsed onto both knees and slumped forward, head bowed, the crucifix wrapped in roses fallen at her side on the ground, utterly exhausted but not dead, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, blood pool, corpse, gore
```

**`saint_therese_rig_base`** — Pose neutra para o rig · animação no Godot

> **Gerar:** proporção 2:3 na **maior resolução possível** · Midjourney: `--ar 2:3` + Upscale 2× (≥ 1792 × 2688 px) · GPT Image: 1024 × 1536 px e ampliar 2×  
> **Matriz:** PNG RGBA **2048 × 3072 px**, 72 ppi, sRGB, guardada em `art_source/` (figura ≈ 2400 px)  
> **Peças finais:** recortadas e exportadas a **50%**, na escala do `body_idle` (figura ≈ 1200 px), em `assets/characters/saints/<id>/rig/`

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body strict side profile view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Therese of Lisieux as a young 19th-century Carmelite nun with a gentle round face, brown Carmelite habit and scapular, white mantle, black veil over white wimple, a crucifix wrapped in roses, neutral rigging pose for 2D skeletal animation: standing straight, arms held slightly away from the torso, legs slightly apart, no limb overlapping the torso or another limb, the crucifix wrapped in roses held clearly apart from the body, loose garments hanging straight without wrapping around the limbs, clearly readable joints at the neck, shoulders, elbows, wrists, hips, knees and ankles, calm neutral expression, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`saint_therese_rig_parts`** — Folha de peças separadas · animação no Godot

> **Gerar:** proporção 1:1 na **maior resolução possível** · Midjourney: `--ar 1:1` + Upscale 2× (≥ 2048 × 2048 px)  
> **Matriz:** PNG RGBA **2048 × 2048 px**, 72 ppi, sRGB, em `art_source/`  
> **Peças finais:** uma PNG RGBA por peça, mesma escala do `body_idle` (figura ≈ 1200 px), em `assets/characters/saints/<id>/rig/`

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, character parts sheet for 2D cutout skeletal animation, Saint Therese of Lisieux as a young 19th-century Carmelite nun with a gentle round face, brown Carmelite habit and scapular, white mantle, black veil over white wimple, a crucifix wrapped in roses, the same character disassembled into separate pieces laid out in a tidy grid with wide empty space between every piece: head with neck facing right, torso with hips, upper arm, forearm and hand for the near and far arm, thigh and lower leg with foot for the near and far leg, loose garments such as cloak, veil and lower robe as separate pieces, the crucifix wrapped in roses as separate pieces, every limb piece with extra rounded overlap at the joint ends, no piece touching another, all pieces at the same scale, side view facing right, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 1:1 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, assembled character, overlapping pieces, labels, text, numbers, grid lines, arrows
```

## São Nicolau de Mira (`saint_nicholas`)

**`saint_nicholas_body_idle`** — Corpo inteiro, pose padrão · essencial

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Nicholas of Myra as an elderly 4th-century Greek bishop with a full white beard, eastern bishop's vestments with an omophorion stole marked with crosses, a bishop's crozier, three small closed leather purses, a book of the Gospels at his side, the crozier in one hand, the three purses held forward in the other in a gesture of giving, determined resolute expression, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, santa claus, red suit, fur trim, sleigh, gold coins, children
```

**`saint_nicholas_face_dark_night`** — Rosto em Noite Escura · essencial

> **Gerar:** proporção 1:1 · **1024 × 1024 px** (Midjourney: `--ar 1:1` + Upscale)  
> **Arquivo final:** PNG RGBA, **1024 × 1024 px**, 72 ppi, sRGB · o Claude Code reduz ao tamanho da cabeça do `body_idle` (≈ 170 px)

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, close-up head and shoulders portrait, side three-quarter view facing right, same head angle as the full body reference, head and shoulders filling about 70 percent of the frame, head centered, Saint Nicholas of Myra, an elderly Greek bishop with a full white beard, eastern bishop's vestments with an omophorion stole marked with crosses, anguished exhausted expression, eyes downcast, brow furrowed, deep shadows under the eyes, face drained of color, thick irregular black ink outlines, heavy black shadows engulfing half the face, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 1:1 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, santa claus, red suit, fur trim, sleigh, gold coins, children
```

**`saint_nicholas_face_consolation`** — Rosto em Consolação · essencial

> **Gerar:** proporção 1:1 · **1024 × 1024 px** (Midjourney: `--ar 1:1` + Upscale)  
> **Arquivo final:** PNG RGBA, **1024 × 1024 px**, 72 ppi, sRGB · o Claude Code reduz ao tamanho da cabeça do `body_idle` (≈ 170 px)

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, close-up head and shoulders portrait, side three-quarter view facing right, same head angle as the full body reference, head and shoulders filling about 70 percent of the frame, head centered, Saint Nicholas of Myra, an elderly Greek bishop with a full white beard, eastern bishop's vestments with an omophorion stole marked with crosses, peaceful serene radiant expression, eyes softly lifted, faint warm gold light on the face, thick irregular black ink outlines, heavy black shadows engulfing half the face, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 1:1 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, santa claus, red suit, fur trim, sleigh, gold coins, children
```

**`saint_nicholas_portrait`** — Retrato · essencial

> **Gerar:** proporção 3:4 · Midjourney: `--ar 3:4` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **768 × 1024 px**, 72 ppi, sRGB · do peito para cima

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, bust portrait from the chest up, three-quarter view facing right, framed from the chest up, eyes in the upper third of the frame, Saint Nicholas of Myra, an elderly Greek bishop with a full white beard, eastern bishop's vestments with an omophorion stole marked with crosses, determined resolute expression, strong readable silhouette, thick irregular black ink outlines, heavy black shadows engulfing half the face, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 3:4 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, santa claus, red suit, fur trim, sleigh, gold coins, children
```

**`saint_nicholas_body_attack`** — Pose de ataque · piloto

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Nicholas of Myra as an elderly 4th-century Greek bishop with a full white beard, eastern bishop's vestments with an omophorion stole marked with crosses, a bishop's crozier, three small closed leather purses, a book of the Gospels at his side, striking forward with the bishop's crozier in a firm rebuking blow, the other hand raised in admonition, fierce determined expression, dynamic action pose, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, santa claus, red suit, fur trim, sleigh, gold coins, children
```

**`saint_nicholas_body_hit`** — Pose de golpe recebido · piloto

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Nicholas of Myra as an elderly 4th-century Greek bishop with a full white beard, eastern bishop's vestments with an omophorion stole marked with crosses, a bishop's crozier, three small closed leather purses, a book of the Gospels at his side, recoiling backward from a heavy blow, body twisted, one arm thrown up, still holding the crozier, grimacing in pain, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, santa claus, red suit, fur trim, sleigh, gold coins, children
```

**`saint_nicholas_body_fall`** — Pose de queda · piloto

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Nicholas of Myra as an elderly 4th-century Greek bishop with a full white beard, eastern bishop's vestments with an omophorion stole marked with crosses, a bishop's crozier, three small closed leather purses, a book of the Gospels at his side, collapsed onto both knees and slumped forward, head bowed, the crozier and the three purses fallen at his side on the ground, utterly exhausted but not dead, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, santa claus, red suit, fur trim, sleigh, gold coins, children, blood pool, corpse, gore
```

**`saint_nicholas_rig_base`** — Pose neutra para o rig · animação no Godot

> **Gerar:** proporção 2:3 na **maior resolução possível** · Midjourney: `--ar 2:3` + Upscale 2× (≥ 1792 × 2688 px) · GPT Image: 1024 × 1536 px e ampliar 2×  
> **Matriz:** PNG RGBA **2048 × 3072 px**, 72 ppi, sRGB, guardada em `art_source/` (figura ≈ 2400 px)  
> **Peças finais:** recortadas e exportadas a **50%**, na escala do `body_idle` (figura ≈ 1200 px), em `assets/characters/saints/<id>/rig/`

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body strict side profile view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Nicholas of Myra as an elderly 4th-century Greek bishop with a full white beard, eastern bishop's vestments with an omophorion stole marked with crosses, a bishop's crozier, three small closed leather purses, a book of the Gospels at his side, neutral rigging pose for 2D skeletal animation: standing straight, arms held slightly away from the torso, legs slightly apart, no limb overlapping the torso or another limb, the crozier and the three purses held clearly apart from the body, loose garments hanging straight without wrapping around the limbs, clearly readable joints at the neck, shoulders, elbows, wrists, hips, knees and ankles, calm neutral expression, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, santa claus, red suit, fur trim, sleigh, gold coins, children, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`saint_nicholas_rig_parts`** — Folha de peças separadas · animação no Godot

> **Gerar:** proporção 1:1 na **maior resolução possível** · Midjourney: `--ar 1:1` + Upscale 2× (≥ 2048 × 2048 px)  
> **Matriz:** PNG RGBA **2048 × 2048 px**, 72 ppi, sRGB, em `art_source/`  
> **Peças finais:** uma PNG RGBA por peça, mesma escala do `body_idle` (figura ≈ 1200 px), em `assets/characters/saints/<id>/rig/`

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, character parts sheet for 2D cutout skeletal animation, Saint Nicholas of Myra as an elderly 4th-century Greek bishop with a full white beard, eastern bishop's vestments with an omophorion stole marked with crosses, a bishop's crozier, three small closed leather purses, a book of the Gospels at his side, the same character disassembled into separate pieces laid out in a tidy grid with wide empty space between every piece: head with neck facing right, torso with hips, upper arm, forearm and hand for the near and far arm, thigh and lower leg with foot for the near and far leg, loose garments such as cloak, veil and lower robe as separate pieces, the crozier and the three purses as separate pieces, every limb piece with extra rounded overlap at the joint ends, no piece touching another, all pieces at the same scale, side view facing right, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 1:1 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, santa claus, red suit, fur trim, sleigh, gold coins, children, assembled character, overlapping pieces, labels, text, numbers, grid lines, arrows
```

## Santo Antão (`saint_anthony_abbot`)

**`saint_anthony_abbot_body_idle`** — Corpo inteiro, pose padrão · essencial

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Anthony the Great as a very old 4th-century desert hermit with a long white beard, rough hooded hermit tunic, a tau-shaped staff, a small hand bell at his belt, a tau symbol on his shoulder, a small pig at his feet, the tau staff gripped like a weapon, leaning forward in a fighting stance, determined resolute expression, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

**`saint_anthony_abbot_face_dark_night`** — Rosto em Noite Escura · essencial

> **Gerar:** proporção 1:1 · **1024 × 1024 px** (Midjourney: `--ar 1:1` + Upscale)  
> **Arquivo final:** PNG RGBA, **1024 × 1024 px**, 72 ppi, sRGB · o Claude Code reduz ao tamanho da cabeça do `body_idle` (≈ 170 px)

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, close-up head and shoulders portrait, side three-quarter view facing right, same head angle as the full body reference, head and shoulders filling about 70 percent of the frame, head centered, Saint Anthony the Great, a very old desert hermit with a long white beard and a rough hooded tunic, anguished exhausted expression, eyes downcast, brow furrowed, deep shadows under the eyes, face drained of color, thick irregular black ink outlines, heavy black shadows engulfing half the face, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 1:1 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

**`saint_anthony_abbot_face_consolation`** — Rosto em Consolação · essencial

> **Gerar:** proporção 1:1 · **1024 × 1024 px** (Midjourney: `--ar 1:1` + Upscale)  
> **Arquivo final:** PNG RGBA, **1024 × 1024 px**, 72 ppi, sRGB · o Claude Code reduz ao tamanho da cabeça do `body_idle` (≈ 170 px)

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, close-up head and shoulders portrait, side three-quarter view facing right, same head angle as the full body reference, head and shoulders filling about 70 percent of the frame, head centered, Saint Anthony the Great, a very old desert hermit with a long white beard and a rough hooded tunic, peaceful serene radiant expression, eyes softly lifted, faint warm gold light on the face, thick irregular black ink outlines, heavy black shadows engulfing half the face, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 1:1 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

**`saint_anthony_abbot_portrait`** — Retrato · essencial

> **Gerar:** proporção 3:4 · Midjourney: `--ar 3:4` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **768 × 1024 px**, 72 ppi, sRGB · do peito para cima

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, bust portrait from the chest up, three-quarter view facing right, framed from the chest up, eyes in the upper third of the frame, Saint Anthony the Great, a very old desert hermit with a long white beard and a rough hooded tunic, determined resolute expression, strong readable silhouette, thick irregular black ink outlines, heavy black shadows engulfing half the face, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 3:4 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

**`saint_anthony_abbot_body_attack`** — Pose de ataque · piloto

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Anthony the Great as a very old 4th-century desert hermit with a long white beard, rough hooded hermit tunic, a tau-shaped staff, a small hand bell at his belt, a tau symbol on his shoulder, a small pig at his feet, swinging the tau staff in a powerful overhead strike, beard and tunic whipping with the motion, fierce determined expression, dynamic action pose, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

**`saint_anthony_abbot_body_hit`** — Pose de golpe recebido · piloto

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Anthony the Great as a very old 4th-century desert hermit with a long white beard, rough hooded hermit tunic, a tau-shaped staff, a small hand bell at his belt, a tau symbol on his shoulder, a small pig at his feet, recoiling backward from a heavy blow, body twisted, one arm thrown up, still holding the tau staff, grimacing in pain, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

**`saint_anthony_abbot_body_fall`** — Pose de queda · piloto

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Anthony the Great as a very old 4th-century desert hermit with a long white beard, rough hooded hermit tunic, a tau-shaped staff, a small hand bell at his belt, a tau symbol on his shoulder, a small pig at his feet, collapsed onto both knees and slumped forward, head bowed, the tau staff and the hand bell fallen at his side on the ground, utterly exhausted but not dead, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, blood pool, corpse, gore
```

**`saint_anthony_abbot_rig_base`** — Pose neutra para o rig · animação no Godot

> **Gerar:** proporção 2:3 na **maior resolução possível** · Midjourney: `--ar 2:3` + Upscale 2× (≥ 1792 × 2688 px) · GPT Image: 1024 × 1536 px e ampliar 2×  
> **Matriz:** PNG RGBA **2048 × 3072 px**, 72 ppi, sRGB, guardada em `art_source/` (figura ≈ 2400 px)  
> **Peças finais:** recortadas e exportadas a **50%**, na escala do `body_idle` (figura ≈ 1200 px), em `assets/characters/saints/<id>/rig/`

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body strict side profile view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Anthony the Great as a very old 4th-century desert hermit with a long white beard, rough hooded hermit tunic, a tau-shaped staff, a small hand bell at his belt, a tau symbol on his shoulder, a small pig at his feet, neutral rigging pose for 2D skeletal animation: standing straight, arms held slightly away from the torso, legs slightly apart, no limb overlapping the torso or another limb, the tau staff and the hand bell held clearly apart from the body, loose garments hanging straight without wrapping around the limbs, clearly readable joints at the neck, shoulders, elbows, wrists, hips, knees and ankles, calm neutral expression, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`saint_anthony_abbot_rig_parts`** — Folha de peças separadas · animação no Godot

> **Gerar:** proporção 1:1 na **maior resolução possível** · Midjourney: `--ar 1:1` + Upscale 2× (≥ 2048 × 2048 px)  
> **Matriz:** PNG RGBA **2048 × 2048 px**, 72 ppi, sRGB, em `art_source/`  
> **Peças finais:** uma PNG RGBA por peça, mesma escala do `body_idle` (figura ≈ 1200 px), em `assets/characters/saints/<id>/rig/`

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, character parts sheet for 2D cutout skeletal animation, Saint Anthony the Great as a very old 4th-century desert hermit with a long white beard, rough hooded hermit tunic, a tau-shaped staff, a small hand bell at his belt, a tau symbol on his shoulder, a small pig at his feet, the same character disassembled into separate pieces laid out in a tidy grid with wide empty space between every piece: head with neck facing right, torso with hips, upper arm, forearm and hand for the near and far arm, thigh and lower leg with foot for the near and far leg, loose garments such as cloak, veil and lower robe as separate pieces, the tau staff and the hand bell as separate pieces, every limb piece with extra rounded overlap at the joint ends, no piece touching another, all pieces at the same scale, side view facing right, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 1:1 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, assembled character, overlapping pieces, labels, text, numbers, grid lines, arrows
```

## Santa Joana d'Arc (`saint_joan`)

**`saint_joan_body_idle`** — Corpo inteiro, pose padrão · essencial

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Joan of Arc as a young 15th-century warrior maiden with short page-boy haircut, full plate armor, a white battle standard with fleur-de-lis, a sword, the standard held high, the sword at the ready, determined resolute expression, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, long hair, letters
```

**`saint_joan_face_dark_night`** — Rosto em Noite Escura · essencial

> **Gerar:** proporção 1:1 · **1024 × 1024 px** (Midjourney: `--ar 1:1` + Upscale)  
> **Arquivo final:** PNG RGBA, **1024 × 1024 px**, 72 ppi, sRGB · o Claude Code reduz ao tamanho da cabeça do `body_idle` (≈ 170 px)

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, close-up head and shoulders portrait, side three-quarter view facing right, same head angle as the full body reference, head and shoulders filling about 70 percent of the frame, head centered, Saint Joan of Arc, a young warrior maiden with a short page-boy haircut, wearing plate armor, anguished exhausted expression, eyes downcast, brow furrowed, deep shadows under the eyes, face drained of color, thick irregular black ink outlines, heavy black shadows engulfing half the face, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 1:1 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, long hair, letters
```

**`saint_joan_face_consolation`** — Rosto em Consolação · essencial

> **Gerar:** proporção 1:1 · **1024 × 1024 px** (Midjourney: `--ar 1:1` + Upscale)  
> **Arquivo final:** PNG RGBA, **1024 × 1024 px**, 72 ppi, sRGB · o Claude Code reduz ao tamanho da cabeça do `body_idle` (≈ 170 px)

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, close-up head and shoulders portrait, side three-quarter view facing right, same head angle as the full body reference, head and shoulders filling about 70 percent of the frame, head centered, Saint Joan of Arc, a young warrior maiden with a short page-boy haircut, wearing plate armor, peaceful serene radiant expression, eyes softly lifted, faint warm gold light on the face, thick irregular black ink outlines, heavy black shadows engulfing half the face, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 1:1 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, long hair, letters
```

**`saint_joan_portrait`** — Retrato · essencial

> **Gerar:** proporção 3:4 · Midjourney: `--ar 3:4` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **768 × 1024 px**, 72 ppi, sRGB · do peito para cima

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, bust portrait from the chest up, three-quarter view facing right, framed from the chest up, eyes in the upper third of the frame, Saint Joan of Arc, a young warrior maiden with a short page-boy haircut, wearing plate armor, determined resolute expression, strong readable silhouette, thick irregular black ink outlines, heavy black shadows engulfing half the face, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 3:4 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, long hair, letters
```

**`saint_joan_body_attack`** — Pose de ataque · piloto

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Joan of Arc as a young 15th-century warrior maiden with short page-boy haircut, full plate armor, a white battle standard with fleur-de-lis, a sword, charging forward with a sweeping sword cut, the white standard streaming behind her, fierce determined expression, dynamic action pose, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, long hair, letters
```

**`saint_joan_body_hit`** — Pose de golpe recebido · piloto

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Joan of Arc as a young 15th-century warrior maiden with short page-boy haircut, full plate armor, a white battle standard with fleur-de-lis, a sword, recoiling backward from a heavy blow, body twisted, one arm thrown up, still holding the sword and the standard, grimacing in pain, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, long hair, letters
```

**`saint_joan_body_fall`** — Pose de queda · piloto

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Joan of Arc as a young 15th-century warrior maiden with short page-boy haircut, full plate armor, a white battle standard with fleur-de-lis, a sword, collapsed onto both knees and slumped forward, head bowed, the sword and the white standard fallen at her side on the ground, utterly exhausted but not dead, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, long hair, letters, blood pool, corpse, gore
```

**`saint_joan_rig_base`** — Pose neutra para o rig · animação no Godot

> **Gerar:** proporção 2:3 na **maior resolução possível** · Midjourney: `--ar 2:3` + Upscale 2× (≥ 1792 × 2688 px) · GPT Image: 1024 × 1536 px e ampliar 2×  
> **Matriz:** PNG RGBA **2048 × 3072 px**, 72 ppi, sRGB, guardada em `art_source/` (figura ≈ 2400 px)  
> **Peças finais:** recortadas e exportadas a **50%**, na escala do `body_idle` (figura ≈ 1200 px), em `assets/characters/saints/<id>/rig/`

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body strict side profile view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Joan of Arc as a young 15th-century warrior maiden with short page-boy haircut, full plate armor, a white battle standard with fleur-de-lis, a sword, neutral rigging pose for 2D skeletal animation: standing straight, arms held slightly away from the torso, legs slightly apart, no limb overlapping the torso or another limb, the sword and the white standard held clearly apart from the body, loose garments hanging straight without wrapping around the limbs, clearly readable joints at the neck, shoulders, elbows, wrists, hips, knees and ankles, calm neutral expression, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, long hair, letters, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`saint_joan_rig_parts`** — Folha de peças separadas · animação no Godot

> **Gerar:** proporção 1:1 na **maior resolução possível** · Midjourney: `--ar 1:1` + Upscale 2× (≥ 2048 × 2048 px)  
> **Matriz:** PNG RGBA **2048 × 2048 px**, 72 ppi, sRGB, em `art_source/`  
> **Peças finais:** uma PNG RGBA por peça, mesma escala do `body_idle` (figura ≈ 1200 px), em `assets/characters/saints/<id>/rig/`

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, character parts sheet for 2D cutout skeletal animation, Saint Joan of Arc as a young 15th-century warrior maiden with short page-boy haircut, full plate armor, a white battle standard with fleur-de-lis, a sword, the same character disassembled into separate pieces laid out in a tidy grid with wide empty space between every piece: head with neck facing right, torso with hips, upper arm, forearm and hand for the near and far arm, thigh and lower leg with foot for the near and far leg, loose garments such as cloak, veil and lower robe as separate pieces, the sword and the white standard as separate pieces, every limb piece with extra rounded overlap at the joint ends, no piece touching another, all pieces at the same scale, side view facing right, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 1:1 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, long hair, letters, assembled character, overlapping pieces, labels, text, numbers, grid lines, arrows
```

## São João da Cruz (`saint_john_cross`)

**`saint_john_cross_body_idle`** — Corpo inteiro, pose padrão · essencial

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint John of the Cross as a small, thin 16th-century Discalced Carmelite friar with tonsure and short dark beard, brown habit, white cape with hood, sandals, a large wooden cross, a quill and a small book at his belt, the large wooden cross held forward, determined resolute expression, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

**`saint_john_cross_face_dark_night`** — Rosto em Noite Escura · essencial

> **Gerar:** proporção 1:1 · **1024 × 1024 px** (Midjourney: `--ar 1:1` + Upscale)  
> **Arquivo final:** PNG RGBA, **1024 × 1024 px**, 72 ppi, sRGB · o Claude Code reduz ao tamanho da cabeça do `body_idle` (≈ 170 px)

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, close-up head and shoulders portrait, side three-quarter view facing right, same head angle as the full body reference, head and shoulders filling about 70 percent of the frame, head centered, Saint John of the Cross, a small thin Carmelite friar with tonsure and short dark beard, brown habit and white hooded cape, anguished exhausted expression, eyes downcast, brow furrowed, deep shadows under the eyes, face drained of color, thick irregular black ink outlines, heavy black shadows engulfing half the face, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 1:1 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

**`saint_john_cross_face_consolation`** — Rosto em Consolação · essencial

> **Gerar:** proporção 1:1 · **1024 × 1024 px** (Midjourney: `--ar 1:1` + Upscale)  
> **Arquivo final:** PNG RGBA, **1024 × 1024 px**, 72 ppi, sRGB · o Claude Code reduz ao tamanho da cabeça do `body_idle` (≈ 170 px)

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, close-up head and shoulders portrait, side three-quarter view facing right, same head angle as the full body reference, head and shoulders filling about 70 percent of the frame, head centered, Saint John of the Cross, a small thin Carmelite friar with tonsure and short dark beard, brown habit and white hooded cape, peaceful serene radiant expression, eyes softly lifted, faint warm gold light on the face, thick irregular black ink outlines, heavy black shadows engulfing half the face, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 1:1 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

**`saint_john_cross_portrait`** — Retrato · essencial

> **Gerar:** proporção 3:4 · Midjourney: `--ar 3:4` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **768 × 1024 px**, 72 ppi, sRGB · do peito para cima

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, bust portrait from the chest up, three-quarter view facing right, framed from the chest up, eyes in the upper third of the frame, Saint John of the Cross, a small thin Carmelite friar with tonsure and short dark beard, brown habit and white hooded cape, determined resolute expression, strong readable silhouette, thick irregular black ink outlines, heavy black shadows engulfing half the face, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 3:4 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

**`saint_john_cross_body_attack`** — Pose de ataque · piloto

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint John of the Cross as a small, thin 16th-century Discalced Carmelite friar with tonsure and short dark beard, brown habit, white cape with hood, sandals, a large wooden cross, a quill and a small book at his belt, thrusting the large wooden cross forward at arm's length against the darkness, leaning into the gesture, fierce determined expression, dynamic action pose, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

**`saint_john_cross_body_hit`** — Pose de golpe recebido · piloto

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint John of the Cross as a small, thin 16th-century Discalced Carmelite friar with tonsure and short dark beard, brown habit, white cape with hood, sandals, a large wooden cross, a quill and a small book at his belt, recoiling backward from a heavy blow, body twisted, one arm thrown up, still holding the wooden cross, grimacing in pain, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

**`saint_john_cross_body_fall`** — Pose de queda · piloto

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint John of the Cross as a small, thin 16th-century Discalced Carmelite friar with tonsure and short dark beard, brown habit, white cape with hood, sandals, a large wooden cross, a quill and a small book at his belt, collapsed onto both knees and slumped forward, head bowed, the large wooden cross fallen at his side on the ground, utterly exhausted but not dead, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, blood pool, corpse, gore
```

**`saint_john_cross_rig_base`** — Pose neutra para o rig · animação no Godot

> **Gerar:** proporção 2:3 na **maior resolução possível** · Midjourney: `--ar 2:3` + Upscale 2× (≥ 1792 × 2688 px) · GPT Image: 1024 × 1536 px e ampliar 2×  
> **Matriz:** PNG RGBA **2048 × 3072 px**, 72 ppi, sRGB, guardada em `art_source/` (figura ≈ 2400 px)  
> **Peças finais:** recortadas e exportadas a **50%**, na escala do `body_idle` (figura ≈ 1200 px), em `assets/characters/saints/<id>/rig/`

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body strict side profile view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint John of the Cross as a small, thin 16th-century Discalced Carmelite friar with tonsure and short dark beard, brown habit, white cape with hood, sandals, a large wooden cross, a quill and a small book at his belt, neutral rigging pose for 2D skeletal animation: standing straight, arms held slightly away from the torso, legs slightly apart, no limb overlapping the torso or another limb, the large wooden cross held clearly apart from the body, loose garments hanging straight without wrapping around the limbs, clearly readable joints at the neck, shoulders, elbows, wrists, hips, knees and ankles, calm neutral expression, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`saint_john_cross_rig_parts`** — Folha de peças separadas · animação no Godot

> **Gerar:** proporção 1:1 na **maior resolução possível** · Midjourney: `--ar 1:1` + Upscale 2× (≥ 2048 × 2048 px)  
> **Matriz:** PNG RGBA **2048 × 2048 px**, 72 ppi, sRGB, em `art_source/`  
> **Peças finais:** uma PNG RGBA por peça, mesma escala do `body_idle` (figura ≈ 1200 px), em `assets/characters/saints/<id>/rig/`

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, character parts sheet for 2D cutout skeletal animation, Saint John of the Cross as a small, thin 16th-century Discalced Carmelite friar with tonsure and short dark beard, brown habit, white cape with hood, sandals, a large wooden cross, a quill and a small book at his belt, the same character disassembled into separate pieces laid out in a tidy grid with wide empty space between every piece: head with neck facing right, torso with hips, upper arm, forearm and hand for the near and far arm, thigh and lower leg with foot for the near and far leg, loose garments such as cloak, veil and lower robe as separate pieces, the large wooden cross as separate pieces, every limb piece with extra rounded overlap at the joint ends, no piece touching another, all pieces at the same scale, side view facing right, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 1:1 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, assembled character, overlapping pieces, labels, text, numbers, grid lines, arrows
```

## São Padre Pio (`saint_pio`)

**`saint_pio_body_idle`** — Corpo inteiro, pose padrão · essencial

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Padre Pio of Pietrelcina as a grey-bearded 20th-century Capuchin friar, brown Capuchin habit with long pointed hood, white rope belt, fingerless brown half-gloves covering the stigmata, a rosary wrapped around one hand, the other hand raised against evil, determined resolute expression, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

**`saint_pio_face_dark_night`** — Rosto em Noite Escura · essencial

> **Gerar:** proporção 1:1 · **1024 × 1024 px** (Midjourney: `--ar 1:1` + Upscale)  
> **Arquivo final:** PNG RGBA, **1024 × 1024 px**, 72 ppi, sRGB · o Claude Code reduz ao tamanho da cabeça do `body_idle` (≈ 170 px)

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, close-up head and shoulders portrait, side three-quarter view facing right, same head angle as the full body reference, head and shoulders filling about 70 percent of the frame, head centered, Saint Padre Pio of Pietrelcina, a grey-bearded Capuchin friar in a brown habit with long pointed hood, anguished exhausted expression, eyes downcast, brow furrowed, deep shadows under the eyes, face drained of color, thick irregular black ink outlines, heavy black shadows engulfing half the face, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 1:1 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

**`saint_pio_face_consolation`** — Rosto em Consolação · essencial

> **Gerar:** proporção 1:1 · **1024 × 1024 px** (Midjourney: `--ar 1:1` + Upscale)  
> **Arquivo final:** PNG RGBA, **1024 × 1024 px**, 72 ppi, sRGB · o Claude Code reduz ao tamanho da cabeça do `body_idle` (≈ 170 px)

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, close-up head and shoulders portrait, side three-quarter view facing right, same head angle as the full body reference, head and shoulders filling about 70 percent of the frame, head centered, Saint Padre Pio of Pietrelcina, a grey-bearded Capuchin friar in a brown habit with long pointed hood, peaceful serene radiant expression, eyes softly lifted, faint warm gold light on the face, thick irregular black ink outlines, heavy black shadows engulfing half the face, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 1:1 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

**`saint_pio_portrait`** — Retrato · essencial

> **Gerar:** proporção 3:4 · Midjourney: `--ar 3:4` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **768 × 1024 px**, 72 ppi, sRGB · do peito para cima

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, bust portrait from the chest up, three-quarter view facing right, framed from the chest up, eyes in the upper third of the frame, Saint Padre Pio of Pietrelcina, a grey-bearded Capuchin friar in a brown habit with long pointed hood, determined resolute expression, strong readable silhouette, thick irregular black ink outlines, heavy black shadows engulfing half the face, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 3:4 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

**`saint_pio_body_attack`** — Pose de ataque · piloto

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Padre Pio of Pietrelcina as a grey-bearded 20th-century Capuchin friar, brown Capuchin habit with long pointed hood, white rope belt, fingerless brown half-gloves covering the stigmata, a rosary wrapped around one hand, thrusting forward the hand wrapped in the rosary in an exorcism, the other gloved hand raised in blessing against evil, fierce determined expression, dynamic action pose, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

**`saint_pio_body_hit`** — Pose de golpe recebido · piloto

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Padre Pio of Pietrelcina as a grey-bearded 20th-century Capuchin friar, brown Capuchin habit with long pointed hood, white rope belt, fingerless brown half-gloves covering the stigmata, a rosary wrapped around one hand, recoiling backward from a heavy blow, body twisted, one arm thrown up, still holding the rosary, grimacing in pain, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

**`saint_pio_body_fall`** — Pose de queda · piloto

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Padre Pio of Pietrelcina as a grey-bearded 20th-century Capuchin friar, brown Capuchin habit with long pointed hood, white rope belt, fingerless brown half-gloves covering the stigmata, a rosary wrapped around one hand, collapsed onto both knees and slumped forward, head bowed, the rosary fallen at his side on the ground, utterly exhausted but not dead, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, blood pool, corpse, gore
```

**`saint_pio_rig_base`** — Pose neutra para o rig · animação no Godot

> **Gerar:** proporção 2:3 na **maior resolução possível** · Midjourney: `--ar 2:3` + Upscale 2× (≥ 1792 × 2688 px) · GPT Image: 1024 × 1536 px e ampliar 2×  
> **Matriz:** PNG RGBA **2048 × 3072 px**, 72 ppi, sRGB, guardada em `art_source/` (figura ≈ 2400 px)  
> **Peças finais:** recortadas e exportadas a **50%**, na escala do `body_idle` (figura ≈ 1200 px), em `assets/characters/saints/<id>/rig/`

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body strict side profile view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Padre Pio of Pietrelcina as a grey-bearded 20th-century Capuchin friar, brown Capuchin habit with long pointed hood, white rope belt, fingerless brown half-gloves covering the stigmata, a rosary wrapped around one hand, neutral rigging pose for 2D skeletal animation: standing straight, arms held slightly away from the torso, legs slightly apart, no limb overlapping the torso or another limb, the rosary held clearly apart from the body, loose garments hanging straight without wrapping around the limbs, clearly readable joints at the neck, shoulders, elbows, wrists, hips, knees and ankles, calm neutral expression, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`saint_pio_rig_parts`** — Folha de peças separadas · animação no Godot

> **Gerar:** proporção 1:1 na **maior resolução possível** · Midjourney: `--ar 1:1` + Upscale 2× (≥ 2048 × 2048 px)  
> **Matriz:** PNG RGBA **2048 × 2048 px**, 72 ppi, sRGB, em `art_source/`  
> **Peças finais:** uma PNG RGBA por peça, mesma escala do `body_idle` (figura ≈ 1200 px), em `assets/characters/saints/<id>/rig/`

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, character parts sheet for 2D cutout skeletal animation, Saint Padre Pio of Pietrelcina as a grey-bearded 20th-century Capuchin friar, brown Capuchin habit with long pointed hood, white rope belt, fingerless brown half-gloves covering the stigmata, a rosary wrapped around one hand, the same character disassembled into separate pieces laid out in a tidy grid with wide empty space between every piece: head with neck facing right, torso with hips, upper arm, forearm and hand for the near and far arm, thigh and lower leg with foot for the near and far leg, loose garments such as cloak, veil and lower robe as separate pieces, the rosary as separate pieces, every limb piece with extra rounded overlap at the joint ends, no piece touching another, all pieces at the same scale, side view facing right, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 1:1 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, assembled character, overlapping pieces, labels, text, numbers, grid lines, arrows
```

## Santa Rita de Cássia (`saint_rita`)

**`saint_rita_body_idle`** — Corpo inteiro, pose padrão · essencial

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Rita of Cascia as a 15th-century Augustinian nun, black habit and black veil over white wimple, a thorn wound on her forehead, a crucifix, red roses, the crucifix held forward in one hand, red roses in the other, determined resolute expression, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

**`saint_rita_face_dark_night`** — Rosto em Noite Escura · essencial

> **Gerar:** proporção 1:1 · **1024 × 1024 px** (Midjourney: `--ar 1:1` + Upscale)  
> **Arquivo final:** PNG RGBA, **1024 × 1024 px**, 72 ppi, sRGB · o Claude Code reduz ao tamanho da cabeça do `body_idle` (≈ 170 px)

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, close-up head and shoulders portrait, side three-quarter view facing right, same head angle as the full body reference, head and shoulders filling about 70 percent of the frame, head centered, Saint Rita of Cascia, an Augustinian nun in black habit and black veil over white wimple, a thorn wound on her forehead, anguished exhausted expression, eyes downcast, brow furrowed, deep shadows under the eyes, face drained of color, thick irregular black ink outlines, heavy black shadows engulfing half the face, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 1:1 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

**`saint_rita_face_consolation`** — Rosto em Consolação · essencial

> **Gerar:** proporção 1:1 · **1024 × 1024 px** (Midjourney: `--ar 1:1` + Upscale)  
> **Arquivo final:** PNG RGBA, **1024 × 1024 px**, 72 ppi, sRGB · o Claude Code reduz ao tamanho da cabeça do `body_idle` (≈ 170 px)

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, close-up head and shoulders portrait, side three-quarter view facing right, same head angle as the full body reference, head and shoulders filling about 70 percent of the frame, head centered, Saint Rita of Cascia, an Augustinian nun in black habit and black veil over white wimple, a thorn wound on her forehead, peaceful serene radiant expression, eyes softly lifted, faint warm gold light on the face, thick irregular black ink outlines, heavy black shadows engulfing half the face, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 1:1 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

**`saint_rita_portrait`** — Retrato · essencial

> **Gerar:** proporção 3:4 · Midjourney: `--ar 3:4` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **768 × 1024 px**, 72 ppi, sRGB · do peito para cima

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, bust portrait from the chest up, three-quarter view facing right, framed from the chest up, eyes in the upper third of the frame, Saint Rita of Cascia, an Augustinian nun in black habit and black veil over white wimple, a thorn wound on her forehead, determined resolute expression, strong readable silhouette, thick irregular black ink outlines, heavy black shadows engulfing half the face, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 3:4 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

**`saint_rita_body_attack`** — Pose de ataque · piloto

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Rita of Cascia as a 15th-century Augustinian nun, black habit and black veil over white wimple, a thorn wound on her forehead, a crucifix, red roses, holding the crucifix forward at arm's length with commanding force, red rose petals scattering from the other hand, fierce determined expression, dynamic action pose, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

**`saint_rita_body_hit`** — Pose de golpe recebido · piloto

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Rita of Cascia as a 15th-century Augustinian nun, black habit and black veil over white wimple, a thorn wound on her forehead, a crucifix, red roses, recoiling backward from a heavy blow, body twisted, one arm thrown up, still holding the crucifix, grimacing in pain, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

**`saint_rita_body_fall`** — Pose de queda · piloto

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Rita of Cascia as a 15th-century Augustinian nun, black habit and black veil over white wimple, a thorn wound on her forehead, a crucifix, red roses, collapsed onto both knees and slumped forward, head bowed, the crucifix and the red roses fallen at her side on the ground, utterly exhausted but not dead, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, blood pool, corpse, gore
```

**`saint_rita_rig_base`** — Pose neutra para o rig · animação no Godot

> **Gerar:** proporção 2:3 na **maior resolução possível** · Midjourney: `--ar 2:3` + Upscale 2× (≥ 1792 × 2688 px) · GPT Image: 1024 × 1536 px e ampliar 2×  
> **Matriz:** PNG RGBA **2048 × 3072 px**, 72 ppi, sRGB, guardada em `art_source/` (figura ≈ 2400 px)  
> **Peças finais:** recortadas e exportadas a **50%**, na escala do `body_idle` (figura ≈ 1200 px), em `assets/characters/saints/<id>/rig/`

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body strict side profile view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Rita of Cascia as a 15th-century Augustinian nun, black habit and black veil over white wimple, a thorn wound on her forehead, a crucifix, red roses, neutral rigging pose for 2D skeletal animation: standing straight, arms held slightly away from the torso, legs slightly apart, no limb overlapping the torso or another limb, the crucifix and the red roses held clearly apart from the body, loose garments hanging straight without wrapping around the limbs, clearly readable joints at the neck, shoulders, elbows, wrists, hips, knees and ankles, calm neutral expression, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`saint_rita_rig_parts`** — Folha de peças separadas · animação no Godot

> **Gerar:** proporção 1:1 na **maior resolução possível** · Midjourney: `--ar 1:1` + Upscale 2× (≥ 2048 × 2048 px)  
> **Matriz:** PNG RGBA **2048 × 2048 px**, 72 ppi, sRGB, em `art_source/`  
> **Peças finais:** uma PNG RGBA por peça, mesma escala do `body_idle` (figura ≈ 1200 px), em `assets/characters/saints/<id>/rig/`

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, character parts sheet for 2D cutout skeletal animation, Saint Rita of Cascia as a 15th-century Augustinian nun, black habit and black veil over white wimple, a thorn wound on her forehead, a crucifix, red roses, the same character disassembled into separate pieces laid out in a tidy grid with wide empty space between every piece: head with neck facing right, torso with hips, upper arm, forearm and hand for the near and far arm, thigh and lower leg with foot for the near and far leg, loose garments such as cloak, veil and lower robe as separate pieces, the crucifix and the red roses as separate pieces, every limb piece with extra rounded overlap at the joint ends, no piece touching another, all pieces at the same scale, side view facing right, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 1:1 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, assembled character, overlapping pieces, labels, text, numbers, grid lines, arrows
```

## Santo Antônio de Pádua (`saint_anthony_padua`)

**`saint_anthony_padua_body_idle`** — Corpo inteiro, pose padrão · essencial

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Anthony of Padua as a young 13th-century Franciscan friar with tonsure, beardless, brown habit with a rope belt with three knots, a white lily, an open book, the lily in one hand, the open book in the other, preaching gesture, determined resolute expression, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, infant, child, baby
```

**`saint_anthony_padua_face_dark_night`** — Rosto em Noite Escura · essencial

> **Gerar:** proporção 1:1 · **1024 × 1024 px** (Midjourney: `--ar 1:1` + Upscale)  
> **Arquivo final:** PNG RGBA, **1024 × 1024 px**, 72 ppi, sRGB · o Claude Code reduz ao tamanho da cabeça do `body_idle` (≈ 170 px)

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, close-up head and shoulders portrait, side three-quarter view facing right, same head angle as the full body reference, head and shoulders filling about 70 percent of the frame, head centered, Saint Anthony of Padua, a young beardless Franciscan friar with tonsure, brown habit with a knotted rope belt, anguished exhausted expression, eyes downcast, brow furrowed, deep shadows under the eyes, face drained of color, thick irregular black ink outlines, heavy black shadows engulfing half the face, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 1:1 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, infant, child, baby
```

**`saint_anthony_padua_face_consolation`** — Rosto em Consolação · essencial

> **Gerar:** proporção 1:1 · **1024 × 1024 px** (Midjourney: `--ar 1:1` + Upscale)  
> **Arquivo final:** PNG RGBA, **1024 × 1024 px**, 72 ppi, sRGB · o Claude Code reduz ao tamanho da cabeça do `body_idle` (≈ 170 px)

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, close-up head and shoulders portrait, side three-quarter view facing right, same head angle as the full body reference, head and shoulders filling about 70 percent of the frame, head centered, Saint Anthony of Padua, a young beardless Franciscan friar with tonsure, brown habit with a knotted rope belt, peaceful serene radiant expression, eyes softly lifted, faint warm gold light on the face, thick irregular black ink outlines, heavy black shadows engulfing half the face, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 1:1 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, infant, child, baby
```

**`saint_anthony_padua_portrait`** — Retrato · essencial

> **Gerar:** proporção 3:4 · Midjourney: `--ar 3:4` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **768 × 1024 px**, 72 ppi, sRGB · do peito para cima

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, bust portrait from the chest up, three-quarter view facing right, framed from the chest up, eyes in the upper third of the frame, Saint Anthony of Padua, a young beardless Franciscan friar with tonsure, brown habit with a knotted rope belt, determined resolute expression, strong readable silhouette, thick irregular black ink outlines, heavy black shadows engulfing half the face, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 3:4 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, infant, child, baby
```

**`saint_anthony_padua_body_attack`** — Pose de ataque · piloto

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Anthony of Padua as a young 13th-century Franciscan friar with tonsure, beardless, brown habit with a rope belt with three knots, a white lily, an open book, preaching forcefully, the open book raised high, the white lily thrust forward like a blade, fierce determined expression, dynamic action pose, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, infant, child, baby
```

**`saint_anthony_padua_body_hit`** — Pose de golpe recebido · piloto

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Anthony of Padua as a young 13th-century Franciscan friar with tonsure, beardless, brown habit with a rope belt with three knots, a white lily, an open book, recoiling backward from a heavy blow, body twisted, one arm thrown up, still holding the lily and the book, grimacing in pain, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, infant, child, baby
```

**`saint_anthony_padua_body_fall`** — Pose de queda · piloto

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Anthony of Padua as a young 13th-century Franciscan friar with tonsure, beardless, brown habit with a rope belt with three knots, a white lily, an open book, collapsed onto both knees and slumped forward, head bowed, the white lily and the open book fallen at his side on the ground, utterly exhausted but not dead, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, infant, child, baby, blood pool, corpse, gore
```

**`saint_anthony_padua_rig_base`** — Pose neutra para o rig · animação no Godot

> **Gerar:** proporção 2:3 na **maior resolução possível** · Midjourney: `--ar 2:3` + Upscale 2× (≥ 1792 × 2688 px) · GPT Image: 1024 × 1536 px e ampliar 2×  
> **Matriz:** PNG RGBA **2048 × 3072 px**, 72 ppi, sRGB, guardada em `art_source/` (figura ≈ 2400 px)  
> **Peças finais:** recortadas e exportadas a **50%**, na escala do `body_idle` (figura ≈ 1200 px), em `assets/characters/saints/<id>/rig/`

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body strict side profile view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Anthony of Padua as a young 13th-century Franciscan friar with tonsure, beardless, brown habit with a rope belt with three knots, a white lily, an open book, neutral rigging pose for 2D skeletal animation: standing straight, arms held slightly away from the torso, legs slightly apart, no limb overlapping the torso or another limb, the white lily and the open book held clearly apart from the body, loose garments hanging straight without wrapping around the limbs, clearly readable joints at the neck, shoulders, elbows, wrists, hips, knees and ankles, calm neutral expression, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, infant, child, baby, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`saint_anthony_padua_rig_parts`** — Folha de peças separadas · animação no Godot

> **Gerar:** proporção 1:1 na **maior resolução possível** · Midjourney: `--ar 1:1` + Upscale 2× (≥ 2048 × 2048 px)  
> **Matriz:** PNG RGBA **2048 × 2048 px**, 72 ppi, sRGB, em `art_source/`  
> **Peças finais:** uma PNG RGBA por peça, mesma escala do `body_idle` (figura ≈ 1200 px), em `assets/characters/saints/<id>/rig/`

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, character parts sheet for 2D cutout skeletal animation, Saint Anthony of Padua as a young 13th-century Franciscan friar with tonsure, beardless, brown habit with a rope belt with three knots, a white lily, an open book, the same character disassembled into separate pieces laid out in a tidy grid with wide empty space between every piece: head with neck facing right, torso with hips, upper arm, forearm and hand for the near and far arm, thigh and lower leg with foot for the near and far leg, loose garments such as cloak, veil and lower robe as separate pieces, the white lily and the open book as separate pieces, every limb piece with extra rounded overlap at the joint ends, no piece touching another, all pieces at the same scale, side view facing right, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 1:1 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, infant, child, baby, assembled character, overlapping pieces, labels, text, numbers, grid lines, arrows
```

## São Sebastião (`saint_sebastian`)

**`saint_sebastian_body_idle`** — Corpo inteiro, pose padrão · essencial

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Sebastian as a young 3rd-century Roman Praetorian guard, Roman segmented armor over a red tunic, Roman helmet, large rectangular scutum shield, arrows embedded in his shield and armor, broken arrow shafts, bracing behind the shield in a defensive stance, determined resolute expression, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, naked, nude, shirtless, medieval knight
```

**`saint_sebastian_face_dark_night`** — Rosto em Noite Escura · essencial

> **Gerar:** proporção 1:1 · **1024 × 1024 px** (Midjourney: `--ar 1:1` + Upscale)  
> **Arquivo final:** PNG RGBA, **1024 × 1024 px**, 72 ppi, sRGB · o Claude Code reduz ao tamanho da cabeça do `body_idle` (≈ 170 px)

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, close-up head and shoulders portrait, side three-quarter view facing right, same head angle as the full body reference, head and shoulders filling about 70 percent of the frame, head centered, Saint Sebastian, a young Roman Praetorian guard in a Roman helmet and segmented armor over a red tunic, broken arrow shafts in his armor, anguished exhausted expression, eyes downcast, brow furrowed, deep shadows under the eyes, face drained of color, thick irregular black ink outlines, heavy black shadows engulfing half the face, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 1:1 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, naked, nude, shirtless, medieval knight
```

**`saint_sebastian_face_consolation`** — Rosto em Consolação · essencial

> **Gerar:** proporção 1:1 · **1024 × 1024 px** (Midjourney: `--ar 1:1` + Upscale)  
> **Arquivo final:** PNG RGBA, **1024 × 1024 px**, 72 ppi, sRGB · o Claude Code reduz ao tamanho da cabeça do `body_idle` (≈ 170 px)

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, close-up head and shoulders portrait, side three-quarter view facing right, same head angle as the full body reference, head and shoulders filling about 70 percent of the frame, head centered, Saint Sebastian, a young Roman Praetorian guard in a Roman helmet and segmented armor over a red tunic, broken arrow shafts in his armor, peaceful serene radiant expression, eyes softly lifted, faint warm gold light on the face, thick irregular black ink outlines, heavy black shadows engulfing half the face, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 1:1 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, naked, nude, shirtless, medieval knight
```

**`saint_sebastian_portrait`** — Retrato · essencial

> **Gerar:** proporção 3:4 · Midjourney: `--ar 3:4` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **768 × 1024 px**, 72 ppi, sRGB · do peito para cima

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, bust portrait from the chest up, three-quarter view facing right, framed from the chest up, eyes in the upper third of the frame, Saint Sebastian, a young Roman Praetorian guard in a Roman helmet and segmented armor over a red tunic, broken arrow shafts in his armor, determined resolute expression, strong readable silhouette, thick irregular black ink outlines, heavy black shadows engulfing half the face, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 3:4 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, naked, nude, shirtless, medieval knight
```

**`saint_sebastian_body_attack`** — Pose de ataque · piloto

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Sebastian as a young 3rd-century Roman Praetorian guard, Roman segmented armor over a red tunic, Roman helmet, large rectangular scutum shield, arrows embedded in his shield and armor, broken arrow shafts, stabbing forward with a short Roman gladius from behind the scutum shield, fierce determined expression, dynamic action pose, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, naked, nude, shirtless, medieval knight
```

**`saint_sebastian_body_hit`** — Pose de golpe recebido · piloto

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Sebastian as a young 3rd-century Roman Praetorian guard, Roman segmented armor over a red tunic, Roman helmet, large rectangular scutum shield, arrows embedded in his shield and armor, broken arrow shafts, recoiling backward from a heavy blow, body twisted, one arm thrown up, still holding the scutum shield, grimacing in pain, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, naked, nude, shirtless, medieval knight
```

**`saint_sebastian_body_fall`** — Pose de queda · piloto

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Sebastian as a young 3rd-century Roman Praetorian guard, Roman segmented armor over a red tunic, Roman helmet, large rectangular scutum shield, arrows embedded in his shield and armor, broken arrow shafts, collapsed onto both knees and slumped forward, head bowed, the scutum shield and the gladius fallen at his side on the ground, utterly exhausted but not dead, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, naked, nude, shirtless, medieval knight, blood pool, corpse, gore
```

**`saint_sebastian_rig_base`** — Pose neutra para o rig · animação no Godot

> **Gerar:** proporção 2:3 na **maior resolução possível** · Midjourney: `--ar 2:3` + Upscale 2× (≥ 1792 × 2688 px) · GPT Image: 1024 × 1536 px e ampliar 2×  
> **Matriz:** PNG RGBA **2048 × 3072 px**, 72 ppi, sRGB, guardada em `art_source/` (figura ≈ 2400 px)  
> **Peças finais:** recortadas e exportadas a **50%**, na escala do `body_idle` (figura ≈ 1200 px), em `assets/characters/saints/<id>/rig/`

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body strict side profile view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Sebastian as a young 3rd-century Roman Praetorian guard, Roman segmented armor over a red tunic, Roman helmet, large rectangular scutum shield, arrows embedded in his shield and armor, broken arrow shafts, neutral rigging pose for 2D skeletal animation: standing straight, arms held slightly away from the torso, legs slightly apart, no limb overlapping the torso or another limb, the scutum shield and the gladius held clearly apart from the body, loose garments hanging straight without wrapping around the limbs, clearly readable joints at the neck, shoulders, elbows, wrists, hips, knees and ankles, calm neutral expression, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, naked, nude, shirtless, medieval knight, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`saint_sebastian_rig_parts`** — Folha de peças separadas · animação no Godot

> **Gerar:** proporção 1:1 na **maior resolução possível** · Midjourney: `--ar 1:1` + Upscale 2× (≥ 2048 × 2048 px)  
> **Matriz:** PNG RGBA **2048 × 2048 px**, 72 ppi, sRGB, em `art_source/`  
> **Peças finais:** uma PNG RGBA por peça, mesma escala do `body_idle` (figura ≈ 1200 px), em `assets/characters/saints/<id>/rig/`

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, character parts sheet for 2D cutout skeletal animation, Saint Sebastian as a young 3rd-century Roman Praetorian guard, Roman segmented armor over a red tunic, Roman helmet, large rectangular scutum shield, arrows embedded in his shield and armor, broken arrow shafts, the same character disassembled into separate pieces laid out in a tidy grid with wide empty space between every piece: head with neck facing right, torso with hips, upper arm, forearm and hand for the near and far arm, thigh and lower leg with foot for the near and far leg, loose garments such as cloak, veil and lower robe as separate pieces, the scutum shield and the gladius as separate pieces, every limb piece with extra rounded overlap at the joint ends, no piece touching another, all pieces at the same scale, side view facing right, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 1:1 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, naked, nude, shirtless, medieval knight, assembled character, overlapping pieces, labels, text, numbers, grid lines, arrows
```

## Santa Gertrudes (`saint_gertrude`)

**`saint_gertrude_body_idle`** — Corpo inteiro, pose padrão · essencial

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Gertrude the Great as a 13th-century mystic nun of Helfta, black habit and black veil over a white wimple, a small flaming heart, an open book, the flaming heart held against her chest, the open book in the other hand, determined resolute expression, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, crozier, crown, letters
```

**`saint_gertrude_face_dark_night`** — Rosto em Noite Escura · essencial

> **Gerar:** proporção 1:1 · **1024 × 1024 px** (Midjourney: `--ar 1:1` + Upscale)  
> **Arquivo final:** PNG RGBA, **1024 × 1024 px**, 72 ppi, sRGB · o Claude Code reduz ao tamanho da cabeça do `body_idle` (≈ 170 px)

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, close-up head and shoulders portrait, side three-quarter view facing right, same head angle as the full body reference, head and shoulders filling about 70 percent of the frame, head centered, Saint Gertrude the Great, a mystic nun of Helfta in black habit and black veil over a white wimple, anguished exhausted expression, eyes downcast, brow furrowed, deep shadows under the eyes, face drained of color, thick irregular black ink outlines, heavy black shadows engulfing half the face, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 1:1 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, crozier, crown, letters
```

**`saint_gertrude_face_consolation`** — Rosto em Consolação · essencial

> **Gerar:** proporção 1:1 · **1024 × 1024 px** (Midjourney: `--ar 1:1` + Upscale)  
> **Arquivo final:** PNG RGBA, **1024 × 1024 px**, 72 ppi, sRGB · o Claude Code reduz ao tamanho da cabeça do `body_idle` (≈ 170 px)

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, close-up head and shoulders portrait, side three-quarter view facing right, same head angle as the full body reference, head and shoulders filling about 70 percent of the frame, head centered, Saint Gertrude the Great, a mystic nun of Helfta in black habit and black veil over a white wimple, peaceful serene radiant expression, eyes softly lifted, faint warm gold light on the face, thick irregular black ink outlines, heavy black shadows engulfing half the face, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 1:1 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, crozier, crown, letters
```

**`saint_gertrude_portrait`** — Retrato · essencial

> **Gerar:** proporção 3:4 · Midjourney: `--ar 3:4` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **768 × 1024 px**, 72 ppi, sRGB · do peito para cima

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, bust portrait from the chest up, three-quarter view facing right, framed from the chest up, eyes in the upper third of the frame, Saint Gertrude the Great, a mystic nun of Helfta in black habit and black veil over a white wimple, determined resolute expression, strong readable silhouette, thick irregular black ink outlines, heavy black shadows engulfing half the face, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 3:4 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, crozier, crown, letters
```

**`saint_gertrude_body_attack`** — Pose de ataque · piloto

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Gertrude the Great as a 13th-century mystic nun of Helfta, black habit and black veil over a white wimple, a small flaming heart, an open book, holding the small flaming heart forward with an outstretched hand, the open book raised in the other, leaning into a fervent prayer, fierce determined expression, dynamic action pose, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, crozier, crown, letters
```

**`saint_gertrude_body_hit`** — Pose de golpe recebido · piloto

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Gertrude the Great as a 13th-century mystic nun of Helfta, black habit and black veil over a white wimple, a small flaming heart, an open book, recoiling backward from a heavy blow, body twisted, one arm thrown up, still holding the open book, grimacing in pain, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, crozier, crown, letters
```

**`saint_gertrude_body_fall`** — Pose de queda · piloto

> **Gerar:** proporção 2:3 · GPT Image: 1024 × 1536 px direto · Midjourney: `--ar 2:3` + Upscale 2× (≈ 1792 × 2688 px)  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura · pés a **96 px** da borda inferior · centralizado

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Gertrude the Great as a 13th-century mystic nun of Helfta, black habit and black veil over a white wimple, a small flaming heart, an open book, collapsed onto both knees and slumped forward, head bowed, the open book and the flaming heart fallen at her side on the ground, utterly exhausted but not dead, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, crozier, crown, letters, blood pool, corpse, gore
```

**`saint_gertrude_rig_base`** — Pose neutra para o rig · animação no Godot

> **Gerar:** proporção 2:3 na **maior resolução possível** · Midjourney: `--ar 2:3` + Upscale 2× (≥ 1792 × 2688 px) · GPT Image: 1024 × 1536 px e ampliar 2×  
> **Matriz:** PNG RGBA **2048 × 3072 px**, 72 ppi, sRGB, guardada em `art_source/` (figura ≈ 2400 px)  
> **Peças finais:** recortadas e exportadas a **50%**, na escala do `body_idle` (figura ≈ 1200 px), em `assets/characters/saints/<id>/rig/`

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body strict side profile view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Gertrude the Great as a 13th-century mystic nun of Helfta, black habit and black veil over a white wimple, a small flaming heart, an open book, neutral rigging pose for 2D skeletal animation: standing straight, arms held slightly away from the torso, legs slightly apart, no limb overlapping the torso or another limb, the open book and the flaming heart held clearly apart from the body, loose garments hanging straight without wrapping around the limbs, clearly readable joints at the neck, shoulders, elbows, wrists, hips, knees and ankles, calm neutral expression, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, crozier, crown, letters, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`saint_gertrude_rig_parts`** — Folha de peças separadas · animação no Godot

> **Gerar:** proporção 1:1 na **maior resolução possível** · Midjourney: `--ar 1:1` + Upscale 2× (≥ 2048 × 2048 px)  
> **Matriz:** PNG RGBA **2048 × 2048 px**, 72 ppi, sRGB, em `art_source/`  
> **Peças finais:** uma PNG RGBA por peça, mesma escala do `body_idle` (figura ≈ 1200 px), em `assets/characters/saints/<id>/rig/`

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, character parts sheet for 2D cutout skeletal animation, Saint Gertrude the Great as a 13th-century mystic nun of Helfta, black habit and black veil over a white wimple, a small flaming heart, an open book, the same character disassembled into separate pieces laid out in a tidy grid with wide empty space between every piece: head with neck facing right, torso with hips, upper arm, forearm and hand for the near and far arm, thigh and lower leg with foot for the near and far leg, loose garments such as cloak, veil and lower robe as separate pieces, the open book and the flaming heart as separate pieces, every limb piece with extra rounded overlap at the joint ends, no piece touching another, all pieces at the same scale, side view facing right, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 1:1 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, crozier, crown, letters, assembled character, overlapping pieces, labels, text, numbers, grid lines, arrows
```

