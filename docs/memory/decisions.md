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

## Arte

- **D-201 · 03/11/2026 · Alan** — Poses de ataque, golpe recebido e queda não serão geradas: animação feita no motor a partir de uma imagem por estado; plano B é recorte com `Skeleton2D`. *ADR-0007.*

- **D-202 · 03/11/2026 · Alan** — Teresinha: a imagem com muitas pétalas é a Consolação; a com poucas pétalas é o estado padrão. *`art_source/characters/saints/saint_therese/`.*
- **D-203 · 03/11/2026 · Alan** — Depois de jogar a T15 no navegador (toque e leitura OK), Alan manteve o plano original: a T16 traz só São Jorge e a auréola; o resto da arte recebida (Bento, Teresinha, inimigos, cenário) entra depois. O seletor de encontro fica para a T17. *`progress.md`.*

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
- **D-308** — Simulador: formação do M0 Jorge (1), Bento (2), Teresinha (3); expedição longa simulada com 6 combates, Lume −5 por nó, Pousos com Vigília depois dos combates 2 e 4 e vida cheia a cada combate. *T13, `tools/sim/battle_simulator.gd`.*
