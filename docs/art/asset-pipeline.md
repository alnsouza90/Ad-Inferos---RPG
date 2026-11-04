# Pipeline técnico de assets

Versão 1.0 · base: Direção de Arte v1.1 ("Padrões técnicos", "Auréola") · ADR-0007 e ADR-0008

Este documento diz **como** uma imagem gerada vira um asset do jogo. **O que** gerar (estilo, prompts) está em `docs/art/art-direction.md` e nas folhas de produção de Alan:

- `docs/art/prompts-saints.md` — os 12 santos jogáveis: corpo padrão, rostos de Noite Escura e Consolação, retrato, poses de ataque, golpe e queda, pose neutra e folha de peças para o rig.
- `docs/art/prompts-splash.md` — telas de passagem dos 12 santos (milagre, Noite Escura e Consolação): o santo sozinho em meio corpo; o motor monta a cena (raios, auréola, nome, interface), como as telas de virtude e de aflição de Darkest Dungeon (D-210).
- `docs/art/prompts-environments.md` — cenários em camadas para parallax (`_ref`, `_back`, `_mid`, `_front`) de cada trecho e chefe dos 9 círculos, almas, partículas, Pouso, Vigília, chegada, mapa de escolha dos círculos e extras.

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
| Rig (`rig_base`, `rig_parts`) | PNG RGBA | Matriz 2048 × 3072 / 2048 × 2048 em `art_source/`; peças na escala do idle | `assets/characters/saints/<id>/rig/` |
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

## 7. Animação (pendente do piloto, ADR-0007)

Primeiro teste: poses estáticas (idle, ataque, golpe recebido, queda) trocadas com pequenos tremores e deslocamentos por `Tween`. Se ficar amador, testar recortes com `Skeleton2D` para movimentos simples. A decisão vira ADR e atualiza este documento.

A interface `CombatantView` (`architecture.md`) é a mesma nas duas abordagens, então o código de combate não muda.

## 8. Checklist de aceite de um asset

- [ ] Nome e pasta corretos.
- [ ] Fundo totalmente transparente, sem halo cinza nas bordas.
- [ ] Sem auréola, texto ou moldura desenhados na imagem.
- [ ] Tamanho e pivô do §4; pés alinhados à linha de chão no jogo.
- [ ] Legível em 1280 × 720 no celular (silhueta reconhecível em tamanho de combate).
- [ ] Coerente com a paleta e o traço da Direção de Arte.
- [ ] Original guardado em `art_source/` com versão.
- [ ] Figura sagrada respeita as regras de conteúdo.
