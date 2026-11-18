# Guardiões dos prédios da vila · retratos para o Meta AI (T49, D-499)

**Como aparecem (D-499):** como o atendente de cada prédio no *Darkest Dungeon*. Ao abrir o prédio, o guardião fica **grande, à esquerda da tela, da cintura para cima**, olhando **para a direita**, para os painéis de ação. O fundo é o interior do prédio (`prompts-interiores-vila.md`). Ele diz a fala aprovada (D-468, D-471, D-492), e logo abaixo vem a instrução do prédio.

**Padrão de arte:**
- O mesmo dos retratos dos santos (`docs/fable/prompts-pixel-m2.md` §2.7): pixel art *Blasphemous* com o clima de *Darkest Dungeon*, sem o lado contraventor.
- Mudam só o enquadramento (**da cintura para cima**) e o tamanho.
- **Sem auréola**: a auréola é feita pelo motor, como nos santos.
- Sem sangue; os santos nunca sexualizados (`writing-guide.md`).

**Formato:** proporção **3:4**, fundo cinza claro liso, para recortar. O agente converte para pixel; na tela da vila o retrato fica com cerca de **300 × 400**.

---

## Bloco comum

Troque `<GUARDIÃO>` e `<OBJETOS>`:

```text
dark gothic pixel art portrait, 16-bit style, in the style of Blasphemous with the grim mood of Darkest Dungeon, reverent and dignified, without Blasphemous's grotesque, gory or profane side, waist-up portrait, three-quarter view facing right, both hands visible, <GUARDIÃO>, <OBJETOS>, calm wise welcoming expression, warm amber rim light from the left, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, heavy black shadows engulfing half the face, limited palette of about 24 muted desaturated colors, selective dithering only in the shadows, no anti-aliasing, isolated on a plain flat solid light grey background --ar 3:4 --no halo, gold halo, glowing halo, blood, wounds, gore, grotesque, sexualized, cleavage, blur, smooth shading, anti-aliasing, gradient, painterly, 3D, photorealistic, cartoon, chibi, anime, text, letters, frame, background scenery, watermark
```

**Os objetos são a iconografia tradicional de cada santo** (como a arte cristã os mostra). Cada um tem a origem registrada na tabela, para o Martirológio.

---

## Os dez guardiões

| # | Prédio | Guardião | `<GUARDIÃO>` | `<OBJETOS>` | Iconografia (para o Martirológio) |
| --- | --- | --- | --- | --- | --- |
| 1 | **Portão** | São Cristóvão | `Saint Christopher, a very tall and broad-shouldered bearded man in a simple tunic and a traveller's cloak` | `leaning on a tall rough wooden staff, the small Christ Child sitting on his shoulder blessing, river water dripping from the hem of his cloak` | Tradição e *Legenda Áurea*: o gigante que carregou o Menino pelo rio |
| 2 | **Relicário** | Santa Helena, imperatriz | `Saint Helena the Empress, a dignified elderly woman with a simple imperial crown over a veil and a long dark mantle` | `holding a large plain wooden cross upright beside her` | Tradição: a descoberta da Vera Cruz em Jerusalém |
| 3 | **Casa de Exercícios** | Santo Inácio de Loyola | `Saint Ignatius of Loyola, a balding middle-aged man with a short dark beard in a plain black Jesuit cassock` | `holding a closed book against his chest, an old soldier's sword hanging at his belt` | *Autobiografia*: soldado ferido em Pamplona, depois os *Exercícios Espirituais* |
| 4 | **Biblioteca** | Santo Tomás de Aquino | `Saint Thomas Aquinas, a heavy-set calm friar with a tonsure in a white Dominican habit and a black cloak` | `holding a large open book, a quill in his other hand, a small sun emblem on his chest` | Iconografia dominicana: o livro e o sol no peito (o "Doutor Angélico") |
| 5 | **Catedral** (Capela) | Santo Agostinho | `Saint Augustine of Hippo, a bearded bishop in an embroidered cope and a tall mitre` | `holding a bishop's crozier and a closed book, a small flaming heart in his hand` | Iconografia: bispo, o livro e o coração em chamas (*Confissões*) |
| 6 | **Carmelo** | Santa Teresa d'Ávila | `Saint Teresa of Avila, a woman in a brown Carmelite habit with a white mantle and a black veil` | `holding a quill and an open book, eyes lifted a little in thought` | Iconografia carmelita: a pena e o livro (Doutora da Igreja) |
| 7 | **Jardim e Claustro** | São Francisco de Assis | `Saint Francis of Assisi, a thin gentle friar with a tonsure and a short beard in a patched brown Franciscan habit tied with a white cord with three knots` | `a small bird resting on his open hand, a simple wooden cross on a cord at his chest` | Tradição: o pobre de Assis, a pregação às aves e o *Cântico das Criaturas* |
| 8 | **Enfermaria** | São Cosme e São Damião | `Saints Cosmas and Damian, two young twin brothers side by side, physicians in long dark red robes and soft round caps` | `one holding a small wooden box of medicines, the other a clay jar and a small spatula` | Tradição: os irmãos médicos "anárgiros", que curavam sem cobrar |
| 9 | **Forja** | Santo Elói | `Saint Eligius, a strong bearded man in a leather smith's apron over a simple bishop's robe` | `holding a smith's hammer, a pair of tongs at his belt, a small finished horseshoe in his other hand` | Tradição: ourives do rei franco, depois bispo de Noyon; padroeiro dos ferreiros |
| 10 | **Despensa** | Santa Isabel da Hungria | `Saint Elizabeth of Hungary, a young queen with a simple crown over a white veil and a plain grey Franciscan tertiary habit` | `holding the folded front of her mantle full of red roses and a few loaves of bread` | Lenda: o "milagre das rosas" (o pão aos pobres que virou rosas) |

**Nota sobre o Menino com São Cristóvão:** a Direção de Arte permite Cristo só como iconografia, e cita o "Menino com Cristóvão" (`art-direction.md`). O Menino aparece aqui só como imagem. Ele não fala, não é unidade e não dá bônus.

**Nota sobre Cosme e Damião:** os dois ficam no mesmo retrato. Se a dupla não couber bem em 3:4, gere em **4:3**; o agente ajusta o enquadramento.

---

## Prioridade

1. Os cinco prédios abertos no M2: **São Cristóvão** (Portão), **Santo Inácio** (Casa de Exercícios), **São Francisco** (Jardim e Claustro), **São Cosme e São Damião** (Enfermaria) e **Santa Isabel** (Despensa).
2. Os outros cinco, depois. No M2 eles só aparecem no aviso de fechado.

## Lista dos guardiões

| Prédio | Guardião | Fala aprovada |
| --- | --- | --- |
| Portão | São Cristóvão | "Por esta porta chega quem foi chamado, e por ela sai quem vai buscar." |
| Relicário | Santa Helena, imperatriz | "Fui longe procurar a Cruz. Cada relíquia também é um caminho." |
| Casa de Exercícios | Santo Inácio de Loyola | "Também fui soldado, e uma ferida me ensinou mais que todas as vitórias." |
| Biblioteca | Santo Tomás de Aquino | "Escrevi muito. No fim, tudo me pareceu palha diante do que vi." |
| Catedral (Capela) | Santo Agostinho | "Fizeste-nos para ti, e inquieto está o nosso coração enquanto não repousa em ti." |
| Carmelo | Santa Teresa d'Ávila | "Nada te perturbe, nada te espante. Tudo passa; Deus não muda. Só Deus basta." |
| Jardim e Claustro | São Francisco de Assis | "Louvado sejas, meu Senhor, com todas as tuas criaturas." |
| Enfermaria | São Cosme e São Damião | "Curávamos sem cobrar. Aqui também ninguém paga para ser cuidado." |
| Forja | Santo Elói | "Trabalhei o ouro para reis. Aqui o ferro serve melhor." |
| Despensa | Santa Isabel da Hungria | "O pão que guardo não é meu. É de quem vai precisar dele lá embaixo." |

---

## Decisão de Alan (D-501): São Cristóvão sem o Menino; o Menino num quadro do Portão

O retrato de São Cristóvão fica **sem o Menino Jesus**. O Menino vai para um **quadro na parede do Portão**: uma imagem sacra pendurada, peça de cenário (iconografia, como permite a Direção de Arte). Ele não fala, não é unidade e não dá bônus. O agente recorta a imagem e a põe na parede do interior do Portão, à luz das tochas.

### Quadro do Menino Jesus · peça de cenário do Portão · proporção 3:4

```text
dark gothic pixel art game prop, 16-bit style, in the style of Blasphemous together with the gothic look of Darkest Dungeon, reverent, calm and tender, without Blasphemous's grotesque, gory or profane side, a single small old devotional painting hanging on a wall, front view, a dark carved wooden frame with simple worn edges and a small iron ring at the top, inside the painting the Christ Child as a small boy in a simple pale robe, standing, one hand raised in blessing, the other holding a small orb with a cross, a soft warm amber light around him painted in the picture, a gentle serene face, the painting slightly darkened and cracked by age, a single consistent pixel size, crisp hard pixel edges, chunky black outlines, muted desaturated palette of black, bone, ash grey and warm amber, selective dithering, no anti-aliasing, isolated on a plain flat solid light grey background --ar 3:4 --no flat gold, glowing gold halo, blue, text, letters, wall, room, other objects, people around, gore, grotesque, damaged face, blur, smooth shading, painterly, 3D, photorealistic, watermark
```

**Origem (para o Martirológio):** iconografia tradicional do Menino Jesus abençoando, com o globo e a cruz (o *Salvator Mundi* na forma de menino); ligado ao Portão pela lenda de São Cristóvão (*Legenda Áurea*).
