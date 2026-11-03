# Lições técnicas

Armadilhas que já custaram tempo. Ler antes de mexer nas áreas citadas.

## Godot e GDScript

- O Godot tem um enum global `Side`; uma variável `var side: Side` numa classe sua dá erro confuso de tipo. Por isso o lado do combatente se chama `Team`.
- Nomes de constantes repetidos na mesma classe só aparecem como "Could not parse global class": rode `godot --headless --path game --check-only -s res://arquivo.gd` para ver o erro real.
- `ResourceSaver` gera ids internos novos a cada gravação: o importador só regrava `.tres` cujo conteúdo mudou (`ResourceSnapshot`), para não sujar o git.
- Referência circular entre `RefCounted` vaza memória: o motor de condições guarda o `BattleState` por `weakref`.
- CSV dentro de `res://` é importado como tradução: pastas de saída levam `.gdignore`.

## GUT e CI

- O GUT **ignora em silêncio** um script de teste com erro de sintaxe e ainda diz "All tests passed". O CI falha se aparecer "Ignoring script", "Parse Error" ou "SCRIPT ERROR".
- Testes nunca dependem de `game/data`; usam `tests/helpers/combat_fixture.gd`. Testes com dados reais leem os CSVs pelo importador (`tests/helpers/real_data.gd`).

## Claude Code

- A saída de um gancho `SessionStart` com mais de poucos KB chega ao agente **cortada** (só uma prévia). O gancho deve ser curto e mandar ler os arquivos com a ferramenta de leitura.

## Git e ambiente

- No `.gitignore`, uma regra com barra no meio (`tools/out/`) vale só a partir da raiz; para `game/tools/out/` é preciso escrever o caminho.
- Nunca usar `git push -f`: é bloqueado pelas permissões, com razão.
- Na nuvem, downloads de `github.com` são bloqueados e `git clone` funciona: o Godot é compilado do código-fonte (comando em `progress.md`).
- Depois do merge de um PR, recriar a branch de trabalho a partir da `main` (`git fetch origin main && git checkout -B <branch> origin/main`).
