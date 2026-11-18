# Vila · prompts para o Meta AI (T49, D-488)

**Como funciona:**
1. Alan gera cada peça no Meta AI e escolhe a melhor.
2. O agente recorta e converte para o pixel do jogo, no tamanho da tabela, e monta.
3. Alan aprova peça por peça.

Os prompts saem em **arte de tinta, no estilo do *Darkest Dungeon***, porque é o que o Meta AI faz bem e o que a conversão para pixel preserva. Por isso não pedem pixel art.

**A montagem (D-488):**
- Uma **tela 16:9 só**, sem arrastar, de **frente**, como a vila do *Darkest Dungeon* da imagem de referência.
- Os edifícios ficam em **três fileiras de profundidade**: fundo, meio e frente.
- O chão é **um morro com caminho de terra**; o **céu da aurora** fica atrás.
- A **imagem de Nossa Senhora** fica na frente, no centro.
- O **Portão** fica na **borda direita**, no alto de uma **escada que desce para o abismo**.
- A **Capela vira uma catedral gótica**, a peça central e mais alta, como a abadia do *Darkest Dungeon*. Na regra, continua sendo a Capela (D-488).

---

## 0. Regras para todo edifício

- **Um edifício só**, inteiro, com **margem** dos quatro lados; nada atrás nem do lado.
- **Mesma vista em todos:** de frente, em três quartos, um pouco de cima, como na vila do *Darkest Dungeon*. Não é a vista de cima.
- **Fundo cinza claro liso**, para recortar. Sem céu, sem paisagem, sem pessoas.
- **Luz da esquerda**, janelas em âmbar. **Sem ouro** e sem céu azul.
- O edifício ocupa **cerca de 85% da altura da imagem**. O tamanho final na vila sai da tabela de proporções (§3), e é o agente que ajusta.

---

## 1. Camadas de fundo

### 1.1 Céu · proporção 21:9

```text
Darkest Dungeon style 2D hand-painted gothic illustration, hand-inked comic art, Mike Mignola influence, a wide overcast dawn sky over an abyss, heavy layered clouds drawn with ink hatching, a pale amber glow low on the horizon slightly right of center like a weak sun behind the clouds, the rest of the sky ash grey and dark umber, no buildings, no ground, no mountains, no birds, the left and right edges continuous, palette of black, bone, ash grey and warm amber, thick black ink lines, distressed print texture --ar 21:9 --no flat gold, sun disk, blue sky, buildings, people, text, cartoon, 3D, photorealistic
```

### 1.2 Fundo distante · proporção 21:9

```text
Darkest Dungeon style 2D hand-painted gothic illustration, hand-inked comic art, Mike Mignola influence, a distant dark horizon of jagged cliffs and broken rock spires at the rim of an immense abyss, rising mist, a few bare dead trees in silhouette, all in dark muted silhouette with little detail, the lower part fading into mist, isolated on a plain flat solid light grey background above the silhouettes, palette of black, ash grey and dark umber, thick black ink lines, distressed print texture --ar 21:9 --no buildings, castles, towers, people, sky details, flat gold, blue, text, cartoon, 3D, photorealistic
```

### 1.3 Chão da vila (o morro, sem edifícios) · proporção 16:9

```text
Darkest Dungeon style 2D hand-painted gothic illustration, hand-inked comic art, Mike Mignola influence, the empty ground of a small medieval monastery village seen from the front like the hamlet of Darkest Dungeon, a low rocky hill rising toward the back with three terraces of flat building plots, a worn dirt road winding from the front center up to the top, short stone stairs between the terraces, low dry-stone walls, a few bare dead trees at the left and right edges, a small round paved place in the front center for a statue, at the far right the ground ends at a cliff edge over a dark abyss with a stone stair descending into the darkness, the upper third of the image left as plain flat light grey for the sky to be placed behind, warm amber light from the left, palette of black, bone, ash grey and dark umber, thick black ink outlines, heavy black shadows, distressed print texture --ar 16:9 --no buildings, houses, chapel, towers, statue, people, characters, flat gold, blue, text, UI, cartoon, 3D, photorealistic
```

---

## 2. Edifícios e peças (um por imagem)

**Bloco comum.** Troque `<EDIFÍCIO>` pela descrição de cada peça abaixo:

```text
Darkest Dungeon style 2D hand-painted gothic illustration, hand-inked comic art, Mike Mignola influence, ONE single isolated <EDIFÍCIO> of a small medieval monastery village, three-quarter front view from slightly above like the buildings of the Darkest Dungeon hamlet, the whole building fully visible and centered with empty margin on all four sides, filling about 85 percent of the image height, nothing behind it and nothing beside it, standing on a small patch of dirt ground, warm amber candlelight in the windows, soft light from the left, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and warm amber, ink texture on the building only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal --ar <PROPORÇÃO> --no other buildings, background buildings, walls behind, towers behind, sky, landscape, people, characters, flat gold, blue, cropped edges, top-down view, isometric, parchment background, textured background, vignette, text, cartoon, 3D, photorealistic
```

| # | Peça (prédio do jogo) | Proporção | `<EDIFÍCIO>` |
| --- | --- | --- | --- |
| 1 | **Catedral gótica** (Capela) | 3:4 | `tall gothic stone cathedral, the largest building of the village, a high pointed nave roof of dark slate, a large rose window above a deep pointed portal with heavy wooden doors, two slender bell towers with pointed spires and small iron crosses, flying buttresses and pinnacles, tall lancet windows glowing amber, weathered and old but standing proud` |
| 2 | Biblioteca | 1:2 | `tall narrow stone library tower with tall arched windows glowing amber on three floors, a crenellated top with a small slate spire and an iron cross, a small stone house with a door at its foot` |
| 3 | Jardim e Claustro | 4:3 | `low square stone cloister with a front arcade of pointed gothic arches under a mossy slate roof, through the arches a small green garden with flowers and a round stone well with a wooden pulley frame, candles glowing in the inner arches` |
| 4 | Enfermaria | 3:2 | `long low stone infirmary hall with a slate roof, a row of small arched windows glowing amber, a plain wooden door with a small wooden cross above it, raised stone herb beds with green medicinal plants along the front` |
| 5 | Casa de Exercícios | 1:1 | `small sturdy stone retreat house with a steep slate roof and a tall chimney, an arched wooden door, a low stone wall around a small training yard in front with a straw training dummy and a plain cloth banner on a pole` |
| 6 | Despensa | 6:5 | `sturdy two-storey stone storehouse with a steep slate roof, a wide wooden double loading door bound with iron, small windows glowing amber, wooden barrels and grain sacks stacked beside the door` |
| 7 | Forja | 1:1 | `small stone forge with an open front shed, an iron anvil on a tree stump, tongs and hammers on the wall, a glowing fire in a brick hearth, a tall square stone chimney with a little smoke, a small iron cross on the gable` |
| 8 | Relicário | 1:1 | `small square stone reliquary shrine with a low stone dome topped by a stone ball and a small iron cross, a grated iron door in a stone arch, two small niches with candles` |
| 9 | Carmelo em ruínas | 4:3 | `ruined roofless convent of old whitewashed stone, cracked walls, a small bell gable without its bell, seven dark empty arched windows in a row, broken roof beams, fallen stones and weeds at its foot, quiet and sad, no light inside` |
| 10 | Portão | 3:4 | `fortified stone gatehouse at the edge of a cliff, two crenellated towers joined by a wall with a single heavy closed wooden gate bound with iron, two burning wall torches, a steep stone stair going down from the gate on its right side into darkness` |
| 11 | Imagem de Nossa Senhora | 1:2 | `weathered stone statue of the Virgin Mary standing in prayer with joined hands, a long veil and a simple carved stone halo, serene and gentle face, on a tall stepped stone pedestal, small votive candles and wild flowers at its base, reverent` (em vez de "building", é uma estátua; sem praça redonda, só o pedestal) |

**Cuidados:**
- **Imagem de Nossa Senhora:** com reverência, sem rosto deformado, auréola de pedra (nunca de ouro) e sem azul.
- **Carmelo:** está em ruínas desde o início da história (D-262); a reforma vem no M3.

---

## 3. Proporções e lugar de cada peça na tela (960 × 540)

Altura e largura **finais em pixels**, na conversão. As peças maiores ficam atrás, no alto do morro.

| Peça | Tamanho final (L × A) | Fileira | Lugar |
| --- | --- | --- | --- |
| Catedral gótica | 230 × 300 | fundo | centro, no alto do morro |
| Biblioteca | 90 × 210 | fundo | à esquerda da catedral |
| Carmelo em ruínas | 170 × 130 | fundo | à direita da catedral |
| Jardim e Claustro | 210 × 150 | meio | à esquerda, abaixo da Biblioteca |
| Enfermaria | 190 × 120 | meio | esquerda, perto da borda |
| Despensa | 150 × 130 | meio | à direita do caminho |
| Forja | 150 × 140 | meio | direita |
| Casa de Exercícios | 140 × 130 | frente | esquerda |
| Relicário | 90 × 100 | frente | direita do caminho |
| Imagem de Nossa Senhora | 60 × 140 | frente | centro, sobre a praça redonda do chão |
| Portão | 150 × 190 | meio | borda direita, sobre o penhasco, com a escada descendo para o abismo |

Na montagem, o agente pode mudar um tamanho em até 10%, para as peças se assentarem no chão. Mudança maior volta para Alan.

---

## 4. Depois da geração

- **Alan escolhe e envia:** gere cada peça, escolha a melhor e me envie, de uma a uma ou todas juntas.
- **Conversão:** recorto o fundo cinza (só o que encosta na borda, sem furar paredes claras), converto para pixel no tamanho da tabela e confiro as bordas.
- **Montagem no jogo:** céu, fundo distante e chão do morro, os edifícios por fileira, e a estátua na frente.
- **Feito pelo motor:**
  - a noite cinza-violeta;
  - as janelas acesas;
  - os prédios fechados escurecidos, com o aviso;
  - o sino de novidade.
