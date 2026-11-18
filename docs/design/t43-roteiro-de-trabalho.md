# T43 · Narrativa do Círculo 2: roteiro de trabalho com Alan

Onde a tarefa começa e onde termina, peça por peça. Cada peça é um rascunho do agente; Alan corrige e aprova, e só então ela entra no jogo. As regras de todo texto estão em `docs/narrative/writing-guide.md`: origem indicada, nada inventado sobre santos, orações ou citações, sem os nomes do poema nas almas criadas pelo jogo.

## As peças, na ordem

| # | Peça | Onde entra | Situação |
| --- | --- | --- | --- |
| 1 | Encontro com alma 1: "Os que o vento não separa" (o casal) | `c02_soul_lovers` | **Feito e aprovado** (D-447) |
| 2 | Encontro com alma 2: Helena | Mesmo cenário das almas | **Feito e aprovado** (D-461, D-462): texto, prancha de Alan em pixel, figura animada |
| 3 | Tentação nova | — | **Fora** (D-462): o Círculo 2 fica só com "O abrigo do vento" |
| 4 | Falas curtas de São Cristóvão no Portão | Relatório da semana (D-262) e anúncio do santo que chega (D-458) | A fazer: 3 a 5 frases |
| 5 | Ficha breve de Santo Antão para o cartão de novo santo (T50) | Vida em poucas linhas, com a origem de cada dado (fato, tradição, lenda) | A fazer: Alan confere as fontes |
| 5b | Falas das Elites e do chefe durante a luta | Vertigem, Minos e Asmodeu: 2 a 4 frases curtas cada, nos momentos fortes (começo, troca de fase, vida baixa, derrota). Precisa de um sistema de falas na luta (parte técnica) | A fazer: pedido de Alan (18/11) |
| 5c | Apresentação da vila | Uma fala curta de cada guardião no seu prédio (GDD §6: Santo Agostinho e Santa Mônica, Cosme e Damião, Santa Isabel, São Cristóvão, Santo Inácio, Santo Elói, Santo Tomás, Santa Teresa d'Ávila, Santa Helena); os não liberados com aviso (D-459) | A fazer: pedido de Alan (18/11) |
| 5d | Cena da Porta do Inferno e do Anjo da Guarda | Abertura do Círculo 1 (M3) | Fica para o M3: o Prólogo termina na beira do abismo, olhando a porta |
| 6 | `docs/narrative/flags.md` | Lista das bandeiras de história usadas pelos eventos | Técnica: o agente faz |
| 7 | Motor da cena (`story`) | Usado pelos eventos e pelo Prólogo (T51) | Técnica: o agente faz depois dos textos |

## Começa e termina

- **Começa** na peça 2. A peça 1 já está pronta e serve de modelo de tamanho e tom.
- **Termina** quando as peças 2 a 5 estão aprovadas por Alan, os textos estão nos arquivos `docs/narrative/events/circle_02/*.yaml` e `game/data/events/`, e os casos de `narrative-system.md` §8 passam nos testes.

## Como trabalhar cada peça

1. Alan diz a ideia em poucas linhas, ou escolhe entre 2 ou 3 propostas do agente.
2. O agente escreve o rascunho completo, com páginas, opções, resultados e origem, num arquivo `docs/design/rascunho-*.md`, como no Encontro do casal.
3. Alan corrige. O agente aplica as correções até a aprovação.
4. O agente põe o texto no jogo, roda os testes e registra a decisão na memória.
