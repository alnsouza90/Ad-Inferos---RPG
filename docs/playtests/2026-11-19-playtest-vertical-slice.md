# Playtest da fatia vertical · Revisão geral do jogo

Data: 19/11/2026 · Jogador: Alan (responsável pelo projeto) · Escopo: uma expedição completa do Círculo 2, da vila ao chefe
Estado: **pedido de análise e plano**. Nada deve ser implementado antes da aprovação do plano.

## 0. Instruções para o Claude Code

Este documento organiza as anotações do playtest e define a direção do redesign. O trabalho tem três etapas, e **só a terceira mexe no jogo**:

1. **Auditoria.** Para cada item com código (`B`, `D`, `V`, `M`, `P`, `C`, `H`, `A`, `N`), descubra o que existe hoje no repositório e como está feito. Preencha a tabela do §9 com:
   - estado: implementado · parcial · não existe · bug confirmado · não reproduzido;
   - onde: cena, script ou dado responsável;
   - causa provável (para bugs);
   - tamanho: P (horas) · M (1–2 dias) · G (3+ dias);
   - dependências entre itens.
2. **Plano de revisão.** Entregue em `docs/playtests/2026-11-19-plano-de-revisao.md`:
   - o relatório da auditoria (§9 preenchido);
   - as fases propostas (§8 é o ponto de partida; ajuste a ordem se a auditoria mostrar outra melhor);
   - as mudanças de especificação necessárias para as decisões do §2, arquivo por arquivo;
   - a lista de **assets de arte e de áudio** que faltam, para Alan gerar os prompts;
   - riscos e perguntas.
3. **Execução**, fase por fase, só depois de Alan aprovar o plano. Cada fase termina com uma build Android para novo playtest.

Regras: siga o `CLAUDE.md`. As decisões do §2 são **pedido explícito do responsável** para mudar GDD e especificações, mas só depois da aprovação do plano. Onde este documento e uma especificação conflitarem, aponte o conflito no plano em vez de escolher sozinho.

## 1. Diagnóstico e direção

O jogo funciona, mas está **monótono, pouco intuitivo e pequeno demais para o celular**. Os quatro problemas de fundo:

1. **Legibilidade:** fontes pequenas, molduras grossas, ícones minúsculos, textos saindo dos painéis.
2. **Fluidez:** a troca de tela entre andar e lutar quebra o ritmo. Clicar em "Entrar" para seguir em frente cansa.
3. **Peso e resposta:** os golpes não têm impacto, o toque não dá retorno e às vezes não se sabe quem foi selecionado.
4. **Repetição visual:** cenários sem variedade, peças de parallax cortadas, efeitos antigos convivendo com os novos.

### 1.1 Pilares do redesign

| Pilar | O que significa na prática |
| --- | --- |
| **Celular primeiro** | Tudo importante ao alcance dos polegares; fontes grandes; alvos de toque grandes; nada fora das paredes de tijolos da moldura |
| **Um mundo contínuo** | Andar, lutar, acampar e decidir acontecem no mesmo cenário, sem troca de tela |
| **Um HUD só** | A mesma interface para caminhada, combate e Pouso; muda o que está ativo, não o lugar das coisas |
| **Cada toque responde** | Seleção clara, vibração leve, som, brilho; o jogador nunca se pergunta "cliquei?" |
| **Golpes com peso** | Inimigos leves, médios e pesados se sentem diferentes: pausa no impacto, tremor, recuo, mancha de tinta |
| **Arte de estampa** | Todos os efeitos seguem a linguagem de estampa e tinta; nenhum efeito antigo de cruzes girando |
| **Variedade com intenção** | Cenários planejados por trecho, com props que os santos usam (escada, porta, caverna) |

### 1.2 Metas de legibilidade (para 1920 × 1080; valem como mínimo)

| Elemento | Mínimo |
| --- | --- |
| Texto corrido (descrições, fichas) | **32 px** |
| Rótulo de botão | **36 px** |
| Números importantes (vida, Fervor, Lume, dano) | **44 px** |
| Alvo de toque | **120 × 120 px** (≈ 48 dp num celular comum) |
| Espaço entre alvos de toque | 16 px |
| Contraste do texto | 4,5 : 1 |

Toda tela deve caber dentro da área útil da moldura de tijolos, com quebra de texto automática.

## 2. Decisões de design (mudam GDD e especificações)

| ID | Decisão | Afeta | Observação para o plano |
| --- | --- | --- | --- |
| **D1** | O santo leva **3 habilidades + o milagre** (hoje são 4 + milagre). A roseta sai; o milagre fica num vitral de fundo dourado, como as habilidades | `combat.md` §2.5, `saint-kits.md`, `abilities.csv`, interface | Manter a regra de que pelo menos uma das 3 custe 0 (Noite Escura). Verificar o impacto no equilíbrio pelo simulador |
| **D2** | **Não existe botão "Encerrar turno"**: o turno da equipe acaba quando todos os santos agiram ou passaram | `combat.md` §4, interface | "Passar" continua como ação de cada santo |
| **D3** | **Andar e lutar no mesmo ambiente.** O combate começa no próprio corredor e, ao fim, a companhia volta a andar sem troca de tela | `expedition.md`, arquitetura de cenas | Provavelmente a maior mudança técnica; avaliar no plano |
| **D4** | **HUD único** para caminhada, combate e Pouso | interface | Ver §6 |
| **D5** | Seguir em frente é **só andar**: sem botão "Entrar". Nós com prop (escada, porta, caverna) têm uma animação em que os santos interagem com o prop | `expedition.md`, interface, animação | Ver §5 |
| **D6** | Nós de evento (Tentação, Encontro com alma, Relíquia) têm **cenário fixo por círculo**; só muda o conteúdo (a alma, o evento) | `expedition.md`, arte | — |
| **D7** | Nova estrutura de trechos do Círculo 2, com nó pré-guardião e Minos no fim do Trecho 1 | `expedition.md` §1–2, `encounters.csv` | Ver §7. Definir se vira regra geral dos círculos |
| **D8** | Santo designado para Capela, Jardim ou Enfermaria **sai da equipe e vai para a reserva** na hora | `village-economy.md` §4 | Hoje ele continua na equipe e só aparece um aviso |
| **D9** | **Botão "Passar a semana"** na vila, para recuperar santos sem descer | `village-economy.md` §1 | Conflita com o limite atual do Retiro (uma vez entre expedições). Proposta: sem limite quando não há 3 santos aptos |
| **D10** | **Derrota sem substitutos:** se não houver 3 santos aptos, o jogo não trava; o jogador passa semanas (D9) até liberar a Enfermaria, um santo por vez | `village-economy.md`, `expedition.md` §9 | Garantir que nunca existe estado sem saída |
| **D11** | O Portão mostra **só os espaços vazios** na reserva, sem os nomes dos santos que ainda vão chegar | interface da vila | Preserva a surpresa |
| **D12** | Itens, relíquias e qualquer elemento de interface **nunca recebem o filtro de cor do círculo** | renderização | O filtro vale só para cenário e inimigos |

## 3. Bugs

| ID | Bug | Onde | Como reproduzir |
| --- | --- | --- | --- |
| **B01** | Às vezes o turno passa **sem o inimigo atacar** | Combate, também no chefe | Jogar vários turnos e conferir o log de intenções contra as ações executadas |
| **B02** | As **escoltas de Asmodeu não atacam** | Chefe do Círculo 2 | Luta contra Asmodeu |
| **B03** | Clicar na **estátua de Nossa Senhora** não toca a Ave-Maria em latim | Vila | Tocar na estátua |
| **B04** | **Contorno de seleção** (outliner) dos edifícios não aparece; não funciona no Advento nem na Quaresma | Vila | Tocar num edifício em cada tempo litúrgico |
| **B05** | Bento: **vestígio de fundo piscando** na perna direita | Sprite de Bento | Observar Bento parado e andando |
| **B06** | **Animação de andar de Teresinha** não funciona | Caminhada | Andar com Teresinha na equipe |
| **B07** | Teresinha fica **meio transparente** ao cair | Combate | Deixar Teresinha cair |
| **B08** | **Efeitos antigos e novos juntos**: exorcismos ainda giram cruzes antes da estampa; o Amparo de Jorge mostra o escudo antigo e o novo; o milagre de Bento mostra a cruz girando e a estampa; todas as habilidades de Teresinha usam o efeito antigo | Efeitos de combate | Usar cada habilidade. Correção: **só a estampa**, em todas |
| **B09** | A **ponta da lança de Jorge some** no ataque | Animação de Jorge | Atacar com Jorge. Solução sugerida: sprite de golpe com brilho âmbar na ponta, desenhado pelo motor |
| **B10** | **Alforje** só aparece ao andar; no combate o ícone existe mas é minúsculo; não aparece no Pouso nem na Vigília | HUD | Abrir o alforje em cada situação |
| **B11** | A **ficha do inimigo** sai para fora do painel | Combate | Abrir a ficha de um inimigo com texto longo |
| **B12** | Na ficha do santo (ex.: Bento), a descrição **invade a área de posição e alvo** | Ficha do santo | Abrir a ficha de Bento |
| **B13** | Santo no Jardim continua aparecendo na equipe do Portão (ver D8) | Vila | Pôr Bento no Jardim e abrir o Portão |
| **B14** | Peças de **parallax de primeiro plano cortadas** | Cenários | Andar pelos trechos |
| **B15** | Na Vigília, a **peça do meio (pedras brancas)** cobre o portão e destoa | Cenário da Vigília | Chegar à Vigília |

## 4. Vila

| ID | Item | Tipo |
| --- | --- | --- |
| **V01** | Tocar num edifício o **acende** (contorno); um segundo toque **entra** nele | Interação (ligado a B04) |
| **V02** | **Natal à noite**, com céu estrelado | Arte e ambientação |
| **V03** | **Despensa:** tocar num item mostra o que ele faz | Interface |
| **V04** | **Portão:** só espaços vazios na reserva (D11); santos designados vão para a reserva (D8) | Interface e regra |
| **V05** | **Casa de Exercícios:** mostrar claramente o custo de cada melhoria e o saldo ao selecionar | Interface |
| **V06** | **Botão "Passar a semana"** (D9, D10) | Regra e interface |
| **V07** | **Ficha do santo** e **minificha** mostram o estado: ferimento leve ou grave, Noite Escura, Consolação | Interface |
| **V08** | Ficha do santo com 3 habilidades + milagre em vitral dourado (D1) | Interface |
| **V09** | Estátua de Nossa Senhora: ao tocar, toca a **Ave-Maria em latim** (B03) | Áudio e interação |

## 5. Mapa, caminhada e nós

| ID | Item | Tipo |
| --- | --- | --- |
| **M01** | **Mapa do Inferno:** o caminho entre Portão, Pousos e chefe vira uma linha reta, sem seguir a geografia: `ícone · ● ● ● · ícone · ● ● ● · ícone`, com pontos âmbar. Ícones e pontos **maiores**, fáceis de tocar e com estado aceso bem visível | Interface |
| **M02** | Seguir em frente é **só andar** (D5); sem botão "Entrar" | Interação |
| **M03** | **Bifurcações** planejadas peça por peça, em harmonia com o nó seguinte | Arte e level design |
| **M04** | **Props de nó** na escala dos santos: escada, porta, caverna, ponte etc., com animação dos santos interagindo (virar de costas e entrar na caverna, subir a escada, abrir a porta) | Arte e animação |
| **M05** | **Trechos pré-definidos** de cenário em vez de peças montadas ao acaso (ver §7) | Level design |
| **M06** | **Tenda da Tentação:** refazer | Arte |
| **M07** | Nós de evento com **cenário fixo** por círculo (D6) | Arte e dados |
| **M08** | **Encontro com as almas:** animar as almas do fundo | Animação |
| **M09** | Revisar o **parallax de primeiro plano** peça por peça (B14) | Arte |
| **P01** | **Pouso e Vigília** usam o mesmo HUD do resto do jogo (D4) | Interface |
| **P02** | Tocar num santo no Pouso abre a **tela de atividades**: as comuns e a própria do santo, com descrição em fonte grande | Interface |
| **P03** | Alforje visível no Pouso e na Vigília (B10) | Interface |

## 6. Combate e HUD

### 6.1 HUD unificado (caminhada, combate, Pouso)

| ID | Item |
| --- | --- |
| **H01** | Tudo dentro do espaço das paredes de tijolos, com tamanhos e posições revistos |
| **H02** | **Realocar o Fervor** e o **Lume** para lugares fixos e visíveis |
| **H03** | Barra do santo ativo: **3 habilidades + milagre** em vitral dourado (D1), sem a roseta |
| **H04** | Ações comuns (**Trocar, Passar**, provisão) junto das habilidades do santo, grandes, com moldura fina |
| **H05** | **Botão de abrir o Alforje** e **botão de abrir o Mapa**, sempre no mesmo lugar |
| **H06** | Habilidades e itens que não podem ser usados naquele momento ficam **cinza**, com o motivo |
| **H07** | Tocar numa habilidade abre um **quadro com os detalhes** (efeito, alvo, custo); tocar de novo usa |
| **H08** | **Espaço das relíquias equipadas**; tocar mostra o efeito. Relicário maior |
| **H09** | Sem botão "Encerrar turno" (D2) |
| **H10** | Ícones de itens e relíquias **sem o filtro do círculo** (D12) |

### 6.2 Sensação de combate

| ID | Item |
| --- | --- |
| **C01** | **Início da luta:** a tela escurece e aparece um elemento de entrada (ver sugestões no §6.3) |
| **C02** | **Ataque em close:** o fundo desfoca ou escurece; atacante e alvo deslizam para o centro com zoom; o golpe acontece; os dois voltam |
| **C03** | **Peso dos golpes** por categoria de inimigo (leve, médio, pesado): pausa no impacto, tremor da tela, recuo do alvo e tamanho da mancha de tinta crescendo com o peso |
| **C04** | **Atiradores** (Moscardo, Arqueiro, Arpoeiro) disparam algo que **viaja até o alvo**: o ferrão sai da boca do Moscardo |
| **C05** | **Condições na tela:** ao aplicar Sangramento, Atordoamento etc., o nome aparece escrito grande sobre o alvo e depois vira o ícone |
| **C06** | **Golpes físicos** com efeito de mancha de tinta |
| **C07** | **Todas as habilidades com estampa** própria (B08); criar estampas que faltam |
| **C08** | **Milagres com mais impacto:** escurecer mais, segurar um instante e depois tremer a tela |
| **C09** | **Nova estampa do milagre de Teresinha** (a atual não agradou) |
| **C10** | **Ataques espirituais dos inimigos** mais visuais |
| **C11** | **Vitória:** aviso maior e uma caixa que se abre mostrando os ícones do que foi ganho (Esmolas, itens, relíquias) |
| **C12** | Ao fim da luta, a companhia **volta a andar** no mesmo cenário (D3) |
| **C13** | **Alforje no combate** claro: cada item mostra o que faz (H05, H07) |

### 6.3 Sugestões para as perguntas do playtest

**Elemento de início de luta (C01).** Três opções, em ordem de preferência:
1. **Sino e mancha de tinta:** um toque grave de sino; uma mancha de tinta preta se espalha das bordas e escurece a tela; no centro, uma estampa de **espada cruzada com uma cruz**, que some em seguida. Tem a cara do jogo e fala de fé e combate.
2. **Selo de lacre:** um selo de cera vermelho com a cruz bate no centro da tela, como um documento selado.
3. **Duas espadas cruzadas:** a ideia original, em estampa de tinta. Funciona, mas é mais genérica.

**Seleção de quem age e de quem é alvo (H07, item do playtest "melhorar o outliner").**
- **Santo que vai agir:** contorno dourado de vela pulsando devagar, uma pequena chama sobre a cabeça e o retrato dele em destaque na barra.
- **Alvos possíveis:** contorno vermelho-tinta suave em todos.
- **Alvo escolhido:** um anel de tinta girando aos pés, uma linha pontilhada do santo até o alvo e a pré-visualização do dano em número grande.
- **Toque com peso:** vibração curta em cada toque válido; vibração dupla e som seco quando o toque não é válido; som de pena riscando ao selecionar.

**Peso dos golpes (C03).** Valores de partida para calibrar:

| Peso do golpe | Pausa no impacto | Tremor da tela | Recuo do alvo | Mancha de tinta |
| --- | --- | --- | --- | --- |
| Leve | 40 ms | nenhum | curto | pequena |
| Médio | 80 ms | leve | médio | média |
| Pesado | 140 ms | forte | longo, com poeira | grande |
| Milagre | 250 ms com tela escura | forte, depois de segurar | — | estampa dourada |

O peso vem da categoria do atacante (`role` em `enemies.csv`: Bruto = pesado, Guarda = médio, Atirador = leve) e de uma marca nas habilidades dos santos. Os números ficam num recurso de apresentação, não em `docs/balance/`.

## 7. Cenários do Círculo 2 (estrutura nova)

### 7.1 Estrutura dos trechos

| Trecho | Sequência de nós |
| --- | --- |
| **1** | Entrada (Trono de Minos ao fundo) → caminhada e combates comuns → **Tentação** → caminhada e combates → **Encontro com alma** → elite (Pecado Encarnado) → **pré-guardião** (chegada diante de Minos; pode ter uma luta) → **Minos, dentro do Júri** → **Pouso** |
| **2** | Mesma estrutura do Trecho 1, **sem** pré-guardião e sem Minos, com **cenários exclusivos** → **Pouso** |
| **3** | Mesma estrutura, com **cenários exclusivos** → **Vigília** → **Chefe do círculo (Asmodeu)** |

Para o plano: confirmar se a Tentação, a alma e a elite ficam em posições fixas ou continuam sorteadas como hoje (`expedition.md` §2.1).

### 7.2 Cenários a produzir

| Cenário | Quantidade | Regra |
| --- | --- | --- |
| Entrada do Trecho 1 (Trono de Minos ao fundo) | 1 | Peça única |
| Corredores de caminhada e luta comum | **3 tipos por trecho** = 9 | Cada tipo com pista (chão), primeiro plano, segundo plano e fundo; emendam entre si e com os nós |
| Nó da Tentação | 1 | Igual em todo o círculo |
| Nó da alma | 1 | Igual em todo o círculo; muda só a alma |
| Pré-guardião (diante de Minos) | 1 | Trecho 1 |
| Júri de Minos | 1 | Trecho 1 |
| Pouso | 1 (ou 2, se os trechos 1 e 2 tiverem Pousos diferentes) | — |
| Vigília | 1 | Refazer a peça central (B15) |
| Arena de Asmodeu | 1 | Já existe; revisar |
| Props de transição | escada, porta, caverna, ponte (definir no plano) | Na escala dos santos, com animação de interação |

Depois do plano aprovado, Alan gera os prompts desses cenários a partir da lista de assets do agente.

## 8. Fases sugeridas (ponto de partida para o plano)

| Fase | Conteúdo | Por quê nesta ordem |
| --- | --- | --- |
| **F1 · Correções** | B01–B15; D8, D10 (sem estado sem saída) | Bugs e travas atrapalham qualquer outro teste |
| **F2 · HUD e legibilidade** | D1, D2, D4, D12; H01–H10; metas do §1.2; fichas (V07, V08) | É a base de tudo que vem depois |
| **F3 · Sensação de combate** | C01–C11, C13 | O maior ganho de diversão por esforço |
| **F4 · Mundo contínuo** | D3, D5, C12; M02, M04; P01–P03 | A maior mudança técnica; depende do HUD único |
| **F5 · Cenários do Círculo 2** | D6, D7; M03, M05–M09; §7 | Depende da caminhada contínua e dos props |
| **F6 · Vila** | V01–V06, V09, D9, D11; M01 | Polimento da camada estratégica |

Cada fase fecha com uma build Android e um novo playtest de Alan.

## 9. Tabela de auditoria (o agente preenche)

| ID | Estado | Onde (cena, script, dado) | Causa provável | Tamanho | Depende de |
| --- | --- | --- | --- | --- | --- |
| B01 | | | | | |
| … | | | | | |

Liste todos os IDs deste documento: D1–D12, B01–B15, V01–V09, M01–M09, P01–P03, H01–H10, C01–C13.

## 10. Anotações originais do playtest

Mantidas como referência, sem edição de conteúdo.

> Ficha dos personagens: exemplo a de bento o traço a descrição esta invadindo a área da posição/alvo.
> escolher 3 habilidades o milagre tbm vai ficar em um vitral de fundo dourado.
> mostrar na ficha e na minificha status (ferimento ou noite escura)
> clicar na estatua de nossa senhora não esta funcionando a oração ave maria em latim.
> Não estou vendo os outliners ao clicar em um prédio ele deve ligar e um segundo clique te leva pra dentro do prédio.
>
> **Vila** · Geral Outliner não esta funcionando no advento e quaresma · natal pode ser noite e um céu estrelado · Despensa: parecer oque faz cada item ao clicar em cima. · Portão: vamos tirar os nomes do santos que vão chegar e deixar apenas os espaços na reserva. · Casa de Exercicios: oque custa melhorar cada habilidade, não esta claro ao selecionar, quanto custa e o saldo · botão de passar a semana em algum lugar, para eu poder ficar só recuperando se eu não tiver todos disponíveis para descer. · Quando coloquei bento no jardim e fui ao portão ele constava na equipe mas apareceu uma notificação que eles estava no jardim se eu colocar ele em algum lugar, enfermaria, catedral ou jardim ele tem que sumir da composição da equipe e ir para reserva.
>
> **Mapa do inferno:** ajustar o UI dos pontos portão, pousos e boss não precisa levar em consideração a geografia do mapa, proponho uma reta icone 3 pontos âmbar,icone 3 pontos,icone. E pode aumentar um pouco esta difícil de clicar e de saber se esta aceso.
>
> **Pouso e vigília:** não esta aparecendo o alforje · manter o mesmo HUD ele sera único agora · Clicando em um santo vai aparecer uma tela de habilidades do acampamento as comuns e as especificas para cada personagem · A fonte esta muito pequena onde explicam as habilidade e em um lugar ruim abrindo a tela de habilidades de cada personagem como eu disse acima ficaria simples de resolver isso também. · Se eu tiver derrota geral 3 santos gravemente feridos e não tiver mais 3 pra substituir oque fazer? Precisamos colocar na enfermaria e passar as semanas..um por um enquanto não libera.
>
> **Geral / andar / batalhas:** Personagem bento ainda aparece um vestígio de fundo piscando na perna direita. · Alforje só esta aparecendo ao andar, não aparece na luta nem nos pousos · animação de Teresinha ao andar não esta funcionando · os itens como relíquias, vestígios e tudo que precisar aparecer não podem estar com o filtro do circulo, achei o tamanho do relicário pequeno também. · no geral os botões estão com fonte pequena e difícil leitura · não achei intuitivo então temos que planejar melhor as interfaces. · O andar as peças das bifurcações estão ruins temos que ajustar uma por uma, podemos criar trechos pré definidos no quesito cenário? · A tenda da tentação esta ruim, refazer. · Os nós de evento (tentação, almas, relíquias são sempre iguais para o circulo.) · O andar e a luta devem fluir organicamente, não precisar entrar em outro ambiente para luta e sair dela para voltar para o andar. · muitos elementos de parallax de primeiro plano estão ruins e cortados. · Cenários do círculo 2: entrada trono de minos; nós comuns para andar e lutas comuns e da elite Pecado devem ser cenários preparados para emendar e para transicionar para um outro modelo, para não enjoar podemos definir 3 tipos com pista, primeiro, segundo plano e fundo; Nó da tentação sempre igual; Nó das almas cenário sempre igual só alterna a alma; Nó pré guardião: chegada antes de minos pode ter uma luta aqui; Nó Guardião Minos dentro do Juri; Fim do trecho 1; Pouso; Trecho 2 igual o trecho 1 na estrutura mas criar novos cenarios exclusivos para o trecho, não tem o nó pre guardião nem o Nó guardião; Pouso; Trecho 3 igual trecho 1,2 criar novos cenários exclusivos para o trecho. mas vai ter os nós: Vigília e Chefe de Círculo · Vigília antes do chefe arrumar a peça do meio pedras brancas esta tampando o portao e não combina com o resto. · Importante planejar os trechos e as interfaces da bifurcação para ser harmonioso com o nó planejar uma escada, planejar uma porta, planejar uma caverna e colocar os tamanhos proporcionais aos santos, e fazer a animação dos santos interagindo com esse prop virar as costas e entrar todos na caverna por exemplo, virar e subir uma escada, o seguir para frente deve ser apenas andar para frente e o nó vai continuar não preciso clicar em ENTRAR para seguir em frente. · no inicio da luta escurecer a tela e aparecer um elemento "prop" de luta (duas espadas? Sugestões?) · Na hora do ataque tela desfoca e ou escurece atras, o atacante e o alvo escorregam para o meio da tela em zoom e fazem o ataque. · não estou sentido o peso dos ataques como definimos inimigo pesados leves e médios. · atiradores como moscardo tem que ser animados para atirar algo, da boca e fazer o projétil ir ate o alvo. · penalidade, sangramentos, stun, aparecer escrito na tela no momento e depois ficar o icone sobre o alvo. · alforje na luta e item de cura (não fica claro oque cada item faz) · Melhorar o outliner quando escolher tanto o personagem que vai fazer a ação quanto o alvo, sugestões. · não estou sentindo o peso do toque e as vezes da pra se perder em quem clicou. · efeitos de ataque físicos com mancha de tinta · Os ataques tipo exorcismo estão com o efeito antigo ainda de rodar cruzes e depois da estampa, quero só o da estampa. · do Jorge com o escudo esta igual o escudo antigo depois o novo, seria só o estampado. · Vitoria na luta aparecer maior e abrir uma caixa com os icones do que foi ganho na luta, esmolas, itens · Voltar para o ambiente de andar sem troca de tela, tem que ser orgânico acabou a luta volta a andar. · a lança de Jorge some a ponta no ataque então coloque um efeito de brilho âmbar um sprite de ataque no motor. · Os milagres escurecer mais a tela segurar por mais um momento e depois tremer. Esta com pouco impacto visual. · Ataque espiritual do inimigo não esta muito visual · ataque da Teresinha ainda esta o antigo de rodar cruzes, todos ataques · Teresinha ao cair esta ficando meio transparente · habilidades tem que estar de estampa se não tiver um próprio pra ela vamos criar · milagre de bento esta aparecendo a estampa a cruz rodando e a cruz estampada é só a estampa do milagre e a animação · O escudo de amparo de Jorge esta com os dois efeitos o antigo e o novo · encontro com as almas animar as almas do fundo · Teresinha não gostei da estampa do milagre vamos ter que bolar outra
>
> **Boss e luta em geral:** estou tendo a impressão que as vezes passa o turno sem o inimigo atacar. Verificar isso · as escoltas do asmodeus não estão atacando verificar · Melhorar o HUD de Luta/andar (vamos unificar) · Ajustar o tamanho e posição de tudo para ficar dentro do espaço das paredes de tijolos. · Realocar FERVOR · Realocar LUME · Carregar apenas 3 habilidades + Milagre (retirar a roseta, deixar o milagre também em um vitral mas de fundo dourado) · Alforje não esta aparecendo na luta (confirmar na verdade esta mas muito pequeno o icone) temos que revisar o HUD. · As habilidades comuns trocar passar etc.. melhorar a caixa de retângulos moldura muito grossa, temos que realocar também devem ficar próximas das skills do personagem e de fácil acesso hoje estão muito pequenas. · A Ficha do inimigo esta saindo pra fora do painel de tras, ajustar quebra de texto. · tirar botão de encerrar turno, turno encerra quando acaba as ações · botão para abrir o alforje ou o mapa · As habilidades e itens que não puderem ser usados na caminhada ou na luta devem ficar cinzas. · ao clicar em uma habilidade abre um quadrado com os detalhes do que ela faz. · Espaço mostrando as relíquias equipadas ao clicar aparece o efeito.
