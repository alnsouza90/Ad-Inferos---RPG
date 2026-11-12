# Etapa 2 · Game design: o que faz este jogo ser inesquecível

Versão 1.0 · 11/11/2026 · consultor convidado · **tudo aqui é proposta**; números são pontos de partida para o simulador; nomes são provisórios; nenhum texto final.

**Base:** tudo o que já foi lido (decisões até D-263, Prólogo, GDD, especificações, backlog do M2) e as suas respostas de hoje (`04-respostas-de-alan.md`). Este documento **não repete** o que você já aprovou (Interceder, desolação por rodadas, Fidelidade, preparo do teste de Fé, "luz é ver", Provação do Círculo, Obras de Misericórdia, luz pálida no mapa, Narrador, Esmolas como restituição). Ele parte disso e vai além.

---

## 1. A pergunta

> O que faz este jogo ser inesquecível e diferente de Darkest Dungeon?

**Darkest Dungeon** é um jogo de **desgaste**. Você gasta gente. Quem fica na vila não existe. O herói é um recurso, e a pergunta é "quanto ainda dá para tirar dele?".

**Ad Inferos** tem tudo para ser o contrário, um jogo de **comunhão**:

- ninguém é gasto, ninguém quebra;
- quem não desceu **continua na luta**, rezando;
- o que um recebe, pode dar ao outro;
- e, no fim do caminho, há um homem numa cama que **começa a responder**.

A minha resposta em uma frase:

> **Inesquecível é o jogador descobrir que a companhia inteira luta junta, mesmo separada, e que cada coisa feita no abismo estava acontecendo à beira de um leito.**

Hoje o jogo **conta** isso (Prólogo, leito, D-141). As ideias abaixo fazem o jogo **jogar** isso.

---

## 2. Análise: onde o jogo ainda é Darkest Dungeon e onde já é ele mesmo

| Parte | O que veio de Darkest Dungeon | O que já é próprio | O que falta |
| --- | --- | --- | --- |
| **Laço** vila → expedição → combate → volta | Vila com instalações, semana que passa, expedição em corredor, acampamento | Retirada planejada sem culpa; Pousos consagrados; "voltar e se preparar é a estratégia" (D-166) | **Quem fica na vila some do jogo.** Com 12 santos e 3 em campo, 9 ficam parados. A volta à vila é só conserto. |
| **Desolação** | A barra de estresse e o limiar de 100 | O santo nunca perde o controle; Consolação, Noite Escura, Purificação; agora também Interceder e Fidelidade | A **Consolação** ainda é só um prêmio de sorteio (+15%). Graça recebida e guardada para si. |
| **Lume** | A tocha | A lanterna acesa por Santa Luzia; agora "luz é ver" | A lanterna não está **nas mãos de ninguém**. É um número da equipe. |
| **Peregrino e Virtudes** | Nada | Tudo: sempre à frente e nunca lá (D-141), o leito, o final único | As Virtudes só mudam **o texto do final**. Durante 9 círculos, o jogador não sente o Peregrino reagir. É o maior tesouro do jogo, e o menos jogado. |
| **Santos** | Classes com 4 habilidades e posições | Traços que contam a vida de cada um; chegam por marcos; nunca se compram | A **relação entre eles** é uma tabela fixa de 4 Afinidades com +10%. Não há história entre dois santos que o jogador tenha construído. |
| **Calendário litúrgico** | Nada | A ideia inteira | Hoje é uma **tabela de porcentagens** (+25% disto, −20% daquilo). O jogador não *vive* a Quaresma; ele lê um modificador. |

**Conclusão:** o combate e a expedição já estão bem resolvidos. A identidade que falta está em **três lugares que Darkest Dungeon não tem como copiar**: os santos que ficam, o homem no leito e o ano litúrgico.

---

## 3. As ideias

Sete ideias. As três primeiras são as mais fortes.

| # | Ideia | Em uma linha | Testa no M2? |
| --- | --- | --- | --- |
| G-1 | Três descem, os outros rezam | Quem fica na Capela ajuda a expedição com uma Súplica | Só no simulador |
| G-2 | O domínio cede | O que a companhia faz pelo Peregrino no círculo enfraquece o chefe | **Sim** (Asmodeu) |
| G-3 | A consolação é dom | O santo consolado pode dar a sua Consolação a outro | **Sim** |
| G-4 | Laços | A amizade entre dois santos nasce de interceder, e substitui as Afinidades | **Sim** |
| G-5 | A vida dele pelo caminho | Os Vestígios são objetos da vida do Peregrino e compõem a contrição final | Em parte |
| G-6 | O ano que se vive | Cada tempo litúrgico muda uma regra; a Quaresma é escolhida | Não |
| G-7 | Quem leva a lanterna | A lanterna está com um santo, e a posição dele importa | **Sim** |

---

### G-1 · Três descem, os outros rezam

**A ideia.** Um santo designado para a Capela não só gera Sufrágios. Ele **acompanha a expedição em oração**. Cada santo na Capela dá à companhia **uma Súplica** por expedição: um pedido de socorro que o jogador aciona **quando quiser**, uma única vez, com um efeito fixo e conhecido daquele santo.

- O efeito não precisa de conteúdo novo: é a **atividade de Pouso** que o santo já tem (Bento: −15 de desolação em todos; Teresinha: cura 15% de todos; Jorge: anula uma emboscada…), usada à distância.
- A Súplica não gasta a vez de ninguém e não custa Fervor. Aparece na tela como um retrato pequeno com auréola, ao lado das provisões.
- As vagas da Capela (1 a 3) limitam quantas Súplicas a expedição leva.

**O que muda na experiência.**
- "Quem fica" vira uma escolha tão importante quanto "quem vai". Deixar Teresinha rezando não é mais deixá-la de fora.
- No pior momento de um chefe, o jogador toca no retrato de quem ficou, e o socorro chega. É o momento que o jogador vai contar para os outros.
- Os 12 santos passam a importar o tempo todo, não só os 3 da vez.

**Por que é melhor.** É a **comunhão dos santos como regra**, que o jogo já tem como fundamento (D-198). Darkest Dungeon não pode fazer isso: lá, quem está na vila está se tratando ou bebendo. Aqui, quem está na vila está **lutando de outro jeito**.

**Risco.**
- Poder demais: 3 Súplicas numa luta de chefe podem trivializar. Limite sugerido: **uma Súplica por combate**.
- A Capela vira "sempre cheia". Isso é bom (dá sentido ao elenco), desde que o jogador sinta o custo de não levar aquele santo.
- **Regras do dossiê:** respeita. Não é figura sagrada dando bônus; são os próprios santos da companhia. Os Sufrágios continuam sem ser gastos: a Súplica não os consome.

**Custo.** Médio. Um comando novo, a tela, e o simulador.

**No M2?** **Não dá para jogar** (a Capela é do M3 e só há três santos, D-173 e D-174). Dá para **simular** na T55 com um quarto santo fictício na Capela. Entra de verdade quando Santo Antão e Nicolau chegarem.

---

### G-2 · O domínio cede (a graça e o consentimento como regra)

**O problema.** As Virtudes do Peregrino mudam nas Tentações e nos Encontros, mas o jogador só vê o efeito 9 círculos depois, no texto da contrição. No meio do caminho, o homem por quem tudo é feito não reage.

**A ideia.** Cada chefe **segura** a alma do Peregrino naquele círculo. Esse aperto tem um nome e um número pequeno na tela: o **Domínio** (proposta: de 0 a 3).

- O Domínio começa cheio.
- Cada vez que a companhia **alcança** o Peregrino naquele círculo (uma Tentação bem resolvida, o Encontro com a alma: tudo o que hoje já sobe uma Virtude na primeira passagem), o Domínio daquele chefe **cede um ponto**.
- Cada ponto de Domínio é uma **vantagem concreta e visível do chefe**: uma ação a mais, uma escolta, uma fase extra. Com Domínio 0, o chefe luta sem nenhuma delas.
- A companhia **sempre pode vencer** com o Domínio cheio. Só é mais duro.

**Isto já existe no seu jogo, uma vez.** O GDD diz que, contra Asmodeu, o fígado do peixe permite a intervenção de São Rafael, e que **sem o item o chefe ganha uma fase extra** (P9). É exatamente esta ideia. Proponho que ela deixe de ser exceção e vire **a regra de todos os chefes**.

**O que muda na experiência.**
- A Tentação e o Encontro deixam de ser "pausas narrativas" e viram **parte da preparação para o chefe**.
- O jogador chega ao chefe e **vê** o quanto conseguiu alcançar o Peregrino. O Domínio é o termômetro do resgate.
- O Peregrino passa a estar presente **como aquilo que está em jogo**, sem entrar na luta nem na jornada. É o mesmo modelo do seu final (P10: a prisão de gelo do Peregrino na luta contra Lúcifer). Os 8 chefes anteriores passam a ensaiar esse final.

**Por que é melhor.** Põe em regra a frase que fundamenta o seu final: a graça pede o consentimento (D-198 cita o Catecismo 1993). Os santos intercedem; o homem responde; o demônio perde a força **na medida em que ele responde**. Nenhum outro jogo tem isso.

**Risco.**
- O jogador escolher nas Tentações "pelo bônus" e não pelo sentido. Aceitável: a opção segura já existe, e a opção melhor tem risco visível.
- **Teologia:** o texto não pode sugerir que o Peregrino *merece* a ajuda, nem que os santos vencem por força própria. Pede a revisão teológica.
- **Confira com a sua orientação** ("o Peregrino não entra na luta"): aqui ele não é unidade, não tem vida nem age. É o que o chefe segura. Se mesmo assim passar do limite, a alternativa é o Domínio aparecer **só na Vigília**, antes da luta, como aviso.

**Custo.** Baixo a médio. Os ganchos de chefe e as fases já estão previstos (`enemy-ai.md` §6).

**No M2?** **Sim, e no lugar certo.** A T38 vai escrever Asmodeu (`bosses.md`), a T43 traz 2 Tentações e 2 Encontros do Círculo 2. É só desenhar Asmodeu já com o Domínio: o fígado do peixe vira um dos pontos.

---

### G-3 · A consolação é dom

**A ideia.** Um santo em **Consolação** pode, gastando a ação, **dar a sua Consolação** a um companheiro:

- se o companheiro está em **Noite Escura**, ele sai dela na hora (com Purificação);
- se está **Caído** dentro da janela, levanta;
- em qualquer outro caso, o companheiro perde uma boa parte da desolação (proposta: 30).

Quem deu **perde** a Consolação e volta ao estado normal.

**O que muda na experiência.**
- A Consolação deixa de ser "tirei a sorte, ganhei +15%". Vira uma pergunta: **guardo, ou dou?**
- Cria a jogada mais bonita do jogo: Teresinha passa no teste de Fé, recebe a Consolação e a entrega a Jorge, que estava há três combates em Noite Escura.
- Dá ao único sorteio pesado do jogo (o teste de Fé) um desfecho que é sempre uma decisão.

**Por que é melhor.** É o tema da graça em uma regra: **o que se recebe de graça, dá-se de graça**. Em Darkest Dungeon, a virtude heroica é um bônus do herói. Aqui é algo que ele pode passar adiante.

**Aviso:** o GDD já previa algo parecido para São João da Cruz ("converte desolação de um aliado em consolação"). Com G-3, **todo** santo consolado pode dar; João da Cruz pode ser o único que dá **sem perder** a sua (proposta; o kit é seu).

**Risco.** Pode reduzir demais as Noites Escuras. Como depende de alguém ter passado no teste de Fé, é raro por natureza. O simulador mede.

**Custo.** Baixo. Um comando e a prévia.

**No M2?** **Sim.** As regras de desolação estão prontas e os botões de teste já põem um santo em Consolação (D-117). Pode entrar na rodada de simulação que você já aceitou.

---

### G-4 · Laços (no lugar das Afinidades)

**O problema.** A relação entre santos hoje é uma tabela: 4 Afinidades fixas, +10% ou parecido. O jogador não constrói nada. E 3 dos 12 santos (Nicolau, Rita e, na prática, quem não tem par na equipe) ficam de fora.

**A ideia.** Entre **quaisquer dois santos** pode nascer um **Laço**. Ele cresce com gestos concretos feitos um pelo outro:

- interceder pelo companheiro;
- levantá-lo quando caiu;
- trocar de lugar para receber o golpe que ia nele;
- dar-lhe a Consolação (G-3).

O Laço tem **3 graus**, e cada grau dá algo simples e igual para todos os pares (sem conteúdo por par):

| Grau | Efeito (proposta) |
| --- | --- |
| 1 | Interceder um pelo outro move mais desolação |
| 2 | Uma vez por combate, Interceder um pelo outro não gasta a ação |
| 3 | Quando um cai, o outro não recebe a desolação de aliado caído; recebe 1 Força |

As **Afinidades atuais deixam de ser bônus fixo** e viram **ponto de partida**: santos da mesma família (Carmelo, monges, soldados, franciscanos) já começam com Laço 1.

**O que muda na experiência.**
- Cada jogador tem a **sua** companhia. "Na minha campanha, Bento e Teresinha são inseparáveis."
- A escolha da equipe ganha memória: levar dois santos que já se ajudaram muito é diferente de levar dois que nunca desceram juntos.
- No flashback, o "testemunho dos santos" pode, um dia, ter uma fala a dois para pares de Laço 3 (texto seu, opcional).

**Por que é melhor.** Darkest Dungeon II tem relações que **azedam**. Aqui só há uma direção possível, porque santos não brigam: a amizade **cresce**. É o mesmo sistema de relações, virado do avesso pela regra de que santos nunca pecam.

**Risco.**
- Favorecer sempre o mesmo trio. Compensa: o retorno de cada grau é pequeno, e círculos diferentes pedem santos diferentes.
- Mais um número por par na tela. Mostrar só como um fio fino entre os retratos, sem menu.

**Custo.** Médio. Contadores no save, 3 efeitos, tela.

**No M2?** **Sim**, com os três santos (três pares possíveis), logo depois de Interceder. E já serve para a tela de "Planejar a semana".

---

### G-5 · A vida dele pelo caminho

**O que já existe.** Você aprovou os **Vestígios** (D-262): um só sistema de objetos, obstáculos e armadilhas no corredor, para o M3. E decidiu que o Peregrino vai sempre à frente e só deixa rastros (D-141).

**A ideia.** Juntar as duas coisas: **todo Vestígio é uma coisa da vida do Peregrino**, caída durante a queda. Um objeto, não uma cena. A companhia para diante dele e escolhe (como já previsto: passar, ou gastar uma provisão).

- Recolher um Vestígio guarda uma **lembrança** no Diário do Peregrino, na Biblioteca.
- No fim do jogo, o **ato de contrição é montado com as lembranças recolhidas**. A versão continua definida pela soma das Virtudes, como você decidiu (D-198). O que muda é que, dentro dela, aparecem **as coisas que a companhia encontrou**: o jogador reconhece, uma por uma, o que ele mesmo recolheu ao longo de 9 círculos.
- O final é sempre o mesmo e sempre bom. As lembranças não mudam o destino; mudam **o quanto o jogador reconhece daquela vida** na hora do arrependimento.

**O que muda na experiência.**
- Explorar o corredor deixa de ser só "achar bônus" e vira **conhecer o homem**.
- A cena final deixa de ser um texto que o jogador lê e passa a ser um espelho do que ele fez. É o tipo de final de que as pessoas se lembram.
- O Peregrino fica presente o jogo inteiro, **pela ausência**: só as coisas dele.

**Por que é melhor.** Faz do jogo inteiro um **exame de consciência**, que é o que acontece de verdade num leito de morte na tradição que o jogo retrata. E é presença sem escolta: ninguém protege o Peregrino, ninguém o vê.

**Risco.**
- **Escrita:** é muito texto seu (os objetos, as lembranças, as linhas da contrição). Proposta de tamanho: 3 Vestígios de lembrança por círculo, 27 no total; a contrição usa uma linha curta por lembrança.
- Coerência com os flashbacks e com as três pessoas da selva. Os Vestígios precisam ser pensados junto com o roteiro de cada círculo.
- Sem criança como vítima, sem nada que quebre as regras de conteúdo.

**Custo.** Baixo no código (o sistema de Vestígios já vai existir; falta a bandeira de lembrança e a montagem da contrição). **Alto na escrita.**

**No M2?** **Em parte.** A mecânica pode ser testada com 1 ou 2 Vestígios no corredor do Círculo 2 (a caminhada interativa é a T37). O efeito no final só aparece no M4.

---

### G-6 · O ano que se vive

**O problema.** O calendário litúrgico é a ideia mais original da vila, mas hoje é uma lista de porcentagens. O jogador não sente a Quaresma: ele lê "+25% de desolação".

**A ideia, em duas partes.**

**Parte 1 · Cada tempo tem um verbo e muda uma regra, não um número.** Exemplos de forma (o conteúdo é seu):

| Tempo | Verbo | Uma regra que muda (proposta) |
| --- | --- | --- |
| Advento | Vigiar | O mapa mostra uma camada a mais |
| Natal | Receber | Chega um santo; a vila dá, em vez de cobrar, uma coisa |
| Tempo Comum | Perseverar | Nada muda: é o jogo de base |
| Quaresma | Renunciar | O jogador **escolhe** uma penitência (parte 2) |
| Páscoa | Alegrar-se | Cada expedição começa com um santo em Consolação, escolhido pelo jogador |

**Parte 2 · A Quaresma é escolhida.** No começo da Quaresma, o jogador escolhe **uma de três práticas** para as quatro semanas. As três práticas são da tradição (oração, jejum e esmola: você confere a fonte):

- **Jejum:** a companhia leva menos provisões.
- **Esmola:** uma parte das Esmolas ganhas é dada, não guardada.
- **Oração:** um santo fica obrigatoriamente na Capela a cada semana.

O prêmio **não é poder**: são mais Sufrágios e uma Páscoa mais forte (a Páscoa responde à Quaresma que o jogador viveu).

**E as penitências substituem a Escalada.** Hoje as revisitas têm 5 níveis de dificuldade copiados da "Ascensão" de Slay the Spire (+15% de vida, elites em dobro…). Em vez disso: em **qualquer** revisita, o jogador pode assumir uma ou mais penitências por vontade própria. Mesma função (desafio para quem repete), com sentido.

**O que muda na experiência.**
- O ano vira **ritmo**: há semanas de aperto e semanas de alívio, e o jogador sabe quais vêm.
- Como o ano é cíclico e a campanha dura mais de um ano, a segunda Quaresma é vivida de outro jeito: com mais santos, outra escolha.
- A dificuldade opcional passa a ter cara do jogo, e não de outro jogo.

**Por que é melhor.** Nenhum jogo do gênero tem um calendário que o jogador **pratica**. E resolve de graça um sistema inteiro (a Escalada).

**Risco.**
- Santos "fazendo penitência" precisa de cuidado no texto: é a companhia que se une à penitência da Igreja pelo moribundo, não santos pagando culpa. Revisão teológica.
- O Advento e a Páscoa com regras boas demais podem fazer o jogador "esperar a estação". Como cada expedição avança uma semana, esperar custa.

**Custo.** Médio. A vila e o calendário ainda nem foram programados, então é desenhar certo **antes** de construir.

**No M2?** **Não.** O calendário ficou para o M3 (D-173). Mas vale decidir agora, porque muda a especificação da vila (T45).

---

### G-7 · Quem leva a lanterna

**A ideia.** A lanterna de Santa Luzia está **nas mãos de um santo**. O jogador escolhe o portador (no Pouso e na luta, como a ordem da equipe, D-262).

- O que a luz revela ("luz é ver", já na simulação) vale melhor **perto do portador**: o inimigo à frente dele é o que se vê com mais clareza.
- Se o portador **cai**, a lanterna vai ao chão: o Lume perde um tanto (proposta: 10) e outro santo precisa gastar a ação para erguê-la.
- O portador não perde nada do seu kit. Só passa a ser alguém que vale a pena proteger.

**O que muda na experiência.**
- A posição ganha mais uma camada: quem leva a luz, na frente ou atrás?
- O Lume deixa de ser um número no canto. É um objeto que um santo carrega, que o jogador vê na cena, e que pode cair.
- A fala de Luzia no seu Prólogo ("cuidem para que não se apague") vira uma coisa que o jogador **faz**.

**Por que é melhor.** A tocha de Darkest Dungeon é do grupo e ninguém a segura. Aqui há um portador, e proteger a luz é proteger uma pessoa.

**Risco.**
- Somar complicação ao Lume, que já está sendo simulado em cinco variantes. Por isso: **só depois** de você escolher a variante do Lume.
- Arte: a lanterna na mão do portador. O motor pode desenhá-la como um objeto à parte, sem refazer as poses.

**Custo.** Baixo a médio.

**No M2?** **Sim**, na regra (combate, Lume e posições existem). Sugiro testar no simulador junto com as variantes do Lume, e só pôr na tela se a variante "luz é ver" for a escolhida.

---

## 4. Três coisas que eu cortaria ou simplificaria

| # | O que | Por quê | O que fica no lugar |
| --- | --- | --- | --- |
| C-1 | **A Escalada** (5 níveis de dificuldade nas revisitas) e o **retorno decrescente das Esmolas** (100%, 75%, 50%, 25% por tempo litúrgico) | São dois sistemas copiados de outros jogos, difíceis de explicar e sem ligação com o tema | As **penitências** de G-6 para quem quer desafio. Para as Esmolas, uma regra só: revisita paga metade. |
| C-2 | **As Afinidades fixas** (4 pares com +10%) | Tabela que o jogador não constrói; deixa santos de fora | Os **Laços** de G-4, com a Afinidade como ponto de partida |
| C-3 | **O Jardim** como instalação separada | Faz o mesmo que a Capela (tirar desolação), só que mais. Com a saída da Noite Escura pela Fidelidade (aprovada para simular) e a Súplica (G-1), o banco deixa de ser castigo e o Jardim perde a razão | **Capela com 3 níveis**; o nível 3 dá o descanso forte que era do Jardim. São Francisco continua como guardião de alguma coisa (decisão sua). Uma instalação e um conjunto de arte a menos. |

**Um quarto, se quiser ir mais fundo:** os **7 bônus pequenos das Moradas** (+5% aqui, ×0,95 ali). As sete janelas acendendo são lindas e devem ficar; os sete numerozinhos ninguém vai notar. Poderiam ser **3 marcos visíveis** (Moradas 1, 4 e 7), cada um com uma mudança que o jogador sente.

---

## 5. Como as ideias se somam

Lidas juntas, elas contam uma coisa só:

1. **Três descem, os outros rezam** (G-1): a companhia inteira luta.
2. **Laços** (G-4) e **a consolação é dom** (G-3): o que um tem, é do outro.
3. **Quem leva a lanterna** (G-7): a luz recebida é uma responsabilidade.
4. **A vida dele pelo caminho** (G-5): a companhia vai conhecendo o homem.
5. **O domínio cede** (G-2): e o homem, aos poucos, responde.
6. **O ano que se vive** (G-6): tudo isso dentro do tempo da Igreja.

Em Darkest Dungeon, o jogo é sobre **o que a masmorra faz com as pessoas**. Aqui, seria sobre **o que as pessoas fazem umas pelas outras, e por um homem que não as vê**.

## 6. Se eu tivesse que escolher a ordem

| Ordem | Ideia | Por quê |
| --- | --- | --- |
| 1 | **G-2 · O domínio cede** | Cabe na T38, que é a próxima tarefa de design; custa pouco; dá sentido às Virtudes já no Círculo 2 |
| 2 | **G-3 · A consolação é dom** | Barata; entra na rodada de simulação já aceita |
| 3 | **G-4 · Laços** | Depende de Interceder; testável com os três santos |
| 4 | **G-7 · Quem leva a lanterna** | Só depois de escolher a variante do Lume |
| 5 | **G-6 · O ano que se vive** e os cortes C-1 e C-3 | Decidir **antes** da T45, que especifica a vila, mesmo que só se construa no M3 |
| 6 | **G-1 · Três descem, os outros rezam** | Simular já; jogar quando houver Capela e um quarto santo |
| 7 | **G-5 · A vida dele pelo caminho** | Anda com o roteiro dos círculos e com os Vestígios (M3); o efeito final é do M4 |

## 7. O que eu preciso que você confira

- **G-2:** se o Domínio respeita a sua orientação de que o Peregrino não entra na luta (ele é o que está em jogo, não uma unidade).
- **G-1, G-2 e G-6:** são as três que tocam teologia (intercessão, consentimento, penitência). Pedem a revisão que você já previu.
- **G-5:** se combina com o que você imagina para os flashbacks e para as três pessoas da selva.
