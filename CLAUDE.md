# CLAUDE.md — Ad Inferos: A Companhia dos Santos

Instruções permanentes para o agente que desenvolve este projeto. Leia este arquivo inteiro no início de toda sessão.

## 1. O projeto em uma frase

RPG tático por turnos para Android (paisagem), feito em Godot 4, em que uma companhia de três santos católicos segue um Peregrino pelos nove círculos do Inferno de Dante. Projeto de portfólio, sem compras dentro do jogo, classificação 18 anos.

## 2. Papéis

- **Responsável pelo projeto (Alan):** decide design, narrativa, tom, arte e prioridades. Não é desenvolvedor. Explique decisões técnicas em linguagem simples quando precisar da aprovação dele.
- **Agente (você):** implementa, testa e mantém o código, os dados e a documentação técnica. Decide questões puramente técnicas e registra a decisão em `docs/adr/`.

## 3. Fontes de verdade (em ordem de prioridade)

1. `docs/specs/*.md` — regras exatas dos sistemas. **É o que você implementa.**
2. `docs/data-schemas.md` — formato de todos os dados.
3. `docs/balance/*.csv` — todos os números do jogo.
4. `docs/architecture.md` e `docs/adr/` — como o código é organizado e por quê.
5. `docs/gdd/gdd-v1.1.md` — visão e intenção de design (contexto, não especificação).
6. `docs/art/` — direção de arte e pipeline de assets.
7. `docs/narrative/writing-guide.md` — regras para qualquer texto que apareça no jogo.
8. `docs/glossary.md` — nomes oficiais em português e em inglês (código).

`docs/design/saint-kits.md` é gerado a partir dos CSVs (leitura para o responsável); se divergir, valem os CSVs.

Se a especificação e o GDD divergirem, **a especificação vale** e você aponta a divergência no resumo da tarefa.

## 4. Ambiente

- **Engine:** Godot 4.7.x estável (série estável mais recente em nov/2026). Confirme a versão instalada com `godot --version` e atualize esta linha se for diferente. Nunca use sintaxe ou APIs do Godot 3.
- **`godot --version` registrado (03/11/2026):** `4.7.2.stable.official.ed1daf0bf` (CI do GitHub, `.github/workflows/tests.yml`).
- **Godot na sessão (D-162):** o gancho `SessionStart` roda `tools/dev/setup_godot.sh`, que liga o Godot já compilado ou começa a compilação em segundo plano (cerca de 25 min). Antes de testar localmente, confira se ficou pronto (o script diz onde está o log); depois `git lfs pull` e `godot --headless --path game --import`.
- **Linguagem:** GDScript **com tipagem estática obrigatória** (`var hp: int`, `func f(x: int) -> void`). Sem C#.
- **Renderizador:** Compatibility (OpenGL ES 3), para cobrir Android de entrada.
- **Testes:** GUT (Godot Unit Test) em `game/addons/gut/`. Ver `docs/testing.md`.
- **Controle de versão:** Git com Git LFS para imagens e áudio.

## 5. Comandos

```bash
# rodar todos os testes sem abrir o editor (a partir da raiz do repositório)
godot --headless --path game -s addons/gut/gut_cmdln.gd -gdir=res://tests -ginclude_subdirs -gexit

# rodar um diretório de testes
godot --headless --path game -s addons/gut/gut_cmdln.gd -gdir=res://tests/unit/conditions -gexit

# simulador de balanceamento (sem tela)
godot --headless --path game -s res://tools/sim/run_sim.gd -- --encounters=m0 --runs=1000

# importar os CSVs de balanceamento para Resources
godot --headless --path game -s res://tools/data/import_balance.gd

# conferir se game/data está em dia com os CSVs, sem gravar (usado pelo CI)
godot --headless --path game -s res://tools/data/import_balance.gd -- --check
```

Se algum comando não existir ainda, a tarefa atual provavelmente é criá-lo; confira o backlog.

## 6. Arquitetura (resumo; detalhes em `docs/architecture.md`)

- `game/core/` — **regras puras**. Classes `RefCounted`, sem `Node`, sem cenas, sem `get_tree()`, sem acesso a arquivos. Toda regra do jogo mora aqui e é testável sem tela.
- `game/data/` — conteúdo em Resources (`.tres`) gerados a partir de `docs/balance/*.csv`. Conteúdo novo = dado novo, não código novo.
- `game/scenes/` — apresentação. Lê o estado e reage a eventos; **nunca decide uma regra**.
- `game/autoload/` — serviços globais mínimos: `EventBus`, `GameState`, `SaveService`.
- Toda ação do jogador vira um **comando** registrado em log. Toda aleatoriedade passa por `core/rng/` com semente.

Regra de dependência: `scenes → core`, nunca `core → scenes`. `core` não conhece `autoload`.

## 7. Convenções de código

- Código, nomes de arquivos, classes e variáveis em **inglês**, usando os termos de `docs/glossary.md`. Textos exibidos ao jogador em **português**, vindos dos dados, nunca escritos no código.
- Arquivos e pastas em `snake_case`; classes em `PascalCase` com `class_name`.
- Um arquivo por classe. Funções curtas. Comentários explicam *por quê*, não *o quê*.
- Números de balanceamento **nunca** no código: venham de `docs/balance/` via Resources.
- Sinais (`signal`) para comunicação de `core` para fora; `core` emite eventos por um objeto `CombatEvents`/`GameEvents`, não pelo `EventBus` global.
- Sem singletons além dos três autoloads.
- Sem `await` dentro de `core/`.

## 8. Como trabalhar em cada tarefa

0. No início da sessão, leia a memória do projeto em `docs/memory/` (carregada automaticamente pelo gancho de `.claude/settings.json`) e siga o protocolo de `docs/memory/README.md`: toda decisão vai para `decisions.md` no mesmo PR; nada importante fica só no chat.
1. Leia a tarefa no backlog (`docs/backlog/`) e as seções da especificação que ela cita.
2. Se a tarefa for maior que algumas horas ou mexer em mais de um sistema, apresente um plano curto antes de codar.
3. Escreva os testes junto com o código. Uma tarefa só está pronta com testes passando.
4. Mexa apenas nos arquivos do escopo da tarefa.
5. Ao terminar, entregue: o que mudou, como testar, o comando de teste usado e o resultado, e qualquer ambiguidade encontrada.
6. Atualize a caixa da tarefa no backlog e a memória (`docs/memory/progress.md`, `decisions.md`, `open-questions.md`).

## 9. Pare e pergunte quando

- A especificação estiver ambígua, contraditória ou incompleta para o caso.
- A tarefa exigir um número que não está em `docs/balance/`.
- Uma mudança afetar o design (regra, texto, tom, figura sagrada, conteúdo sensível).
- Você precisar mudar a arquitetura ou criar um novo autoload.

Nunca invente regras de jogo, números de balanceamento, textos narrativos, citações bíblicas, fatos sobre santos, orações ou relíquias.

## 10. O que nunca fazer

- Alterar `docs/gdd/`, `docs/art/art-direction.md` ou `docs/narrative/` sem pedido explícito.
- Mexer em `art_source/` (arquivos originais de arte).
- Apagar ou sobrescrever saves de jogador sem migração (`docs/specs/save-load.md`).
- Introduzir acerto aleatório, críticos por sorte ou qualquer acaso não previsto nas especificações (o combate é determinístico: ADR-0003).
- Adicionar dependências externas (plugins, bibliotecas) sem um ADR.
- Commitar com testes falhando.

## 11. Conteúdo e tom (resumo de `docs/narrative/writing-guide.md`)

- Figuras sagradas (Deus, Cristo, Nossa Senhora, São José) nunca viram unidades, estatísticas ou fontes de bônus.
- Santos nunca pecam nem são sexualizados. Nenhuma criança como vítima. Nenhum ato sexual explícito.
- Todo texto de lore indica a origem: Escritura, tradição, lenda, Dante ou criação do jogo.

## 12. Definição de pronto (para qualquer tarefa)

- [ ] Testes novos cobrem o comportamento pedido e passam no modo sem tela.
- [ ] Nenhum teste existente quebrou.
- [ ] Nenhum número fixo no código.
- [ ] Tipagem estática em todo código novo.
- [ ] Especificação e backlog atualizados se a tarefa revelou algo.
