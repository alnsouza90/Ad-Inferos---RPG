# Etapa 3b · Interface própria e efeitos dos santos

Versão 1.0 · 12/11/2026 · consultor convidado · **proposta**. Responde a duas dúvidas de Alan: "não sei como criar uma interface original, própria do jogo" e "não estou satisfeito com os efeitos dos santos (magia)". Inclui o registro do teste de Lúcifer.

## 0. Registro

- **Alan aprovou todas as sugestões da Etapa 3** (`02-arte.md` §10, itens 1 a 8): as duas luzes; ouro para a graça e âmbar para o fogo; o sagrado sem contorno; auréola em eclipse e clareira; telas de passagem em folha de ouro e em preto; regenerar as quatro peças e diferenciar os pares; o bloco novo dos prompts de santos; Lúcifer como cenário e quase sem cor.
- **Teste de Lúcifer gerado no ImagineArt** (modelo ImagineArt 2.0, 21:9, **25 créditos; saldo 10**). O modelo padrão recusou por falta de créditos. Arquivo: `docs/fable/previas/lucifer_cenario_teste_v01.jpg`. Avaliação no §3.

---

## 1. Uma interface própria

### 1.1 Por que a de hoje parece emprestada

A interface atual cumpre o que você pediu (preto e cinza, ferro forjado, D-257 e D-258). O que a faz parecer Darkest Dungeon não é a cor. São três coisas:

1. **As formas:** retângulos, faixas e estandartes. É a gramática de lá.
2. **O que acende:** lá e aqui, o que está ativo fica dourado ou vermelho por cima do ferro.
3. **Não há um objeto do mundo por trás.** Em Darkest Dungeon a interface é "a papelada de uma herdade em ruínas". A sua ainda não é *de lugar nenhum*.

A pergunta certa é: **de que objeto do mundo dos santos esta interface é feita?**

### 1.2 A proposta: "a capela às escuras"

A interface é **o interior de uma capela com as luzes apagadas**. Ferro, chumbo e vidro escuro. Tudo o que você já decidiu continua valendo; o que muda é a forma e o jeito de acender.

Quatro regras:

**Regra 1 · As formas são de igreja, não de escritório.**

| Elemento | Hoje | Proposta |
| --- | --- | --- |
| Retrato do santo | Moldura retangular | **Arco ogival** (uma janela de capela) |
| Botões de habilidade | Retângulos | **Lancetas**: janelas estreitas de arco, lado a lado |
| Milagre | Botão retangular dourado | **Rosácea** redonda no centro, a única forma circular grande |
| Ficha do inimigo | Moldura igual à do santo | Moldura **quebrada e torta**, sem arco. O abismo não tem arquitetura |
| Intenções inimigas | Discos vermelhos | **Óculos** de ferro (janelas redondas pequenas), vermelho só no ataque |

Três formas, três sentidos: **arco** é santo, **círculo** é graça, **quebrado** é inimigo.

**Regra 2 · Os botões são vidro apagado; o que acende é vitral.**

- Em repouso, cada janela é **vidro escuro com as linhas de chumbo**: preto e cinza, como você quer.
- Habilidade disponível: o vidro deixa passar uma luz fraca, **sem cor**.
- Habilidade escolhida: o vidro **acende por trás**, como vitral ao sol.
- Milagre pronto: a rosácea acende em **ouro**. É a única coisa dourada do painel.
- Habilidade bloqueada (Noite Escura, sem Fervor): o vidro fica **fosco**, sem brilho.

Com isso, a regra "ouro só para a graça" fica visível no próprio painel, e a interface inteira se comporta como a auréola: escura por fora, luz por dentro.

**Regra 3 · O Fervor é um porta-velas de ferro.**

- Seis velas votivas numa fileira de ferro, como as que ficam diante de um altar.
- Cada ponto de Fervor é uma vela acesa. Gastar apaga, com um fio de fumaça.
- É ferro, é reconhecível por qualquer pessoa que já entrou numa igreja, e nenhum outro jogo tem.
- A chama é **âmbar** enquanto é Fervor comum; a vela que paga um milagre queima em **ouro**.

**Regra 4 · As coisas acendem; não deslizam.**

- Em Darkest Dungeon os painéis entram e saem deslizando.
- Aqui, tudo **acende e apaga** como vela: um tremor curto e firma.
- O som acompanha: fósforo, pavio, sino pequeno. (Para a tarefa de áudio.)

### 1.3 Como fica cada tela

| Tela | Ideia |
| --- | --- |
| **Combate** | Painel de ferro como hoje. À esquerda, o santo num arco, com as lancetas das habilidades e a rosácea do milagre. No meio, o porta-velas do Fervor. À direita, a ficha do inimigo em moldura quebrada |
| **Caminhada** | Só a lanterna e uma faixa fina de ferro. Quanto menos interface, melhor: é o momento de olhar o cenário |
| **Pouso** | Os três santos em três arcos lado a lado, como um tríptico de altar. As atividades são velas que se acendem diante de cada um |
| **Vila** | O mesmo ferro, com luz de vela (âmbar). Cada instalação é uma porta em arco |
| **Planejar a semana** | Um tríptico grande: quem desce (centro), quem reza na Capela (esquerda), quem descansa (direita) |
| **Mapa do Inferno** | Os nove círculos como nove janelas apagadas em fila descendente; as vencidas acendem; a luz pálida um círculo à frente da lanterna |

### 1.4 O que isso custa

- **Arte:** poucas peças novas, todas de ferro e vidro escuro: uma moldura em arco, uma lanceta (3 estados), uma rosácea (2 estados), um porta-velas, uma vela (acesa e apagada), uma moldura quebrada. São de 8 a 10 imagens.
- **Motor:** trocar as molduras e os estados dos botões. O leiaute de D-347 (onde cada coisa fica) não muda.
- **Risco:** lancetas estreitas com nome de habilidade em Pirata One podem ficar apertadas. Solução: o **ícone** dentro do vidro e o nome embaixo, na faixa de ferro.
- **Regra do §2 do dossiê:** o vitral é linguagem de interface, não figura sagrada. Nenhum santo ou cena sagrada desenhado nos botões.

### 1.5 Prompts de teste da interface

**I-1 · Botão em lanceta, três estados numa folha**

```text
2D game UI asset sheet in the style of Darkest Dungeon, hand-inked comic art, three identical tall narrow gothic lancet window frames side by side, each framed in rough black forged iron with rivets, the glass divided by thick dark lead lines into simple diamond panes with no figures and no symbols, left window: dark unlit smoked glass in black and ash grey, middle window: the same glass faintly lit from behind in pale bone white, right window: the same glass brightly lit from behind in warm amber, thick irregular black ink outlines, heavy black shadows, flat painterly fills, front view, isolated on a plain flat solid light grey background --ar 3:2 --no people, saints, faces, crosses, text, letters, gold, bright colors, glossy, 3D, photorealistic
```

**I-2 · Rosácea do milagre, apagada e acesa**

```text
2D game UI asset sheet in the style of Darkest Dungeon, hand-inked comic art, two identical small round gothic rose windows side by side framed in rough black forged iron, simple radial stone tracery with dark lead lines, no figures, left one: dark unlit smoked glass in black and ash grey, right one: every pane lit from behind in completely flat gold with no gradient, thick irregular black ink outlines, front view, isolated on a plain flat solid light grey background --ar 2:1 --no people, faces, text, letters, colored glass, blue, red, glossy, 3D, photorealistic
```

**I-3 · Porta-velas do Fervor**

```text
2D game UI asset in the style of Darkest Dungeon, hand-inked comic art, a low horizontal forged iron votive candle rack with exactly six short thick candles in a single row, wax drips, rough black iron with rivets, all six candles unlit with black wicks, thick irregular black ink outlines, heavy black shadows, palette of black, ash grey and bone, front view, isolated on a plain flat solid light grey background --ar 3:1 --no flames, fire, people, crosses, text, gold, glossy, 3D, photorealistic
```

(A chama é do motor, para acender e apagar.)

**I-4 · Moldura do retrato em arco e moldura quebrada do inimigo**

```text
2D game UI asset sheet in the style of Darkest Dungeon, hand-inked comic art, two empty portrait frames side by side with flat grey empty centers, left frame: a pointed gothic arch window frame in rough black forged iron with rivets and a small keystone, upright and symmetrical, right frame: a crooked broken rectangular iron frame, bent and cracked with one corner torn away and jagged edges, no arch, thick irregular black ink outlines, heavy black shadows, palette of black and ash grey, front view, isolated on a plain flat solid light grey background --ar 3:2 --no people, faces, text, gold, ornaments, glossy, 3D, photorealistic
```

---

## 2. Os efeitos dos santos

### 2.1 Por que os de hoje não convencem

Pelo registro (D-235, D-236, D-335), os efeitos são feitos **no motor**: brilhos redondos gerados em código, mistura aditiva, pontos de luz. Você já disse o que sente: "precisam ser mais 2D e com a identidade do jogo".

O problema é de **matéria**. Os personagens são **tinta desenhada, quadro a quadro**. Os efeitos são **luz calculada, lisa e borrada**. São dois mundos na mesma tela. Enquanto o efeito for luz de computador, ele vai parecer colado por cima.

E vocês já acharam a resposta, só que em outro lugar: a **Vertigem em stop motion** (D-247, D-248) ficou boa justamente quando deixou de ser vídeo e virou **desenho em poucos quadros**.

### 2.2 A proposta: xilogravura em folha de ouro

Três princípios.

**Princípio 1 · Efeito é desenho, não partícula.**

- Cada efeito é uma sequência de **4 a 6 desenhos**, tocada devagar (por volta de 8 por segundo), como os personagens.
- Borda **dura**, cor **chapada**, com um leve tremor de linha entre um desenho e outro.
- O motor só faz o que já faz bem: posicionar, escalar, fazer sumir.

**Princípio 2 · O sagrado aparece como uma estampa.**

- A imagem de referência não é "magia de videogame". É a **xilogravura**: o santinho impresso, a gravura de devoção, o cordel. Linha grossa, recorte simples, um pouco torta, com falhas de impressão.
- A Direção de Arte já pede "textura de impressão desgastada" em tudo. Os efeitos passam a falar a mesma língua.
- O efeito **carimba** a cena: aparece de uma vez, com um pequeno impacto, falha um pouco nas bordas e some como tinta secando.
- Cor: **ouro chapado** e **branco**, sem contorno preto (a regra do sagrado sem contorno).

**Princípio 3 · A magia muda a luz da cena, em vez de voar pela tela.**

- No instante do efeito, por um terço de segundo, **o alvo vira silhueta preta contra um campo de ouro liso**. É o "instante de ícone" em miniatura.
- Depois a cena volta, e fica uma **marca** pequena por um turno (o Amparo como um escudinho de ouro ao lado do santo; o Atordoamento como uma estampa sobre o inimigo).
- Isso dá peso sem partícula nenhuma, e custa quase nada.

**A sequência de todo efeito de santo:** gesto (a pose que já existe) → **sinal** (a estampa de ouro, 4 a 6 desenhos) → **instante de silhueta** no alvo → **marca** que fica.

### 2.3 Os três santos atuais, refeitos nessa língua

As formas são as que você já aprovou (D-236 a D-238). Muda a matéria.

| Santo | Habilidade | Hoje | Proposta |
| --- | --- | --- | --- |
| **São Bento** | Exorcismos (Cruz de São Bento, Crux Sacra) | Cruzes translúcidas em órbita | Uma **cruz de gravura em ouro** é estampada sobre o inimigo, com um baque; o inimigo fica em silhueta; a cruz racha e se desfaz em lascas |
| **São Bento** | Bênçãos (A Regra, Ora et Labora) | Anel de luz e coluna suave | Um **anel de ouro recortado** cai em volta dos pés do aliado, como um selo, e sobe se fechando |
| **Santa Teresinha** | Curas | Pétalas com luz | **Pétalas desenhadas**, vermelhas e chapadas, caem em poucos quadros; a que toca o aliado **vira ouro** |
| **Santa Teresinha** | Oração Ardente (exorcismo) | Luz que voa | Uma **única pétala de ouro** atravessa a cena em linha reta, como uma flecha, e estampa no inimigo |
| **São Jorge** | Escudo Erguido | Escudo de luz branca com cruz | O **escudo de gravura**, branco e chapado, **bate no chão** diante do aliado como um carimbo, com poeira de tinta |
| **Milagres (todos)** | — | Tela de passagem | O instante de ícone completo: fundo de folha de ouro, santo em tinta preta |

### 2.4 O que isso custa

- **Arte:** uma folha de 6 desenhos por efeito. Para os três santos, são 5 ou 6 folhas. É o tipo de arte que você já gera bem.
- **Motor:** tocar a folha no lugar do efeito atual (o tocador de quadros já existe, da T35) e o instante de silhueta (o material de silhueta já existe, do contorno da Vertigem).
- **O que se joga fora:** os brilhos gerados em código. A câmera de impacto (G1) fica: ela é boa.
- **Risco:** a IA variar o desenho entre os 6 quadros. Por isso pedir **uma folha só**, com os 6 na mesma imagem (prompts abaixo), em vez de 6 imagens.

### 2.5 Prompts de teste dos efeitos

**E-1 · Cruz estampada (exorcismo), 6 quadros numa folha**

```text
2D game VFX sprite sheet, six frames in a single horizontal row, medieval woodcut print style, a bold equal-armed cross printed in completely flat gold ink with rough hand-carved edges and small gaps like a worn woodblock stamp, frame 1: a faint thin ghost of the cross, frame 2: the cross half printed, frame 3: the full bold cross with a small burst of short straight rays, frame 4: the full cross with ink cracks, frame 5: the cross breaking into angular splinters, frame 6: a few last splinters drifting apart, no outline, no gradient, no glow, hard cut edges, each frame centered in its cell, isolated on a plain flat solid dark grey background --ar 3:1 --no black outline, soft glow, blur, lens flare, particles, 3D, text, letters, people, glossy, photorealistic
```

**E-2 · Pétalas (cura de Teresinha), 6 quadros numa folha**

```text
2D game VFX sprite sheet, six frames in a single horizontal row, medieval woodcut print style, simple flat rose petals with rough hand-carved edges falling, frame 1: three small dark red petals at the top, frame 2: five dark red petals falling, frame 3: seven petals with the lowest one turning flat gold, frame 4: half of the petals flat gold, frame 5: all petals flat gold and spreading outward, frame 6: two last gold petals fading, completely flat colors, no outline, no gradient, no glow, hard cut edges, each frame centered in its cell, isolated on a plain flat solid dark grey background --ar 3:1 --no black outline, soft glow, blur, sparkles, realistic flowers, stems, 3D, text, glossy, photorealistic
```

**E-3 · Escudo que carimba o chão (Jorge), 6 quadros numa folha**

```text
2D game VFX sprite sheet, six frames in a single horizontal row, medieval woodcut print style, a round shield bearing a simple cross printed in completely flat white ink with rough hand-carved edges like a worn woodblock stamp, frame 1: the shield small and high, frame 2: the shield larger and falling, frame 3: the shield slamming upright onto a ground line with a low burst of angular dust shards, frame 4: the shield standing firm and bold, frame 5: the shield with gaps appearing like fading print, frame 6: only a faint broken outline of the shield, no outline, no gradient, no glow, hard cut edges, each frame centered in its cell, isolated on a plain flat solid dark grey background --ar 3:1 --no black outline, soft glow, blur, 3D, metal shine, text, people, glossy, photorealistic
```

**E-4 · Anel que sela (bênção de Bento), 6 quadros numa folha**

```text
2D game VFX sprite sheet, six frames in a single horizontal row, medieval woodcut print style, a flat elliptical ring seen from a low side view lying on the ground, printed in completely flat gold ink with rough hand-carved edges, frame 1: a thin broken ring, frame 2: the ring closing, frame 3: a bold closed ring with short straight rays rising from it, frame 4: the ring lifting off the ground, frame 5: the ring narrowing as it rises, frame 6: a small bright ring high above fading, no outline, no gradient, no glow, hard cut edges, each frame centered in its cell, isolated on a plain flat solid dark grey background --ar 3:1 --no black outline, soft glow, blur, particles, 3D, text, people, glossy, photorealistic
```

---

## 3. O teste de Lúcifer

Arquivo: `previas/lucifer_cenario_teste_v01.jpg` (3136 × 1344).

| O que deu certo | O que não deu |
| --- | --- |
| As três faces com as cores de Dante (vermelha, branca, negra), bem legíveis | **A figura ficou toda à direita**; a metade esquerda é só asa. Como cenário de luta, o chefe precisa estar no centro |
| Lágrimas e baba de sangue nos três queixos | As três faces saíram **juntas**, no mesmo pescoço. Para serem três alvos, precisam estar afastadas |
| Asas de morcego, sem penas | Não dá para contar **seis** asas com clareza |
| Quase sem cor: preto, cinza, o vermelho de uma face e o azul só no gelo. **A ideia funciona** | O traço saiu **limpo demais**: mais quadrinho de Mignola do que a tinta suja de Darkest Dungeon. Falta respingo e textura de impressão |
| Faixa de gelo livre na frente para os santos | Escala: parece grande, mas não **colossal**. Falta algo pequeno ao lado para comparar |

**Conclusão:** a direção (Lúcifer como cenário, quase monocromático) está validada. A composição e o traço, não. Este modelo é o mais barato do ImagineArt; os seus chefes aprovados vieram de outra ferramenta, com imagem de referência de estilo.

**Prompt corrigido para a próxima tentativa** (use um chefe aprovado, como Moloque, de referência de estilo):

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, in the spirit of Gustave Dore engravings, extreme wide front view, perfectly symmetrical composition centered in the frame, Lucifer as described by Dante, the colossal chest and shoulders of a fallen angel rising from a frozen lake, one enormous head in the exact center with three separate huge faces spread far apart across the width of the image, the left face black turned to the left, the central face dark red looking straight ahead, the right face pale bone white turned to the right, wide empty dark gaps between the faces, exactly three pairs of enormous bat-like wings, one pair below each face, tears and bloody foam on the three chins, tiny broken stone ruins on the ice at his chest to show immense scale, a flat empty strip of cracked ice across the bottom for characters, almost monochrome, black, white and ash grey with only a faint icy pale blue on the ice edges, rough dirty ink texture, heavy ink splatter, distressed print texture, thick irregular black ink outlines, massive black shadows engulfing half the figure, angular blocky shading, isolated on a plain flat solid light grey background above the ice line, no text --ar 21:9 --no gold, yellow, halo, feathered wings, fire, warm light, off-center, figure on one side, clean vector lines, smooth shading, cartoon, anime, glossy, 3D, photorealistic
```

---

## 4. O próximo passo que eu sugiro

Interface e efeitos são coisas que se decidem **vendo**, não lendo. Da outra vez, vocês escolheram os efeitos numa página de modelos animados (D-333, D-237), e funcionou.

Posso montar uma página parecida, sem gastar créditos, com:

1. o painel de combate nas duas versões lado a lado (a de hoje e "a capela às escuras"), em desenho simples;
2. os quatro efeitos do §2.3 animados em quadros, com o instante de silhueta, para comparar com os atuais;
3. a auréola nos cinco estados (normal, cobrindo, eclipse, Consolação, Purificação).

Você olha no celular e responde "este sim, este não". Depois disso, você gera só as peças do que aprovou.
