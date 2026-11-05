# Pedido de arte do M2

Versão 1.0 · 05/11/2026 · tarefa T34 (`docs/backlog/m2.md`) · decisões D-159, D-176, D-180, D-187

Lista de **tudo o que o M2 precisa de imagem**, na ordem em que o código vai usar. Quase tudo já tem prompt pronto nas folhas de Alan (`prompts-saints.md`, `prompts-enemies-v1.md`, `prompts-elites-bosses-v1.md`, `prompts-environments.md`, `prompts-splash.md`) ou na Direção de Arte (`art-direction.md`); aqui só se aponta onde. O que **não** tinha prompt, as entradas da bifurcação e os objetos do corredor, ganhou prompt novo no fim deste documento (§6).

Referência de clima, tamanho e composição: `docs/art/reference/` (D-187).

**Para gerar:** `docs/art/m2-art-prompts.md` junta todos os prompts deste pedido, já copiados das folhas e na ordem de prioridade, com uma caixa para marcar cada imagem aprovada (pedido de Alan, 05/11/2026).

## 1. Como entregar

- Mandar pelo chat (até 20 por vez), com o nome da tabela. O agente guarda o original em `art_source/` com versão (`_v01`) e trata a imagem (`tools/art/`, `asset-pipeline.md`).
- Fundo cinza-claro liso (ou transparente) em tudo que não é cenário de fundo.
- Sem auréola, texto, moldura ou vinheta desenhados.
- O código **não espera** a arte: usa a provisória e troca quando a final chega. Por isso a ordem abaixo é a ordem de prioridade, não uma trava.

## 2. Animação dos personagens: quadros e poses (D-194)

O esqueleto 2D foi testado e reprovado (D-195). Cada personagem passa a ser animado com **quadros desenhados** e **poses-chave**, e o motor faz a ligação entre eles (deslizar até o alvo, câmera, tremor, clarão, esticar e encolher, partículas). **Formato escolhido (D-197):** GIFs gerados no Meta AI a partir da imagem padrão, com os prompts prontos de `docs/art/animation-prompts.md` (santos: parado, andar e ações; inimigos, elites e chefe: parado e ações). O que importa:

- **Mesma escala, mesma câmera e mesma linha do chão em todos os clipes** do personagem: é o que impede a figura de "pular" na troca de pose.
- Vista de lado, santos olhando para a **direita** e inimigos para a **esquerda**; fundo cinza-claro liso; sem auréola, texto ou sombra no chão.
- Figura com **pelo menos 1000 px de altura** no quadro (o jogo mostra cerca de metade da altura da tela).
- **Clipes por personagem:**
  - **parado** em ciclo, com 6 a 9 quadros (o último emenda no primeiro), como o GIF de exemplo com a capa ao vento;
  - **andar** em ciclo, com 6 a 8 quadros;
  - **poses-chave das ações**, na ordem: atacar (preparar e golpear), defender, golpe recebido e queda (ajoelhar e caído), como o GIF de exemplo das ações;
  - opcional: **parado em Noite Escura** (curvado), 1 a 4 quadros.
- O agente tira o fundo, alinha os pés, corta os quadros e monta tudo (`tools/art/`).

## 3. Inventário e prioridade

Situação: ✅ já recebido e usável · 🟡 recebido, mas precisa de versão nova · ⬜ falta.

### Prioridade 1 · Bloco A (piloto de troca de pose e caminhada; T35 a T37)

| Imagem | Situação | Onde está o prompt |
| --- | --- | --- |
| Quadros de São Jorge: parado, andar e poses das ações (§2) | ⬜ Alan está definindo o formato (D-196); os GIFs de exemplo mostraram o caminho | Prompts de Alan; referência: `body_idle` aprovado |
| `env_circle_02_t1_ref`, `_back`, `_mid`, `_front` | 🟡 há só `_back` e `_front` com 1584×672 e sem `_mid`; precisa das 4 camadas no tamanho final, com o chão a y ≈ 900 e o `_mid` emendável | `prompts-environments.md` · Luxúria · T1 |
| Entradas da bifurcação: `prop_c02_entry_door`, `_cave`, `_stair`, `_straight` | ⬜ | **§6 deste documento** |
| Objetos do corredor: `prop_c02_tent` (Tentação), `prop_reliquary_closed` e `prop_reliquary_open` (relíquia) | ⬜ | **§6 deste documento** |
| `env_circle_02_souls_crowd` e `env_circle_02_souls_sheet` (a pose 3, duas almas abraçadas, é a alma parada no corredor do Encontro) | ⬜ | `prompts-environments.md` · Luxúria · Almas |
| `fx_circle_02_ambient`, `fx_fog_strip` | ⬜ | `prompts-environments.md` · Luxúria · Ambientação; Extras |

### Prioridade 2 · Bloco B (Círculo 2 completo; T38 a T44)

| Imagem | Situação | Onde está o prompt |
| --- | --- | --- |
| Quadros de Bento e Teresinha: parado, andar e poses das ações (§2) | ⬜ | Prompts de Alan; referência: `body_idle` e poses de `prompts-saints.md` |
| Quadros dos 7 inimigos da Família A: parado e poses das ações (§2); o `body_idle` já veio, mas em JPG com fundo xadrez pintado: se possível, regerar em PNG com fundo liso | 🟡 / ⬜ | `prompts-enemies-v1.md` · Família A (padrão, ataque e defesa como referência) |
| Minos (`elite_minos`): padrão, depois os quadros (§2) | ⬜ | `prompts-elites-bosses-v1.md` · Minos |
| Vertigem (`elite_sin_vertigo`): idem | ⬜ | `prompts-enemies-v1.md` · Vertigem |
| Asmodeu (`boss_asmodeus`): idem | ⬜ | `prompts-elites-bosses-v1.md` · Asmodeu |
| `env_circle_02_t2_*`, `env_circle_02_t3_*`, `env_circle_02_boss_*` (4 camadas cada) | ⬜ | `prompts-environments.md` · Luxúria |
| `env_circle_02_camp` em 2560×1080 | 🟡 v02 tem 1600×672 | `prompts-environments.md` · Luxúria · Ambientação |
| `env_circle_02_vigil` | ⬜ | Idem |
| Telas de passagem de Jorge, Bento e Teresinha (`splash_<id>_miracle`, `_dark_night`, `_consolation`) | ⬜ | `prompts-splash.md` |
| Ícones de intenção, de condição e de tipo de nó | ⬜ | `art-direction.md` §12 (modelo de ícone e tabelas) |
| Ilustrações dos eventos novos do Círculo 2 (Tentação nova, 2 Encontros, flashback) | ⬜ | Prompt feito pelo agente na T43, junto do texto; Francesca e Paolo já têm prancha em `art-direction.md` §11 |

### Prioridade 3 · Bloco C (vila e campanha; T45 a T50)

| Imagem | Situação | Onde está o prompt |
| --- | --- | --- |
| Fundo da vila sem edifícios | ⬜ | `art-direction.md` §10A · Fundo da vila |
| Edifícios: Despensa, Portão, Enfermaria, Casa de Exercícios | ⬜ | `art-direction.md` §10A (modelo e tabela) |
| Interiores das 4 instalações | ⬜ | `art-direction.md` §10 |
| Mapa do Inferno: faixa do topo (vila), Círculo 1 (bloqueado) e Círculo 2 | ⬜ | `prompts-environments.md` · Interface (guias do funil prontas) |
| Retrato de Santo Antão (tela de novo santo) | ⬜ | `prompts-saints.md` · Santo Antão (só o retrato) |
| `env_circle_02_arrival`, `env_descent_stair` | ⬜ | `prompts-environments.md` |
| Moldura de painel e de botões | ⬜ | `art-direction.md` §12 · Moldura de painel |

### Prioridade 4 · Bloco D (Prólogo e acabamento; T51 a T53)

| Imagem | Situação | Onde está o prompt |
| --- | --- | --- |
| Prólogo: 5 retratos de diálogo (`R01` a `R05`) e 16 pranchas (`P02` a `P17`) | ⬜ | `docs/narrative/prologue.md` §5 (D-190, D-198) |
| `env_gate_of_hell` | ⬜ | `prompts-environments.md` · Extras |
| `fx_light_shafts` | ⬜ | Idem |

**Fontes da interface:** não são imagens geradas; já estão definidas na Direção de Arte §12 (Uncial Antiqua nos títulos, EB Garamond nos textos, licença OFL) e entram na T53.

## 4. O que o motor faz sozinho (não precisa de imagem)

- A ligação entre as poses: deslizar até o alvo, câmera que aproxima, tremor, clarão, esticar e encolher; respiração e capa sutis por cima dos quadros.
- Chegada dos inimigos, câmera que aproxima, tremor, clarões, rastros de golpe.
- Auréola, raios, brilho, estados de desolação.
- Parallax, névoa, partículas soltas, almas balançando, redemoinhos girando.
- Relicário abrindo: troca entre `prop_reliquary_closed` e `_open` com brilho (animação por quadros, D-176).
- Luz do cenário conforme o Lume; vinheta.
- Barras, números, nomes e todos os textos.

## 5. Tamanhos das imagens novas

| Item | Formato | Arquivo final | Base |
| --- | --- | --- | --- |
| Entrada da bifurcação (`prop_<círculo>_entry_*`) | PNG RGBA 2:3 | 1024 × 1536 | Base no chão, a 96 px da borda de baixo (mesma linha dos pés dos santos) |
| Tenda da Tentação | PNG RGBA 1:1 | 1536 × 1536 | Idem |
| Relicário fechado e aberto | PNG RGBA 1:1 | 1024 × 1024, os dois com o **mesmo enquadramento** | Idem |

Pastas: `assets/environments/circles/circle_02/props/` (entradas e tenda) e `assets/environments/props/` (relicário, usado em todos os círculos).

## 6. Prompts novos: entradas e objetos do corredor (Círculo 2)

Mesmo estilo das folhas de Alan. As entradas ficam encostadas na parede de rocha do `_mid`; a figura de um santo deve caber na abertura com folga. Gerar com o `env_circle_02_t1_ref` aprovado como referência de estilo (`--sref`).

**`prop_c02_entry_door`** — Porta (desvio)

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px** · base a 96 px da borda de baixo · abertura com ≈ 1300 px de altura

```text
Darkest Dungeon style 2D side-view game prop, hand-painted gothic horror, hand-inked comic art, a narrow ancient doorway cut into a storm-battered rock wall, a heavy half-open wooden door with rusted iron bands rattling in the wind, torn cloth caught on the frame, darkness beyond the opening, standing on a short strip of flat stony ground, front view, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal --ar 2:3 --no characters, people, creatures, text, letters, UI, halo, vignette, cartoon, anime, glossy, 3D, photorealistic, white background
```

**`prop_c02_entry_cave`** — Caverna (desvio)

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px** · base a 96 px da borda de baixo

```text
Darkest Dungeon style 2D side-view game prop, hand-painted gothic horror, hand-inked comic art, the jagged black mouth of a cave opening in a cliff face, wind howling into it, loose debris and thorny roots around the rim, deep darkness inside, standing on a short strip of flat stony ground, front view, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal --ar 2:3 --no characters, people, creatures, text, letters, UI, halo, vignette, cartoon, anime, glossy, 3D, photorealistic, white background
```

**`prop_c02_entry_stair`** — Escada (desvio)

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px** · base a 96 px da borda de baixo

```text
Darkest Dungeon style 2D side-view game prop, hand-painted gothic horror, hand-inked comic art, a steep worn stone stairway carved into the rock, descending into a dark gap between two crooked rock pillars, crumbling steps swept by wind and dust, standing on a short strip of flat stony ground, front view, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal --ar 2:3 --no characters, people, creatures, text, letters, UI, halo, vignette, cartoon, anime, glossy, 3D, photorealistic, white background
```

**`prop_c02_entry_straight`** — Seguir em frente (fim do corredor)

> **Gerar:** `--ar 2:3` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **1024 × 1536 px** · base a 96 px da borda de baixo

```text
Darkest Dungeon style 2D side-view game prop, hand-painted gothic horror, hand-inked comic art, a crude archway of two leaning wind-worn standing stones marking the path that continues forward into the storm, a tattered strip of grey cloth tied to one stone and flapping in the wind, standing on a short strip of flat stony ground, front view, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal --ar 2:3 --no characters, people, creatures, text, letters, UI, halo, vignette, cartoon, anime, glossy, 3D, photorealistic, white background
```

**`prop_c02_tent`** — Tenda da Tentação ("O abrigo do vento")

> **Gerar:** `--ar 1:1` + Upscale 2×  
> **Arquivo final:** PNG RGBA, **1536 × 1536 px** · base a 96 px da borda de baixo · a mesma tenda da ilustração do evento (usar a ilustração como referência de imagem)

```text
Darkest Dungeon style 2D side-view game prop, hand-painted gothic horror, hand-inked comic art, a single isolated pale cloth tent glowing with a soft warm inviting light from within, untouched and perfectly still while sand and wind whip around it, entrance flap slightly open showing only light, faint footprints in the sand leading to it, standing on a short strip of flat sandy ground, front view, uncanny calm, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey, stormy violet and a single warm amber glow, distressed print texture, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal --ar 1:1 --no characters, people, creatures, text, letters, UI, halo, vignette, cartoon, anime, glossy, 3D, photorealistic, white background
```

**`prop_reliquary_closed`** e **`prop_reliquary_open`** — Relicário fechado e aberto

> **Gerar:** `--ar 1:1` + Upscale 2× · gere o fechado, aprove, e use-o como referência de imagem para o aberto (mesmo ângulo, mesma escala)  
> **Arquivo final:** PNG RGBA, **1024 × 1024 px** cada · base a 96 px da borda de baixo · os dois no mesmo enquadramento

```text
Darkest Dungeon style 2D side-view game prop, hand-painted gothic horror, hand-inked comic art, a small ornate medieval reliquary casket with a gabled lid and a simple cross on top, worn and dusty, lid tightly closed, resting on a fallen flat stone, three-quarter front view, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey with small touches of flat gold, distressed print texture, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal --ar 1:1 --no characters, people, creatures, text, letters, UI, halo, vignette, cartoon, anime, glossy, 3D, photorealistic, white background
```

Para o aberto, trocar `lid tightly closed` por `lid open, a soft pale gold light rising from inside, the contents hidden by the glow`.

Para os trechos 2 e 3 e os outros círculos, as entradas seguem o mesmo modelo, trocando a descrição do material e a cor do círculo (`prompts-environments.md`).

## 7. Variações do meio do corredor (D-216)

Depois da prévia, Alan definiu: trechos com evento ficam **mais limpos**; porta e caverna precisam de **parede atrás**; o trecho atual (com o trono de Minos) fica para **combate** e para a **escada**; o "seguir em frente" só precisa da emenda do chão; as almas aparecem **só no trecho do Encontro com a alma**.

**`env_circle_02_t1_mid_clean`** — Meio limpo (tenda, relicário, alma)

> **Gerar:** `--ar 21:9` + Upscale 2× (se possível) · use o `env_circle_02_t1_mid` aprovado como referência de estilo  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px** · chão em **y ≈ 900 px** · bordas emendáveis

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, middle layer only for parallax, a clean open stretch of the same rocky cliff ledge with only a few low scattered rocks and small debris at the edges, no tall structures, no throne, wide open empty space above the ground, a continuous flat walkable ground strip along the bottom of the image with the ground surface at about 83 percent of the image height, empty plain flat solid light grey background above and behind instead of sky, seamless left and right edges for horizontal tiling, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture --ar 21:9 --no sky, clouds, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

**`env_circle_02_t1_mid_wall`** — Meio com parede de rocha (porta, caverna)

> **Gerar:** `--ar 21:9` + Upscale 2× (se possível) · mesma referência de estilo  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px** · chão em **y ≈ 900 px** · bordas emendáveis

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, middle layer only for parallax, a continuous tall rugged rock cliff wall rising behind the walkway along the whole image, a flat vertical rock face where a doorway or a cave mouth can be set, no openings drawn in it, a continuous flat walkable ground strip along the bottom of the image with the ground surface at about 83 percent of the image height, empty plain flat solid light grey background above and behind instead of sky, seamless left and right edges for horizontal tiling, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture --ar 21:9 --no sky, clouds, characters, people, creatures, text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

**`env_circle_02_t1_mid_battle`** — Meio genérico de combate (a maioria dos trechos)

> **Gerar:** `--ar 21:9` + Upscale 2× (se possível) · mesma referência de estilo · se puder, gere 2 ou 3 variações para alternar entre os nós  
> **Arquivo final:** PNG RGBA, **2560 × 1080 px** · chão em **y ≈ 900 px** · bordas emendáveis

```text
Darkest Dungeon style 2D side-view game background, hand-painted gothic horror, hand-inked comic art, middle layer only for parallax, a generic windswept rocky cliff ledge, jagged storm-battered boulders of different heights, a few broken stone fragments and torn cloth caught on thorns, no throne, no seat, no landmark, varied but low-detail shapes, a continuous flat walkable ground strip along the bottom of the image with the ground surface at about 83 percent of the image height, empty plain flat solid light grey background above and behind instead of sky, seamless left and right edges for horizontal tiling, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture --ar 21:9 --no sky, clouds, characters, people, creatures, text, letters, UI, throne, seat, cartoon, anime, glossy, 3D, photorealistic, vignette, frame
```

O meio com o **trono de Minos** (`env_circle_02_t1_mid`, já recebido) fica reservado para **um trecho só** (D-218).
