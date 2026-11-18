# O que cada habilidade de Santo Antão faz · conferência para Alan (D-474)

**Por quê:** no cartão, algumas descrições de Antão só contam a história ("Os demônios fogem do sinal da cruz.") e não dizem o que a habilidade faz na luta. Esta tabela é o que o jogo faz hoje, lido de `abilities.csv` e `effects.csv`. Os números não mudaram.

**Posições:** a companhia fica nas posições 1 (frente), 2 e 3 (retaguarda); os inimigos nas posições 1 a 4. "Usa de" é de onde Antão pode usar a habilidade; "Alvo" é quem ela atinge.

| Habilidade | Custo | Usa de | Alvo | O que faz no jogo | Descrição de hoje no cartão |
| --- | --- | --- | --- | --- | --- |
| Sinal da Cruz | 0 | 1, 2, 3 | um inimigo em 1, 2 ou 3 | 6 de dano de **exorcismo** | Os demônios fogem do sinal da cruz. |
| Cajado em Tau | 0 | 1, 2 | um inimigo em 1 ou 2 | 7 de dano de **golpe** | Golpe com o cajado do eremita. |
| Vigília no Deserto | 0 | 1, 2, 3 | o próprio Antão | +8 de desolação nele e 2 fichas de **Força** (cada uma: próxima ação +25%) | Aceita a provação: +8 de desolação e 2 Força. |
| Desprezo do Inimigo | 1 Fervor | 1, 2, 3 | um inimigo em qualquer posição | Retira as fichas positivas do alvo e dá 4 de dano de **exorcismo** | Zomba do demônio: retira as fichas positivas e fere. |
| As Feras do Sepulcro | 2 Fervor | 1, 2 | **todos** os inimigos em 1 e 2 | 7 de dano de **golpe** em cada um | Enfrenta os demônios em forma de fera. |
| Perseverança | 2 Fervor | 1, 2, 3 | o próprio Antão | 2 fichas de **Amparo** (cada uma: próximo dano −50%) e −10 de desolação | 2 Amparo e −10 de desolação. |
| **Milagre:** Combate no Sepulcro | 3 | 1, 2 | **todos** os inimigos | 8 de dano de **exorcismo** em cada um, e Antão recupera 8 de vida | Exorcismo em todos os inimigos; Antão recupera 8 de vida. |

**Traço · Ermitão:** +10% de dano a cada 25 de desolação que Antão carrega, até +40%. Por isso a Vigília no Deserto, que lhe dá desolação, também aumenta o dano dele.

## Proposta para o cartão

Em vez de reescrever as descrições à mão, o cartão mostra, debaixo do nome de cada habilidade, **uma linha de regra montada a partir dos dados** (dano, tipo, alvo, fichas, desolação, cura), seguida da frase da história. Exemplo:

> **Sinal da Cruz** · 6 de exorcismo num inimigo das posições 1 a 3
> *Os demônios fogem do sinal da cruz.*

Assim, os números do cartão são sempre os mesmos da luta, para todos os santos, e mudam sozinhos quando o balanceamento mudar. O cartão fica um pouco mais longo; para caber, as habilidades podem passar para duas colunas.

**O que Alan precisa decidir:**
- se a linha de regra automática serve (recomendado), ou se prefere descrições escritas à mão, uma a uma;
- se alguma habilidade de Antão deve mudar de mecânica. Os números de dano e de desolação seguem para o simulador na T55.
