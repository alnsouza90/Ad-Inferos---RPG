# Mapa do Inferno · prompts para o Meta AI (T49, D-505)

**Como funciona:**
1. Alan gera **primeiro o mapa completo** (uma imagem só, vertical). Ele serve de guia de estilo e de forma para todas as faixas.
2. Depois, Alan gera **as 11 faixas, uma por vez, de cima para baixo**. Em cada uma, anexe como referência **o mapa completo** e **a faixa anterior**, para as emendas casarem.
3. Alan escolhe a melhor de cada e envia ao agente.
4. O agente reduz cada faixa para **960 × 240** (proporção 4:1), confere a emenda com a de cima e monta o mapa. Ele mostra a Alan faixa por faixa.

**O estilo é o mesmo da vila, dos interiores e dos guardiões** (D-489, D-495, D-498):
- pixel art no estilo de *Blasphemous* junto com o gótico de *Darkest Dungeon*;
- **sem o lado contraventor** de *Blasphemous*: nada grotesco, nada de sangue, nenhuma nudez, nenhuma imagem sagrada deformada;
- luz âmbar e sombras pesadas, **sem ouro chapado e sem céu azul**.

**O que é o mapa:** o **corte do funil do Inferno visto de lado**, como o *Mapa do Inferno* de Botticelli. Ele vai da vila, no alto, até o gelo do Cocito, no fundo.
- O funil vai **estreitando** a cada faixa, sempre **centrado**.
- Fora do funil: **terra escura com camadas de rocha e raízes**.
- Na tela, o jogador **rola o mapa para cima e para baixo**; cabem duas faixas por tela.

**O que o motor faz (não entra nas imagens):**
- o **medalhão** de cada círculo, numa área vazia à esquerda da faixa;
- a **lanterna** da companhia e a **luz pálida**, um círculo à frente (D-276);
- as faixas **acesas** (abertas) e as **escurecidas com cadeado** (fechadas). No M2 só o Círculo 2 fica aberto; o Átrio, a Porta, o Antinferno e o Limbo aparecem bloqueados, com aviso (D-192, D-459);
- os nomes e os números.

---

## 1. O mapa completo · proporção 9:16

```text
dark gothic pixel art game map, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, inspired by Botticelli's Map of Hell, a complete vertical map of Dante's Hell, a cross-section of the immense funnel of Hell seen from the side from top to bottom, the funnel centered and narrowing evenly from the full width at the top to a narrow point at the bottom, divided into eleven stacked horizontal levels separated by rock ledges, steep sloped rock walls on both sides with jagged ledges and small crumbling paths, outside the funnel dark earth with layered rock strata, cracks and hanging roots, from top to bottom: at the very top a pale amber dawn sky with streaked ash grey clouds and on the right edge of the cliff a small fortified monastery village with a tall gothic cathedral with two spires, a crenellated gate tower at its right and a stone stair zigzagging down the cliff to a great dark gate carved in the rock; the grey vestibule with a tattered empty banner on a pole, a crowd of tiny souls running after it and the wide black river Acheron with a tiny ferry boat and a ferryman with a lantern; the quiet dusk meadow of Limbo with a pale castle with seven walls and a small stream; a howling violet whirlwind of tiny shrouded souls with a stone seat of judgment at the left; a cold rain and hail on foul mud with a three-headed dog seen small; two crowds pushing great round stone weights that crash in the middle; the black marsh of the Styx with a small boat before the red glowing iron walls and towers of the city of Dis; a plain of open stone tombs with low flames inside the walls of Dis; a crimson river with tiny centaurs, a dead wood of thorn trees and a burning sand under falling fire; ten concentric stone ditches with arched bridges and green vapour; and at the bottom point a frozen lake of ice with giants around the rim and a colossal dark winged shape frozen up to its chest, distant, silent and without detail, an empty quiet dark area at the far left of each level for a round medallion, tiny distant figures only, nothing close-up, each level readable from far away with one clear focal point, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey and warm amber with one muted accent colour per level (pearl grey, stormy violet, olive green, greenish brass, muddy dark red, ember orange-red, crimson, poison green and pale ice blue), warm amber light from the left, selective dithering in the shadows, no anti-aliasing --ar 9:16 --no text, letters, numbers, labels, flat gold, blue sky, frame, border, separating line, gore, blood, nudity, grotesque, profane imagery, close-up figures, blur, smooth shading, painterly, 3D, photorealistic, cartoon, watermark
```

---

## 2. As faixas · todas em proporção 4:1

**Cada prompt abaixo está completo:** é só copiar e colar. Todos seguem o mesmo padrão, na mesma ordem:
1. o estilo;
2. a largura do funil;
3. as paredes e a terra de fora;
4. a cena do lugar;
5. a área do medalhão;
6. as emendas;
7. o acabamento do pixel;
8. a paleta, com uma cor de destaque por faixa;
9. a mesma lista do que não pode aparecer.

**Para as faixas se encaixarem:**
- a borda de baixo de cada faixa tem a mesma largura de funil da borda de cima da faixa seguinte;
- ao gerar cada faixa, **anexe o mapa completo e a faixa anterior** como referência.

### Faixa 0 · Átrio e Porta do Inferno

*volta à vila; bloqueada no M2, com aviso*

```text
dark gothic pixel art game map band, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, inspired by Botticelli's Map of Hell, one wide horizontal slice of a cross-section of the immense funnel of Hell seen from the side, the topmost slice of the map: in the upper half a pale amber dawn sky with long streaked ash grey clouds, the sun hidden low behind them, in the lower half the black mouth of the funnel opening across about 100 percent of the width at the bottom edge, steep sloped rock walls on both sides of the funnel with jagged ledges and small crumbling paths, outside the funnel dark earth with layered rock strata, cracks and hanging roots, on the right edge of the cliff a small fortified monastery village fully visible and small, a tall gothic cathedral with two slender spires and a rose window in the middle of it, slate roofs, candlelit amber windows, a low wall, at the right end of the village a crenellated gate tower with a heavy wooden gate and two burning torches, from the gate a narrow stone stair zigzagging down the cliff face to a great dark gate carved into the rock below, framed by a heavy stone arch with worn carvings and two iron braziers, a few dead trees on the cliff edge, a thin mist drifting into the funnel, calm air, no storm, an empty quiet dark area at the far left inside the band for a round medallion, tiny distant figures only, nothing close-up, the scene readable from far away with one clear focal point, the bottom edge continuous and seamless for stacking with the band below, the funnel walls and rock strata matching at the bottom edge, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey and warm amber, warm amber light from the left, selective dithering in the shadows, no anti-aliasing --ar 4:1 --no text, letters, numbers, labels, flat gold, blue sky, frame, border, separating line, gore, blood, nudity, grotesque, profane imagery, close-up figures, blur, smooth shading, painterly, 3D, photorealistic, cartoon, watermark
```

### Faixa 1 · Antinferno e o rio Aqueronte

*bloqueada no M2, com aviso*

```text
dark gothic pixel art game map band, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, inspired by Botticelli's Map of Hell, one wide horizontal slice of a cross-section of the immense funnel of Hell seen from the side, the funnel opening centered spanning about 100 percent of the width at the top edge and narrowing evenly to about 93 percent at the bottom edge, steep sloped rock walls on both sides of the funnel with jagged ledges and small crumbling paths, outside the funnel dark earth with layered rock strata, cracks and hanging roots, inside: the vestibule of Hell, a barren grey plain under a starless haze, a tattered empty banner on a tall pole whipping in the wind, a long crowd of tiny pale souls running after it without rest, small dark swarms of flies and wasps circling above them, near the bottom the wide black river Acheron crossing the whole band with slow oily ripples, on its near bank a crowd of tiny souls waiting, a tiny ferry boat on the water with an old ferryman holding a small lantern, the far bank lost in grey mist, an empty quiet dark area at the far left inside the band for a round medallion, tiny distant figures only, nothing close-up, the scene readable from far away with one clear focal point, the top and bottom edges continuous and seamless for stacking with the bands above and below, the funnel walls and rock strata matching at both edges, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey and pale pearl grey, warm amber light from the left, selective dithering in the shadows, no anti-aliasing --ar 4:1 --no text, letters, numbers, labels, flat gold, blue sky, frame, border, separating line, fire, gore, blood, nudity, grotesque, profane imagery, close-up figures, blur, smooth shading, painterly, 3D, photorealistic, cartoon, watermark
```

### Faixa 2 · Limbo · Círculo 1

*bloqueada no M2, com aviso*

```text
dark gothic pixel art game map band, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, inspired by Botticelli's Map of Hell, one wide horizontal slice of a cross-section of the immense funnel of Hell seen from the side, the funnel opening centered spanning about 93 percent of the width at the top edge and narrowing evenly to about 86 percent at the bottom edge, steep sloped rock walls on both sides of the funnel with jagged ledges and small crumbling paths, outside the funnel dark earth with layered rock strata, cracks and hanging roots, inside: the first circle, a quiet green-grey meadow in eternal dusk, a soft pale glow over the grass, on the right a noble pale castle with seven concentric walls and seven gates, a small clear stream winding around it, tiny robed figures walking in silence on the grass and resting under a few old trees, sad and calm, still air, no fire, no demons, an empty quiet dark area at the far left inside the band for a round medallion, tiny distant figures only, nothing close-up, the scene readable from far away with one clear focal point, the top and bottom edges continuous and seamless for stacking with the bands above and below, the funnel walls and rock strata matching at both edges, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey and pale pearl grey with a hint of faded green, warm amber light from the left, selective dithering in the shadows, no anti-aliasing --ar 4:1 --no text, letters, numbers, labels, flat gold, blue sky, frame, border, separating line, fire, demons, gore, blood, nudity, grotesque, profane imagery, close-up figures, blur, smooth shading, painterly, 3D, photorealistic, cartoon, watermark
```

### Faixa 3 · Luxúria · Círculo 2

*o único aberto no M2: capriche*

```text
dark gothic pixel art game map band, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, inspired by Botticelli's Map of Hell, one wide horizontal slice of a cross-section of the immense funnel of Hell seen from the side, the funnel opening centered spanning about 86 percent of the width at the top edge and narrowing evenly to about 79 percent at the bottom edge, steep sloped rock walls on both sides of the funnel with jagged ledges and small crumbling paths, outside the funnel dark earth with layered rock strata, cracks and hanging roots, inside: the second circle, a howling dark whirlwind filling the whole band in a great spiral, streaks of violet wind and black cloud, tiny shrouded souls in long grey cloths tumbling helplessly in the spiral, never resting, at the left a stone seat of judgment carved into the rock wall with steps, a tiny seated judge with a long coiled tail wrapped around him, a short stone ledge path running from the judgment seat along the left wall into the storm, flashes of pale light inside the clouds, an empty quiet dark area at the far left inside the band for a round medallion, tiny distant figures only, nothing close-up, the scene readable from far away with one clear focal point, the top and bottom edges continuous and seamless for stacking with the bands above and below, the funnel walls and rock strata matching at both edges, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey and stormy violet, warm amber light from the left, selective dithering in the shadows, no anti-aliasing --ar 4:1 --no text, letters, numbers, labels, flat gold, blue sky, frame, border, separating line, gore, blood, nudity, grotesque, profane imagery, close-up figures, blur, smooth shading, painterly, 3D, photorealistic, cartoon, watermark
```

### Faixa 4 · Gula · Círculo 3

*bloqueada no M2*

```text
dark gothic pixel art game map band, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, inspired by Botticelli's Map of Hell, one wide horizontal slice of a cross-section of the immense funnel of Hell seen from the side, the funnel opening centered spanning about 79 percent of the width at the top edge and narrowing evenly to about 72 percent at the bottom edge, steep sloped rock walls on both sides of the funnel with jagged ledges and small crumbling paths, outside the funnel dark earth with layered rock strata, cracks and hanging roots, inside: the third circle, a cold heavy slanting rain mixed with hail and dark snow falling without end on a wide field of foul grey-green mud, tiny souls lying half sunk in the mire, puddles and broken ruined stone arches half buried in the mud, in the middle a huge three-headed dog with a matted mane standing guard, seen small and far, its three heads raised, an empty quiet dark area at the far left inside the band for a round medallion, tiny distant figures only, nothing close-up, the scene readable from far away with one clear focal point, the top and bottom edges continuous and seamless for stacking with the bands above and below, the funnel walls and rock strata matching at both edges, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey and sickly olive green, warm amber light from the left, selective dithering in the shadows, no anti-aliasing --ar 4:1 --no text, letters, numbers, labels, flat gold, blue sky, frame, border, separating line, gore, blood, nudity, grotesque, profane imagery, close-up figures, blur, smooth shading, painterly, 3D, photorealistic, cartoon, watermark
```

### Faixa 5 · Avareza e Prodigalidade · Círculo 4

*bloqueada no M2*

```text
dark gothic pixel art game map band, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, inspired by Botticelli's Map of Hell, one wide horizontal slice of a cross-section of the immense funnel of Hell seen from the side, the funnel opening centered spanning about 72 percent of the width at the top edge and narrowing evenly to about 65 percent at the bottom edge, steep sloped rock walls on both sides of the funnel with jagged ledges and small crumbling paths, outside the funnel dark earth with layered rock strata, cracks and hanging roots, inside: the fourth circle, a wide stony floor with a worn half-circle track, two crowds of tiny souls pushing great heavy round stone weights with their chests along the track from the left and from the right, the two crowds crashing into each other in the middle and turning back, deep grooves in the ground, scattered rubble, at the right a hulking demon guardian with a swollen body watching, seen small, an empty quiet dark area at the far left inside the band for a round medallion, tiny distant figures only, nothing close-up, the scene readable from far away with one clear focal point, the top and bottom edges continuous and seamless for stacking with the bands above and below, the funnel walls and rock strata matching at both edges, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey and oxidized greenish brass, warm amber light from the left, selective dithering in the shadows, no anti-aliasing --ar 4:1 --no text, letters, numbers, labels, flat gold, blue sky, frame, border, separating line, gold, coins, gore, blood, nudity, grotesque, profane imagery, close-up figures, blur, smooth shading, painterly, 3D, photorealistic, cartoon, watermark
```

### Faixa 6 · Ira e Acídia · Círculo 5 e as muralhas de Dite

*bloqueada no M2*

```text
dark gothic pixel art game map band, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, inspired by Botticelli's Map of Hell, one wide horizontal slice of a cross-section of the immense funnel of Hell seen from the side, the funnel opening centered spanning about 65 percent of the width at the top edge and narrowing evenly to about 58 percent at the bottom edge, steep sloped rock walls on both sides of the funnel with jagged ledges and small crumbling paths, outside the funnel dark earth with layered rock strata, cracks and hanging roots, inside: the fifth circle, the black muddy marsh of the Styx filling the band, bubbles rising from the mud, tiny souls struggling and fighting in the mire, a small boat with a lone ferryman crossing the marsh, a tall signal tower with a small fire on the left shore, at the right the high iron walls and towers of the city of Dis rising from the marsh glowing dull red, small dark winged figures on the battlements, an empty quiet dark area at the far left inside the band for a round medallion, tiny distant figures only, nothing close-up, the scene readable from far away with one clear focal point, the top and bottom edges continuous and seamless for stacking with the bands above and below, the funnel walls and rock strata matching at both edges, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey and muddy dark red, warm amber light from the left, selective dithering in the shadows, no anti-aliasing --ar 4:1 --no text, letters, numbers, labels, flat gold, blue sky, frame, border, separating line, gore, blood, nudity, grotesque, profane imagery, close-up figures, blur, smooth shading, painterly, 3D, photorealistic, cartoon, watermark
```

### Faixa 7 · Heresia · Círculo 6

*bloqueada no M2*

```text
dark gothic pixel art game map band, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, inspired by Botticelli's Map of Hell, one wide horizontal slice of a cross-section of the immense funnel of Hell seen from the side, the funnel opening centered spanning about 58 percent of the width at the top edge and narrowing evenly to about 51 percent at the bottom edge, steep sloped rock walls on both sides of the funnel with jagged ledges and small crumbling paths, outside the funnel dark earth with layered rock strata, cracks and hanging roots, inside: the sixth circle within the walls of the city of Dis, a wide plain of open stone tombs in long rows with their heavy lids raised and leaning, low flames rising from inside the tombs, a narrow path between the rows leading to the center, the red iron walls and gate of Dis standing behind, smoke drifting low, an empty quiet dark area at the far left inside the band for a round medallion, tiny distant figures only, nothing close-up, the scene readable from far away with one clear focal point, the top and bottom edges continuous and seamless for stacking with the bands above and below, the funnel walls and rock strata matching at both edges, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey and ember orange-red, warm amber light from the left, selective dithering in the shadows, no anti-aliasing --ar 4:1 --no text, letters, numbers, labels, flat gold, blue sky, frame, border, separating line, bodies, gore, blood, nudity, grotesque, profane imagery, close-up figures, blur, smooth shading, painterly, 3D, photorealistic, cartoon, watermark
```

### Faixa 8 · Violência · Círculo 7

*bloqueada no M2*

```text
dark gothic pixel art game map band, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, inspired by Botticelli's Map of Hell, one wide horizontal slice of a cross-section of the immense funnel of Hell seen from the side, the funnel opening centered spanning about 51 percent of the width at the top edge and narrowing evenly to about 44 percent at the bottom edge, steep sloped rock walls on both sides of the funnel with jagged ledges and small crumbling paths, outside the funnel dark earth with layered rock strata, cracks and hanging roots, inside: the seventh circle in three rings from left to right, a boiling river of dark crimson with rising steam guarded by tiny centaurs with bows on its bank, a dead wood of twisted leafless thorn trees with dark birds with human faces perched in the branches, and a burning desert of pale sand under a slow rain of fire flakes, a waterfall falling into the depth at the center, a horned bull-headed figure standing small at the entrance on the left, an empty quiet dark area at the far left inside the band for a round medallion, tiny distant figures only, nothing close-up, the scene readable from far away with one clear focal point, the top and bottom edges continuous and seamless for stacking with the bands above and below, the funnel walls and rock strata matching at both edges, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey and crimson, warm amber light from the left, selective dithering in the shadows, no anti-aliasing --ar 4:1 --no text, letters, numbers, labels, flat gold, blue sky, frame, border, separating line, blood splatter, bodies, gore, blood, nudity, grotesque, profane imagery, close-up figures, blur, smooth shading, painterly, 3D, photorealistic, cartoon, watermark
```

### Faixa 9 · Fraude · Círculo 8, as Malebolge

*bloqueada no M2*

```text
dark gothic pixel art game map band, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, inspired by Botticelli's Map of Hell, one wide horizontal slice of a cross-section of the immense funnel of Hell seen from the side, the funnel opening centered spanning about 44 percent of the width at the top edge and narrowing evenly to about 37 percent at the bottom edge, steep sloped rock walls on both sides of the funnel with jagged ledges and small crumbling paths, outside the funnel dark earth with layered rock strata, cracks and hanging roots, inside: the eighth circle, ten deep concentric stone ditches seen in section side by side down to a central well, narrow arched stone bridges crossing over the ditches like ribs, faint poisonous green vapour rising from the trenches, tiny figures walking in the ditches, a winged monster with a man's face and a long serpent tail climbing the left wall, seen small, two dark stone towers of giants at the bottom edge of the central well, an empty quiet dark area at the far left inside the band for a round medallion, tiny distant figures only, nothing close-up, the scene readable from far away with one clear focal point, the top and bottom edges continuous and seamless for stacking with the bands above and below, the funnel walls and rock strata matching at both edges, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey and poison green, warm amber light from the left, selective dithering in the shadows, no anti-aliasing --ar 4:1 --no text, letters, numbers, labels, flat gold, blue sky, frame, border, separating line, bodies, gore, blood, nudity, grotesque, profane imagery, close-up figures, blur, smooth shading, painterly, 3D, photorealistic, cartoon, watermark
```

### Faixa 10 · Traição · Círculo 9, o Cocito

*o fundo do funil; bloqueada no M2*

```text
dark gothic pixel art game map band, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, inspired by Botticelli's Map of Hell, one wide horizontal slice of a cross-section of the immense funnel of Hell seen from the side, the lowest slice of the map: the funnel opening centered spanning about 37 percent of the width at the top edge and closing to a narrow point at the bottom center, the rest of the band filled with dark earth and rock, steep sloped rock walls on both sides of the funnel with jagged ledges and small crumbling paths, outside the funnel dark earth with layered rock strata, cracks and hanging roots, inside: the ninth circle, a frozen lake of grey-white ice in four rings, tiny souls trapped in the ice up to their necks, frost and cracks across the surface, huge giants standing chained around the upper rim seen small, at the very bottom point a colossal dark winged shape frozen in the ice up to its chest, its great wings spread and still, a cold wind blowing up from it, distant, silent and without detail, an empty quiet dark area at the far left inside the band for a round medallion, tiny distant figures only, nothing close-up, the scene readable from far away with one clear focal point, the top edge continuous and seamless with the band above, the funnel walls and rock strata matching at the top edge, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey and white and pale ice blue only at the edges, warm amber light from the left, selective dithering in the shadows, no anti-aliasing --ar 4:1 --no text, letters, numbers, labels, flat gold, blue sky, frame, border, separating line, bright colors, gore, blood, nudity, grotesque, profane imagery, close-up figures, blur, smooth shading, painterly, 3D, photorealistic, cartoon, watermark
```

**Cuidados:**
- **Faixa 0:** a vila fica **à direita**, como na vila aprovada: o Portão na borda direita, com a escada descendo para o abismo (D-488, D-495). A vila é pequena e cabe inteira.
- **Faixa 3 (Círculo 2):** é a que o jogador vê aberta no M2. Vale capricho especial e mais de uma tentativa.
- **Faixa 10:** a figura do fundo é Lúcifer como Dante o descreve (*Inferno* XXXIV), **distante e sem detalhe**, nunca em destaque.
- **Nada de figuras sagradas** no mapa (`writing-guide.md`).
- **Origem (para o Martirológio):** a forma e os lugares são de **Dante** (*Inferno*, cantos I a XXXIV); a imagem do funil em corte é inspirada no *Mapa do Inferno* de **Botticelli** (c. 1485).

---

## 3. Depois da geração

- **Alan envia:** o mapa completo primeiro; depois as faixas, de uma a uma ou todas juntas.
- **Conversão:** o agente reduz cada faixa para **960 × 240**, acerta o tamanho do pixel e a paleta do jogo, e confere a emenda com a de cima (a largura do funil e as camadas de rocha precisam casar). Se uma emenda não casar, o agente avisa antes de montar.
- **Montagem no motor:** as 11 faixas empilhadas, com rolagem; o medalhão de cada círculo; a lanterna e a luz pálida; as faixas abertas acesas e as fechadas escurecidas com cadeado e aviso; o Átrio no alto, para voltar à vila.
- **Aprovação:** o agente mostra a Alan faixa por faixa, e depois o mapa montado na tela.
