# Etapa 4 · Animação: o núcleo que dá vida com poucos desenhos

Versão 1.0 · 12/11/2026 · consultor convidado · **proposta**. Tempos, porcentagens e tamanhos são pontos de partida para testar no aparelho.

## 0. O que eu li e conferi

- `docs/adr/0007-animacao-definida-pelo-piloto.md` e a seção "Animação de personagens" de `docs/memory/lessons.md`.
- `docs/art/asset-pipeline.md` §7, `tools/art/animation_characters.csv` e os nomes de funções e constantes de `combatant_view.gd` e `frame_player.gd` (para saber o que o motor **já faz**).
- As decisões D-194, D-195, D-229, D-233 a D-255, D-330 a D-348.

**O que já foi tentado e não volta:**

| Tentativa | Resultado | Lição que este documento respeita |
| --- | --- | --- |
| Esqueleto 2D com peças recortadas e giradas | Reprovado: "boneco articulado" (D-195) | **Nunca girar um pedaço cortado do personagem.** Só a figura inteira se deforma |
| Vídeo do Wan 3 para tudo | Caro (150 créditos por clipe), pisca, corta nas bordas (D-222, D-342) | Vídeo só onde já existe; daqui para a frente, desenho |
| Média temporal para tirar o piscar | Borrou; reprovada (D-253) | Poucos quadros nítidos, parados, com fusão curta (D-344) |
| Meta AI para poses de personagem complexo | Perdeu a fidelidade (D-254) | Poses complexas vêm de quem gerou o personagem |
| Efeitos de luz gerados em código | "Não são 2D nem têm a identidade do jogo" (D-235) | Efeito é desenho; o motor só move, escala e some |
| **Minos: 4 poses desenhadas, movimento todo no motor** | **Aprovado** (D-229) | É o modelo a seguir |
| **Vertigem em stop motion, poucos desenhos** | **Aprovada** (D-248) | Idem |

**O que o motor já faz hoje:** respiração no parado (a figura estica 1,2% a cada 3,2 s), um pequeno "pulo" ao trocar de pose, deslizar até o alvo com rastro de cópias, segurar no impacto, voltar, câmera de impacto (aproxima, escurece o fundo, clarão, tremor), tremor do alvo em ataque espiritual com contorno colorido, queda com leve giro, quem age vai para a frente. **Os 6 inimigos da família A têm só uma imagem parada.**

**O que ainda não existe** (procurei no código e não achei): sombra no chão, poeira, antecipação com esmagar e esticar, parada no impacto com recuo que passa do ponto, reação de quem está ao lado, onda em capa ou fumaça, dissolver.

---

## 1. A ideia

> **O peso não está nos quadros. Está no tempo.**

Darkest Dungeon quase não anima. Ele mostra uma pose, **segura**, e troca. O que faz o golpe doer é o instante em que tudo para, e o que vem logo depois.

Por isso a proposta não é "mais desenhos". É um **núcleo de 12 gestos do motor**, que serve a todo personagem, mais uma **ficha de temperamento** por personagem, em dados. Um inimigo novo passa a custar **uma imagem e uma linha de planilha**.

Três regras de estilo, que valem para tudo:

1. **A figura inteira se deforma; nenhum pedaço gira.** (A lição do esqueleto.)
2. **Pose, segura, pose.** Troca de pose é corte seco com um tranco, nunca transição macia.
3. **O motor anima "aos pulos", como os desenhos.** Os personagens andam a poucos quadros por segundo. Se a respiração e as ondas do motor forem lisas a 60 por segundo, viram "dois mundos", como aconteceu com os efeitos. Proposta: as deformações da figura mudam cerca de **12 vezes por segundo**. Só o deslocamento pela tela e a câmera ficam lisos. (Vale testar com e sem.)

---

## 2. O núcleo: 12 gestos do motor

Cada gesto é uma peça que o motor faz sozinho, com uma imagem só. A coluna "Sensação" é o que o jogador sente.

| # | Gesto | O que é | Sensação | Custo |
| --- | --- | --- | --- | --- |
| 1 | **Parada no impacto** | No instante do golpe, quem bate e quem apanha **congelam** por um instante (de 60 a 140 milésimos, conforme o peso). Depois o alvo recua **passando do ponto** e volta | O golpe dói. É o gesto que mais muda o jogo | Baixo |
| 2 | **Sombra no chão** | Uma mancha escura sob cada figura. Encolhe quando a figura sobe, estica na investida, cresce com a desolação | A figura deixa de flutuar; ganha chão | Baixo |
| 3 | **Antecipação** | Antes de agir, a figura **se abaixa e alarga**, presa pelos pés; depois **estica** na direção do golpe | O jogador vê o golpe nascer. Dá peso ao bruto e leveza ao ágil | Baixo |
| 4 | **Poeira e respingo desenhados** | Uma folha pequena de 6 a 8 desenhos (poeira, lascas, gotas de tinta), usada por todos: nos pés ao arrancar e ao frear, no alvo ao apanhar | O chão e o corpo respondem | Baixo (1 folha de arte) |
| 5 | **Borrão de velocidade** | Durante a investida, a figura **estica na direção do movimento** por dois ou três passos, no lugar das cópias fantasmas de hoje | Rapidez sem quadro novo | Baixo |
| 6 | **Câmera com direção** | A câmera de impacto atual, mais um **empurrão para o lado do golpe** | A pancada tem lado | Baixo |
| 7 | **Inclinar e balançar** | A figura inteira inclina (para a frente ao ameaçar, para trás ao apanhar) e balança o peso no parado | Postura e intenção | Baixo |
| 8 | **Onda** | A imagem ondula por dentro, sem cortar nada: na **barra** da roupa (capa, hábito), no **alto** (chama, cabelo) ou no **corpo todo** (fumaça) | Pano ao vento e corpo de fumaça com uma imagem só | Médio |
| 9 | **Dissolver e brotar** | A figura some ou aparece por uma borda rasgada de tinta: de baixo para cima (brotar da poça), de cima para baixo (evaporar) | Nascimento e morte sem desenho novo | Médio |
| 10 | **Silhueta** | A figura vira preto, branco ou a cor do círculo por um instante. O material já existe (contorno da Vertigem) | O "instante de ícone" e o assédio | Baixo |
| 11 | **Reação em volta** | Quem está ao lado de quem apanha dá um **pequeno sobressalto**; os inimigos se encolhem quando um exorcismo estoura perto | O campo inteiro está vivo, não só os dois que lutam | Baixo |
| 12 | **A intenção no corpo** | Durante o turno do jogador, o inimigo **mostra no corpo o que vai fazer**: inclina na direção do alvo e respira mais rápido se vai atacar; encolhe se vai defender; incha se vai invocar | A intenção deixa de ser só um ícone. É o gesto com mais identidade | Baixo a médio |

**Como se faz, em uma linha cada (para quem implementa):**

- 1, 3, 5, 7: escala, inclinação e posição da figura inteira, ancoradas nos pés. Sem malha, sem peças.
- 2: uma elipse por figura, desenhada antes dela.
- 4: sprites da folha, poucos por vez (teto de uns 24 na tela).
- 8, 9: um material só para todos, que desloca ou corta a imagem com uma textura pequena de ruído. Uma amostra de textura a mais por figura; nada de luz dinâmica.
- 10: o material de silhueta que já existe.
- 11, 12: só leem o estado do combate (intenção, alvo) e ajustam os gestos 3 e 7. **Nenhuma regra é decidida aqui.**
- Onde houver variação "ao acaso" (um tique no parado), ela sai de um cálculo fixo sobre o nome do personagem e o tempo, **nunca** do sorteio das regras (ADR-0003).

---

## 3. A frase do golpe

Todo ataque físico, de santo ou de inimigo, é a mesma frase em cinco tempos. O **peso** do personagem muda a duração de cada um.

| Tempo | O que acontece | Leve | Médio | Pesado |
| --- | --- | --- | --- | --- |
| 1 · Antecipação | Abaixa e alarga; inclina para trás | 0,10 s | 0,18 s | 0,32 s |
| 2 · Disparo | Estica e desliza com borrão; poeira nos pés | 0,10 s | 0,14 s | 0,18 s |
| 3 · **Impacto** | **Tudo para.** Silhueta num clarão, respingo, câmera empurra | 0,06 s | 0,09 s | 0,14 s |
| 4 · Consequência | O alvo recua passando do ponto e volta; vizinhos reagem; o número aparece | 0,20 s | 0,25 s | 0,30 s |
| 5 · Recuperação | Volta devagar; assenta com um pequeno balanço | 0,25 s | 0,30 s | 0,40 s |
| **Total** | | **0,71 s** | **0,96 s** | **1,34 s** |

- Hoje o golpe leva perto de 0,8 s (deslizar 0,22 + segurar 0,25 + voltar 0,30). O total médio fica parecido; o que muda é **onde** o tempo é gasto.
- Na velocidade 2× tudo cai pela metade; no modo instantâneo, só o tempo 3 e o número.
- **Golpe espiritual** (exorcismo, ação de Espiritual) não tem disparo: a antecipação é **esticar para cima**, e o impacto acontece no alvo (a estampa dos santos ou a tinta que sobe, da Bíblia de Arte).

---

## 4. A ficha de temperamento

Cada personagem ganha uma linha em `animation_characters.csv` (que já existe), com poucas colunas novas. É aqui que nasce a personalidade.

| Coluna | Valores | O que muda |
| --- | --- | --- |
| **Peso** | leve · médio · pesado · colossal | Os tempos da frase do golpe, o tamanho do tremor, a poeira, a sombra |
| **Matéria** | carne · fumaça · casca · enxame | Como se deforma, como apanha e como morre (§5) |
| **Fôlego** | parado · calmo · inquieto · ofegante | Ritmo e tamanho da respiração |
| **Postura** | ereto · curvado · inclinado para a frente · flutuando | A inclinação de base e o balanço no parado |
| **Vento** | nenhum · barra · alto · corpo todo | Onde a onda age (gesto 8) |
| **Ataque** | investida · bote · arremesso · no lugar · do trono | Já existe em parte (`attack_style`) |
| **Fim** | desaba · evapora · estilhaça | Como sai de cena |

Sete escolhas por personagem. Nenhuma arte.

---

## 5. As quatro matérias

A natureza do inimigo (Corpóreo ou Espiritual) já está nos dados. A matéria detalha um pouco mais e decide **como o corpo responde**.

| Matéria | Quem | Parado | Ao apanhar | Ao morrer |
| --- | --- | --- | --- | --- |
| **Carne** | Corpóreos em geral: Diabo de Lodo, Mãe-Enxame, Cornífero, Malebranche, Harpia | Respira fundo; o peso balança | Esmaga e recua; respingo de tinta | **Desaba**: a figura achata até um terço da altura, escurece e fica. **Isto são os "restos"** que você decidiu ligar em todos os Corpóreos, sem desenho novo |
| **Fumaça** | Espirituais: Sombra do Desejo, Sopro Errante, Caído de Dite, Vulto Mascarado, os Pecados Encarnados | O corpo todo ondula; a borda se desfaz; **não tem sombra no chão**, flutua um pouco | **Rasga**: a imagem se parte de lado por um instante e se recompõe. Não recua | **Evapora** para cima, por uma borda rasgada |
| **Casca** | Os de armadura e carapaça: Escaravelho, Sentinelas, Caído das Muralhas | Quase imóvel; respiração mínima | Não esmaga: **treme seco** e solta lascas | **Estilhaça**: racha em silhueta e cai em cacos de tinta |
| **Enxame** | Enxame, Moscardo | Tremor miúdo e constante; sobe e desce | Espalha e junta | Dispersa em pontos |

---

## 6. Seis jeitos de se mover, um por função

O jogo tem três famílias, e cada família tem as mesmas **seis funções**. Em vez de animar 19 inimigos, animam-se **6 funções**. Cada inimigo herda o jeito da sua função e a matéria do seu corpo.

| Função | Jeito de se mover | Parado | Ataque | A intenção no corpo |
| --- | --- | --- | --- | --- |
| **Bruto** | Pesado, lento, inevitável | Respiração funda e lenta; balança de um pé para o outro | Antecipação longa, investida curta, parada no impacto longa, o chão treme | Inclina devagar na direção de quem vai apanhar |
| **Guarda** | Plantado | Quase imóvel | Meio passo e empurrão; nunca atravessa o campo | Ao defender, **encolhe e endurece** (a casca de tinta da Bíblia) |
| **Atirador** | Arisco | Inquieto; sobe e desce se voa | Não avança: **recua com o coice** do disparo; o projétil é um desenho pequeno que voa em arco | Recua um passo e aponta |
| **Corruptor** | Parado e alto | Ondula; cresce devagar | **Estica para cima**; a tinta nasce nos pés do santo e sobe | Cresce e escurece a borda |
| **Manipulador** | Giratório | Balanço constante de um lado para o outro | Linhas de vento desenhadas; o santo é que se move | Gira mais rápido |
| **Invocador** | Convulso | Pulsa na altura da barriga | Tremores curtos e seguidos; a poça se abre e a cria **brota** dela | Incha |

**A conta:** 6 funções × 4 matérias cobrem os 19 comuns. As três famílias se distinguem pelo desenho e pela cor do círculo, que já existem.

| Inimigo (exemplos da família A) | Função | Matéria | Peso | O que ele precisa de arte |
| --- | --- | --- | --- | --- |
| Diabo de Lodo | Bruto | Carne | Pesado | A imagem que já tem |
| Escaravelho Infernal | Guarda | Casca | Médio | A que já tem |
| Moscardo | Atirador | Enxame | Leve | A que já tem + 1 ferrão (projétil) |
| Sombra do Desejo | Corruptor | Fumaça | Leve | A que já tem |
| Sopro Errante | Manipulador | Fumaça | Leve | A que já tem |
| Mãe-Enxame | Invocador | Carne | Pesado | A que já tem |
| Enxame | Bruto | Enxame | Leve | A que já tem |

**Opcional, por inimigo:** uma segunda imagem, a **pose de ataque**. Onde ela existir, o motor troca no tempo 2 da frase do golpe. Onde não existir, a imagem parada esticada pelo motor já funciona. Sugiro dar a pose de ataque só aos **brutos** e **atiradores**, que são os que mais se veem atacar.

---

## 7. Quantos desenhos cada tipo de personagem precisa

| Tipo | Hoje | Proposta | Observação |
| --- | --- | --- | --- |
| **Inimigo comum** | 1 imagem | **1** (2 para brutos e atiradores) | Os 19 já existem. Nenhum vídeo |
| **Elite** | Minos: 1 vídeo parado + 4 poses · Vertigem: ~15 desenhos | **3 poses**: parado, ataque, derrota | O modelo é Minos (D-229). Os outros 14 elites: 42 imagens no total |
| **Chefe** | Asmodeu: 3 vídeos | **3 quadros nítidos no parado** (seguros com fusão, D-344) **+ 3 poses + o efeito próprio** | O efeito próprio (o sopro) é o que faz o chefe; vale o desenho |
| **Santo** | 3 vídeos por santo (parado, andar, ações) | **9 imagens**: parado, 2 passos de andar, preparar, golpear, defender, golpe recebido, ajoelhar, caído | Ver §8 |

**Por que isto importa além do custo:** os quadros de vídeo de cada santo ocupam dezenas de megabytes na memória do celular (pendência de D-330). Nove imagens por santo são uma fração disso.

---

## 8. Os santos

### 8.1 Os três que já existem

Ficam como estão. Os vídeos de Jorge, Bento e Teresinha foram aprovados e custaram caro. O núcleo se aplica **por cima**: sombra, antecipação, parada no impacto, onda na barra da roupa.

### 8.2 Os nove que faltam: por poses, não por vídeo

- São 27 vídeos se for pelo caminho antigo (mais de 4.000 créditos). Pelo caminho de Minos, são **9 imagens por santo**, geradas na mesma ferramenta e com a mesma referência do `body_idle`. A folha `prompts-saints.md` já prevê `body_attack`, `body_hit` e `body_fall` para cada santo.
- **O parado:** uma imagem, com respiração, balanço e onda na roupa (gestos 7 e 8). Se ficar parado demais, o truque do Asmodeu: três versões quase iguais, seguras por mais de um segundo cada, com fusão.
- **O andar com dois desenhos.** Em vez de um ciclo de 8 quadros: duas poses de passo (um pé à frente, depois o outro), trocadas em corte seco, com a figura **subindo e descendo** a cada passo, inclinada para a frente, poeira no pé que pousa e a sombra acompanhando. É como Darkest Dungeon anda. **É o item que eu mais recomendo testar primeiro**, porque decide se os nove santos precisam ou não de vídeo.

### 8.3 Um jeito de se mover para cada santo

Tirado só do papel de cada um nos kits; nada aqui é fato de santo. **Proposta.**

| Santo | Peso | Jeito | O detalhe que o distingue |
| --- | --- | --- | --- |
| Jorge | Médio | Direto: investida em linha reta, freada seca | A capa chega depois dele (onda na barra, atrasada) |
| Bento | Pesado | Devagar e firme: planta o báculo antes de agir | No exorcismo não sai do lugar; o chão treme de leve quando o báculo bate |
| Teresinha | Leve | Passos pequenos; nunca corre | Quase sem antecipação; as pétalas é que fazem o gesto |
| Nicolau | Médio | Calmo, de mãos abertas | Ao dar uma provisão, inclina-se para o companheiro |
| Antão | Pesado | Curvado, econômico; quanto mais desolação, **mais ereto** | É o traço Ermitão dito pelo corpo |
| Joana | Médio | Avança sempre; nunca recua ao bater | O estandarte ondula no alto (onda "alto") |
| João da Cruz | Leve | Quase imóvel; cabeça baixa | Na Noite Escura de um companheiro, vira-se para ele |
| Padre Pio | Médio | Parado, e de repente **em outro lugar** | A Bilocação é um corte seco com silhueta, sem deslizar |
| Rita | Leve | Suave; estende a mão | Quando o aliado está no limite, o gesto fica rápido |
| Antônio | Leve | Gesto largo de quem prega | Aponta; o efeito cai longe dele |
| Sebastião | Pesado | Imóvel atrás do escudo; **não recua ao apanhar** | O recuo dele é zero: só treme. É a Provocação dita pelo corpo |
| Gertrudes | Leve | Ereta, serena | Movimento mínimo; a luz se move por ela |

### 8.4 A desolação no corpo

Liga com a auréola em eclipse, já aprovada. Sem desenho novo:

| Estado | No corpo |
| --- | --- |
| Normal | Respiração calma |
| Desolação 75+ | Respira mais curto; os ombros caem um pouco (a figura encolhe 2% e inclina para a frente); a sombra cresce |
| Noite Escura | Quase sem respiração; antecipação mais lenta; a volta ao lugar é arrastada |
| Consolação | Ereto; respiração larga; **sem sombra** (a clareira de ouro) |
| Caído | A pose de ajoelhar e depois a de caído; a auréola desce junto |
| Levantado | A pose de ajoelhar, um instante de silhueta em ouro, e de pé |

---

## 9. Elites e chefes

- **Elite = 3 poses + a ficha.** O que faz o elite parecer elite é o **peso** (um degrau acima dos comuns) e uma coisa própria na ficha. Exemplos de forma: Cérbero com três antecipações seguidas, uma por cabeça; a Medusa que não se move e só vira o rosto (silhueta); o Minotauro com a investida mais longa do jogo.
- **Chefe = parado em 3 quadros + 3 poses + efeito próprio + câmera.**
  - Peso **colossal**: a parada no impacto mais longa, o chão treme, **todos** os santos reagem (gesto 11).
  - **Troca de fase:** silhueta na cor do círculo, a câmera recua, uma **garra do Domínio** cede ou se fecha (já aprovado).
  - O chefe **reage ao que a companhia faz** fora da vez dele: encolhe quando o Domínio cede, inclina-se para a frente quando um santo cai. Só gestos 7 e 12; nenhuma arte.
- **Lúcifer** é cenário: quase não se move. As seis asas com a onda "alto", bem lenta, e o gelo estalando. A imobilidade é o que assusta.

---

## 10. Prioridade: o que mais muda a sensação por menos trabalho

| Ordem | O quê | Sensação | Custo | Arte nova | Cabe no M2? |
| --- | --- | --- | --- | --- | --- |
| 1 | **Parada no impacto, recuo que passa do ponto, câmera com direção** (gestos 1 e 6) | O golpe passa a doer | Baixo | Nenhuma | Sim |
| 2 | **Sombra no chão e poeira** (2 e 4) | Os personagens ganham chão | Baixo | 1 folha pequena | Sim |
| 3 | **Antecipação por peso e borrão** (3 e 5) | Cada personagem tem massa | Baixo | Nenhuma | Sim |
| 4 | **Inimigos por função e matéria** (§5 e §6), com onda e dissolver (8 e 9) | Os 7 inimigos do Círculo 2 ganham vida com a imagem que têm | Médio | Nenhuma (opcional: pose de ataque dos brutos) | Sim: é a T52 feita de outro jeito |
| 5 | **A intenção no corpo** (12) | Ler o inimigo pelo corpo; identidade própria | Baixo a médio | Nenhuma | Sim |
| 6 | **Reação em volta** (11) | O campo inteiro vive | Baixo | Nenhuma | Sim |
| 7 | **O andar com dois desenhos** (§8.2), testado com um santo | Decide se os 9 santos precisam de vídeo | Médio | 2 imagens de teste | Sim, como teste |
| 8 | **A desolação no corpo** (§8.4) | A provação se vê sem olhar a barra | Baixo | Nenhuma | Sim |
| 9 | **Animar "aos pulos"** (regra 3 do §1) | Motor e desenho no mesmo mundo | Baixo | Nenhuma | Sim, como teste lado a lado |
| 10 | Os 9 santos por poses; elites e chefes por 3 poses | Produção | Alto (é o M3) | 9 por santo, 3 por elite | M3 |

**Os itens 1 a 3 juntos são cerca de uma tarefa e não pedem nenhuma arte.** Se só um bloco couber no M2, é esse.

## 11. Como testar

- A tela **"Animações (teste)"** já existe (T35). Acrescentar nela um interruptor por gesto (parada, sombra, antecipação, borrão, onda, aos pulos) e os quatro pesos. Você liga e desliga no Redmi e sente a diferença.
- Um par de combates com tudo ligado e tudo desligado, lado a lado.
- **Medir no aparelho:** quadros por segundo com 7 figuras, todas com o material de onda. Se cair, a onda fica só nos Espirituais.
- **Tempo do combate:** a meta é de 2 a 4 minutos por combate. A frase do golpe não pode esticar isso; por isso os totais do §3 ficam perto do tempo de hoje.

## 12. Riscos

| Risco | Como evitar |
| --- | --- |
| Animar demais e a luta ficar lenta | Teto de tempo por golpe; a velocidade 2× corta tudo pela metade |
| A onda parecer "gelatina" | Amplitude pequena, só na região certa, aos pulos; desligada em quem é de casca |
| Esmagar e esticar virar desenho animado | Porcentagens pequenas (de 4% a 8%); zero em santos de peso leve e em casca |
| O andar com dois desenhos parecer pobre | É um teste: se não passar, os santos novos ganham um ciclo curto desenhado (4 quadros), ainda sem vídeo |
| Misturar santos em vídeo (os 3 atuais) com santos em poses (os 9 novos) | O núcleo por cima de todos aproxima; e os 3 atuais já usam poses seguras nas ações |
| Peso no celular | Um material só, uma textura de ruído pequena, sem luz dinâmica, poucos sprites de poeira |
| Decisão de regra escondida na animação | A animação só lê o estado; nada de sorteio das regras; o modo instantâneo dá o mesmo resultado |

## 13. O que eu preciso que você decida

1. **O bloco de peso** (parada no impacto, sombra, poeira, antecipação, borrão): entra no M2?
2. **Inimigos comuns com uma imagem só**, animados por função e matéria: aprova, no lugar de gerar quadros para cada um na T52?
3. **Pose de ataque** só para brutos e atiradores: sim, ou nenhuma por enquanto?
4. **A intenção no corpo** do inimigo: aprova para testar?
5. **Os 9 santos por poses** (9 imagens cada), sem vídeo, se o teste do andar com dois desenhos passar?
6. **Animar aos pulos** (12 por segundo) as deformações do motor: testar lado a lado?
7. Quer uma **página de teste** como as outras, com os gestos ligando e desligando sobre um personagem do jogo, antes de alguém programar no Godot?

---

## 14. Decisões de Alan (12/11/2026) e o que elas mudam neste documento

| # | Pergunta | Resposta de Alan | O que muda |
| --- | --- | --- | --- |
| 1 | Bloco de peso no M2 | **Sim** | Parada no impacto, recuo, câmera com direção, sombra, poeira, antecipação e borrão entram no M2 |
| 2 | Inimigos com uma imagem só | **Não.** Prefere **gerar os quadros de ação dos inimigos**; o motor faz os efeitos e a transição | O §6 continua valendo para o **jeito** de cada função (tempos, peso, parado), mas as ações usam poses desenhadas. O §7 muda: ver a conta abaixo |
| 3 | Pose de ataque só para alguns | **Todas as poses para todos** | Cada inimigo tem o mesmo conjunto dos atuais: parado, preparar, golpear, defender, golpe recebido, queda |
| 4 | A intenção no corpo | **Aprovada, junto com as poses** | O motor inclina e muda a respiração; quando a pose de "preparar" existir, ela pode aparecer já no turno do jogador para quem vai atacar |
| 5 | Os 9 santos por poses | **Não.** Prefere **vídeo**; pediu o custo no ImagineArt | O §8.2 (andar com dois desenhos) fica arquivado. Conta abaixo |
| 6 | Animar aos pulos | **Sim para os inimigos**; os santos ficam todos com vídeo | As deformações do motor em passos valem para os inimigos (que são poses). Nos santos, o vídeo já tem o seu ritmo; a respiração do motor fica como está |
| 7 | Página de teste | Só se for necessária; o que custar menos | **Testar direto no APK**, na tela "Animações (teste)" que já existe, com um interruptor por gesto. Uma página seria feita duas vezes (em código de página e depois no Godot) |

### A conta dos santos em vídeo

Preço conhecido pelo histórico do projeto: **Wan 3, 480p, 150 créditos por clipe** (D-224, D-225). Cada santo tem 3 clipes (parado, andar, ações).

| Item | Clipes | Créditos |
| --- | --- | --- |
| 1 santo | 3 | 450 |
| Os 9 santos que faltam | 27 | **4.050** |
| Margem para refazer (no histórico, cerca de 1 em cada 5 clipes precisou de nova tentativa) | ~6 | ~900 |
| **Total estimado** | ~33 | **~5.000** |

- Saldo em 12/11/2026: **10 créditos**. O saldo inicial do projeto foi 3.100 (D-221).
- **Não sei o preço em reais** de cada crédito; depende do seu plano.
- Para gastar menos: gerar **um santo inteiro primeiro** (450) e aprovar no celular antes dos outros oito; usar sempre a imagem de partida **com margem em 3:4**, que evitou os pés cortados (D-222, D-224).
- **Atenção à memória do celular:** os quadros de vídeo de cada santo ocupam dezenas de megabytes (D-330). Com 12 santos em vídeo, a compressão de textura prevista para a T53 deixa de ser opcional. Em combate só 3 santos estão na tela, então o jogo pode carregar só os três da equipe.

### A conta das poses dos inimigos

Cinco poses de ação por inimigo (preparar, golpear, defender, golpe recebido, queda), além da imagem parada que já existe.

| Grupo | Quantos | Poses a gerar |
| --- | --- | --- |
| Família A (o que o M2 precisa) | 7 | **35** |
| Famílias B e C e o Caído das Muralhas | 13 | 65 |
| Elites (fora Minos e Vertigem, já feitos) | 14 | 70 |
| Chefes (fora Asmodeu), mais o efeito próprio de cada um | 8 | 40 |
| **Total** | 42 | **210** |

- **Custo:** se forem geradas onde você gerou os personagens (o Meta AI serviu para a Vertigem), não gastam créditos. No ImagineArt, o único preço que medi foi **25 créditos por imagem** no modelo mais barato (o teste de Lúcifer): 35 poses seriam cerca de 875 créditos; as 210, cerca de 5.250. Outros modelos têm outro preço, que eu não medi.
- **Cuidado que o histórico ensina:** o Meta AI perdeu a fidelidade em personagem complexo (Asmodeu, D-254). Para os simples (a maioria dos comuns) tende a funcionar; para os complexos, usar a mesma ferramenta que fez o personagem, com a imagem parada como referência.
- **Para render mais:** pedir as 5 poses de um inimigo **numa folha só**, com a mesma escala e a mesma linha de chão. Uma geração por inimigo em vez de cinco, e as poses saem coerentes entre si.
