# Prompts das elites e dos chefes de círculo · v1

Base: GDD v1.1 e Direção de Arte v1.1 (§6 e §7) · tamanhos de `docs/art/asset-pipeline.md` · v1 (05/11/2026).

## Como usar

- **Quatro imagens por elite e chefe:** pose padrão (`body_idle`), pose neutra para o rig (`rig_base`), ataque (`body_attack`) e defesa / golpe recebido (`body_defend`). Não há pose de queda: eles somem ao morrer.
- **Rig:** só a pose neutra; as peças são recortadas no editor.
- **Ordem:** gere e aprove o `body_idle`; use-o como referência de personagem (`--cref`/`--oref`) nas outras três, com a imagem de estilo em `--sref`.
- **Fundo:** cinza-claro liso para recorte. Sem cenário, texto, auréola ou ouro.
- **Cor:** elites e chefes já saem na cor de destaque do seu círculo.
- **Direção:** olham para a **esquerda**, exceto Lúcifer, que é visto de frente.
- Chefes ocupam 2 ou 3 posições; por isso usam 4:3 ou 1:1.

| Proporção | Arquivo final | Figura |
| --- | --- | --- |
| 2:3 | 1366 × 2048 px | ≈ 1700 px de altura, base a 128 px da borda |
| 4:3 | 2048 × 1536 px | ≈ 1300 px de altura, base a 96 px da borda |
| 1:1 | 2048 × 2048 px | ≈ 1750 px de altura, base a 128 px da borda |
| Rig | matriz no dobro do tamanho final, em `art_source/`; peças exportadas a 50% | — |

Todos os arquivos: PNG com transparência (RGBA), 8 bits, sRGB, 72 ppi. Pastas: `assets/characters/elites/<id>/` e `assets/characters/bosses/<id>/`. Os Traidores Atados do Círculo 9 são ambiente e ficam nos cenários (`prompts-environments-v1.md`).

## Guardiões de Dante (elites)

### Minos (`elite_minos`) · Corpóreo · Círculo 2

**`elite_minos_body_idle`** — Pose padrão

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Minos the infernal judge as a towering crowned demonic king seated on a stone seat of judgment, an enormous serpent tail, the tail coiled many times around his body, one clawed hand pointing in condemnation, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and stormy violet, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`elite_minos_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 2:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **2732 × 4096 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Minos the infernal judge as a towering crowned demonic king seated on a stone seat of judgment, an enormous serpent tail, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: the tail uncoiled and laid out to the side without crossing itself, arms held apart, clearly readable joints, calm neutral stance, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and stormy violet, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`elite_minos_body_attack`** — Ataque

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Minos the infernal judge as a towering crowned demonic king seated on a stone seat of judgment, an enormous serpent tail, lashing his serpent tail forward like a whip while roaring a sentence, dynamic aggressive action pose, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and stormy violet, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`elite_minos_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Minos the infernal judge as a towering crowned demonic king seated on a stone seat of judgment, an enormous serpent tail, the serpent tail coiling up around him like armor, recoiling and bracing against an incoming blow, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and stormy violet, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

### Cérbero (`elite_cerberus`) · Corpóreo · Círculo 3

**`elite_cerberus_body_idle`** — Pose padrão

> **Gerar:** `--ar 4:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **2048 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1300 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Cerberus as a huge three-headed hellhound caked in filthy mud, three heads with red eyes, matted black fur, enormous claws, a bloated greedy belly, all three heads snarling, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and sickly olive green, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 4:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`elite_cerberus_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 4:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **4096 × 3072 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Cerberus as a huge three-headed hellhound caked in filthy mud, three heads with red eyes, matted black fur, enormous claws, a bloated greedy belly, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: the three heads and necks clearly separated, the four legs apart and not overlapping, clearly readable joints, calm neutral stance, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and sickly olive green, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 4:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`elite_cerberus_body_attack`** — Ataque

> **Gerar:** `--ar 4:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **2048 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1300 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Cerberus as a huge three-headed hellhound caked in filthy mud, three heads with red eyes, matted black fur, enormous claws, a bloated greedy belly, lunging forward with all three jaws snapping, dynamic aggressive action pose, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and sickly olive green, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 4:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`elite_cerberus_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 4:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **2048 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1300 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Cerberus as a huge three-headed hellhound caked in filthy mud, three heads with red eyes, matted black fur, enormous claws, a bloated greedy belly, crouching low with its heads pulled back and hackles raised, recoiling and bracing against an incoming blow, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and sickly olive green, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 4:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

### Pluto (`elite_plutus`) · Corpóreo · Círculo 4

**`elite_plutus_body_idle`** — Pose padrão

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Plutus as a bloated wolf-headed demon standing upright, a swollen belly, clawed hands clutching tarnished coins, growling with coins clutched to its chest, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and tarnished oxidized brass, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`elite_plutus_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 2:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **2732 × 4096 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Plutus as a bloated wolf-headed demon standing upright, a swollen belly, clawed hands clutching tarnished coins, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: limbs held slightly away from the body, no limb overlapping the torso or another limb, weapons and held objects clearly apart from the body, clearly readable joints, calm neutral stance, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and tarnished oxidized brass, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`elite_plutus_body_attack`** — Ataque

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Plutus as a bloated wolf-headed demon standing upright, a swollen belly, clawed hands clutching tarnished coins, jaws gaping wide in a deafening howl that blasts forward, dynamic aggressive action pose, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and tarnished oxidized brass, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`elite_plutus_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Plutus as a bloated wolf-headed demon standing upright, a swollen belly, clawed hands clutching tarnished coins, hunched and clutching its coins to its chest, recoiling and bracing against an incoming blow, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and tarnished oxidized brass, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

### Flégias (`elite_phlegyas`) · Corpóreo · Círculo 5

**`elite_phlegyas_body_idle`** — Pose padrão

> **Gerar:** `--ar 4:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **2048 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1300 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Phlegyas the furious boatman of the Styx, a wild-haired raging demon standing in a small rotten boat, a heavy oar, the oar held ready, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and muddy dark red, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 4:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`elite_phlegyas_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 4:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **4096 × 3072 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Phlegyas the furious boatman of the Styx, a wild-haired raging demon standing in a small rotten boat, a heavy oar, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: the oar held out to the side and clear of the body, the boat drawn as a separate shape below him, clearly readable joints, calm neutral stance, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and muddy dark red, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 4:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`elite_phlegyas_body_attack`** — Ataque

> **Gerar:** `--ar 4:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **2048 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1300 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Phlegyas the furious boatman of the Styx, a wild-haired raging demon standing in a small rotten boat, a heavy oar, swinging the heavy oar overhead in a smashing blow, dynamic aggressive action pose, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and muddy dark red, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 4:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`elite_phlegyas_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 4:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **2048 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1300 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Phlegyas the furious boatman of the Styx, a wild-haired raging demon standing in a small rotten boat, a heavy oar, bracing in the rocking boat with the oar held crosswise, recoiling and bracing against an incoming blow, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and muddy dark red, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 4:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

### Medusa (`elite_medusa`) · Corpóreo · elite do Círculo 6

**`elite_medusa_body_idle`** — Pose padrão

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Medusa the Gorgon as a terrible gaunt winged woman with a crown of living hissing serpents for hair, pale glowing eyes, scaled bronze claws, tattered dark robes covering her body, non-sexualized, a petrifying stare, stone dust crumbling at her feet, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and ember orange, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, nude, breasts
```

**`elite_medusa_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 2:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **2732 × 4096 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Medusa the Gorgon as a terrible gaunt winged woman with a crown of living hissing serpents for hair, pale glowing eyes, scaled bronze claws, tattered dark robes covering her body, non-sexualized, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: wings spread and clear of the body, arms held apart, serpent hair kept compact around the head, clearly readable joints, calm neutral stance, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and ember orange, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, nude, breasts, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`elite_medusa_body_attack`** — Ataque

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Medusa the Gorgon as a terrible gaunt winged woman with a crown of living hissing serpents for hair, pale glowing eyes, scaled bronze claws, tattered dark robes covering her body, non-sexualized, thrusting her head forward with eyes blazing pale and her serpent hair striking outward, dynamic aggressive action pose, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and ember orange, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, nude, breasts
```

**`elite_medusa_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Medusa the Gorgon as a terrible gaunt winged woman with a crown of living hissing serpents for hair, pale glowing eyes, scaled bronze claws, tattered dark robes covering her body, non-sexualized, raising her scaled claws and wings to cover her face, recoiling and bracing against an incoming blow, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and ember orange, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, nude, breasts
```

### Fúria (escolta da Medusa) (`elite_fury`) · Corpóreo · Círculo 6

> Gere uma Fúria e varie no motor (cor e escala), ou gere três variações com o mesmo prompt.

**`elite_fury_body_idle`** — Pose padrão

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, one of the three Furies from Dante's Inferno, a gaunt blood-stained winged woman with serpents for hair and green water-snakes coiled around her waist, tattered bat-like wings, ragged robes, non-sexualized, tearing at her own ragged robes with long claws, screaming, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and ember orange, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, nude, breasts
```

**`elite_fury_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 2:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **2732 × 4096 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, one of the three Furies from Dante's Inferno, a gaunt blood-stained winged woman with serpents for hair and green water-snakes coiled around her waist, tattered bat-like wings, ragged robes, non-sexualized, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: wings spread and clear of the body, arms held apart, clearly readable joints, calm neutral stance, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and ember orange, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, nude, breasts, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`elite_fury_body_attack`** — Ataque

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, one of the three Furies from Dante's Inferno, a gaunt blood-stained winged woman with serpents for hair and green water-snakes coiled around her waist, tattered bat-like wings, ragged robes, non-sexualized, shrieking forward with claws raking the air, dynamic aggressive action pose, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and ember orange, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, nude, breasts
```

**`elite_fury_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, one of the three Furies from Dante's Inferno, a gaunt blood-stained winged woman with serpents for hair and green water-snakes coiled around her waist, tattered bat-like wings, ragged robes, non-sexualized, wrapping her tattered wings around herself, hissing, recoiling and bracing against an incoming blow, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and ember orange, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, nude, breasts
```

### Minotauro (`elite_minotaur`) · Corpóreo · Círculo 7

**`elite_minotaur_body_idle`** — Pose padrão

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, the Minotaur as a colossal bull-headed brute, blood-soaked, chained wrists, a massive crude axe, horns lowered, ready to charge, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and deep crimson, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`elite_minotaur_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 2:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **2732 × 4096 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, the Minotaur as a colossal bull-headed brute, blood-soaked, chained wrists, a massive crude axe, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: limbs held slightly away from the body, no limb overlapping the torso or another limb, weapons and held objects clearly apart from the body, clearly readable joints, calm neutral stance, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and deep crimson, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`elite_minotaur_body_attack`** — Ataque

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, the Minotaur as a colossal bull-headed brute, blood-soaked, chained wrists, a massive crude axe, swinging the massive axe down in a cleaving blow, dynamic aggressive action pose, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and deep crimson, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`elite_minotaur_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, the Minotaur as a colossal bull-headed brute, blood-soaked, chained wrists, a massive crude axe, lowering its horned head and raising its chained arms as a guard, recoiling and bracing against an incoming blow, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and deep crimson, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

### Malacoda (`elite_malacoda`) · Corpóreo · Círculo 8

**`elite_malacoda_body_idle`** — Pose padrão

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Malacoda, leader of the Malebranche demons, a tall black-skinned winged demon with torn bat wings, a long barbed pitchfork, a leering fanged grin, a crude crown of hooks, the pitchfork planted beside him, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and poison green, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`elite_malacoda_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 2:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **2732 × 4096 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Malacoda, leader of the Malebranche demons, a tall black-skinned winged demon with torn bat wings, a long barbed pitchfork, a leering fanged grin, a crude crown of hooks, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: wings spread and clear of the body, pitchfork held apart, clearly readable joints, calm neutral stance, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and poison green, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`elite_malacoda_body_attack`** — Ataque

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Malacoda, leader of the Malebranche demons, a tall black-skinned winged demon with torn bat wings, a long barbed pitchfork, a leering fanged grin, a crude crown of hooks, stabbing the barbed pitchfork forward, dynamic aggressive action pose, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and poison green, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`elite_malacoda_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **1366 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1700 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure height about 83 percent of the image height, base resting about 6 percent above the bottom edge, Malacoda, leader of the Malebranche demons, a tall black-skinned winged demon with torn bat wings, a long barbed pitchfork, a leering fanged grin, a crude crown of hooks, leaping back with his torn wings flared, recoiling and bracing against an incoming blow, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and poison green, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

### Anteu (`scene_antaeus`) · Corpóreo · cena da transição do Círculo 8

> Anteu aparece só na cena em que desce a companhia ao Cocito (GDD §8). Não luta, então basta a pose padrão.

**`scene_antaeus_body_idle`** — Pose padrão

> **Gerar:** `--ar 1:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA **2048 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1750 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, seen from the waist up, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, colossal giant Antaeus rising from a deep pit, an enormous muscular torso, a primitive face, one gigantic hand reaching down, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and poison green, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 1:1 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

## Chefes de círculo

### Caronte (`boss_charon`) · Corpóreo · Antinferno

**`boss_charon_body_idle`** — Pose padrão

> **Gerar:** `--ar 4:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **2048 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1300 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Charon the demon ferryman of the Acheron, a gaunt ancient old man with a long white beard and wheels of flame around his eyes, standing in a long black rotten boat, a heavy oar, leaning on the oar, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and pale pearl grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 4:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`boss_charon_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 4:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **4096 × 3072 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Charon the demon ferryman of the Acheron, a gaunt ancient old man with a long white beard and wheels of flame around his eyes, standing in a long black rotten boat, a heavy oar, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: the oar held out to the side and clear of the body, the boat drawn as a separate shape below him, clearly readable joints, calm neutral stance, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and pale pearl grey, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 4:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`boss_charon_body_attack`** — Ataque

> **Gerar:** `--ar 4:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **2048 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1300 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Charon the demon ferryman of the Acheron, a gaunt ancient old man with a long white beard and wheels of flame around his eyes, standing in a long black rotten boat, a heavy oar, raising the heavy oar and bringing it down to strike, dynamic aggressive action pose, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and pale pearl grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 4:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`boss_charon_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 4:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **2048 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1300 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Charon the demon ferryman of the Acheron, a gaunt ancient old man with a long white beard and wheels of flame around his eyes, standing in a long black rotten boat, a heavy oar, raising the oar crosswise as the boat rocks, recoiling and bracing against an incoming blow, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and pale pearl grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 4:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

### Asmodeu (`boss_asmodeus`) · Espiritual · Círculo 2

> O GDD v1.1 (P6) tornou Asmodeu **Espiritual**; o prompt já usa o estilo espiritual. A fonte do desenho é o *Dictionnaire Infernal*.

**`boss_asmodeus_body_idle`** — Pose padrão

> **Gerar:** `--ar 4:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **2048 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1300 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Asmodeus the demon king with three heads, a bull head, a crowned human head and a ram head, rooster legs and clawed feet, a serpent tail, a lance with a blank banner, riding a winged infernal dragon, non-sexualized, the dragon's wings half spread, translucent body of smoke and ink, pale inverted linework on black, glowing stormy violet edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and stormy violet, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 4:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, nude, letters
```

**`boss_asmodeus_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 4:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **4096 × 3072 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Asmodeus the demon king with three heads, a bull head, a crowned human head and a ram head, rooster legs and clawed feet, a serpent tail, a lance with a blank banner, riding a winged infernal dragon, non-sexualized, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: the dragon's wings and legs spread and clear, the rider sitting upright with the lance held apart, the three heads clearly separated, clearly readable joints, calm neutral stance, translucent body of smoke and ink, pale inverted linework on black, glowing stormy violet edges, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and stormy violet, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 4:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, nude, letters, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`boss_asmodeus_body_attack`** — Ataque

> **Gerar:** `--ar 4:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **2048 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1300 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Asmodeus the demon king with three heads, a bull head, a crowned human head and a ram head, rooster legs and clawed feet, a serpent tail, a lance with a blank banner, riding a winged infernal dragon, non-sexualized, thrusting the banner lance forward as the dragon breathes a gust of violet smoke, dynamic aggressive action pose, translucent body of smoke and ink, pale inverted linework on black, glowing stormy violet edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and stormy violet, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 4:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, nude, letters
```

**`boss_asmodeus_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 4:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **2048 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1300 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Asmodeus the demon king with three heads, a bull head, a crowned human head and a ram head, rooster legs and clawed feet, a serpent tail, a lance with a blank banner, riding a winged infernal dragon, non-sexualized, the dragon rearing and covering its rider with its wings, recoiling and bracing against an incoming blow, translucent body of smoke and ink, pale inverted linework on black, glowing stormy violet edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and stormy violet, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 4:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, nude, letters
```

### Belzebu (`boss_beelzebub`) · Corpóreo · Círculo 3

**`boss_beelzebub_body_idle`** — Pose padrão

> **Gerar:** `--ar 1:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA **2048 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1750 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Beelzebub the Lord of the Flies as a colossal fly-demon with a skull-and-crossbones pattern on its wings, compound eyes, bristling legs and a dripping proboscis, hovering, surrounded by a dense swarm of flies, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and sickly olive green, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 1:1 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`boss_beelzebub_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 1:1` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **4096 × 4096 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Beelzebub the Lord of the Flies as a colossal fly-demon with a skull-and-crossbones pattern on its wings, compound eyes, bristling legs and a dripping proboscis, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: wings spread wide and clear, legs held apart and not overlapping, no swarm, clearly readable joints, calm neutral stance, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and sickly olive green, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 1:1 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`boss_beelzebub_body_attack`** — Ataque

> **Gerar:** `--ar 1:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA **2048 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1750 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Beelzebub the Lord of the Flies as a colossal fly-demon with a skull-and-crossbones pattern on its wings, compound eyes, bristling legs and a dripping proboscis, diving forward with proboscis and legs extended as the swarm bursts forward, dynamic aggressive action pose, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and sickly olive green, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 1:1 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`boss_beelzebub_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 1:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA **2048 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1750 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Beelzebub the Lord of the Flies as a colossal fly-demon with a skull-and-crossbones pattern on its wings, compound eyes, bristling legs and a dripping proboscis, folding its wings around its body while the swarm thickens into a shield, recoiling and bracing against an incoming blow, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and sickly olive green, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 1:1 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

### Mamom (`boss_mammon`) · Corpóreo · Círculo 4

**`boss_mammon_body_idle`** — Pose padrão

> **Gerar:** `--ar 1:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA **2048 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1750 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Mammon as a colossal demon made of fused tarnished brass coins and heavy chains, a crown of false brass, many grasping hands emerging from its body, hollow eyes leaking coins, seated on a mound of coins, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and tarnished oxidized brass, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 1:1 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, shiny gold
```

**`boss_mammon_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 1:1` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **4096 × 4096 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Mammon as a colossal demon made of fused tarnished brass coins and heavy chains, a crown of false brass, many grasping hands emerging from its body, hollow eyes leaking coins, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: seated upright with the grasping arms held apart, chains hanging free, clearly readable joints, calm neutral stance, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and tarnished oxidized brass, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 1:1 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, shiny gold, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`boss_mammon_body_attack`** — Ataque

> **Gerar:** `--ar 1:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA **2048 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1750 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Mammon as a colossal demon made of fused tarnished brass coins and heavy chains, a crown of false brass, many grasping hands emerging from its body, hollow eyes leaking coins, many hands lunging forward from its body to grasp, dynamic aggressive action pose, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and tarnished oxidized brass, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 1:1 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, shiny gold
```

**`boss_mammon_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 1:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA **2048 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1750 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Mammon as a colossal demon made of fused tarnished brass coins and heavy chains, a crown of false brass, many grasping hands emerging from its body, hollow eyes leaking coins, chains wrapping around its body like armor as coins pile up into a wall, recoiling and bracing against an incoming blow, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and tarnished oxidized brass, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 1:1 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, shiny gold
```

### Belfegor (`boss_belphegor`) · Corpóreo · Círculo 5

**`boss_belphegor_body_idle`** — Pose padrão

> **Gerar:** `--ar 1:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA **2048 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1750 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Belphegor the demon of sloth as a huge bloated horned demon on a throne of black mud, long curved horns, a thick tail, slumped asleep, heavy-lidded eyes half closed, mud slowly swallowing his limbs, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and muddy dark red, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 1:1 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, toilet
```

**`boss_belphegor_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 1:1` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **4096 × 4096 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Belphegor the demon of sloth as a huge bloated horned demon on a throne of black mud, long curved horns, a thick tail, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: seated upright with arms resting apart on the throne, tail laid to the side, clearly readable joints, calm neutral stance, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and muddy dark red, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 1:1 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, toilet, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`boss_belphegor_body_attack`** — Ataque

> **Gerar:** `--ar 1:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA **2048 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1750 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Belphegor the demon of sloth as a huge bloated horned demon on a throne of black mud, long curved horns, a thick tail, waking in sudden fury with eyes wide, swinging a massive arm up out of the mud, dynamic aggressive action pose, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and muddy dark red, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 1:1 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, toilet
```

**`boss_belphegor_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 1:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA **2048 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1750 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Belphegor the demon of sloth as a huge bloated horned demon on a throne of black mud, long curved horns, a thick tail, sinking deeper into the mud throne with arms crossed, half asleep, recoiling and bracing against an incoming blow, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and muddy dark red, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 1:1 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, toilet
```

### Belial (`boss_belial`) · Espiritual · Círculo 6

**`boss_belial_body_idle`** — Pose padrão

> **Gerar:** `--ar 4:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **2048 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1300 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Belial as two disturbingly beautiful fallen angels with cold empty eyes standing together in a chariot of fire, dark ornate robes, black wings, a cracked inverted scepter, flames trailing behind the chariot, translucent body of smoke and ink, pale inverted linework on black, glowing ember orange edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and ember orange, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 4:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, white feathered wings
```

**`boss_belial_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 4:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **4096 × 3072 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Belial as two disturbingly beautiful fallen angels with cold empty eyes standing together in a chariot of fire, dark ornate robes, black wings, a cracked inverted scepter, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: the two figures standing slightly apart, wings spread and clear, the chariot drawn as a separate shape, clearly readable joints, calm neutral stance, translucent body of smoke and ink, pale inverted linework on black, glowing ember orange edges, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and ember orange, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 4:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, white feathered wings, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`boss_belial_body_attack`** — Ataque

> **Gerar:** `--ar 4:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **2048 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1300 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Belial as two disturbingly beautiful fallen angels with cold empty eyes standing together in a chariot of fire, dark ornate robes, black wings, a cracked inverted scepter, both figures raising the cracked inverted scepter as fire lashes forward from the chariot, dynamic aggressive action pose, translucent body of smoke and ink, pale inverted linework on black, glowing ember orange edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and ember orange, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 4:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, white feathered wings
```

**`boss_belial_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 4:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **2048 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1300 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Belial as two disturbingly beautiful fallen angels with cold empty eyes standing together in a chariot of fire, dark ornate robes, black wings, a cracked inverted scepter, their black wings closing around both figures, recoiling and bracing against an incoming blow, translucent body of smoke and ink, pale inverted linework on black, glowing ember orange edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and ember orange, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 4:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, white feathered wings
```

### Moloque (`boss_moloch`) · Corpóreo · Círculo 7

**`boss_moloch_body_idle`** — Pose padrão

> **Gerar:** `--ar 1:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA **2048 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1750 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Moloch as a colossal hollow bronze idol with a bull head and a roaring furnace inside its open belly, cracked metal glowing red-hot, no victims shown, arms outstretched, smoke pouring from its nostrils, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and deep crimson, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 1:1 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, children, infants, babies, victims
```

**`boss_moloch_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 1:1` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **4096 × 4096 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Moloch as a colossal hollow bronze idol with a bull head and a roaring furnace inside its open belly, cracked metal glowing red-hot, no victims shown, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: arms held straight out to the sides, clear of the body, clearly readable joints, calm neutral stance, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and deep crimson, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 1:1 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, children, infants, babies, victims, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`boss_moloch_body_attack`** — Ataque

> **Gerar:** `--ar 1:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA **2048 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1750 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Moloch as a colossal hollow bronze idol with a bull head and a roaring furnace inside its open belly, cracked metal glowing red-hot, no victims shown, its bronze arms swinging forward as a blast of fire bursts from its belly, dynamic aggressive action pose, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and deep crimson, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 1:1 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, children, infants, babies, victims
```

**`boss_moloch_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 1:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA **2048 × 2048 px**, 72 ppi, sRGB · figura com **≈ 1750 px** de altura, base a **128 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Moloch as a colossal hollow bronze idol with a bull head and a roaring furnace inside its open belly, cracked metal glowing red-hot, no victims shown, its bronze arms folding across the furnace, the metal glowing, recoiling and bracing against an incoming blow, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and deep crimson, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 1:1 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, children, infants, babies, victims
```

### Azazel (`boss_azazel`) · Espiritual · Círculo 8

> O GDD v1.1 (P6) tornou Azazel **Espiritual**; o prompt já usa o estilo espiritual. Para a pista visual do Azazel verdadeiro, o motor muda um detalhe (por exemplo, o brilho do espelho).

**`boss_azazel_body_idle`** — Pose padrão

> **Gerar:** `--ar 4:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **2048 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1300 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Azazel the fallen Watcher as a tall goat-headed fallen angel with long curved horns, great dark wings, forged weapons and smithing tools hanging from his belt, a cloak of porcelain masks, holding a mirror and a dagger, translucent body of smoke and ink, pale inverted linework on black, glowing poison green edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and poison green, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 4:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`boss_azazel_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 4:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **4096 × 3072 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Azazel the fallen Watcher as a tall goat-headed fallen angel with long curved horns, great dark wings, forged weapons and smithing tools hanging from his belt, a cloak of porcelain masks, neutral rigging pose for 2D skeletal animation in strict side profile view facing left: wings spread and clear of the body, mirror and dagger held apart, clearly readable joints, calm neutral stance, translucent body of smoke and ink, pale inverted linework on black, glowing poison green edges, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and poison green, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 4:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`boss_azazel_body_attack`** — Ataque

> **Gerar:** `--ar 4:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **2048 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1300 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Azazel the fallen Watcher as a tall goat-headed fallen angel with long curved horns, great dark wings, forged weapons and smithing tools hanging from his belt, a cloak of porcelain masks, lunging with the dagger as the mirror flashes, dynamic aggressive action pose, translucent body of smoke and ink, pale inverted linework on black, glowing poison green edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and poison green, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 4:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`boss_azazel_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 4:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **2048 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1300 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Azazel the fallen Watcher as a tall goat-headed fallen angel with long curved horns, great dark wings, forged weapons and smithing tools hanging from his belt, a cloak of porcelain masks, the cloak of porcelain masks wrapping around him, wings folded, recoiling and bracing against an incoming blow, translucent body of smoke and ink, pale inverted linework on black, glowing poison green edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and poison green, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 4:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

### Lúcifer (`boss_lucifer`) · Corpóreo · Círculo 9

> Visto de frente, como na Direção de Arte. As fases do chefe (prisão do Peregrino, faces silenciadas, São Miguel) são montadas pelo motor sobre estas imagens.

**`boss_lucifer_body_idle`** — Pose padrão

> **Gerar:** `--ar 4:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **2048 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1300 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Lucifer as described by Dante, a colossal fallen angel frozen waist-deep in a lake of ice, three faces on one head, the central face red, the right face pale yellowish white, the left face black, six huge bat-like wings, tears and bloody foam running down his three chins, each mouth chewing a struggling sinner, the wings beating to create freezing wind, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and icy pale blue, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, front view --ar 4:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, feathered wings
```

**`boss_lucifer_rig_base`** — Pose neutra para o rig

> **Gerar:** `--ar 4:3` + Upscale 2× (o maior tamanho possível)  
> **Matriz:** PNG RGBA **4096 × 3072 px**, 72 ppi, sRGB, em `art_source/` (o dobro do tamanho final)  
> **Peças:** recortadas no editor a partir desta imagem e exportadas a **50%**, na escala do `body_idle`, em `rig/`

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Lucifer as described by Dante, a colossal fallen angel frozen waist-deep in a lake of ice, three faces on one head, the central face red, the right face pale yellowish white, the left face black, six huge bat-like wings, tears and bloody foam running down his three chins, neutral rigging pose for 2D skeletal animation in strict front view: the six wings spread symmetrically and clear of each other, arms held apart, the three faces clearly separated, clearly readable joints, calm neutral stance, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, angular blocky shading kept inside each body part, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and icy pale blue, dark blood red, even flat lighting with no cast shadows crossing the joints, no ink splatter, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, front view --ar 4:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, feathered wings, overlapping limbs, crossed arms, dynamic pose, motion blur, heavy shadows
```

**`boss_lucifer_body_attack`** — Ataque

> **Gerar:** `--ar 4:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **2048 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1300 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Lucifer as described by Dante, a colossal fallen angel frozen waist-deep in a lake of ice, three faces on one head, the central face red, the right face pale yellowish white, the left face black, six huge bat-like wings, tears and bloody foam running down his three chins, all six wings beating forward in a blast of freezing wind while the three mouths roar, dynamic aggressive action pose, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and icy pale blue, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, front view --ar 4:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, feathered wings
```

**`boss_lucifer_body_defend`** — Defesa / golpe recebido

> **Gerar:** `--ar 4:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA **2048 × 1536 px**, 72 ppi, sRGB · figura com **≈ 1300 px** de altura, base a **96 px** da borda inferior · fundo cinza removido

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, figure filling about 85 percent of the image height, base resting about 6 percent above the bottom edge, Lucifer as described by Dante, a colossal fallen angel frozen waist-deep in a lake of ice, three faces on one head, the central face red, the right face pale yellowish white, the left face black, six huge bat-like wings, tears and bloody foam running down his three chins, the six wings folding forward around his body like a frozen shell, recoiling and bracing against an incoming blow, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and icy pale blue, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, front view --ar 4:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, feathered wings
```
