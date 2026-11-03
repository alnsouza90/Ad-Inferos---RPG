# Glossário

Termos oficiais do jogo. A coluna "Código" é o nome obrigatório em classes, variáveis, IDs de dados e arquivos. O texto exibido ao jogador sempre vem dos dados, em português.

**Regra:** se um termo não estiver aqui, pergunte antes de criar um nome novo, e acrescente-o a esta tabela.

## Estrutura do jogo

| Português | Código | Observação |
| --- | --- | --- |
| Companhia | `party` | Os três santos em campo |
| Santo | `saint` | Personagem jogável |
| Peregrino | `pilgrim` | Não é unidade de combate |
| Círculo | `circle` | `circle_01` a `circle_09`; o prólogo é `circle_00` |
| Expedição | `expedition` | Uma ida da vila até retirada, derrota ou chefe |
| Trecho | `leg` | Parte da expedição entre Pousos |
| Nó | `node` | Ponto do mapa |
| Pouso | `camp` | Fim de trecho; descanso |
| Pouso consagrado | `consecrated_camp` | Ponto de retomada |
| Vigília (nó antes do chefe) | `vigil_node` | |
| Vila / Átrio | `village` | |
| Instalação | `facility` | |
| Guardião | `guardian` | Santo não jogável de uma instalação |
| Semana | `week` | |
| Calendário litúrgico | `liturgical_calendar` | |
| Tempo litúrgico | `season` | `advent`, `christmas`, `ordinary_1`, `lent`, `easter`, `ordinary_2` |
| Escalada | `escalation` | Revisitas com dificuldade |
| Conselho da vila | `council` | |
| Flashback | `flashback` | Cena do fim de cada círculo |

## Combate

| Português | Código | Observação |
| --- | --- | --- |
| Combate | `battle` | Uma luta |
| Encontro de combate | `encounter` | Grupo de inimigos definido em dados |
| Posição | `slot` | Santos 1–3, inimigos 1–4 (1 = mais perto do centro) |
| Vanguarda / Centro / Retaguarda | `slot` 1 / 2 / 3 | |
| Turno de equipe | `party_turn` | |
| Turno inimigo | `enemy_turn` | |
| Rodada | `round` | Turno de equipe + turno inimigo + ambiente |
| Ação | `action` | |
| Intenção | `intent` | Ação que o inimigo anunciou |
| Fervor | `fervor` | Recurso compartilhado |
| Habilidade | `ability` | |
| Habilidade básica | `basic_ability` | Custo 0 ou 1 |
| Habilidade de Fervor | `fervor_ability` | Custo 2 |
| Milagre | `miracle` | Fora dos espaços, custo 3 ou 4 |
| Traço | `trait` | Passivo |
| Carisma | `charism` | Caminho de especialização |
| Efeito | `effect` | Unidade de resultado (dano, cura, mover...) |
| Golpe | `strike` | Tipo de dano físico |
| Exorcismo | `exorcism` | Tipo de dano espiritual |
| Corpóreo | `corporeal` | Natureza de inimigo |
| Espiritual | `spiritual` | Natureza de inimigo |
| Caído (estado) | `fallen` | Santo a 0 de vida |
| Levantar | `revive` | |
| Afinidade | `affinity` | |
| Elite | `elite` | |
| Chefe | `boss` | |
| Pecado Encarnado | `sin_incarnate` | |
| Mecânica de ambiente | `circle_hazard` | |

## Atributos

| Português | Código | Observação |
| --- | --- | --- |
| Vigor (vida máxima) | `max_hp` | Vida atual: `hp` |
| Proteção (atributo) | `armor` | Redução fixa de dano. **Não confundir** com a condição Amparo |
| Fé (atributo do santo) | `faith` | **Não confundir** com a virtude Fé do Peregrino |
| Vontade | `will` | Resistência a condições |

## Condições

| Português | Código | Observação |
| --- | --- | --- |
| Condição | `condition` | |
| Ficha | `token` | Condição consumida ao disparar |
| Duração | `duration` | Condição que conta turnos |
| Pilhas | `stacks` | |
| Atordoamento | `stun` | |
| Sangramento | `bleed` | Antiga "Ferida" |
| Corrupção | `corruption` | |
| Amparo (condição) | `ward` | Ficha que reduz o próximo golpe à metade (antes chamada "Proteção") |
| Força | `strength` | |
| Provocação | `taunt` | |
| Duelo | `duel` | Condição de assinatura de São Jorge |
| Congelamento | `freeze` | Só Círculo 9 |
| Fúria | `fury` | Só Círculo 5, inimigos |
| Torpor | `torpor` | Só Círculo 5, santos |

## Espiritual

| Português | Código | Observação |
| --- | --- | --- |
| Desolação | `desolation` | 0 a 200 |
| Consolação | `consolation` | Estado |
| Noite Escura | `dark_night` | Estado |
| Prostração | `prostration` | Estado |
| Purificação | `purification` | Estado momentâneo |
| Teste de Fé | `faith_check` | |
| Auréola | `halo` | Elemento visual do motor |

## Expedição e recursos

| Português | Código | Observação |
| --- | --- | --- |
| Lume | `light` | 0 a 100 |
| Provisão | `provision` | |
| Pão | `bread` | |
| Vela | `candle` | |
| Água Benta | `holy_water` | |
| Ataduras | `bandages` | |
| Incenso | `incense` | |
| Esmolas | `alms` | Moeda |
| Sufrágios | `suffrages` | Nunca gastos |
| Trilha do Purgatório | `purgatory_track` | |
| Marco | `milestone` | |
| Ferimento (leve/grave) | `injury` (`minor`/`major`) | Estado de vila |
| Relíquia | `relic` | |
| Sacramental | `sacramental` | Categoria de relíquia |
| Equipamento | `equipment` | |
| Instrumento | `instrument` | Espaço de equipamento |
| Hábito | `habit` | Espaço de equipamento |
| Morada (Carmelo) | `mansion` | 1 a 7 |

## Atividades do Pouso

| Português | Código |
| --- | --- |
| Vigília | `vigil` |
| Partilha | `share` |
| Oração | `prayer` |
| Atividade própria | `signature_camp_skill` |

## Nós do mapa

| Português | Código |
| --- | --- |
| Combate | `node_battle` |
| Elite | `node_elite` |
| Tentação | `node_temptation` |
| Encontro (alma) | `node_soul` |
| Relíquia oculta | `node_relic` |
| Pouso | `node_camp` |
| Vigília | `node_vigil` |
| Chefe | `node_boss` |

## Narrativa

| Português | Código | Observação |
| --- | --- | --- |
| Tentação | `temptation` | |
| Encontro com alma | `soul_meeting` | **Não confundir** com `encounter` (combate) |
| Virtude Fé / Esperança / Caridade | `virtue_faith` / `virtue_hope` / `virtue_charity` | 0 a 5 |
| Missão de Intercessão | `intercession_mission` | |
| Martirológio | `martyrology` | Só santos e arcanjos |
| Arquivo de Santo Tomás | `archive` | Demônios, almas, lugares, fontes |
| Final | `ending` | `awakening`, `restless_awakening`, `good_death` |

## Instalações

| Português | Código |
| --- | --- |
| Capela | `chapel` |
| Enfermaria | `infirmary` |
| Despensa | `pantry` |
| Portão | `gate` |
| Casa de Exercícios | `exercise_house` |
| Forja | `forge` |
| Biblioteca | `library` |
| Carmelo | `carmel` |
| Relicário | `reliquary` |
| Jardim | `garden` |
| Coro (expansão) | `choir` |

## IDs de personagens

| Português | Código |
| --- | --- |
| São Jorge | `saint_george` |
| São Bento | `saint_benedict` |
| Santa Teresinha | `saint_therese` |
| São Nicolau de Mira | `saint_nicholas` |
| Santo Antão | `saint_anthony_abbot` |
| Santa Joana d'Arc | `saint_joan` |
| São João da Cruz | `saint_john_cross` |
| São Padre Pio | `saint_pio` |
| Santa Rita de Cássia | `saint_rita` |
| Santo Antônio de Pádua | `saint_anthony_padua` |
| São Sebastião | `saint_sebastian` |
| Santa Gertrudes | `saint_gertrude` |
