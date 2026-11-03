# Especificação · Condições

Versão 1.0 · base: GDD v1.1 §2 (Condições) e §12 · números em `docs/balance/conditions.csv`

## 1. Princípio

Toda condição é um registro de dados com os mesmos campos. O motor de condições (`game/core/conditions/`) não conhece condições específicas: ele aplica regras genéricas a partir dos dados. Comportamentos que não cabem nos campos genéricos são **ganchos** nomeados (§4), implementados uma vez e referenciados pelos dados.

## 2. Campos

| Campo | Valores | Significado |
| --- | --- | --- |
| `id` | texto | Ver glossário |
| `kind` | `token` / `duration` / `permanent` | Ficha (consumida ao disparar), duração (conta e decai) ou permanente no combate |
| `polarity` | `positive` / `negative` | Positivas são removidas quando o portador cai |
| `max_stacks` | inteiro | Limite de pilhas |
| `stacking` | `add` / `refresh` / `none` | Somar pilhas, substituir pelo maior valor, ou ignorar nova aplicação |
| `decay` | `none` / `minus_one_after_tick` / `expire_round_end` | Como perde pilhas |
| `tick` | `none` / `owner_turn_start` / `round_end` | Quando o efeito periódico ocorre |
| `consume_on` | `none` / `on_hit_received` / `on_damaging_action` / `on_action_attempt` | Quando a ficha é consumida |
| `resisted_by_will` | `true` / `false` | Se a Vontade do alvo reduz as pilhas aplicadas |
| `hook` | nome ou vazio | Comportamento especial (§4) |
| `icon` | caminho | Ícone da interface |
| `display_priority` | 1 (mais alta) a 9 | Ordem de exibição |
| `name_pt`, `desc_pt` | texto | Texto ao jogador |

## 3. Regras gerais

### 3.1 Aplicação

1. Se o alvo tem imunidade à condição (dado do inimigo ou imunidade temporária), não aplicar e gerar evento "imune".
2. Se `resisted_by_will`, pilhas = máximo(0, pilhas − `will` do alvo). Se der 0, gerar evento "resistiu".
3. Aplicar conforme `stacking`, respeitando `max_stacks`.
4. Gerar evento `condition_applied`.

### 3.2 Momentos

| Momento | Quando, na rodada (`combat.md` §3) |
| --- | --- |
| `owner_turn_start` | Santos: início do turno da equipe (etapa 4). Inimigo: imediatamente antes da sua ação (etapa 6a) |
| `round_end` | Etapa 8 |

### 3.3 Decaimento

- `minus_one_after_tick`: logo após o tick, −1 pilha; com 0, a condição sai.
- `expire_round_end`: a condição inteira sai no fim da rodada em que foi aplicada... **exceto** quando aplicada durante o turno inimigo ou o ambiente, caso em que dura até o fim da rodada seguinte. Isso garante que toda ficha com expiração protege pelo menos um turno inimigo.

### 3.4 Remoção

- Por efeito `remove_condition` (provisões, habilidades).
- Ao cair: removem-se todas as positivas.
- Ao fim do combate: removem-se todas.

## 4. Ganchos

| Gancho | Comportamento |
| --- | --- |
| `stun_cancel` | O portador perde a próxima ação (santo) ou a intenção atual (inimigo). Ao ser consumida, concede `stun_immune` por 1 rodada |
| `bleed_tick` | No tick: dano igual às pilhas, `untyped`, ignorando `armor` e a ficha Amparo |
| `corruption_tick` | No tick: desolação = [corruption_desolation_per_stack] × pilhas. Só afeta santos; inimigos são imunes |
| `ward_halve` | Reduz à metade o próximo dano recebido (`combat.md` §9) |
| `strength_boost` | Aumenta em 25% o dano da próxima ação que cause dano |
| `taunt_redirect` | Redireciona intenções de alvo único (`combat.md` §6.2) |
| `duel_mark` | §5 |
| `freeze_counter` | Ver tabela §6 |
| `fury_counter` | Ver tabela §6 |
| `torpor_counter` | Ver tabela §6 |

## 5. Condição de assinatura: Duelo

- Aplicada apenas por São Jorge (traço e habilidade Desafio Formal).
- Só um inimigo por vez fica em Duelo com Jorge; aplicar em outro remove do anterior.
- Efeitos: Jorge causa dano × [duel_damage_mult] (1,25) ao alvo em Duelo; quando esse alvo executa uma ação de alvo único que atinge Jorge, Jorge contra-ataca com Golpe [duel_counter_damage] (3), enfileirado após o golpe recebido. Sem contra-ataque se Jorge estiver Caído ou Atordoado.
- Dura até o alvo morrer, Jorge cair ou o combate acabar.

## 6. Condições da versão 1

| Condição | `kind` | Pol. | Máx. | Acúmulo | Tick / consumo | Decaimento | Vontade | Gancho | Regra |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Atordoamento `stun` | token | neg | 1 | none | consumo `on_action_attempt` | — | não | `stun_cancel` | Perde a próxima ação; depois, 1 rodada imune |
| Sangramento `bleed` | duration | neg | 5 | add | tick `owner_turn_start` | −1 após tick | sim | `bleed_tick` | Dano = pilhas |
| Corrupção `corruption` | duration | neg | 5 | add | tick `owner_turn_start` | −1 após tick | sim | `corruption_tick` | Desolação = 3 × pilhas |
| Amparo `ward` | token | pos | 3 | add | consumo `on_hit_received` | — | — | `ward_halve` | Próximo dano −50% |
| Força `strength` | token | pos | 3 | add | consumo `on_damaging_action` | — | — | `strength_boost` | Próxima ação +25% |
| Provocação `taunt` | token | pos | 1 | refresh | — | `expire_round_end` | — | `taunt_redirect` | Atrai ataques de alvo único |
| Duelo `duel` | permanent | neg (no inimigo) | 1 | refresh | — | — | não | `duel_mark` | §5 |
| Congelamento `freeze` (Círculo 9) | duration | neg | 3 | add | tick `round_end` | — | não | `freeze_counter` | +1 se o santo não mudou de posição na rodada; mudar remove 1; com 3, perde a próxima ação e zera |
| Fúria `fury` (Círculo 5, inimigos) | permanent | pos | 5 | add | — | — | — | `fury_counter` | +1 cada vez que o inimigo recebe dano; +10% de dano por pilha |
| Torpor `torpor` (Círculo 5, santos) | duration | neg | 3 | add | tick `round_end` | — | não | `torpor_counter` | +1 se o santo não usou milagre na rodada; com 3, a equipe recebe −1 de Fervor na rodada seguinte e zera; usar milagre zera |

Valores numéricos repetidos aqui são cópia de `docs/balance/conditions.csv`; em caso de divergência, o CSV vale.

## 7. Exibição

- No máximo 3 ícones por personagem, pela `display_priority`; um selo "+N" abre a lista completa ao tocar.
- Cada ícone mostra o número de pilhas quando `max_stacks` > 1.
- Ferimentos (estado de vila) e estados de desolação (na auréola) não aparecem como condição.

## 8. Casos de teste obrigatórios

| # | Cenário | Esperado |
| --- | --- | --- |
| K01 | Sangramento 3 no santo | No início do turno: 3 de dano ignorando armor e Amparo; fica com 2 |
| K02 | Aplicar Sangramento 4 em santo com Vontade 1 | Recebe 3 |
| K03 | Aplicar Sangramento 1 em santo com Vontade 1 | Não recebe; evento "resistiu" |
| K04 | Sangramento 5 + aplicar 2 | Fica em 5 |
| K05 | Atordoamento em inimigo com intenção | Intenção cancelada; inimigo fica imune a atordoamento até o fim da rodada seguinte |
| K06 | Atordoar inimigo imune | Evento "imune"; sem efeito |
| K07 | Amparo 2 e dois golpes | Primeiro golpe −50%, consome 1; segundo golpe −50%, consome 1 |
| K08 | Força em ação que só cura | Ficha não é consumida |
| K09 | Provocação aplicada no turno da equipe | Expira no fim da mesma rodada, depois de proteger o turno inimigo |
| K10 | Santo cai com Força e Sangramento | Força removida; Sangramento permanece |
| K11 | Corrupção em inimigo | Imune |
| K12 | Duelo em A, depois Desafio Formal em B | A sai do Duelo; B entra |
| K13 | Alvo em Duelo ataca Jorge | Jorge recebe o golpe e depois contra-ataca com 3 |
| K14 | Congelamento: santo parado 3 rodadas | Perde a ação da 4ª rodada e zera |
| K15 | Fim do combate | Todas as condições removidas |
