# Interiores dos prédios da vila · prompts para o Meta AI (T49, D-498)

**Como funciona:** Alan gera cada interior no Meta AI e envia ao agente. O agente reduz a imagem para a tela do jogo (960 × 540) e monta por cima os painéis de ferro com as ações do prédio. Um interior por prédio, aprovado por Alan um a um.

**O que vale para todos:**
- **Estilo:** o mesmo da vila (D-489, D-495): pixel art no estilo de *Blasphemous* junto com o gótico de *Darkest Dungeon*, **sem o lado contraventor** (nada grotesco, nada de sangue, nenhuma imagem sagrada deformada).
- **Por dentro do prédio da vila:** cada interior respeita a forma e os materiais do prédio na imagem da vila (D-495): o tamanho, o teto, as janelas e a pedra. A Capela agora é uma **catedral gótica** (D-488).
- **Tela 16:9, vista de frente**, como uma sala de teatro: a câmera na altura dos olhos, olhando para a parede do fundo.
- **Sem pessoas.** O guardião de cada prédio entra **separado**, como figura, para não ficar preso ao cenário e poder falar (falas aprovadas na D-468 e na D-471).
- **Área livre para a interface:** o **terço de baixo** fica mais calmo e escuro (o chão), porque ali entram os painéis de ferro. O **lado esquerdo** fica livre para o guardião em pé.
- **Luz âmbar** de velas, lamparinas ou fogo, vinda da esquerda; o resto na penumbra. **Sem ouro chapado, sem céu azul.**

---

## Bloco comum

Troque `<INTERIOR>` pela descrição de cada prédio abaixo:

```text
dark gothic pixel art interior, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent and calm, without Blasphemous's grotesque, gory or profane side, a wide interior scene seen from the front at eye level like a theatre stage looking at the back wall, <INTERIOR>, the left third of the floor kept clear and open for a standing figure, the lower third of the image calmer and darker for interface panels, warm amber light from candles and lamps coming from the left, deep shadows on the right, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows in solid blocks, muted desaturated palette of black, bone, ash grey and warm amber, selective dithering in the shadows, no anti-aliasing --ar 16:9 --no people, characters, figures, monks, saints, faces, text, letters, writing, signs, flat gold, blue sky, gore, blood, grotesque, profane imagery, blur, smooth shading, painterly, 3D, photorealistic, watermark
```

---

## 1. Portão (São Cristóvão)

Por fora: duas torres redondas com ameias, um muro entre elas e um portão grande de madeira com ferragens e tochas.

```text
the inside of a fortified stone gatehouse between two round towers, a high vaulted stone passage, the great wooden gate bound with iron closed at the back wall with a heavy beam across it, two iron torches burning beside it, a wooden rack with travel packs, ropes, lanterns and walking staffs on the right wall, a narrow stone stair going up into one tower on the right, a rough wooden table with a map of a deep funnel spread on it, straw on the stone floor
```

## 2. Relicário (Santa Helena, imperatriz)

Por fora: santuário pequeno e quadrado, de pedra, com cúpula baixa, uma cruz de ferro no alto, porta de grade e dois nichos com velas.

```text
the inside of a small square stone reliquary shrine under a low stone dome, a round opening at the top of the dome letting in a pale shaft of light, rows of small stone niches in the walls holding closed reliquaries, small caskets and wrapped cloths, each niche with a small candle, a stone altar in the center of the back wall with a simple iron cross above it, an iron grate dividing the back of the room
```

## 3. Casa de Exercícios (Santo Inácio de Loyola)

Por fora: casa pequena e firme de pedra, telhado de ardósia, chaminé alta, porta em arco e um pátio de treino murado com boneco de palha e estandarte.

```text
the inside of a small sturdy stone retreat house, a low wooden ceiling with dark beams, a simple wooden kneeler and a plain wooden crucifix on the back wall, a wooden lectern with a closed book, a rack of wooden practice staffs and a worn leather shield on the right wall, a straw training dummy in a corner, a stone fireplace on the right with a low fire, a narrow window showing a training yard
```

## 4. Biblioteca (Santo Tomás de Aquino)

Por fora: torre alta e estreita de pedra, janelas altas em arco, ameias, pináculo de ardósia e uma casinha de pedra na base.

```text
the inside of a tall narrow stone library tower, wooden shelves full of old books and scrolls climbing the round walls up into darkness, a narrow wooden spiral stair going up the right wall, a tall arched window at the back, a heavy wooden reading desk with an open large book, an inkwell, a quill and a candle, a ladder leaning on the shelves, dust in the candlelight
```

## 5. Catedral gótica (Capela, Santo Agostinho)

Por fora: catedral gótica alta, a maior da vila, com duas torres de agulha, rosácea, portal em arco ogival profundo e janelas altas em lanceta acesas.

```text
the inside of a tall gothic stone cathedral, a long nave with high pointed rib vaults disappearing into darkness, tall pillars on both sides, a great round rose window high on the back wall glowing amber, tall lancet windows along the walls, a raised stone altar at the back under a simple crucifix with many votive candles, rows of wooden pews in the lower third seen from behind, censers hanging from chains, solemn and silent
```

## 6. Carmelo (Santa Teresa d'Ávila)

Por fora: convento carmelita simples, paredes brancas caiadas, telhado de ardósia escura, sineira pequena com sino e cruz, sete janelinhas em arco e um muro baixo com portão.

```text
the inside of a simple whitewashed Carmelite convent, a long low room with bare white walls and dark wooden beams, a row of seven small arched windows along the back wall with candles on their sills, a plain wooden cross on the back wall, a few simple wooden stools and a long plain wooden table with a small book, a woven rush mat on the stone floor, a small grille in the wall to a hidden chapel, austere, quiet and poor
```

## 7. Jardim e Claustro (São Francisco de Assis)

Por fora: claustro longo de arcadas de pedra em volta de um jardim verde com canteiros e um poço coberto com telhadinho.

```text
the inside of a quiet stone cloister seen from under its arcade, a row of round stone arches framing a small green garden with flower beds, herbs and a few small trees, a covered stone well with a small wooden roof and a bucket in the middle of the garden, stone benches along the arcade, a few small birds on the edge of the well, soft late light falling into the garden, the arcade in amber shadow
```

## 8. Enfermaria (São Cosme e São Damião)

Por fora: prédio comprido e baixo de pedra, telhado de ardósia, fileira de janelas pequenas em arco, porta de madeira com uma pequena cruz e canteiros de ervas na frente.

```text
the inside of a long low stone infirmary hall, a row of simple wooden beds with white linen along the back wall under small arched windows, a small wooden cross above the door, shelves with clay jars, bottles and bundles of dried herbs hanging from the beams, a wooden table with a mortar and pestle, rolled bandages and a basin of water, a low brazier giving warmth, clean, calm and caring
```

## 9. Forja (Santo Elói)

Por fora: forja pequena de pedra com galpão aberto na frente, bigorna num toco, fogo aceso numa lareira de tijolos, chaminé quadrada alta e uma cruz de ferro no oitão.

```text
the inside of a small stone forge, a large brick hearth with a glowing fire and a bellows on the back wall, an iron anvil on a tree stump in front of it, hammers, tongs and horseshoes hanging on the walls, a water trough, a rack with unfinished staffs, lantern frames and small iron crosses, sparks and warm orange firelight against the dark stone, a small iron cross on the beam above the hearth
```

## 10. Despensa (Santa Isabel da Hungria)

Por fora: armazém de pedra com dois andares, telhado de ardósia, porta dupla larga de madeira com ferro, janelinhas acesas, barris e sacos de grão na frente.

```text
the inside of a two-storey stone storehouse, a wooden upper floor on heavy beams with a ladder going up, sacks of grain, loaves of bread on wooden shelves, wooden barrels and crates stacked along the walls, strings of candles and small bottles of holy water on a shelf, rolls of bandages and small pouches of incense on a table, a set of iron scales and a ledger on a wooden counter in front, the wide wooden double door at the back
```

---

## Tabela de conferência

| # | Prédio | Guardião (entra separado) | Aberto no M2 |
| --- | --- | --- | --- |
| 1 | Portão | São Cristóvão | Sim |
| 2 | Relicário | Santa Helena, imperatriz | Não (só aviso) |
| 3 | Casa de Exercícios | Santo Inácio de Loyola | Sim |
| 4 | Biblioteca | Santo Tomás de Aquino | Não |
| 5 | Catedral (Capela) | Santo Agostinho | Não |
| 6 | Carmelo | Santa Teresa d'Ávila | Não |
| 7 | Jardim e Claustro | São Francisco de Assis | Sim |
| 8 | Enfermaria | São Cosme e São Damião | Sim |
| 9 | Forja | Santo Elói | Não |
| 10 | Despensa | Santa Isabel da Hungria | Sim |

**Prioridade:** os cinco abertos no M2 (Portão, Casa de Exercícios, Jardim e Claustro, Enfermaria e Despensa). Os outros cinco podem vir depois; no M2 eles só mostram o aviso de fechado.
