# 2 · Propostas (F-01 a F-18)

Versão 1.0 · 11/11/2026 · **tudo aqui é proposta**. Números são sugestões para o simulador, nunca valores finais. Nomes de mecânicas são provisórios.

**Como ler cada ficha:** problema → ideia → impacto no jogador → sistemas → custo (baixo, médio, alto) → risco → simulação.

**Minhas cinco apostas, se você só puder ler cinco:** F-01, F-05, F-07, F-12 e F-17.

---

## Pilar A · Intercessão

### F-01 · Interceder: tomar sobre si o peso do outro

- **Problema:** a intercessão é o tema do jogo, mas não é um gesto do jogador. "Ajudar" hoje é curar e aliviar, como em qualquer RPG.
- **Ideia:** todo santo ganha uma ação comum, ao lado de Trocar e Passar: **Interceder**. Ela gasta a ação do santo e não custa Fervor. O santo escolhe um aliado e **toma para si** uma destas coisas:
  - uma parte da desolação dele (proposta para o simulador: até 15); ou
  - todas as pilhas de **uma** condição negativa dele (Sangramento, Corrupção, Torpor…).
- **A regra de ouro:** interceder **move** o peso, não apaga. Curar e aliviar continuam sendo das habilidades. Assim os dois gestos não se confundem.
- **Tudo é exato e visível:** a prévia mostra quanto sai de um e quanto entra no outro.
- **Impacto no jogador:**
  - Ele ganha uma decisão nova em toda rodada: "quem aguenta mais agora?".
  - Ele pode **afastar um santo do teste de Fé** espalhando a desolação. É o jeito de lidar com o acaso sem tirar o acaso.
  - Ele pode **concentrar** o peso em quem foi feito para isso. Santo Antão fica mais forte com desolação (traço Ermitão). Sebastião aguenta Sangramento. Isso cria equipes com papel claro.
  - "Tomar o golpe" já existe sem regra nova: as intenções miram **posições**, então Trocar de lugar já é pôr-se na frente do outro. Vale ensinar isso ao jogador como parte do mesmo gesto.
- **Na tela:** um fio dourado liga os dois santos por um instante. O ouro continua reservado ao sagrado.
- **Sistemas:** `combat.md` (comando novo), `desolation.md` (transferência), prévia, IA do simulador, uma dica na primeira vez.
- **Custo:** médio.
- **Riscos:**
  - **Abuso com a Consolação:** um santo em Consolação recebe metade da desolação. Se a transferência passar por esse desconto, vira um jeito de apagar desolação. Sugestão: a transferência **não** passa por multiplicadores (igual às reduções hoje).
  - Pode diminuir o valor das habilidades de alívio de custo 0. Ver F-11.
  - Pode empurrar a Noite Escura para baixo da meta (0,5 a 1,5 por expedição longa).
- **Simulação:** sim. Medir Noites Escuras por expedição com e sem Interceder, e procurar o abuso da Consolação na caça a exploits (T56).
- **Regras do §2:** respeita todas. O santo age por vontade própria; nada é sorteado.

### F-02 · A Tentação relida como intercessão

- **Problema:** se o Peregrino não está na jornada, **quem é tentado na tenda?** Hoje a especificação diz que a Tentação é um evento com escolhas que mudam as Virtudes do Peregrino, e que o santo nunca peca. Fica um buraco: os santos não podem cair, e o Peregrino não está ali.
- **Ideia (estrutura, não texto):** a tenda mostra **uma tentação da vida do Peregrino**, revivida. Ele está no leito, repassando a própria vida. Os santos **assistem e intercedem**.
  - A escolha do jogador deixa de ser "aceitar ou recusar". Passa a ser **"como a companhia intercede"**: qual santo reza, o que a companhia oferece (uma provisão, Lume, um pouco de desolação tomada sobre si).
  - O resultado (com a chance sempre visível, como hoje) é se o Peregrino, no leito, **se arrepende** daquela falha. O passado não muda; a contrição, sim.
  - As Virtudes passam a medir isso: **o quanto a intercessão ajudou o arrependimento dele**. Isso casa com o ato de contrição no final.
- **Impacto no jogador:** a Tentação deixa de ser um evento genérico de "risco e recompensa" e vira a alegoria em miniatura: os santos pedem, o homem responde.
- **O que continua igual:** sempre existe a opção segura; toda chance é visível e pode ser melhorada por santo, provisão ou relíquia; nenhum santo peca.
- **Sistemas:** `narrative-system.md` §4.1 (só o enquadramento; o formato dos dados já serve), roteiros das Tentações (seus).
- **Custo:** baixo no código; **alto na escrita**, que é sua.
- **Risco:** mexe em narrativa e em teologia (arrependimento, intercessão). **É decisão sua** e merece a revisão teológica prevista para o M4. Confira também com o roteiro do Prólogo e com o "flashback de antes", que eu não li.
- **Simulação:** não.
- **Regras do §2:** respeita. Os santos não são tentados; intercedem.

### F-03 · As nove correntes: o objeto visível do resgate

- **Problema:** um resgate precisa de algo que o jogador **veja avançar**. Sem o Peregrino na jornada, hoje o avanço é só "venci o chefe".
- **Ideia (criação do jogo, proposta):** a alma do Peregrino está presa por **nove correntes**, uma por círculo. Cada chefe guarda um elo. Vencer o chefe **quebra** a corrente daquele pecado.
  - O mesmo símbolo aparece em três lugares: o **medalhão** do Mapa do Inferno, o **vitral** da Capela e a **vinheta do leito** (uma corrente a menos a cada cena).
  - Isso aproveita o que já foi decidido ("uma ideia, três lugares") e dá a ela um sentido: não é troféu, é libertação.
- **Impacto no jogador:** ele vê o resgate avançar sem precisar ver o Peregrino andando pelo Inferno.
- **Cuidado de reverência (princípio 4 do GDD):** os santos quebram a corrente **pela intercessão**; quem salva é Cristo. O desenho e o texto não podem sugerir que os santos "libertam por força própria". Texto e imagem são seus.
- **Sistemas:** só apresentação (mapa, Capela, vinheta).
- **Custo:** baixo no código; um conjunto de arte (uma corrente com 9 estados).
- **Risco:** baixo. É símbolo novo: precisa do rótulo "criação do jogo".
- **Simulação:** não.

---

## Pilar B · Provação

### F-04 · O teste de Fé com preparo: "a companhia reza"

- **Problema:** aos 100 de desolação, a chance é 26% a 38% no começo, e o jogador só assiste.
- **Ideia:** manter o sorteio (a regra permite), mas dar ao jogador **modos visíveis de preparar** a chance antes de o santo chegar aos 100:
  1. **Aviso na intenção inimiga:** quando um ataque previsto vai levar um santo aos 100, a intenção mostra "→ teste de Fé (26%)". Hoje a prévia é exata, mas esse aviso é o mais importante do jogo e merece destaque.
  2. **Oração da companhia:** cada aliado que **intercedeu** por aquele santo neste combate (F-01) ou o aliviou com uma habilidade dá um bônus pequeno e visível na chance (proposta: +5% cada, no máximo +10%).
  3. **Vigília feita neste trecho:** bônus pequeno até o fim do trecho (proposta: +5%).
- **Sobre o teto de 60%:** hoje, um santo de Fé alta com João da Cruz na equipe já bate no teto, e o traço de João se perde em parte. Vale o simulador testar um teto de 70% **só** quando há preparo.
- **Impacto no jogador:** o teste deixa de ser "moeda" e vira "o que eu fiz por ele antes?". Quando falha, o jogador sente que tentou.
- **Sistemas:** `desolation.md` §3 (bônus na fórmula, que já prevê "bônus de relíquias, traços e Moradas"), tela das intenções.
- **Custo:** baixo a médio.
- **Risco:** mais Consolações do que a meta. A Consolação é forte (dano e cura ×1,15).
- **Simulação:** sim.
- **Regras do §2:** respeita. O acaso fica onde a regra deixa; a figura de Deus não entra como bônus (quem reza é a companhia, e o bônus é dela).

### F-05 · A Noite Escura se atravessa jogando

- **Problema:** hoje a Noite Escura só acaba com a desolação abaixo de 50. O caminho mais fácil é deixar o santo no banco por semanas. Antes do Jardim (Círculo 5), a Capela tira só 15 por semana. E cada combate vencido soma mais 20, empurrando o santo para a Prostração. Isso se parece demais com a espiral de Darkest Dungeon.
- **Ideia:** a Noite tem **duas saídas**, e a segunda é a mais bonita:
  1. a de hoje (desolação abaixo de 50);
  2. **Fidelidade:** o santo em Noite Escura que termina combates **de pé** ganha uma marca de Fidelidade por combate. Com um número fixo de marcas (proposta para o simulador: 3), acontece a **Purificação**, mesmo com a desolação alta. Ao purificar, a desolação volta a 50.
- **Complemento:** enquanto está em Noite Escura, o santo **não** recebe a desolação de fim de combate (proposta). Ele já está na noite; a noite não fica "mais noite" por ele continuar fiel.
- **Impacto no jogador:** levar um santo em Noite Escura para a expedição vira uma **escolha corajosa com prêmio**, e não um erro. A história que o jogador conta depois é "Jorge atravessou o Círculo 3 só com a Estocada e saiu purificado".
- **Sistemas:** `desolation.md` §4.2 e §4.3, tela (marcas ao lado da auréola), simulador.
- **Custo:** médio.
- **Risco:** a Noite ficar branda demais. O santo continua só com as habilidades de custo 0, o que já pesa muito. O número de marcas ajusta isso.
- **Simulação:** sim. Meta nova a medir: quantas Noites terminam por descanso e quantas por Fidelidade.
- **Regras do §2:** respeita e reforça. O santo não perde o controle; ele persevera.

### F-06 · A Purificação deixa marca

- **Problema:** a Purificação hoje dá +25% de experiência por um tempo. É pouco para o ponto mais alto da vida espiritual do santo no jogo.
- **Ideia:** cada Purificação dá ao santo uma **marca permanente**, escolhida pelo jogador entre duas opções pequenas e próprias daquele santo (proposta: no máximo 3 marcas por santo na campanha).
  - Exemplos de **forma** (não de conteúdo): uma habilidade passa à versão "+"; o traço ganha um detalhe; o santo começa os combates com 1 Amparo.
- **Trava contra abuso:** só uma marca por santo por **tempo litúrgico**. Isso amarra a provação ao calendário, sem prazo novo.
- **Ligação com F-17:** as marcas podem **substituir os Carismas** como forma de personalizar o santo. Em vez de 24 Carismas com cerca de 72 variantes, 12 santos com 3 escolhas de 2 opções. Menos conteúdo, mais sentido: o santo cresce **porque foi provado**.
- **Impacto no jogador:** ele passa a **querer** que o santo atravesse a Noite, com medo e com esperança ao mesmo tempo. É o contrário exato de Darkest Dungeon.
- **Sistemas:** `desolation.md` §4.3, `village-economy.md` §9, dados novos (marcas por santo), save.
- **Custo:** médio (alto se mantiver também os Carismas).
- **Risco:** o jogador provocar a Noite de propósito. A trava por tempo litúrgico e o custo real da Noite seguram isso. O conteúdo das marcas toca a vida de cada santo: **você aprova cada uma**.
- **Simulação:** sim (poder acumulado no fim da campanha).

---

## Pilar C · Clareza com profundidade

### F-07 · O relógio do combate

- **Problema:** 20 de desolação fixos por combate vencido. Lutar bem ou mal dá no mesmo. E pode existir um abuso: segurar um inimigo fraco vivo para curar e aliviar de graça com habilidades de custo 0 (confira se já há trava).
- **Ideia:** trocar o valor fixo por **base menor + um tanto por rodada** depois das primeiras. Proposta para o simulador: 8 de base, mais 3 por rodada a partir da 3ª, calibrado para que a luta **mediana** continue dando perto de 20.
  - A tela mostra o relógio: "Rodada 4 · desolação ao vencer: 14".
- **Impacto no jogador:**
  - Rapidez vira virtude: arriscar para terminar logo passa a valer.
  - Enrolar passa a custar. O abuso some sem regra especial.
  - O jogador sente que **a desolação é consequência do que ele fez**.
- **Sistemas:** `desolation.md` §2.1, `constants.csv`, tela do combate, simulador.
- **Custo:** baixo.
- **Risco:** favorecer demais equipes de dano e punir equipes de proteção (Bento, Sebastião). O simulador precisa comparar os dois estilos.
- **Simulação:** sim, obrigatória. É a mudança de maior efeito com o menor custo.

### F-08 · Intenções "se… então…"

- **Problema:** a IA é uma lista de prioridades. Depois de aprendida, cada inimigo tem uma resposta certa.
- **Ideia:** alguns inimigos (não todos) ganham **uma reação visível** na ficha, além da intenção da rodada. Formas possíveis:
  - "Se for atingido por Golpe nesta rodada: revida em quem bateu."
  - "Se ninguém o atingir nesta rodada: ganha 1 Força."
  - "Se um aliado dele cair: avança uma posição."
- **Por que funciona sem sorte:** tudo está escrito antes. O jogador não adivinha; ele **escolhe qual condição aceitar**. A ordem dos três santos passa a importar muito mais.
- **Já existe um parente:** o Duelo de Jorge tem contra-ataque. A ideia estende o mesmo princípio aos inimigos.
- **Impacto no jogador:** cada combinação de inimigos vira um problema diferente, mesmo com os mesmos sete tipos.
- **Sistemas:** `enemy-ai.md` (campo novo de reação), `enemy_actions.csv`, ficha do inimigo, prévia.
- **Custo:** médio.
- **Risco:** poluir a tela. Limite sugerido: **uma** reação por inimigo, e no máximo dois inimigos com reação por encontro comum.
- **Simulação:** sim (a IA do simulador precisa entender as reações).
- **Quando:** nas famílias B e C (M3), não no Círculo 2.

### F-09 · A Provação do Círculo (resposta à pergunta aberta da Tentação)

- **A pergunta:** os pecados agem como **assédio dos inimigos**, ou ficam só como eventos?
- **Minha resposta:** assédio, **sim**. Mas **sem criar um sistema novo de "pecados"**. O jogo já tem a peça certa: a mecânica de ambiente de cada círculo.
- **Ideia:** juntar "ambiente" e "assédio" num conceito só, a **Provação do Círculo**, com três regras fixas:
  1. **É visível antes** (já é assim).
  2. **Tem uma resposta ativa do santo, com custo.** Quase todas já têm: usar o Pão na Fome, trocar de lugar nos Túmulos, usar Exorcismo no Contrapasso, usar o milagre no Torpor.
  3. **Resistir dá prêmio.** Isto é o que falta. O guia de roteiro diz que resistir à tentação é sempre vitória. Então, quando a companhia responde à provação, ganha uma ficha de **Firmeza** (proposta: +1 de Fervor na rodada seguinte, dentro do limite de ganho extra que já existe).
- **O papel de cada inimigo especial:**
  - o **Pecado Encarnado** (elite) é quem **ensina** a provação, com uma ação própria que a aplica com força (a Vertigem com um "Encanto" que puxa as intenções para um santo, por exemplo: ele sofre o assédio, não peca);
  - o **chefe** é a **prova final** da mesma lição.
- **Onde a provação ainda não tem resposta ativa (a revisar):**
  - **Ouro Maldito (Círculo 4):** hoje dá desolação ao receber Esmolas, sem escolha. Sugestão de forma: a companhia pode **recusar** as Esmolas daquele nó. É a única provação em que resistir custa dinheiro, o que é exatamente o tema.
  - **Vendaval (Círculo 2):** a resposta hoje é quase só a Clausura de Bento. Vale dar uma resposta comum (por exemplo, um santo que não agiu ainda pode "firmar o pé" gastando a ação).
- **Impacto no jogador:** cada círculo ensina uma virtude pela prática. Ele aprende a lição com o Pecado Encarnado e é cobrado pelo chefe.
- **Sistemas:** `expedition.md` §10, `combat.md` §14, `conditions.csv` (Firmeza), especificação dos chefes.
- **Custo:** baixo a médio. Aproveita o que existe.
- **Risco:** a Firmeza encher demais o Fervor. O limite de +2 por rodada já protege.
- **Simulação:** sim (Fervor médio por rodada).
- **Regras do §2:** respeita. O pecado age **de fora**; o santo resiste e é premiado. Nenhuma perda de controle.

### F-10 · Variantes de círculo para a família A

- **Problema:** os mesmos 7 inimigos comuns aparecem em quatro círculos seguidos (2 a 5).
- **Ideia:** cada círculo dá aos inimigos da família uma **marca do círculo**, só nos dados: **uma ação trocada** e um detalhe visual feito pelo motor (cor da névoa, um brilho). Exemplo de forma: no Círculo 3, o Diabo de Lodo troca o esmagamento por uma ação ligada à Fome.
- **Impacto no jogador:** o inimigo conhecido volta "diferente", e o jogador precisa reaprender um pedaço. Sem arte nova.
- **Sistemas:** `enemies.csv`, `enemy_actions.csv`, encontros.
- **Custo:** baixo por variante. São 7 inimigos × 3 círculos = até 21 ações novas; dá para começar com 3 por círculo.
- **Risco:** o detalhe visual é decisão de arte: sua.
- **Simulação:** sim, junto com os encontros de cada círculo.

### F-11 · A regra da assinatura nos kits

- **Problema:** os traços são ótimos, mas as habilidades se repetem entre santos. O que achei em `saint-kits.md`:
  - "custo 0, tira desolação de um aliado": Bento, Teresinha, João da Cruz, Sebastião, Gertrudes e Antônio;
  - "custo 0, cura um aliado": Teresinha, Nicolau, Pio, Rita e Antônio;
  - "exorcismo pequeno a qualquer distância": Teresinha, João da Cruz, Gertrudes, Antônio;
  - "retira as fichas positivas do inimigo": Bento, Antão, Pio, Antônio.
- **Ideia:** uma regra simples para revisar os kits (e para desenhar os de Nicolau e Gertrudes, que estão pendentes):
  - de cada 6 habilidades, **pelo menos 2 fazem algo que nenhum outro santo faz**;
  - cada santo tem **um verbo** que o resume numa palavra (Jorge desafia, Bento firma, Teresinha oferece, Pio está em dois lugares, Antão aguenta…).
- **Com F-01**, parte do alívio de desolação de custo 0 pode sair dos kits, porque Interceder já cobre o básico. Isso abre espaço para habilidades com cara própria.
- **Impacto no jogador:** escolher a equipe vira escolher **jeitos de jogar**, não números.
- **Sistemas:** `abilities.csv`, `saint-kits.md` (gerado).
- **Custo:** médio (desenho e novo balanceamento). **O conteúdo é seu**: eu não invento fato de santo.
- **Risco:** mexer em kits já testados (os três iniciais). Sugestão: não tocar em Jorge, Bento e Teresinha no M2; aplicar a regra dos próximos em diante.
- **Simulação:** sim, por santo.

---

## Pilar D · Luz

### F-12 · Luz é ver

- **Problema:** o Lume passa sozinho, a faixa do meio não faz nada, e o efeito mal aparece.
- **Ideia:** num jogo sem sorte, o que mais vale é **saber antes**. Então cada faixa de Lume muda **quanto a companhia vê**:

  | Faixa | O que o jogador vê (proposta) |
  | --- | --- |
  | Alta (75–100) | As intenções desta rodada **e** um aviso da próxima (só o ícone, sem número) |
  | Média (25–74) | As intenções desta rodada, como hoje |
  | Baixa (0–24) | O ícone da intenção, mas **sem o alvo** de um dos inimigos |

- **Por que é melhor que só aumentar a desolação no escuro:** mexe no coração do jogo (planejar com informação) e dá sentido às três faixas. A Vela vira uma compra de **visão**, que o jogador sente na hora.
- **Relação com as 4 variantes já decididas (D-262):** esta é uma **quinta variante** para simular junto. Ela combina com a variante "mostrar o efeito da faixa na tela" e pode substituir a "faixa de Escuridão".
- **Conflito a resolver:** o Círculo 8 (Fraude) já usa intenções veladas e as desfaz com Lume alto. Se F-12 for aprovada, o Círculo 8 passa a **baixar uma faixa** de visão, em vez de ter regra própria. Fica até mais simples.
- **Sobre "mais Esmolas no escuro":** eu tiraria. É cobiça, não combina com santos, e empurra o jogador a andar no escuro por dinheiro. Se quiser manter um prêmio para o risco, que seja de outro tipo (experiência, por exemplo). **Decisão sua.**
- **Impacto no jogador:** ele olha para a lamparina antes de cada bifurcação, porque ela decide o quanto ele vai enxergar na próxima luta.
- **Sistemas:** `expedition.md` §4, `enemy-ai.md` §5 (exibição), tela do combate, simulador.
- **Custo:** médio (calcular a intenção da rodada seguinte exige cuidado, porque ela depende do estado).
- **Risco:** o "aviso da próxima rodada" pode mudar depois das ações do jogador. Solução: mostrar como "provável", só o ícone. Com Lume baixo, o jogo fica mais difícil **sem** virar sorteio: a ação inimiga continua determinística, só o alvo fica oculto.
- **Simulação:** sim. A IA do simulador precisa jogar "sem ver o alvo".
- **Regras do §2:** respeita. Nenhum acerto vira sorte; muda só o que é mostrado.

### F-13 · Erguer a lamparina

- **Problema:** o Lume só se perde. Falta o jogador **gastar** luz por vontade própria.
- **Ideia:** uma ação da companhia, uma vez por combate, sem gastar a vez de ninguém: **Erguer a lamparina**. Custa Lume (proposta: 10) e dá, só naquela rodada, a visão da faixa acima (F-12).
  - Na caminhada, o mesmo gesto pode revelar o conteúdo do próximo nó.
- **Impacto no jogador:** a luz vira um recurso com dilema: gastar agora para ver melhor, ou guardar para chegar ao chefe com a lamparina cheia.
- **Sistemas:** `expedition.md` §4, comando novo, tela.
- **Custo:** baixo, **se** F-12 existir. Sozinha, não faz sentido.
- **Risco:** sobrepor o Incenso (que revela camadas). Sugestão: o Incenso revela **longe** (uma camada inteira), a lamparina revela **perto** (o próximo nó).
- **Simulação:** sim, junto com F-12.

---

## Fora do combate

### F-14 · As Obras de Misericórdia: conquistas e chegada de novos santos numa ideia só

- **Duas perguntas abertas de uma vez:** "conquistas opcionais: em qual edifício e com que lista?" e "santos de expansões: qual mecânica de desbloqueio?".
- **Ideia:** a lista das conquistas são as **catorze Obras de Misericórdia** da tradição (sete corporais e sete espirituais). Cada obra tem um feito de jogo que a espelha. **Você confere a formulação e a fonte** (Catecismo) antes de qualquer texto.
- **Exemplos de forma (proposta, você decide os pares):**

  | Obra (tradição) | Feito de jogo (criação do jogo) |
  | --- | --- |
  | Dar de comer a quem tem fome | Partilhar Pão em certo número de Pousos |
  | Visitar os enfermos | Curar ferimentos graves na Enfermaria |
  | Dar pousada aos peregrinos | Consagrar Pousos |
  | Consolar os aflitos | Tirar desolação de companheiros |
  | Sofrer com paciência | Atravessar uma Noite Escura pela Fidelidade (F-05) |
  | Rogar pelos vivos e pelos mortos | Avançar a Trilha do Purgatório |

- **Onde fica:** nos **vitrais da Capela** (já previstos no GDD como tela de conquistas). Catorze vitrais pequenos, que acendem.
- **Prêmio:** **nenhum poder**. Só o vitral aceso e uma página no Martirológio. Obra de misericórdia não pode virar moeda.
- **Santos de expansão:** cada santo novo **chega quando a companhia pratica a obra ligada à vida dele**. Não é compra, não é sorte, não é só "terminar um círculo": é o jogador fazendo o que o santo fez. Qual obra liga a qual santo é **fato de santo**: você escolhe.
- **Impacto no jogador:** motivo para jogar de novo e de outro jeito; e cada santo novo chega com uma história que o jogador viveu.
- **Sistemas:** contadores no save, tela da Capela, `village-economy.md` §10.
- **Custo:** baixo a médio.
- **Risco:** contadores que pedem repetição chata ("faça 50 vezes"). Preferir feitos de **qualidade** a feitos de quantidade.
- **Simulação:** não.
- **Regras do §2:** respeita a regra 5 (santos nunca comprados) e a 4 (Sufrágios não são gastos; aqui só se conta o marco).

### F-15 · A voz do jogo

- **Problema:** metade da alma de Darkest Dungeon é o narrador. Ad Inferos, sem uma voz, fica com a aparência do gênero e sem a presença.
- **Ideia (estrutura):** uma voz única, com frases curtas disparadas por momentos do jogo: início de combate, santo caído, teste de Fé, Consolação, Noite Escura, Purificação, chefe vencido, Lume baixo.
  - Começar pequeno: 3 frases por momento, só em texto. Voz gravada só depois, se o texto funcionar.
- **Quem fala? É decisão sua. Três caminhos:**
  1. **Os próprios santos**, com as falas curtas que você já decidiu aprovar (D-262). É o mais seguro.
  2. **Um cronista** da vila (São Tomás na Biblioteca já é o escriba). Voz sóbria, de quem registra.
  3. **O Anjo da Guarda** do Peregrino, que o GDD põe no papel de guia. Atenção: se o Peregrino não está na jornada, vale definir **onde o Anjo está** e a quem ele guia.
- **O que eu não proponho:** a voz do Peregrino na jornada. Você foi claro.
- **Sistemas:** `ui_text.csv` ou arquivo de falas, gatilhos por evento (os eventos já existem em `desolation.md` §6).
- **Custo:** baixo no código; **a escrita é toda sua**, com origem marcada.
- **Risco:** texto de santo exige fonte. Frase ruim pesa mais do que frase nenhuma.
- **Simulação:** não.

### F-16 · Leitura no celular

- **Problema e ideia, item a item (tudo de custo baixo):**
  1. **Fonte:** manter a Pirata One só em títulos e nomes. Texto corrido, números e descrições numa fonte com serifa simples e legível. Definir um tamanho mínimo e testar no Redmi 12.
  2. **A auréola como medidor:** a desolação de cada santo deve ser lida **na auréola**, sem abrir ficha (a especificação já prevê isso). Proposta: o anel se apaga em quatro passos (0, 50, 75, 100) e some na Noite Escura.
  3. **O Lume:** a lamparina já existe; o número "Lume 64" pode sumir se a chama tiver três tamanhos claros (as três faixas).
  4. **Intenções:** prender cada ícone de intenção **acima da cabeça** do inimigo dono dela. Na captura, o quarto ícone aparece cortado pelo canto.
  5. **Botões de teste** (+25, −25, Consolação): esconder atrás de uma opção de desenvolvedor antes de qualquer teste com jogador.
  6. **Relógio do combate** (F-07) junto do "Rodada 1".
- **Sistemas:** só telas.
- **Custo:** baixo.
- **Risco:** trocar a fonte muda o clima. Faça a comparação lado a lado antes de decidir.
- **Simulação:** não. Precisa de **teste no aparelho**.

---

## Tamanho

### F-17 · Cortes e fusões

Princípio 3 do GDD: uma ideia só vira mecânica se melhorar uma decisão do jogador. Passei cada sistema por essa régua.

| Sistema | O jogador decide algo? | Sugestão |
| --- | --- | --- |
| Desolação, Fervor, posições, intenções | Sim, o tempo todo | **Manter.** É o jogo. |
| Provisões | Sim | **Manter.** |
| Lume | Hoje, pouco | **Refazer** (F-12, F-13). |
| Afinidades | Um pouco (quem levar) | **Manter.** Já está pronto e é barato. |
| **Carismas** (24, cerca de 72 variantes) | Sim, mas custa muito conteúdo | **Trocar pelas marcas de Purificação** (F-06), ou reduzir para 1 Carisma por santo. É o maior corte possível. |
| **Equipamento** (Instrumento e Hábito, 3 níveis) | Quase nada: é só "+10% de dano" e "+8% de vida" | **Fundir em um só espaço**, ou manter como simples destino das Esmolas, sem tela própria elaborada. |
| **Ferimento leve** (−10% num atributo sorteado, 1 semana) | Não | **Cortar.** Fica só o ferimento grave, que já pesa e gera decisão (leito, banco). |
| Capela × Jardim | Parecidos | **Manter**, como a análise anterior concluiu. O Jardim perde importância se F-05 entrar; nesse caso pode virar um nível 3 da Capela. |
| Moradas (7 bônus pequenos) | Não (são automáticas) | **Manter como cena**: cada Morada acende uma janela e muda algo visível. Os bônus pequenos podem ficar. |
| Escalada (5 níveis) | Sim, para quem repete | **Adiar** o desenho dos níveis 3 a 5 para depois da campanha completa. |
| Relíquias (25) | Sim | **Manter**, mas lançar por família de círculos, não todas de uma vez. |
| Retorno decrescente das Esmolas por tempo litúrgico | Regra difícil de explicar | **Simplificar** a mensagem na tela; a regra pode ficar. |

- **Impacto no jogador:** menos telas para aprender; cada sistema que sobra tem uma decisão clara.
- **Custo:** negativo. É trabalho que **deixa de ser feito**.
- **Risco:** a economia foi desenhada para pagar 70% a 80% do essencial. Tirar destinos das Esmolas (equipamento) pede recalibrar. Por isso o equipamento pode ficar, só simplificado.
- **Simulação:** sim, para a economia.

### F-18 · O que fazer primeiro no M3

- **Problema:** "produção por família" pode virar produzir conteúdo em cima de um laço que ainda não foi provado inteiro.
- **Ideia:** dividir o M3 em dois passos.
  1. **M3a · Ato I (Círculos 3 a 5).** Usa só a família A, que já tem arte e dados. Entrega: três círculos novos com as provações (F-09), as variantes (F-10), a vila completa em uso, três santos novos. É um jogo de 6 a 8 horas que já pode ser mostrado como portfólio.
  2. **M3b · famílias B e C (Círculos 6 a 9).** Só depois do Ato I jogado e medido. É aqui que entram as intenções "se… então…" (F-08).
- **Antes do M3a, uma semana só de regras:** F-01, F-05, F-07 e F-12 no simulador. Elas mudam o que é "equilíbrio"; calibrar o Círculo 2 antes delas é calibrar duas vezes.
- **Impacto no jogador:** nenhum direto; para o projeto, um ponto de parada apresentável no meio do caminho.
- **Custo:** nenhum. É ordem de trabalho.
- **Risco:** adiar a arte que falta (9 santos e Lúcifer) pode pesar no fim. Os três santos do Ato I (Joana, Pio, Rita) entram na frente da fila.
