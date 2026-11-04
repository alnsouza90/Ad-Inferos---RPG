# Esquemas de dados

Formato de todos os dados do jogo. A fonte de verdade são os CSVs em `docs/balance/`; o importador (`game/tools/data/import_balance.gd`) gera os Resources em `game/data/`.

## 1. Regras gerais dos CSVs

- Codificação UTF-8, separador vírgula, primeira linha com cabeçalho.
- Campos de texto com vírgula vão entre aspas duplas.
- Listas dentro de um campo usam `|` (ex.: `1|2|3`).
- Pares chave-valor dentro de um campo usam `chave=valor` separados por `;` (ex.: `elite=2.0;boss=2.0`).
- IDs em `snake_case`, conforme `docs/glossary.md`.
- Células vazias significam "não se aplica".
- Linhas que começam com `#` na primeira coluna são comentários e são ignoradas.

## 2. Validação do importador

O importador **falha** (e não gera nada) se:

- Um ID referenciado não existe (habilidade de santo inexistente, efeito de habilidade inexistente, condição inexistente...).
- Um ID se repete.
- Um número está fora do intervalo do campo.
- Um santo não tem habilidade básica de custo 0 utilizável de qualquer posição (`combat.md` §2.5).
- Uma Tentação não tem opção segura (`narrative-system.md` N02).
- Um milagre custa menos que 3 ou mais que 4 (decisão de 03/11/2026: custo mínimo 3).
- Uma básica custa mais que 1, ou uma de Fervor custa diferente de 2.
- O `default_equipped` de um santo não tem nenhuma habilidade de custo 0.
- Um santo não tem pelo menos uma básica que cause dano (GDD §12, P5).

## 3. Arquivos e campos

### 3.1 `constants.csv` → `game/data/constants.tres`

| Campo | Tipo | Descrição |
| --- | --- | --- |
| `key` | texto | Nome da constante citada nas especificações como `[key]` |
| `value` | número | Valor |
| `description` | texto | Para que serve |

### 3.2 `saints.csv` → `SaintDef`

| Campo | Tipo | Descrição |
| --- | --- | --- |
| `id` | texto | Ex.: `saint_george` |
| `name_pt` | texto | Nome exibido |
| `roles` | lista | `protector`, `healer`, `fighter`, `exorcist`, `intercessor` |
| `preferred_slots` | lista | Posições indicadas |
| `max_hp` | inteiro | Vigor no nível 1 |
| `armor` | inteiro 0–3 | Proteção (atributo) |
| `faith` | inteiro 0–10 | Fé |
| `will` | inteiro 0–3 | Vontade |
| `hp_per_level` | inteiro | Vida ganha por nível |
| `faith_per_level` | inteiro | Fé ganha por nível |
| `abilities` | lista de 6 | IDs em `abilities.csv` (4 básicas + 2 de Fervor) |
| `default_equipped` | lista de 4 | Subconjunto de `abilities` |
| `miracle` | texto | ID do milagre |
| `trait` | texto | ID do traço (`traits.csv`) |
| `camp_skill` | texto | ID da atividade própria de Pouso |
| `affinities` | lista | IDs de afinidade |
| `unlock` | texto | `start`, `week:3`, `circle:2`, `carmel`, `milestone:3` |
| `m0` | `y`/vazio | Incluído no protótipo M0 |

### 3.3 `abilities.csv` → `AbilityDef`

| Campo | Tipo | Descrição |
| --- | --- | --- |
| `id` | texto | Ex.: `george_lance` |
| `owner` | texto | ID do santo |
| `name_pt` | texto | |
| `kind` | `basic` / `fervor` / `miracle` | |
| `cost` | inteiro | Fervor |
| `use_slots` | lista | Posições do santo |
| `targeting` | texto | Ver `combat.md` §6.1 |
| `target_slots` | lista | Posições-alvo (inimigos ou aliados) |
| `allow_self` | `y`/vazio | Para `ally` |
| `once_per_battle` | `y`/vazio | |
| `origin` | texto | Ver `narrative-system.md` §6 |
| `upgrade` | texto | Vazio = regra geral de melhoria (`village-economy.md` §9). Preenchido só para exceções, no formato `e<ordem>.<campo>+<valor>` (ex.: `e1.amount+4;e2.stacks+1`) |
| `desc_pt` | texto | Descrição curta exibida |

Os efeitos ficam em `effects.csv`.

### 3.4 `effects.csv` → lista de `EffectDef` dentro de habilidades e ações inimigas

| Campo | Tipo | Descrição |
| --- | --- | --- |
| `owner_id` | texto | ID da habilidade ou da ação inimiga |
| `order` | inteiro | Ordem de resolução |
| `type` | texto | Ver `combat.md` §7.1 |
| `amount` | número | Quantidade (dano, cura, Fervor, desolação, fração) |
| `damage_type` | `strike` / `exorcism` / `untyped` | Só para `damage` |
| `condition_id` | texto | Para `apply_condition` / `remove_condition` |
| `stacks` | inteiro | Pilhas ou quantidade de remoções |
| `polarity` | `negative` / `positive` | Para remoção por polaridade |
| `move_kind` | `push` / `pull` / `swap` | Para `move` |
| `n` | inteiro | Casas de movimento |
| `summon_id` | texto | Para `summon` |
| `max_alive` | inteiro | Para `summon` |
| `target_override` | `self` / `all_allies` / `all_enemies` / vazio | Aplica o efeito em outro alvo que não o da habilidade |
| `params` | chave=valor | Extras (ex.: `elite=2.0;boss=2.0`; `hp_fraction=0.3`; `const=bread_heal` indica que o valor vem da constante) |

Parâmetros extras reconhecidos na v1: `elite`, `boss` (multiplicadores por categoria) · `hp_fraction` · `heal_if_alive=1` (revive que cura quem está de pé) · `dark_night_amount` (valor alternativo se o alvo estiver em Noite Escura) · `per_milestone` (soma por marco do Purgatório; o combate recebe o número de marcos no `SETUP`) · `exclude_self=1` · `with=actor` (troca o alvo de lugar com o usuário, sem gastar a ação do alvo) · `const`.

Tipos de efeito exclusivos de provisões, fora de combate: `light` (soma Lume) e `reveal_or_cancel_ambush` (Incenso).

### 3.5 `traits.csv` → `TraitDef`

| Campo | Tipo | Descrição |
| --- | --- | --- |
| `id` | texto | |
| `owner` | texto | Santo |
| `name_pt`, `desc_pt` | texto | |
| `trigger` | texto | `on_battle_start`, `on_round_start`, `on_ability_used`, `on_damage_dealt`, `on_damaged`, `on_ally_fallen`, `on_fallen`, `passive` |
| `hook` | texto | Comportamento implementado no código (um por traço) |
| `params` | chave=valor | Números do traço |

### 3.5.1 `camp_skills.csv` → `CampSkillDef`

| Campo | Tipo | Descrição |
| --- | --- | --- |
| `id`, `owner`, `name_pt`, `desc_pt` | texto | |
| `effect` | texto | `ambush_mult`, `desolation_party`, `heal_party_pct`, `heal_ally_pct`, `ally_desolation`, `refund_bread`, `alms_bonus`, `next_battle_condition`, `remove_minor_injury`, `reveal_next_layer`, `suffrage_bonus` (lista fechada; novo efeito exige código) |
| `params` | chave=valor | |

### 3.6 `conditions.csv` → `ConditionDef`

Campos de `docs/specs/conditions.md` §2.

### 3.7 `enemies.csv` → `EnemyDef`

| Campo | Tipo | Descrição |
| --- | --- | --- |
| `id` | texto | |
| `name_pt` | texto | |
| `family` | `a` / `b` / `c` / `elite` / `boss` | |
| `circles` | lista | Círculos onde aparece |
| `nature` | `corporeal` / `spiritual` | |
| `role` | `brute` / `guard` / `ranged` / `corruptor` / `manipulator` / `summoner` | |
| `size` | 1–3 | Posições ocupadas |
| `max_hp` | inteiro | |
| `armor` | inteiro 0–3 | |
| `immune` | lista | Condições a que é imune |
| `leaves_remains` | `y`/vazio | |
| `remains_rounds` | inteiro | |
| `actions` | lista | IDs em `enemy_actions.csv` |
| `art_id` | texto | Nome base da arte (`asset-pipeline.md`) |

### 3.8 `enemy_actions.csv` → `EnemyActionDef`

Campos de `docs/specs/enemy-ai.md` §2. As condições ficam em `conditions` no formato `nome:param` separados por `|` (ex.: `every_n_rounds:2|free_enemy_slot`). Os efeitos ficam em `effects.csv`.

### 3.9 `encounters.csv` → `EncounterDef`

| Campo | Tipo | Descrição |
| --- | --- | --- |
| `id` | texto | |
| `circle` | inteiro | 0 a 9 (`m0` para a arena do protótipo) |
| `pool` | `easy` / `hard` / `elite` / `boss` / `ambush` | |
| `slot_1` … `slot_4` | texto | ID do inimigo em cada posição |
| `type` | `common` / `elite` / `boss` | Para recompensas e desolação de fim de combate |

### 3.10 `provisions.csv` → `ProvisionDef`

| Campo | Tipo | Descrição |
| --- | --- | --- |
| `id` | texto | |
| `name_pt` | texto | |
| `price` | inteiro | Esmolas |
| `usable_in_battle` | `y`/vazio | |
| `targeting` | texto | |
| `effect_ids` | lista | Efeitos (em `effects.csv`, `owner_id` = ID da provisão) |

### 3.11 `relics.csv` → `RelicDef`

| Campo | Tipo | Descrição |
| --- | --- | --- |
| `id` | texto | |
| `name_pt` | texto | |
| `category` | `sacramental` / `saint` / `guardian` / `purgatory` | |
| `relic_class` | `2` / `3` / `sacramental` / `devotional` | Classe da relíquia |
| `origin` | texto | `tradition`, `legend`, `hagiography`… |
| `to_confirm` | `y`/vazio | Precisa de pesquisa antes do Martirológio |
| `rarity` | `common` / `rare` / `unique` | |
| `source` | texto | `relic_node`, `milestone:5`, `milestone:9` |
| `modifier` | texto | Tipo de modificador (§4) |
| `params` | chave=valor | |
| `desc_pt` | texto | |

### 3.12 `facilities.csv` e `economy.csv`

- `facilities.csv`: `facility`, `level`, `unlock`, `cost`, `effect_key`, `value`, `desc_pt`.
- `economy.csv`: `key`, `value`, `description` (custos, recompensas, multiplicadores).

### 3.13 `feasts.csv`

`saint_id`, `real_date` (dia/mês), `week` (1–20), `note`. A preencher após a pesquisa do Martirológio.

### 3.14 `ui_text.csv` → `game/data/ui_text.tres` (`UiTextDef`)

Textos da interface (botões, avisos, motivos de recusa, rótulos de estado). ADR-0010.

| Campo | Tipo | Descrição |
| --- | --- | --- |
| `id` | texto | Chave estável usada pelas telas (`end_turn`, `reason_wrong_slot`...) |
| `text_pt` | texto | Texto exibido; pode ter campos entre chaves (`Rodada {round}`), preenchidos pela tela |

- Motivos de recusa: `reason_<código>` para cada código de `CommandResult`.
- Intenções: `intent_<intent_icon>`; estados espirituais: `spirit_<estado>`.
- O teste `test_every_screen_text_exists_in_the_data` falha se a tela pedir uma chave que não existe.

## 4. Modificadores de relíquia (versão 1)

| `modifier` | `params` | Efeito |
| --- | --- | --- |
| `stat_add` | `stat=faith;value=1` | Soma ao atributo |
| `stat_mult` | `stat=max_hp;value=1.05` | Multiplica o atributo |
| `damage_type_mult` | `type=strike;value=1.10` | Dano do portador daquele tipo |
| `heal_dealt_mult` | `value=1.15` | Cura causada |
| `heal_received_mult` | `value=1.10` | Cura recebida |
| `desolation_gain_mult` | `value=0.90` | Ganho de desolação |
| `condition_received_reduction` | `condition=corruption;value=1` | Pilhas a menos recebidas |
| `light_per_node` | `value=4` | Substitui a perda de Lume por nó (não acumula; vale o menor) |
| `provision_effect_mult` | `value=1.25` | Provisões usadas pelo portador |
| `battle_start_condition` | `condition=strength;stacks=1` | Condição no início do combate |
| `share_heal_mult` | `value=1.5` | Partilha no Pouso |
| `ability_param` | `ability=rita_rose_winter;param=hp_fraction;value=0.6` | Altera parâmetro de uma habilidade |
| `ability_cost_mult` | `ability=pio_stigmata;param=self_damage;value=0.75` | Altera custo de vida |
| `stun_duration_bonus` | `value=1;target=common` | Atordoamento dura mais em comuns |
| `trait_extension` | `trait=benedict_clausura;add=stun_immunity` | Amplia um traço |
| `turn_start_cleanse` | `value=1` | Remove 1 condição negativa no início do turno |
| `purification_heal` | `value=0.20` | Cura na Purificação |
| `purification_xp_mult` | `value=1.25` | Experiência após Purificação |
| `faith_check_bonus` | `value=0.05` | Chance de Consolação |
| `injury_heal_bonus` | `weeks=1` | Ferimentos curam mais rápido |
| `chapel_suffrages_add` | `value=1` | Sufrágios quando na Capela |
| `prevent_prostration` | `per=expedition;value=1` | Impede uma Prostração |

Um modificador novo exige atualizar esta tabela e o código do motor de modificadores.

### 3.15 `map_templates.csv` → `game/data/map_templates/<id>.tres` (`MapTemplateDef`)

Trechos fixos de reserva, usados quando o gerador não consegue um trecho válido em [map_generation_retries] tentativas (`expedition.md` §2.1). Uma linha por nó; as linhas com o mesmo `id` formam um modelo (D-132).

| Campo | Tipo | Descrição |
| --- | --- | --- |
| `id` | ID | Nome do modelo (`leg1_reserve`) |
| `leg` | inteiro 1–3 | Trecho a que o modelo serve |
| `layer` | inteiro ≥ 1 | Camada do nó, sem buracos |
| `index` | inteiro 0–2 | Posição na camada (de cima para baixo no mini-mapa), sem buracos |
| `role` | enum | O que as regras de caminho contam: `battle`, `temptation`, `variable`, `soul` |
| `type` | enum | Tipo de nó visível: `node_battle`, `node_elite`, `node_temptation`, `node_soul`, `node_relic` |
| `links` | lista de inteiros | Posições ligadas na camada seguinte; vazio na última camada |

Validação: o modelo inteiro passa pelas mesmas regras de caminho de um trecho gerado (`invalid_template`); nós fora da sequência dão `slot_gap`.
