# Registro de decisões

Só acrescentar; nunca apagar nem reescrever. Uma decisão revista ganha nova entrada que cita a anterior ("substitui D-xxx").
Formato: **D-número · data · quem** — decisão. *Onde está aplicada.*

## Forma de trabalho

- **D-001 · 03/11/2026 · Alan** — Alan é o navegador, aprovador e olhar crítico; o agente é o piloto técnico. O agente pede o que precisar de forma clara, em português e em linguagem simples. *`CLAUDE.md` §2, `owner.md`.*
- **D-002 · 03/11/2026 · Alan** — Uma tarefa do backlog por PR. Merge só depois de Alan escrever "aprovado". *`progress.md`.*
- **D-003 · 03/11/2026 · Alan** — "Acompanhe sempre os PR": o agente acompanha cada PR aberto (CI e comentários) até o merge e corrige falhas sozinho.
- **D-004 · 03/11/2026 · Alan** — Plano curto antes de programar; pergunta quando a spec é ambígua; nunca inventa regra (`CLAUDE.md` §9).
- **D-005 · 03/11/2026 · Alan** — Liberada a compilação do Godot a partir do código-fonte no ambiente na nuvem. *`progress.md` (Ambiente).*
- **D-006 · 03/11/2026 · Alan** — GitHub Pages ligado (Settings → Pages → Source: GitHub Actions) para testar o jogo no navegador do celular a partir da T15.
- **D-007 · 03/11/2026 · Alan** — Originais de arte ficam no Google Drive de Alan; ele envia pelo chat só o que a tarefa precisa; o agente processa conforme `docs/art/asset-pipeline.md`. Cuidado com a cota de 1 GB do Git LFS.
- **D-008 · 03/11/2026 · Alan** — Memória do projeto no repositório (`docs/memory/`), carregada automaticamente no início de cada sessão; checklist de memória em todo PR. *Esta pasta, `.claude/settings.json`, `.github/pull_request_template.md`.*

## Regras de jogo (aprovadas por Alan)

- **D-101 · 03/11/2026 · Alan** — Relíquia de Sebastião: o texto passa a dizer "1 Amparo" (era "Proteção"). *`relics.csv`.*
- **D-102 · 03/11/2026 · Alan** — Janela de levantar um Caído: o resto da rodada da queda e a rodada seguinte; no fim desta, fica fora de combate. *T03, `BattleState.end_round_falls`.*
- **D-103 · 03/11/2026 · Alan** — Fervor extra: só o que de fato entra (abaixo do teto) conta para o limite de +2 por rodada. *T04, `FervorPool`.*
- **D-104 · 03/11/2026 · Alan** — `chosen_enemy_slots(n)` aceita menos posições quando há menos inimigos vivos ao alcance (Sermão aos Peixes com 1 inimigo). *T05.*
- **D-105 · 03/11/2026 · Alan** — Provisão só em santo de pé (o Pão não levanta Caído). *T05.*
- **D-106 · 03/11/2026 · Alan** — Santo Atordoado só pode passar a vez (não usa habilidade, não se move, não aplica provisão). *T05.*
- **D-107 · 03/11/2026 · Alan** — O santo Atordoado gasta o atordoamento ao passar (ou se o turno acaba sem agir) e fica imune até o fim da rodada seguinte, como o inimigo. *T07.*
- **D-108 · 03/11/2026 · Alan** — Bônus de afinidade só para os membros da afinidade. *T10.*
- **D-109 · 03/11/2026 · Alan** — Clausura bloqueia só deslocamento por inimigos e ambiente, e só com Bento de pé; troca voluntária e habilidades da equipe continuam movendo. *T10.*
- **D-110 · 03/11/2026 · Alan** — Pequeno Caminho: vale para curas e levantamentos que custariam Fervor; nunca para o milagre; uma cura de custo 0 não gasta o bônus. *T10.*
- **D-111 · 03/11/2026 · Alan** — Balanceamento da T14: Família A com +20% de vida e dano; Sangramento do Moscardo 2; Corrupção da Sombra 3; desolação do Toque da Sombra 10 e do Lamento 8. *CSVs, `docs/balance/sim-reports/2026-11-03-m0-t14.md`.*
- **D-112 · 03/11/2026 · Alan** — Vigília no Pouso passa de −40 para −20 de desolação. *`constants.csv`, specs de desolação e expedição.*
- **D-113 · 03/11/2026 · Alan** — Metas "vitória da heurística em combate difícil" e "Noite Escura na expedição longa" ficam para recalibrar no M1.
- **D-114 · 03/11/2026 · Alan** — Textos da tela de combate (`docs/balance/ui_text.csv`) revisados e aprovados sem mudanças; T15 aprovada. *PR #17.*
- **D-115 · 03/11/2026 · Alan** — T16 aprovada (auréola no motor com a arte piloto de São Jorge). *PR #18.*
- **D-116 · 04/11/2026 · Alan** — Animação de combate estilo Darkest Dungeon fica no plano original: M2, junto com a arte final (trava "abordagem de animação" do roadmap, ADR-0007). *`open-questions.md`.*
- **D-117 · 04/11/2026 · Alan** — A T17 inclui botões de teste (só na versão de desenvolvimento) para aumentar e diminuir a desolação e para pôr um santo em Consolação, para ver a auréola mudar. *`docs/backlog/m0.md` T17.*
- **D-118 · 04/11/2026 · Alan** — T17 aprovada (arena, botões de teste, APK). Falta o aceite no celular (instalar e jogar de 2 a 4 min). *PR #20.*
- **D-119 · 04/11/2026 · Alan** — T17 não aprovada no celular: tela de combate deslocada. Corrigir antes de fechar o M0. *`lessons.md`, PR da correção.*
- **D-120 · 04/11/2026 · Alan** — Correção da tela deslocada aprovada (PR #21); falta o novo teste no Redmi para fechar a T17. *`progress.md`.*
- **D-121 · 04/11/2026 · Alan** — M1: a tela principal da expedição é o corredor da caminhada; no fim de cada corredor aparecem as entradas da próxima camada com o ícone do tipo de nó; um botão abre o mini-mapa do trecho inteiro. Detalha D-207. *`docs/backlog/m1.md` T18 e T27.*
- **D-122 · 04/11/2026 · Alan** — Texto da Tentação do M1: o agente faz o rascunho seguindo `writing-guide.md` (origem `game_fiction`); Alan corrige e aprova antes do merge. *T23.*
- **D-123 · 04/11/2026 · Alan** — Sem vila no M1, a expedição parte com um kit fixo de provisões definido pelo agente, com pelo menos 1 de cada: 2 Pães, 1 Vela, 2 Águas Bentas, 1 Ataduras, 1 Incenso (7 dos 8 espaços). *T22, `m1.md`.*
- **D-124 · 04/11/2026 · Alan** — M1 sem elites: o nó variável sorteia só entre relíquia (35) e combate (25); relíquias do M1: Vela da Candelária, Cruz em tau e Crucifixo de madeira. *T25.*
- **D-125 · 04/11/2026 · Alan** — Meta "vitória da heurística em combate difícil" (75–90%) passa a ser medida nos combates difíceis dentro de trechos simulados. Detalha D-113. *T31.*
- **D-126 · 04/11/2026 · Alan** — Meta de Noite Escura no M1: "Noite Escura por trecho", com o valor aprovado por Alan depois do primeiro relatório; a meta da expedição longa (0,5–1,5) volta no M2. Detalha D-113. *T31.*
- **D-127 · 04/11/2026 · Alan** — Backlog do M1 aprovado (PR #24). Próxima tarefa: T18. *`docs/backlog/m1.md`.*
- **D-128 · 04/11/2026 · Alan** — Mini-mapa da expedição só para consulta; a escolha do caminho é feita nas entradas do corredor. *`expedition.md` §2.3, `screens.md` §4.*
- **D-129 · 04/11/2026 · Alan** — Incenso passa a revelar mais uma camada além do que o Portão mostra (nos nós ligados às entradas da bifurcação), ou anula a emboscada no Pouso. Substitui "revela os nós vizinhos". *`expedition.md` §2.2 e §5, caso E14.*
- **D-130 · 04/11/2026 · Alan** — T18 aprovada (specs da caminhada e simplificações do M1). *PR #25.*
- **D-131 · 04/11/2026 · Alan** — T19 aprovada (estado da expedição e Lume; +10% de dano inimigo com Lume baixo na fórmula de dano). *PR #26.*
- **D-132 · 04/11/2026 · Alan** — Gerador do trecho: 2 ou 3 nós por camada, meio a meio (`map_three_nodes_chance` 0,5); cada nó liga ao caminho reto e, com 50% de chance, a um vizinho (`map_second_link_chance` 0,5), sem ligações cruzadas; trecho fixo de reserva desenhado pelo agente em `docs/balance/map_templates.csv`. *T20, `expedition.md` §2, `data-schemas.md` §3.15.*
- **D-133 · 04/11/2026 · Alan** — T20 aprovada (gerador do trecho e trecho de reserva). *PR #27.*
- **D-134 · 04/11/2026 · Alan** — Entre combates, a equipe começa na ordem em que o combate anterior terminou (como em Darkest Dungeon). *T21, `ExpeditionController`, `expedition.md` §13.*
- **D-135 · 04/11/2026 · Alan** — T21 aprovada (controlador da expedição, comandos e estado dos santos entre combates). *PR #28.*
- **D-136 · 04/11/2026 · Alan** — Ataduras só podem ser usadas em combate (o Sangramento acaba com o combate); fora dele aparecem indisponíveis com o motivo. Pão fora do combate só serve para descansar no Pouso. *T22, `FieldProvisions`, `expedition.md` §5.*
- **D-137 · 04/11/2026 · Alan** — O que o Incenso revela fica conhecido até o fim do trecho. *T22, `ExpeditionState.revealed_nodes`, `expedition.md` §2.2.*
- **D-138 · 04/11/2026 · Alan** — T22 aprovada (kit de partida, mochila, provisões fora do combate e correção da Água Benta, D-317). *PR #29.*

## Arte

- **D-201 · 03/11/2026 · Alan** — Poses de ataque, golpe recebido e queda não serão geradas: animação feita no motor a partir de uma imagem por estado; plano B é recorte com `Skeleton2D`. *ADR-0007.*

- **D-202 · 03/11/2026 · Alan** — Teresinha: a imagem com muitas pétalas é a Consolação; a com poucas pétalas é o estado padrão. *`art_source/characters/saints/saint_therese/`.*
- **D-203 · 03/11/2026 · Alan** — Depois de jogar a T15 no navegador (toque e leitura OK), Alan manteve o plano original: a T16 traz só São Jorge e a auréola; o resto da arte recebida (Bento, Teresinha, inimigos, cenário) entra depois. O seletor de encontro fica para a T17. *`progress.md`.*
- **D-204 · 04/11/2026 · Alan** — Alan gerou arte nova de São Jorge (pose normal melhor, pose neutra para recorte, ataque, golpe recebido, queda e retrato) e pediu para testar antes da T17. As poses entram na animação no motor (troca de imagem durante o movimento); a animação completa estilo Darkest Dungeon segue no M2 (D-116). *ADR-0007 (atualização), PR do complemento da T16.*
- **D-214 · 04/11/2026 · Alan** — Tela do milagre de São Jorge segue a folha `prompts-splash.md` (Jorge a pé, lança erguida, sem cavalo nem dragão); substitui a menção ao cavalo em D-210. PR #23 aprovado.
- **D-215 · 04/11/2026 · Alan** — Pode começar a proposta do backlog do M1. Quando o contexto da conversa estiver ficando cheio, o agente avisa e entrega o texto exato para colar numa conversa nova. *`owner.md`, `README.md` desta pasta (protocolo §4).*
- **D-213 · 04/11/2026 · Alan** — Folha das telas de passagem: `docs/art/prompts-splash.md` (milagre, Noite Escura e Consolação dos 12 santos, 1024×1280, santo sozinho em meio corpo; o motor compõe raios, auréola e nome). Nomes, efeitos e origens conferidos com `abilities.csv`. Detalha D-210 para o M2. *`docs/art/asset-pipeline.md`.*
- **D-207 · 04/11/2026 · Alan** — Expedição com **caminhada lateral entre os nós**, como em Darkest Dungeon, com bifurcações: seguir reto ou tomar outro caminho (porta, caverna...). Detalhamento numa etapa própria do M1 ou M2; a spec de expedição será atualizada lá.
- **D-208 · 04/11/2026 · Alan** — O **Mapa do Inferno** (escolha do círculo em faixas) aparece ao tocar para sair pelo portão da vila, no Átrio; escolhido o círculo, começa a expedição.
- **D-209 · 04/11/2026 · Alan** — Personagens pequenos em relação à tela (também no APK): rever o leiaute do campo no M2, junto com a linha do chão dos cenários.
- **D-210 · 04/11/2026 · Alan** — Estados espirituais seguem com **imagem de corpo inteiro** por estado (não só o rosto). Animação no estilo Darkest Dungeon no M2: transições, andar, câmera que aproxima, avanço e ataque. **Milagres** com imagem sobreposta em tela especial (ex.: Jorge atacando a cavalo). **Consolação e desolação** (Noite Escura) com imagem sobreposta por um momento, mostrando o santo em consolação ou em agonia, como a loucura em Darkest Dungeon. Substitui a parte de D-116 que falava só de "animação estilo DD".
- **D-211 · 04/11/2026 · Alan** — Santa Rita: gesto do crucifixo na pose de ataque aprovado.
- **D-212 · 04/11/2026 · Alan** — Folhas de produção aprovadas (PR #22). APK corrigido instalado e aberto no Redmi: **T17 aceita**.
- **D-206 · 04/11/2026 · Alan** — Folhas de produção de arte de Alan entram como fonte da direção de arte: `docs/art/prompts-saints.md` (12 santos, 9 imagens cada, incluindo rostos por estado e rig) e `docs/art/prompts-environments.md` (cenários em 4 camadas para parallax, almas, Pouso, Vigília, mapa de escolha dos círculos). Guardadas sem alteração; o pipeline aponta para elas. *`docs/art/asset-pipeline.md`.*
- **D-205 · 04/11/2026 · Alan** — Complemento da T16 aprovado (PR #19). Noite Escura e Consolação de Jorge ficam com as imagens antigas por enquanto; Alan testa assim. *`open-questions.md`.*

## Técnicas (do agente)

- **D-301** — Godot 4.7.2 + GUT 9.7.1; CI no GitHub baixa o Godot oficial, analisa cada script, falha se o GUT ignorar um teste e confere `game/data` com os CSVs.
- **D-302** — Gerador com semente próprio (hash de 32 bits, contador por fluxo): mesmo resultado em qualquer aparelho. *T01.*
- **D-303** — Importador de CSV recusa tudo se houver qualquer erro; grava só o que mudou; erros com arquivo, linha e código. *T02.*
- **D-304** — Comandos são dados (`BattleCommand`); log reaplicado via JSON reconstrói o combate byte a byte. *T05, T12.*
- **D-305** — Recarga de N rodadas: a ação inimiga fica indisponível nas N rodadas seguintes ao uso. *T09.*
- **D-306** — Contra-ataque do Duelo passa pela fórmula de dano normal e não gasta a Força de Jorge. *T07.*
- **D-307** — A pré-visualização executa numa cópia completa do combate e não mostra o resultado do teste de Fé. *T11.*
- **D-309 · 03/11/2026 · agente** — Textos da interface em `docs/balance/ui_text.csv`, importados para `game/data/ui_text.tres`; chave ausente aparece como `[chave]`. *ADR-0010, T15.*
- **D-310 · 03/11/2026 · agente** — Tela de combate montada em código sobre um palco de 1920×1080 centralizado; o fluxo de toques fica em `BattleSelection` (sem `Node`), que só usa `validate()` e `preview()`. A prévia passou a informar a desolação (`PreviewEntry.desolation`). *T15, `scenes/battle/`.*
- **D-311 · 03/11/2026 · agente** — Versão Web sem threads publicada no GitHub Pages a cada merge na `main` (o Pages não envia COOP/COEP). *`.github/workflows/pages.yml`, `game/export_presets.cfg`.*
- **D-312 · 03/11/2026 · agente** — Arte tratada por `tools/art/process_art.py` (Python e Pillow, ferramenta de desenvolvimento). *ADR-0011.*
- **D-313 · 03/11/2026 · agente** — Arte de cada santo num recurso `CombatantArt` (`scenes/battle/combatants/<id>_art.tres`) com uma imagem por estado e o ponto da cabeça; valores visuais da auréola em `scenes/battle/halo_settings.tres` (apresentação, fora de `docs/balance`). Texturas com importação padrão (sem perda) até a T17. *T16.*
- **D-314 · 04/11/2026 · agente** — Botões de teste ligados em builds de depuração ou com a feature `dev_tools` (presets Web e Android da fase de testes); passam pelas regras de desolação, mas não entram no log de comandos. *T17, `BattleController.dev_*`.*
- **D-315 · 04/11/2026 · agente** — APK de depuração montado no GitHub Actions (SDK Android do próprio runner, chave de depuração descartável gerada a cada build) e publicado em Releases com a tag fixa `teste-android`. *`.github/workflows/android.yml`.*
- **D-316 · 04/11/2026 · agente** — Expedição: cada combate tem semente própria, derivada da semente do mapa e do ID do nó (um combate nunca depende de quantos sorteios os anteriores fizeram); `economy.csv` passa a ser importado como `game/data/economy.tres`; o estado de cada santo entre combates fica em `SaintStatus` (vida, desolação, estado espiritual, ferimento). *T21, `core/expedition/`.*
- **D-317 · 04/11/2026 · agente** — Correção: o importador trocava o valor de um efeito pela constante (`const=`) e perdia o sinal da planilha; a Água Benta **aumentava** a desolação em 15 (também em combate, desde o M0). Agora a constante dá o tamanho e a planilha dá o sinal. *T22, `balance_importer.gd`, teste em `test_balance_importer.gd`.*
- **D-308** — Simulador: formação do M0 Jorge (1), Bento (2), Teresinha (3); expedição longa simulada com 6 combates, Lume −5 por nó, Pousos com Vigília depois dos combates 2 e 4 e vida cheia a cada combate. *T13, `tools/sim/battle_simulator.gd`.*
