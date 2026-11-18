# T43 · Narrativa do Círculo 2: roteiro de trabalho com Alan

Onde a tarefa começa e onde termina, peça por peça. Cada peça é um rascunho do agente; Alan corrige e aprova, e só então ela entra no jogo. As regras de todo texto estão em `docs/narrative/writing-guide.md`: origem indicada, nada inventado sobre santos, orações ou citações, sem os nomes do poema nas almas criadas pelo jogo.

## As peças, na ordem

| # | Peça | Onde entra | Situação |
| --- | --- | --- | --- |
| 1 | Encontro com alma 1: "Os que o vento não separa" (o casal) | `c02_soul_lovers` | **Feito e aprovado** (D-447) |
| 2 | Encontro com alma 2: Helena | Mesmo cenário das almas | **Feito e aprovado** (D-461, D-462): texto, prancha de Alan em pixel, figura animada |
| 3 | Tentação nova | — | **Fora** (D-462): o Círculo 2 fica só com "O abrigo do vento" |
| 4 | Falas curtas de São Cristóvão no Portão | Relatório da semana (D-262) e anúncio do santo que chega (D-458) | **Aprovado** (D-463): `ui_text.csv`, `christopher_*` |
| 5 | Ficha breve de Santo Antão para o cartão de novo santo (T50) | Vida em poucas linhas; a origem de cada dado vai para o Martirológio | **Texto aprovado** (D-464); retrato e figura em pixel com Alan |
| 5b | Falas das Elites e do chefe durante a luta | Vertigem, Minos e Asmodeu, em balão | **Feito** (D-466): textos em `ui_text.csv` (`line_*`), balão `BattleLine` |
| 5c | Apresentação da vila | Fala e instrução de cada guardião | **Texto aprovado** (D-468); a tela é a T49. Pendente: fala do guardião do Jardim (D-469) e a do Portão ajustada ao papel novo |
| 5d | Cena da Porta do Inferno e do Anjo da Guarda | Abertura do Círculo 1 (M3) | Fica para o M3: o Prólogo termina na beira do abismo, olhando a porta |
| 6 | `docs/narrative/flags.md` | Lista das bandeiras de história usadas pelos eventos | **Feito** |
| 7 | Motor da cena (`story`) | Usado pelos eventos e pelo Prólogo (T51) | **Feito**: `EventScreen.setup_story` |

## Começa e termina

- **Começa** na peça 2. A peça 1 já está pronta e serve de modelo de tamanho e tom.
- **Termina** quando as peças 2 a 5 estão aprovadas por Alan, os textos estão nos arquivos `docs/narrative/events/circle_02/*.yaml` e `game/data/events/`, e os casos de `narrative-system.md` §8 passam nos testes.

## Como trabalhar cada peça

1. Alan diz a ideia em poucas linhas, ou escolhe entre 2 ou 3 propostas do agente.
2. O agente escreve o rascunho completo, com páginas, opções, resultados e origem, num arquivo `docs/design/rascunho-*.md`, como no Encontro do casal.
3. Alan corrige. O agente aplica as correções até a aprovação.
4. O agente põe o texto no jogo, roda os testes e registra a decisão na memória.
