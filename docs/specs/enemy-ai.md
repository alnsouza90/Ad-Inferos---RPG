# Especificação · IA inimiga e intenções

Versão 1.0 · base: GDD v1.1 §2 e §8 · dados em `docs/balance/enemy_actions.csv`

## 1. Princípios

- A IA é simples, legível e previsível: o jogador deve conseguir entender por que um inimigo escolheu aquela ação.
- Cada inimigo tem uma lista ordenada de ações com condições. Não há aprendizado nem busca.
- Toda escolha acontece no `ROUND_START` e é mostrada como **intenção** durante o turno da equipe.

## 2. Estrutura de uma ação inimiga (dados)

| Campo | Significado |
| --- | --- |
| `id` | Identificador |
| `priority` | Menor número = avaliada primeiro |
| `use_slots` | Posições do inimigo de onde a ação pode ser usada |
| `target_slots` | Posições de santo que a ação pode atingir |
| `targeting` | `single`, `all_party`, `self`, `ally_enemy`, `all_enemies` |
| `target_rule` | Como escolher entre alvos válidos (§3) |
| `conditions` | Lista de condições de uso (§2.1); todas precisam ser verdadeiras |
| `cooldown` | Rodadas até poder repetir (0 = sempre) |
| `effects` | Lista de efeitos (mesmo formato das habilidades) |
| `intent_icon` | `attack`, `corrupt`, `displace`, `defend`, `summon`, `special` |

### 2.1 Condições de uso

| Condição | Verdadeira quando |
| --- | --- |
| `always` | Sempre |
| `self_hp_below(p)` | Vida do inimigo abaixo de `p`% |
| `ally_hp_below(p)` | Algum outro inimigo abaixo de `p`% |
| `allies_alive_below(n)` | Menos de `n` inimigos vivos (incluindo ele) |
| `round_at_least(n)` | Rodada ≥ `n` |
| `every_n_rounds(n)` | Rodada múltipla de `n` |
| `party_has_condition(id)` | Algum santo tem a condição |
| `free_enemy_slot` | Há posição inimiga livre (para invocar) |

## 3. Escolha da intenção (no `ROUND_START`)

Para cada inimigo vivo, da posição 1 à 4:

1. Se Atordoado, a intenção é "atordoado" (nenhuma ação).
2. Percorrer as ações por `priority` crescente. A primeira cujas condições forem verdadeiras, fora de recarga, usável da posição atual e com pelo menos um alvo válido é a escolhida.
3. Se nenhuma servir, a intenção é "aguardar" (nenhuma ação).
4. Escolher o alvo pela `target_rule`:

| Regra | Alvo |
| --- | --- |
| `front_most` | Santo válido na menor posição |
| `back_most` | Santo válido na maior posição |
| `lowest_hp` | Menor vida atual (absoluta) |
| `lowest_hp_pct` | Menor percentual de vida |
| `highest_desolation` | Maior desolação |
| `random` | Sorteio pelo fluxo `battle` do RNG |

Empates (exceto `random`) são decididos pela menor posição.

5. Se algum santo tem Provocação e a ação é de alvo único e alcança a posição dele, o alvo passa a ser o provocador.
6. Registrar a intenção: `{enemy_id, action_id, target_slot | null, preview_value}`.

## 4. Execução (no `ENEMY_TURN`)

1. Se o inimigo foi Atordoado depois da escolha, a intenção é cancelada.
2. Se a posição-alvo não tem mais um alvo válido (Caído, fora de alcance), reescolher o alvo com a mesma `target_rule` entre os válidos; se não houver, a intenção falha com o evento "sem alvo".
3. Aplicar Provocação vigente (pode ter sido aplicada após a escolha).
4. Executar os efeitos.
5. Iniciar a recarga, se houver.

## 5. Exibição da intenção

- Ícone pela `intent_icon`, em tinta, nunca em ouro.
- Número: dano previsto já com todos os modificadores atuais (Força do inimigo, Amparo do alvo, `armor`).
- Uma linha ligando o inimigo à posição-alvo ao tocar no inimigo.
- A intenção é recalculada e redesenhada sempre que o estado mudar durante o turno da equipe (alvo mudou de posição, recebeu Amparo, inimigo foi atordoado ou empurrado).

## 6. Chefes (a partir do M2)

- Fases definidas por limiares de vida (`phase_thresholds`, ex.: [0.66, 0.33]); cada fase tem sua lista de ações.
- Chefes podem ter `actions_per_round` > 1; cada ação é uma intenção separada.
- Mecânicas próprias (contador da Judeca, olhar da Medusa) são ganchos nomeados, especificados por chefe em `docs/specs/bosses.md` (a criar no M2).
- **Domínio (D-284):** todo chefe segura a alma do Peregrino com um Domínio (proposta: 0 a 3), visível na tela; cada ponto é uma vantagem concreta do chefe (ação a mais, escolta, fase extra) e cede quando a companhia alcança o Peregrino no círculo. A companhia sempre pode vencer com o Domínio cheio. Asmodeu é o primeiro, e o fígado do peixe é um dos pontos (T38).
- **Pecado Encarnado e Provação (D-267):** o elite do círculo tem uma ação própria que aplica a Provação do Círculo com força (`expedition.md` §10.1); o chefe a cobra.
- **Intenção no corpo (D-355):** a apresentação pode mostrar, pela pose e pela respiração, quem vai atacar; a regra da intenção não muda.

## 7. Casos de teste obrigatórios

| # | Cenário | Esperado |
| --- | --- | --- |
| A01 | Duas ações válidas, prioridades 1 e 2 | Escolhe a de prioridade 1 |
| A02 | Ação de prioridade 1 em recarga | Escolhe a 2 |
| A03 | `lowest_hp` com empate em vida | Escolhe a menor posição |
| A04 | Alvo troca de posição antes da execução | A ação atinge quem estiver na posição-alvo |
| A05 | Posição-alvo com Caído | Reescolhe alvo; sem alvo, "sem alvo" |
| A06 | Provocação aplicada após a escolha | Intenção redirecionada e redesenhada |
| A07 | Inimigo atordoado após a escolha | Intenção cancelada |
| A08 | Invocação sem posição livre | Ação não escolhida (condição `free_enemy_slot`) |
| A09 | Mesma semente | Mesmas intenções |
