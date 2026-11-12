# Especificação · Expedição

Versão 1.2 (12/11/2026: Provação do Círculo, §10.1; Lume, Esmolas e Escalada marcados com as decisões da consultoria) · versão 1.1 (04/11/2026: caminhada e bifurcações, §2.3; simplificações do M1, §13) · base: GDD v1.1 §4, §8 e §12 · números em `docs/balance/constants.csv` e `economy.csv`

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
- **Como o gerador monta o trecho (D-132):** cada camada tem 3 nós com chance [map_three_nodes_chance] (50%), senão 2. Cada nó liga ao nó mais próximo da camada seguinte (o caminho reto) e, com chance [map_second_link_chance] (50%), também a um vizinho desse nó; as ligações nunca se cruzam. Nó sem entrada recebe uma ligação do nó mais próximo da camada anterior. Os papéis (combate, Tentação, variável) são distribuídos de modo que todo caminho cumpra §2.1; depois o tipo de cada nó variável é sorteado.
- **Modelo fixo de reserva:** `docs/balance/map_templates.csv` (`data-schemas.md` §3.15).

### 2.1 Restrições por caminho

O gerador cria o trecho e verifica **todos os caminhos possíveis**; se algum violar as restrições, gera de novo (máximo de [map_generation_retries] (50) tentativas; depois, usa o modelo fixo de reserva do círculo).

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
- Incenso revela o conteúdo de **mais uma camada** além do que o Portão já mostra, nos nós ligados às entradas da bifurcação atual (D-129). Com o Portão nível 1: o conteúdo dos nós que vêm depois das entradas. O que foi revelado fica conhecido até o fim do trecho (D-137).

### 2.3 Caminhada interativa e bifurcações (D-207, D-121, D-158, D-178, D-184 a D-186)

A expedição é vista como uma **caminhada lateral**: os santos andam por um corredor (da esquerda para a direita), como em Darkest Dungeon. O mapa de nós continua existindo por baixo (§2.1) e é ele que define as escolhas; o corredor é a forma de mostrá-lo. No M2 a caminhada passa a ser **interativa**: o jogador anda com o dedo, encontra o conteúdo do nó no caminho e entra nas bifurcações andando até elas.

**Um corredor por nó.** Cada nó em que a equipe entra tem o seu corredor:

```text
[começo] ── andar ── [conteúdo do nó] ── andar ── [bifurcação: entradas da próxima camada]
```

- O corredor que sai do Portão (ou de um Pouso consagrado, no começo da expedição) não tem conteúdo: só leva à bifurcação da camada 1.
- Pouso (§6), Vigília (§7) e chefe não têm corredor próprio: entrar neles abre direto a tela do Pouso, a da Vigília ou o combate com o chefe. Depois do Pouso, a equipe segue para o corredor que leva à camada 1 do trecho seguinte.

**Regras da caminhada**

1. **Andar.** Segurar o dedo na metade direita do corredor anda para a frente; na metade esquerda, para trás; soltar para (D-178). Os botões da tela não contam como corredor. A velocidade segue a preferência de animação (1× ou 2×; "instantâneo" anda a 2×).
2. **Andar não tem regra.** Não gasta Lume, não sorteia nada, não muda o estado e não entra no log de comandos.
3. **Voltar.** Só até o começo do corredor atual; nunca a um nó já visitado, porque o mapa só anda para a frente (D-186). Conteúdo já resolvido fica como cenário (tenda vazia, baú aberto) e pode ser atravessado nos dois sentidos.
4. **Conteúdo do nó no caminho** (D-184, D-185). Ao chegar ao conteúdo, a equipe para sozinha e não passa adiante enquanto ele não for resolvido:

| Nó | No corredor | Ao chegar |
| --- | --- | --- |
| `node_battle`, `node_elite` | Inimigos fora de vista | O combate começa sem toque, com os inimigos chegando como em Darkest Dungeon (D-185) |
| `node_temptation` | Tenda (ou o objeto da Tentação do círculo) | Botões **Entrar** (abre o evento) e **Passar ao largo** (aplica a primeira opção `safe: true` do evento, com o mesmo custo; `narrative-system.md` §4.1) |
| `node_relic` | Baú ou relicário fechado | Botão **Abrir**. Relíquia guardada (§3): os guardiões chegam e o combate começa; a relíquia vem depois da vitória |
| `node_soul` | A alma parada no caminho | Botão **Falar** (abre o Encontro); não há como passar sem falar |

   Começar o conteúdo é um comando registrado no log (`EngageNode`: combate, Entrar, Abrir, Falar), e Passar ao largo também (`PassBy`). Entre `ChoosePath` e esse comando, o nó fica **entrado, com conteúdo pendente**: o Lume já caiu, e o conteúdo e a semente do combate não mudam se o jogador andar, voltar ou fechar o app.

5. **Bifurcação no fim do corredor.** As **entradas** da próxima camada ficam espalhadas no trecho final: uma para cada nó ligado ao nó atual. O caminho que **segue reto** fica no fim do corredor; os **desvios** (porta, caverna, escada...) ficam nas paredes antes dele. Quando só há uma ligação, aparece só o caminho reto.
6. **O que se vê de cada entrada.** O ícone e o nome do tipo de nó, sempre (§2.2); o conteúdo segue a regra do Portão e o Incenso.
7. **Entrar.** Parado diante de uma entrada, o painel mostra o que se sabe do nó (a pré-visualização) e o botão **Entrar**. Tocar em Entrar é o comando `ChoosePath`, registrado no log: Lume −5 (§4), salvamento (`save-load.md` §4) e a equipe passa ao corredor do nó escolhido.
8. **Provisões.** Com a equipe parada e fora de combate, o jogador pode usar provisões em qualquer ponto do corredor (§5).
9. **Mini-mapa.** Um botão no corredor abre o trecho inteiro: todos os nós com o tipo, as ligações, o caminho já percorrido e a posição atual; o conteúdo segue §2.2. O mini-mapa só mostra: a escolha é feita nas entradas do corredor (D-128).
10. **Aparência.** Porta e caverna só aparecem em trecho com **parede de rocha** ao fundo; em trecho aberto, os desvios são **escada** ou **passagem tipo portal** (D-220). Qual entrada é o caminho reto, o desenho de cada desvio e o tamanho do corredor são só apresentação: a tela escolhe a partir do ID do nó, sem usar o RNG das regras, para sempre parecer igual ao retomar o jogo. O Lume também aparece na luz do cenário (mais escuro com Lume baixo), sem efeito de regra.
11. **Retomada.** A posição da equipe no corredor fica guardada no save como dado de apresentação (`save-load.md` §3.1), fora do log. Fechar o app no corredor volta ao mesmo ponto, com o mesmo estado; fechar diante de um conteúdo ainda não resolvido volta diante dele, com os mesmos botões.

**No M1** (D-121, D-149) a caminhada era um deslize automático: o conteúdo do nó era resolvido logo depois de `ChoosePath` e as entradas eram tocadas (primeiro toque mostra, segundo confirma), sem andar até elas.

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
| 75–100 | Chance de emboscada no Pouso × 0,5; desolação × [light_high_desolation_mult] (1,0 desde D-164; não reduz mais) |
| 25–74 | Neutro |
| 0–24 | Desolação × 1,3; inimigos causam +10% de dano; Esmolas × 1,5; peso de relíquia oculta × 2 nos nós variáveis gerados a partir daí |

**Aprovado, a simular (D-262, D-273, D-274, D-289; `docs/backlog/m2.md` T61):** as faixas acima continuam em vigor até Alan escolher uma das **cinco variantes** do Lume pelo relatório: (a) desolação ao andar no escuro; (b) faixa de Escuridão; (c) efeito da faixa mostrado na tela; (d) −7 por nó; (e) **"luz é ver"**: a faixa muda o quanto a companhia vê das intenções (alta: as desta rodada e um aviso da próxima; média: como hoje; baixa: um inimigo sem o alvo mostrado). As **Esmolas × 1,5 no escuro saem** (D-274); o prêmio do escuro passa a ser de outro tipo (o simulador testa experiência +25% ou +50%). Se a variante "luz é ver" for a escolhida, entram "Erguer a lamparina" (F-13) e, no M3, o **portador da lanterna** (D-289).

## 5. Provisões

- Espaços pelo nível do Portão: [gate_slots_l1] (8), [gate_slots_l2] (10), [gate_slots_l3] (12). Cada espaço guarda **uma unidade**.
- Compradas na Despensa antes da partida (preços em `economy.csv`). Não usadas voltam ao estoque da vila.
- Em combate: no máximo 1 por turno da equipe, sem gastar ação.

| Provisão | Em combate | Fora de combate |
| --- | --- | --- |
| Pão | Cura [bread_heal] (5); no Círculo 3, suspende a Fome naquele combate | Só para descansar no Pouso (1 por equipe) |
| Vela | — | +25 de Lume |
| Água Benta | Remove Corrupção; −15 de desolação | Idem |
| Ataduras | Remove Sangramento | — (o Sangramento acaba com o combate; D-136) |
| Incenso | — | Revela mais uma camada à frente (§2.2) ou anula emboscada no Pouso |

## 6. Pouso

Ao chegar ao `node_camp`:

1. O Pouso é consagrado e as Esmolas carregadas ficam **garantidas**.
2. O jogador escolhe: **descansar** (custa 1 Pão), **seguir sem descansar** ou **retirada planejada**.
3. Se descansar, cada santo escolhe uma atividade:

| Atividade | Efeito |
| --- | --- |
| Vigília | −[desolation_vigil] (20) de desolação no próprio santo |
| Partilha | Cura [share_heal_pct] (30%) da vida máxima de um aliado (outro santo, nunca o próprio; D-144) |
| Oração | +1 de Fervor inicial no próximo combate (somando as Orações, no máximo +2); a emboscada deste Pouso conta como próximo combate (D-143) |
| Atividade própria | Definida em `saints.csv` (`camp_skill`) |

4. Depois das atividades, sorteio de emboscada: [ambush_chance] (25%), multiplicada pelo Lume e pela atividade própria (Guarda de Jorge); se a emboscada acontecer e a equipe levar Incenso, ela é anulada e o Incenso é gasto. Emboscada = combate comum do trecho seguinte, iniciado com a equipe como está; as Esmolas dela ficam garantidas ao voltar ao Pouso.

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
- Lume 0–24: × 1,5 (sai quando a variante do Lume for escolhida, D-274).
- Revisitas: § 11.
- Esmolas ganhas ficam "não garantidas" até chegar a um Pouso ou terminar a expedição com o chefe vencido. Na história, é o ouro negado aos pobres que a companhia **restitui**; ele só vira Esmola ao ser consagrado no Pouso, e o abismo o toma de volta na derrota (D-266 (1), D-279). Nomes sugeridos na tela: "Despojos" antes do Pouso e "Esmolas" depois (a aprovar em `ui_text.csv`).
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

### 10.1 A Provação do Círculo (D-266, D-267)

Os pecados de cada círculo agem como **assédio dos inimigos**, nunca como pecado dos santos. A mecânica de ambiente da tabela acima e o assédio são **um conceito só**, a Provação do Círculo, com três regras fixas:

1. **É visível antes**, como intenção de ambiente ou condição com contagem.
2. **Tem uma resposta ativa do santo, com custo** (ex.: o Pão na Fome, trocar de lugar nos Túmulos, Exorcismo no Contrapasso, o milagre no Torpor; no Vendaval, uma resposta comum a definir na T38, além da Clausura de Bento).
3. **Resistir dá prêmio:** quando a companhia responde à provação, ganha uma ficha de **Firmeza** (proposta: +1 de Fervor na rodada seguinte, dentro do limite de ganho extra; número a aprovar na T38).

- O **Pecado Encarnado** (elite do círculo) aplica a provação com força, numa ação própria. No Círculo 2, o **Encanto** da Vertigem puxa as intenções para um santo: ele sofre o assédio, não peca.
- O **chefe** cobra a mesma lição como prova final.
- O santo **nunca** peca nem perde o controle das próprias ações (`desolation.md`, `writing-guide.md`). Tudo vem de fora e é visível.
- A **tenda da Tentação não muda** (D-141, D-184): continua sendo o eco da tentação do Peregrino, com escolha (`narrative-system.md` §4.1).
- Ações, números e textos do Círculo 2 em `docs/specs/bosses.md` (T38, aprovados por Alan). Nos outros círculos, cada Provação é revista quando o círculo for especificado (ex.: no Ouro Maldito, recusar as Esmolas do nó como resposta, ligada à renúncia de Mamom).

## 11. Revisitas e Escalada

> **Corte aprovado (D-290, M3):** a Escalada e o retorno decrescente das Esmolas saem. No lugar: em qualquer revisita, o jogador pode assumir **penitências** por vontade própria (`village-economy.md` §6, D-288), e as Esmolas seguem uma regra só (proposta: revisita paga metade, a simular com a economia). O texto abaixo fica só como referência até a especificação nova, no M3; nada dele foi implementado.

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
| E15 | Segurar para andar para trás no começo do corredor | A equipe não sai do lugar; nenhum comando no log |
| E16 | Andar o corredor inteiro para a frente e para trás antes de entrar numa bifurcação | Lume e estado iguais; nenhum comando no log |
| E17 | Chegar aos inimigos de um `node_battle` | O combate começa sem toque; a equipe não passa do ponto sem vencer |
| E18 | Chegar à tenda e escolher Passar ao largo | Mesmo efeito da primeira opção `safe: true` do evento (no "Abrigo do vento", −5 de Lume); o evento não abre; um comando no log |
| E19 | Abrir uma relíquia guardada | Combate começa; a relíquia só é entregue depois da vitória |
| E20 | Chegar a uma alma e tentar seguir sem Falar | A equipe não passa |
| E21 | Fechar e reabrir o app no meio do corredor e diante de uma tenda | Mesma posição, mesmo estado; diante da tenda, os mesmos botões; nenhum comando novo no log |
| E22 | Parar diante de um desvio e tocar em Entrar | Painel mostra o que se sabe do nó; Entrar = `ChoosePath` (Lume −5, salvamento) |

## 13. Simplificações do M1 (protótipo de trecho)

Valem só no M1 (`docs/backlog/m1.md`); o M2 volta à regra completa.

| Regra completa | No M1 | Decisão |
| --- | --- | --- |
| Expedição de 3 trechos, Vigília e chefe (§1) | Só o trecho 1 e o Pouso; depois do Pouso, a expedição termina com um resumo | Backlog do M1 |
| Provisões compradas na Despensa (§5) | Kit fixo em `docs/balance/starting_kits.csv`: 2 Pães, 1 Vela, 2 Águas Bentas, 1 Ataduras e 1 Incenso (7 dos 8 espaços do Portão nível 1) | D-123 |
| Nível do Portão definido pela vila | Portão nível 1 | Backlog do M1 |
| Nó variável: elite, relíquia ou combate (§2.1) | Só relíquia ou combate, com os pesos [node_weight_relic] (35) e [node_weight_battle] (25); nenhum elite | D-124 |
| Todas as relíquias de nó | Vela da Candelária, Cruz em tau e Crucifixo de madeira (`relics.csv`) | D-124 |
| Relíquia encontrada | O jogador escolhe na hora um santo com espaço livre (1 espaço por santo até o nível 4, [relic_slots_start]); o efeito vale já no trecho. Sem espaço, vai para a mochila sem efeito até a vila | D-146 |
| Encontros do círculo (§3) | Combates do trecho com os encontros `m0_easy_*`; emboscada do Pouso com `m0_hard_*` | Backlog do M1 |
| Ordem da equipe | Cada combate começa na ordem em que o anterior terminou (vale também depois do M1) | D-134 |
| Saída do Pouso (§6) | Seguir ou retirada planejada encerram o trecho, com as Esmolas garantidas | Backlog do M1 |
| Experiência (§8) e ferimentos (§9) | Ferimentos ficam registrados no estado, sem efeito; sem experiência | Backlog do M1 |
| Mecânica de ambiente do Círculo 2 (§10) | Sem Vendaval | Backlog do M1 |
