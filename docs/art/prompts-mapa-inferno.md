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
dark gothic pixel art, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, a complete vertical map of Dante's Hell inspired by Botticelli's Map of Hell, a cross-section of the immense funnel of Hell seen from the side from top to bottom, at the very top a pale amber dawn sky and on the right edge of the cliff a small fortified monastery village with a tall gothic cathedral with two spires, a gate tower at its right and a stone stair descending from the gate into the abyss, below it the funnel narrowing evenly in eleven stacked horizontal levels separated by rock ledges: the dark gate carved in the rock, the grey vestibule with a tattered empty banner and the black river Acheron with a tiny ferry boat, the quiet meadow of Limbo with a pale castle with seven walls, a violet howling whirlwind, a cold rain on foul mud with a three-headed dog seen small, two crowds pushing great round weights, the black marsh of the Styx before the red iron walls of the city of Dis, a plain of open burning tombs, a crimson river then a dead wood of thorn trees then a burning sand under falling fire, ten concentric stone ditches with arched bridges and green vapour, and at the bottom point a frozen lake of ice with a colossal dark winged shape frozen up to its chest, distant and silent, outside the funnel dark earth with rock strata and roots on both sides, tiny figures only, nothing close-up, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey and warm amber with one muted accent colour per level, selective dithering, no anti-aliasing --ar 9:16 --no text, letters, numbers, labels, flat gold, blue sky, frame, border, gore, blood, nudity, grotesque, profane imagery, close-up figures, blur, smooth shading, painterly, 3D, photorealistic, watermark
```

---

## 2. As faixas · todas em proporção 4:1

**Para as faixas se encaixarem:**
- **mesma proporção (4:1)** em todas;
- **a largura do funil** vem em cada prompt (em % da largura, na borda de cima e na de baixo), sempre centrado. A borda de baixo de uma faixa tem a mesma largura da borda de cima da seguinte;
- **anexe o mapa completo e a faixa anterior** como referência;
- **área vazia à esquerda**, dentro da faixa, para o medalhão do motor.

**Bloco comum.** Troque `<FUNIL>` e `<CENA>` pelos de cada faixa da tabela abaixo:

```text
dark gothic pixel art game map band, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and solemn, without Blasphemous's grotesque, gory or profane side, inspired by Botticelli's Map of Hell, one wide horizontal slice of a cross-section of the funnel of Hell seen from the side, <FUNIL>, steep sloped rock walls on both sides, inside: <CENA>, outside the funnel dark earth with rock strata and roots, an empty quiet dark area at the far left inside the band for a round medallion, tiny figures only, the top and bottom edges continuous and seamless for stacking with the bands above and below, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, limited muted desaturated palette of black, bone, ash grey and <COR>, selective dithering, no anti-aliasing --ar 4:1 --no text, letters, numbers, labels, flat gold, blue sky, frame, border, separating line, gore, blood, nudity, grotesque, profane imagery, close-up figures, blur, smooth shading, painterly, 3D, photorealistic, watermark
```

| Faixa | Lugar | `<FUNIL>` | `<CENA>` | `<COR>` |
| --- | --- | --- | --- | --- |
| **0** | **Átrio e Porta do Inferno** (volta à vila) | `the topmost slice: a pale amber dawn sky with streaked clouds in the upper half, the black mouth of the funnel opening across about 100 percent of the width at the bottom edge` | `on the right edge of the cliff a small fortified monastery village fully visible and small, with a tall gothic cathedral with two spires, candlelit windows and a gate tower at its right, a stone stair descending from the gate down the cliff to a great dark gate carved in the rock below, calm air` | `warm amber` |
| **1** | **Antinferno** e o rio Aqueronte | `the funnel spanning about 100 percent of the width at the top edge and narrowing evenly to about 93 percent at the bottom edge` | `the vestibule, a barren grey plain, a tattered empty banner on a pole with a crowd of tiny souls running after it, small dark swarms of flies and wasps, the wide black river Acheron crossing the band near the bottom with a tiny ferry boat and its old ferryman holding a lantern` | `pale pearl grey` |
| **2** | **Limbo** (Círculo 1) | `about 93 percent at the top edge narrowing evenly to about 86 percent at the bottom edge` | `the first circle, a quiet meadow in eternal dusk, a pale noble castle with seven walls and seven gates on the right surrounded by a small stream, tiny robed figures walking in silence on the grass, sad and calm, no fire` | `pale pearl grey` |
| **3** | **Luxúria** (Círculo 2) · **o único aberto no M2** | `about 86 percent at the top edge narrowing evenly to about 79 percent at the bottom edge` | `the second circle, a howling dark whirlwind filling the band, tiny shrouded souls tumbling in a spiral of wind, at the left a stone seat of judgment carved into the rock wall with a tiny seated judge with a long coiled tail` | `stormy violet` |
| **4** | **Gula** (Círculo 3) | `about 79 percent at the top edge narrowing evenly to about 72 percent at the bottom edge` | `the third circle, a cold heavy rain and hail falling on a field of foul mud, tiny souls lying in the mire, a huge three-headed dog standing guard in the middle, seen small and far` | `sickly olive green` |
| **5** | **Avareza e Prodigalidade** (Círculo 4) | `about 72 percent at the top edge narrowing evenly to about 65 percent at the bottom edge` | `the fourth circle, two crowds of tiny souls pushing great heavy round stone weights with their chests along a half-circle track and crashing into each other in the middle, a hulking demon guardian watching at the right, seen small` | `oxidized greenish brass` |
| **6** | **Ira e Acídia** (Círculo 5) e as muralhas de Dite | `about 65 percent at the top edge narrowing evenly to about 58 percent at the bottom edge` | `the fifth circle, the black muddy marsh of the Styx filling the band, tiny souls struggling in the mire, a small boat with a ferryman crossing it, at the right the high iron walls and towers of the city of Dis glowing dull red` | `muddy dark red` |
| **7** | **Heresia** (Círculo 6) | `about 58 percent at the top edge narrowing evenly to about 51 percent at the bottom edge` | `the sixth circle inside the city of Dis, a wide plain of open stone tombs with their lids raised and flames rising from inside them, iron walls behind` | `ember orange-red` |
| **8** | **Violência** (Círculo 7) | `about 51 percent at the top edge narrowing evenly to about 44 percent at the bottom edge` | `the seventh circle in three rings from left to right: a boiling river of dark crimson guarded by tiny centaurs with bows, a dead wood of twisted leafless thorn trees, and a burning desert of sand under a slow rain of fire flakes, a horned bull-headed figure standing small at the entrance` | `crimson` |
| **9** | **Fraude** (Círculo 8, as Malebolge) | `about 44 percent at the top edge narrowing evenly to about 37 percent at the bottom edge` | `the eighth circle, ten deep concentric stone ditches seen in section side by side, narrow stone bridges arching over them, faint poisonous green vapour rising from the trenches, a winged monster with a serpent tail climbing the left wall, seen small` | `poison green` |
| **10** | **Traição** (Círculo 9, o Cocito) · o fundo | `the lowest slice: about 37 percent at the top edge closing to a narrow point at the bottom center, the rest of the band filled with dark earth and rock` | `the ninth circle, a frozen lake of ice with tiny souls trapped in it, huge giants standing chained around the rim seen small, at the very bottom point a colossal dark winged shape frozen in the ice up to its chest, distant and silent` | `white and pale ice blue only at the edges` |

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
