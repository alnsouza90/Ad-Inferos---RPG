# Lições técnicas

Armadilhas que já custaram tempo. Ler antes de mexer nas áreas citadas.

## Godot e GDScript

- O Godot tem um enum global `Side`; uma variável `var side: Side` numa classe sua dá erro confuso de tipo. Por isso o lado do combatente se chama `Team`.
- O operador ternário perde o tipo da lista: `var x: Array[StringName] = a if c else [] as Array[StringName]` dá "Trying to assign an array of type Array" na execução. Use `if` com atribuição.
- `set_anchors_preset(PRESET_FULL_RECT)` **não muda o tamanho** de um Control criado em código (fica 0): use `set_anchors_and_offsets_preset`. Na T17 a tela de combate criada pela arena ficou com tamanho 0 e o palco saiu deslocado no celular; os testes não pegaram porque só a cena inicial (de arquivo `.tscn`) tinha tamanho certo. Teste novo confere tamanho e centro.
- Nomes de constantes repetidos na mesma classe só aparecem como "Could not parse global class": rode `godot --headless --path game --check-only -s res://arquivo.gd` para ver o erro real.
- `ResourceSaver` gera ids internos novos a cada gravação: o importador só regrava `.tres` cujo conteúdo mudou (`ResourceSnapshot`), para não sujar o git.
- Referência circular entre `RefCounted` vaza memória: o motor de condições guarda o `BattleState` por `weakref`.
- CSV dentro de `res://` é importado como tradução: pastas de saída levam `.gdignore`.

- `Array[StringName].sort()` **não** segue a ordem alfabética (compara outra coisa que não o texto). Para ordem estável de IDs, use `sort_custom` comparando `str(a) < str(b)` (T25).

- A verificação de scripts do CI (`--check-only -s arquivo.gd`) **não conhece os nomes dos autoloads**: `EventBus.algo` dá "Identifier not found". Acesse autoloads por caminho (`get_node("/root/EventBus")`) (T26).

- `JSON.parse_string` com texto inválido imprime um erro do motor, que o GUT conta como falha ("Unexpected Errors"). Para dados que podem estar estragados (saves), use `JSON.new().parse(texto)` e confira o código (T26).
- Números lidos de JSON voltam como float: ao reconstruir um estado salvo, regenere as partes guardadas como dicionário a partir das classes (`LegMap.to_dict()`), senão a comparação de texto acusa diferença (T26).

## GUT e CI

- O GUT **ignora em silêncio** um script de teste com erro de sintaxe e ainda diz "All tests passed". O CI falha se aparecer "Ignoring script", "Parse Error" ou "SCRIPT ERROR".
- Testes nunca dependem de `game/data`; usam `tests/helpers/combat_fixture.gd`. Testes com dados reais leem os CSVs pelo importador (`tests/helpers/real_data.gd`).

## Claude Code

- A saída de um gancho `SessionStart` com mais de poucos KB chega ao agente **cortada** (só uma prévia). O gancho deve ser curto e mandar ler os arquivos com a ferramenta de leitura.

## Dados

- Antes de criar uma constante nova, procure em `constants.csv`: na T20 quase entrou `map_generation_attempts`, mas `map_generation_retries` já existia.
- Sem Godot local, `.tres` gerados podem ser escritos à mão no formato do importador (dicionários com chaves em ordem alfabética): a conferência do CI (`--check`) compara o **conteúdo** (`ResourceSnapshot`), não o texto.

- Efeito com `const=`: a constante dá só o tamanho; o sinal vem do `amount` da planilha (D-317). Na T22, a Água Benta aumentava a desolação porque o sinal se perdia.

## Git e ambiente

- Na nuvem, as imagens do Git LFS chegam como ponteiros (o Pillow diz "cannot identify image file"): rode `git lfs pull --include="art_source/<pasta>/**"` antes de processar arte (T27).

- Na nuvem, `pip install "gdtoolkit==4.*"` dá o `gdparse`, que confere a sintaxe dos scripts sem o Godot (não pega erro de tipo).

- No `.gitignore`, uma regra com barra no meio (`tools/out/`) vale só a partir da raiz; para `game/tools/out/` é preciso escrever o caminho.
- Godot compilado na nuvem (D-161): o binário fica em `<scratchpad>/godot/src/bin/godot.linuxbsd.editor.x86_64` (some com a sessão); ligar em `~/.local/bin/godot` e rodar `git lfs pull` e `godot --headless --path game --import` antes dos testes. O import cria os `.import` e `.gd.uid` que faltavam; o repositório já versiona os dois tipos, então eles entram no commit (05/11/2026).
- Nunca usar `git push -f`: é bloqueado pelas permissões, com razão.
- Na nuvem, downloads de `github.com` são bloqueados e `git clone` funciona: o Godot é compilado do código-fonte (comando em `progress.md`).
- Depois do merge de um PR, recriar a branch de trabalho a partir da `main` (`git fetch origin main && git checkout -B <branch> origin/main`).
