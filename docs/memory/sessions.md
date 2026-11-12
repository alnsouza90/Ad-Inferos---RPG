# Sessões do agente

Resumo curto de cada sessão. A mais recente no topo.

## Sessão 8 · 12/11/2026

- PR #60 (D-266) conferido (CI verde) e com merge, como Alan aprovou.
- Feito: T58 · Passo 1 do rumo do Fable (só documentos): D-267 a D-300 e D-350 a D-362 (uma decisão por resposta de `docs/fable/04-respostas-de-alan.md`), D-363 (numeração única); `open-questions.md`; backlog do M2 com T58 a T62 e a ordem do rumo; specs de desolação, expedição, vila, combate, narrativa, IA e telas marcadas; `art-direction.md` aponta para a Bíblia de Arte.
- Alan aprovou o PR #61 e pediu o GDD atualizado: GDD v1.2 (D-364, PR #62, com merge).
- Godot: pypi bloqueado na sessão; SCons rodado do código clonado do GitHub (D-365, lição em `lessons.md`).
- Feito: T37 · caminhada interativa (fase `PENDING`, `EngageNode`, `PassBy`, save versão 2, posição no corredor, corte seco), D-365.
- Próximo: Alan testa a caminhada no celular; depois T59.

## Sessão 6 · 10/11/2026

- Godot compilado em segundo plano (a compilação foi interrompida por um reinício e retomada; lição em `lessons.md`).
- Feito: T35 · ferramenta `tools/art/process_frames.py` + `animation_clips.csv`, `FrameClip`, `CharacterFrames`, `FramePlayer`, quadros no `CombatantView` (parado, andar, atacar com deslize, rastro e impacto, defender, golpe recebido, queda), `ImpactCamera` e a tela "Animações (teste)" na arena. Decisões D-231 (Alan: Minos parado do vídeo, ações pelas poses) e D-329 a D-331.
- Próximo: Alan testa no celular a tela "Animações (teste)"; depois T36.

## Sessão 5 · 05 a 10/11/2026

- Godot compilado em segundo plano pelo gancho (D-162).
- Feito: proposta do backlog do M2 (`docs/backlog/m2.md`, T33 a T57); decisões de Alan D-171 a D-182 (blocos, Santo Antão, recorte das partes pelo agente, Conselho no M3, sons, Prólogo, vila mínima, companhia e tela de novo santo, encontros, animação com esqueleto 2D, áudio, caminhada segurando o dedo).
- Depois: T33 (PR #42), T34 (PR #43), roteiro do Prólogo (PR #44); esqueleto 2D de Jorge testado e reprovado, trocado por quadros e poses-chave com GIFs do Meta AI (PR #45, D-194 a D-197, D-200); decisão do leito de morte e final único aplicada (D-198, D-199).
- Arte da prioridade 1 recebida; prévias do cenário montadas para Alan validar (PR #46 com merge).
- 06 a 10/11: ImagineArt conectado (D-221); animações no Wan 3, 480p, 150 créditos cada: santos (D-225), Minos, Vertigem, Asmodeu (D-226); fumaça de Asmodeu escurecida no tratamento (D-227); rabo de Minos reprovado em vídeo, ações de Minos por poses desenhadas de Alan (D-228 a D-230). Saldo do ImagineArt: 185. Google Drive "Art Source" como repositório de mídia (D-230).
- Próximo: T35 numa sessão nova (troca de pose no motor com os vídeos e poses em `art_source/characters/`).

## Sessão 4 · 04/11/2026

- Sem Godot no ambiente (compilação do código-fonte negada pelas permissões): testes pelo CI; sintaxe com `gdparse`. Arquivos do Git LFS baixados com `git lfs pull --include=...` antes de processar arte.
- Feitas: T27 · tela da caminhada e das bifurcações (D-148 a D-150, D-321); T28 · tela do evento narrativo (D-151 a D-154, D-322), com a ilustração de Alan; T29 · tela do Pouso (D-155 a D-157, D-323); T30 · fluxo completo (D-158, D-159, D-324).
- Alan testou no celular (04/11): caminhada, provisões, mini-mapa e Tentação ok; caminhada interativa, animação, tamanho e parallax ficam para o M2 (D-158).
- Godot compilado na sessão com a autorização de Alan (D-161) e preparado automaticamente nas próximas (D-162).
- T31 aprovada (D-163 a D-166, D-325); T32 aceita no Redmi (D-167); Moscardo sorteia entre 2 e 3 (D-168, D-326). **M1 concluído.**
- Plano de caça a exploits aprovado (D-170).
- Próximo: backlog do M2 com Alan, numa sessão nova.

## Sessão 3 · 04/11/2026

- Sem Godot no ambiente (compilação negada de novo pelas permissões): testes pelo CI; sintaxe conferida com `gdtoolkit` (`pip install "gdtoolkit==4.*"`, comando `gdparse`).
- Feitos: backlog do M1 (PR #24), T18 specs da caminhada (PR #25), T19 Lume e estado da expedição (PR #26), T20 gerador do trecho (PR #27), T21 controlador da expedição (PR #28), T22 provisões e preparação (PR #29, com a correção da Água Benta, D-317), T23 Tentação e virtudes (PR #30, "O abrigo do vento"), T24 Pouso (PR #31), T25 relíquias (PR #32).
- Decisões de Alan: D-121 a D-147 (caminhada e mini-mapa, rascunho da Tentação pelo agente, kit fixo de provisões, nó variável sem elite, metas D-113, Incenso revela mais uma camada, números do gerador).
- Estado: 354 testes passando. Estado: 400 testes. Próximo: **T26** (salvamento e retomada, `docs/backlog/m1.md`). Sem Godot local: escrever os `.tres` à mão no formato do importador (ver `lessons.md`).

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
