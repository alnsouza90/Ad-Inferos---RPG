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

- Classe nova com `class_name` só é reconhecida por outros scripts (e pelo `--check-only`) depois de `godot --headless --path game --import`, que atualiza o cache de classes globais; sem isso aparece "Could not find type" (05/11/2026).
- O Godot compilado na nuvem não desenha (sem OpenGL). Para mostrar uma animação a Alan, um script do Godot grava a posição de cada peça ou quadro em JSON e um script Python monta um GIF (05/11/2026).

## GUT e CI

- `Array[StringName].sort()` **não** ordena em ordem alfabética (compara a identidade do nome); ordene como `String` e converta depois (T35).
- Nos testes de animação, `wait_seconds` com uma fração do tempo do movimento é instável no modo sem tela; use `wait_until` com uma condição (T35).
- O GUT **ignora em silêncio** um script de teste com erro de sintaxe e ainda diz "All tests passed". O CI falha se aparecer "Ignoring script", "Parse Error" ou "SCRIPT ERROR".
- Testes nunca dependem de `game/data`; usam `tests/helpers/combat_fixture.gd`. Testes com dados reais leem os CSVs pelo importador (`tests/helpers/real_data.gd`).

## Claude Code

- A saída de um gancho `SessionStart` com mais de poucos KB chega ao agente **cortada** (só uma prévia). O gancho deve ser curto e mandar ler os arquivos com a ferramenta de leitura.

- **Drive: arquivo pequeno que o `download_file_content` devolve só no texto (D-346).** O conteúdo em base64 fica gravado no registro da sessão (`~/.claude/projects/<projeto>/<sessão>.jsonl`); basta procurar pelo id do arquivo nesse registro com Python e decodificar. Arquivos grandes vão para `tool-results/*.txt` (JSON com `content` em base64).

- **Captura real da tela do jogo (T36).** O Godot da sessão é compilado sem vídeo (`opengl3=no`). Para ver a tela de verdade: baixar o Godot oficial da mesma versão (`Godot_v4.7.2-stable_linux.x86_64.zip`, no rascunho) e rodar `xvfb-run -a -s "-screen 0 1920x1080x24" <godot> --path game --rendering-driver opengl3 -s res://<script>.gd`; o script põe a tela na raiz, espera alguns quadros e salva `root.get_texture().get_image()`. O Mesa (llvmpipe) desenha devagar: o tempo de uma sequência capturada não é o do jogo. Não commitar os scripts de captura.
- **Teste de animação com velocidade alta (FAST) e quadro lento.** Num quadro lento da suíte inteira o tween pula do preparo direto para o parado e o golpe nunca aparece no `clip_id()`. Siga os clipes pelo sinal `FramePlayer.clip_started`, não olhando o clipe a cada quadro.

- **TextureRect com textura: defina `expand_mode` antes da `texture`.** Com a textura já posta no modo padrão, o tamanho mínimo vira o da textura e o `size` menor é ignorado (moldura do retrato saiu com 525 × 512, D-348).

## Arte e animação

- Esqueleto 2D a partir de uma imagem parada gerada por IA (peças recortadas e giradas) ficou "boneco articulado" e foi reprovado (D-195). Para o estilo Darkest Dungeon que Alan quer, use poses desenhadas (quadros e poses-chave) e deixe o motor fazer a ligação entre elas (D-194).

- Ao endurecer a limpeza de fundo para um personagem, refaça e confira **todos**: as regras de "buraco" e de "pontos do cinza exato" (D-333) furaram a cauda de Minos e o rosto de Vertigem, pintados no mesmo cinza do fundo. Conferir sempre sobre o fundo escuro do jogo, não sobre verde (T35).

### Animação de personagens: o que custou tempo na T35 e como fazer de primeira

Fluxo que funciona (`tools/art/process_frames.py` + `animation_clips.csv` + `animation_characters.csv`, prévia em Python porque o Godot da nuvem não desenha):

1. **Antes de recortar, confira se a figura cabe no quadro.** Vídeo ou desenho em que a personagem, a fumaça ou a magia encostam na borda ficam cortados em linha reta no jogo, e Alan reprova (fumaça de Asmodeu, sombras da Vertigem). Meça cada quadro (pixels opacos nas colunas da borda) e **não use quadro cortado** sem perguntar (D-247). Se faltar um quadro inteiro, peça a Alan versão com margem em volta.
2. **Fundo cinza de IA é a mesma cor de partes do desenho** (branco dos olhos, rosto da Vertigem, barriga de Minos). Regras que tiram todo pixel do cinza exato apagam olhos e furam corpos. Para desenhos limpos: `protect_all` (só manchas grandes saem, tamanho proporcional à largura) + bolsões fechados com ≥25% de pixels no cinza exato (`pockets`). Para vídeo borrado: `veil_key`/`light_wisps`/`protect_head`. Para figura cujo corpo é cinza: `border_only` (D-337, D-341).
3. **Sempre conferir de perto** (rosto, mãos, cabelo, fumaça) sobre o fundo escuro do jogo (23/18/20), em tamanho grande, antes de mandar a prévia. Alan nota: rosto escuro, fundo entre os dedos, crescentes claros no cabelo.
4. **Mande prévia antes de implementar efeitos** e antes de abrir PR: GIF no layout da tela "Animações (teste)" (`vertigo_preview.py`/`breath_preview.py` no scratchpad, mesmos tamanhos do motor). Alan escolhe por modelo (G1, E1, B2…) (D-235).
5. **Stop motion (GIFs do Meta AI):** 5 desenhos por segundo com 2 quadros de fusão (`tween=2`); listas `a.jpg|b.gif#4` misturam GIF e imagem solta, todos levados à tela do desenho de referência (`STILL_REFERENCE`). Figura limitada a 640 px (`MAX_FIGURE_PX`) para as folhas não pesarem.
6. **Folhas novas `.webp`**: o primeiro `--import` cria o `.import` com `compress/mode=0` e qualidade 0.7; trocar para `compress/mode=1` e `lossy_quality=0.88` como as outras e importar de novo.
7. **Escala e lado:** bosses maiores (`display_scale`), estilo de ataque por personagem (melee/ranged/throne), quem age vai para a frente (`_to_front`). Magias de longe não deslizam até o alvo (D-233, D-240).
8. **O recorte de desenhos grandes é lento** (~2 min por personagem): rodar em segundo plano e, enquanto isso, preparar testes e o script de prévia.
9. **Drive:** `download_file_content` salva o arquivo grande num `.txt` JSON com base64; decodificar com Python. Envio ao Drive passa só até ~3 MB.
10. **Git:** `git checkout <commit> --` **sem caminho** troca a branch inteira (HEAD solto) e deixa arquivos LFS como ponteiros; para recuperar um arquivo use sempre `git checkout <commit> -- <caminho>`, e depois de voltar rode `git lfs pull`.
11. **Pixels piscando em vídeo do Wan 3:** meça antes de mexer no recorte (picos de brilho de um quadro para o outro, sobre o fundo escuro): no Asmodeu o piscar vinha do vídeo, e a cura foi a média temporal (`temporal=N`), não o recorte (D-342).
12. **Nunca cortar a saída da ferramenta com `| head`:** o processo morre no meio e deixa `.tres` velho com folha nova (quadros desalinhados). Redirecione para arquivo e leia o fim.
13. **Vídeo que pisca:** a média temporal borra (reprovada, D-253) e a média só no que muda pouco não ajuda. O que funciona: segurar poucos quadros nítidos do próprio vídeo e fundir entre eles (`keys=`, `hold=`, `tween=`, D-344). O Meta AI não serve para poses de personagem complexo (perde a fidelidade e gera vídeo, D-254).

## Dados

- Antes de criar uma constante nova, procure em `constants.csv`: na T20 quase entrou `map_generation_attempts`, mas `map_generation_retries` já existia.
- Sem Godot local, `.tres` gerados podem ser escritos à mão no formato do importador (dicionários com chaves em ordem alfabética): a conferência do CI (`--check`) compara o **conteúdo** (`ResourceSnapshot`), não o texto.

- Efeito com `const=`: a constante dá só o tamanho; o sinal vem do `amount` da planilha (D-317). Na T22, a Água Benta aumentava a desolação porque o sinal se perdia.

## Git e ambiente

- Na nuvem, as imagens do Git LFS chegam como ponteiros (o Pillow diz "cannot identify image file"): rode `git lfs pull --include="art_source/<pasta>/**"` antes de processar arte (T27).

- Na nuvem, `pip install "gdtoolkit==4.*"` dá o `gdparse`, que confere a sintaxe dos scripts sem o Godot (não pega erro de tipo).

- No `.gitignore`, uma regra com barra no meio (`tools/out/`) vale só a partir da raiz; para `game/tools/out/` é preciso escrever o caminho.
- Godot compilado na nuvem (D-161): o binário fica em `<scratchpad>/godot/src/bin/godot.linuxbsd.editor.x86_64` (some com a sessão); ligar em `~/.local/bin/godot` e rodar `git lfs pull` e `godot --headless --path game --import` antes dos testes. O import cria os `.import` e `.gd.uid` que faltavam; o repositório já versiona os dois tipos, então eles entram no commit (05/11/2026).
- Se o ambiente reiniciar no meio da compilação do Godot, sobra a trava `~/.cache/godot-4.7.2/building` e o `setup_godot.sh` diz "em andamento" para sempre (o log para sem `PRONTO` nem `FALHOU`). Conferir com `pgrep -f scons`; se não houver processo, apagar a trava e rodar o script de novo: a compilação continua de onde parou (05/11/2026).
- Nunca usar `git push -f`: é bloqueado pelas permissões, com razão.
- Na nuvem, downloads de `github.com` são bloqueados e `git clone` funciona: o Godot é compilado do código-fonte (comando em `progress.md`).
- Depois do merge de um PR, recriar a branch de trabalho a partir da `main` (`git fetch origin main && git checkout -B <branch> origin/main`).
