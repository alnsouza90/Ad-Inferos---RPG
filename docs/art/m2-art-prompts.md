# Prompts do M2 · lista para gerar

Gerado em 05/11/2026 a partir do pedido de arte (`docs/art/m2-art-request.md`) e das folhas de produção. Os prompts são cópias exatas das folhas; se houver diferença, valem as folhas. Na ordem de prioridade: gere de cima para baixo e marque a caixa quando aprovar.

**Regras de sempre:** fundo cinza-claro liso (menos nos `_back` e telas inteiras); sem auréola, texto, moldura ou vinheta; mande pelo chat com o nome em negrito (ex.: `env_circle_02_t1_mid`). Para o esqueleto 2D basta a pose neutra (`rig_base`) de cada personagem: eu recorto as peças.

---

## Prioridade 1 · Caminhada e piloto (agora)

Primeiro o cenário do trecho 1 (gere o `_ref`, aprove, e use-o como `--sref` nas outras camadas e nos objetos).

- [ ] **`env_circle_02_t1_ref`** — Referência completa

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** · só referência (guardar em `art_source/`)

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, full scene, howling violet-black darkness and storm clouds, a rocky cliff ledge with a jagged stone seat of judgment carved into the rock wall, jagged rocks and torn cloth caught on thorns at the edges, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

- [ ] **`env_circle_02_t1_back`** — Camada de fundo

> **Gerar:** `--ar 21:9` + Upscale 2× (≈ 3360 × 1440 px)  
> **Arquivo final:** PNG RGB opaco, **2560 × 1080 px**, 72 ppi, sRGB

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, far background layer only for parallax, howling violet-black darkness and storm clouds, distant, low contrast, atmospheric haze, no foreground objects and no near ground, fills the whole frame edge to edge, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, foreground, frame
```

- [ ] **`env_circle_02_t1_mid`** — Camada do meio (chão de caminhada)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px**, 72 ppi, sRGB · superfície do chão em **y ≈ 900 px** · bordas laterais emendáveis  
> Remover o cinza acima das estruturas

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, middle layer only for parallax, a rocky cliff ledge with a jagged stone seat of judgment carved into the rock wall, a continuous flat walkable ground strip along the bottom of the image with the ground surface at about 83 percent of the image height, structures standing on the ground, empty plain flat solid light grey background above and behind the structures instead of sky, seamless left and right edges for horizontal tiling, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture --ar 21:9 --no sky, clouds, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

- [ ] **`env_circle_02_t1_front`** — Camada da frente

> **Gerar:** `--ar 3:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **3240 × 1080 px**, 72 ppi, sRGB · centro livre entre x ≈ 600 e x ≈ 2640 px  
> Remover o cinza

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, foreground layer only for parallax, jagged rocks and torn cloth caught on thorns, dark near-black silhouettes only at the far left edge, the far right edge and along the very bottom edge, the whole center of the image completely empty, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture --ar 3:1 --no sky, ground in the center, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

- [ ] **`prop_c02_entry_door`** — Porta (desvio)

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px** · base a 96 px da borda de baixo · abertura com ≈ 1300 px de altura

```text
Darkest Dungeon style 2D side-view game prop, hand-painted gothic horror, hand-inked comic art, a narrow ancient doorway cut into a storm-battered rock wall, a heavy half-open wooden door with rusted iron bands rattling in the wind, torn cloth caught on the frame, darkness beyond the opening, standing on a short strip of flat stony ground, front view, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal --ar 2:3 --no characters, people, creatures, text, letters, UI, halo, vignette, cartoon, anime, glossy, 3D, photorealistic, white background
```

- [ ] **`prop_c02_entry_cave`** — Caverna (desvio)

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px** · base a 96 px da borda de baixo

```text
Darkest Dungeon style 2D side-view game prop, hand-painted gothic horror, hand-inked comic art, the jagged black mouth of a cave opening in a cliff face, wind howling into it, loose debris and thorny roots around the rim, deep darkness inside, standing on a short strip of flat stony ground, front view, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal --ar 2:3 --no characters, people, creatures, text, letters, UI, halo, vignette, cartoon, anime, glossy, 3D, photorealistic, white background
```

- [ ] **`prop_c02_entry_stair`** — Escada (desvio)

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px** · base a 96 px da borda de baixo

```text
Darkest Dungeon style 2D side-view game prop, hand-painted gothic horror, hand-inked comic art, a steep worn stone stairway carved into the rock, descending into a dark gap between two crooked rock pillars, crumbling steps swept by wind and dust, standing on a short strip of flat stony ground, front view, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal --ar 2:3 --no characters, people, creatures, text, letters, UI, halo, vignette, cartoon, anime, glossy, 3D, photorealistic, white background
```

- [ ] **`prop_c02_entry_straight`** — Seguir em frente (fim do corredor)

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px** · base a 96 px da borda de baixo

```text
Darkest Dungeon style 2D side-view game prop, hand-painted gothic horror, hand-inked comic art, a crude archway of two leaning wind-worn standing stones marking the path that continues forward into the storm, a tattered strip of grey cloth tied to one stone and flapping in the wind, standing on a short strip of flat stony ground, front view, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal --ar 2:3 --no characters, people, creatures, text, letters, UI, halo, vignette, cartoon, anime, glossy, 3D, photorealistic, white background
```

- [ ] **`prop_c02_tent`** — Tenda da Tentação ("O abrigo do vento")

> **Gerar:** `--ar 1:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **1536 × 1536 px** · base a 96 px da borda de baixo · a mesma tenda da ilustração do evento (usar a ilustração como referência de imagem)

```text
Darkest Dungeon style 2D side-view game prop, hand-painted gothic horror, hand-inked comic art, a single isolated pale cloth tent glowing with a soft warm inviting light from within, untouched and perfectly still while sand and wind whip around it, entrance flap slightly open showing only light, faint footprints in the sand leading to it, standing on a short strip of flat sandy ground, front view, uncanny calm, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey, stormy violet and a single warm amber glow, distressed print texture, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal --ar 1:1 --no characters, people, creatures, text, letters, UI, halo, vignette, cartoon, anime, glossy, 3D, photorealistic, white background
```

- [ ] **`prop_reliquary_closed`** — Relicário fechado (gere primeiro)

> **Gerar:** `--ar 1:1` + Upscale 2× · gere o fechado, aprove, e use-o como referência de imagem para o aberto (mesmo ângulo, mesma escala)  
> **Arquivo final:** PNG RGBA, **1024 × 1024 px** cada · base a 96 px da borda de baixo · os dois no mesmo enquadramento

```text
Darkest Dungeon style 2D side-view game prop, hand-painted gothic horror, hand-inked comic art, a small ornate medieval reliquary casket with a gabled lid and a simple cross on top, worn and dusty, lid tightly closed, resting on a fallen flat stone, three-quarter front view, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey with small touches of flat gold, distressed print texture, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal --ar 1:1 --no characters, people, creatures, text, letters, UI, halo, vignette, cartoon, anime, glossy, 3D, photorealistic, white background
```

- [ ] **`prop_reliquary_open`** — Relicário aberto (use o fechado aprovado como referência de imagem: mesmo ângulo e escala)

```text
Darkest Dungeon style 2D side-view game prop, hand-painted gothic horror, hand-inked comic art, a small ornate medieval reliquary casket with a gabled lid and a simple cross on top, worn and dusty, lid open, a soft pale gold light rising from inside, the contents hidden by the glow, resting on a fallen flat stone, three-quarter front view, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey with small touches of flat gold, distressed print texture, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal --ar 1:1 --no characters, people, creatures, text, letters, UI, halo, vignette, cartoon, anime, glossy, 3D, photorealistic, white background
```

- [ ] **`env_circle_02_souls_crowd`** — Multidão distante (camada animada entre `_back` e `_mid`)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px** · figuras pequenas (≈ 80–160 px de altura) · fundo removido  
> O motor anima com balanço, deriva e transparência; não é preciso quadro a quadro

```text
Dark gothic 2D side-view game background layer in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, souls in torn grey shrouds swept through the dark air by the hurricane like a great flock of starlings, endlessly tumbling, non-sexual, many small distant figures in the middle distance, readable silhouettes, all figures shrouded, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture --ar 21:9 --no nudity, sexual, children, gore close-up, ground, sky, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

- [ ] **`env_circle_02_souls_sheet`** — Folha de 3 almas para animação (perto da câmera)

> **Gerar:** `--ar 3:2` + Upscale 2×  
> **Arquivo final:** Matriz PNG RGBA **3072 × 2048 px** em `art_source/`; cada alma recortada em PNG RGBA com **≈ 600 px** de altura  
> Para animação simples por rig ou deformação no Godot; recortar membros se necessário

```text
Dark gothic 2D game character sheet in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, three tormented damned souls of the same kind wrapped in torn grey shrouds, side view facing left, pose 1: tumbling head over heels in the wind; pose 2: reaching out a hand against the wind; pose 3: two souls clinging to each other in sorrow, fully shrouded, non-sexual, the three figures separated by wide empty space, same scale, full figures inside the frame, anguished faces, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors, palette of black, bone, ash grey and stormy violet, isolated on a plain flat solid light grey background --ar 3:2 --no nudity, sexual, children, text, letters, UI, halo, cartoon, anime, glossy, 3D, photorealistic, white background
```

- [ ] **`fx_circle_02_ambient`** — Partículas do ambiente (folha de sprites)

> **Gerar:** `--ar 1:1` + Upscale 2×  
> **Arquivo final:** Matriz PNG RGBA **2048 × 2048 px**; cada sprite recortado em PNG RGBA de **64–256 px**  
> O motor espalha e anima as partículas

```text
2D game VFX sprite sheet in the style of Darkest Dungeon, hand-inked comic art, a grid of separate small particle sprites: wind-blown debris, long torn cloth strips, dust streaks, each sprite isolated with empty space around it, varied sizes, thick ink edges, palette of black, bone, ash grey and stormy violet, isolated on a plain flat solid light grey background --ar 1:1 --no text, letters, numbers, grid lines, characters, cartoon, glossy, 3D, photorealistic, white background
```

- [ ] **`fx_fog_strip`** — Faixa de névoa (uso geral, sobre o `_mid`)

> **Gerar:** `--ar 4:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 640 px**, bordas emendáveis  
> O motor tinge com a cor do círculo

```text
2D game VFX layer in the style of Darkest Dungeon, hand-inked comic art, a long low horizontal band of soft drifting fog with ink-like wisps, thicker at the bottom and fading upward, seamless left and right edges, neutral pale grey, isolated on a plain flat solid dark grey background --ar 4:1 --no text, objects, characters, cartoon, glossy, 3D, photorealistic
```

_São Jorge: a pose neutra que você já mandou serve para o piloto. Se eu precisar de outra, o prompt é o `saint_george_rig_base` (Prioridade 2)._

---

## Prioridade 2 · Círculo 2 completo

### Santos (pose neutra para o esqueleto)

- [ ] **`saint_george_rig_base`** — Pose neutra para o rig · animação no Godot

> **Gerar:** proporção 2:3 na **maior resolução possível** · Midjourney: `--ar 2:3` + Upscale 2× (≥ 1792 × 2688 px) · GPT Image: 1024 × 1536 px e ampliar 2×  
> **Matriz:** PNG RGBA **2048 × 3072 px**, 72 ppi, sRGB, guardada em `art_source/` (figura ≈ 2400 px)  
> **Peças finais:** recortadas e exportadas a **50%**, na escala do `body_idle` (figura ≈ 1200 px), em `assets/characters/saints/<id>/rig/`

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body strict side profile view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint George as a young Roman military officer of the late 3rd century, beardless with short curly hair as in Eastern icons, bronze muscle cuirass with pteruges, flowing red paludamentum cloak, Roman military boots, long spear and round shield bearing a cross, neutral rigging pose for 2D skeletal animation: standing straight, arms held slightly away from the torso, legs slightly apart, no limb overlapping the torso or another limb, the spear and the round shield held clearly apart from the body, loose garments hanging straight without wrapping around the limbs, clearly readable joints at the neck, shoulders, elbows, wrists, hips, knees and ankles, calm neutral expression, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, medieval knight, plate armor, great helm, tabard, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

- [ ] **`saint_benedict_rig_base`** — Pose neutra para o rig · animação no Godot

> **Gerar:** proporção 2:3 na **maior resolução possível** · Midjourney: `--ar 2:3` + Upscale 2× (≥ 1792 × 2688 px) · GPT Image: 1024 × 1536 px e ampliar 2×  
> **Matriz:** PNG RGBA **2048 × 3072 px**, 72 ppi, sRGB, guardada em `art_source/` (figura ≈ 2400 px)  
> **Peças finais:** recortadas e exportadas a **50%**, na escala do `body_idle` (figura ≈ 1200 px), em `assets/characters/saints/<id>/rig/`

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body strict side profile view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Benedict of Nursia as an elderly 6th-century abbot with a long white beard, black Benedictine habit with hood and scapular, abbot's crozier, book of the Rule at his belt, a raven on his shoulder, a chalice with a small serpent rising from it, neutral rigging pose for 2D skeletal animation: standing straight, arms held slightly away from the torso, legs slightly apart, no limb overlapping the torso or another limb, the crozier and the chalice held clearly apart from the body, loose garments hanging straight without wrapping around the limbs, clearly readable joints at the neck, shoulders, elbows, wrists, hips, knees and ankles, calm neutral expression, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

- [ ] **`saint_therese_rig_base`** — Pose neutra para o rig · animação no Godot

> **Gerar:** proporção 2:3 na **maior resolução possível** · Midjourney: `--ar 2:3` + Upscale 2× (≥ 1792 × 2688 px) · GPT Image: 1024 × 1536 px e ampliar 2×  
> **Matriz:** PNG RGBA **2048 × 3072 px**, 72 ppi, sRGB, guardada em `art_source/` (figura ≈ 2400 px)  
> **Peças finais:** recortadas e exportadas a **50%**, na escala do `body_idle` (figura ≈ 1200 px), em `assets/characters/saints/<id>/rig/`

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body strict side profile view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Therese of Lisieux as a young 19th-century Carmelite nun with a gentle round face, brown Carmelite habit and scapular, white mantle, black veil over white wimple, a crucifix wrapped in roses, neutral rigging pose for 2D skeletal animation: standing straight, arms held slightly away from the torso, legs slightly apart, no limb overlapping the torso or another limb, the crucifix wrapped in roses held clearly apart from the body, loose garments hanging straight without wrapping around the limbs, clearly readable joints at the neck, shoulders, elbows, wrists, hips, knees and ankles, calm neutral expression, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

### Inimigos da Família A (pose neutra; se puder, regere também o `body_idle` em PNG com fundo liso)

- [ ] **`enemy_mud_devil_body_idle`** — Pose padrão

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a hulking hunched mud demon with long dragging arms and a toothed mouth gaping in its chest, dripping black filth, long arms hanging to the ground, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

- [ ] **`enemy_mud_devil_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 2:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **2048 × 3072 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a hulking hunched mud demon with long dragging arms and a toothed mouth gaping in its chest, dripping black filth, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: limbs held slightly away from the body, no limb overlapping the torso or another limb, weapons and held objects clearly apart from the body, clearly readable joints, calm neutral stance, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

- [ ] **`enemy_infernal_scarab_body_idle`** — Pose padrão

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a man-sized infernal beetle standing on its hind legs, a thick cracked carapace, serrated mandibles, its carapace raised like a shield, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

- [ ] **`enemy_infernal_scarab_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 2:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **2048 × 3072 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a man-sized infernal beetle standing on its hind legs, a thick cracked carapace, serrated mandibles, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: carapace shell held slightly apart from the body, legs spread and not overlapping, no limb overlapping another, clearly readable joints, calm neutral stance, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

- [ ] **`enemy_gadfly_body_idle`** — Pose padrão

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a gaunt insect-man hybrid with membranous wings, a long proboscis and too many joints, hovering slightly with wings spread, proboscis aimed forward, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

- [ ] **`enemy_gadfly_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 2:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **2048 × 3072 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a gaunt insect-man hybrid with membranous wings, a long proboscis and too many joints, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: wings spread wide and clear of the body, all limbs held apart, none overlapping, clearly readable joints, calm neutral stance, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

- [ ] **`enemy_shade_of_desire_body_idle`** — Pose padrão

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a tall faceless silhouette with many elongated reaching hands, its hands drifting outward around it, translucent body of smoke and ink, pale inverted linework on black, glowing pale edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, nude
```

- [ ] **`enemy_shade_of_desire_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 2:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **2048 × 3072 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a tall faceless silhouette with many elongated reaching hands, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: each long arm held apart from the others and from the body, no arm crossing another, clearly readable joints, calm neutral stance, translucent body of smoke and ink, pale inverted linework on black, glowing pale edges, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, nude, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

- [ ] **`enemy_wandering_breath_body_idle`** — Pose padrão

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a swirling whirlwind with screaming faces trapped inside it, spinning in place, translucent body of smoke and ink, pale inverted linework on black, glowing pale edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

- [ ] **`enemy_wandering_breath_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 2:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **2048 × 3072 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a swirling whirlwind with screaming faces trapped inside it, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: a calm upright whirlwind with its spiral bands clearly separated, faces clearly visible, clearly readable joints, calm neutral stance, translucent body of smoke and ink, pale inverted linework on black, glowing pale edges, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

- [ ] **`enemy_swarm_mother_body_idle`** — Pose padrão

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a bloated swollen demon covered in flies, open hive-like sores across its body, a swarm circling it, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

- [ ] **`enemy_swarm_mother_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 2:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **2048 × 3072 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a bloated swollen demon covered in flies, open hive-like sores across its body, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: limbs held slightly away from the body, no limb overlapping the torso or another limb, weapons and held objects clearly apart from the body, clearly readable joints, calm neutral stance, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

- [ ] **`enemy_swarmling_body_idle`** — Pose padrão

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura pequena, com **≈ 600 px** de altura, base a **96 px** da borda inferior (mesma escala dos santos) · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, small creature, figure height about 40 percent of the image height, base resting about 6 percent above the bottom edge, a small infernal fly-larva demon the size of a dog, a pale bloated grub body with tiny clawed legs, a ring of teeth for a mouth, a few flies buzzing around it, crouched low on the ground, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

- [ ] **`enemy_swarmling_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 2:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **2048 × 3072 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body , small creature, figure height about 40 percent of the image height, base resting about 6 percent above the bottom edge, a small infernal fly-larva demon the size of a dog, a pale bloated grub body with tiny clawed legs, a ring of teeth for a mouth, a few flies buzzing around it, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: limbs held slightly away from the body, no limb overlapping the torso or another limb, weapons and held objects clearly apart from the body, clearly readable joints, calm neutral stance, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

### Elites e chefe (as 4 imagens: padrão, neutra, ataque, defesa)

- [ ] **`elite_minos_body_idle`** — Pose padrão

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Minos the infernal judge as a towering crowned demonic king seated on a stone seat of judgment, an enormous serpent tail, the tail coiled many times around his body, one clawed hand pointing in condemnation, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and stormy violet, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

- [ ] **`elite_minos_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 2:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **2732 × 4096 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Minos the infernal judge as a towering crowned demonic king seated on a stone seat of judgment, an enormous serpent tail, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: the tail uncoiled and laid out to the side without crossing itself, arms held apart, clearly readable joints, calm neutral stance, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and stormy violet, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

- [ ] **`elite_minos_body_attack`** — Ataque

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Minos the infernal judge as a towering crowned demonic king seated on a stone seat of judgment, an enormous serpent tail, lashing his serpent tail forward like a whip while roaring a sentence, dynamic aggressive action pose, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and stormy violet, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

- [ ] **`elite_minos_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Minos the infernal judge as a towering crowned demonic king seated on a stone seat of judgment, an enormous serpent tail, the serpent tail coiling up around him like armor, recoiling and bracing against an incoming blow, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and stormy violet, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

- [ ] **`elite_sin_vertigo_body_idle`** — Pose padrão

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Vertigo, allegorical personification of lust as a tall elegant alluring demon of dark smoke and flowing ink, a striking beautiful face with hypnotic pale empty eyes and a faint corrupted smile, long sheer veils of dark smoke wrapped around the body and covering it completely, a suggestive but fully draped silhouette, ribbons of dark incense smoke trailing from its shoulders and lower body, decadent and corrupting, graceful swaying posture, long fingers beckoning, translucent body of smoke and ink, pale inverted linework on black, glowing stormy violet edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and stormy violet, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, nude, nudity, nipples, explicit, erotic, lingerie
```

- [ ] **`elite_sin_vertigo_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 2:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **2732 × 4096 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Vertigo, allegorical personification of lust as a tall elegant alluring demon of dark smoke and flowing ink, a striking beautiful face with hypnotic pale empty eyes and a faint corrupted smile, long sheer veils of dark smoke wrapped around the body and covering it completely, a suggestive but fully draped silhouette, ribbons of dark incense smoke trailing from its shoulders and lower body, decadent and corrupting, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: arms clearly separated from the torso, veils hanging still and close to the body, clearly readable joints, calm neutral stance, translucent body of smoke and ink, pale inverted linework on black, glowing stormy violet edges, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and stormy violet, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, nude, nudity, nipples, explicit, erotic, lingerie, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

- [ ] **`elite_sin_vertigo_body_attack`** — Ataque

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Vertigo, allegorical personification of lust as a tall elegant alluring demon of dark smoke and flowing ink, a striking beautiful face with hypnotic pale empty eyes and a faint corrupted smile, long sheer veils of dark smoke wrapped around the body and covering it completely, a suggestive but fully draped silhouette, ribbons of dark incense smoke trailing from its shoulders and lower body, decadent and corrupting, gliding forward with arms outstretched, the smoke veils lashing out like whips in a dizzying spiral, dynamic aggressive action pose, translucent body of smoke and ink, pale inverted linework on black, glowing stormy violet edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and stormy violet, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, nude, nudity, nipples, explicit, erotic, lingerie
```

- [ ] **`elite_sin_vertigo_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Vertigo, allegorical personification of lust as a tall elegant alluring demon of dark smoke and flowing ink, a striking beautiful face with hypnotic pale empty eyes and a faint corrupted smile, long sheer veils of dark smoke wrapped around the body and covering it completely, a suggestive but fully draped silhouette, ribbons of dark incense smoke trailing from its shoulders and lower body, decadent and corrupting, wrapping its smoke veils tightly around itself and spinning away, recoiling and bracing against an incoming blow, translucent body of smoke and ink, pale inverted linework on black, glowing stormy violet edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and stormy violet, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, nude, nudity, nipples, explicit, erotic, lingerie
```

- [ ] **`boss_asmodeus_body_idle`** — Pose padrão

> **Gerar:** `--ar 4:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **2048 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1300 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Asmodeus the demon king with three heads, a bull head, a crowned human head and a ram head, rooster legs and clawed feet, a serpent tail, a lance with a blank banner, riding a winged infernal dragon, non-sexualized, the dragon's wings half spread, translucent body of smoke and ink, pale inverted linework on black, glowing stormy violet edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and stormy violet, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 4:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, nude, letters
```

- [ ] **`boss_asmodeus_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 4:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **4096 × 3072 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Asmodeus the demon king with three heads, a bull head, a crowned human head and a ram head, rooster legs and clawed feet, a serpent tail, a lance with a blank banner, riding a winged infernal dragon, non-sexualized, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: the dragon's wings and legs spread and clear, the rider sitting upright with the lance held apart, the three heads clearly separated, clearly readable joints, calm neutral stance, translucent body of smoke and ink, pale inverted linework on black, glowing stormy violet edges, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and stormy violet, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 4:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, nude, letters, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

- [ ] **`boss_asmodeus_body_attack`** — Ataque

> **Gerar:** `--ar 4:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **2048 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1300 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Asmodeus the demon king with three heads, a bull head, a crowned human head and a ram head, rooster legs and clawed feet, a serpent tail, a lance with a blank banner, riding a winged infernal dragon, non-sexualized, thrusting the banner lance forward as the dragon breathes a gust of violet smoke, dynamic aggressive action pose, translucent body of smoke and ink, pale inverted linework on black, glowing stormy violet edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and stormy violet, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 4:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, nude, letters
```

- [ ] **`boss_asmodeus_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 4:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **2048 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1300 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Asmodeus the demon king with three heads, a bull head, a crowned human head and a ram head, rooster legs and clawed feet, a serpent tail, a lance with a blank banner, riding a winged infernal dragon, non-sexualized, the dragon rearing and covering its rider with its wings, recoiling and bracing against an incoming blow, translucent body of smoke and ink, pale inverted linework on black, glowing stormy violet edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and stormy violet, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 4:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, nude, letters
```

### Cenários dos trechos 2 e 3 e da arena do chefe

- [ ] **`env_circle_02_t2_ref`** — Referência completa

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** · só referência (guardar em `art_source/`)

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, full scene, an endless spinning hurricane filling the whole sky, a broken rocky ledge swept by wind, scattered debris, whirling torn cloth and dust at the edges, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

- [ ] **`env_circle_02_t2_back`** — Camada de fundo

> **Gerar:** `--ar 21:9` + Upscale 2× (≈ 3360 × 1440 px)  
> **Arquivo final:** PNG RGB opaco, **2560 × 1080 px**, 72 ppi, sRGB

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, far background layer only for parallax, an endless spinning hurricane filling the whole sky, distant, low contrast, atmospheric haze, no foreground objects and no near ground, fills the whole frame edge to edge, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, foreground, frame
```

- [ ] **`env_circle_02_t2_mid`** — Camada do meio (chão de caminhada)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px**, 72 ppi, sRGB · superfície do chão em **y ≈ 900 px** · bordas laterais emendáveis  
> Remover o cinza acima das estruturas

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, middle layer only for parallax, a broken rocky ledge swept by wind, scattered debris, a continuous flat walkable ground strip along the bottom of the image with the ground surface at about 83 percent of the image height, structures standing on the ground, empty plain flat solid light grey background above and behind the structures instead of sky, seamless left and right edges for horizontal tiling, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture --ar 21:9 --no sky, clouds, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

- [ ] **`env_circle_02_t2_front`** — Camada da frente

> **Gerar:** `--ar 3:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **3240 × 1080 px**, 72 ppi, sRGB · centro livre entre x ≈ 600 e x ≈ 2640 px  
> Remover o cinza

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, foreground layer only for parallax, whirling torn cloth and dust, dark near-black silhouettes only at the far left edge, the far right edge and along the very bottom edge, the whole center of the image completely empty, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture --ar 3:1 --no sky, ground in the center, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

- [ ] **`env_circle_02_t3_ref`** — Referência completa

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** · só referência (guardar em `art_source/`)

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, full scene, a storm sky with distant broken spires, ruins of a gothic cloister, leaning arches, torn curtains frozen in motion, a fallen column and fluttering curtain fragments at the edges, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

- [ ] **`env_circle_02_t3_back`** — Camada de fundo

> **Gerar:** `--ar 21:9` + Upscale 2× (≈ 3360 × 1440 px)  
> **Arquivo final:** PNG RGB opaco, **2560 × 1080 px**, 72 ppi, sRGB

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, far background layer only for parallax, a storm sky with distant broken spires, distant, low contrast, atmospheric haze, no foreground objects and no near ground, fills the whole frame edge to edge, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, foreground, frame
```

- [ ] **`env_circle_02_t3_mid`** — Camada do meio (chão de caminhada)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px**, 72 ppi, sRGB · superfície do chão em **y ≈ 900 px** · bordas laterais emendáveis  
> Remover o cinza acima das estruturas

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, middle layer only for parallax, ruins of a gothic cloister, leaning arches, torn curtains frozen in motion, a continuous flat walkable ground strip along the bottom of the image with the ground surface at about 83 percent of the image height, structures standing on the ground, empty plain flat solid light grey background above and behind the structures instead of sky, seamless left and right edges for horizontal tiling, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture --ar 21:9 --no sky, clouds, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

- [ ] **`env_circle_02_t3_front`** — Camada da frente

> **Gerar:** `--ar 3:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **3240 × 1080 px**, 72 ppi, sRGB · centro livre entre x ≈ 600 e x ≈ 2640 px  
> Remover o cinza

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, foreground layer only for parallax, a fallen column and fluttering curtain fragments, dark near-black silhouettes only at the far left edge, the far right edge and along the very bottom edge, the whole center of the image completely empty, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture --ar 3:1 --no sky, ground in the center, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

- [ ] **`env_circle_02_boss_ref`** — Referência completa

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** · só referência (guardar em `art_source/`)

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, full scene, a ring of spinning walls of wind, a calm dark center above, a calm circular platform of black stone, the edge of the platform with wind-torn debris at the edges, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

- [ ] **`env_circle_02_boss_back`** — Camada de fundo

> **Gerar:** `--ar 21:9` + Upscale 2× (≈ 3360 × 1440 px)  
> **Arquivo final:** PNG RGB opaco, **2560 × 1080 px**, 72 ppi, sRGB

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, far background layer only for parallax, a ring of spinning walls of wind, a calm dark center above, distant, low contrast, atmospheric haze, no foreground objects and no near ground, fills the whole frame edge to edge, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, foreground, frame
```

- [ ] **`env_circle_02_boss_mid`** — Camada do meio (chão de caminhada)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px**, 72 ppi, sRGB · superfície do chão em **y ≈ 900 px** · bordas laterais emendáveis  
> Remover o cinza acima das estruturas

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, middle layer only for parallax, a calm circular platform of black stone, a continuous flat walkable ground strip along the bottom of the image with the ground surface at about 83 percent of the image height, structures standing on the ground, empty plain flat solid light grey background above and behind the structures instead of sky, seamless left and right edges for horizontal tiling, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture --ar 21:9 --no sky, clouds, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

- [ ] **`env_circle_02_boss_front`** — Camada da frente

> **Gerar:** `--ar 3:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **3240 × 1080 px**, 72 ppi, sRGB · centro livre entre x ≈ 600 e x ≈ 2640 px  
> Remover o cinza

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, foreground layer only for parallax, the edge of the platform with wind-torn debris, dark near-black silhouettes only at the far left edge, the far right edge and along the very bottom edge, the whole center of the image completely empty, isolated on a plain flat solid light grey background, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture --ar 3:1 --no sky, ground in the center, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

- [ ] **`env_circle_02_camp`** — Pouso deste círculo

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px** (pode ser dividido em camadas como os trechos)

```text
Darkest Dungeon style 2D side-view camp background, hand-painted gothic horror, hand-inked comic art, a small campfire behind a tall rock that breaks the wind, a few candles placed on a stone, bedrolls, the surrounding darkness of the circle pressing in, warm firelight in a small circle against cold shadow, empty flat floor strip in the foreground for characters, palette of black, bone, ash grey, warm amber and stormy violet, thick black ink outlines, heavy black shadows, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

- [ ] **`env_circle_02_vigil`** — Vigília (antes do chefe)

> **Gerar:** `--ar 21:9` + Upscale 2×  
> **Arquivo final:** PNG **2560 × 1080 px**

```text
Darkest Dungeon style 2D side-view background, hand-painted gothic horror, hand-inked comic art, a last quiet resting spot behind a tall rock that breaks the wind, a single tall candle on a flat rock, the entrance to the boss lair looming in the darkness ahead, tense silence, empty flat floor strip in the foreground for characters, palette of black, bone, ash grey, warm amber and stormy violet, thick black ink outlines, heavy black shadows, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

### Telas de passagem (milagre, Noite Escura, Consolação)

- [ ] **`splash_saint_george_miracle`** · Milagre

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, dramatic half-body portrait from the waist up, three-quarter view facing right, figure centered and filling about 90 percent of the image height, head in the upper third, Saint George as a young Roman military officer of the late 3rd century, beardless with short curly hair as in Eastern icons, bronze muscle cuirass with pteruges, red paludamentum cloak, round shield bearing a cross on his arm, raising his long spear high overhead in both hands, point angled down ready for the killing thrust, fierce determined expression, a faint flat gold glow along the spear point, the saint alone, no other characters, no enemies and no scenery, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, strong rim light from behind the figure, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no text, facing right --ar 4:5 --no halo, rays, light burst, glow background, background, scenery, enemies, monsters, demons, other people, text, letters, frame, vignette, parchment background, textured background, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, medieval knight, plate armor, great helm, tabard, horse, dragon
```

- [ ] **`splash_saint_george_dark_night`** · Noite Escura

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, dramatic half-body portrait from the waist up, three-quarter view facing right, figure centered and filling about 90 percent of the image height, head in the upper third, Saint George as a young Roman military officer of the late 3rd century, beardless with short curly hair as in Eastern icons, bronze muscle cuirass with pteruges, red paludamentum cloak, round shield bearing a cross on his arm, slumped forward gripping the spear, head bowed, anguished exhausted expression, eyes downcast, deep shadows under the eyes, colors drained, the saint alone, no other characters, no enemies and no scenery, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, strong rim light from behind the figure, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no text, facing right --ar 4:5 --no halo, rays, light burst, glow background, background, scenery, enemies, monsters, demons, other people, text, letters, frame, vignette, parchment background, textured background, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, medieval knight, plate armor, great helm, tabard, horse, dragon
```

- [ ] **`splash_saint_george_consolation`** · Consolação

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, dramatic half-body portrait from the waist up, three-quarter view facing right, figure centered and filling about 90 percent of the image height, head in the upper third, Saint George as a young Roman military officer of the late 3rd century, beardless with short curly hair as in Eastern icons, bronze muscle cuirass with pteruges, red paludamentum cloak, round shield bearing a cross on his arm, standing upright holding the spear, eyes softly lifted, peaceful serene radiant expression, faint warm flat gold light on the face, the saint alone, no other characters, no enemies and no scenery, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, strong rim light from behind the figure, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no text, facing right --ar 4:5 --no halo, rays, light burst, glow background, background, scenery, enemies, monsters, demons, other people, text, letters, frame, vignette, parchment background, textured background, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left, medieval knight, plate armor, great helm, tabard, horse, dragon
```

- [ ] **`splash_saint_benedict_miracle`** · Milagre

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, dramatic half-body portrait from the waist up, three-quarter view facing right, figure centered and filling about 90 percent of the image height, head in the upper third, Saint Benedict of Nursia as an elderly 6th-century abbot with a long white beard, black Benedictine habit with hood and scapular, a raven on his shoulder, thrusting a wooden cross forward at arm's length with the abbot's crozier in the other hand, the raven spreading its wings, stern commanding expression, a faint flat gold glow on the cross, the saint alone, no other characters, no enemies and no scenery, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, strong rim light from behind the figure, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no text, facing right --ar 4:5 --no halo, rays, light burst, glow background, background, scenery, enemies, monsters, demons, other people, text, letters, frame, vignette, parchment background, textured background, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

- [ ] **`splash_saint_benedict_dark_night`** · Noite Escura

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, dramatic half-body portrait from the waist up, three-quarter view facing right, figure centered and filling about 90 percent of the image height, head in the upper third, Saint Benedict of Nursia as an elderly 6th-century abbot with a long white beard, black Benedictine habit with hood and scapular, a raven on his shoulder, slumped forward gripping the crozier, head bowed, anguished exhausted expression, eyes downcast, deep shadows under the eyes, colors drained, the saint alone, no other characters, no enemies and no scenery, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, strong rim light from behind the figure, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no text, facing right --ar 4:5 --no halo, rays, light burst, glow background, background, scenery, enemies, monsters, demons, other people, text, letters, frame, vignette, parchment background, textured background, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

- [ ] **`splash_saint_benedict_consolation`** · Consolação

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, dramatic half-body portrait from the waist up, three-quarter view facing right, figure centered and filling about 90 percent of the image height, head in the upper third, Saint Benedict of Nursia as an elderly 6th-century abbot with a long white beard, black Benedictine habit with hood and scapular, a raven on his shoulder, standing upright holding the crozier, eyes softly lifted, peaceful serene radiant expression, faint warm flat gold light on the face, the saint alone, no other characters, no enemies and no scenery, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, strong rim light from behind the figure, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no text, facing right --ar 4:5 --no halo, rays, light burst, glow background, background, scenery, enemies, monsters, demons, other people, text, letters, frame, vignette, parchment background, textured background, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

- [ ] **`splash_saint_therese_miracle`** · Milagre

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, dramatic half-body portrait from the waist up, three-quarter view facing right, figure centered and filling about 90 percent of the image height, head in the upper third, Saint Therese of Lisieux as a young 19th-century Carmelite nun with a gentle round face, brown Carmelite habit and scapular, white mantle, black veil over white wimple, holding a crucifix wrapped in roses against her chest, eyes lifted upward, a few red rose petals falling close around her, tender confident expression, a soft flat gold glow on the roses, the saint alone, no other characters, no enemies and no scenery, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, strong rim light from behind the figure, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no text, facing right --ar 4:5 --no halo, rays, light burst, glow background, background, scenery, enemies, monsters, demons, other people, text, letters, frame, vignette, parchment background, textured background, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

- [ ] **`splash_saint_therese_dark_night`** · Noite Escura

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, dramatic half-body portrait from the waist up, three-quarter view facing right, figure centered and filling about 90 percent of the image height, head in the upper third, Saint Therese of Lisieux as a young 19th-century Carmelite nun with a gentle round face, brown Carmelite habit and scapular, white mantle, black veil over white wimple, slumped forward gripping the crucifix wrapped in roses, head bowed, anguished exhausted expression, eyes downcast, deep shadows under the eyes, colors drained, the saint alone, no other characters, no enemies and no scenery, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, strong rim light from behind the figure, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no text, facing right --ar 4:5 --no halo, rays, light burst, glow background, background, scenery, enemies, monsters, demons, other people, text, letters, frame, vignette, parchment background, textured background, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

- [ ] **`splash_saint_therese_consolation`** · Consolação

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, dramatic half-body portrait from the waist up, three-quarter view facing right, figure centered and filling about 90 percent of the image height, head in the upper third, Saint Therese of Lisieux as a young 19th-century Carmelite nun with a gentle round face, brown Carmelite habit and scapular, white mantle, black veil over white wimple, standing upright holding the crucifix wrapped in roses, eyes softly lifted, peaceful serene radiant expression, faint warm flat gold light on the face, the saint alone, no other characters, no enemies and no scenery, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, strong rim light from behind the figure, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no text, facing right --ar 4:5 --no halo, rays, light burst, glow background, background, scenery, enemies, monsters, demons, other people, text, letters, frame, vignette, parchment background, textured background, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

### Ícones (modelo da Direção de Arte já preenchido)

Arquivo final: PNG 256 × 256 (fundo removido).

- [ ] **`icon_intent_attack`**

```text
2D gothic horror game UI icon in the style of Darkest Dungeon, hand-inked comic art, a jagged black sword, centered, bold readable silhouette, thick irregular black ink outlines, angular blocky shading, muted desaturated flat colors, palette of black, bone, ash grey and dark blood red, distressed print texture, isolated on a plain flat solid light grey background, no text --ar 1:1 --no letters, numbers, cartoon, anime, glossy, 3D, photorealistic, white background
```

- [ ] **`icon_intent_corruption`**

```text
2D gothic horror game UI icon in the style of Darkest Dungeon, hand-inked comic art, a staring bloodshot eye dripping ink, centered, bold readable silhouette, thick irregular black ink outlines, angular blocky shading, muted desaturated flat colors, palette of black, bone, ash grey and dark blood red, distressed print texture, isolated on a plain flat solid light grey background, no text --ar 1:1 --no letters, numbers, cartoon, anime, glossy, 3D, photorealistic, white background
```

- [ ] **`icon_intent_displace`**

```text
2D gothic horror game UI icon in the style of Darkest Dungeon, hand-inked comic art, a curved claw-shaped arrow, centered, bold readable silhouette, thick irregular black ink outlines, angular blocky shading, muted desaturated flat colors, palette of black, bone, ash grey and dark blood red, distressed print texture, isolated on a plain flat solid light grey background, no text --ar 1:1 --no letters, numbers, cartoon, anime, glossy, 3D, photorealistic, white background
```

- [ ] **`icon_intent_defend`**

```text
2D gothic horror game UI icon in the style of Darkest Dungeon, hand-inked comic art, a cracked demonic shield, centered, bold readable silhouette, thick irregular black ink outlines, angular blocky shading, muted desaturated flat colors, palette of black, bone, ash grey and dark blood red, distressed print texture, isolated on a plain flat solid light grey background, no text --ar 1:1 --no letters, numbers, cartoon, anime, glossy, 3D, photorealistic, white background
```

- [ ] **`icon_intent_summon`**

```text
2D gothic horror game UI icon in the style of Darkest Dungeon, hand-inked comic art, a curled horn blowing black smoke, centered, bold readable silhouette, thick irregular black ink outlines, angular blocky shading, muted desaturated flat colors, palette of black, bone, ash grey and dark blood red, distressed print texture, isolated on a plain flat solid light grey background, no text --ar 1:1 --no letters, numbers, cartoon, anime, glossy, 3D, photorealistic, white background
```

- [ ] **`icon_state_consolation`**

```text
2D gothic horror game UI icon in the style of Darkest Dungeon, hand-inked comic art, a radiant halo disk with short rays, centered, bold readable silhouette, thick irregular black ink outlines, angular blocky shading, muted desaturated flat colors, palette of black, bone, ash grey and flat gold, distressed print texture, isolated on a plain flat solid light grey background, no text --ar 1:1 --no letters, numbers, cartoon, anime, glossy, 3D, photorealistic, white background
```

- [ ] **`icon_state_dark_night`**

```text
2D gothic horror game UI icon in the style of Darkest Dungeon, hand-inked comic art, a halo disk eclipsed by a black moon shape, centered, bold readable silhouette, thick irregular black ink outlines, angular blocky shading, muted desaturated flat colors, palette of black, bone, ash grey and ash grey, distressed print texture, isolated on a plain flat solid light grey background, no text --ar 1:1 --no letters, numbers, cartoon, anime, glossy, 3D, photorealistic, white background
```

- [ ] **`icon_state_desolation`**

```text
2D gothic horror game UI icon in the style of Darkest Dungeon, hand-inked comic art, a spreading ink blot over a parchment scrap, centered, bold readable silhouette, thick irregular black ink outlines, angular blocky shading, muted desaturated flat colors, palette of black, bone, ash grey and black, distressed print texture, isolated on a plain flat solid light grey background, no text --ar 1:1 --no letters, numbers, cartoon, anime, glossy, 3D, photorealistic, white background
```

- [ ] **`icon_cond_purification`**

```text
2D gothic horror game UI icon in the style of Darkest Dungeon, hand-inked comic art, a small flame inside a halo ring, centered, bold readable silhouette, thick irregular black ink outlines, angular blocky shading, muted desaturated flat colors, palette of black, bone, ash grey and flat gold, distressed print texture, isolated on a plain flat solid light grey background, no text --ar 1:1 --no letters, numbers, cartoon, anime, glossy, 3D, photorealistic, white background
```

- [ ] **`icon_cond_bleed`**

```text
2D gothic horror game UI icon in the style of Darkest Dungeon, hand-inked comic art, a single heavy drop of blood, centered, bold readable silhouette, thick irregular black ink outlines, angular blocky shading, muted desaturated flat colors, palette of black, bone, ash grey and dark blood red, distressed print texture, isolated on a plain flat solid light grey background, no text --ar 1:1 --no letters, numbers, cartoon, anime, glossy, 3D, photorealistic, white background
```

- [ ] **`icon_cond_corruption`**

```text
2D gothic horror game UI icon in the style of Darkest Dungeon, hand-inked comic art, twisting black veins, centered, bold readable silhouette, thick irregular black ink outlines, angular blocky shading, muted desaturated flat colors, palette of black, bone, ash grey and sickly olive green, distressed print texture, isolated on a plain flat solid light grey background, no text --ar 1:1 --no letters, numbers, cartoon, anime, glossy, 3D, photorealistic, white background
```

- [ ] **`icon_cond_stun`**

```text
2D gothic horror game UI icon in the style of Darkest Dungeon, hand-inked comic art, a spiral of ink with small stars, centered, bold readable silhouette, thick irregular black ink outlines, angular blocky shading, muted desaturated flat colors, palette of black, bone, ash grey and bone white, distressed print texture, isolated on a plain flat solid light grey background, no text --ar 1:1 --no letters, numbers, cartoon, anime, glossy, 3D, photorealistic, white background
```

- [ ] **`icon_cond_mark`**

```text
2D gothic horror game UI icon in the style of Darkest Dungeon, hand-inked comic art, three deep claw marks, centered, bold readable silhouette, thick irregular black ink outlines, angular blocky shading, muted desaturated flat colors, palette of black, bone, ash grey and dark blood red, distressed print texture, isolated on a plain flat solid light grey background, no text --ar 1:1 --no letters, numbers, cartoon, anime, glossy, 3D, photorealistic, white background
```

- [ ] **`icon_dmg_strike`**

```text
2D gothic horror game UI icon in the style of Darkest Dungeon, hand-inked comic art, a clenched mailed fist, centered, bold readable silhouette, thick irregular black ink outlines, angular blocky shading, muted desaturated flat colors, palette of black, bone, ash grey and dark blood red, distressed print texture, isolated on a plain flat solid light grey background, no text --ar 1:1 --no letters, numbers, cartoon, anime, glossy, 3D, photorealistic, white background
```

- [ ] **`icon_dmg_exorcism`**

```text
2D gothic horror game UI icon in the style of Darkest Dungeon, hand-inked comic art, a radiant cross of light, centered, bold readable silhouette, thick irregular black ink outlines, angular blocky shading, muted desaturated flat colors, palette of black, bone, ash grey and flat gold, distressed print texture, isolated on a plain flat solid light grey background, no text --ar 1:1 --no letters, numbers, cartoon, anime, glossy, 3D, photorealistic, white background
```

- [ ] **`icon_node_battle`**

```text
2D gothic horror game UI icon in the style of Darkest Dungeon, hand-inked comic art, two crossed swords, centered, bold readable silhouette, thick irregular black ink outlines, angular blocky shading, muted desaturated flat colors, palette of black, bone, ash grey and dark blood red, distressed print texture, isolated on a plain flat solid light grey background, no text --ar 1:1 --no letters, numbers, cartoon, anime, glossy, 3D, photorealistic, white background
```

- [ ] **`icon_node_elite`**

```text
2D gothic horror game UI icon in the style of Darkest Dungeon, hand-inked comic art, a horned demon skull, centered, bold readable silhouette, thick irregular black ink outlines, angular blocky shading, muted desaturated flat colors, palette of black, bone, ash grey and dark blood red, distressed print texture, isolated on a plain flat solid light grey background, no text --ar 1:1 --no letters, numbers, cartoon, anime, glossy, 3D, photorealistic, white background
```

- [ ] **`icon_node_temptation`**

```text
2D gothic horror game UI icon in the style of Darkest Dungeon, hand-inked comic art, an apple coiled by a serpent, centered, bold readable silhouette, thick irregular black ink outlines, angular blocky shading, muted desaturated flat colors, palette of black, bone, ash grey and dark blood red, distressed print texture, isolated on a plain flat solid light grey background, no text --ar 1:1 --no letters, numbers, cartoon, anime, glossy, 3D, photorealistic, white background
```

- [ ] **`icon_node_soul`**

```text
2D gothic horror game UI icon in the style of Darkest Dungeon, hand-inked comic art, a hooded lantern with a pale ghostly flame, centered, bold readable silhouette, thick irregular black ink outlines, angular blocky shading, muted desaturated flat colors, palette of black, bone, ash grey and pale pearl grey, distressed print texture, isolated on a plain flat solid light grey background, no text --ar 1:1 --no letters, numbers, cartoon, anime, glossy, 3D, photorealistic, white background
```

- [ ] **`icon_node_relic`**

```text
2D gothic horror game UI icon in the style of Darkest Dungeon, hand-inked comic art, a small ornate reliquary casket, centered, bold readable silhouette, thick irregular black ink outlines, angular blocky shading, muted desaturated flat colors, palette of black, bone, ash grey and flat gold, distressed print texture, isolated on a plain flat solid light grey background, no text --ar 1:1 --no letters, numbers, cartoon, anime, glossy, 3D, photorealistic, white background
```

- [ ] **`icon_node_camp`**

```text
2D gothic horror game UI icon in the style of Darkest Dungeon, hand-inked comic art, a small campfire, centered, bold readable silhouette, thick irregular black ink outlines, angular blocky shading, muted desaturated flat colors, palette of black, bone, ash grey and warm amber, distressed print texture, isolated on a plain flat solid light grey background, no text --ar 1:1 --no letters, numbers, cartoon, anime, glossy, 3D, photorealistic, white background
```

- [ ] **`icon_node_boss`**

```text
2D gothic horror game UI icon in the style of Darkest Dungeon, hand-inked comic art, a crown of horns, centered, bold readable silhouette, thick irregular black ink outlines, angular blocky shading, muted desaturated flat colors, palette of black, bone, ash grey and dark blood red, distressed print texture, isolated on a plain flat solid light grey background, no text --ar 1:1 --no letters, numbers, cartoon, anime, glossy, 3D, photorealistic, white background
```

- [ ] **`icon_res_fervor`**

```text
2D gothic horror game UI icon in the style of Darkest Dungeon, hand-inked comic art, a single candle flame, centered, bold readable silhouette, thick irregular black ink outlines, angular blocky shading, muted desaturated flat colors, palette of black, bone, ash grey and flat gold, distressed print texture, isolated on a plain flat solid light grey background, no text --ar 1:1 --no letters, numbers, cartoon, anime, glossy, 3D, photorealistic, white background
```

- [ ] **`icon_res_light`**

```text
2D gothic horror game UI icon in the style of Darkest Dungeon, hand-inked comic art, a tall wax candle half burned with dripping wax, centered, bold readable silhouette, thick irregular black ink outlines, angular blocky shading, muted desaturated flat colors, palette of black, bone, ash grey and warm amber, distressed print texture, isolated on a plain flat solid light grey background, no text --ar 1:1 --no letters, numbers, cartoon, anime, glossy, 3D, photorealistic, white background
```

- [ ] **`icon_res_alms`**

```text
2D gothic horror game UI icon in the style of Darkest Dungeon, hand-inked comic art, a small leather alms purse with a few coins spilling out, centered, bold readable silhouette, thick irregular black ink outlines, angular blocky shading, muted desaturated flat colors, palette of black, bone, ash grey and cinnabar red, distressed print texture, isolated on a plain flat solid light grey background, no text --ar 1:1 --no letters, numbers, cartoon, anime, glossy, 3D, photorealistic, white background
```

- [ ] **`icon_prov_bread`**

```text
2D gothic horror game UI icon in the style of Darkest Dungeon, hand-inked comic art, a round loaf of bread with a cross scored on top, centered, bold readable silhouette, thick irregular black ink outlines, angular blocky shading, muted desaturated flat colors, palette of black, bone, ash grey and warm amber, distressed print texture, isolated on a plain flat solid light grey background, no text --ar 1:1 --no letters, numbers, cartoon, anime, glossy, 3D, photorealistic, white background
```

- [ ] **`icon_prov_candle`**

```text
2D gothic horror game UI icon in the style of Darkest Dungeon, hand-inked comic art, a single short candle on a small iron holder, centered, bold readable silhouette, thick irregular black ink outlines, angular blocky shading, muted desaturated flat colors, palette of black, bone, ash grey and warm amber, distressed print texture, isolated on a plain flat solid light grey background, no text --ar 1:1 --no letters, numbers, cartoon, anime, glossy, 3D, photorealistic, white background
```

- [ ] **`icon_prov_holy_water`**

```text
2D gothic horror game UI icon in the style of Darkest Dungeon, hand-inked comic art, a small glass ampoule of water with a tiny cross on the stopper, centered, bold readable silhouette, thick irregular black ink outlines, angular blocky shading, muted desaturated flat colors, palette of black, bone, ash grey and pale blue, distressed print texture, isolated on a plain flat solid light grey background, no text --ar 1:1 --no letters, numbers, cartoon, anime, glossy, 3D, photorealistic, white background
```

- [ ] **`icon_prov_bandages`**

```text
2D gothic horror game UI icon in the style of Darkest Dungeon, hand-inked comic art, a roll of linen bandages, centered, bold readable silhouette, thick irregular black ink outlines, angular blocky shading, muted desaturated flat colors, palette of black, bone, ash grey and bone white, distressed print texture, isolated on a plain flat solid light grey background, no text --ar 1:1 --no letters, numbers, cartoon, anime, glossy, 3D, photorealistic, white background
```

- [ ] **`icon_prov_incense`**

```text
2D gothic horror game UI icon in the style of Darkest Dungeon, hand-inked comic art, a swinging thurible trailing smoke, centered, bold readable silhouette, thick irregular black ink outlines, angular blocky shading, muted desaturated flat colors, palette of black, bone, ash grey and warm amber, distressed print texture, isolated on a plain flat solid light grey background, no text --ar 1:1 --no letters, numbers, cartoon, anime, glossy, 3D, photorealistic, white background
```

---

## Prioridade 3 · Vila e campanha

- [ ] **`village_hub_background`** — Fundo da vila (sem edifícios) · PNG 1920 × 1080

```text
Darkest Dungeon style 2D hand-painted gothic illustration, hand-inked comic art, Mike Mignola influence, the empty rocky plateau of a medieval monastery village site on the rim of an immense dark abyss, three-quarter view from slightly above, flat open ground with dirt paths connecting empty building plots, low dry-stone walls, a few bare trees, a pale gold dawn sky above, endless darkness and rising mist below the cliff edge, warm amber and pale gold light, palette of black, bone, ash grey and warm amber with small touches of flat gold, thick black ink outlines, heavy black shadows, distressed print texture, soft vignette --ar 16:9 --no buildings, houses, chapel, towers, people, characters, text, UI, cartoon, 3D, photorealistic
```

- [ ] **`village_hub_sky`** — céu separado, para as nuvens andarem

```text
Darkest Dungeon style 2D hand-painted gothic sky, hand-inked comic art, a pale gold dawn sky with long slow drifting clouds over a dark horizon, palette of bone, ash grey, pale gold and warm amber, thick black ink outlines on the clouds, distressed print texture --ar 21:9 --no land, buildings, people, text, cartoon, 3D, photorealistic
```

- [ ] **`village_storehouse_ext`** — Edifício (vista da vila) · PNG RGBA, recortado

```text
Darkest Dungeon style 2D hand-painted gothic illustration, hand-inked comic art, Mike Mignola influence, a single isolated sturdy stone storehouse with a wide wooden loading door, barrels and grain sacks stacked outside of a small medieval monastery village, three-quarter front view from slightly above, standing on a small patch of flat ground, warm amber candlelight in the windows and soft light from the left, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and warm amber with small touches of flat gold, ink texture on the building only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal --ar 1:1 --no people, characters, sky, background scenery, other buildings, parchment background, textured background, vignette, text, cartoon, 3D, photorealistic
```

- [ ] **`village_gate_ext`** — Edifício (vista da vila) · PNG RGBA, recortado

```text
Darkest Dungeon style 2D hand-painted gothic illustration, hand-inked comic art, Mike Mignola influence, a single isolated massive fortified stone gatehouse with iron-bound double doors and wall torches, a stone stair descending behind it into darkness of a small medieval monastery village, three-quarter front view from slightly above, standing on a small patch of flat ground, warm amber candlelight in the windows and soft light from the left, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and warm amber with small touches of flat gold, ink texture on the building only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal --ar 1:1 --no people, characters, sky, background scenery, other buildings, parchment background, textured background, vignette, text, cartoon, 3D, photorealistic
```

- [ ] **`village_infirmary_ext`** — Edifício (vista da vila) · PNG RGBA, recortado

```text
Darkest Dungeon style 2D hand-painted gothic illustration, hand-inked comic art, Mike Mignola influence, a single isolated long low stone infirmary hall with a tiled roof, herb garden beds along its side and a small cross over the door of a small medieval monastery village, three-quarter front view from slightly above, standing on a small patch of flat ground, warm amber candlelight in the windows and soft light from the left, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and warm amber with small touches of flat gold, ink texture on the building only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal --ar 1:1 --no people, characters, sky, background scenery, other buildings, parchment background, textured background, vignette, text, cartoon, 3D, photorealistic
```

- [ ] **`village_retreat_house_ext`** — Edifício (vista da vila) · PNG RGBA, recortado

```text
Darkest Dungeon style 2D hand-painted gothic illustration, hand-inked comic art, Mike Mignola influence, a single isolated sparse stone retreat house with a small walled training yard and a plain banner on a pole of a small medieval monastery village, three-quarter front view from slightly above, standing on a small patch of flat ground, warm amber candlelight in the windows and soft light from the left, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and warm amber with small touches of flat gold, ink texture on the building only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal --ar 1:1 --no people, characters, sky, background scenery, other buildings, parchment background, textured background, vignette, text, cartoon, 3D, photorealistic
```

### Interiores (telas das instalações, 16:9)

- [ ] **`village_storehouse_int`** · PNG 1920 × 1080

```text
Darkest Dungeon style 2D hand-painted gothic illustration, hand-inked comic art, a medieval monastery storeroom, loaves of bread on wooden racks, bundles of candles, small vials of holy water, rolls of bandages, sacks of grain, hanging herbs, warm amber candlelight and pale dawn gold, palette of black, bone, ash grey and warm amber with small touches of flat gold, thick black ink outlines, heavy black shadows, distressed print texture, dark vignette --ar 16:9 --no characters, people, text, UI, cartoon, 3D, photorealistic
```

- [ ] **`village_gate_int`** · PNG 1920 × 1080

```text
Darkest Dungeon style 2D hand-painted gothic illustration, hand-inked comic art, a massive fortified stone gate at the edge of the village opening onto a steep stairway descending into the abyss, torches on the walls, a tall flowering staff leaning by the door, warm amber candlelight against the cold darkness below, palette of black, bone, ash grey and warm amber with small touches of flat gold, thick black ink outlines, heavy black shadows, distressed print texture, dark vignette --ar 16:9 --no characters, people, text, UI, cartoon, 3D, photorealistic
```

- [ ] **`village_infirmary_int`** · PNG 1920 × 1080

```text
Darkest Dungeon style 2D hand-painted gothic illustration, hand-inked comic art, a vaulted medieval monastic infirmary, three simple wooden beds with linen, shelves of herbs, flasks and bandages, a mortar and pestle on a table, warm amber candlelight and pale dawn gold, palette of black, bone, ash grey and warm amber with small touches of flat gold, thick black ink outlines, heavy black shadows, distressed print texture, dark vignette --ar 16:9 --no characters, people, text, UI, cartoon, 3D, photorealistic
```

- [ ] **`village_retreat_house_int`** · PNG 1920 × 1080

```text
Darkest Dungeon style 2D hand-painted gothic illustration, hand-inked comic art, a sparse stone retreat house for spiritual exercises, a simple wooden table with an open book and a candle, a plain crucifix on the wall, a training yard with wooden practice weapons visible through an arch, warm amber candlelight and pale dawn gold, palette of black, bone, ash grey and warm amber with small touches of flat gold, thick black ink outlines, heavy black shadows, distressed print texture, dark vignette --ar 16:9 --no characters, people, text, UI, cartoon, 3D, photorealistic
```

### Mapa do Inferno

- [ ] **`ui_circle_map_reference`** — Referência geral do funil (gere primeiro, use como `--sref` das faixas)

> **Gerar:** `--ar 1:2` + Upscale 2×  
> **Arquivo final:** PNG **2048 × 4096 px**, só referência (guardar em `art_source/`)

```text
2D gothic horror game map illustration in the style of Darkest Dungeon, hand-inked comic art, inspired by Botticelli's Map of Hell and Gustave Dore engravings, a tall vertical cross-section of an immense inverted cone funnel descending into the earth, ten wide horizontal terraces stacked from top to bottom, each terrace a broad band spanning the funnel, the funnel walls sloping inward evenly so each band is narrower than the one above, ending in a frozen point at the bottom, a small fortified monastery village on the rim at the very top under a pale dawn, outside the funnel dark earth in cross-section with rock strata and roots, thick black ink outlines, heavy black shadows, crosshatched engraving texture, muted desaturated palette of black, bone, ash grey and small cinnabar red accents, aged parchment tone, distressed print texture --ar 1:2 --no text, letters, numbers, labels, flat gold, characters in close-up, frame, border, vignette, cartoon, glossy, 3D, photorealistic
```

- [ ] **`ui_circle_map_slice_rim`** — Faixa da vila (topo, prólogo)

> **Gerar:** `--ar 4:1` + Upscale 2× (matriz 3840 × 960)  
> **Arquivo final:** PNG RGB, **1920 × 480 px**, borda de baixo emendável com a faixa do Círculo 1

```text
2D gothic horror game map band in the style of Darkest Dungeon, hand-inked comic art, one wide horizontal slice of a cross-section map of Hell, the top rim of the abyss: a small fortified monastery village with a chapel bell tower and candlelit windows on the cliff edge at the left, a pale gold dawn sky above, the dark mouth of an immense funnel opening below across almost the whole width, a narrow stair descending into it, the bottom edge of the image continuous and seamless for stacking, thick black ink outlines, heavy black shadows, crosshatched engraving texture, muted desaturated palette of black, bone, ash grey and warm amber, aged parchment tone, distressed print texture --ar 4:1 --no text, letters, numbers, labels, flat gold, characters in close-up, frame, border, vignette, cartoon, glossy, 3D, photorealistic
```

- [ ] **`ui_circle_map_slice_circle_01`** — Faixa do círculo · Antinferno e Limbo

> **Gerar:** `--ar 4:1` + Upscale 2× (matriz 3840 × 960) · usar a guia do funil desta faixa como imagem de composição  
> **Arquivo final:** PNG RGB, **1920 × 480 px** · abertura do funil com **100%** da largura na borda de cima e **91%** na de baixo, centralizada · bordas de cima e de baixo emendáveis  
> Área de toque: a faixa inteira

```text
2D gothic horror game map band in the style of Darkest Dungeon, hand-inked comic art, inspired by Botticelli's Map of Hell, one wide horizontal slice of a cross-section of the funnel of Hell, a single terrace of the antinferno e limbo circle seen from the side, the funnel opening centered and spanning about 100 percent of the image width at the top edge narrowing evenly to about 91 percent at the bottom edge, steep sloped rock walls on both sides, inside the terrace: a barren vestibule plain with a tattered empty banner and swarms of wasps on the left, the black river Acheron in the middle, a pale castle with seven walls in a quiet meadow on the right, tiny distant figures only, outside the funnel on the left and right dark earth in cross-section with rock strata and roots, the top and bottom edges continuous and seamless for stacking with the bands above and below, an empty quiet area at the far left inside the band for a medallion, thick black ink outlines, heavy black shadows, crosshatched engraving texture, muted desaturated palette of black, bone, ash grey and pale pearl grey, aged parchment tone, distressed print texture --ar 4:1 --no text, letters, numbers, labels, flat gold, characters in close-up, frame, border, vignette, cartoon, glossy, 3D, photorealistic
```

- [ ] **`ui_circle_map_slice_circle_02`** — Faixa do círculo · Luxúria

> **Gerar:** `--ar 4:1` + Upscale 2× (matriz 3840 × 960) · usar a guia do funil desta faixa como imagem de composição  
> **Arquivo final:** PNG RGB, **1920 × 480 px** · abertura do funil com **91%** da largura na borda de cima e **82%** na de baixo, centralizada · bordas de cima e de baixo emendáveis  
> Área de toque: a faixa inteira

```text
2D gothic horror game map band in the style of Darkest Dungeon, hand-inked comic art, inspired by Botticelli's Map of Hell, one wide horizontal slice of a cross-section of the funnel of Hell, a single terrace of the luxúria circle seen from the side, the funnel opening centered and spanning about 91 percent of the image width at the top edge narrowing evenly to about 82 percent at the bottom edge, steep sloped rock walls on both sides, inside the terrace: a howling hurricane filling the whole band, tiny shrouded souls tumbling in a spiral of wind, a stone seat of judgment carved into the left wall, tiny distant figures only, outside the funnel on the left and right dark earth in cross-section with rock strata and roots, the top and bottom edges continuous and seamless for stacking with the bands above and below, an empty quiet area at the far left inside the band for a medallion, thick black ink outlines, heavy black shadows, crosshatched engraving texture, muted desaturated palette of black, bone, ash grey and stormy violet, aged parchment tone, distressed print texture --ar 4:1 --no text, letters, numbers, labels, flat gold, characters in close-up, frame, border, vignette, cartoon, glossy, 3D, photorealistic
```

### Outros

- [ ] **`saint_anthony_abbot_portrait`** — Retrato · essencial

> **Gerar:** proporção 3:4 · Midjourney: `--ar 3:4` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **768 × 1024 px**, 72 ppi, sRGB · do peito para cima

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, bust portrait from the chest up, three-quarter view facing right, framed from the chest up, eyes in the upper third of the frame, Saint Anthony the Great, a very old desert hermit with a long white beard and a rough hooded tunic, determined resolute expression, strong readable silhouette, thick irregular black ink outlines, heavy black shadows engulfing half the face, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 3:4 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

- [ ] **`env_circle_02_arrival`** — Chegada ao círculo (tela de transição e carregamento)

> **Gerar:** `--ar 16:9` + Upscale 2×  
> **Arquivo final:** PNG **1920 × 1080 px** (guardar a matriz em 3840 × 2160 em `art_source/`)  
> O motor coloca o nome do círculo por cima

```text
Dark gothic panoramic illustration in the style of Darkest Dungeon, hand-inked comic art, in the spirit of Gustave Dore engravings of the Inferno, a vast dark abyss filled by a spinning hurricane of tiny shrouded souls, a cliff ledge in the foreground, seen from a high rocky ledge, tiny distant figures, immense scale, thick black ink outlines, heavy black shadows, crosshatched engraving texture, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, close-up characters, cartoon, glossy, 3D, photorealistic
```

- [ ] **`env_descent_stair`** — Descida da vila ao abismo (transição Portão → círculo)

> **Gerar:** `--ar 9:16` + Upscale 2×  
> **Arquivo final:** PNG **1080 × 1920 px** (rolagem vertical na transição)

```text
Dark gothic vertical illustration in the style of Darkest Dungeon, hand-inked comic art, a narrow stone stairway carved into a sheer cliff spiraling down from a small fortified monastery gate lit by warm candlelight at the top into an endless dark abyss at the bottom, faint red glow far below, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey, warm amber at the top fading to deep shadow, distressed print texture --ar 9:16 --no text, letters, characters, cartoon, glossy, 3D, photorealistic
```

- [ ] **`ui_frame_panel`** — Moldura de painel

```text
2D gothic horror game UI frame in the style of Darkest Dungeon, hand-inked comic art, an ornate border of dark carved stone with gothic tracery and small pointed arches surrounding an empty aged parchment panel, symmetrical, thick irregular black ink outlines, muted desaturated colors, palette of black, bone, ash grey and small cinnabar red accents, distressed print texture, isolated on a plain flat solid light grey background, no text --ar 16:9 --no letters, numbers, cartoon, glossy, 3D, photorealistic, white background
```

---

## Prioridade 4 · Prólogo e acabamento

Roteiro: `docs/narrative/prologue.md` (D-190). Retratos: PNG RGBA **768 × 1024** (`--ar 3:4`), fundo cinza, sem auréola. Pranchas: PNG **1920 × 1080** (`--ar 16:9`, matriz 3840 × 2160), terço de baixo mais escuro para o texto; nas pranchas com santos, use os `body_idle` aprovados como referência de personagem. Nomes finais conforme o roteiro §5.1 (ex.: `prologue_p02_forest`).

### Retratos de diálogo

- [ ] **`R01`** · O Peregrino

```text
Dark gothic graphic novel illustration in the style of Darkest Dungeon character art, hand-inked comic art, Mike Mignola influence, head to waist portrait, the Pilgrim, a weary 14th-century man in his thirties with an unkempt beard and haunted sunken eyes, worn hooded pilgrim's cloak, a scallop shell badge, gripping a pilgrim's staff, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of bone, ash grey, black and dark blood red, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 3:4 --no halo, parchment background, textured background, vignette, gold, cartoon, anime, smile, glossy, 3D, photorealistic, white background
```

- [ ] **`R02`** · Santa Luzia

```text
Dark gothic graphic novel illustration in the style of Darkest Dungeon character art, hand-inked comic art, Mike Mignola influence, head to waist portrait, three-quarter view facing right, Saint Lucy as a young 4th-century Sicilian virgin martyr with a calm resolute face, simple light veil and plain dark red robes, holding a burning clay oil lamp close to her chest, a martyr's palm in the other hand, warm lamplight on her face, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of bone, ash grey, black, dark red and warm amber, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 3:4 --no halo, parchment background, textured background, vignette, eyes on a dish, blood, cartoon, anime, smile, glossy, 3D, photorealistic, white background
```

- [ ] **`R03`** · A Faminta

```text
Dark gothic graphic novel illustration in the style of Darkest Dungeon character art, hand-inked comic art, Mike Mignola influence, head to waist portrait, three-quarter view facing left, a tall strikingly beautiful but terribly emaciated woman with sunken hungry eyes and a sweet inviting smile, a she-wolf pelt draped over her shoulders like a shawl, modest dark gown, holding an empty ornate cup forward, non-sexualized, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and dark blood red, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 3:4 --no halo, gold, nude, cleavage, lingerie, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

- [ ] **`R04`** · O Coroado

```text
Dark gothic graphic novel illustration in the style of Darkest Dungeon character art, hand-inked comic art, Mike Mignola influence, head to waist portrait, three-quarter view facing left, a towering proud man with his head held high and a cold accusing stare, a heavy cloak made from a lion's mane and hide, a crude iron crown, scarred bruised knuckles, one finger pointing in accusation, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and dark blood red, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 3:4 --no halo, gold, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

- [ ] **`R05`** · O Mercador Manchado

```text
Dark gothic graphic novel illustration in the style of Darkest Dungeon character art, hand-inked comic art, Mike Mignola influence, head to waist portrait, three-quarter view facing left, a lean merchant with a sweet treacherous grin, laughing mockingly, a long cloak of spotted dappled leopard-like hide, a rope cord tied around his waist, a merchant's purse and small scales at his belt, one hand raised in a mocking flourish, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and dark blood red, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 3:4 --no halo, gold, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

### Pranchas

- [ ] **`P02`** · A selva escura

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, a lone weary 14th-century pilgrim with a hooded cloak and a staff lost in a dark tangled forest at night, gnarled trees and thorny branches closing in on all sides, no path visible, the pilgrim small in the frame looking around in fear, cinematic composition, the lower third of the image darker for subtitles, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and dark blood red, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, animals, beasts, cartoon, anime, glossy, 3D, photorealistic
```

- [ ] **`P03`** · A Faminta

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, in a dark tangled forest at night a tall strikingly beautiful but terribly emaciated woman steps out of the shadows toward a frightened 14th-century pilgrim, a she-wolf pelt draped over her shoulders like a shawl, sunken hungry eyes, a sweet inviting smile, offering him an empty ornate cup with a thin hand, modest dark gown, non-sexualized, cinematic composition, the lower third of the image darker for subtitles, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and dark blood red, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, nude, cleavage, lingerie, wolf animal, cartoon, anime, glossy, 3D, photorealistic
```

- [ ] **`P04`** · O Coroado

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, in a dark tangled forest at night a towering proud man with his head held high looms over a frightened 14th-century pilgrim, a heavy cloak made from a lion's mane and hide, a crude iron crown, scarred bruised knuckles, a cold accusing stare, pointing at the pilgrim, cinematic composition, the lower third of the image darker for subtitles, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and dark blood red, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, lion animal, gold, cartoon, anime, glossy, 3D, photorealistic
```

- [ ] **`P05`** · O Mercador Manchado

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, in a dark tangled forest at night a lean smiling merchant leans in mockingly close to a frightened 14th-century pilgrim, a long cloak of spotted dappled leopard-like hide, a rope cord tied around his waist, a merchant's purse and a set of scales, a sweet treacherous grin, laughing, one hand patting the pilgrim's shoulder, cinematic composition, the lower third of the image darker for subtitles, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and dark blood red, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, leopard animal, gold, cartoon, anime, glossy, 3D, photorealistic
```

- [ ] **`P06`** · O cerco

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, a terrified 14th-century pilgrim stumbling backward among the roots of a dark forest at night, surrounded by three looming figures closing in: an emaciated woman with a she-wolf pelt and an empty cup, a proud crowned man in a lion-mane cloak, and a grinning merchant in a spotted cloak with a rope at his waist, faces half lost in shadow, the pilgrim's staff slipping from his hand, claustrophobic cinematic composition, the lower third of the image darker for subtitles, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and dark blood red, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, animals, nude, gold, cartoon, anime, glossy, 3D, photorealistic
```

- [ ] **`P07`** · A queda

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, the body of a 14th-century pilgrim lying unconscious among the roots of the dark forest, still breathing, his staff fallen beside him, above him a pale translucent ghostly double of the same man being pulled downward into cracks in the earth by long shadowy hands, three dim human silhouettes watching from the darkness, a woman with a shawl, a crowned man and a man in a long cloak, cinematic composition, the lower third of the image darker for subtitles, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and dark blood red, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, blood, gore, cartoon, anime, glossy, 3D, photorealistic
```

- [ ] **`P08`** · Nossa Senhora

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, reverent iconographic image of the Virgin Mary, veiled, in a deep ultramarine mantle over a dark red dress, gazing downward with grieving compassion, hands open in intercession, surrounded by a soft flat gold radiance, cinematic composition, thick irregular black ink outlines, deep black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ultramarine blue and flat gold, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, sensual
```

- [ ] **`P09`** · Santa Luzia desce

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, Saint Lucy as a young 4th-century Sicilian martyr, simple veil and robes, holding a burning oil lamp and a martyr's palm, a small dish with two eyes at her side as in traditional iconography, flat gold halo, descending a stair of light into darkness to deliver a message, cinematic composition, the lower third of the image darker for subtitles, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and flat gold, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

- [ ] **`P10`** · O chamado: São Jorge

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, Saint George as a young beardless Roman military officer of the late 3rd century with short curly hair, bronze muscle cuirass and red paludamentum cloak, kneeling in prayer in the darkness with his long spear planted beside him and his round cross shield at his side, a warm beam of lamplight falling on him from the left as he lifts his head and begins to rise, flat gold halo, close cinematic framing, the lower third of the image darker for the name, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey, dark blood red and warm amber, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, medieval knight, plate armor, horse, cartoon, anime, glossy, 3D, photorealistic
```

- [ ] **`P11`** · O chamado: São Bento

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, Saint Benedict of Nursia as an elderly abbot with a long white beard in a black Benedictine habit, sitting in a bare stone monastic cell reading the book of his Rule by a small window at night, a raven perched on the sill, a warm beam of lamplight falling on him from the left as he closes the book and looks up, flat gold halo, close cinematic framing, the lower third of the image darker for the name, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and warm amber, distressed print texture, dark vignette --ar 16:9 --no text, letters, readable text, UI, cartoon, anime, glossy, 3D, photorealistic
```

- [ ] **`P12`** · O chamado: Santa Teresinha

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, Saint Therese of Lisieux as a young Carmelite nun with a gentle round face, brown habit, white mantle and black veil, standing in a quiet Carmelite cloister garden at night among rose bushes, holding a crucifix wrapped in roses, a warm beam of lamplight falling on her from the left as she turns toward it with a small confident nod, a few rose petals in the air, flat gold halo, close cinematic framing, the lower third of the image darker for the name, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey, dark red and warm amber, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

- [ ] **`P13`** · Chegada ao Átrio

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, Saint Lucy with a burning oil lamp leading three saints, a young Roman officer with spear and round shield, an elderly black-robed abbot with a crozier and a young Carmelite nun with a crucifix of roses, through the gate of a small fortified medieval monastery village perched on the rim of an immense dark abyss, candlelit windows, a pale gold dawn sky above and endless darkness below the cliff, all four with flat gold halos, wide cinematic composition, the lower third of the image darker for subtitles, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey, warm amber and small touches of flat gold, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

- [ ] **`P14`** · A lanterna da companhia

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, close-up of Saint Lucy tilting her burning clay oil lamp to light a small iron hanging lantern held up by a young Roman officer's hand in a bronze bracer, the flame passing from one to the other in flat gold, faces of the saints softly lit around the flame in the darkness, intimate cinematic framing, the lower third of the image darker for subtitles, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey, warm amber and flat gold, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

- [ ] **`P15`** · A beira do abismo

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, in the spirit of Gustave Dore engravings, four small figures seen from behind standing at the edge of a cliff at dusk, a woman with a lamp and three companions with spear, crozier and veil, one holding up a small lantern, looking down into an immense funnel-shaped abyss, far below a tiny pale light falling into the darkness, and deeper still the faint red glow of a colossal gate, immense scale, the upper half of the sky empty for a title, cinematic composition, thick irregular black ink outlines, heavy black shadows, crosshatched engraving texture, muted desaturated palette of black, bone, ash grey, warm amber and a touch of dark red, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

### Acabamento

- [ ] **`env_gate_of_hell`** — Porta do Inferno (entrada da primeira expedição e do prólogo)

> **Gerar:** `--ar 16:9` + Upscale 2×  
> **Arquivo final:** PNG **1920 × 1080 px** (matriz 3840 × 2160)  
> Sem inscrição na pedra: o texto de Dante (Inferno III) é colocado pelo motor

```text
Dark gothic illustration in the style of Darkest Dungeon, hand-inked comic art, in the spirit of Gustave Dore engravings, the colossal Gate of Hell carved into a black cliff, a blank stone lintel above the arch ready for an inscription, darkness and faint red light beyond, a lonely path leading to it, immense scale, thick black ink outlines, heavy black shadows, crosshatched engraving texture, muted desaturated palette of black, bone, ash grey and pale pearl grey, distressed print texture, dark vignette --ar 16:9 --no text, letters, inscription, characters, cartoon, glossy, 3D, photorealistic
```

- [ ] **`fx_light_shafts`** — Feixes de luz (Consolação, milagres, Vigília)

> **Gerar:** `--ar 16:9` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **1920 × 1080 px**  
> Aplicado em modo aditivo; o motor controla a cor e a intensidade

```text
2D game VFX layer in the style of Darkest Dungeon, hand-inked comic art, several straight shafts of soft light falling diagonally from the top left, hand-inked edges, neutral pale warm white, isolated on a plain flat solid black background --ar 16:9 --no text, objects, characters, halo, cartoon, glossy, 3D, photorealistic
```

**Fontes:** já definidas na Direção de Arte (Uncial Antiqua nos títulos, EB Garamond nos textos, licença OFL); não são geradas.
