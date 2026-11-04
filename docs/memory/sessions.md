# Sessões do agente

Resumo curto de cada sessão. A mais recente no topo.

## Sessão 3 · 04/11/2026

- Sem Godot no ambiente (compilação negada de novo pelas permissões): testes pelo CI; sintaxe conferida com `gdtoolkit` (`pip install "gdtoolkit==4.*"`, comando `gdparse`).
- Feitos: backlog do M1 (PR #24), T18 specs da caminhada (PR #25), T19 Lume e estado da expedição (PR #26), T20 gerador do trecho (PR #27).
- Decisões de Alan: D-121 a D-133 (caminhada e mini-mapa, rascunho da Tentação pelo agente, kit fixo de provisões, nó variável sem elite, metas D-113, Incenso revela mais uma camada, números do gerador).
- Estado ao fim: 329 testes passando. Próximo: **T21** (controlador da expedição e comandos, `docs/backlog/m1.md`).

## Sessão 2 · 03 e 04/11/2026

- Sem Godot no ambiente (compilação negada pelas permissões): tudo testado pelo CI do GitHub; sintaxe conferida com `gdtoolkit`.
- Feitas: T15 tela de combate (PR #17), T16 auréola (PR #18), arte nova de Jorge com poses e retrato (PR #19), T17 arena, botões de teste e APK (PR #20), correção da tela deslocada no celular (PR #21), folhas de produção de arte (PR #22) e telas de passagem (PR #23).
- Publicação: jogo no navegador (GitHub Pages) e APK de teste em Releases (`teste-android`), ambos automáticos a cada merge.
- Decisões de Alan: D-114 a D-120, D-203 a D-215. Lições novas: ternário perde o tipo de lista; `set_anchors_preset` não dá tamanho a Control criado em código.
- Estado ao fim: **M0 concluído** (T00 a T17). Próximo: proposta do backlog do M1 (`docs/backlog/m1.md`) para Alan aprovar, incluindo caminhada entre nós com bifurcações (D-207) e o Mapa do Inferno no portão da vila (D-208). Pendente de Alan: tempo de um combate no APK (meta 2 a 4 min).

## Sessão 1 · 03/11/2026

- Recebidos de Alan: GDD v1.1, Direção de Arte v1.1, specs, CSVs de balanceamento, ADRs, backlog do M0 e documentos de apoio; organizados em `docs/`.
- Ambiente: Godot 4.7.2 compilado do código-fonte na nuvem; CI no GitHub com o Godot oficial.
- Feitas as tarefas T00 a T14 do M0 (PRs #1 a #14), mais o documento de continuidade (PR #15) e a arte do piloto de São Jorge com o ADR-0007 decidido (PR #16).
- Decisões de Alan: D-001 a D-008, D-101 a D-113 e D-201 (`decisions.md`).
- Estado ao fim: 249 testes passando; simulador com 7 de 9 metas; próxima tarefa é a T15 (tela de combate), numa sessão nova.
