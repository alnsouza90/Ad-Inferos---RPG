# Especificação · Combate

Versão 1.0 · base: GDD v1.1 §2 e §12 · números em `docs/balance/`

Esta especificação é a referência de implementação do combate. Os termos seguem `docs/glossary.md`. Todo número citado como `[constante]` vem de `docs/balance/constants.csv`.

## 1. Visão geral

- Turno de equipe: os santos agem (no máximo uma vez cada, na ordem que o jogador quiser), depois os inimigos executam as intenções anunciadas, depois o ambiente do círculo age.
- Determinístico: habilidades sempre acertam; não há atributo de Precisão; críticos só por efeito explícito (ADR-0003).
- Sem Desfazer: a pré-visualização de alvo mostra o resultado antes da confirmação.

## 2. Formação

### 2.1 Posições

- Santos: posições 1, 2 e 3. A posição 1 (vanguarda) é a mais próxima do centro da tela.
- Inimigos: posições 1 a 4. A posição 1 é a mais próxima do centro.
- Inimigos grandes têm `size` 2 ou 3 e ocupam posições consecutivas; sua posição-âncora é a de menor número. Um ataque a qualquer posição ocupada por eles os atinge uma vez.

### 2.2 Movimento voluntário

- Comando `SwapSlots(actor, direction)`: o santo troca de lugar com o aliado adjacente (posição ±1).
- **Gasta a ação do santo que se move.** O aliado deslocado não gasta ação e mantém o estado de "já agiu" ou "não agiu".
- É permitido trocar com um aliado Caído (o corpo é deslocado).
- Um santo Atordoado não pode se mover.

### 2.3 Movimento forçado

- `push(n)`: move o alvo `n` posições para trás, trocando sucessivamente com quem estiver atrás. Para na última posição.
- `pull(n)`: idem, para a frente.
- `swap_with_adjacent`: troca o alvo com um vizinho (direção definida no efeito).
- Inimigos com `size` > 1 ignoram movimento forçado, salvo efeito que diga o contrário.
- Movimento forçado não gasta ação de ninguém.

### 2.4 Quando alguém sai do combate

- **Inimigo morto:** é removido; os inimigos atrás avançam e a fila se fecha. Exceções definidas em dados (`leaves_remains: true`) deixam um "resto" que ocupa a posição por `remains_rounds` rodadas.
- **Santo Caído:** permanece na posição; não pode ser alvo de inimigos nem de habilidades de dano; pode ser alvo de cura e de movimento.

### 2.5 Garantia contra turno morto

- Validação de dados (o importador rejeita): **todo santo tem pelo menos uma habilidade básica de custo 0 utilizável de qualquer posição** entre as 6 disponíveis.
- Regra de equipamento (decisão de 03/11/2026): o jogador **não pode** confirmar um conjunto de 4 habilidades sem ao menos uma de custo 0. Assim, um santo em Noite Escura (§4.2, item 6) sempre tem o que usar.

## 3. Estrutura da rodada

```text
ROUND_START
  1. Fervor +[fervor_per_round] (máx. [fervor_cap])
  2. Inimigos escolhem intenções (docs/specs/enemy-ai.md)
  3. Condições com momento "início da rodada"
PARTY_TURN
  4. Condições com momento "início do turno" dos santos
  5. Jogador executa comandos até EndPartyTurn
ENEMY_TURN
  6. Para cada inimigo, da posição 1 à 4:
     a. condições com momento "início do turno" desse inimigo
     b. executa sua intenção (ou nada, se Atordoado ou sem alvo)
HAZARD
  7. Efeito de ambiente do círculo (se houver)
ROUND_END
  8. Decaimento das condições de duração
  9. Contagem de Caídos (§8)
 10. Verifica vitória e derrota
```

O combate começa em `ROUND_START` da rodada 1 com Fervor 0 (portanto a equipe age com [fervor_per_round] na primeira rodada).

## 4. Turno da equipe

### 4.1 Comandos válidos

| Comando | Efeito | Gasta ação |
| --- | --- | --- |
| `UseAbility(actor, ability, target)` | Executa a habilidade | Sim |
| `UseMiracle(actor, target)` | Executa o milagre do santo | Sim |
| `SwapSlots(actor, direction)` | §2.2 | Sim |
| `Pass(actor)` | Nada | Sim |
| `UseProvision(provision, target, actor)` | Usa uma provisão da expedição; `actor` é o santo que aplica (importa para o traço de Nicolau de Mira) e **não** gasta a ação dele | Não; limite de [provisions_per_turn] por turno de equipe |
| `EndPartyTurn` | Encerra o turno; santos que não agiram perdem a ação | — |
| `RetreatBattle` | Retirada de emergência (não disponível contra chefe) | — |

**Comandos aprovados, ainda não especificados** (entram com os números aprovados; nada implementado):

| Comando | Decisão | Ideia | Quando |
| --- | --- | --- | --- |
| Interceder | D-268 | Ação comum de todo santo, ao lado de Trocar e Passar; gasta a ação, sem Fervor; toma para si desolação ou uma condição de um aliado (`desolation.md` §8). Na tela, um fio de ouro liga os dois santos | T61 e T62 |
| Dar a Consolação | D-285 | O santo em Consolação a dá a um companheiro, gastando a ação (`desolation.md` §8) | T61 e T62 |
| Súplica | D-283 | Um santo que ficou na Capela socorre a companhia uma vez, sem gastar a vez de ninguém nem Fervor (`village-economy.md` §4) | M3 |
| Firmar o pé (resposta comum ao Vendaval) | D-267 | Resposta ativa à Provação do Círculo 2 (`expedition.md` §10.1) | T38 |

### 4.2 Validações de `UseAbility` e `UseMiracle`

Rejeitar o comando, sem alterar o estado, se qualquer item falhar:

1. Estado é `PARTY_TURN`.
2. O santo está vivo, não Caído, não Atordoado e ainda não agiu nesta rodada.
3. A habilidade está equipada (ou é o milagre do santo).
4. A posição atual do santo está em `use_slots` da habilidade.
5. Há Fervor suficiente.
6. O santo não está em Noite Escura, ou a habilidade custa 0.
7. O alvo é válido segundo `targeting` (§6).
8. Restrições de uso: `once_per_battle` ainda não usado.

### 4.3 Resolução

1. Debitar o Fervor.
2. Marcar o santo como "já agiu".
3. Enfileirar os efeitos da habilidade na ordem dos dados.
4. Processar a fila (§7). Efeitos podem enfileirar novos efeitos (contra-ataques, gatilhos de traço).
5. Registrar o comando e os eventos.

## 5. Fervor

| Regra | Valor |
| --- | --- |
| Ganho no início de cada rodada | [fervor_per_round] (3) |
| Máximo acumulado | [fervor_cap] (6) |
| Ganho extra por rodada (habilidades, traços, Afinidade) | no máximo [fervor_bonus_cap_per_round] (2); o excedente é perdido |
| Sobra entre rodadas | Acumula até o máximo |
| Entre combates | Volta a 0 |

O contador de ganho extra zera a cada `ROUND_START`. O ganho base da rodada não conta para esse limite.

## 6. Alvos

### 6.1 Regras de alvo (`targeting`)

| Valor | Significado |
| --- | --- |
| `self` | O próprio santo |
| `ally` | Um aliado vivo (inclui o próprio, se `allow_self`) |
| `ally_fallen` | Um aliado Caído (efeitos de levantar) |
| `all_allies` | Todos os aliados não Caídos |
| `enemy` | Um inimigo em `target_slots` |
| `enemy_group` | Todos os inimigos em `target_slots` |
| `all_enemies` | Todos os inimigos |
| `chosen_enemy_slots(n)` | O jogador escolhe `n` posições inimigas diferentes |

### 6.2 Provocação e Duelo

- **Provocação** (`taunt`): enquanto um santo tiver a ficha, as intenções inimigas de **alvo único** passam a mirá-lo, desde que ele esteja nas posições que a ação inimiga alcança. As intenções são recalculadas e exibidas no momento em que a ficha é aplicada.
- **Duelo** (`duel`, assinatura de São Jorge): ver `docs/specs/conditions.md` §5.

### 6.3 Intenções e posições

A intenção de um inimigo mira uma **posição**, não um santo. Se o santo mudar de lugar, quem estiver na posição recebe a ação. Se a posição tiver um Caído ou estiver fora do alcance, a IA escolhe outro alvo válido na hora da execução (`enemy-ai.md` §4); sem alvo válido, a intenção falha e a tela mostra "sem alvo".

## 7. Efeitos e fila

### 7.1 Tipos de efeito (versão 1)

| Tipo | Parâmetros | Resultado |
| --- | --- | --- |
| `damage` | `amount`, `damage_type` (`strike`/`exorcism`/`untyped`), `multiplier_vs` (opcional: `{elite: 2.0, boss: 2.0}`) | §9 |
| `heal` | `amount` | §10 |
| `revive` | `hp_fraction` | Levanta um Caído com essa fração da vida máxima |
| `apply_condition` | `condition_id`, `stacks` | `conditions.md` |
| `remove_condition` | `condition_id` ou `polarity: negative`, `count` | |
| `strip_positive_tokens` | `count` | Remove fichas positivas do alvo |
| `move` | `kind` (`push`/`pull`/`swap`), `n` | §2.3 |
| `gain_fervor` | `amount` | Respeita o limite extra (§5) |
| `desolation` | `amount` (positivo aumenta, negativo reduz) | `desolation.md` |
| `summon` | `enemy_id`, `max_alive` | Só inimigos; ocupa a primeira posição vazia |
| `self_damage` | `amount` ou `hp_fraction` | Custo de vida (ex.: Estigmas) |

Qualquer efeito pode trocar o alvo da habilidade com `target_override`: `self` (o usuário), `all_allies` ou `all_enemies`. Assim uma habilidade pode, por exemplo, ferir um inimigo e curar a equipe (Estigmas, Chama Viva de Amor).

### 7.2 Ordem

- Efeitos são resolvidos na ordem em que aparecem no dado.
- Em efeitos de grupo, os alvos são processados da posição 1 para a 4.
- Efeitos disparados (contra-ataque, gatilho de traço) entram no fim da fila.
- Limite de segurança: 64 efeitos por comando; acima disso, abortar a fila e registrar erro.

## 8. Queda, levantar e derrota

- Vida chega a 0: o santo fica **Caído**. Perde todas as fichas positivas; condições negativas permanecem.
- Um Caído pode ser levantado por qualquer `heal` ou `revive` dentro de [fallen_revive_window] rodadas (2). A contagem começa no `ROUND_END` da rodada em que caiu.
- Esgotada a janela, o santo fica **fora de combate** até o fim da luta e não pode mais ser levantado.
- **Prostração** (`desolation.md`) também deixa o santo Caído, sem possibilidade de levantar.
- Um santo Caído ou fora de combate gera desolação nos aliados ([desolation_ally_fallen]), **exceto quando a causa é Prostração**.
- **Derrota:** no fim de qualquer comando ou etapa, se nenhum santo puder agir (todos Caídos ou fora de combate).
- **Fim do combate:** quem terminou Caído ou fora de combate volta com 1 de vida e ferimento leve; se já tinha caído antes na mesma expedição, ferimento grave. Prostração sempre gera ferimento grave.

## 9. Fórmula de dano

Para cada alvo:

```text
valor = amount
valor ×= tipo        → 1.25 se o alvo é vulnerável ao tipo, 0.75 se é resistente, 1.0 caso contrário
                        (Corpóreo: vulnerável a strike, resistente a exorcism;
                         Espiritual: o contrário; untyped e santos: 1.0)
valor ×= multiplier_vs → se o efeito tiver multiplicador para a categoria do alvo (elite, chefe)
valor ×= força       → 1.25 se o atacante tem a ficha Força (consumida uma vez por ação, não por alvo)
valor ×= duelo       → 1.25 se o atacante é São Jorge e o alvo está em Duelo com ele
valor ×= fúria       → 1 + 0.10 × pilhas de Fúria do atacante
valor ×= afinidade   → bônus de Afinidade do tipo de dano (§12)
valor ×= relíquia    → bônus de relíquias do atacante
valor ×= lume        → 1.1 se o atacante é inimigo e o Lume está entre 0 e 24 (expedition.md §4)
valor ×= amparo      → 0.5 se o alvo tem a ficha Amparo (consumida por golpe recebido)
dano = arredondar_meio_para_cima(valor) − armor do alvo
dano = máximo(dano, 1)   se amount > 0
```

- Todos os multiplicadores são aplicados juntos sobre o valor real (sem arredondar no meio) e o arredondamento acontece uma única vez, ao final.
- `armor` é o atributo Proteção (inteiro, 0 a 3). A ficha que reduz o próximo golpe à metade chama-se **Amparo** (`ward`).
- `untyped` é usado por inimigos contra santos e por efeitos de ambiente.

**Exemplo:** Lança do Dragão (12, Golpe, ×2 contra elite) num elite Corpóreo com armor 1, Jorge com Força: 12 × 1.25 × 2 × 1.25 = 37,5 → 38 − 1 = **37**.

## 10. Cura

```text
cura = arredondar_meio_para_cima(amount × modificadores)
hp = mínimo(hp + cura, max_hp)
```

Cura em um Caído dentro da janela o levanta com `cura` de vida.

## 11. Fim do combate

| Resultado | Condição | Próximo passo |
| --- | --- | --- |
| Vitória | Nenhum inimigo vivo (incluindo invocados) | Recompensas e desolação de fim de combate (`expedition.md`, `desolation.md`) |
| Derrota | §8 | `expedition.md` §9 |
| Retirada | Comando `RetreatBattle` aceito | `expedition.md` §9 |

Ao fim do combate: Fervor volta a 0; condições de combate são removidas; estados de desolação (Consolação, Noite Escura) permanecem até a regra própria removê-los.

## 12. Afinidades

> **Aprovado para o M3 (D-286, D-291):** as Afinidades fixas viram o ponto de partida dos **Laços** (santos da mesma família começam com Laço 1); o Laço nasce entre quaisquer dois santos e cresce com gestos de um pelo outro. Até a especificação nova, as Afinidades abaixo continuam valendo como estão programadas e testadas; a troca precisa de migração dos testes e do save.

Verificadas no `SETUP`. Ativas quando pelo menos dois membros da afinidade estão na equipe (Caídos contam).

| Afinidade | Membros | Bônus [constante] |
| --- | --- | --- |
| `carmel` | João da Cruz, Teresinha | Desolação recebida × [affinity_carmel_desolation_mult] (0,85) |
| `franciscans` | Antônio de Pádua, Padre Pio | +[affinity_franciscan_first_round_fervor] (1) Fervor na rodada 1 (conta no limite extra) |
| `monastics` | Antão, Bento, Gertrudes* | Exorcismo × [affinity_monastic_mult] (1,10) |
| `soldiers` | Jorge, Joana, Sebastião | Golpe × [affinity_soldier_mult] (1,10) |

\* Gertrudes incluída por decisão de 03/11/2026 (Helfta seguia a Regra de São Bento, com costumes cistercienses).

## 13. Traços e Carismas

- Traços são gatilhos declarados em dados: `on_battle_start`, `on_round_start`, `on_ability_used`, `on_damage_dealt`, `on_damaged`, `on_ally_fallen`, `on_fallen` etc.
- Contadores próprios de traço (ex.: pétalas de Teresinha) ficam no `Combatant` como `trait_counters: Dictionary`, não como condições.
- Carismas, simplificados (D-272, D-281): o kit atual é o primeiro Carisma; o segundo troca **o traço e uma habilidade** por variantes declaradas em dados e abre no nível 3. No M0 a M2 não há Carismas; as variantes de cada santo são definidas antes do M3 (`docs/design/saint-kits.md` §3).
- Os kits completos dos 12 santos estão em `docs/balance/abilities.csv` e, em leitura fácil, em `docs/design/saint-kits.md`.

## 14. Mecânicas de ambiente dos círculos

Executadas na etapa `HAZARD`. O M0 usa uma arena sem ambiente. Regras completas em `docs/specs/expedition.md` §10 (implementação a partir do M2). Cada mecânica é também a **Provação do Círculo** (§10.1, D-267): visível, com resposta ativa do santo e prêmio por resistir (ficha Firmeza).

## 15. Pré-visualização

Antes da confirmação de um comando, o controlador oferece `preview(cmd) -> Array[PreviewEntry]`, que executa a resolução sobre uma **cópia** do estado e devolve, para cada alvo: dano ou cura final, condições aplicadas/removidas, movimento, e intenções canceladas. A pré-visualização nunca altera o estado real.

## 16. Casos de teste obrigatórios

| # | Cenário | Esperado |
| --- | --- | --- |
| C01 | Santo usa habilidade fora de `use_slots` | Comando rejeitado; estado inalterado |
| C02 | Santo tenta agir duas vezes na rodada | Segundo comando rejeitado |
| C03 | Fervor 6 no fim do turno + início da rodada | Continua 6 |
| C04 | Ganhos extras de 3 Fervor numa rodada | Só 2 entram |
| C05 | Noite Escura tenta habilidade de custo 1 | Rejeitado; de custo 0, aceito |
| C06 | `SwapSlots` com aliado que já agiu | Troca feita; ator gasta ação; aliado continua "já agiu" |
| C07 | Inimigo da posição 2 morre | Inimigos 3 e 4 avançam para 2 e 3 |
| C08 | Intenção mira a posição 1; santo da posição 1 troca com o da 2 | A ação atinge quem está na posição 1 ao executar |
| C09 | Intenção mira posição com santo Caído | IA retarget; sem alvo válido, "sem alvo" |
| C10 | Exemplo da §9 | Dano 37 |
| C11 | Ataque de 1 contra alvo com armor 3 | Dano 1 |
| C12 | Força e ataque em grupo de 3 alvos | Força consumida uma vez; bônus em todos os alvos |
| C13 | Amparo e ataque de 2 golpes | Ficha consumida no primeiro golpe |
| C14 | Santo Caído recebe cura na janela | Levanta com a cura |
| C15 | Santo Caído há 2 rodadas no ROUND_END | Fora de combate; cura não o levanta |
| C16 | Prostração | Caído sem levantar; aliados não ganham desolação de aliado caído |
| C17 | Três santos Caídos | Derrota imediata |
| C18 | Mesma semente e mesmos comandos, duas execuções | Estados finais idênticos |
| C19 | `preview` seguido de `execute` | Resultados idênticos; preview não alterou estado |
| C20 | Fila de efeitos com laço de contra-ataque | Abortada em 64 efeitos com erro registrado |
