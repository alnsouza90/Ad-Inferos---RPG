# Especificação · Vila, calendário, economia e progressão

Versão 1.0 · base: GDD v1.1 §3, §6, §7 e §12 · números em `docs/balance/economy.csv`, `facilities.csv` e `constants.csv`

## 1. A semana

- A campanha começa na **semana 1** (1º domingo do Advento) do ano litúrgico de 20 semanas.
- Na vila, o jogador prepara a semana numa tela única ("Planejar a semana") e então parte para uma expedição.
- A semana avança quando a expedição termina (por qualquer motivo) ou quando o jogador faz um **Retiro**.
- **Retiro:** avançar uma semana sem expedição. Permitido no máximo uma vez entre duas expedições.
- Ao virar a semana, nesta ordem: efeitos da Capela e do Jardim → cura de ferimentos → Sufrágios → mudança de tempo litúrgico → eventos da semana (Natal, festa de santo, Conselho pendente).

## 2. Planejar a semana

Uma tela com sugestões automáticas que o jogador apenas confirma ou ajusta:

1. Escolher a equipe (3 santos) e a ordem de posições.
2. Designar santos para a Capela e o Jardim (ficam fora da expedição).
3. Aplicar melhorias de nível e trocar Carismas (Casa de Exercícios).
4. Melhorar equipamentos (Forja) e equipar relíquias.
5. Comprar provisões (Despensa).
6. Pagar leitos da Enfermaria.
7. Escolher o círculo e o ponto de partida (Portão ou Pouso consagrado).

Sugestões automáticas: santos com ferimento grave ou desolação ≥ 100 são sugeridos para Jardim ou descanso; provisões sugeridas pelo histórico do círculo.

## 3. Instalações

| Instalação | Desbloqueio | Nível 1 | Nível 2 | Nível 3 |
| --- | --- | --- | --- | --- |
| Capela | Inicial | 1 vaga de oração | 2 vagas | 3 vagas |
| Enfermaria | Inicial | 1 leito | 2 leitos | 3 leitos |
| Despensa | Inicial | Provisões básicas | Preços −15% | Preços −30% |
| Portão | Inicial | 8 espaços; revela 1 camada | 10 espaços; 2 camadas | 12 espaços; trecho inteiro |
| Casa de Exercícios | Após o Prólogo | Aplica melhorias de nível | Troca de Carisma −50% | Troca de Carisma grátis |
| Forja | Após o Prólogo | Equipamento até nível 2 | Até nível 3 | Melhorias −20% |
| Biblioteca | Após o Círculo 3 | Resistências dos inimigos | + conteúdo dos nós | + fases dos chefes |
| Carmelo | Após o Círculo 3, por [carmel_cost] (1.500) | Ver §5 | — | — |
| Relicário | Após o Círculo 4 | Equipar relíquias raras | — | Fundir 2 sacramentais iguais em 1 aprimorado (+50% do efeito) |
| Jardim | Após o Círculo 5 | 1 vaga | 2 vagas | 3 vagas |

Custo de melhoria: nível 2 = [facility_l2_cost] (1.500); nível 3 = [facility_l3_cost] (2.500).

## 4. Designação semanal

| Lugar | Efeito por semana |
| --- | --- |
| Capela | +[chapel_suffrages] (3) Sufrágios; −15 de desolação |
| Jardim | −50 de desolação |

O santo designado não participa da expedição da semana. Não há bônus por afinidade com o guardião.

## 5. Carmelo e Moradas

- A construção desbloqueia **São João da Cruz** e concede a **Morada 1**.
- Cada círculo concluído (chefe vencido pela primeira vez) depois da construção concede a Morada seguinte, até a 7ª.
- Benefícios cumulativos, para toda a companhia:

| Morada | Benefício [constante] |
| --- | --- |
| 1 | Recolhimento: +5% de chance no teste de Fé |
| 2 | Resistência à desolação: ganho × 0,95 |
| 3 | Recuperação: Vigília −10 adicionais |
| 4 | Proteção espiritual: Corrupção aplicada −1 pilha |
| 5 | Comunidade: +5% de vida máxima |
| 6 | Preparação: +1 espaço de provisão |
| 7 | Intercessão: +1 Sufrágio por santo na Capela |

As Moradas acendem as sete janelas do Carmelo na vila (efeito do motor).

## 6. Calendário litúrgico

| Tempo | Semanas | Efeitos |
| --- | --- | --- |
| Advento | 1–2 | Provisões −20%; santos começam cada combate com −10 de desolação  |
| Natal | 3–4 | Ferimentos curam em dobro; evento de Natal; **São Nicolau de Mira entra na semana 3** |
| Tempo Comum I | 5–8 | Neutro |
| Quaresma | 9–12 | Desolação × 1,25; Sufrágios × 1,5; Exorcismo × 1,10 |
| Páscoa | 13–16 | +1 de Fervor na primeira rodada; evento de Páscoa |
| Tempo Comum II | 17–20 | Semana 18: Todos os Santos (+25% de experiência); semana 19: Finados (Sufrágios × 2) |

**Advento** (confirmado em 03/11/2026): "começar o combate com consolação" significa −10 de desolação no início de cada combate, não o estado de Consolação.

**Festas dos santos:** na semana da festa de um santo jogável, ele ganha +50% de experiência e começa cada combate com −10 de desolação. As semanas de festa ficam em `docs/balance/feasts.csv`, convertendo a data litúrgica real para o tempo correspondente do ano de 20 semanas (a preencher após a pesquisa do Martirológio).

## 7. Economia

- **Esmolas:** única moeda gasta. Fontes em `expedition.md` §8.
- **Sufrágios:** nunca gastos.

| Item | Custo em Esmolas |
| --- | --- |
| Instalação nível 2 / 3 | 1.500 / 2.500 |
| Equipamento nível 2 / 3 | 300 / 800 |
| Leito da Enfermaria por semana | 300 |
| Carmelo | 1.500 |
| Troca de Carisma | 150 |
| Pão / Vela / Água Benta / Ataduras / Incenso | 15 / 20 / 30 / 25 / 35 |

## 8. Ferimentos

| Tipo | Penalidade | Cura natural | Com leito |
| --- | --- | --- | --- |
| Leve | −10% em um atributo (sorteado entre `max_hp` e `faith`) | 1 semana | — |
| Grave | −20% em `max_hp` e `faith` | 3 semanas | 1 semana |

Um santo ferido pode ir à expedição com a penalidade. Ferimentos não se acumulam além de um grave: novo grave renova a contagem.

## 9. Progressão dos santos

| Nível | Experiência acumulada [xp_thresholds] | Ganho |
| --- | --- | --- |
| 1 | 0 | Kit inicial |
| 2 | 40 | Atributos + 1 melhoria de habilidade |
| 3 | 100 | Atributos + 1 melhoria + Carismas |
| 4 | 180 | Atributos + 1 melhoria + 2º espaço de relíquia |
| 5 | 280 | Atributos + milagre aprimorado |

- Ganho de atributos por nível em `saints.csv` (`hp_per_level`, `faith_per_level`).
- **Melhoria de habilidade:** escolher uma habilidade ainda não melhorada; ela passa à versão `+`. Sem custo em Esmolas; aplicada na Casa de Exercícios.
- **Regra geral da versão `+`** (vale quando o campo `upgrade` de `abilities.csv` está vazio): o primeiro efeito com número ganha +30%, arredondando meio para cima, com mínimo de +1 (desolação negativa conta pelo valor absoluto); se a habilidade não tiver número, a primeira condição aplicada ganha +1 pilha; `hp_fraction` ganha +0,1. O custo em Fervor nunca muda. O milagre aprimorado do nível 5 segue a mesma regra.
- **Carismas (nível 3):** o santo escolhe um; cada Carisma troca até 2 habilidades e o traço por variantes. Troca paga na Casa de Exercícios.
- **Equipamento:** 2 espaços por santo (Instrumento e Hábito), próprios do santo, 3 níveis melhorados na Forja. Instrumento: +10% de dano/cura por nível acima do 1. Hábito: +8% de vida máxima por nível acima do 1.
- **Relíquias:** 1 espaço (2 no nível 4). Lista e efeitos em `relics.csv`.

## 10. Desbloqueio de santos

| Santo | Desbloqueio |
| --- | --- |
| Jorge, Bento, Teresinha | Início |
| Nicolau de Mira | Semana 3 (Natal) |
| Antão, Joana, Pio, Rita, Antônio, Sebastião | Conclusão dos Círculos 2 a 7, respectivamente |
| João da Cruz | Construção do Carmelo |
| Gertrudes | Marco 3 da trilha do Purgatório |

## 11. Trilha do Purgatório

- Sufrágios acumulados (nunca gastos). Um marco a cada [suffrages_per_milestone] (8); marco 10 em 80.
- Recompensas em `docs/gdd/gdd-v1.1.md` §7.

## 12. Casos de teste obrigatórios

| # | Cenário | Esperado |
| --- | --- | --- |
| V01 | Retiro duas vezes seguidas | Segundo recusado |
| V02 | Santo na Capela na semana 10 (Quaresma) | +4,5 → arredondar para 5 Sufrágios (meio para cima) |
| V03 | Semana 19 com 2 santos na Capela | 12 Sufrágios |
| V04 | Carmelo construído após o Círculo 3; Círculos 4 a 9 concluídos | Morada 7 |
| V05 | Ferimento grave com leito | Curado na semana seguinte |
| V06 | Chegar à semana 3 | Nicolau de Mira disponível |
| V07 | 3 marcos de Sufrágios (24) | Gertrudes disponível |
| V08 | Experiência 100 | Nível 3; Carismas liberados |
