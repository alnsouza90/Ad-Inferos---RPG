# Especificação · Expedição

Versão 1.1 (04/11/2026: caminhada e bifurcações, §2.3; simplificações do M1, §13) · base: GDD v1.1 §4, §8 e §12 · números em `docs/balance/constants.csv` e `economy.csv`

## 1. Estrutura

```text
Portão → Trecho 1 (4 camadas) → Pouso → Trecho 2 (4 camadas) → Pouso → Trecho 3 (3 camadas) → Vigília → Chefe
```

- Uma expedição é sempre de um círculo.
- A expedição termina por: chefe vencido, retirada (planejada ou de emergência) ou derrota.
- Pousos alcançados ficam **consagrados**: a próxima expedição ao mesmo círculo pode começar no último Pouso consagrado.

## 2. Geração do mapa

- Fluxo `map` do RNG, semente derivada da semente da campanha + círculo + número da expedição.
- Cada trecho tem camadas; cada camada tem 2 ou 3 nós; todo nó de uma camada liga-se a pelo menos um nó da camada seguinte e todo nó é alcançável.
- O jogador visita exatamente um nó por camada.

### 2.1 Restrições por caminho

O gerador cria o trecho e verifica **todos os caminhos possíveis**; se algum violar as restrições, gera de novo (máximo de 50 tentativas; depois, usa o modelo fixo de reserva do círculo).

| Trecho | Camadas | Todo caminho contém |
| --- | --- | --- |
| 1 | 4 | 2 combates; 1 Tentação; 1 nó variável |
| 2 | 4 | 2 combates; o **Encontro com a alma** do círculo (camada única de um só nó, na camada 3); 1 nó variável |
| 3 | 3 | 2 combates; 1 nó variável |

- Nó variável: elite, relíquia oculta ou combate, sorteado com pesos [node_weight_elite] (40), [node_weight_relic] (35), [node_weight_battle] (25).
- No máximo um elite por caminho em cada trecho.

### 2.2 Visibilidade

- **O tipo de todo nó é sempre visível.**
- O **conteúdo** (família de inimigos, tipo de recompensa) é revelado conforme o nível do Portão: nível 1 revela a próxima camada; nível 2, as duas próximas; nível 3, o trecho inteiro. A Biblioteca revela também resistências e a segunda fase dos chefes.
- Incenso revela o conteúdo de **mais uma camada** além do que o Portão já mostra, nos nós ligados às entradas da bifurcação atual (D-129). Com o Portão nível 1: o conteúdo dos nós que vêm depois das entradas.

### 2.3 Caminhada e bifurcações (D-207, D-121)

A expedição é vista como uma **caminhada lateral**: os santos andam por um corredor (da esquerda para a direita), como em Darkest Dungeon. O mapa de nós continua existindo por baixo (§2.1) e é ele que define as escolhas; o corredor é a forma de mostrá-lo.

1. **Corredor.** Entre um ponto e o seguinte (Portão → camada 1, nó → próxima camada, última camada → Pouso), a equipe percorre um corredor. Andar não tem regra: não gasta Lume, não sorteia nada e não muda o estado.
2. **Bifurcação.** No fim do corredor aparecem as **entradas** da próxima camada: uma para cada nó ligado ao nó atual (do Portão, todos os nós da camada 1). Uma das entradas é o caminho que **segue reto**; as outras são **desvios** (porta, caverna, escada...). Quando só há uma ligação, aparece só o caminho reto.
3. **O que se vê de cada entrada.** O ícone do tipo de nó, sempre (§2.2). O conteúdo segue a regra do Portão: com nível 1, como as entradas são a próxima camada, o conteúdo delas aparece.
4. **Escolher.** Tocar numa entrada mostra o que se sabe dela; o segundo toque confirma. Confirmar é um comando registrado no log (`ChoosePath`). A equipe entra no nó: Lume −5 (§4), salvamento (`save-load.md` §4) e conteúdo do nó.
5. **Depois do nó.** Vencido o combate, terminado o evento ou recolhida a relíquia, a equipe volta ao corredor rumo à próxima camada. Depois da última camada do trecho, o corredor leva só ao Pouso.
6. **Aparência.** Qual entrada é o caminho reto e qual desenho tem cada desvio é só apresentação: a tela escolhe a partir do ID do nó, sem usar o RNG das regras, para sempre parecer igual ao retomar o jogo.
7. **Mini-mapa.** Um botão no corredor abre o trecho inteiro: todos os nós com o tipo, as ligações, o caminho já percorrido e a posição atual; o conteúdo segue §2.2. O mini-mapa só mostra: a escolha é feita nas entradas do corredor (D-128).
8. **Provisões no corredor.** Na bifurcação, antes de escolher, o jogador pode usar provisões fora de combate (§5).
9. **Retomada.** Fechar o app no corredor volta à bifurcação em que a equipe estava, com o mesmo estado.

## 3. Tipos de nó

| Nó | Conteúdo |
| --- | --- |
| `node_battle` | Encontro comum do círculo (`encounters.csv`, grupo fácil no trecho 1, difícil nos trechos 2 e 3) |
| `node_elite` | Guardião ou Pecado Encarnado do círculo, com escolta |
| `node_temptation` | Evento de Tentação (`narrative-system.md`) |
| `node_soul` | Encontro com a alma (narrativa, sem combate) |
| `node_relic` | Relíquia; [relic_node_guarded_chance] (30%) de estar guardada por um combate comum |
| `node_camp` | Pouso (§6) |
| `node_vigil` | Vigília antes do chefe (§7) |
| `node_boss` | Chefe do círculo |

## 4. Lume

| Regra | Valor |
| --- | --- |
| Início de expedição | [light_start] (100) |
| Retomada de Pouso consagrado | [light_resume] (75) |
| Ao entrar em cada nó | −[light_per_node] (5) |
| Vela | +[candle_light] (25), máximo 100 |

| Faixa | Efeito |
| --- | --- |
| 75–100 | Chance de emboscada no Pouso × 0,5; desolação × 0,8 |
| 25–74 | Neutro |
| 0–24 | Desolação × 1,3; inimigos causam +10% de dano; Esmolas × 1,5; peso de relíquia oculta × 2 nos nós variáveis gerados a partir daí |

## 5. Provisões

- Espaços pelo nível do Portão: [gate_slots_l1] (8), [gate_slots_l2] (10), [gate_slots_l3] (12). Cada espaço guarda **uma unidade**.
- Compradas na Despensa antes da partida (preços em `economy.csv`). Não usadas voltam ao estoque da vila.
- Em combate: no máximo 1 por turno da equipe, sem gastar ação.

| Provisão | Em combate | Fora de combate |
| --- | --- | --- |
| Pão | Cura [bread_heal] (5); no Círculo 3, suspende a Fome naquele combate | Necessário para descansar no Pouso (1 por equipe) |
| Vela | — | +25 de Lume |
| Água Benta | Remove Corrupção; −15 de desolação | Idem |
| Ataduras | Remove Sangramento | Idem |
| Incenso | — | Revela mais uma camada à frente (§2.2) ou anula emboscada no Pouso |

## 6. Pouso

Ao chegar ao `node_camp`:

1. O Pouso é consagrado e as Esmolas carregadas ficam **garantidas**.
2. O jogador escolhe: **descansar** (custa 1 Pão), **seguir sem descansar** ou **retirada planejada**.
3. Se descansar, cada santo escolhe uma atividade:

| Atividade | Efeito |
| --- | --- |
| Vigília | −[desolation_vigil] (20) de desolação no próprio santo |
| Partilha | Cura [share_heal_pct] (30%) da vida máxima de um aliado |
| Oração | +1 de Fervor inicial no próximo combate (somando as Orações, no máximo +2) |
| Atividade própria | Definida em `saints.csv` (`camp_skill`) |

4. Depois das atividades, sorteio de emboscada: [ambush_chance] (25%), multiplicada pelo Lume; anulada por Incenso (consumido). Emboscada = combate comum do trecho seguinte, iniciado com a equipe como está.

## 7. Vigília (antes do chefe)

- Não exige Pão, não há emboscada e não consagra.
- Cada santo escolhe Vigília ou Partilha.

## 8. Recompensas

| Fonte | Esmolas base [economy.csv] |
| --- | --- |
| Combate comum | 70 |
| Elite | 160 |
| Relíquia oculta | 40 + relíquia |
| Chefe | 300 |
| Conclusão do círculo (primeira vez) | 200 |

- Multiplicador por faixa de círculo: Círculos 0–3 × 1,0; 4–6 × 2,2; 7–9 × 3,6.
- Lume 0–24: × 1,5.
- Revisitas: § 11.
- Esmolas ganhas ficam "não garantidas" até chegar a um Pouso ou terminar a expedição com o chefe vencido.
- Experiência: [xp_battle] (10) por combate comum, 20 por elite, 40 por chefe, para cada santo que participou; santos na reserva da vila recebem 50% do total da expedição.

## 9. Retirada e derrota

| Situação | Quando | Consequência |
| --- | --- | --- |
| Retirada planejada | No Pouso | Sem custo; mantém Esmolas; a semana avança |
| Retirada de emergência | Comando `RetreatBattle` em combate, exceto chefe | Perde 50% das Esmolas não garantidas; +25 de desolação e ferimento leve em cada santo |
| Derrota | Três santos caídos | Perde as Esmolas não garantidas e as relíquias encontradas nesta expedição; ferimento grave em todos; Pousos consagrados mantidos |

## 10. Mecânicas de ambiente dos círculos (a partir do M2)

Executadas na etapa `HAZARD` do combate, salvo indicação.

| Círculo | Mecânica | Regra |
| --- | --- | --- |
| 0 Antinferno | Indecisão | Santo que usou `Pass` ou não agiu na rodada recebe +5 de desolação |
| 2 Luxúria | Vendaval | No `ROUND_START`, sortear duas posições de santos adjacentes e mostrar como intenção de ambiente; no `HAZARD`, trocá-las. Clausura de Bento impede a troca de quem está ao lado dele |
| 3 Gula | Fome | Cura recebida × 0,5 até a equipe usar um Pão naquele combate |
| 4 Avareza | Ouro Maldito | Ao receber Esmolas em um nó, cada santo ganha +5 de desolação |
| 5 Ira e Acídia | Fúria e Torpor | Condições `fury` (inimigos) e `torpor` (santos). Torpor não se aplica na luta contra Belfegor |
| 6 Heresia | Túmulos | No `ROUND_START`, uma posição de santo é marcada (RNG `battle`); no `HAZARD`, quem estiver nela recebe 8 de dano `untyped` |
| 7 Violência | Contrapasso | Cada ação de Golpe aplica 1 Sangramento em quem a desferiu; Exorcismo não |
| 8 Fraude | Intenções veladas | Uma intenção inimiga por rodada aparece como "?", exceto com Santo Antônio na equipe, Lume ≥ 75 ou Biblioteca nível 3 |
| 9 Traição | Congelamento | Condição `freeze` |

## 11. Revisitas e Escalada

- Revisitar um círculo concluído não altera a narrativa nem as virtudes do Peregrino.
- Retorno decrescente das Esmolas no mesmo círculo e nível de Escalada, dentro do mesmo tempo litúrgico: 100%, 75%, 50%, 25% (mínimo). Zera quando o tempo litúrgico muda.
- Escalada (níveis cumulativos, recompensa +25% por nível; níveis 3 e 5 dão relíquia exclusiva):

| Nível | Modificador |
| --- | --- |
| 1 | Inimigos +15% de vida |
| 2 | Lume −10 por nó |
| 3 | Elites em dobro (dois nós variáveis viram elite) |
| 4 | O Pouso intermediário não consagra |
| 5 | Chefe com uma fase extra |

## 12. Casos de teste obrigatórios

| # | Cenário | Esperado |
| --- | --- | --- |
| E01 | Gerar 1.000 mapas com sementes diferentes | Todos os caminhos de todos os mapas cumprem §2.1 |
| E02 | Entrar em 11 nós sem Vela | Lume 45 no chefe |
| E03 | Retomada de Pouso consagrado | Começa com Lume 75 |
| E04 | Comprar 9 provisões com Portão nível 1 | Recusado no 9º item |
| E05 | Descansar sem Pão | Opção indisponível |
| E06 | Duas Orações no Pouso | +2 de Fervor no próximo combate; três Orações também dão +2 |
| E07 | Emboscada com Incenso | Anulada; Incenso consumido |
| E08 | Retirada de emergência com 300 Esmolas não garantidas | Perde 150 |
| E09 | Derrota | Pousos consagrados mantidos |
| E10 | 3ª revisita no mesmo tempo litúrgico | Esmolas × 0,5 |
| E11 | Bifurcação depois de um nó com 2 ligações | Duas entradas, uma reta e um desvio, com o tipo dos dois nós ligados; nenhuma entrada para nós não ligados |
| E12 | Andar pelo corredor e voltar à bifurcação sem escolher | Lume e estado iguais; nenhum comando no log |
| E13 | Fechar e reabrir o app na bifurcação | Mesma bifurcação, mesmas entradas, mesmo estado |
| E14 | Usar Incenso na bifurcação com Portão nível 1 | Conteúdo dos nós ligados às entradas revelado; Incenso consumido |

## 13. Simplificações do M1 (protótipo de trecho)

Valem só no M1 (`docs/backlog/m1.md`); o M2 volta à regra completa.

| Regra completa | No M1 | Decisão |
| --- | --- | --- |
| Expedição de 3 trechos, Vigília e chefe (§1) | Só o trecho 1 e o Pouso; depois do Pouso, a expedição termina com um resumo | Backlog do M1 |
| Provisões compradas na Despensa (§5) | Kit fixo, num CSV de `docs/balance/`: 2 Pães, 1 Vela, 2 Águas Bentas, 1 Ataduras e 1 Incenso (7 dos 8 espaços do Portão nível 1) | D-123 |
| Nível do Portão definido pela vila | Portão nível 1 | Backlog do M1 |
| Nó variável: elite, relíquia ou combate (§2.1) | Só relíquia ou combate, com os pesos [node_weight_relic] (35) e [node_weight_battle] (25); nenhum elite | D-124 |
| Todas as relíquias de nó | Vela da Candelária, Cruz em tau e Crucifixo de madeira (`relics.csv`) | D-124 |
| Encontros do círculo (§3) | Combates do trecho com os encontros `m0_easy_*`; emboscada do Pouso com `m0_hard_*` | Backlog do M1 |
| Experiência (§8) e ferimentos (§9) | Ferimentos ficam registrados no estado, sem efeito; sem experiência | Backlog do M1 |
| Mecânica de ambiente do Círculo 2 (§10) | Sem Vendaval | Backlog do M1 |
