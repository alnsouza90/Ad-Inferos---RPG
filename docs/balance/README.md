# Tabelas de balanceamento

Todos os números do jogo moram aqui. Formato e campos em `docs/data-schemas.md`. O agente nunca coloca um número no código: se faltar um, ele para e pergunta.

## Arquivos

| Arquivo | Conteúdo | Estado |
| --- | --- | --- |
| `constants.csv` | Regras gerais (Fervor, desolação, Lume, experiência) | Completo para a v1 |
| `saints.csv` | 12 santos | Atributos de todos (proposta) |
| `abilities.csv` + `effects.csv` | Habilidades e seus efeitos | Kits completos dos 12 santos (84 habilidades); leitura fácil em `docs/design/saint-kits.md` |
| `traits.csv`, `camp_skills.csv` | Traços e atividades de Pouso | Os 12 santos |
| `conditions.csv` | 10 condições da v1 | Completo |
| `enemies.csv` + `enemy_actions.csv` | Inimigos e suas ações | Família A (Círculos 2–5) + Enxame invocado |
| `encounters.csv` | Grupos de inimigos | 4 encontros da arena do M0 |
| `provisions.csv` | 5 provisões | Completo |
| `economy.csv`, `facilities.csv` | Custos, recompensas, tempos litúrgicos, instalações | Completo para a v1 |
| `relics.csv` | 25 relíquias aprovadas | Completo; `to_confirm=y` exige pesquisa antes do Martirológio |
| `feasts.csv` | Semana da festa de cada santo | A preencher após a pesquisa |

## Kits: proposta para validar no simulador

Os kits dos 12 santos (nomes, alcances e números) são uma **proposta técnica** feita a partir do GDD v1.1. O que o GDD fixa (milagres, traços, funções, Duelo, Provocação) foi respeitado; o resto deve ser aprovado pelo responsável e calibrado pelo simulador (`docs/testing.md` §5). Só Jorge, Bento e Teresinha entram no M0; os demais são calibrados quando entrarem no jogo.

Contas de referência usadas na proposta:

- Dano básico de um santo de frente: 6–7 por ação. Três santos ≈ 15–18 por rodada.
- Encontro comum fácil (≈ 46 de vida) deve durar 3–4 rodadas; difícil (≈ 90) 5–7 rodadas.
- Um inimigo comum causa 3–6 por ação. A equipe deve terminar um combate fácil com 70–85% da vida.

## Decisões de 03/11/2026

1. Milagres custam no mínimo 3 (todos os 12 estão em 3).
2. Advento: −10 de desolação no início de cada combate (`season_advent_battle_desolation`).
3. Noite Escura: só custo 0; todo conjunto equipado precisa ter ao menos uma habilidade de custo 0.
4. A condição `ward` se chama **Amparo**.
5. Gertrudes entra na afinidade Pais do Monaquismo.

6. Balanceamento da T14: inimigos da Família A com +20% de vida e dano; Sangramento do Moscardo 2; Corrupção da Sombra 3; desolação do Toque da Sombra 10 e do Lamento 8; Vigília no Pouso −20 (era −40). Relatório em `sim-reports/2026-11-03-m0-t14.md`.

## Pontos a confirmar

- Nomes das habilidades passam pelo guia de roteiro (`docs/narrative/writing-guide.md`) antes de irem para a tela.
- Almas Benditas (Gertrudes) passou a agir no início de cada rodada (no início do combate não há condições a remover).

## Como mudar um número

1. Editar o CSV (planilha ou editor de texto; salvar como CSV UTF-8).
2. Rodar o importador (`CLAUDE.md` §5). Ele valida tudo e recusa erros.
3. Rodar os testes e o simulador.
4. Commit com a mensagem `balance: <o que mudou e por quê>`.
