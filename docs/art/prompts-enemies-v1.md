# Prompts dos inimigos comuns e dos Pecados Encarnados · v1.1

Base: GDD v1.1 e Direção de Arte v1.1 (§5 e §6) · tamanhos de `docs/art/asset-pipeline.md` · v1.1 (05/11/2026).

**v1.1 — decisão de conteúdo aprovada por Alan em 05/11/2026:** os Pecados Encarnados representam seus pecados de forma mais fiel e mais pesada, dentro das regras do GDD §10 (gore e horror demoníaco permitidos; nenhuma nudez sexualizada, também por exigência da Google Play). A Vertigem é sedutora com o corpo sempre coberto; o Cisma foi redesenhado para o Círculo 6; Voracidade, Cobiça, Rancor, Crueldade e Perfídia ganharam detalhes mais gráficos. Esses prompts têm prioridade sobre as descrições dos Pecados na Direção de Arte §6.

## Como usar

- **Quatro imagens por inimigo:** pose padrão (`body_idle`), pose neutra para o rig (`rig_base`), ataque (`body_attack`) e defesa / golpe recebido (`body_defend`). Não há pose de queda: o inimigo some ao morrer.
- **Rig:** só a pose neutra. As peças são recortadas no editor (a IA erra a quantidade de partes numa folha de peças).
- **Ordem:** gere e aprove o `body_idle`. Depois use-o como referência de personagem (`--cref`/`--oref`) nas outras três, com a sua imagem de estilo em `--sref`.
- **Fundo:** cinza-claro liso, para o Claude Code remover. Nada de cenário, texto, auréola ou ouro (o ouro é só do sagrado).
- **Direção:** inimigos olham para a **esquerda**.
- **Cor:** os comuns saem em tons neutros (preto, osso, cinza e vermelho-sangue); a cor de cada círculo é aplicada pelo motor. Os Pecados Encarnados já saem na cor do seu círculo.
- **Corpóreos** têm carne sólida e sombra pesada; **Espirituais** têm corpo de fumaça e tinta com traço claro invertido.
- **Pixels:** o Midjourney não lê pixels no texto; ele segue `--ar` e o Upscale. Cada prompt diz quanto da imagem a figura ocupa (isso mantém a escala). O redimensionamento final para os pixels exatos é feito depois.

| Grupo | Proporção | Arquivo final | Figura |
| --- | --- | --- | --- |
| Comuns | 2:3 | 1024 × 1536 px | ≈ 1200 px de altura, base a 96 px da borda (mesma escala dos santos) |
| Enxame (invocado) | 2:3 | 1024 × 1536 px | ≈ 600 px de altura |
| Pecados Encarnados | 2:3 (Engano 4:3) | 1366 × 2048 px (Engano 2048 × 1536) | ≈ 1700 px (Engano ≈ 1300 px) |
| Rig (todos) | igual à pose | matriz no dobro do tamanho final, em `art_source/`; peças exportadas a 50% | — |

Todos os arquivos: PNG com transparência (RGBA), 8 bits, sRGB, 72 ppi. Pastas: `assets/characters/enemies/<id>/` (comuns) e `assets/characters/elites/<id>/` (Pecados). Nomes: `<id>_body_idle.png`, `<id>_rig_base.png`, `<id>_body_attack.png`, `<id>_body_defend.png`.

## Família A · Incontinência (Círculos 2 a 5)

### Diabo de Lodo (`enemy_mud_devil`) · Corpóreo · Bruto

**`enemy_mud_devil_body_idle`** — Pose padrão

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a hulking hunched mud demon with long dragging arms and a toothed mouth gaping in its chest, dripping black filth, long arms hanging to the ground, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`enemy_mud_devil_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 2:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **2048 × 3072 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a hulking hunched mud demon with long dragging arms and a toothed mouth gaping in its chest, dripping black filth, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: limbs held slightly away from the body, no limb overlapping the torso or another limb, weapons and held objects clearly apart from the body, clearly readable joints, calm neutral stance, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`enemy_mud_devil_body_attack`** — Ataque

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a hulking hunched mud demon with long dragging arms and a toothed mouth gaping in its chest, dripping black filth, swinging both long arms down in a crushing overhead slam, the chest mouth roaring, dynamic aggressive action pose, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`enemy_mud_devil_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a hulking hunched mud demon with long dragging arms and a toothed mouth gaping in its chest, dripping black filth, both arms raised to shield its head, filth splashing off its body, recoiling and bracing against an incoming blow, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

### Escaravelho Infernal (`enemy_infernal_scarab`) · Corpóreo · Guarda

**`enemy_infernal_scarab_body_idle`** — Pose padrão

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a man-sized infernal beetle standing on its hind legs, a thick cracked carapace, serrated mandibles, its carapace raised like a shield, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`enemy_infernal_scarab_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 2:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **2048 × 3072 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a man-sized infernal beetle standing on its hind legs, a thick cracked carapace, serrated mandibles, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: carapace shell held slightly apart from the body, legs spread and not overlapping, no limb overlapping another, clearly readable joints, calm neutral stance, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`enemy_infernal_scarab_body_attack`** — Ataque

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a man-sized infernal beetle standing on its hind legs, a thick cracked carapace, serrated mandibles, lunging forward snapping its serrated mandibles, dynamic aggressive action pose, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`enemy_infernal_scarab_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a man-sized infernal beetle standing on its hind legs, a thick cracked carapace, serrated mandibles, hunched fully behind its raised carapace like a shield wall, recoiling and bracing against an incoming blow, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

### Moscardo (`enemy_gadfly`) · Corpóreo · Atirador

**`enemy_gadfly_body_idle`** — Pose padrão

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a gaunt insect-man hybrid with membranous wings, a long proboscis and too many joints, hovering slightly with wings spread, proboscis aimed forward, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`enemy_gadfly_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 2:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **2048 × 3072 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a gaunt insect-man hybrid with membranous wings, a long proboscis and too many joints, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: wings spread wide and clear of the body, all limbs held apart, none overlapping, clearly readable joints, calm neutral stance, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`enemy_gadfly_body_attack`** — Ataque

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a gaunt insect-man hybrid with membranous wings, a long proboscis and too many joints, jerking its head forward and spitting a volley of venomous stingers from its proboscis, dynamic aggressive action pose, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`enemy_gadfly_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a gaunt insect-man hybrid with membranous wings, a long proboscis and too many joints, curling its many-jointed limbs inward and wrapping its wings around its body, recoiling and bracing against an incoming blow, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

### Sombra do Desejo (`enemy_shade_of_desire`) · Espiritual · Corruptor

**`enemy_shade_of_desire_body_idle`** — Pose padrão

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a tall faceless silhouette with many elongated reaching hands, its hands drifting outward around it, translucent body of smoke and ink, pale inverted linework on black, glowing pale edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, nude
```

**`enemy_shade_of_desire_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 2:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **2048 × 3072 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a tall faceless silhouette with many elongated reaching hands, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: each long arm held apart from the others and from the body, no arm crossing another, clearly readable joints, calm neutral stance, translucent body of smoke and ink, pale inverted linework on black, glowing pale edges, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, nude, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`enemy_shade_of_desire_body_attack`** — Ataque

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a tall faceless silhouette with many elongated reaching hands, all its long hands lunging forward to grasp, dynamic aggressive action pose, translucent body of smoke and ink, pale inverted linework on black, glowing pale edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, nude
```

**`enemy_shade_of_desire_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a tall faceless silhouette with many elongated reaching hands, its body shrinking and folding its hands around itself, smoke recoiling, recoiling and bracing against an incoming blow, translucent body of smoke and ink, pale inverted linework on black, glowing pale edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, nude
```

### Sopro Errante (`enemy_wandering_breath`) · Espiritual · Manipulador

**`enemy_wandering_breath_body_idle`** — Pose padrão

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a swirling whirlwind with screaming faces trapped inside it, spinning in place, translucent body of smoke and ink, pale inverted linework on black, glowing pale edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`enemy_wandering_breath_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 2:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **2048 × 3072 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a swirling whirlwind with screaming faces trapped inside it, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: a calm upright whirlwind with its spiral bands clearly separated, faces clearly visible, clearly readable joints, calm neutral stance, translucent body of smoke and ink, pale inverted linework on black, glowing pale edges, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`enemy_wandering_breath_body_attack`** — Ataque

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a swirling whirlwind with screaming faces trapped inside it, a violent gust bursting forward out of the whirlwind, the trapped faces screaming outward, dynamic aggressive action pose, translucent body of smoke and ink, pale inverted linework on black, glowing pale edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`enemy_wandering_breath_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a swirling whirlwind with screaming faces trapped inside it, the whirlwind tightening into a narrow dense spiral, recoiling and bracing against an incoming blow, translucent body of smoke and ink, pale inverted linework on black, glowing pale edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

### Mãe-Enxame (`enemy_swarm_mother`) · Corpóreo · Invocador

**`enemy_swarm_mother_body_idle`** — Pose padrão

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a bloated swollen demon covered in flies, open hive-like sores across its body, a swarm circling it, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`enemy_swarm_mother_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 2:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **2048 × 3072 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a bloated swollen demon covered in flies, open hive-like sores across its body, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: limbs held slightly away from the body, no limb overlapping the torso or another limb, weapons and held objects clearly apart from the body, clearly readable joints, calm neutral stance, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`enemy_swarm_mother_body_attack`** — Ataque

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a bloated swollen demon covered in flies, open hive-like sores across its body, convulsing as a thick swarm of flies bursts out of its sores toward the left, dynamic aggressive action pose, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`enemy_swarm_mother_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a bloated swollen demon covered in flies, open hive-like sores across its body, hunching its swollen body while the flies form a dense shield cloud in front of it, recoiling and bracing against an incoming blow, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

### Enxame (invocado) (`enemy_swarmling`) · Corpóreo · invocado pela Mãe-Enxame

> Novo: criado no M0 (`enemies.csv`) e ainda sem arte na Direção de Arte. Aprove o desenho antes de gerar as outras imagens.

**`enemy_swarmling_body_idle`** — Pose padrão

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura pequena, com **≈ 600 px** de altura, base a **96 px** da borda inferior (mesma escala dos santos) · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, small creature, figure height about 40 percent of the image height, base resting about 6 percent above the bottom edge, a small infernal fly-larva demon the size of a dog, a pale bloated grub body with tiny clawed legs, a ring of teeth for a mouth, a few flies buzzing around it, crouched low on the ground, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`enemy_swarmling_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 2:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **2048 × 3072 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body , small creature, figure height about 40 percent of the image height, base resting about 6 percent above the bottom edge, a small infernal fly-larva demon the size of a dog, a pale bloated grub body with tiny clawed legs, a ring of teeth for a mouth, a few flies buzzing around it, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: limbs held slightly away from the body, no limb overlapping the torso or another limb, weapons and held objects clearly apart from the body, clearly readable joints, calm neutral stance, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`enemy_swarmling_body_attack`** — Ataque

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura pequena, com **≈ 600 px** de altura, base a **96 px** da borda inferior (mesma escala dos santos) · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, small creature, figure height about 40 percent of the image height, base resting about 6 percent above the bottom edge, a small infernal fly-larva demon the size of a dog, a pale bloated grub body with tiny clawed legs, a ring of teeth for a mouth, a few flies buzzing around it, leaping forward with its ring of teeth wide open, dynamic aggressive action pose, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`enemy_swarmling_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura pequena, com **≈ 600 px** de altura, base a **96 px** da borda inferior (mesma escala dos santos) · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, small creature, figure height about 40 percent of the image height, base resting about 6 percent above the bottom edge, a small infernal fly-larva demon the size of a dog, a pale bloated grub body with tiny clawed legs, a ring of teeth for a mouth, a few flies buzzing around it, curling into a tight ball, recoiling and bracing against an incoming blow, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

## Família B · Dite e Violência (Círculos 6 e 7)

### Cornífero de Ferro (`enemy_iron_horned`) · Corpóreo · Bruto

**`enemy_iron_horned_body_idle`** — Pose padrão

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a brutish horned demon in heavy riveted iron armor wielding a glowing red-hot mace, the mace resting on its shoulder, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`enemy_iron_horned_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 2:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **2048 × 3072 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a brutish horned demon in heavy riveted iron armor wielding a glowing red-hot mace, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: limbs held slightly away from the body, no limb overlapping the torso or another limb, weapons and held objects clearly apart from the body, clearly readable joints, calm neutral stance, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`enemy_iron_horned_body_attack`** — Ataque

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a brutish horned demon in heavy riveted iron armor wielding a glowing red-hot mace, swinging the red-hot mace in a wide overhead smash, dynamic aggressive action pose, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`enemy_iron_horned_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a brutish horned demon in heavy riveted iron armor wielding a glowing red-hot mace, bracing with an armored forearm raised, head lowered behind its horns, recoiling and bracing against an incoming blow, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

### Sentinela de Dite (`enemy_dis_sentinel`) · Espiritual · Guarda

> O GDD v1.1 (P6) tornou a Sentinela de Dite **Espiritual**; a Direção de Arte ainda a descreve como Corpórea. O prompt já usa o estilo espiritual.

**`enemy_dis_sentinel_body_idle`** — Pose padrão

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a towering demon soldier like a living fortress, a massive gate-shaped iron shield and a long spear, planted behind its shield, translucent body of smoke and ink, pale inverted linework on black, glowing pale edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`enemy_dis_sentinel_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 2:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **2048 × 3072 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a towering demon soldier like a living fortress, a massive gate-shaped iron shield and a long spear, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: the gate shield held out to the side and clear of the body, spear held apart, clearly readable joints, calm neutral stance, translucent body of smoke and ink, pale inverted linework on black, glowing pale edges, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`enemy_dis_sentinel_body_attack`** — Ataque

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a towering demon soldier like a living fortress, a massive gate-shaped iron shield and a long spear, thrusting the long spear over the top of its gate-shaped shield, dynamic aggressive action pose, translucent body of smoke and ink, pale inverted linework on black, glowing pale edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`enemy_dis_sentinel_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a towering demon soldier like a living fortress, a massive gate-shaped iron shield and a long spear, crouched fully behind the gate-shaped shield, recoiling and bracing against an incoming blow, translucent body of smoke and ink, pale inverted linework on black, glowing pale edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

### Arqueiro Centauro (`enemy_centaur_archer`) · Corpóreo · Atirador

**`enemy_centaur_archer_body_idle`** — Pose padrão

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a demonic centaur archer with a gaunt horse body, a bow made of bone, a quiver of barbed arrows, standing with the bow lowered, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`enemy_centaur_archer_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 2:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **2048 × 3072 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a demonic centaur archer with a gaunt horse body, a bow made of bone, a quiver of barbed arrows, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: the four horse legs clearly separated, arms held apart from the human torso, bow held clear, clearly readable joints, calm neutral stance, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`enemy_centaur_archer_body_attack`** — Ataque

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a demonic centaur archer with a gaunt horse body, a bow made of bone, a quiver of barbed arrows, drawing the bone bow to full and loosing a barbed arrow, dynamic aggressive action pose, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`enemy_centaur_archer_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a demonic centaur archer with a gaunt horse body, a bow made of bone, a quiver of barbed arrows, rearing back on its hind legs with the bow raised across its body, recoiling and bracing against an incoming blow, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

### Caído de Dite (`enemy_fallen_of_dis`) · Espiritual · Corruptor

**`enemy_fallen_of_dis_body_idle`** — Pose padrão

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a fallen angel with charred burnt wings, a featureless erased face, tattered dark robes, wings half spread, translucent body of smoke and ink, pale inverted linework on black, glowing pale edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, feathered white wings
```

**`enemy_fallen_of_dis_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 2:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **2048 × 3072 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a fallen angel with charred burnt wings, a featureless erased face, tattered dark robes, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: both wings spread wide and clear of the body, arms held apart, clearly readable joints, calm neutral stance, translucent body of smoke and ink, pale inverted linework on black, glowing pale edges, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, feathered white wings, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`enemy_fallen_of_dis_body_attack`** — Ataque

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a fallen angel with charred burnt wings, a featureless erased face, tattered dark robes, reaching forward with a clawed hand as its burnt wings flare, dynamic aggressive action pose, translucent body of smoke and ink, pale inverted linework on black, glowing pale edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, feathered white wings
```

**`enemy_fallen_of_dis_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a fallen angel with charred burnt wings, a featureless erased face, tattered dark robes, wrapping its charred wings around its body, recoiling and bracing against an incoming blow, translucent body of smoke and ink, pale inverted linework on black, glowing pale edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, feathered white wings
```

### Harpia (`enemy_harpy`) · Corpóreo · Manipulador

**`enemy_harpy_body_idle`** — Pose padrão

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a gaunt emaciated harpy with a haggard old woman's face, body fully covered in ragged dark feathers, wide ragged wings, iron talons, non-sexualized, crouched with wings half open, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, nude, breasts
```

**`enemy_harpy_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 2:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **2048 × 3072 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a gaunt emaciated harpy with a haggard old woman's face, body fully covered in ragged dark feathers, wide ragged wings, iron talons, non-sexualized, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: wings spread wide and clear of the body, legs and talons apart, clearly readable joints, calm neutral stance, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, nude, breasts, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`enemy_harpy_body_attack`** — Ataque

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a gaunt emaciated harpy with a haggard old woman's face, body fully covered in ragged dark feathers, wide ragged wings, iron talons, non-sexualized, diving forward with iron talons extended and wings spread wide, dynamic aggressive action pose, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, nude, breasts
```

**`enemy_harpy_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a gaunt emaciated harpy with a haggard old woman's face, body fully covered in ragged dark feathers, wide ragged wings, iron talons, non-sexualized, shielding herself with her ragged wings, shrieking, recoiling and bracing against an incoming blow, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, nude, breasts
```

### Fornalheiro (`enemy_furnace_man`) · Corpóreo · Invocador

**`enemy_furnace_man_body_idle`** — Pose padrão

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a demon blacksmith with an open furnace burning inside its chest, a heavy hammer and long tongs, soot-covered, the hammer hanging at its side, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`enemy_furnace_man_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 2:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **2048 × 3072 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a demon blacksmith with an open furnace burning inside its chest, a heavy hammer and long tongs, soot-covered, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: limbs held slightly away from the body, no limb overlapping the torso or another limb, weapons and held objects clearly apart from the body, clearly readable joints, calm neutral stance, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`enemy_furnace_man_body_attack`** — Ataque

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a demon blacksmith with an open furnace burning inside its chest, a heavy hammer and long tongs, soot-covered, bringing the heavy hammer down while the chest furnace flares, dynamic aggressive action pose, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`enemy_furnace_man_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a demon blacksmith with an open furnace burning inside its chest, a heavy hammer and long tongs, soot-covered, turning its shoulder and raising the tongs to guard, recoiling and bracing against an incoming blow, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

### Caído das Muralhas (`enemy_fallen_of_walls`) · Corpóreo · Guarda · comum exclusivo do Círculo 6

> Inimigo comum desde a v1.1, mas exclusivo do Círculo 6: mantém a cor laranja-brasa da arte aprovada, sem troca de paleta.

**`enemy_fallen_of_walls_body_idle`** — Pose padrão

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a fallen angel guardian of the walls of Dis in blackened ornate armor, great bat-like wings, a long cruel spear, a proud contemptuous face, spear held upright, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and ember orange, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, feathered white wings
```

**`enemy_fallen_of_walls_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 2:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **2048 × 3072 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a fallen angel guardian of the walls of Dis in blackened ornate armor, great bat-like wings, a long cruel spear, a proud contemptuous face, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: both wings spread and clear of the body, spear held apart, clearly readable joints, calm neutral stance, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and ember orange, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, feathered white wings, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`enemy_fallen_of_walls_body_attack`** — Ataque

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a fallen angel guardian of the walls of Dis in blackened ornate armor, great bat-like wings, a long cruel spear, a proud contemptuous face, thrusting the long spear forward with wings spread, dynamic aggressive action pose, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and ember orange, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, feathered white wings
```

**`enemy_fallen_of_walls_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a fallen angel guardian of the walls of Dis in blackened ornate armor, great bat-like wings, a long cruel spear, a proud contemptuous face, closing its wings in front like a cloak, spear held across, recoiling and bracing against an incoming blow, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and ember orange, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, feathered white wings
```

## Família C · Fraude e Traição (Círculos 8 e 9)

### Malebranche (`enemy_malebranche`) · Corpóreo · Bruto

**`enemy_malebranche_body_idle`** — Pose padrão

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a lean black-skinned winged demon with bat wings, a leering fanged mouth and a long barbed hooked pitchfork, the pitchfork held ready, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`enemy_malebranche_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 2:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **2048 × 3072 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a lean black-skinned winged demon with bat wings, a leering fanged mouth and a long barbed hooked pitchfork, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: wings spread and clear of the body, pitchfork held apart, clearly readable joints, calm neutral stance, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`enemy_malebranche_body_attack`** — Ataque

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a lean black-skinned winged demon with bat wings, a leering fanged mouth and a long barbed hooked pitchfork, lunging forward and stabbing with the hooked pitchfork, dynamic aggressive action pose, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`enemy_malebranche_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a lean black-skinned winged demon with bat wings, a leering fanged mouth and a long barbed hooked pitchfork, leaping back with bat wings flared and the pitchfork held across its body, recoiling and bracing against an incoming blow, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

### Sentinela Gélida (`enemy_frost_sentinel`) · Espiritual · Guarda

**`enemy_frost_sentinel_body_idle`** — Pose padrão

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, an empty hollow suit of ancient armor made of ice, frost mist leaking from its joints, an icy blade and an icy shield, shield held forward, translucent body of smoke and ink, pale inverted linework on black, glowing pale edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`enemy_frost_sentinel_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 2:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **2048 × 3072 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, an empty hollow suit of ancient armor made of ice, frost mist leaking from its joints, an icy blade and an icy shield, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: limbs held slightly away from the body, no limb overlapping the torso or another limb, weapons and held objects clearly apart from the body, clearly readable joints, calm neutral stance, translucent body of smoke and ink, pale inverted linework on black, glowing pale edges, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`enemy_frost_sentinel_body_attack`** — Ataque

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, an empty hollow suit of ancient armor made of ice, frost mist leaking from its joints, an icy blade and an icy shield, slashing the icy blade in a wide arc, dynamic aggressive action pose, translucent body of smoke and ink, pale inverted linework on black, glowing pale edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`enemy_frost_sentinel_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, an empty hollow suit of ancient armor made of ice, frost mist leaking from its joints, an icy blade and an icy shield, kneeling behind the ice shield as frost thickens around it, recoiling and bracing against an incoming blow, translucent body of smoke and ink, pale inverted linework on black, glowing pale edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

### Arpoeiro (`enemy_harpooner`) · Corpóreo · Atirador

**`enemy_harpooner_body_idle`** — Pose padrão

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a winged demon with a barbed harpoon attached to a rattling chain, more harpoons on its back, the harpoon raised by its shoulder, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`enemy_harpooner_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 2:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **2048 × 3072 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a winged demon with a barbed harpoon attached to a rattling chain, more harpoons on its back, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: wings spread and clear of the body, harpoon and chain held apart, clearly readable joints, calm neutral stance, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`enemy_harpooner_body_attack`** — Ataque

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a winged demon with a barbed harpoon attached to a rattling chain, more harpoons on its back, hurling the barbed harpoon forward, the chain uncoiling behind it, dynamic aggressive action pose, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`enemy_harpooner_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a winged demon with a barbed harpoon attached to a rattling chain, more harpoons on its back, pulling the chain taut across its body as a guard, wings folded, recoiling and bracing against an incoming blow, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

### Vulto Mascarado (`enemy_masked_shade`) · Espiritual · Corruptor

**`enemy_masked_shade_body_idle`** — Pose padrão

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, an empty floating cloak with several cracked porcelain masks with frozen grins arranged where a face should be, floating still, translucent body of smoke and ink, pale inverted linework on black, glowing pale edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`enemy_masked_shade_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 2:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **2048 × 3072 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, an empty floating cloak with several cracked porcelain masks with frozen grins arranged where a face should be, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: the cloak hanging open and still, each mask clearly separated, clearly readable joints, calm neutral stance, translucent body of smoke and ink, pale inverted linework on black, glowing pale edges, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`enemy_masked_shade_body_attack`** — Ataque

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, an empty floating cloak with several cracked porcelain masks with frozen grins arranged where a face should be, the cloak billowing forward as the masks lunge out on smoky necks, dynamic aggressive action pose, translucent body of smoke and ink, pale inverted linework on black, glowing pale edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`enemy_masked_shade_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, an empty floating cloak with several cracked porcelain masks with frozen grins arranged where a face should be, the masks turning away and the cloak folding shut, recoiling and bracing against an incoming blow, translucent body of smoke and ink, pale inverted linework on black, glowing pale edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

### Serpente Ladra (`enemy_thief_serpent`) · Corpóreo · Manipulador

**`enemy_thief_serpent_body_idle`** — Pose padrão

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a large serpent with grasping human hands sprouting along its body, coiled and rearing up, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`enemy_thief_serpent_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 2:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **2048 × 3072 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a large serpent with grasping human hands sprouting along its body, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: the serpent body in a loose open S-curve without crossing itself, hands held apart, clearly readable joints, calm neutral stance, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`enemy_thief_serpent_body_attack`** — Ataque

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a large serpent with grasping human hands sprouting along its body, striking forward with fangs bared, the hands grabbing, dynamic aggressive action pose, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`enemy_thief_serpent_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a large serpent with grasping human hands sprouting along its body, coiling tightly with the hands covering its head, recoiling and bracing against an incoming blow, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

### Arauto da Mentira (`enemy_herald_of_lies`) · Espiritual · Invocador

**`enemy_herald_of_lies_body_idle`** — Pose padrão

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a tall gaunt robed figure with a long tarnished trumpet growing in place of its mouth, standing upright, translucent body of smoke and ink, pale inverted linework on black, glowing pale edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`enemy_herald_of_lies_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 2:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **2048 × 3072 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a tall gaunt robed figure with a long tarnished trumpet growing in place of its mouth, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: limbs held slightly away from the body, no limb overlapping the torso or another limb, weapons and held objects clearly apart from the body, clearly readable joints, calm neutral stance, translucent body of smoke and ink, pale inverted linework on black, glowing pale edges, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`enemy_herald_of_lies_body_attack`** — Ataque

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a tall gaunt robed figure with a long tarnished trumpet growing in place of its mouth, blasting from its trumpet, a cone of inky sound waves shooting forward, dynamic aggressive action pose, translucent body of smoke and ink, pale inverted linework on black, glowing pale edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`enemy_herald_of_lies_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1024 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1200 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 78 percent of the image height, base resting about 6 percent above the bottom edge, a tall gaunt robed figure with a long tarnished trumpet growing in place of its mouth, hunching and drawing its robe around itself, the trumpet lowered, recoiling and bracing against an incoming blow, translucent body of smoke and ink, pale inverted linework on black, glowing pale edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

## Pecados Encarnados (elites, um por círculo)

### Vertigem · Luxúria (`elite_sin_vertigo`) · Espiritual · Círculo 2

> Versão aprovada em 05/11/2026: sedutora e fiel ao pecado, com o corpo sempre coberto por véus de fumaça (regras de conteúdo do GDD §10 e política da Google Play).

**`elite_sin_vertigo_body_idle`** — Pose padrão

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Vertigo, allegorical personification of lust as a tall elegant alluring demon of dark smoke and flowing ink, a striking beautiful face with hypnotic pale empty eyes and a faint corrupted smile, long sheer veils of dark smoke wrapped around the body and covering it completely, a suggestive but fully draped silhouette, ribbons of dark incense smoke trailing from its shoulders and lower body, decadent and corrupting, graceful swaying posture, long fingers beckoning, translucent body of smoke and ink, pale inverted linework on black, glowing stormy violet edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and stormy violet, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, nude, nudity, nipples, explicit, erotic, lingerie
```

**`elite_sin_vertigo_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 2:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **2732 × 4096 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Vertigo, allegorical personification of lust as a tall elegant alluring demon of dark smoke and flowing ink, a striking beautiful face with hypnotic pale empty eyes and a faint corrupted smile, long sheer veils of dark smoke wrapped around the body and covering it completely, a suggestive but fully draped silhouette, ribbons of dark incense smoke trailing from its shoulders and lower body, decadent and corrupting, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: arms clearly separated from the torso, veils hanging still and close to the body, clearly readable joints, calm neutral stance, translucent body of smoke and ink, pale inverted linework on black, glowing stormy violet edges, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and stormy violet, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, nude, nudity, nipples, explicit, erotic, lingerie, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`elite_sin_vertigo_body_attack`** — Ataque

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Vertigo, allegorical personification of lust as a tall elegant alluring demon of dark smoke and flowing ink, a striking beautiful face with hypnotic pale empty eyes and a faint corrupted smile, long sheer veils of dark smoke wrapped around the body and covering it completely, a suggestive but fully draped silhouette, ribbons of dark incense smoke trailing from its shoulders and lower body, decadent and corrupting, gliding forward with arms outstretched, the smoke veils lashing out like whips in a dizzying spiral, dynamic aggressive action pose, translucent body of smoke and ink, pale inverted linework on black, glowing stormy violet edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and stormy violet, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, nude, nudity, nipples, explicit, erotic, lingerie
```

**`elite_sin_vertigo_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Vertigo, allegorical personification of lust as a tall elegant alluring demon of dark smoke and flowing ink, a striking beautiful face with hypnotic pale empty eyes and a faint corrupted smile, long sheer veils of dark smoke wrapped around the body and covering it completely, a suggestive but fully draped silhouette, ribbons of dark incense smoke trailing from its shoulders and lower body, decadent and corrupting, wrapping its smoke veils tightly around itself and spinning away, recoiling and bracing against an incoming blow, translucent body of smoke and ink, pale inverted linework on black, glowing stormy violet edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and stormy violet, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, nude, nudity, nipples, explicit, erotic, lingerie
```

### Voracidade · Gula (`elite_sin_voracity`) · Corpóreo · Círculo 3

**`elite_sin_voracity_body_idle`** — Pose padrão

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Voracity, allegorical personification of gluttony as a grotesquely swollen figure with a tiny head, skin stretched and splitting at the seams, a huge toothed mouth gaping open in its belly overflowing with rotten food and dripping bile, gnawed bones hanging from its body on cords, stuffing rotten scraps into its belly mouth, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and sickly olive green, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`elite_sin_voracity_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 2:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **2732 × 4096 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Voracity, allegorical personification of gluttony as a grotesquely swollen figure with a tiny head, skin stretched and splitting at the seams, a huge toothed mouth gaping open in its belly overflowing with rotten food and dripping bile, gnawed bones hanging from its body on cords, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: limbs held slightly away from the body, no limb overlapping the torso or another limb, weapons and held objects clearly apart from the body, clearly readable joints, calm neutral stance, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and sickly olive green, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`elite_sin_voracity_body_attack`** — Ataque

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Voracity, allegorical personification of gluttony as a grotesquely swollen figure with a tiny head, skin stretched and splitting at the seams, a huge toothed mouth gaping open in its belly overflowing with rotten food and dripping bile, gnawed bones hanging from its body on cords, lurching forward with the belly mouth gaping wide to devour, bile spraying, dynamic aggressive action pose, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and sickly olive green, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`elite_sin_voracity_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Voracity, allegorical personification of gluttony as a grotesquely swollen figure with a tiny head, skin stretched and splitting at the seams, a huge toothed mouth gaping open in its belly overflowing with rotten food and dripping bile, gnawed bones hanging from its body on cords, clutching its bloated belly as the belly mouth snaps shut, rotten scraps spilling, recoiling and bracing against an incoming blow, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and sickly olive green, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

### Cobiça · Avareza (`elite_sin_covetousness`) · Corpóreo · Círculo 4

**`elite_sin_covetousness_body_idle`** — Pose padrão

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Covetousness, allegorical personification of greed as a long gaunt hunched figure with many arms ending in tarnished brass claws, fingertips worn down to the bone from endless counting, tarnished coins fused into its flesh, coin purses sewn into its skin, sunken greedy eyes, bent over heavy sacks, counting coins, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and tarnished oxidized brass, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`elite_sin_covetousness_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 2:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **2732 × 4096 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Covetousness, allegorical personification of greed as a long gaunt hunched figure with many arms ending in tarnished brass claws, fingertips worn down to the bone from endless counting, tarnished coins fused into its flesh, coin purses sewn into its skin, sunken greedy eyes, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: each arm held apart from the others, sacks set down beside it, clearly readable joints, calm neutral stance, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and tarnished oxidized brass, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`elite_sin_covetousness_body_attack`** — Ataque

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Covetousness, allegorical personification of greed as a long gaunt hunched figure with many arms ending in tarnished brass claws, fingertips worn down to the bone from endless counting, tarnished coins fused into its flesh, coin purses sewn into its skin, sunken greedy eyes, lashing out with its many brass-clawed arms to snatch, dynamic aggressive action pose, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and tarnished oxidized brass, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`elite_sin_covetousness_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Covetousness, allegorical personification of greed as a long gaunt hunched figure with many arms ending in tarnished brass claws, fingertips worn down to the bone from endless counting, tarnished coins fused into its flesh, coin purses sewn into its skin, sunken greedy eyes, hunching over its sacks with its arms wrapped around them, recoiling and bracing against an incoming blow, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and tarnished oxidized brass, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

### Rancor · Ira (`elite_sin_rancor`) · Corpóreo · Círculo 5

**`elite_sin_rancor_body_idle`** — Pose padrão

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Rancor, allegorical personification of wrath as a mud-and-blood-soaked figure in blind fury, veins bulging, broken teeth bared, the flesh of its forearms torn by its own bites, biting into its own forearm, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and muddy dark red, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`elite_sin_rancor_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 2:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **2732 × 4096 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Rancor, allegorical personification of wrath as a mud-and-blood-soaked figure in blind fury, veins bulging, broken teeth bared, the flesh of its forearms torn by its own bites, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: limbs held slightly away from the body, no limb overlapping the torso or another limb, weapons and held objects clearly apart from the body, clearly readable joints, calm neutral stance, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and muddy dark red, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`elite_sin_rancor_body_attack`** — Ataque

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Rancor, allegorical personification of wrath as a mud-and-blood-soaked figure in blind fury, veins bulging, broken teeth bared, the flesh of its forearms torn by its own bites, charging forward with both fists swinging wildly, dynamic aggressive action pose, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and muddy dark red, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`elite_sin_rancor_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Rancor, allegorical personification of wrath as a mud-and-blood-soaked figure in blind fury, veins bulging, broken teeth bared, the flesh of its forearms torn by its own bites, doubling over with its arms wrapped around its head, shaking with rage, recoiling and bracing against an incoming blow, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and muddy dark red, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

### Cisma · Heresia (`elite_sin_schism`) · Espiritual · Círculo 6

> Redesenho aprovado em 05/11/2026: mais fiel ao Círculo 6 de Dante (os que negaram a imortalidade da alma, nos túmulos em chamas). O corpo partido ao meio lembrava os cismáticos do Círculo 8.

**`elite_sin_schism_body_idle`** — Pose padrão

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Schism, allegorical personification of heresy as a charred robed figure half risen from a burning open stone tomb, cracks across its body glowing with embers from a burning interior, holding a torn burning book of false doctrine, clutching the burning book to its chest, translucent body of smoke and ink, pale inverted linework on black, glowing ember orange edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and ember orange, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`elite_sin_schism_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 2:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **2732 × 4096 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Schism, allegorical personification of heresy as a charred robed figure half risen from a burning open stone tomb, cracks across its body glowing with embers from a burning interior, holding a torn burning book of false doctrine, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: the figure standing upright in front of the tomb, the tomb drawn as a separate shape below, arms and book held apart from the body, clearly readable joints, calm neutral stance, translucent body of smoke and ink, pale inverted linework on black, glowing ember orange edges, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and ember orange, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`elite_sin_schism_body_attack`** — Ataque

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Schism, allegorical personification of heresy as a charred robed figure half risen from a burning open stone tomb, cracks across its body glowing with embers from a burning interior, holding a torn burning book of false doctrine, thrusting the burning book forward as flames burst from its pages and from the cracks in its body, dynamic aggressive action pose, translucent body of smoke and ink, pale inverted linework on black, glowing ember orange edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and ember orange, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`elite_sin_schism_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Schism, allegorical personification of heresy as a charred robed figure half risen from a burning open stone tomb, cracks across its body glowing with embers from a burning interior, holding a torn burning book of false doctrine, sinking back into its burning tomb, shielding its face with the book, recoiling and bracing against an incoming blow, translucent body of smoke and ink, pale inverted linework on black, glowing ember orange edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and ember orange, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

### Crueldade · Violência (`elite_sin_cruelty`) · Corpóreo · Círculo 7

**`elite_sin_cruelty_body_idle`** — Pose padrão

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Cruelty, allegorical personification of violence as a hooded executioner with bare arms covered in burn scars, rusted meat hooks dripping blood and red-hot branding irons, a blood-soaked leather apron, no victims shown, hooks hanging from its hands, blood dripping, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and deep crimson, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, victims, children
```

**`elite_sin_cruelty_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 2:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **2732 × 4096 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Cruelty, allegorical personification of violence as a hooded executioner with bare arms covered in burn scars, rusted meat hooks dripping blood and red-hot branding irons, a blood-soaked leather apron, no victims shown, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: limbs held slightly away from the body, no limb overlapping the torso or another limb, weapons and held objects clearly apart from the body, clearly readable joints, calm neutral stance, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and deep crimson, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, victims, children, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`elite_sin_cruelty_body_attack`** — Ataque

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Cruelty, allegorical personification of violence as a hooded executioner with bare arms covered in burn scars, rusted meat hooks dripping blood and red-hot branding irons, a blood-soaked leather apron, no victims shown, swinging a dripping meat hook forward in a vicious arc, dynamic aggressive action pose, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and deep crimson, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, victims, children
```

**`elite_sin_cruelty_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Cruelty, allegorical personification of violence as a hooded executioner with bare arms covered in burn scars, rusted meat hooks dripping blood and red-hot branding irons, a blood-soaked leather apron, no victims shown, raising the branding irons crossed in front of its hood, recoiling and bracing against an incoming blow, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and deep crimson, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, victims, children
```

### Engano · Fraude (`elite_sin_deceit`) · Espiritual · Círculo 8

**`elite_sin_deceit_body_idle`** — Pose padrão

> **Gerar:** `--ar 4:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **2048 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1300 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Deceit, allegorical personification of fraud inspired by Dante's Geryon, a handsome serene wax human face atop a long scaly serpent body, hairy clawed forelimbs, a scorpion stinger tail, coiled with its calm wax face turned forward, translucent body of smoke and ink, pale inverted linework on black, glowing poison green edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and poison green, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 4:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`elite_sin_deceit_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 4:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **4096 × 3072 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Deceit, allegorical personification of fraud inspired by Dante's Geryon, a handsome serene wax human face atop a long scaly serpent body, hairy clawed forelimbs, a scorpion stinger tail, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: the serpent body laid out in a long open curve without crossing itself, forelimbs and stinger tail clearly apart, clearly readable joints, calm neutral stance, translucent body of smoke and ink, pale inverted linework on black, glowing poison green edges, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and poison green, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 4:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`elite_sin_deceit_body_attack`** — Ataque

> **Gerar:** `--ar 4:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **2048 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1300 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Deceit, allegorical personification of fraud inspired by Dante's Geryon, a handsome serene wax human face atop a long scaly serpent body, hairy clawed forelimbs, a scorpion stinger tail, the scorpion stinger tail striking forward over its head, dynamic aggressive action pose, translucent body of smoke and ink, pale inverted linework on black, glowing poison green edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and poison green, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 4:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`elite_sin_deceit_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 4:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **2048 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1300 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Deceit, allegorical personification of fraud inspired by Dante's Geryon, a handsome serene wax human face atop a long scaly serpent body, hairy clawed forelimbs, a scorpion stinger tail, the serpent body coiling around itself while the wax face stays calm, recoiling and bracing against an incoming blow, translucent body of smoke and ink, pale inverted linework on black, glowing poison green edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and poison green, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 4:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

### Perfídia · Traição (`elite_sin_perfidy`) · Espiritual · Círculo 9

> Aprovado em 05/11/2026: as trinta moedas de prata (Mateus 26,15) aludem a Judas sem representá-lo.

**`elite_sin_perfidy_body_idle`** — Pose padrão

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Perfidy, allegorical personification of treachery as a robed figure whose face is half gentle human and half frozen skull of ice, frozen tears on the human cheek, thirty tarnished silver coins strung on a cord around its neck, a hidden dagger, one hand extended in false friendship, the other hiding the dagger behind its back, translucent body of smoke and ink, pale inverted linework on black, glowing icy pale blue edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and icy pale blue, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`elite_sin_perfidy_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 2:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **2732 × 4096 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Perfidy, allegorical personification of treachery as a robed figure whose face is half gentle human and half frozen skull of ice, frozen tears on the human cheek, thirty tarnished silver coins strung on a cord around its neck, a hidden dagger, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: limbs held slightly away from the body, no limb overlapping the torso or another limb, weapons and held objects clearly apart from the body, clearly readable joints, calm neutral stance, translucent body of smoke and ink, pale inverted linework on black, glowing icy pale blue edges, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and icy pale blue, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`elite_sin_perfidy_body_attack`** — Ataque

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Perfidy, allegorical personification of treachery as a robed figure whose face is half gentle human and half frozen skull of ice, frozen tears on the human cheek, thirty tarnished silver coins strung on a cord around its neck, a hidden dagger, stabbing forward with the hidden dagger while still smiling, dynamic aggressive action pose, translucent body of smoke and ink, pale inverted linework on black, glowing icy pale blue edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and icy pale blue, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`elite_sin_perfidy_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Perfidy, allegorical personification of treachery as a robed figure whose face is half gentle human and half frozen skull of ice, frozen tears on the human cheek, thirty tarnished silver coins strung on a cord around its neck, a hidden dagger, drawing its robe across its body, the hand of friendship raised to stop the blow, recoiling and bracing against an incoming blow, translucent body of smoke and ink, pale inverted linework on black, glowing icy pale blue edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and icy pale blue, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```
