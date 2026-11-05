# Andamento e continuidade

Onde estamos agora. Parte da memória do projeto (`docs/memory/README.md`). Atualize ao fim de cada tarefa.

## Onde estamos

- **Marco atual:** M1 · Protótipo de trecho (`docs/backlog/m1.md`, tarefas T18 a T32). Perguntas de design respondidas por Alan em 04/11/2026 (D-121 a D-126); backlog aprovado e com merge (PR #24, D-127). T18 aprovada (PR #25, D-130). T19 aprovada (PR #26, D-131). T20 aprovada (PR #27, D-133). T21 aprovada (PR #28, D-135). T22 aprovada (PR #29, D-138). T23 aprovada (PR #30, D-142). T24 aprovada (PR #31, D-145). T25 aprovada (PR #32, D-147). T26 aprovada (PR #33, D-148). T27 aprovada (PR #34, D-150); teste pelo botão "Caminhada (teste)" da arena (D-149). T28 aprovada (PR #35, D-154). T29 aprovada (PR #36, D-157). T30 aprovada (PR #37, D-160). Próxima: T31 (simulador do trecho e recalibração das metas). O jogo agora abre no título; o trecho inteiro é jogável no celular. Alan testou no celular a caminhada, provisões, mini-mapa e Tentação (04/11/2026) e pediu caminhada interativa: fica para o M2 (D-158, D-159).
- **Concluídas:** T00 a T14 (PRs #1 a #14, todos com merge na `main`); continuidade (PR #15); arte do piloto e memória do projeto (PR #16); T15 · tela de combate com arte provisória (PR #17, aprovado por Alan em 03/11/2026); T16 · auréola no motor com a arte piloto de São Jorge (PR #18, aprovado por Alan em 03/11/2026).
- **Jogo no navegador:** https://alnsouza90.github.io/Ad-Inferos---RPG/ (publicado a cada merge na `main`).
- **Concluído também:** complemento da T16 com a arte nova de Jorge (PR #19, aprovado em 04/11/2026, D-204, D-205).
- **T17 aceita (04/11/2026, D-212):** APK corrigido instalado e aberto no Redmi. **Todas as tarefas do M0 (T00 a T17) feitas.** Próximo passo: fechar o M0 (metas de simulação pendentes já adiadas para o M1, D-113) e criar `docs/backlog/m1.md` com Alan, incluindo a caminhada entre nós (D-207).
- Histórico da T17: reprovada no celular por Alan (04/11/2026): a arena abriu certa, mas a tela de combate saiu deslocada (palco com tamanho 0 dentro da arena). Correção aprovada (PR #21, D-120); falta o novo teste no Redmi. T17 (PR #20, D-118). APK em https://github.com/alnsouza90/Ad-Inferos---RPG/releases/tag/teste-android. Depois: fechar o M0 e criar `docs/backlog/m1.md`. T17 · Arena de teste (seletor de encontro e semente) e APK Android. Teste da T16 no celular (04/11/2026): Jorge aparece com auréola e parece nítido, mas **pequeno** (o navegador não deixa tela cheia); auréola ao vivo não testada (sem desolação no combate); combate segue funcionando.
- **Adiado para o M1 (decisão de Alan, 03/11/2026):** recalibrar as metas "vitória da heurística em combate difícil" e "Noite Escura na expedição longa" (`docs/balance/sim-reports/2026-11-03-m0-t14.md`).

## Como trabalhamos

- **Alan** é o responsável: aprova design, números e cada PR. Não é técnico. Falar sempre em português, em linguagem simples, e pedir decisões de forma clara.
- **Uma tarefa = um PR.** Antes de programar, plano curto; pergunta só quando a spec é ambígua (`CLAUDE.md` §9). Ao terminar: resumo do que mudou, testes e o que falta de Alan.
- **Depois de abrir o PR:** acompanhar o PR (CI e comentários) até o merge. Merge só depois do "aprovado" de Alan.
- **Depois do merge:** recriar a branch de trabalho a partir da `main` atualizada.
- **Números de balanceamento:** só nos CSVs, só com aprovação de Alan; rodar importador, testes e simulador.

## Ambiente

- **CI do GitHub** (`.github/workflows/tests.yml`): baixa o Godot 4.7.2 oficial, analisa os scripts, roda o GUT, falha se algum teste for ignorado e confere se `game/data` está em dia com os CSVs.
- **Sessões 2 e 3 (03 e 04/11/2026):** a compilação do Godot foi negada pelas permissões do ambiente; a T15 foi verificada pelo CI e pelo analisador `gdtoolkit` (só sintaxe). Os `.gd.uid` dos scripts novos não foram gerados (o editor cria ao abrir).
- **Sessões na nuvem:** não há Godot pré-instalado e downloads do GitHub são bloqueados. A saída usada foi compilar o Godot 4.7.2 do código-fonte (tag `4.7.2-stable`, `scons platform=linuxbsd target=editor x11=no wayland=no vulkan=no opengl3=no alsa=no pulseaudio=no dbus=no speechd=no fontconfig=no udev=no sdl=no accesskit=no`), cerca de 25 min em segundo plano. Sem isso, os testes rodam pelo CI ao enviar o código.
- **Comandos:** `CLAUDE.md` §5.

## Decisões de regra tomadas com Alan (resumo)

Registradas também no backlog de cada tarefa.

| Tarefa | Decisão |
| --- | --- |
| T03 | Janela de levantar: o resto da rodada da queda e a rodada seguinte |
| T04 | Só o Fervor extra que entra conta para o limite de +2 |
| T05 | `chosen_enemy_slots(n)` aceita menos posições se houver menos inimigos; provisão só em santo de pé; Atordoado só pode passar a vez |
| T07 | Santo Atordoado gasta o atordoamento ao passar e fica imune até o fim da rodada seguinte |
| T10 | Bônus de afinidade só para membros; Clausura só contra inimigos e ambiente, com Bento de pé; Pequeno Caminho não vale para o milagre e não é gasto por cura de custo 0 |
| T14 | Família A +20% de vida e dano; Sangramento do Moscardo 2; Corrupção da Sombra 3; Toque da Sombra 10 e Lamento 8 de desolação; Vigília −20 |

## Arte

- Arte só entra a partir da T16 e do piloto de São Jorge. A T15 usa retângulos.
- Originais ficam com Alan (Google Drive); ele envia pelo chat só o que a tarefa precisa; o agente processa conforme `docs/art/asset-pipeline.md`.
- Atenção à cota de 1 GB do Git LFS gratuito: só versões de jogo no repositório.
- Poses de ataque, golpe recebido e queda: não geradas; **animação feita no motor** a partir de uma imagem por estado (ADR-0007, aprovado por Alan em 03/11/2026).
- **Piloto de São Jorge recebido (03/11/2026)**, originais em `art_source/`:
  - `characters/saints/saint_george/`: corpo padrão (`_body_idle_v01`, **só 343×512**: pedir versão maior a Alan antes da arte final), corpo em Noite Escura e em Consolação (848×1264, usados como pose própria do estado), retrato (896×1200).
  - `vfx/halo/`: disco da auréola e raios (1024×1024).
  - A imagem de Consolação tem um brilho claro atrás da cabeça; conferir no motor se ele briga com a auréola (a Direção de Arte pede imagens sem auréola).
  - Corpo nos três estados e auréola processados na T16 (`game/assets/`, `tools/art/process_art.py`).
  - **Arte nova (04/11/2026, D-204):** `_body_idle_v02` (848×1264, substitui a v01 pequena), `_body_attack_v01`, `_body_hit_v01`, `_body_fall_v01`, `_portrait_v02` e `_body_rig_neutral_v01` (guardada para o recorte do M2). Todas processadas, menos a neutra.
- **Folhas de produção de Alan (04/11/2026, D-206, D-213):** `docs/art/prompts-saints.md`, `docs/art/prompts-environments.md` e `docs/art/prompts-splash.md` (telas de passagem); consultar nas etapas de arte e animação (M2). Divergências de design em `open-questions.md`.
- **Arte do piloto em combate recebida (03/11/2026)**, originais em `art_source/`: os 7 inimigos da Família A (`characters/enemies/`), Bento e Teresinha em padrão, Noite Escura e Consolação, cenário do Círculo 2 trecho 1 (fundo e frente) e redemoinhos do Vendaval (`vfx/hazards/`). Pendências em `open-questions.md`.
