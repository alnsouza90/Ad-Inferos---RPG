# Sessões do agente

Resumo curto de cada sessão. A mais recente no topo.

## Sessão 10 (14 e 15/11/2026) · T65

- Commits de arte e memória do ramo `ccr-22a5456d-tz0r3e` trazidos para o ramo da T65 (avanço direto, sem conflito).
- Godot: o oficial 4.7.2 baixou do GitHub nesta sessão (o download funcionou); serve para os testes e para a captura real da tela (`xvfb-run`), sem esperar a compilação.
- Feito: T65 (D-381 a D-387). Alan revisou várias rodadas; arte gerada no PixelLab com a lista liberada por ele (1.709 → 1.455 gerações). PR da T65 aberto.
- Lição: conferir os shaders no Godot 4 (o COLOR do fragment já traz a textura); a cor ao quadrado escureceu tudo (D-382, `lessons.md`).
- Pendências novas: Jorge e Teresinha sem clipes de ação em pixel; cinco inimigos ainda pintados; lamparina e ícones em pixel (`open-questions.md`).

## Sessão 8 · 12/11/2026

- PR #60 (D-266) conferido (CI verde) e com merge, como Alan aprovou.
- Feito: T58 · Passo 1 do rumo do Fable (só documentos): D-267 a D-300 e D-350 a D-362 (uma decisão por resposta de `docs/fable/04-respostas-de-alan.md`), D-363 (numeração única); `open-questions.md`; backlog do M2 com T58 a T62 e a ordem do rumo; specs de desolação, expedição, vila, combate, narrativa, IA e telas marcadas; `art-direction.md` aponta para a Bíblia de Arte.
- Alan aprovou o PR #61 e pediu o GDD atualizado: GDD v1.2 (D-364, PR #62, com merge).
- Godot: pypi bloqueado na sessão; SCons rodado do código clonado do GitHub (D-365, lição em `lessons.md`).
- Feito: T37 · caminhada interativa (fase `PENDING`, `EngageNode`, `PassBy`, save versão 2, posição no corredor, corte seco), D-365.
- Alan aprovou a T37 (PR #63, com merge).
- Feito: T59 · peso do golpe (seis gestos com interruptores, quatro pesos), D-366.
- Próximo: Alan testa os gestos no APK; depois T60.

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

## Consultoria de direção (11 a 14/11/2026)

- Consultor convidado (Fable), só documentos, tudo em `docs/fable/`. Nenhum código, dado ou teste alterado.
- Etapas: primeira análise e propostas; game design (G-1 a G-7 e cortes); arte e Bíblia de Arte; animação; rumo final (`00-rumo.md`).
- Mudança de rumo no fim: **arte em pixel pelo PixelLab** (D-367). Piloto gerado e aprovado (D-368); guia e plano em `guia-pixellab.md` e `06-rumo-pixel.md`.
- Decisões de Alan: D-367 a D-369 (as anteriores já estavam em D-264 a D-300 e D-350 a D-362); encaixe na `main`: D-370. Gasto no PixelLab até o fim da sessão: ver `06-rumo-pixel.md` §2.
- Próxima sessão (agente de implementação): merge da T59, depois T63, T64, T65 e T60 (`backlog/m2.md`).

## Sessão 9 (14/11/2026) · rumo em pixel na `main`, T63, T64 e cenários do Círculo 2

- PRs com merge, todos com o CI verde e o "aprovado" de Alan: #64 (T59, D-371), #65 (rumo em pixel do consultor, D-373), #66 (T63, ADR-0013, D-372), #67 (T64, entrada dos clipes do PixelLab, D-374 a D-376).
- Arte: Asmodeu, Vertigem e Minos da galeria de Alan entraram pela ferramenta; fontes **Jacquard 12** (títulos) e **Jersey 10** (texto) escolhidas (D-377); peças do fundo aprovadas: chão, arcada, pináculo, muro (céu e montanhas reprovados, D-378); **cenários pintados do Círculo 2 convertidos para pixel** (trecho 1, trechos 2 e 3, chefe, camadas comuns), aprovados, com o **filtro B do círculo** no motor (D-379, D-380). Originais em `art_source/environments/circles/circle_02/pixel/`.
- PixelLab: 1.896 → 1.749 gerações (147, das quais cerca de 47 do Minos gerado por Alan no site).
- Godot local: compila sozinho pelo gancho; numa sessão retomada a compilação morre e precisa de nova chamada (`lessons.md`).
- Próxima sessão: **T65** (tela de 960 × 540), no ramo novo a partir da `main` (os commits de arte e memória desta sessão estão no ramo de trabalho e entram no PR da T65).

## Sessão 10 (15/11/2026) · T65, T60, T38, T61, T62 e T39

- PRs com merge, todos com o CI verde e o "aprovado" de Alan: #68 (T65, tela de 960 × 540, D-381 a D-390), #69 (T60, luta em poses, D-391, D-392), #70 (T38, `bosses.md`, D-393, D-394), #71 (T61 parte 1, simulação das regras novas, D-395 a D-397), #72 (T62, regras em vigor e save versão 3, D-398 a D-400), #73 (T39, encontros do Círculo 2, Vendaval, Firmar o pé e Firmeza, D-401 a D-403).
- Godot oficial 4.7.2 baixado do GitHub em `~/.local/bin/godot` (desenha com `xvfb-run`; ver `lessons.md`).
- Números de Alan: fim de combate 20 + 3 por rodada desde a 1ª (D-396); dom levanta Caído com 30% (D-399); a Clausura não segura o Vendaval (D-402).
- Pendências novas: ícone, efeito no motor e talvez elemento do PixelLab para o Vendaval (T44); aviso na intenção e fio de ouro de Interceder (T44); medir de novo na T42 a Noite Escura e os difíceis do Círculo 2.
- Próxima sessão: **T40** (elites Minos e Vertigem com o Encanto, nó variável completo), num ramo novo a partir da `main`.
