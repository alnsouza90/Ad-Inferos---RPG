# Especificação · Desolação e Consolação

Versão 1.0 · base: GDD v1.1 §5 · números em `docs/balance/constants.csv`

A desolação é a pressão espiritual de cada santo. Nenhum estado representa pecado ou perda de santidade; o santo nunca perde o controle das próprias ações.

## 1. Escala

- Cada santo tem `desolation` inteira de 0 a 200, persistente entre combates e entre expedições.
- Estados possíveis: `normal`, `consolation`, `dark_night`. A `prostration` é um evento, não um estado duradouro.

## 2. Ganho de desolação

Todo ganho passa por esta fórmula:

```text
ganho = arredondar_meio_para_cima(valor_base × mult_lume × mult_afinidade × mult_relíquias × mult_estado × mult_tempo_litúrgico)
```

| Multiplicador | Valor |
| --- | --- |
| `mult_lume` | Lume 75–100: [light_high_desolation_mult] (0,8) · 25–74: 1,0 · 0–24: [light_low_desolation_mult] (1,3). Só durante expedições |
| `mult_afinidade` | Afinidade do Carmelo ativa: 0,85 |
| `mult_relíquias` | Ex.: Sino de Santo Antão 0,9 |
| `mult_estado` | Consolação: [consolation_desolation_mult] (0,5) |
| `mult_tempo_litúrgico` | Quaresma: 1,25 |

Reduções (valores negativos) não passam pelos multiplicadores.

### 2.1 Fontes

| Fonte | Valor base [constante] | Quando |
| --- | --- | --- |
| Fim de combate comum vencido | [desolation_battle_end_common] (12) | Em todos os santos que participaram |
| Fim de combate de elite | [desolation_battle_end_elite] (20) | Idem |
| Fim de combate de chefe | [desolation_battle_end_boss] (35) | Idem |
| Ação inimiga espiritual | Definido no efeito `desolation` do inimigo | No alvo |
| Corrupção | 3 por pilha, no tick | No portador |
| Aliado caído | [desolation_ally_fallen] (15) | Nos aliados vivos; **não** se a queda foi Prostração |
| Tentação mal resolvida | Definido no evento | Nos santos da equipe |
| Retirada de emergência | [desolation_emergency_retreat] (25) | Em todos |

As fontes em combate são **adicionais** às de fim de combate. A calibragem do M0 deve manter a meta de `docs/testing.md` (Noite Escura em 0,5 a 1,5 santo por expedição longa).

### 2.2 Recuperação

| Fonte | Valor [constante] |
| --- | --- |
| Vigília no Pouso | −[desolation_vigil] (20; era 40 até 03/11/2026) |
| Água Benta | −[holy_water_desolation] (15) e remove Corrupção |
| Habilidades (Teresinha, Bento, João da Cruz...) | Definido em `abilities.csv` |
| Capela, por semana | −[chapel_desolation_per_week] (15) |
| Jardim, por semana | −[garden_desolation_per_week] (50) |

O valor nunca fica abaixo de 0.

## 3. Limiar de 100: teste de Fé

Quando a desolação de um santo em estado `normal` passa de menos de 100 para 100 ou mais:

1. O teste é feito imediatamente, depois do efeito que causou o ganho (dentro da fila de efeitos, se em combate).
2. Chance de Consolação:

```text
chance = mínimo([faith_check_cap] (60%), [faith_check_base] (10%) + [faith_check_per_point] (4%) × faith + bônus de relíquias, traços e Moradas)
```

3. Sorteio pelo fluxo `faith` do `RngStream`.
4. **Sucesso → Consolação:** desolação vai a [consolation_reset_value] (50); estado `consolation`.
5. **Falha → Noite Escura:** estado `dark_night`; a desolação continua no valor atual.

A interface mostra a chance ao lado da barra a partir de [faith_chance_display_threshold] (75) de desolação.

## 4. Estados

### 4.1 Consolação

- Efeito: dano e cura causados × [consolation_output_mult] (1,15); ganho de desolação × 0,5.
- Termina ao voltar à vila ou se a desolação voltar a 100 (nesse caso, o santo perde a Consolação e faz novo teste de Fé).

### 4.2 Noite Escura

- O santo não pode usar habilidades com custo maior que 0, nem o milagre. Mantém habilidades de custo 0, movimento, provisões e todos os traços passivos. Todo conjunto equipado tem pelo menos uma habilidade de custo 0 (`combat.md` §2.5), então o santo sempre tem o que fazer.
- Persiste entre combates, expedições e semanas.
- Termina quando a desolação cai abaixo de [dark_night_exit_threshold] (50): gera **Purificação**.

### 4.3 Purificação

- Evento instantâneo ao sair da Noite Escura.
- Concede +[purification_xp_bonus] (25%) de experiência ao santo até o fim da expedição atual (ou da próxima, se ocorrer na vila).
- Efeitos de relíquia ligados à Purificação disparam aqui.

## 5. Limiar de 200: Prostração

Quando a desolação chega a 200, em qualquer estado:

- **Em combate:** o santo fica Caído sem possibilidade de levantar até o fim do combate; ferimento grave; desolação vai a [prostration_reset_value] (150). Os aliados **não** ganham desolação de aliado caído.
- **Fora de combate:** ferimento grave; desolação vai a 150.
- O estado anterior (normal, Consolação ou Noite Escura) é mantido; a Consolação, se houver, é perdida.

## 6. Eventos gerados

`desolation_changed(saint, old, new, source)`, `faith_check(saint, chance, success)`, `state_changed(saint, old_state, new_state)`, `purification(saint)`, `prostration(saint)`.

A tela usa esses eventos para a barra, a auréola (`docs/art/asset-pipeline.md` §6) e as falas.

## 7. Casos de teste obrigatórios

| # | Cenário | Esperado |
| --- | --- | --- |
| D01 | Santo com 90 recebe 12 com Lume 80 | Ganho 10 (12 × 0,8 = 9,6 → 10); vai a 100; teste de Fé |
| D02 | Fé 5, semente que sorteia 0,29 | Chance 30%: sucesso; desolação 50; Consolação |
| D03 | Fé 5, semente que sorteia 0,31 | Falha; Noite Escura |
| D04 | Fé 15 (relíquias) | Chance limitada a 60% |
| D05 | Noite Escura e desolação cai de 60 para 45 | Purificação; estado normal |
| D06 | Consolação e ganho de 20 | Recebe 10 |
| D07 | Desolação 195 recebe 10 em combate | Prostração; desolação 150; ferimento grave; aliados sem ganho de aliado caído |
| D08 | Redução de 40 com Lume 10 | Reduz 40 (multiplicadores não se aplicam) |
| D09 | Desolação 30 recebe −40 | Fica em 0 |
| D10 | Noite Escura tenta milagre | Rejeitado (`combat.md` C05) |
