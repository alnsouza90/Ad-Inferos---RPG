# 2 · Propostas (F-01 a F-18)

Versão 1.1 · 11/11/2026 · revista depois de ler `decisions.md` inteiro, o Prólogo e as pendências · **tudo aqui é proposta**. Números são sugestões para o simulador, nunca valores finais. Nomes de mecânicas são provisórios.

**Como ler cada ficha:** problema → ideia → impacto no jogador → sistemas → custo (baixo, médio, alto) → risco → simulação.

**Minhas cinco apostas, se você só puder ler cinco:** F-01, F-05, F-07, F-12 e F-17.

**Mudou na versão 1.1:** F-02 foi **retirada** (já decidido em D-141). F-03, F-14, F-15, F-16 e F-18 foram **refeitas** para respeitar decisões que eu não tinha lido. As outras ganharam a linha "Decisões ligadas".

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

### F-02 · (retirada) A Tentação relida como intercessão

- **Por que saiu:** eu escrevi que havia um buraco ("quem é tentado na tenda?"). **Não há.** Você já decidiu em **D-141**: a Tentação é o **eco da tentação do Peregrino**, que vai sempre à frente; os rastros parecem levar à tenda, mas ele nunca está lá; é a voz mentindo. Os santos nunca cedem. O que está em jogo é **alcançar o Peregrino**, e por isso as Virtudes mudam.
- Essa solução é melhor que a minha. Ela já é resgate, e não escolta.
- **O que sobra, bem pequeno (opcional):** o formato das opções já aceita "rezar" com requisito (D-140). Se F-01 for aprovada, uma Tentação pode ter uma opção em que um santo **toma desolação sobre si** para melhorar a chance visível. É só um tipo novo de modificador; o texto continua seu.

### F-03 · As três luzes: usar os símbolos que o Prólogo já criou

- **O que eu tinha proposto e retiro:** "nove correntes" como símbolo novo do resgate. **Não precisa.** O seu Prólogo já tem os símbolos, e eles são melhores:
  1. **a luz pálida que desce** (a alma do Peregrino caindo pelos círculos, Cena 11);
  2. **a lanterna da companhia**, acesa na lâmpada de Santa Luzia (Cena 10), que é o Lume e o marcador da companhia no mapa;
  3. **a vela do leito**, que baixa a cada vinheta (D-198).
- **Ideia:** tratar essas três luzes como **o sistema de símbolos do jogo** e usá-las sempre do mesmo jeito, sem criar um quarto símbolo.
  - No **Mapa do Inferno** (D-208): a lanterna marca onde a companhia está; a luz pálida aparece **um círculo abaixo**, sempre à frente (como em D-141 e D-199). Vencido o chefe, a luz pálida desce mais um círculo.
  - Na **vila**: a vela do leito pode ser o desenho que acompanha o relatório da semana de São Cristóvão (D-262), sem número e sem regra.
  - Os **vitrais da Capela** continuam sendo os capítulos da história, como você decidiu (D-262).
- **Impacto no jogador:** ele vê o resgate avançar (a luz pálida sempre um passo à frente) sem o Peregrino entrar na luta nem na jornada.
- **Sistemas:** só apresentação (Mapa do Inferno, relatório da semana).
- **Custo:** baixo.
- **Risco:** baixo. Confira se a luz pálida no mapa combina com o que você imagina para a tela do Mapa do Inferno.
- **Simulação:** não.
- **Decisões ligadas:** D-141, D-198, D-199, D-208, D-262; Prólogo, Cenas 10 e 11.

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
- **Decisões ligadas:** D-307 (a prévia não mostra o **resultado** do teste; continua assim, o aviso mostra só a chance) e D-310 (a prévia já informa a desolação).
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
- **Decisões ligadas:** D-210 e D-213 (a tela especial de Noite Escura e de Consolação de cada santo já está prevista). A Purificação pela Fidelidade merece a mesma tela.

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
- **Decisões ligadas:** **D-164 e D-165**. Você já calibrou esse número (12 → 25 → 20) com a meta de 0,02 a 0,10 Noite Escura por trecho. F-07 **mexe num valor que você escolheu**: a meta fica a mesma, muda só a forma de chegar nela. Se preferir não reabrir, a alternativa mínima é só a trava contra enrolar.

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
- **Decisões ligadas:** a tenda da Tentação **não muda** (D-141, D-184). D-163 (os Pecados Encarnados representam o pecado de forma fiel e pesada: esta proposta dá a eles a mecânica para isso). D-175 e D-219 (Minos e Vertigem são as elites do Círculo 2, com números a aprovar em `bosses.md`: é ali que o "Encanto" entraria, se você quiser).

### F-10 · Variantes de círculo para a família A

- **Problema:** os mesmos 7 inimigos comuns aparecem em quatro círculos seguidos (2 a 5).
- **Ideia:** cada círculo dá aos inimigos da família uma **marca do círculo**, só nos dados: **uma ação trocada** e um detalhe visual feito pelo motor (cor da névoa, um brilho). Exemplo de forma: no Círculo 3, o Diabo de Lodo troca o esmagamento por uma ação ligada à Fome.
- **Impacto no jogador:** o inimigo conhecido volta "diferente", e o jogador precisa reaprender um pedaço. Sem arte nova.
- **Sistemas:** `enemies.csv`, `enemy_actions.csv`, encontros.
- **Custo:** baixo por variante. São 7 inimigos × 3 círculos = até 21 ações novas; dá para começar com 3 por círculo.
- **Risco:** o detalhe visual é decisão de arte: sua.
- **Simulação:** sim, junto com os encontros de cada círculo.
- **Decisões ligadas:** D-175 (no Círculo 2, nenhum inimigo comum novo: continua valendo, isto é só do Círculo 3 em diante). E eu sei que a família A cobrir os Círculos 2 a 5 **é de propósito**: é a incontinência de Dante, a Faminta do Prólogo. A variante não quebra a família; só dá o sotaque de cada círculo.

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

- **O Prólogo já pede isto:** a lanterna da companhia é acesa na lâmpada de **Santa Luzia**, que o seu roteiro apresenta como padroeira da visão (tradição). Se a luz vem de Luzia, o natural é que **luz seja ver**.
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
- **Decisões ligadas:** D-262 (as 4 variantes a simular), D-257 (a lamparina na escala vertical), D-164 (Lume alto já não reduz desolação).

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

### F-14 · As Obras de Misericórdia: conquistas opcionais e chegada de novos santos numa ideia só

- **Duas pendências suas de uma vez** (D-262): "qual edifício guarda as conquistas opcionais e com que lista?" e "qual mecânica de desbloqueio para cada santo de expansão?".
- **Ideia:** a lista das conquistas são as **catorze Obras de Misericórdia** da tradição (sete corporais e sete espirituais). Cada obra tem um feito de jogo que a espelha. **Você confere a formulação e a fonte** (Catecismo) antes de qualquer texto.
- **Exemplos de forma (proposta, você decide os pares):**

  | Obra (tradição) | Feito de jogo (criação do jogo) |
  | --- | --- |
  | Dar de comer a quem tem fome | Partilhar Pão em Pousos |
  | Visitar os enfermos | Curar ferimentos graves na Enfermaria |
  | Dar pousada aos peregrinos | Consagrar Pousos |
  | Consolar os aflitos | Tirar desolação de companheiros |
  | Sofrer com paciência | Atravessar uma Noite Escura pela Fidelidade (F-05) |
  | Rogar pelos vivos e pelos mortos | Avançar a Trilha do Purgatório |

- **Onde fica:** **não** nos vitrais da Capela. Você decidiu que os vitrais são os capítulos da história (D-262) e que as conquistas ficam numa seção de **outro** edifício. Duas opções:
  1. **Um "Livro das Obras" na Biblioteca de Santo Tomás**, ao lado do Arquivo, do Martirológio e da Crônica. É o mais simples. Como a Biblioteca só abre no Círculo 3, os contadores são gravados desde o início e aparecem prontos quando ela abrir (o mesmo truque já sugerido para o registro de inimigos).
  2. **Cada obra no edifício que tem a ver com ela** (o Pão na Despensa, os enfermos na Enfermaria, a pousada no Portão). Mais bonito, mais espalhado.
  - **Recomendo a 1.**
- **Prêmio:** **nenhum poder**. Só a página preenchida e um registro no Martirológio. Obra de misericórdia não pode virar moeda.
- **Santos de expansão:** cada santo novo **chega quando a companhia pratica a obra ligada à vida dele**. Não é compra, não é sorte: é o jogador fazendo o que o santo fez. Isso cumpre a regra de D-262 (todo santo novo tem mecânica de desbloqueio). Qual obra liga a qual santo é **fato de santo**: você escolhe.
- **Impacto no jogador:** motivo para jogar de novo e de outro jeito; cada santo novo chega com uma história que o jogador viveu.
- **Sistemas:** contadores no save, tela da Biblioteca, `village-economy.md` §10.
- **Custo:** baixo a médio.
- **Risco:** contadores que pedem repetição chata ("faça 50 vezes"). Preferir feitos de **qualidade** a feitos de quantidade.
- **Simulação:** não.
- **Regras do §2:** respeita a regra 5 (santos nunca comprados) e a 4 (Sufrágios não são gastos; aqui só se conta o marco).

### F-15 · A voz do jogo: o Narrador que o Prólogo já tem

- **Problema:** metade da alma de Darkest Dungeon é o narrador. Sem uma voz, Ad Inferos fica com a aparência do gênero e sem a presença.
- **O que já existe:** o seu Prólogo tem um **Narrador** (os versos de Dante e passagens curtas, sem retrato, em itálico). E você já decidiu as **falas curtas dos santos na vila**, aprovadas por você com a fonte (D-262).
- **Ideia:** não criar voz nova. **Estender o Narrador do Prólogo** para dentro do jogo, com frases curtas em poucos momentos fortes:
  - teste de Fé, Consolação, Noite Escura e Purificação (nas telas especiais já previstas em D-210 e D-213);
  - santo caído; chefe vencido; Lume na faixa baixa.
  - Começar pequeno: 2 ou 3 frases por momento, só em texto.
- **Quem não fala:** o Peregrino (decisão sua). E o Anjo da Guarda tem o papel dele já definido (espera a companhia na Porta, no Círculo 1, D-190); eu não mexo.
- **Sistemas:** arquivo de falas, gatilhos por evento (os eventos já existem em `desolation.md` §6).
- **Custo:** baixo no código; **a escrita é toda sua**, com origem marcada (`[jogo]`, Dante, Escritura).
- **Risco:** frase ruim pesa mais do que frase nenhuma. Se o Narrador falar demais, perde a força que tem no Prólogo.
- **Simulação:** não.

### F-16 · Leitura no celular (quase tudo já está resolvido)

- **Correção:** na versão 1.0 eu listei seis problemas. **Cinco já estavam decididos ou resolvidos**, e eu não sabia:
  - os botões de teste só existem na versão de desenvolvimento (D-117, D-314);
  - a desolação já aparece nos pés (10 quadradinhos) e na moldura do retrato (D-258, D-347);
  - as intenções já ficam sobre os inimigos, maiores e com destaque (D-257, D-258);
  - o Lume já é a lamparina descendo na escala (D-257);
  - a fonte Pirata One foi **escolha sua**, depois de reprovar a anterior (D-258).
- **O que sobra, só como pedido de teste:**
  1. Num Redmi 12, ler as **descrições de habilidade** e os **números pequenos** em Pirata One, a um braço de distância. Se cansar, a saída que respeita D-258 é manter a Pirata One em tudo e só **aumentar o tamanho mínimo** dos textos longos. Não proponho trocar a fonte.
  2. Se F-07 entrar, o relógio do combate fica junto do "Rodada 1".
- **Custo:** baixo. **Simulação:** não; precisa de teste no aparelho.

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

- **Decisões ligadas:** D-173 (o M2 já entra com ferimentos e sem Carismas, Capela e Forja; ou seja, o corte dos Carismas e do equipamento **não desfaz trabalho feito**; o do ferimento leve mexe na vila mínima do M2, então vale decidir antes da T45). D-262 (Carmelo em ruínas e Vestígios continuam como você decidiu).
- **Impacto no jogador:** menos telas para aprender; cada sistema que sobra tem uma decisão clara.
- **Custo:** negativo. É trabalho que **deixa de ser feito**.
- **Risco:** a economia foi desenhada para pagar 70% a 80% do essencial. Tirar destinos das Esmolas (equipamento) pede recalibrar. Por isso o equipamento pode ficar, só simplificado.
- **Simulação:** sim, para a economia.

### F-18 · A ordem do M3

- **Correção:** o M3 já é "produção por família", com caça a exploits repetida a cada família (D-170). Então a divisão que eu propus **já é o plano**. Retiro a parte que só repetia isso.
- **O que eu acrescento, em três pontos:**
  1. **O primeiro passo do M3 é a família A inteira: Círculo 1 (Porta, Anjo da Guarda, Antinferno com Caronte e o combate de ensino, que ficaram para o M3 em D-190 e D-192) e Círculos 3 a 5.** Com o Prólogo e o Círculo 2 do M2, isso fecha a primeira parte do Inferno de Dante (a incontinência, a Faminta do Prólogo). É um ponto de parada **apresentável como portfólio**.
  2. **Antes de produzir os Círculos 3 a 5, uma rodada só de regras no simulador:** F-01, F-05, F-07 e F-12. Elas mudam o que é "equilíbrio". Calibrar três círculos antes delas é calibrar duas vezes.
  3. **As intenções "se… então…" (F-08) ficam para as famílias B e C**, quando o jogador já domina o básico.
- **Custo:** nenhum. É ordem de trabalho.
- **Risco:** a rodada de regras atrasa o começo da produção. Em troca, evita refazer números.
