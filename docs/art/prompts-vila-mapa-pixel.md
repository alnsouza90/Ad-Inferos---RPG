# Prompts da vila e do Mapa do Inferno · para Alan gerar (T49, D-485, D-486)

**Como funciona agora (D-486):** Alan gera as artes, ao menos como referência, no Meta AI ou no PixelLab. Depois o agente converte para o pixel do jogo, peça por peça, e Alan aprova cada uma.

**O que já está aprovado:** a Despensa (`art_source/environments/village/pixel/village_pantry_l1_px_v01.png`). Ela é a **referência de estilo** para as outras peças: no Meta AI ou no PixelLab, anexe a imagem dela como estilo.

## 0. Regras para toda peça da vila

As regras saem do que deu errado no Portão:
- **Um edifício só**, inteiro dentro da imagem, com **margem dos quatro lados**. Nada cortado nas bordas.
- **Nada atrás nem do lado:** sem outros prédios, muralhas ou torres de fundo, sem paisagem.
- **Fundo cinza claro liso**, para recortar. Sem chão em volta e sem sombra projetada; o chão é feito no motor.
- **De frente**, como na vila do *Darkest Dungeon*: nem visto de cima, nem isométrico.
- **Luz da esquerda**, janelas em âmbar, sem ouro, sem céu azul.
- **Estilo:** o gótico de *Darkest Dungeon*, com o acabamento em pixel de *Blasphemous*, **sem o lado contraventor**: nada grotesco, nada de sangue, nenhuma imagem sagrada deformada.

## 1. Vila · bloco comum

Troque `<EDIFÍCIO>` pela linha da tabela. Proporção indicada em cada peça.

```text
dark gothic pixel art building, 16-bit style, in the gothic style of Darkest Dungeon with crisp pixel rendering like Blasphemous but reverent and calm, front view, ONE single isolated <EDIFÍCIO> of a small fortified medieval monastery village, the whole building fully visible and centered with empty margin on all four sides, nothing behind it and nothing beside it, standing on a thin flat ground line, warm amber candlelight in the windows, soft light from the left, painted in black, bone and ash grey, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, selective dithering in the shadows, no anti-aliasing, isolated on a plain flat solid light grey background --no other buildings, background buildings, walls behind, towers behind, landscape, ground patch, cast shadow, cropped edges, people, gold, blue sky, night sky, isometric, top-down, gore, blood, grotesque, text, watermark
```

| # | Peça | Proporção | `<EDIFÍCIO>` |
| --- | --- | --- | --- |
| 1 | Despensa | — | **aprovada** (usar como estilo) |
| 2 | Portão | 4:5 | `fortified stone gatehouse with two crenellated round towers joined by a wall with a single heavy closed wooden gate bound with iron, two burning wall torches beside the gate, a few stone steps going up to the gate` |
| 3 | Enfermaria | 3:2 | `long low stone infirmary with a slate roof, a row of small arched windows lit amber, a plain wooden door with a small wooden cross above it, raised herb beds with green plants along the front wall` |
| 4 | Casa de Exercícios | 1:1 | `small stone house with a tall chimney and an arched wooden door, a low stone wall around a small yard in front with a straw training dummy and a hanging cloth banner on a pole` |
| 5 | Jardim e Claustro | 4:3 | `square stone cloister seen from the front with an arcade of pointed arches, through the arches a small green garden with a stone well and a wooden pulley frame, candles glowing in the inner arches` |
| 6 | Capela | 3:4 | `small stone chapel with two tall lancet windows lit amber, an arched wooden door with iron studs, a square stone bell tower beside it with a wooden belfry, an iron bell and a small iron cross on top` |
| 7 | Forja | 1:1 | `small stone forge with an open front shed, an anvil on a tree stump, tools hanging on the wall, a glowing fire in a brick hearth, a tall square stone chimney, a small iron cross on the gable` |
| 8 | Biblioteca | 1:2 | `tall narrow stone tower with tall arched windows lit amber, a crenellated top with a small slate spire and an iron cross, a small stone house with a door at its foot` |
| 9 | Carmelo (em ruínas) | 4:3 | `ruined roofless whitewashed stone convent with a small bell gable without bell, seven dark empty arched windows in a row, cracked walls, fallen stones at its foot` |
| 10 | Relicário | 1:1 | `small square stone shrine with a low stone dome topped by a stone ball and a small iron cross, a grated iron door, two small niches with candles` |
| 11 | Praça central | 1:1 | `round paved stone plaza seen from the front at a low angle, in its center a weathered stone statue of the Virgin Mary standing in prayer with joined hands, a veil and a simple stone halo, on a stepped stone pedestal, votive candles and wild flowers at its base, serene and reverent` |
| 12 | Céu (fundo) | 32:9 | (bloco próprio abaixo) |

**Céu** (sem fundo cinza, imagem cheia):

```text
dark gothic pixel art background, 16-bit style, in the gothic style of Darkest Dungeon, a wide pale dawn sky with long streaked clouds drawn with ink hatching, pale amber light low on the horizon, the rest of the sky ash grey, no buildings, no ground, no sun disk, a single consistent pixel size, crisp hard pixel edges, selective dithering, no anti-aliasing --no flat gold, blue sky, text, watermark
```

## 2. Mapa do Inferno · faixas

O teste que funcionou foi o primeiro: **duas faixas geradas numa imagem só**, que por isso se encaixam. Então cada pedido gera **duas faixas empilhadas**, e a de baixo de um pedido repete como a de cima do seguinte. Isso dá a continuidade. A faixa da vila precisa de mais altura, para a vila caber inteira.

**Bloco comum** (proporção 2:1, duas faixas de 4:1 empilhadas):

```text
dark gothic pixel art game map, 16-bit style, in the gothic style of Darkest Dungeon with crisp pixel rendering like Blasphemous but reverent, inspired by Botticelli's Map of Hell, a cross-section of the funnel of Hell seen from the side, made of TWO wide horizontal bands stacked one on top of the other inside one continuous funnel, the funnel walls of steep rock sloping inward evenly so each band is a little narrower than the one above, outside the funnel dark earth in cross-section with rock strata and roots, in each band an empty quiet area at the far left for a round medallion. TOP BAND: <FAIXA DE CIMA>. BOTTOM BAND: <FAIXA DE BAIXO>. The two bands joined without any line between them, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey and <COR>, selective dithering, no anti-aliasing --no text, letters, numbers, labels, flat gold, frame, border, separating line, gore, close-up figures
```

| Pedido | `<FAIXA DE CIMA>` | `<FAIXA DE BAIXO>` | `<COR>` |
| --- | --- | --- | --- |
| A | `the top rim of the abyss under a pale dawn sky: a small fortified monastery village fully visible and small, with a chapel bell tower and candlelit windows on the cliff edge at the left, a narrow stair descending from the village down to a great dark gate carved in the rock at the mouth of the funnel, calm air, no storm, no whirlwind` | `the vestibule of Hell: a barren plain with a tattered empty banner on a pole and a crowd of tiny souls running after it, small swarms of wasps, the wide black river Acheron crossing the band near the bottom with a small ferry boat` | warm amber and pale pearl grey |
| B | (a mesma do vestíbulo, para emendar) | `the first circle, Limbo: a quiet meadow in eternal dusk, a pale castle with seven walls and seven gates on the right, a small stream around it, tiny robed figures walking in silence` | pale pearl grey |
| C | (a mesma do Limbo, para emendar) | `the second circle: a howling hurricane filling the whole band, tiny shrouded souls tumbling in a spiral of wind, a stone seat of judgment carved into the left wall` | stormy violet |
| D em diante | (a de baixo do pedido anterior) | um círculo por vez, de 3 a 9, com o conteúdo de Dante (escrevo quando chegar a vez) | a cor do círculo |

**Na conversão:** o agente corta cada pedido nas duas faixas e usa a de cima de cada pedido para conferir a emenda com o pedido anterior. Depois converte as faixas para o pixel do jogo, numa tela de 480 × 120 por faixa, que o motor amplia 2×.

**No motor:**
- o círculo atual recebe a lanterna;
- a luz pálida fica um círculo à frente (D-276);
- os círculos vencidos acendem;
- os bloqueados ficam escuros, com o aviso (D-459).
