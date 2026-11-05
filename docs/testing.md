# Plano de testes

Versão 1.0 · ADR-0006

## 1. Tipos de teste

| Tipo | Onde | O que cobre | Quando roda |
| --- | --- | --- | --- |
| Unidade | `game/tests/unit/<sistema>/` | Uma regra de `core/` isolada | A cada mudança |
| Integração | `game/tests/integration/` | Combate inteiro, expedição inteira, salvar e carregar | A cada mudança |
| Dados | `game/tests/unit/data/` | Validação do importador sobre os CSVs reais | A cada mudança nos CSVs |
| Simulação | `game/tools/sim/` | Milhares de combates sem tela para medir equilíbrio | Antes de fechar um marco e após mexer em números |
| Manual | Celular Android | Toque, leitura, desempenho, sensação | Fim de cada marco |

## 2. Regras

- Toda regra de `docs/specs/` tem pelo menos um teste. Os casos numerados nas especificações (C01, K01, D01, A01, E01, V01, N01, S01...) são **obrigatórios** e o nome do teste começa pelo código (`test_C07_vulnerable_damage`).
- Testes nunca dependem de arquivos de `game/data/`: usam definições criadas no próprio teste por construtores auxiliares em `game/tests/helpers/`. Exceção: os testes de dados.
- Todo teste com aleatoriedade fixa a semente.
- Teste de unidade roda em menos de 50 ms; a suíte inteira em menos de 60 s.
- Nenhum commit com teste falhando (`CLAUDE.md` §10).

## 3. Comandos

Ver `CLAUDE.md` §5.

## 4. Teste de determinismo

Para cada encontro do M0: rodar o mesmo combate duas vezes com a mesma semente e a mesma lista de comandos; o estado final serializado deve ser **idêntico byte a byte**. É a base do salvamento por log (ADR-0005).

## 5. Simulador de balanceamento

`run_sim.gd` joga combates com uma política automática e grava um relatório em `game/tools/out/sim_<data>.csv` e um resumo no terminal.

### 5.1 Políticas

| Política | Comportamento |
| --- | --- |
| `random` | Escolhe uma ação válida qualquer |
| `greedy` | Escolhe a ação com maior dano imediato |
| `heuristic` | Cura abaixo de 40% de vida, reduz desolação acima de 80, senão maior dano; usa milagre quando pode |

### 5.2 Métricas e metas do M0

| Métrica | Meta |
| --- | --- |
| Rodadas por combate fácil / difícil (heurística) | 3–4 / 5–7 |
| Vitória da heurística em combate fácil / difícil | ≥ 95% / 75–90% |
| Vitória da política `random` em combate difícil | ≤ 40% (a decisão importa) |
| Vida restante média após combate fácil | 70–85% |
| Turnos em que um santo não tinha nenhuma ação útil | < 5% |
| Participação de cada habilidade equipada nas ações da heurística | Nenhuma acima de 40% (sem estratégia dominante) |
| Noite Escura numa sequência de 6 combates (expedição longa simulada) | 0,5 a 1,5 santo |

O relatório lista as métricas fora da meta. O agente propõe ajustes de números, mas **quem aprova é o responsável**.

### 5.3 Simulador do trecho (M1)

`run_sim.gd -- --mode=leg --runs=N` joga trechos inteiros com o `ExpeditionController` (T31): caminhos sorteados, políticas de §5.1 nos combates e escolhas simples de provisões, Tentação, relíquia e Pouso (`tools/sim/leg_simulator.gd`). Grava `tools/out/leg_<data>.csv`, uma linha por trecho.

| Métrica | Meta |
| --- | --- |
| Vitória da heurística em combate difícil, medida nos combates difíceis dentro de trechos simulados (no M1, as emboscadas do Pouso) | 75–90% (D-125); recalibrada no M2 com os combates reais do trecho 2 (D-164) |
| Santos em Noite Escura por trecho 1 (heurística) | 0,02–0,10 (D-126, D-164) |
| Vitória da heurística em combate fácil dentro de trechos | ≥ 95% |

A meta "Noite Escura numa expedição longa" (0,5–1,5) de §5.2 volta no M2 (D-126).

## 6. Teste manual no Android (fim de cada marco)

- [ ] Instala e abre em um aparelho de entrada (2 GB de RAM) e em um intermediário.
- [ ] 60 quadros por segundo em combate no intermediário; mínimo 30 no de entrada.
- [ ] Fechar o app no meio do turno e reabrir: volta ao mesmo ponto.
- [ ] Todos os botões alcançáveis com os polegares; nenhum toque perdido.
- [ ] Texto legível no tamanho padrão a 30 cm.
- [ ] Sem textos em inglês ou IDs aparecendo na tela.
