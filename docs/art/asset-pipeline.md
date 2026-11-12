# Pipeline técnico de assets

Versão 1.0 · base: Direção de Arte v1.1 ("Padrões técnicos", "Auréola") · ADR-0007 e ADR-0008

Este documento diz **como** uma imagem gerada vira um asset do jogo. **O que** gerar (estilo, prompts) está em `docs/art/art-direction.md` e nas folhas de produção de Alan:

- `docs/art/prompts-saints.md` — os 12 santos jogáveis: corpo padrão, rostos de Noite Escura e Consolação, retrato, poses de ataque, golpe e queda, pose neutra e folha de peças para o rig.
- `docs/art/prompts-splash.md` — telas de passagem dos 12 santos (milagre, Noite Escura e Consolação): o santo sozinho em meio corpo; o motor monta a cena (raios, auréola, nome, interface), como as telas de virtude e de aflição de Darkest Dungeon (D-210).
- `docs/art/prompts-environments.md` — cenários em camadas para parallax (`_ref`, `_back`, `_mid`, `_front`) de cada trecho e chefe dos 9 círculos, almas, partículas, Pouso, Vigília, chegada, mapa de escolha dos círculos e extras.
- `docs/art/prompts-enemies-v1.md` (v1.1) — inimigos comuns das famílias A, B e C e os 8 Pecados Encarnados: pose padrão, pose neutra do rig, ataque e defesa. Os Pecados seguem a decisão de conteúdo de 05/11/2026 (D-163) e têm prioridade sobre as descrições da Direção de Arte §6.
- `docs/art/prompts-elites-bosses-v1.md` — Guardiões de Dante (elites) e chefes de círculo, com as mesmas quatro imagens.

Os padrões abaixo são provisórios até o piloto com São Jorge. Onde as folhas de produção forem mais detalhadas (tamanhos, camadas, linha do chão), elas valem; divergências de design ficam em `docs/memory/open-questions.md`.

## 1. Fluxo

```text
Gerar (IA, fundo cinza-claro) → Escolher → Guardar original em art_source/
→ Remover fundo → Limpar bordas → Recortar e redimensionar → Nomear
→ Copiar para game/assets/ → Godot importa → Conferir no jogo (checklist §8)
```

- Quem gera, escolhe e aprova: o responsável.
- O agente pode automatizar remoção de fundo, recorte, redimensionamento e conferência com scripts em `tools/art/`, **sem nunca alterar** `art_source/`.

## 2. Pastas

```text
art_source/                         ← fora do Godot (contém .gdignore); originais e versões
  characters/saints/saint_george/   george_body_idle_v01.png ...
game/assets/
  characters/saints/<id>/body/  portrait/  rig/
  characters/enemies/  elites/  bosses/  guardians/  narrative/
  environments/village/hub/<edificio>/  village/interiors/<instalacao>/
  environments/camp/  environments/circles/circle_02/t1/ ...
  events/<círculo>/                 event_<id do evento>.png
  vfx/halo/  vfx/miracles/  vfx/impacts/  vfx/particles/  vfx/ground_markers/
  ui/icons/  ui/frames/
  fonts/
  audio/music/  audio/sfx/
```

## 3. Nomes

- Inglês, minúsculas e sublinhado: `categoria_nome_parte_variante.png`.
- O `art_id` em `enemies.csv` e o `id` do santo são o nome base.

| Tipo | Exemplo |
| --- | --- |
| Corpo de santo, pose | `saint_george_body_idle.png`, `saint_george_body_attack.png` |
| Rosto por estado | `saint_george_face_dark_night.png`, `saint_george_face_consolation.png` |
| Retrato | `saint_george_portrait.png` |
| Inimigo | `enemy_mud_devil_body_idle.png` |
| Fundo de combate | `env_circle_02_t1_back.png`, `..._mid.png`, `..._front.png` |
| Edifício da vila | `village_chapel_ext.png`; fundo `village_hub_background.png` |
| Ícone | `icon_cond_stun.png`, `icon_intent_attack.png` |
| Auréola | `vfx_halo_disk.png`, `vfx_halo_rays.png` |
| Ilustração de evento | `event_c02_temptation_wind_shelter.png` (`event_` + `id` do evento) |

Só os originais em `art_source/` têm sufixo de versão (`_v01`, `_v02`). Em `game/assets/` o nome é sempre o final.

## 4. Tamanhos

| Item | Formato | Tamanho de jogo | Pivô |
| --- | --- | --- | --- |
| Santo, corpo inteiro | PNG transparente 2:3 | 1024 × 1536 (figura ≈ 1200 px de altura) | Centro dos pés, 96 px acima da base |
| Inimigo comum | PNG 2:3 | 1024 × 1536 | Centro da base |
| Elite / chefe | PNG 2:3, 4:3 ou 1:1 | Até 2048 no lado maior | Centro da base |
| Retrato | PNG 3:4 | 768 × 1024 | — |
| Fundo de combate `_back` | PNG opaco | 2560 × 1080 | Parallax ≈ 20% |
| Fundo de combate `_mid` | PNG RGBA, bordas emendáveis | 2560 × 1080 | Chão a y ≈ 900 px (83%); parallax 100% |
| Fundo de combate `_front` | PNG RGBA | 3240 × 1080 | Parallax ≈ 130% |
| Rosto por estado (`face_*`) | PNG RGBA 1:1 | 1024 × 1024, reduzido à cabeça do idle (≈ 170 px) | Mesmo ângulo do idle |
| Tela de passagem (`splash_<id>_miracle`, `_dark_night`, `_consolation`) | PNG RGBA 4:5, meio corpo | 1024 × 1280 | `assets/characters/saints/<id>/splash/` |
| Quadros de animação (parado, andar, poses das ações) | Sprite sheet ou GIF (D-196) | Figura ≥ 1000 px no original; no jogo, na escala do `body_idle`, todos com a mesma linha do chão (§7) | `assets/characters/<grupo>/<id>/frames/` |
| Entrada da bifurcação (`prop_<círculo>_entry_*`) | PNG RGBA 2:3 | 1024 × 1536 | Base a 96 px da borda de baixo (linha dos pés) |
| Objeto do corredor (tenda, relicário fechado/aberto) | PNG RGBA 1:1 | 1536 × 1536 (tenda) / 1024 × 1024 (relicário, mesmo enquadramento nos dois) | Idem; `environments/circles/<círculo>/props/` e `environments/props/` |
| Ilustração de evento | PNG opaco 16:9 | 1920 × 1080 (recortada para preencher); o terço de baixo fica sob a caixa de texto | `assets/events/<círculo>/` |
| Ícone | PNG 1:1 | 256 × 256 (exibido a 64–96) | — |
| Auréola | PNG 1:1 | 512 × 512 | Centro |

## 5. Importação no Godot

- Texturas 2D: compressão **VRAM Compressed** (ETC2/ASTC) para personagens e fundos; **Lossless** para ícones e interface.
- Mipmaps desligados (jogo 2D sem zoom grande).
- Filtro linear; sem repetição.
- Cada santo com arte tem um `CombatantArt` em `scenes/battle/combatants/<id>_art.tres`: uma imagem de corpo por estado espiritual e o ponto da cabeça (`head_*`, frações da imagem) onde a auréola se prende. A `CombatantView` é montada em código e lê esse recurso (T16). Sem o recurso, o personagem continua um retângulo com nome.
- Tratamento automático: `python3 tools/art/process_art.py` (ADR-0011).
- No piloto (T16) as texturas usam a importação padrão do Godot (sem perda); a compressão VRAM fica para a T17, com o APK.

## 6. Auréola no motor (ADR-0008)

- Um `Sprite2D` com `vfx_halo_disk.png` atrás da cabeça, posicionado no `HaloAnchor`; os raios (`vfx_halo_rays.png`) em outro sprite, desligado por padrão.
- Shader `shaders/halo.gdshader` com parâmetros:

| Parâmetro | Normal | Desolação 75–99 | Noite Escura | Consolação |
| --- | --- | --- | --- | --- |
| `brightness` | 1.0 | 1.0 → 0.6 (linear) | 0.25 | 1.3 |
| `saturation` (do personagem) | 1.0 | 1.0 → 0.8 | 0.45 | 1.05 |
| `rays_visible` | não | não | não | sim (rotação lenta) |
| Rosto | padrão | padrão | `face_dark_night` | `face_consolation` |

- Poses de ação (`body_attack`, `body_hit`, `body_fall`) são opcionais no `CombatantArt`: quando existem, a animação troca para elas; são tratadas com a mesma escala da pose em pé (`tools/art/process_art.py`, tipo `pose`), para manter a proporção.
- No piloto, o rosto por estado vem da imagem de corpo inteiro do estado (`saint_george_body_dark_night`, `..._consolation`), não de um rosto separado.
- A auréola mostra **só o estado espiritual**; o Fervor fica na barra da equipe (Direção de Arte v1.1 prevalece sobre a tabela antiga da seção 12).
- Valores do shader ficam num Resource de apresentação (`scenes/battle/halo_settings.tres`), não em `docs/balance/`, porque não afetam regras.

## 6b. Repositório × Drive (D-245)

O repositório guarda só a arte que o jogo ou as ferramentas usam agora; o Drive "Art Source" é o arquivo de toda a arte aprovada. Mapa das pastas do Drive e das tarefas em que cada arte entra: `docs/art/drive-inventory.md`.

## 7. Animação (D-194; ADR-0007)

- **Personagens:** quadros desenhados para parado e andar (ciclos) e poses-chave para as ações (atacar, defender, golpe recebido, queda), entregues por Alan como sprite sheet ou GIF (D-196). O agente tira o fundo, alinha os pés numa mesma linha e escala e corta os quadros (`tools/art/`).
- **No motor:** a ligação entre as poses (deslizar até o alvo, câmera que aproxima, tremor, clarão, esticar e encolher), respiração e capa sutis; cenário, fundo, almas e milagres com tweens, partículas e shaders; troca de quadros quando indicada (ex.: relicário fechado e aberto).
- O esqueleto 2D foi testado com São Jorge e reprovado (D-195).
- **Ferramenta (T35):** `tools/art/process_frames.py` lê `tools/art/animation_clips.csv` (um clipe por linha: personagem, vídeo ou pose, quadro inicial e final, passo, ciclo ou não, mistura da emenda do ciclo, quadro do impacto, tratamento) e grava uma folha por clipe em `game/assets/characters/<grupo>/<id>/frames/<id>_<clipe>.webp` e o recurso `game/scenes/battle/combatants/<id>_frames.tres` (`CharacterFrames`). Tira o fundo cinza (também os buracos fechados entre véus e asas), põe os pés de todos os clipes no mesmo ponto pela imagem inicial de cada vídeo (a pose padrão) e mantém a escala do vídeo parado (90%). Poses desenhadas (Minos, D-229) são escaladas pela tela da pose parada desenhada, que tem o mesmo enquadramento. `--preview <pasta>` gera uma prancha com todos os quadros sobre a linha do chão, para conferir.
- **Por personagem** (`tools/art/animation_characters.csv`): tamanho ao lado dos santos (`display_scale`; chefes maiores, D-233) e alcance do ataque físico (`melee` desliza até o alvo, `ranged` acerta de longe, `throne` só inclina). Todos os quadros são clareados (gama 0,8, D-233). Tratamentos por clipe (somados com `+`): `smoke_dark` (fumaça de Asmodeu, D-227), `fade_left` (a borda cortada pelo vídeo some aos poucos), `light_wisps` e `veil_key` (rastros claros e véus semitransparentes de Vertigem). A borda de toda figura (3 px) é desmisturada do cinza, para não deixar contorno cinza sobre o fundo escuro do jogo (D-333). Coluna `speed`: velocidade dos clipes do personagem. Coluna `weight` (T59, D-353, D-366): peso do golpe, `light`, `medium`, `heavy` ou `colossal`; muda os tempos da frase do golpe, a parada no impacto, o recuo, o tremor e o empurrão da câmera (`scenes/battle/blow_weight.gd`).
- **Estilo de cada ação no combate** (D-233, `AnimationStyle`): vem do tipo de dano dos dados — `strike` é golpe físico (desliza), outro dano é magia (no lugar, luz até o alvo), sem dano no próprio lado é bênção (luz sobre o aliado).
- **Clipes:** santos têm `idle`, `walk`, `windup`, `strike`, `defend`, `hit`, `fall`; inimigos, elites e chefe não têm `walk`. Mudar um corte = editar o CSV e rodar a ferramenta de novo.
- **Folhas em WebP com perda** (qualidade 88): os quadros em PNG pesariam demais no Git LFS e no jogo no navegador (D-330).
- A interface `CombatantView` (`architecture.md`) continua a mesma; o código de combate não muda.
- Pedido completo de arte do M2: `docs/art/m2-art-request.md`.

## 8. Checklist de aceite de um asset

- [ ] Nome e pasta corretos.
- [ ] Fundo totalmente transparente, sem halo cinza nas bordas.
- [ ] Sem auréola, texto ou moldura desenhados na imagem.
- [ ] Tamanho e pivô do §4; pés alinhados à linha de chão no jogo.
- [ ] Legível em 1280 × 720 no celular (silhueta reconhecível em tamanho de combate).
- [ ] Coerente com a paleta e o traço da Direção de Arte.
- [ ] Original guardado em `art_source/` com versão.
- [ ] Figura sagrada respeita as regras de conteúdo.
