# Prompts da vila e do Mapa do Inferno em pixel (T49, D-485)

**Situação:** prompts reescritos com as decisões de Alan de 18/11/2026 (D-485). As artes são feitas **uma a uma** no PixelLab, cada uma aprovada por Alan antes da próxima, com o custo dito antes.

**Estilo (D-485):**
- O gótico de *Darkest Dungeon* é a referência principal.
- *Blasphemous* entra só como **referência de acabamento em pixel**: pixel nítido, contorno preto, sombra em blocos. Fica de fora o lado contraventor dele: nada grotesco, nada de sangue, nenhuma imagem religiosa profanada ou deformada. As figuras sagradas aparecem com reverência (`writing-guide.md`).

**Montagem da vila (D-485, D-352):**
- Como na vila do *Darkest Dungeon*: os edifícios **de frente**, em **fileira**, com o céu atrás em camada própria e a câmera correndo para os lados.
- A **praça central com a imagem de Nossa Senhora** fica no meio da fileira. É cena: não se toca nela e ela não tem efeito (D-262).
- O chão e a beira do abismo são feitos **no motor**.
- A montagem vista de cima, enviada por Alan, é só referência geral: o lugar de cada coisa e o clima. O desenho de cada edifício segue as imagens dele no Drive (`environments/village/buildings/level_1/day`).
- A Despensa feita só com o prompt, sem imagem de referência, foi a aprovada (D-485). Por isso as próximas também saem só do prompt, com a forma de cada edifício descrita em texto a partir das imagens de Alan.

## 1. Bloco da vila (um edifício por vez)

`create_image_pro`, fundo transparente, paleta do jogo (`docs/fable/piloto-pixel/paleta.json`), imagem de estilo `env_circle_02_t1_mid.png`. Custo: 10 gerações até 256 px de lado.

```text
dark gothic pixel art building, 16-bit style, in the gothic style of Darkest Dungeon, with crisp pixel rendering like Blasphemous but reverent, front view, a single isolated <edifício> of a small fortified medieval monastery village, standing on a flat ground line, warm amber candlelight in the windows, soft light from the left, painted in black, bone and ash grey, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, selective dithering in the shadows, no anti-aliasing, no ground patch, no cast shadow, no people, no gold, no blue night sky, not isometric, not top-down, no gore, no grotesque or profane imagery, no text
```

| Peça | Tela | `<edifício>` (a partir da imagem de Alan) | Estado |
| --- | --- | --- | --- |
| Despensa | 192 × 160 | `stone storehouse with a wide wooden double door, barrels and sacks beside it` | **Aprovada (D-485)** |
| Portão | 192 × 224 | `fortified stone gatehouse with two crenellated towers, a heavy closed wooden gate bound with iron, two burning wall torches, a narrow stone stair going down in front` | |
| Enfermaria | 224 × 144 | `long low stone infirmary with a slate roof, a row of small arched lit windows, a small wooden cross over the plain door, raised herb beds along the front wall` | |
| Casa de Exercícios | 192 × 160 | `small stone house with a tall chimney and an arched wooden door, a low stone wall around a yard with a straw training dummy and a hanging cloth banner` | |
| Jardim e Claustro | 224 × 176 | `square stone cloister with an arcade of pointed arches around a small green garden with a stone well and a wooden pulley frame, candles in the inner arches` | |
| Capela | 160 × 208 | `small stone chapel with two tall lit lancet windows, an arched wooden door with iron studs, a square bell tower with a wooden belfry, an iron bell and a small iron cross on top` | |
| Forja | 192 × 192 | `small stone forge with an open front shed, an anvil on a stump, tools on the wall, a glowing fire in a brick hearth, a tall square chimney, a small iron cross on the gable` | |
| Biblioteca | 128 × 240 | `tall narrow stone tower with tall lit arched windows, crenellated top with a small spire and iron cross, a small stone house with a door at its foot` | |
| Carmelo em ruínas | 192 × 176 | `ruined roofless whitewashed stone convent with a small bell gable, seven dark empty arched windows in a row, cracked walls` | |
| Relicário | 160 × 176 | `small square stone shrine with a low stone dome topped by a stone ball and a small iron cross, an iron grated door, two small lit niches` | |
| Praça central | 224 × 224 | `round paved stone plaza with a weathered stone statue of the Virgin Mary standing in prayer with joined hands, a veil and a simple stone halo, on a stepped pedestal, votive candles and wild flowers at its base` (cena; sem toque) | |
| Céu | 640 × 180 | `pale dawn sky with long streaked clouds, pale amber light on the horizon, painted not flat gold` (fundo, sem transparência) | |

**Fechados no M2** (Capela, Forja, Biblioteca, Carmelo, Relicário): desenhados inteiros, como os outros. O motor os mostra escurecidos, como silhueta, com o aviso de quando abrem (D-459, §10A da Bíblia de Arte). O Carmelo já é uma ruína na história (D-262).

## 2. Bloco do Mapa do Inferno (uma faixa por vez)

O mapa é um **corte do funil visto de lado**, em faixas horizontais empilhadas, como o mapa de Botticelli (D-485). Cada faixa é **uma geração**, e a próxima nasce **colada à anterior**: a faixa de cima entra como contexto e só a parte de baixo é pintada. Assim as bordas se encaixam. Tela de cada faixa: 480 × 120 (o motor amplia 2×, para 960 × 240). Custo: cerca de 25 gerações por faixa.

```text
dark gothic pixel art game map band, 16-bit style, in the gothic style of Darkest Dungeon, with crisp pixel rendering like Blasphemous but reverent, inspired by Botticelli's Map of Hell, one wide horizontal slice of a cross-section of the funnel of Hell seen from the side, <conteúdo da faixa>, steep sloped rock walls of the funnel on both sides, outside the funnel dark earth in cross-section with rock strata and roots, an empty quiet area at the far left inside the band for a medallion, the top and bottom edges continuous and seamless for stacking, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey and <cor do círculo>, selective dithering in the shadows, no anti-aliasing, no separating line between bands, no text, no letters, no numbers, no labels, no flat gold, no frame, no border, no gore
```

| Faixa | Largura do funil (topo → base) | `<conteúdo da faixa>` | `<cor do círculo>` |
| --- | --- | --- | --- |
| 0 · Átrio e a Porta | abertura de quase toda a largura | `the top rim of the abyss: a small fortified monastery village with a chapel bell tower and candlelit windows on the cliff edge at the left under a pale dawn sky, a narrow stair descending from it to a great dark gate carved in the rock at the mouth of the funnel, no storm, no whirlwind` | warm amber |
| 1 · Antinferno | 100% → 95% | `the vestibule: a barren plain with a tattered empty banner on a pole and a crowd of tiny souls running after it, swarms of wasps, the wide black river Acheron crossing the whole band at the bottom with a small ferry boat` | pale pearl grey |
| 2 · Limbo | 95% → 88% | `the first circle: a quiet meadow in eternal dusk, a pale castle with seven walls and seven gates on the right, a small stream around it, tiny robed figures walking in silence` | pale pearl grey |
| 3 · Luxúria (Círculo 2) | 88% → 80% | `the second circle: a howling hurricane filling the whole band, tiny shrouded souls tumbling in a spiral of wind, a stone seat of judgment carved into the left wall` | stormy violet |
| 4 a 10 · Círculos 3 a 9 | estreitando até a ponta | um por vez, com o conteúdo de Dante de cada círculo (a escrever quando chegar a vez; no M2 aparecem bloqueados, escurecidos pelo motor) | a cor de cada círculo (`biblia-de-arte.md`) |

**No motor:** a faixa do círculo atual recebe a lanterna; a luz pálida fica um círculo à frente (D-276); os círculos vencidos acendem; os bloqueados ficam escurecidos, com o aviso (D-459).
