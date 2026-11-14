# Prompts para testar o M2 em pixel art

Versão 1.0 · 14/11/2026 · consultor convidado · **proposta de teste**. Acompanha `05-pixel-art.md`.

Cobre tudo o que a fatia do M2 usa: os 3 santos, os 7 inimigos da família A, Minos, Vertigem, Asmodeu, o Círculo 2, o Pouso, a interface, os ícones, os efeitos, a vila mínima e o Prólogo.

## 0. Como usar

**Duas ferramentas, dois jeitos de pedir.**

| Ferramenta | Serve para | Como pedir |
| --- | --- | --- |
| **Meta AI** (onde saíram os seus três testes) | O **desenho** do personagem, retratos, pranchas, telas de passagem | O prompt longo, completo, de cada bloco |
| **PixelLab** | O **sprite de jogo** na grade real, as **animações**, objetos pequenos, ícones | Uma **descrição curta** (linha "PixelLab") mais o tamanho. Se a ferramenta aceitar imagem de referência, use a do Meta AI |

**Fluxo sugerido por personagem:** desenho no Meta AI → você aprova → sprite no PixelLab com o desenho como referência → animações no PixelLab a partir do sprite.

**Tamanhos** (tela interna de 640 × 360; ver `05-pixel-art.md` §3): santo 112 de altura em tela de 128 · inimigo comum 96 a 120 · Enxame 48 · elite até 150 · Asmodeu cerca de 200 em tela de 256 · retrato 48 × 64 · ícone 16 ou 24.

**Eu não testei estes prompts**: o PixelLab não está conectado nesta sessão, e os nomes exatos dos parâmetros dele precisam ser conferidos na ferramenta. Os prompts longos seguem o formato do que você aprovou no Meta AI, com as correções do §2 da análise.

**O que mudei em relação ao seu prompt de exemplo, e por quê:**

| Acrescentei | Motivo |
| --- | --- |
| `a single consistent pixel size across the whole figure` | O crucifixo de Teresinha saiu mais fino que o resto |
| `no ground shadow`, `no floating particles` | Sombra e pétalas vieram desenhadas na imagem |
| `no blood stains, no blood on clothes` | Jorge veio com sangue na saia e no escudo |
| `dark bronze, not gold` e `gold` no negativo | A couraça veio dourada; o ouro é só da graça |
| `a thin warm amber rim light of single pixels along the back edge` | O hábito preto de Bento some no escuro |

---

## 1. Blocos comuns

Os prompts abaixo já vêm completos. Estes blocos servem para você montar os que estão em tabela.

**[SPRITE] estilo de sprite de personagem**

```text
dark gothic pixel art, 16-bit style game sprite, in the style of Blasphemous with the grim mood of Darkest Dungeon, full body side view, a single consistent pixel size across the whole figure, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited palette of about 24 muted desaturated colors, selective dithering only in the shadows, no anti-aliasing, isolated on a plain flat solid light grey background, no ground shadow, no scenery
```

**[SANTO] acréscimo para santos**

```text
a thin warm amber rim light of single pixels along the back edge of the figure, no blood stains, no blood on clothes, facing right --ar 2:3 --no halo, gold, golden armor, blood stains, blood splatter, ground shadow, floating particles, extra props, mixed pixel sizes, tiny fine details, blur, smooth shading, anti-aliasing, gradient, painterly, 3D, photorealistic, vector, cartoon, chibi, anime, text, letters, UI, watermark
```

**[INIMIGO] acréscimo para inimigos**

```text
palette of black, bone, ash grey and dark blood red only, facing left --ar 2:3 --no gold, halo, bright colors, glowing colored outline, ground shadow, floating particles, mixed pixel sizes, blur, smooth shading, anti-aliasing, gradient, painterly, 3D, photorealistic, vector, cartoon, cute, chibi, anime, text, letters, UI, watermark
```

**[ESPIRITUAL] trocar no inimigo de fumaça**

```text
body made of smoke and flowing ink, drawn with a pale bone-white outline instead of black, ragged dissolving edges
```

**[FOLHA] folha de poses do mesmo personagem**

```text
pixel art sprite sheet, six poses of the same character in a single horizontal row, identical proportions, identical colors and identical pixel size in every pose, all feet on the same ground line, evenly spaced, each pose fully separated from the next
```

---

## 2. Os três santos

A descrição de cada santo repete o que já está nas suas folhas. **Bento com ou sem capuz é escolha sua**: o corpo em tinta estava sem, o teste de pixel veio com. Escrevi sem, com o corvo no ombro, como na folha original.

### 2.1 São Jorge · parado

```text
dark gothic pixel art, 16-bit style game sprite, in the style of Blasphemous with the grim mood of Darkest Dungeon, full body side view, Saint George as a young Roman military officer of the late 3rd century, beardless with short curly hair, dark bronze muscle cuirass with pteruges, not gold, clean red paludamentum cloak hanging behind him, Roman military boots, long spear held low ready to strike, round shield bearing a plain clean red cross, broad heroic silhouette, determined resolute expression, a single consistent pixel size across the whole figure, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited palette of about 24 muted desaturated colors, dark bronze, bone, ash grey, black and deep red, selective dithering only in the shadows, no anti-aliasing, a thin warm amber rim light of single pixels along the back edge of the figure, no blood stains, no blood on clothes, isolated on a plain flat solid light grey background, no ground shadow, no scenery, facing right --ar 2:3 --no halo, gold, golden armor, blood stains, blood splatter, dripping cross, torn bloody cloak, ground shadow, floating particles, mixed pixel sizes, tiny fine details, blur, smooth shading, anti-aliasing, gradient, painterly, 3D, photorealistic, vector, cartoon, chibi, anime, text, letters, UI, watermark
```

**PixelLab** · tela 128 × 128, vista lateral, virado para a direita:
`Saint George, young beardless Roman officer with short curly hair, dark bronze muscle cuirass, red cloak, long spear held low, round shield with a plain red cross, grim dark gothic, muted colors, black outline`

### 2.2 Santa Teresinha · parada

```text
dark gothic pixel art, 16-bit style game sprite, in the style of Blasphemous with the grim mood of Darkest Dungeon, full body side view, Saint Therese of Lisieux as a young 19th-century Carmelite nun with a gentle round face, brown habit and scapular, white mantle, black veil over white wimple, a simple wooden crucifix wrapped in red roses held against her chest, drawn at the same pixel size as the rest of the figure, one hand extended in blessing, simple confident expression, a single consistent pixel size across the whole figure, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited palette of about 24 muted desaturated colors, brown, bone, ash grey, black and deep rose red, selective dithering only in the shadows, no anti-aliasing, a thin warm amber rim light of single pixels along the back edge of the figure, isolated on a plain flat solid light grey background, no ground shadow, no falling petals, no scenery, facing right --ar 2:3 --no halo, gold, falling petals, floating particles, ground shadow, blood, mixed pixel sizes, tiny fine details, blur, smooth shading, anti-aliasing, gradient, painterly, 3D, photorealistic, vector, cartoon, chibi, anime, text, letters, UI, watermark
```

**PixelLab** · tela 128 × 128 (figura um pouco mais baixa que a de Jorge):
`Saint Therese of Lisieux, young Carmelite nun, brown habit, white mantle, black veil, holding a wooden crucifix wrapped in red roses, one hand raised in blessing, grim dark gothic, muted colors, black outline`

### 2.3 São Bento · parado

```text
dark gothic pixel art, 16-bit style game sprite, in the style of Blasphemous with the grim mood of Darkest Dungeon, full body side view, Saint Benedict of Nursia as an elderly 6th-century abbot with a long white beard and white hair, black Benedictine habit with the hood down and scapular, abbot's wooden crozier held upright in one hand, the book of the Rule hanging at his belt, a raven perched on his shoulder, serene firm expression, a single consistent pixel size across the whole figure, crisp hard pixel edges, chunky black outlines, the black habit drawn in dark charcoal greys so its folds are readable, heavy black shadows in solid blocks, limited palette of about 24 muted desaturated colors, charcoal, bone, ash grey, black and brown, selective dithering only in the shadows, no anti-aliasing, a thin warm amber rim light of single pixels along the whole back edge of the figure, isolated on a plain flat solid light grey background, no ground shadow, no scenery, facing right --ar 2:3 --no halo, gold, raven on the ground, separate animals, ground shadow, floating particles, blood, mixed pixel sizes, tiny fine details, blur, smooth shading, anti-aliasing, gradient, painterly, 3D, photorealistic, vector, cartoon, chibi, anime, text, letters, UI, watermark
```

**PixelLab** · tela 128 × 128:
`Saint Benedict, elderly abbot with a long white beard, black Benedictine habit in charcoal greys, hood down, wooden crozier held upright, book at his belt, raven on his shoulder, grim dark gothic, muted colors, black outline`

### 2.4 Animações dos santos (PixelLab, a partir do sprite parado)

Uma animação por linha. Texto curto, em inglês, para a ferramenta de animar.

| Clipe | Jorge | Bento | Teresinha |
| --- | --- | --- | --- |
| Parado (4 a 8 quadros) | `standing guard, breathing slowly, cloak moving slightly` | `standing still, breathing slowly, beard and habit moving slightly` | `standing still, breathing gently, mantle moving slightly` |
| Andar (8 quadros) | `walking forward at a steady pace, spear on the shoulder` | `walking slowly, leaning on the crozier` | `walking with small light steps` |
| Preparar | `pulling the spear back, knees bent, about to thrust` | `raising the crozier high with both hands` | `raising the crucifix forward` |
| Golpear | `thrusting the spear forward in a long lunge` | `striking the ground with the crozier` | `extending the open hand forward in blessing` |
| Defender | `crouching behind the raised round shield` | `holding the crozier across the body, bracing` | `clutching the crucifix to the chest, turning the shoulder` |
| Golpe recebido | `recoiling backward from a blow` | `staggering backward from a blow` | `flinching backward from a blow` |
| Queda | `dropping to one knee, then collapsing forward` | `dropping to his knees, leaning on the crozier` | `sinking to her knees, head bowed` |

### 2.5 Folha de poses (alternativa no Meta AI, se o PixelLab não segurar o personagem)

Troque a parte entre `<>` pela descrição do santo, copiada do prompt parado.

```text
dark gothic pixel art sprite sheet, 16-bit style, in the style of Blasphemous with the grim mood of Darkest Dungeon, six poses of the same character in a single horizontal row, <descrição do santo>, pose 1 standing guard, pose 2 winding up to strike, pose 3 striking, pose 4 defending, pose 5 recoiling from a blow, pose 6 fallen on one knee, identical proportions, identical colors and identical pixel size in every pose, all feet on the same ground line, evenly spaced, each pose fully separated, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited palette of about 24 muted desaturated colors, no anti-aliasing, isolated on a plain flat solid light grey background, no ground shadow, facing right --ar 3:1 --no halo, gold, blood stains, ground shadow, floating particles, mixed pixel sizes, overlapping poses, blur, smooth shading, anti-aliasing, gradient, painterly, 3D, photorealistic, cartoon, chibi, anime, text, letters, numbers, UI, watermark
```

### 2.6 Sentados no Pouso

Um por santo, tela 128 × 128, virado para a direita; o motor espelha.

| Santo | PixelLab |
| --- | --- |
| Jorge | `Saint George sitting on a low stone, one knee raised, spear leaning on his shoulder, round shield on the ground, head slightly bowed, lit from the front by a low fire, back in shadow` |
| Bento | `Saint Benedict sitting upright on a low stone, an open book on his knees, crozier planted beside him with a raven on top, lit from the front by a low fire, back in shadow` |
| Teresinha | `Saint Therese sitting on the ground with her habit spread around her, holding the crucifix with roses in her lap, lit from the front by a low fire, back in shadow` |

### 2.7 Retratos (interface e diálogo) · estilo detalhado

Tela final 48 × 64. Gere grande no Meta AI e converta para a grade.

```text
dark gothic pixel art portrait, 16-bit style, in the style of Blasphemous with the grim mood of Darkest Dungeon, head and shoulders, three-quarter view facing right, <descrição do santo>, <expressão>, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows engulfing half the face, limited palette of about 24 muted desaturated colors, selective dithering only in the shadows, no anti-aliasing, isolated on a plain flat solid light grey background --ar 3:4 --no halo, gold, blood, blur, smooth shading, anti-aliasing, gradient, painterly, 3D, photorealistic, cartoon, chibi, anime, text, frame, watermark
```

Três expressões por santo: `determined resolute expression` (padrão) · `anguished exhausted expression, eyes downcast` (Noite Escura) · `serene peaceful expression` (Consolação).

### 2.8 Telas de passagem (milagre) · estilo detalhado

O santo sozinho, meio corpo; o fundo de ouro é do motor.

```text
dark gothic pixel art illustration, 16-bit style, in the style of Blasphemous with the grim mood of Darkest Dungeon, dramatic half-body figure from the waist up, three-quarter view facing right, <descrição do santo>, <gesto do milagre>, drawn only in black and very dark tones like an ink silhouette with a few bone highlights, a single consistent pixel size, crisp hard pixel edges, no anti-aliasing, isolated on a plain flat solid light grey background --ar 4:5 --no halo, gold, rays, glow, background, enemies, blur, smooth shading, gradient, painterly, 3D, photorealistic, cartoon, anime, text, watermark
```

Gestos: Jorge `raising the long spear high with both hands` · Bento `thrusting the crozier forward in command` · Teresinha `opening both hands, roses falling from them`.

---

## 3. Os sete inimigos da família A

Tom neutro; a cor do círculo vem do motor. Virados para a esquerda.

### 3.1 Diabo de Lodo (bruto, corpóreo) · tela 128

```text
dark gothic pixel art, 16-bit style game sprite, in the style of Blasphemous with the grim mood of Darkest Dungeon, full body side view, a hulking hunched mud demon with long dragging arms hanging to the ground and a toothed mouth gaping in its chest, dripping black filth, solid heavy flesh, a single consistent pixel size across the whole figure, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited palette of black, bone, ash grey and dark blood red only, selective dithering only in the shadows, no anti-aliasing, isolated on a plain flat solid light grey background, no ground shadow, no scenery, facing left --ar 2:3 --no gold, halo, bright colors, glowing outline, ground shadow, floating particles, mixed pixel sizes, blur, smooth shading, anti-aliasing, gradient, painterly, 3D, photorealistic, vector, cartoon, cute, chibi, anime, text, letters, UI, watermark
```

**PixelLab:** `hulking hunched mud demon, long arms dragging on the ground, toothed mouth in its chest, dripping black filth, bone and grey, grim dark gothic, black outline, facing left`

### 3.2 Os outros seis

Monte com **[SPRITE] + sujeito + [INIMIGO]**, ou use a linha do PixelLab direto.

| Inimigo | Tela | Sujeito (prompt longo) | PixelLab |
| --- | --- | --- | --- |
| Escaravelho Infernal (guarda, corpóreo) | 112 | `a man-sized infernal beetle standing on its hind legs, a thick cracked carapace raised like a shield, serrated mandibles, hard shell` | `man-sized infernal beetle standing upright, cracked carapace raised like a shield, serrated mandibles, bone and grey, dark gothic, facing left` |
| Moscardo (atirador, corpóreo) | 112 | `a gaunt insect-man hybrid with membranous wings, a long proboscis aimed forward and too many joints, hovering slightly off the ground` | `gaunt insect-man with membranous wings and a long proboscis, hovering, bone and grey, dark gothic, facing left` |
| Sombra do Desejo (corruptor, espiritual) | 128 | `a tall faceless silhouette with many elongated reaching hands drifting outward` + [ESPIRITUAL] | `tall faceless shadow spirit with many long reaching hands, body of smoke, pale white outline, dark gothic, facing left` |
| Sopro Errante (manipulador, espiritual) | 128 | `a swirling whirlwind with screaming faces trapped inside it` + [ESPIRITUAL] | `swirling whirlwind spirit with screaming faces inside, body of smoke, pale white outline, dark gothic` |
| Mãe-Enxame (invocador, corpóreo) | 128 | `a bloated swollen demon covered in open hive-like sores, a few flies drawn on its body` | `bloated swollen demon covered in hive-like sores, bone and grey, grim, dark gothic, facing left` |
| Enxame (invocado) | 64 | `a small pale bloated grub demon the size of a dog, tiny clawed legs, a ring of teeth for a mouth, crouched low, menacing not cute` | `small pale grub demon with a ring of teeth, crouched low, menacing, dark gothic, facing left` |

Na Mãe-Enxame e no Enxame, as moscas em volta ficam **fora** da imagem (o motor desenha).

### 3.3 Animações dos inimigos (PixelLab)

| Clipe | Texto (troque `<quem>` pelo inimigo) |
| --- | --- |
| Parado | Bruto: `<quem> breathing heavily, swaying its weight` · Guarda: `<quem> standing almost still` · Atirador: `<quem> hovering up and down, wings beating` · Espiritual: `<quem> body slowly waving like smoke` · Invocador: `<quem> belly pulsing` |
| Preparar | `<quem> rearing back, about to attack` |
| Golpear | Bruto: `slamming both arms down` · Guarda: `short shove with the carapace` · Atirador: `jerking backward while shooting from the proboscis` · Corruptor: `stretching upward, hands reaching out` · Manipulador: `spinning faster` · Invocador: `convulsing, body opening` |
| Defender | `<quem> hunching and bracing` |
| Golpe recebido | Corpóreo: `recoiling from a blow` · Espiritual: `body tearing sideways and reforming` |
| Queda | Corpóreo: `collapsing into a heap` · Espiritual: `dissolving upward into smoke` |

---

## 4. Elites e chefe do Círculo 2

### 4.1 Minos (guardião) · tela 192, sentado

```text
dark gothic pixel art, 16-bit style game sprite, in the style of Blasphemous with the grim mood of Darkest Dungeon, full body side view, Minos the infernal judge as a towering crowned demonic king seated on a rough stone seat of judgment, an enormous serpent tail coiled many times around his body and the seat, one clawed hand pointing in condemnation, iron crown, solid heavy flesh, a single consistent pixel size across the whole figure, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited palette of black, bone, ash grey, dark blood red and a little stormy violet, selective dithering only in the shadows, no anti-aliasing, isolated on a plain flat solid light grey background, no ground shadow, no scenery, facing left --ar 1:1 --no gold, golden crown, halo, snake head on the tail, second tail, ground shadow, floating particles, mixed pixel sizes, blur, smooth shading, anti-aliasing, gradient, painterly, 3D, photorealistic, vector, cartoon, chibi, anime, text, letters, UI, watermark
```

Animações (ele nunca se levanta, D-219): `tail rising behind him` · `tail whipping forward` · `tail coiling around his body like armor` · `recoiling on the seat` · `slumping on the seat`.

### 4.2 Vertigem (Pecado Encarnado, espiritual) · tela 160

```text
dark gothic pixel art, 16-bit style game sprite, in the style of Blasphemous with the grim mood of Darkest Dungeon, full body side view, Vertigo the incarnate sin of lust, a tall graceful woman-shaped spirit entirely wrapped from neck to feet in long dark flowing veils that cover her whole body, hair streaming upward like smoke, one hand raised with a beckoning finger, calm cruel face, non-sexualized, fully covered, body made of smoke and flowing veils, drawn with a pale bone-white outline instead of black, ragged dissolving edges at the hem, a single consistent pixel size across the whole figure, crisp hard pixel edges, heavy black shadows in solid blocks, limited palette of black, bone, ash grey and stormy violet, selective dithering only in the shadows, no anti-aliasing, isolated on a plain flat solid light grey background, no ground shadow, no scenery, facing left --ar 2:3 --no gold, halo, nude, bare skin, cleavage, lingerie, ground shadow, floating particles, mixed pixel sizes, blur, smooth shading, anti-aliasing, gradient, painterly, 3D, photorealistic, vector, cartoon, chibi, anime, text, letters, UI, watermark
```

Animações: `standing calmly, veils drifting` · `veils lashing forward like ribbons` · `raising one finger, beckoning` (o Encanto) · `wrapping herself in the veils` · `leaping back` · `melting into a pool of smoke`.

### 4.3 Asmodeu (chefe) · tela 256, o teste mais difícil

```text
dark gothic pixel art, 16-bit style large boss sprite, in the style of Blasphemous with the grim mood of Darkest Dungeon, full body side view, Asmodeus the demon king with three heads clearly separated, a bull head, a crowned human head and a ram head, rooster legs with clawed feet, a serpent tail, holding a long lance with a blank tattered banner, riding a winged infernal dragon with its wings half spread, non-sexualized, big simple readable shapes, a single consistent pixel size across the whole figure, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited palette of black, bone, ash grey, dark blood red and stormy violet, selective dithering only in the shadows, no anti-aliasing, isolated on a plain flat solid light grey background, no ground shadow, no scenery, facing left --ar 4:3 --no gold, golden crown, halo, text on the banner, nude, ground shadow, floating particles, smoke breath, mixed pixel sizes, tiny fine details, blur, smooth shading, anti-aliasing, gradient, painterly, 3D, photorealistic, vector, cartoon, chibi, anime, letters, UI, watermark
```

Animações: `dragon breathing slowly, wings shifting` · `dragon rearing up` · `diving forward with the lance` · `dragon opening its mouth wide` (o sopro é efeito à parte) · `wings folding over the rider` · `recoiling` · `collapsing`.

**Sopro de Asmodeu (efeito, 6 quadros):** `pixel art VFX sprite sheet, six frames in a row, a rolling cloud of dark violet smoke growing from left to right, drawn in flat dark shapes with ragged edges, no glow, plain light grey background`.

---

## 5. Cenários do Círculo 2

Cada camada é uma imagem separada. Final: 640 × 360 por tela (o corredor usa 2 ou 3 telas que emendam). A cor é **luz**, não tinta da pedra.

### 5.1 Fundo (a tempestade)

```text
dark gothic pixel art game background, 16-bit style, in the style of Blasphemous with the grim mood of Darkest Dungeon, side view, an endless howling storm sky over a distant broken horizon, huge spiralling clouds, debris and torn cloth whirling far away, painted only in black, ash grey and bone, lit by a dim stormy violet glow from the far distance, a single consistent pixel size, crisp hard pixel edges, large flat dark shapes, selective dithering in the clouds, no anti-aliasing, the lower third very dark and empty --ar 16:9 --no characters, people, creatures, buildings in the foreground, bright colors, saturated purple, warm light, blur, smooth gradient, painterly, 3D, photorealistic, text, UI, watermark
```

### 5.2 Meio (onde a luta acontece)

```text
dark gothic pixel art game background layer, 16-bit style, in the style of Blasphemous with the grim mood of Darkest Dungeon, side view, a wide flat ledge of broken black rock with low ruined stone walls and leaning gothic arches in the distance, the left and right edges drawn so the image can repeat seamlessly, painted only in black, ash grey and bone with faint stormy violet light on the upper edges, a smooth dark band across the middle where characters will stand, a flat empty floor strip along the bottom, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, selective dithering in the shadows, no anti-aliasing, isolated on a plain flat solid light grey background above the rocks --ar 16:9 --no characters, people, creatures, throne, bright colors, saturated purple, warm light, blur, smooth gradient, painterly, 3D, photorealistic, text, UI, watermark
```

### 5.3 As outras camadas e lugares

Monte com o estilo do 5.2, trocando o lugar.

| Peça | Lugar |
| --- | --- |
| Frente (só nos cantos de baixo) | `dead thorn bushes and torn rags of cloth in the two lower corners only, the center empty` |
| Meio com parede (porta e caverna) | `a tall wall of black rock along the back, flat ledge in front` |
| Meio limpo (tenda, relicário, alma) | `a bare flat ledge of black rock with nothing on it` |
| Trecho 2 | `a broken rocky ledge torn by a hurricane, shattered towers leaning in the wind` |
| Trecho 3 | `ruins of a gothic cloister battered by eternal wind, arches leaning, torn curtains frozen in motion` |
| Arena do chefe | `a calm circular platform of black stone inside the eye of a vast storm, ringed by low broken walls` |
| Pouso (sem fogo e sem santos) | `the inside of a shallow cave sheltered from the storm, flat dirt floor, bedrolls against the rock, painted in black and dark brown, lit by warm amber light from the center` |
| Vigília | `a small rock shelter beside a dark gothic gate, flat ground, lit by one small warm amber light` |

### 5.4 Objetos do corredor (PixelLab, peças isoladas)

| Peça | Tela | PixelLab |
| --- | --- | --- |
| Porta | 96 × 128 | `heavy gothic iron-bound wooden door set in black rock, side-scroller prop, dark gothic` |
| Caverna | 128 × 128 | `dark cave mouth in black rock, side-scroller prop, dark gothic` |
| Escada | 128 × 160 | `broken stone stairway going up, side-scroller prop, dark gothic` |
| Passagem | 96 × 128 | `ruined gothic stone archway, open, side-scroller prop, dark gothic` |
| Tenda da Tentação | 128 × 128 | `small dark cloth tent with a warm light inside, torn by wind, dark gothic` |
| Relicário (fechado e aberto) | 48 × 48 | `small ornate iron and wood reliquary casket, closed` / `the same casket, lid open, empty inside` |
| Alma | 64 × 112 | `pale translucent human soul, standing still, sorrowful, body fading at the feet, bone white and grey` |

---

## 6. Interface: a capela às escuras

Ferro forjado, chumbo, vidro apagado. Nenhuma figura dentro do vidro.

**Bloco:**

```text
pixel art game UI asset, 16-bit style, dark gothic, rough black forged iron with rivets, dark smoked glass divided by thick lead lines, no figures and no symbols in the glass, flat colors, crisp hard pixel edges, 1-pixel black outline, palette of black and ash grey, front view, isolated on a plain flat solid light grey background --no people, faces, crosses, text, letters, gold, bright colors, blur, anti-aliasing, gradient, 3D, glossy
```

| Peça | Tela | Descrição (PixelLab, ou junto do bloco) |
| --- | --- | --- |
| Lanceta, 3 estados numa folha | 3 × (24 × 40) | `three identical tall narrow gothic lancet window frames side by side: dark unlit glass, glass faintly lit in pale bone, glass brightly lit in warm amber` |
| Rosácea, 2 estados | 2 × (40 × 40) | `two identical small round gothic rose windows with simple radial tracery: dark unlit glass, every pane lit in flat gold` (aqui o ouro é permitido) |
| Porta-velas | 96 × 24 | `low iron votive candle rack with exactly six short thick unlit candles in a row` |
| Chama da vela, 3 quadros | 3 × (8 × 12) | `three frames of a small candle flame in flat warm amber, slightly different shapes` |
| Arco do retrato | 56 × 72 | `empty pointed gothic arch window frame in forged iron with a small keystone, grey empty center` |
| Moldura quebrada (inimigo) | 96 × 72 | `crooked broken rectangular iron frame, bent and cracked, one corner torn away, grey empty center` |
| Óculo de intenção | 20 × 20 | `small round iron porthole frame, empty dark center` (e uma versão rachada, em vermelho escuro, para o ataque) |
| Painel (9 partes) | 48 × 48 | `square forged iron panel frame with riveted corners, plain dark center, corners and edges designed for nine-slice scaling` |
| Botão | 48 × 16 | `plain rectangular forged iron button, two states: raised and pressed` |
| Gancho do alforje | 16 × 24 | `small iron hook with a little cloth pouch hanging from it` |
| Lanterna do Lume | 24 × 32 | `small iron hanging lantern with glass panes, unlit` (a chama é a mesma peça de 3 quadros, maior) |
| Garra do Domínio, 2 estados | 2 × (16 × 16) | `a broken jagged claw shape: one in dark colored tone gripping, one in dead ash grey open` |

---

## 7. Ícones

16 × 16, salvo os de ação (24 × 24). Um por imagem, ou uma folha por grupo.

**Ação dos santos (linha de osso, como chumbo de vitral, sem preenchimento):**

```text
pixel art icon set, 16-bit style, ten icons in two rows of five, each 24 by 24 pixels, drawn only in bone-white lines 2 pixels thick like the lead lines of stained glass, no fill, on a plain flat very dark grey background, in order: a diagonal spear, a cross with short rays, a drop above an open hand, a halo disk being uncovered by a moving shadow, a shield, an upright flame, a drop falling on a stain, one hand pulling another upward, two bent arrows pointing opposite ways, a cracked shield --no color, gold, text, letters, numbers, gradient, blur, anti-aliasing, 3D
```

Ordem: Golpe, Exorcismo, Cura, Alívio, Amparo, Força, Limpeza, Levantar, Deslocar, Retirar.

**Os outros grupos (PixelLab, um objeto por ícone, `dark gothic pixel art icon, 16x16, black outline`):**

| Grupo | Ícones |
| --- | --- |
| Intenção inimiga (nunca ouro) | `jagged black sword` · `bloodshot eye dripping ink` · `curved claw-shaped arrow` · `cracked demonic shield` · `curled horn blowing black smoke` |
| Provisões | `round loaf of bread with a cross scored on top` · `short candle on an iron holder` · `small glass ampoule of water` · `roll of linen bandages` · `thurible trailing smoke` |
| Recursos | `single candle flame` (Fervor) · `tall wax candle half burned` (Lume) · `small leather alms purse` (Esmolas) |
| Condições | `single drop of blood` · `twisting black veins` · `ink blot over the eyes` · `small shield` · `small upright flame` · `three claw marks` |
| Nós do mapa | `two crossed swords` · `horned demon skull` · `apple coiled by a serpent` · `lantern with a pale flame` · `small reliquary casket` · `small campfire` · `crown of horns` |
| Comuns | `a thread joining two small circles` (Interceder, em ouro) · `two arrows swapping places` (Trocar) · `an hourglass` (Passar) |

---

## 8. Efeitos

Folhas de 6 quadros, cor chapada. Santos: ouro ou branco, **sem contorno**. Inimigos: tinta preta, borda escorrida.

**Bloco da estampa (santos):**

```text
pixel art VFX sprite sheet, six frames in a single horizontal row, <forma> in completely flat <gold | white> with rough chipped edges like a worn woodblock print, <o que muda em cada quadro>, no outline, no gradient, no glow, a single consistent pixel size, each frame centered in its cell, isolated on a plain flat solid dark grey background --no black outline, soft glow, blur, particles, anti-aliasing, 3D, text
```

| Efeito | Forma e quadros |
| --- | --- |
| Cruz (exorcismo de Bento) | `a bold equal-armed cross` · `faint ghost, half printed, full with short rays, full with cracks, breaking into splinters, last splinters` |
| Anel (bênção de Bento) | `a flat elliptical ring lying on the ground seen from the side` · `thin broken, closing, bold with short rays, lifting, narrowing as it rises, small and fading` |
| Pétalas (Teresinha) | `simple flat rose petals falling` · `three dark red at the top, five falling, the lowest turning gold, half gold, all gold spreading, two fading` |
| Escudo (Jorge) | `a round shield with a plain cross` em branco · `small and high, larger and falling, slamming onto a ground line with dust shards, standing bold, fading with gaps, faint outline` |

**Bloco da tinta (inimigos):**

```text
pixel art VFX sprite sheet, six frames in a single horizontal row, <forma> of thick black ink with dripping ragged edges and heavy splatter, a few accents of dark blood red, <como cresce>, wet and irregular, no clean edges, a single consistent pixel size, each frame centered in its cell, isolated on a plain flat solid light grey background --no gold, glow, light rays, clean geometric shapes, blur, anti-aliasing, 3D, text
```

| Efeito | Forma e quadros |
| --- | --- |
| Corte (golpe de corpóreo) | `a diagonal slash` · `thin line, thick slash with red core, splatter, drips running down, fewer drips, fading` |
| Mancha que sobe (espiritual) | `a stain rising from the ground` · `small pool, wider pool, rising tongues, tall jagged column, column thinning, gone` |
| Poça (invocação) | `a pool opening on the ground` · `dot, small pool, wide pool with bubbles, pool bulging upward, pool closing, stain` |
| Vento (Vendaval) | `curved wind lines` em osso e violeta · `one line, three lines, long sweeping lines, lines breaking, short dashes, gone` |

**Peças soltas (PixelLab):**

| Peça | Tela | Descrição |
| --- | --- | --- |
| Poeira e respingo | 8 × (16 × 16) | `eight small pixel art particles: three dust puffs in bone, three angular rock chips in grey, two black ink drops` |
| Auréola: disco | 32 × 32 | `perfectly round flat gold disk, no outline, no shading` |
| Auréola: coberta | 32 × 32 | `flat gold disk one third covered by a black circle sliding in from the right` |
| Auréola: eclipse | 32 × 32 | `solid black disk with a thin flat gold ring around its edge` |
| Raios | 64 × 64 | `straight short rays in flat gold around an empty round center, no outline` |
| Clareira | 96 × 16 | `flat gold ellipse lying on the ground seen from the side, hard edges, a few short rays along the rim` |
| Fogueira, 4 quadros | 4 × (32 × 32) | `small low campfire of crossed logs on a ring of stones, flames in flat warm amber with black outline, four frames, same logs in every frame` |
| Sombra de chão | 48 × 8 | `flat black ellipse, hard edges` (o motor escurece e estica) |

---

## 9. Vila mínima do M2

Sugestão desta troca: edifícios **de frente**, como em Darkest Dungeon. Luz da esquerda, janelas em âmbar.

**Bloco:**

```text
dark gothic pixel art building, 16-bit style, in the style of Blasphemous with the grim mood of Darkest Dungeon, front view, a single isolated <edifício> of a small fortified medieval monastery village, standing on a flat ground line, warm amber candlelight in the windows, soft light from the left, painted in black, bone and ash grey, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, selective dithering in the shadows, no anti-aliasing, isolated on a plain flat solid light grey background, no ground patch, no cast shadow --no people, gold, blue night sky, isometric view, top-down view, ground shadow, blur, gradient, painterly, 3D, photorealistic, text, UI, watermark
```

| Peça | Tela | Edifício |
| --- | --- | --- |
| Despensa | 128 × 112 | `stone storehouse with a wide wooden double door, barrels and sacks beside it` |
| Portão | 128 × 160 | `fortified stone gatehouse with a heavy closed gate, two towers and iron lanterns` |
| Enfermaria | 160 × 96 | `long low stone infirmary with a row of small arched windows and a small cross over the door` |
| Casa de Exercícios | 128 × 128 | `plain two-storey stone retreat house with a cloister arcade on the ground floor` |
| Praça | 96 × 128 | `round paved plaza with a stone statue of a veiled woman in prayer on a pedestal, votive candles at the base` (cena; sem toque) |
| Carmelo em ruínas | 128 × 128 | `ruined roofless stone convent with seven dark empty windows` |
| Céu | 640 × 180 | `pale dawn sky with long streaked clouds, pale amber light on the horizon, painted not flat gold` |
| Chão e beira do abismo | 640 × 180 | `flat stony ground of a cliff top ending in a sheer drop into total darkness on the right` |

**Mapa do Inferno** (640 × 360): `nine dark gothic lancet windows in a row descending from upper left to lower right like a stair, each framed in forged iron, all glass dark and unlit, black background`.

---

## 10. Prólogo: pranchas e retratos (estilo detalhado)

As 16 pranchas e os 5 retratos de `docs/narrative/prologue.md` §5 continuam valendo como **conteúdo**. Para convertê-las, troque o começo e o fim de cada prompt de lá:

- **Começo:** `Dark gothic pixel art illustrated story panel, 16-bit style, in the style of Blasphemous with the grim mood of Darkest Dungeon,`
- **Fim (no lugar do trecho de estilo em tinta):** `a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited palette of about 32 muted desaturated colors, selective dithering in the shadows, no anti-aliasing, the lower third of the image darker for subtitles --ar 16:9 --no text, letters, UI, blur, smooth shading, anti-aliasing, gradient, painterly, 3D, photorealistic, cartoon, anime, watermark`

Três já prontas, para testar o estilo:

**P02 · A selva escura**

```text
Dark gothic pixel art illustrated story panel, 16-bit style, in the style of Blasphemous with the grim mood of Darkest Dungeon, a lone weary 14th-century pilgrim with a hooded cloak and a staff lost in a dark tangled forest at night, gnarled trees and thorny branches closing in on all sides, no path visible, the pilgrim small in the frame looking around in fear, cinematic composition, palette of black, bone, ash grey and dark blood red, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, selective dithering in the shadows, no anti-aliasing, the lower third of the image darker for subtitles --ar 16:9 --no text, letters, UI, animals, beasts, blur, smooth shading, anti-aliasing, gradient, painterly, 3D, photorealistic, cartoon, anime, watermark
```

**P08 · Nossa Senhora** (ultramar e ouro são permitidos aqui)

```text
Dark gothic pixel art illustrated story panel, 16-bit style, in the style of Blasphemous with the grim mood of Darkest Dungeon, reverent iconographic image of the Virgin Mary, veiled, in a deep ultramarine mantle over a dark red dress, gazing downward with grieving compassion, hands open in intercession, surrounded by a soft flat gold radiance, dignified and serene, cinematic composition, palette of black, bone, ultramarine blue and flat gold, a single consistent pixel size, crisp hard pixel edges, heavy black shadows in solid blocks, selective dithering, no anti-aliasing --ar 16:9 --no text, letters, UI, sensual, grotesque, distorted face, blood, tears of blood, blur, smooth shading, anti-aliasing, gradient, painterly, 3D, photorealistic, cartoon, anime, watermark
```

**P16 · O leito**

```text
Dark gothic pixel art illustrated story panel, 16-bit style, in the style of Blasphemous with the grim mood of Darkest Dungeon, a poor 14th-century room at night, a gaunt pale bearded man lying gravely ill in a simple wooden bed, a single candle burning on a stool beside the bed, an elderly woman in a plain dark veil kneeling at the bedside praying with wooden prayer beads, a small wooden cross on the bare wall, long shadows, quiet and heavy atmosphere, cinematic composition, palette of black, bone, ash grey and warm amber candlelight, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, selective dithering in the shadows, no anti-aliasing, the lower third of the image darker for subtitles --ar 16:9 --no text, letters, UI, halo, gold, rosary with crucifix pendant, modern objects, blur, smooth shading, anti-aliasing, gradient, painterly, 3D, photorealistic, cartoon, anime, watermark
```

**Cuidado próprio desta troca:** *Blasphemous* desenha o sagrado de forma grotesca. Nas pranchas de Nossa Senhora, de Santa Luzia e dos santos, mantenha no negativo `grotesque, distorted face, blood, tears of blood` e peça `dignified and serene`.

---

## 11. Conferir em cada imagem

- [ ] Um só tamanho de pixel na figura inteira
- [ ] Nenhum ouro (salvo auréola, rosácea, estampas e a prancha de Nossa Senhora)
- [ ] Nenhum sangue na roupa de santo
- [ ] Nenhuma sombra de chão, pétala ou partícula desenhada na imagem
- [ ] Santo virado para a direita, inimigo para a esquerda
- [ ] Hábito escuro com dobras legíveis e o fio âmbar nas costas
- [ ] Fundo cinza liso, figura inteira dentro do quadro, com margem
- [ ] O mesmo personagem igual em todos os quadros da animação
- [ ] Nenhuma letra ou número

## 12. Por onde começar

As 15 peças do piloto (`05-pixel-art.md` §7), nesta ordem: 2.1, 2.2 e 2.3 · as animações de Jorge (2.4) · 3.1 e a Sombra do Desejo · 4.3 (Asmodeu) · 5.1 e 5.2 · lanceta, rosácea, porta-velas, arco e moldura quebrada (§6) · três ícones de ação · auréola, cruz e corte (§8) · um retrato (2.7) e a prancha P16.
