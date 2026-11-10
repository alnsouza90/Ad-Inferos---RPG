# Ad Inferos × Darkest Dungeon — análise crítica das ideias de Alan

Versão 1.0 · 10/11/2026 · documento de trabalho (nenhuma decisão tomada aqui)

Base: o documento "AD INFEROS — Brainstorming, análise de referências e evolução do jogo" (Alan, 10/11/2026), as especificações (`docs/specs/`), o GDD v1.1, os dados (`docs/balance/`), o código atual (`game/core/`, `game/scenes/`) e o backlog do M2.

**Sobre as referências.** O que está escrito aqui sobre Darkest Dungeon I (DD1) e II (DD2) vem do conhecimento geral dos dois jogos. Não consegui abrir as wikis nesta sessão: os sites recusam acesso automático. Onde um detalhe for importante para uma decisão, ele está marcado como **a confirmar**. Você jogou e pode corrigir.

**Regra que guiou a análise.** Uma ideia só vale se resolver um problema do Ad Inferos. Estar em Darkest Dungeon não basta. Três princípios do projeto pesam em quase tudo:

- o **combate determinístico** (ADR-0003);
- **santos nunca pecam nem perdem o controle** (`writing-guide.md` §1, `desolation.md` início);
- **figuras sagradas nunca viram bônus** e **Sufrágios nunca são gastos** (GDD §6 e §7).

---

## A. Diagnóstico: o que já existe

| Sistema | Estado | Onde |
| --- | --- | --- |
| Combate por turnos, intenções, Fervor, 3 posições × 4, movimento | **Pronto e testado** (M0/M1) | `core/combat/`, `specs/combat.md` |
| Tipos de dano Golpe/Exorcismo/sem tipo; inimigos Corpóreos e Espirituais (±25%) | **Pronto** | `combat.md` §9, `enemies.csv` (`nature`) |
| "Restos" de inimigos ocupando posição (`leaves_remains`, `remains_rounds`) | **Pronto no motor, sem uso nos dados** | `combatant.gd`, `enemies.csv` |
| Condições (Atordoamento, Sangramento, Corrupção, Amparo, Força, Provocação, Duelo, Congelamento, Fúria, Torpor) | **Pronto** (as dos círculos 5 e 9, só nos dados) | `specs/conditions.md` |
| Desolação 0–200, teste de Fé aos 100, Consolação, Noite Escura, Purificação, Prostração | **Pronto** | `core/spirit/`, `specs/desolation.md` |
| Ataque de desolação em área | **Já existe** (Lamento do Sopro Errante, `all_party`) | `enemy_actions.csv` |
| Lume: 100 no início, −5 por nó, Vela +25, 3 faixas com efeito | **Pronto (regras)**; na tela, só número e barra (agora a lamparina, T36) | `expedition_light.gd`, `expedition.md` §4 |
| Expedição: mapa em camadas, nós, Pouso, Vigília, recompensas, retirada | **Pronto (M1)**; caminhada interativa é a **T37** | `core/expedition/` |
| Provisões (8 espaços no Portão 1), uso em combate e fora dele | **Pronto** | `expedition.md` §5 |
| Tentação | **Evento narrativo** (tenda, opções com chance visível), nunca estado do santo | `narrative-system.md` §4.1 |
| Afinidades e traços (bônus de grupo) | **Pronto** | `combat.md` §12–13 |
| Relíquias (25 nos dados) e relíquia oculta no mapa | **Pronto**; tela de escolher quem carrega | `relics.csv`, D-146 |
| Interface do combate no clima DD | **Pronta** (T36, PR #55) | `battle_screen.gd`, `hud_style.gd` |
| Vila, semanas, instalações, níveis, campanha | **Só especificado** (T45–T50 do M2) | `village-economy.md`; `core/village/` vazio |
| Calendário litúrgico de 20 semanas, festas | **Só especificado** | `village-economy.md` §6 |
| Martirológio e Arquivo de Santo Tomás (o "bestiário") | **Só especificado** | `narrative-system.md` §7, GDD §6 |
| Prólogo, telas de passagem, áudio | **No backlog** (T51, T44, T54) | `m2.md` |
| Dicas na primeira vez | **Decidido** (D-191), ainda não feito | `m2.md` T51 |
| Recrutamento | **Não existe por compra**: santos chegam por marcos (Natal, círculos, Carmelo, Purgatório) | `village-economy.md` §10 |
| Esquiva, erro de ataque, crítico por sorte | **Não existem, por decisão** (ADR-0003) | — |
| Armadilhas, obstáculos, objetos de interação além de tenda/relicário/alma | **Não existem** | — |
| Tutorial completo, bestiário com registro, troféus, diário | **Não existem** | — |

**Conclusão do diagnóstico.** Boa parte do que o documento pede já existe, total ou parcialmente:

- tipos de dano contra espirituais;
- restos de inimigos;
- ataque de desolação em área;
- bônus de grupo;
- calendário litúrgico;
- Biblioteca com bestiário.

O que falta de verdade se concentra em três frentes: a **exploração** (objetos, armadilhas, formação fora do combate), a **vila inteira** e a **apresentação** (abertura, música, dicas).

---

## B e C. Análise e classificação de cada ideia

Classificação:

- ✅ **Recomendada**
- 🔧 **Recomendada com adaptações**
- 🧪 **Precisa de teste ou simulação**
- 💤 **Baixa prioridade**
- ⛔ **Não recomendada**
- ⏳ **Depende de outra decisão**

### 2. Abertura e apresentação

| Ideia | Referência | Análise | Classe |
| --- | --- | --- | --- |
| 2.1 Menu inicial com identidade | DD1: título com o Ancestral narrando e a mansão ao fundo; menu curto. | Hoje o título é simples. Um fundo com o Portão em camadas (parallax), a fonte Pirata One e a lamparina deixam o menu no clima sem atrasar a entrada no jogo. | ✅ |
| 2.2 Abertura cinematográfica pelo Mapa do Inferno até o Portão, com a inscrição | DD1 abre com um vídeo narrado (a confirmar a duração). | Tecnicamente viável no Godot com o que já existe: camadas, câmera animada, luz e o efeito de impacto. A arte do Portão já foi pedida (`env_gate_of_hell`, com a inscrição desenhada pelo motor). A inscrição é Dante, *Inferno* III, 9: precisa aparecer com o rótulo de origem. Deve poder ser pulada e mostrada só na primeira vez. Custo: arte (mapa do Inferno, figuras recortadas) e uma tarde de montagem. | 🔧 |
| 2.3 Abertura narrativa do Peregrino | — | **Já existe**: é o Prólogo (T51, roteiro de Alan, 11 cenas). Sugestão: usar o mesmo motor de cena para a abertura do 2.2, sem criar um sistema paralelo. | ✅ (já no plano) |
| 2.4 Música e sons por situação | DD1 muda a música pela tensão (exploração, combate, chefe) e tem sons fortes para golpe, crítico e estresse. | **Já no plano** (T54). Proposta de conjunto mínimo: vila, caminhada, combate, chefe, vitória, derrota e um tema de abertura (7 faixas), mais uma variação por círculo depois do M2. Fonte: bancos livres (D-177). | ✅ |
| 2.5 Logotipo e identidade | — | Necessário antes da loja; pedir arte. | 💤 (antes do lançamento) |

### 3. Telas de carregamento

- **Referência:** DD1 usa o carregamento para a voz do Ancestral, com frases da região, e para dicas.
- **No Godot:** as cenas do Ad Inferos carregam em menos de um segundo. Uma tela de "carregando" seria falsa.
- **Proposta:** uma **tela de passagem** curta, de 2 a 3 s e que se pula com um toque, ao entrar num círculo ou num chefe. Ela mostra:
  - o nome do círculo;
  - um verso de Dante com a origem;
  - uma dica.

Isso já cabe na T44 ("Telas de passagem") e substitui a ideia do loading. **Classe: 🔧**

### 4. Tutorial

- **Referência:** DD1 ensina com uma expedição inicial guiada e dicas na primeira vez que algo aparece. DD2 explica cada sistema com cartões curtos (a confirmar).
- **Ad Inferos:** você já decidiu "dicas curtas na primeira vez" (D-191). Proposta para não criar um sistema à parte:
  - uma lista de dicas no `ui_text.csv`;
  - a marca "já vista" guardada no `settings.json`, para não repetir;
  - uma aba "Ensinamentos" na Biblioteca para rever as dicas.
- **Pontos de disparo:**
  - primeira vez na vila;
  - primeira expedição;
  - primeiro combate;
  - primeira habilidade com Fervor;
  - primeira provisão;
  - primeira Noite Escura (ensinada por Teresinha, GDD §3);
  - primeiro chefe;
  - primeiro círculo concluído.

**Classe: ✅**

### 5. Exploração

| Ideia | Referência | Análise | Classe |
| --- | --- | --- | --- |
| 5.1 Objetos interativos | DD1: "curiosidades" no corredor; cada uma tem um resultado, e usar o item certo nelas (por exemplo, água benta num altar) dá o resultado bom. | Hoje o corredor tem tenda, relicário, alma e entradas. Proposta: **"Vestígios"**, objetos do círculo (por exemplo, no Círculo 2, um véu preso num espinho ou uma vela apagada) com **duas opções sempre visíveis**: passar ao largo, ou usar uma provisão para um bônus pequeno (Lume, desolação, Esmolas). Isso dá uso às provisões e dá decisão ao jogador sem acaso escondido. | 🔧 |
| 5.2 Reorganizar a equipe entre nós | DD1: o jogador reordena livremente fora do combate. | Hoje a ordem é escolhida no planejamento, e no combate trocar custa a ação. Permitir reordenar na caminhada, com a equipe parada, é barato (um comando novo e a tela) e de alto valor tático, principalmente com o Vendaval do Círculo 2. Restrição sugerida: não vale durante a emboscada nem dentro do nó. | ✅ |
| 5.3 Obstáculos que pedem item | DD1: obstáculos no corredor; sem pá, a equipe passa à força com dano e estresse. | Pode frustrar se bloquear o caminho. Adaptação: **nunca bloquear**. Sem o item, a equipe passa pagando Lume ou desolação. Juntar com os "Vestígios" (5.1) em vez de criar outra mecânica. | 🔧 (junto com 5.1) |
| 5.4 Armadilhas | DD1: armadilhas escondidas; o reconhecimento as revela e a chance de desarmar depende do herói. | O sorteio escondido vai contra o espírito do ADR-0003. Adaptação: **ciladas visíveis**, porque o Incenso e o Portão revelam camadas. Ao chegar, há uma escolha (contornar pagando Lume ou atravessar pagando vida ou desolação). Fica para o M3, com os círculos que pedem isso (Fraude, Heresia). | 💤 / 🔧 |
| 5.5 Elementos do ambiente que aumentam a desolação | DD1: certas curiosidades dão estresse. | Os círculos já têm uma mecânica de ambiente no combate (`expedition.md` §10). Fora do combate, cabe nos "Vestígios" (5.1) como opção de risco. Não criar um terceiro sistema. | ⏳ (depende do 5.1) |

### 6. Lume e desolação

- **Como está hoje:**
  - o Lume começa em 100 e perde 5 por nó;
  - um trecho tem de 8 a 12 nós, então sem velas termina perto de 40 a 60;
  - faixas: de 75 a 100 reduz a emboscada; de 25 a 74 é neutro; de 0 a 24 dá desolação × 1,3, inimigos com +10% de dano e Esmolas × 1,5;
  - o bônus de desolação do Lume alto foi retirado (D-164).
- **Referência:** em DD1, a tocha é o centro da tensão. Luz baixa traz mais emboscadas e mais críticos inimigos, mas também mais tesouro; luz alta melhora o reconhecimento. O estresse cresce andando no escuro (a confirmar).
- **Por que parece fraco:**
  1. Raramente se chega abaixo de 25 num trecho.
  2. Até a T36, o efeito não aparecia na tela.
  3. Na faixa do meio, nada acontece.
- **Proposta (sem números novos antes do simulador):**
  - a. **Desolação ao andar no escuro:** cada nó entrado com Lume abaixo de um limite dá uma pequena desolação a todos (o valor sai do simulador da T55).
  - b. **Uma 4ª faixa, a "Escuridão" (0–9),** com a mecânica do círculo mais forte. Por exemplo, o Vendaval troca duas duplas.
  - c. **Mostrar o efeito da faixa** perto da lamparina.
  - d. Talvez **−5 → −7 por nó**, para que as Velas virem decisão real.

  Tudo isso precisa passar pelo simulador, para manter a meta de Noite Escura (0,5 a 1,5 por expedição longa, D-126).
- **Classe: 🧪**

### 7. Combate

| Ideia | Referência | Análise | Classe |
| --- | --- | --- | --- |
| 7.1 Descrição ao tocar na habilidade | DD1: a dica mostra posições, alvos, dano, chance e efeitos. | Hoje, ao escolher a habilidade, aparece o texto `desc_pt` e a prévia exata no alvo. Falta um bloco organizado (alvo, posições de uso e de alcance, custo, efeitos). Barato: tudo vem dos dados. | ✅ |
| 7.2 Ficha do personagem no combate | DD1: o painel do herói mostra atributos, peças e efeitos. | A ficha da direita (T36) já mostra o combatente tocado. Falta para os santos: habilidades, relíquias, equipamento e traço, que dependem da vila (T47–T48). | 🔧 (após T48) |
| 7.3 Esquiva, erro, crítico | DD1 tem precisão, esquiva e crítico por sorte, e isso gera momentos marcantes, mas também frustração. | **Vai contra o ADR-0003**, que você decidiu em 03/11/2026: o combate é determinístico porque as intenções e a prévia exata dependem disso. Já existem formas de evitar dano: Amparo, Provocação, Proteção (`armor`), mover o alvo da intenção e atordoar. Recomendo auditar o **equilíbrio** dessas defesas no simulador (T55), não acrescentar acaso. | ⛔ (acaso) / 🧪 (equilíbrio) |
| 7.4 Dano físico fraco contra espirituais | DD1: tipos de inimigo (Eldritch, Unholy) com bônus de algumas habilidades. | **Já existe**: Golpe ×0,75 contra Espiritual e Exorcismo ×1,25. Uma redução "significativa" (por exemplo ×0,5) tornaria obrigatório um exorcista na equipe e Jorge fraco em metade das lutas. Ajustar só pelo simulador, se os números mostrarem que a diferença não pesa. | 🧪 |
| 7.5 Corpos ocupando posição | DD1: o cadáver ocupa a posição e protege a fila de trás. Bater no cadáver gasta a ação; ele some com o tempo ou por dano. | **O motor já tem** (`leaves_remains`, `remains_rounds`), só falta usar nos dados. Proposta: ligar em inimigos **Corpóreos** escolhidos, como o Diabo de Lodo e a Mãe-Enxame, com 2 rodadas. Os Espirituais somem na hora, como você sugeriu. Afeta alcance, área e duração: testar no simulador. | 🔧 / 🧪 |
| 7.6 Desolação em área | DD1: ataques de estresse em toda a equipe. | **Já existe** (Lamento do Sopro Errante). Bom candidato para chefes e para a Escuridão (6b). | ✅ (já existe) |
| 7.7 Animação própria por habilidade (pergaminho, luz, oração) | DD1: cada habilidade tem uma pose e um efeito próprios. | Hoje há três estilos (golpe, magia, bênção) mais efeitos por santo: cruzes, anel, pétalas, escudo. Fazer uma animação por habilidade multiplica a arte (12 santos × 6 habilidades). Adaptação: **um efeito por santo para a magia** e **um para o milagre** (o milagre merece a cena especial). | 🔧 |

### 8. Personagens e progressão

| Ideia | Análise | Classe |
| --- | --- | --- |
| 8.1 Seleção da equipe da semana | **Já especificada** em "Planejar a semana" (`village-economy.md` §2, T48–T49). | ✅ (já no plano) |
| 8.2 Retrato com cadeado para quem não pode ir | Ótimo e barato. O motivo aparece embaixo: "Na Capela", "Ferimento grave", "Ainda não chegou" (com o marco). Sem cadeado para quem está em Noite Escura, que pode ir. | ✅ |
| 8.3 Habilidades que ajudam o grupo | **Já existem**: afinidades, traços e bênçãos. Mais bônus passivos de presença tornam santos obrigatórios. Manter como está. | ✅ (já existe) |
| 8.4 Recrutar santos com Esmolas na "Casa de Treino" | DD1 recruta pela Diligência com ouro, e os heróis são descartáveis. No Ad Inferos, os santos são poucos, únicos e chegam por marcos com sentido: o Natal traz Nicolau, cada círculo traz um santo, o Carmelo traz João da Cruz, o Purgatório traz Gertrudes. **Comprar um santo** tira esse sentido e soa mal no tema ("santo à venda"). A Casa de Exercícios já existe para o treino. | ⛔ (compra) / ✅ (manter os marcos) |
| 8.5 Ficha definitiva do personagem | Necessária na vila (T50 já tem a "tela de novo santo"). Conteúdo sugerido em 3 abas: **Vida** (retrato, história com rótulo de origem, festa), **Combate** (atributos, habilidades, milagre, traço, afinidades) e **Caminho** (nível, experiência, equipamento, relíquias, ferimento, desolação). | ✅ |

### 9. Tentação e pecados

- **Referência:** em DD1, ao chegar a 100 de estresse, o herói pode entrar em "aflição" (egoísmo, raiva, desânimo...). Aí ele **age sozinho**: recusa ordens, ataca quem não devia, pula a vez.
- **O problema:** a proposta (Luxúria muda o alvo, Ira deixa agressivo, Acídia faz perder a vez) **contradiz duas regras fundadoras**:
  - "santos nunca pecam" (`writing-guide.md` §1.5);
  - "o santo nunca perde o controle das próprias ações" (`desolation.md`).

  Um santo dominado pela luxúria ou pela ira é exatamente o que o projeto proíbe. O equivalente do Ad Inferos à aflição já existe: é a **Noite Escura**, provação e não queda, que tira as habilidades de Fervor mas deixa o santo no comando.
- **Adaptação possível e coerente:** os pecados agem **de fora**, como **assédio** dos inimigos de cada círculo. São condições aplicadas por eles, visíveis, com contagem e com cura por provisão ou habilidade. Por exemplo:
  - Torpor (Acídia), que **já existe**;
  - Fúria nos inimigos (Ira), que **já existe**;
  - para a Luxúria (Círculo 2), um "Encanto" que puxa a intenção para o santo encantado. Ele sofre o assédio, não peca.

  O santo resiste; o jogador vê tudo antes. As Tentações continuam sendo eventos com escolha do Peregrino (que pode pecar e se converter), nunca estados dos santos.
- **Classe:** ⛔ (perda de controle / pecado do santo) e 🔧 (assédio vindo dos inimigos)

### 10. Chefes

| Ideia | Análise | Classe |
| --- | --- | --- |
| 10.1 Chefe com escolta | Já previsto para os elites (`node_elite` com escolta) e possível nos chefes (o efeito `summon` já existe). Definir na T38. | ✅ |
| 10.2 Objeto que protege o chefe | Compatível: o objeto vira um "inimigo" sem ações, com vida, e um gancho de chefe dá o efeito, por exemplo "enquanto o objeto existir, o chefe recebe −50%". Usa o sistema de alvos atual. Bom para o meio da campanha. | 🔧 |
| 10.3 Chefe que age dormindo | Possível como **intenção de ambiente** (a mesma vitrine do Vendaval): o efeito aparece antes, então não parece injusto. Combina com Belfegor/Acídia (Círculo 5). | 🔧 (M3) |
| 10.4 Dificuldade por mecânica, não só números | Já é o princípio do GDD §8 (cada chefe com uma mecânica nomeada). Manter. | ✅ |
| 10.5 Recompensas do chefe | Já existem: 300 Esmolas, mais 200 na primeira conclusão, mais o santo novo. Acrescentar o **selo** (ver 25). | ✅ |

### 11. Progressão dos círculos

- 11.1 **Já há escada:** encontros fáceis/difíceis por trecho, faixas de Esmolas (×1 / ×2,2 / ×3,6), mecânicas de ambiente novas por círculo e Escalada nas revisitas. ✅ (validar no simulador)
- 11.2 **Medalhão no Mapa do Inferno** para o círculo concluído: barato e muito claro. Pode ser o mesmo desenho do selo do chefe. ✅

### 12. Conclusão do círculo com luz da Providência

- **Coerência com as regras:** a regra permite figuras sagradas como **cena** (`narrative-system.md` §4.5), nunca como bônus. Uma luz dourada, a pomba como símbolo ao longe e o caminho de volta à vila são coerentes.
- **Risco a evitar:** a cena virar a "fonte" da recompensa. A ordem deve ser: cena, depois Conselho da vila (já previsto), depois recompensas, sem ligação visual entre a luz e as Esmolas.
- **Estrutura:** uma cena reutilizável com variações por círculo.
- **Classe: 🔧**

### 13. Itens e provisões

| Ideia | Análise | Classe |
| --- | --- | --- |
| 13.1 Auditar o inventário | Hoje há dois tipos: **provisões** (5 tipos, 8–12 espaços, uma unidade por espaço) e **relíquias** (equipadas por santo, D-146). Não há itens de missão. É simples e funciona. | ✅ (manter) |
| 13.2 Descartar itens | Uma provisão sem uso volta ao estoque da vila, então descartar só importa se o espaço encher no caminho. Hoje não se acha provisão no caminho. Só fará sentido com os "Vestígios" (5.1). | 💤 |
| 13.3 Quantidade de provisões | A conferir no simulador. DD1 sugere uma compra por tamanho de expedição; o Ad Inferos já prevê sugestões automáticas (§2). | 🧪 |
| 13.4 Esmolas, Fervor e provisões compartilhados | Já são da equipe: o Fervor é um só no combate e a mochila é da equipe. Sem inconsistência encontrada. | ✅ |

### 14. Relíquias

| Ideia | Análise | Classe |
| --- | --- | --- |
| 14.1 Inventário próprio de relíquias no Relicário | DD1 guarda os amuletos numa lista à parte. Proposta: a lista das relíquias da companhia fica no Relicário (instalação). Antes de o Relicário abrir (Círculo 4), a lista fica dentro de "Planejar a semana". Não cria sistema novo: é a mesma lista com outra porta. | ✅ |
| 14.2 Achar relíquias no caminho | **Já existe** (nó de relíquia oculta, 30% guardada por combate). | ✅ (já existe) |
| 14.3 Luz da Providência ao achar algo | Bonito, mas o risco de banalizar é real se toda Esmola brilhar. Proposta: **só relíquias** recebem a luz e uma frase curta (com origem). Esmolas são "esmolas deixadas pelos fiéis", sem efeito sagrado. | 🔧 |

### 15. Economia

- 15.1 **Esmolas para o que é material:** já é assim (moeda única). ✅
- 15.2 **Orações e Sufrágios para recompensas espirituais:** os Sufrágios **nunca são gastos**, por decisão de design (GDD §7). As recompensas da Trilha do Purgatório são "gratidão das Almas, não compra". Gastar Sufrágios para obter santos transformaria graça em moeda. ⛔. A Trilha do Purgatório já é a progressão espiritual, com Gertrudes no marco 3.
- 15.3 **Recrutamento por recurso:** ver 8.4. ⛔

### 16 e 17. Bestiário e Diário do Peregrino

- **O que já está previsto:** o GDD prevê a Biblioteca de Santo Tomás com o **Arquivo** (demônios, almas, lugares, fontes) e o **Martirológio** (santos), desbloqueados ao encontrar cada um.
- **Proposta:** **registrar o encontro desde o primeiro combate** (dado no save), mesmo antes de a Biblioteca abrir (Círculo 3). Quando ela abrir, as fichas já estão lá. As informações se revelam por camadas, como em DD (a confirmar como DD2 faz): primeiro nome e figura; depois de vencer, as ações; com a Biblioteca nível 1, as resistências.
- **O Diário do Peregrino** vira uma **aba da mesma Biblioteca**, com as páginas achadas nos "Vestígios" e as falas das almas. Assim nada fica espalhado.
- **Classe:** ✅ (registro) e 🔧 (diário, depende do 5.1)

### 18 a 21. Vila: visual e interface

| Ideia | Análise | Classe |
| --- | --- | --- |
| 18.1 Cenário montado pelo motor com os edifícios por cima | DD1: o Lugarejo é um painel único com edifícios clicáveis que mudam com as melhorias. Proposta igual à da batalha: céu, fundo e frente em camadas, mais os edifícios recortados por cima, cada um com estados (fechado, nível 1–3) e área de toque. Você manda os edifícios; o motor compõe o resto. | ✅ |
| 18.2 Praça com a estátua de Nossa Senhora | Permitido como **cena** (`writing-guide.md`: figuras sagradas nunca dão bônus). Fica só como elemento visual e símbolo da vila. | ✅ |
| 18.3 Dia e noite só visual | Barato no motor (cor e luz). Uma ligação boa sem regra nova: o tempo litúrgico muda a cor (roxo no Advento e na Quaresma, branco no Natal e na Páscoa, verde no Tempo Comum), já que a semana é o relógio do jogo. | 🔧 |
| 18.4/19.3 Imagem por nível de edifício | 3 imagens por edifício × 9 edifícios = 27 artes. Dá para reduzir: uma imagem-base mais acréscimos sobrepostos por nível (andaime, vitral aceso, estandarte). | 🔧 |
| 19.1 HUD da vila | Topo: semana, tempo litúrgico, Esmolas, Sufrágios (já especificado, `screens.md` §7). Embaixo: retratos dos santos (21.1). | ✅ |
| 19.2 Indicador "!" | Bom e barato. Regra para não poluir: só aparece quando há **ação possível nova** (instalação aberta, melhoria pagável, santo novo) e some ao abrir. | ✅ |
| 19.4/20.2 Carmelo presente desde o início, reformado | Hoje ele é **construído** após o Círculo 3 por 1.500. Adaptação **sem mudar regra**: as ruínas do Carmelo aparecem desde o início, e "construir" vira **reformar**, com o mesmo custo e os mesmos efeitos. As 7 janelas acendem com as Moradas (já previsto). Ganha narrativa e não mexe no equilíbrio. | ✅ |
| 20.1 Casa de Treino | Não há esse edifício. A **Casa de Exercícios** (Santo Inácio) já faz o treino (níveis, Carismas). Recrutar por compra: ver 8.4. | ⛔ (novo edifício) |
| 20.3 Biblioteca concentra Arquivo, Martirológio, Diário, Ensinamentos e calendário | Faz sentido e evita espalhar informação. | ✅ |
| 20.4 Portão abre o Mapa do Inferno | **Já decidido** (D-208): círculos bloqueados aparecem fechados, concluídos com medalhão (11.2). | ✅ |
| 20.5 Auditoria dos outros edifícios | Capela (Sufrágios, desolação), Enfermaria (ferimentos), Despensa (provisões), Portão (espaços, revelação), Forja (equipamento), Relicário (relíquias), Jardim (desolação). **Possível redundância:** Capela e Jardim fazem coisas parecidas (tirar desolação); a diferença é Sufrágios contra quantidade. **Sugestão:** manter, porque o Jardim chega tarde (Círculo 5) e é a válvula da campanha longa. | ✅ (manter) |
| 21.1 Retratos dos santos no HUD com ficha | Sim, liga com 8.2 e 8.5. | ✅ |
| 21.2 Balões de fala | DD1 não tem isso na vila; DD2 tem falas e relações na estrada (a confirmar). No Ad Inferos, cada fala é texto de santo e **exige origem** (frase real ou criação do jogo marcada). Começar pequeno: 3 frases por santo, tiradas dos escritos dele, ao entrar na vila. **Depende de você** fornecer ou aprovar as frases, porque o agente não inventa citações. | 🔧 / ⏳ |
| 21.3 São Tomás como escriba | Já é o guardião da Biblioteca no GDD. ✅ |

### 22 a 25. Registro, zelador, calendário, troféus

| Ideia | Análise | Classe |
| --- | --- | --- |
| 22 Registro de atividades e planejamento semanal | O planejamento já está especificado. O registro é barato: os comandos já ficam em log (`save-load.md`). Uma página "Crônica" na Biblioteca lista, por semana, a expedição, o resultado, as recompensas e os santos. | 🔧 |
| 23 "Zelador" que conta o que houve na vila | Em DD1, quem fala é o Ancestral, o narrador (a confirmar se há um "zelador" no seu sentido). Adaptação própria: ao voltar, um **relatório da semana** curto, dado por um guardião. Sugestão: **São Cristóvão no Portão**, que recebe quem volta. Ele diz o que mudou (ferimentos curados, Sufrágios, tempo litúrgico, festa, Conselho pendente). Sem texto inventado sobre santos: frases funcionais da interface. | 🔧 |
| 24 Calendário litúrgico | **Já especificado** (20 semanas, tempos, festas). Usar a data **real** do aparelho fica ⛔: o jogador perderia conteúdo e o ano do jogo (20 semanas) não bate com o real. Consultar o calendário na Biblioteca: ✅. | ✅ / ⛔ (data real) |
| 25 Troféus e selos | O GDD já tem os **vitrais da Capela como tela de conquistas**. Melhor que criar uma Sala de Troféus: cada chefe vencido acende um **vitral-selo** na Capela, e o mesmo desenho vira o medalhão do Mapa (11.2). Uma ideia, três lugares, sem duplicar. | 🔧 |

---

## D. Impactos

| Proposta | Sistemas afetados |
| --- | --- |
| Reordenar a equipe na caminhada (5.2) | Comando novo da expedição, save (ordem), tela da caminhada, testes de formação |
| Vestígios (5.1/5.3/5.5) | Dados novos por círculo, gerador do mapa (lugar no corredor), provisões, Lume, desolação, save, arte por círculo |
| Lume mais forte (6) | `constants.csv`, `expedition_light.gd`, simulador, metas de Noite Escura, interface da lamparina |
| Restos de inimigos (7.5) | Só dados (`enemies.csv`) + aparência do corpo na tela; alcance e área nos testes |
| Descrição de habilidade (7.1) | Só tela (`battle_screen`, `battle_texts`) |
| Assédio dos pecados (9) | `conditions.csv` (condições novas), ganchos, IA; textos com origem |
| Registro de inimigos (16) | Save da campanha (T46), tela da Biblioteca |
| Vila composta pelo motor (18) | Nova cena da vila (T49), arte dos edifícios |
| Dicas na primeira vez (4) | `ui_text.csv`, `settings.json`, telas que disparam |

## E. Riscos

- **Equilíbrio:** Lume mais punitivo + Escuridão + desolação em área podem empurrar a Noite Escura acima da meta. **Tudo que mexe em desolação passa pelo simulador antes.**
- **Complexidade:** Vestígios, armadilhas e obstáculos são três nomes para a mesma coisa. Propor **um só sistema**.
- **Regressão:** reordenar fora do combate mexe na formação salva. Precisa de teste de retomada.
- **Coerência narrativa:** os maiores riscos estão em 9 (santo que peca), 8.4/15.2 (comprar santos e graça), 14.3 (Providência como fonte de dinheiro). Por isso essas ficaram como não recomendadas ou adaptadas.
- **Arte:** abertura, vila por nível e animação por habilidade multiplicam pedidos de arte. Precisam de escopo fechado antes de pedir.
- **Desempenho no celular:** a vila em camadas e a abertura são leves; a atenção fica no tamanho das texturas (lição da T53).

## F. Ordem sugerida

1. **Agora, sem mexer em regra:** 7.1 (descrição da habilidade), 8.2 (cadeado), 4 (dicas na primeira vez, já decidido), 11.2/25 (medalhão e selo, desenho só depois).
2. **Na T37 (caminhada):** 5.2 (reordenar a equipe parada).
3. **Na T38–T41 (Círculo 2):** 7.5 (restos em alguns Corpóreos), 9 adaptado ("Encanto" como assédio do Círculo 2, se aprovado), 10.1/10.2 na especificação de Asmodeu.
4. **Na T55 (simulador):** 6 (Lume), 7.3 (equilíbrio das defesas), 7.4, 13.3.
5. **No bloco da vila (T45–T50):**
   - 18 e 19 (cenário e HUD);
   - 19.4 (Carmelo em ruínas);
   - 8.5 e 21.1 (ficha e retratos);
   - 16 (registro de inimigos no save);
   - 22 e 23 (Crônica e relatório de São Cristóvão);
   - 14.1 (lista de relíquias).
6. **No bloco de apresentação (T44, T51, T53, T54):** 2.1–2.4 (título, abertura pulável, música), 3 (passagem no lugar do loading), 12 (cena de conclusão).
7. **M3:** 5.1/5.3/5.4/5.5 (Vestígios e ciladas), 10.3, 21.2 (falas dos santos), 18.3 (luz pelo tempo litúrgico).

## G. Decisões que são suas

1. **Tentação (9):** aceita trocar "o santo peca e perde o controle" por **assédio dos inimigos** (condições visíveis aplicadas de fora, o santo resiste)? Ou prefere manter a Tentação só como evento do Peregrino?
2. **Recrutamento (8.4/15):** mantém os santos chegando por marcos (Natal, círculos, Carmelo, Purgatório), sem compra? Se quiser algo na vila, a alternativa é uma tela "Companhia" que mostra quem já chegou e o que falta para cada um chegar.
3. **Esquiva e crítico (7.3):** confirma o ADR-0003 (sem acaso no acerto)?
4. **Lume (6):** posso preparar a simulação com as variantes a, b, c e d para você escolher pelos resultados?
5. **Restos de inimigos (7.5):** quais inimigos? Sugestão: Diabo de Lodo e Mãe-Enxame, por 2 rodadas.
6. **Reordenar a equipe (5.2):** livre a qualquer momento parado, ou só nos Pousos?
7. **Vestígios (5.1):** aprova o conceito de um só sistema para objetos, obstáculos e armadilhas, para especificar no M3?
8. **Carmelo em ruínas desde o início (19.4)**, com reforma pelo mesmo custo?
9. **Troféus (25):** usar os vitrais da Capela (já no GDD) em vez de uma Sala de Troféus?
10. **Relatório da semana (23):** São Cristóvão no Portão ou outro guardião?
11. **Abertura (2.2):** a ordem seria abertura → título → Prólogo (na primeira vez)?
12. **Falas dos santos na vila (21.2):** você fornece ou aprova as frases, com a fonte?

## H. Próximos passos

1. Você responde às decisões (G), mesmo que em partes.
2. Eu registro cada uma em `docs/memory/decisions.md` e atualizo as especificações afetadas. Será um PR só de documentos, com nenhum código.
3. As decisões que mexem em números (Lume, defesas, restos) vão primeiro ao simulador, com relatório para você escolher.
4. Cada item aprovado entra no backlog na tarefa certa (ordem F), com plano curto antes de codar, como pede a seção 29 do seu documento.
5. Enquanto isso, a T37 (caminhada interativa) continua parada até você liberar.
