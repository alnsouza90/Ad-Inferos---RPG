# Bandeiras de história e de campanha

Lista das bandeiras que o jogo grava (`narrative-system.md` §5). Toda bandeira nova entra aqui no mesmo PR que a cria.

- **Bandeiras narrativas:** seguem o formato `cNN_descricao` e só servem para abrir ou fechar falas e eventos futuros.
- **Bandeiras de campanha:** marcam o avanço do jogador e ficam no save.

## Campanha

| Bandeira | Quem grava | Quando | Para que serve |
| --- | --- | --- | --- |
| `prologue_done` | Prólogo (T51) | Ao fim do Prólogo | Pular o Prólogo nas próximas vezes e abrir a vila |
| `circle_02_completed` | Expedição | Na primeira vitória sobre Asmodeu | Esmolas da primeira conclusão; liberar Santo Antão (D-417, T50) |
| `circle_02_camp_1`, `circle_02_camp_2` | Expedição | Ao chegar a cada Pouso, na expedição inteira | Pousos consagrados: começar a próxima expedição ali (D-435). Não se perdem na derrota |

O padrão vale para os outros círculos: `circle_NN_completed` e `circle_NN_camp_N`.

## Narrativas do Círculo 2

Nenhuma ainda. Os dois Encontros (o casal e Helena) e a Tentação "O abrigo do vento" mudam virtudes e o Domínio, mas não gravam bandeira. A primeira deve vir com os flashbacks, no M3.
