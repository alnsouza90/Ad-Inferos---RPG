# Especificação · Elites, chefe e encontros do Círculo 2

Versão 1.0 (15/11/2026, T38) · base: GDD v1.1 §8, `enemy-ai.md` §6, `expedition.md` §10 e §10.1, decisões D-175, D-219, D-267, D-284 e D-393

Escopo: o Guardião (Minos), o Pecado Encarnado (Vertigem) e o chefe (Asmodeu) do Círculo 2; a Provação do Círculo 2 completa (Vendaval, Firmar o pé, Encanto, Firmeza); o Domínio de Asmodeu; os encontros comuns do círculo.

**Números:** tudo o que está entre colchetes, como [minos_max_hp], é **proposta** a aprovar por Alan neste PR. Aprovados, os números entram em `docs/balance/` nas tarefas que os implementam (T39 a T41), com o simulador (D-363). O valor da Firmeza passa também pela rodada de simulação (T61).

**Origem de cada regra** (`writing-guide.md`): **[E]** Escritura · **[T]** tradição · **[D]** Dante · **[J]** criação do jogo.

## 1. Regras comuns

- Elites e chefe usam as regras de IA de `enemy-ai.md`: prioridade, condições, recarga, intenção visível antes do turno da equipe. Nada aqui usa sorte além do RNG `battle` já previsto (ADR-0003).
- Elites aparecem em `node_elite`, sempre com escolta (`expedition.md` §3). No máximo um elite por caminho em cada trecho (T40).
- **O Pecado Encarnado é a encarnação do círculo (D-406):** volta como luta de elite em todos os trechos: o nó variável, quando sorteia elite, traz o Pecado Encarnado do círculo (no Círculo 2, a Vertigem). Num círculo com mais de um Pecado, eles se alternam, evitando repetir o último enfrentado.
- **O Guardião é obrigatório (D-407):** Minos aparece uma vez por expedição, numa camada só dele no **fim do trecho 1**, ligada a todos os nós da camada anterior, antes do primeiro Pouso (Dante: Minos julga na entrada do círculo). Fica fora da composição dos caminhos e do limite de um elite por caminho. Encontro no grupo `guardian` de `encounters.csv`.
- O chefe aparece em `node_boss`, sem retirada de emergência (`expedition.md` §9).
- O santo **nunca** peca nem perde o controle das próprias ações. Todo assédio vem de fora, é visível e tem resposta (`expedition.md` §10.1).

## 2. A Provação do Círculo 2: Vendaval

### 2.1 Vendaval (já especificado, `expedition.md` §10)

No `ROUND_START`, sortear (RNG `battle`) duas posições de santos adjacentes e mostrar como intenção de ambiente; no `HAZARD`, trocá-las. ~~A Clausura de Bento impede a troca de quem está ao lado dele.~~ **A Clausura não segura o Vendaval** (D-402: vale só contra os inimigos; com Bento no meio ela seguraria todo Vendaval). **Implementado na T39:** o sorteio é entre as duplas de posições vizinhas, com chance igual, depois das intenções inimigas; as posições marcadas são as da rodada (quem estiver nelas no `HAZARD` é trocado, inclusive um Caído); só nos encontros com `hazard = gale` (`encounters.csv`). **[D]** a tempestade que arrasta os luxuriosos (*Inferno* V); a forma de jogo é **[J]**.

### 2.2 Firmar o pé (resposta comum, D-393 (3))

Comando novo `StandFirm(actor)`, ao lado de Trocar e Passar. **[J]**

| Regra | Valor |
| --- | --- |
| Quem pode | Um santo de pé, que ainda não agiu, cuja posição está marcada pela intenção do Vendaval desta rodada (ou pelo Vendaval de Asmodeu, §5.1) |
| Custo | Gasta a ação do santo; não custa Fervor |
| Efeito | A troca do Vendaval marcada nesta rodada **não acontece** (nem o santo nem o vizinho saem do lugar) |
| Prêmio | Uma ficha de **Firmeza** (§2.4) |
| Validação | Rejeitar se não há Vendaval marcado na posição do santo, se ele já agiu, ou se está Atordoado ou Caído |
| Prévia | "Firmar o pé: a troca não acontece. Firmeza: +[firmness_fervor] de Fervor na próxima rodada" |

- ~~Se a Clausura de Bento já impede a troca, Firmar o pé não está disponível.~~ A Clausura não segura o Vendaval (D-402).

### 2.3 Encanto da Vertigem (o assédio com força, D-393 (2))

Condição nova `enchanted` (Encantado), aplicada pela ação Encanto da Vertigem (§4). **[J]**, inspirada no vento que arrasta e na vertigem do desejo **[D]**.

| Campo | Valor |
| --- | --- |
| Tipo | `duration`, negativa, [enchanted_rounds] rodadas (proposta: 2), sem acúmulo (renova) |
| Efeito | Todas as ações inimigas de **alvo único** que podem mirar o santo Encantado passam a mirá-lo (o inverso da Provocação de Jorge: aqui quem puxa é o inimigo) |
| Prioridade | Se Jorge tiver Provocação ativa, a Provocação vale (o santo que se oferece protege o encantado) |
| Quebra | Termina na hora em que **outro santo** cura ou abençoa o Encantado (qualquer efeito positivo de habilidade de um aliado: cura, Amparo, Força, limpeza) |
| Prêmio | Quebrar o Encanto dá uma ficha de **Firmeza** (§2.4) |
| Texto | Nome "Encantado"; descrição "Os inimigos miram este santo. Um companheiro que o cure ou abençoe quebra o encanto." |

O santo Encantado **não** perde o controle: escolhe suas ações normalmente. Ele sofre o assédio, não peca (D-267).

### 2.4 Firmeza (prêmio por resistir, D-393 (4))

Ficha da companhia, não do santo. **[J]**

| Regra | Valor |
| --- | --- |
| Ganha | Ao Firmar o pé (§2.2) e ao quebrar o Encanto (§2.3) |
| Efeito | +[firmness_fervor] de Fervor (proposta: 1) no início da próxima rodada |
| Limite | Conta dentro do limite de Fervor extra por rodada que já existe ([fervor_bonus_cap_per_round] = 2) e do teto de Fervor; no máximo [firmness_per_round] ficha por rodada (proposta: 1) |
| Tela | O contorno na cor do círculo em volta do santo estilhaça para fora (Bíblia de Arte) |

## 3. Minos, o Guardião

**[D]** Minos julga as almas na entrada do segundo círculo, enrolando a cauda tantas vezes quanto o círculo a que as manda (*Inferno* V, 4–12). Sentado no trono, **nunca se levanta** (D-219). Corpóreo (fraco a Golpe), papel Guardião. Forma de jogo: **[J]**.

| Campo | Proposta |
| --- | --- |
| Vida | [minos_max_hp] = 72 |
| Armadura | [minos_armor] = 2 |
| Tamanho | 1 posição; ocupa a posição 3 (escolta à frente) |
| Ações por rodada | 1 |

| Ação | Prioridade | Usa de | Alvo | Condição | Recarga | Efeito |
| --- | --- | --- | --- | --- | --- | --- |
| `minos_coil` · Rabo enrolado | 1 | qualquer | si mesmo | vida abaixo de 50% | 2 | Ganha [minos_coil_ward] = 2 de Amparo |
| `minos_summon` · Invocação | 2 | qualquer | — | a cada 3 rodadas e posição inimiga livre | 0 | Invoca uma Sombra do Desejo (no máximo [minos_summon_max] = 1 viva) |
| `minos_tail_lash` · Rabo de serpente | 3 | qualquer | 1 santo, posições 2 a 4, o de maior vida | sempre | 0 | [minos_lash_damage] = 8 de Golpe e **puxa** o santo para a posição 1 |

Escolta proposta: Diabo de Lodo (1), Escaravelho Infernal (2), Minos (3).

## 4. Vertigem, o Pecado Encarnado

**[J]**, figura alegórica da luxúria do Círculo 2 (Pecados Encarnados, GDD §8). Espiritual (fraca a Exorcismo); sempre coberta pelos véus (D-163). Aplica a Provação com força: o Encanto.

| Campo | Proposta |
| --- | --- |
| Vida | [vertigo_max_hp] = 80 (era 58; Alan subiu na T40, D-405) |
| Armadura | 0 |
| Imunidade | Atordoamento |
| Tamanho | 1 posição; posição 2 ou 3 |
| Ações por rodada | 1 |

| Ação | Prioridade | Usa de | Alvo | Condição | Recarga | Efeito |
| --- | --- | --- | --- | --- | --- | --- |
| `vertigo_enchant` · Encanto | 1 | 2, 3, 4 | 1 santo, o de maior vida que não esteja Encantado | nenhum santo Encantado | 3 | Aplica Encantado ([enchanted_rounds] rodadas) |
| `vertigo_veils` · Véus | 2 | qualquer | 1 santo, posições 1 a 3 | sempre | 0 | [vertigo_veils_damage] = 6 de Exorcismo e +[vertigo_veils_desolation] = 6 de desolação |
| `vertigo_whirl` · Rodopio | 3 | 2, 3, 4 | 1 santo, posições 1 e 2 | a cada 2 rodadas | 0 | Empurra o santo 1 posição para trás |

Escolta proposta: Sombra do Desejo (1), Vertigem (2), Sopro Errante (3).

**Implementado na T40 (D-404):** o Rodopio entra com prioridade 2 e os Véus com 3 (na ordem da tabela, os Véus valem "sempre" e o Rodopio nunca seria escolhido); os Véus miram o santo da frente (`front_most`), porque a tabela não diz a regra. Alvos de 1 a 3 (a companhia tem 3 posições). Minos: ids `elite_minos` e `elite_sin_vertigo` (os nomes da arte); o Rabo de serpente puxa até a posição 1 (`pull` 3), e a Clausura de Bento resiste ao puxão como a qualquer deslocamento por inimigo (D-109).

## 5. Asmodeu, o chefe

**[E]** Asmodeu é o demônio que atormentava Sara (Tobias 3,8); Tobias queima o coração e o fígado do peixe, a fumaça o expulsa e o Arcanjo Rafael o prende (Tobias 6,8; 8,2–3). **[T]** As três cabeças vêm do *Dictionnaire Infernal* (Collin de Plancy, séc. XIX). Na tela: dragão com o cavaleiro, lança e fumaça violeta (D-226). Espiritual (fraco a Exorcismo). Forma de jogo: **[J]**.

| Campo | Proposta |
| --- | --- |
| Vida | [asmodeus_max_hp] = 150 |
| Armadura | [asmodeus_armor] = 1 |
| Tamanho | 2 posições (1 e 2); na tela, o desenho atual ampliado 2× (D-421) |
| Ações por rodada | 1 (+1 com a garra 2 do Domínio) |
| Fases | Limiares de vida: [0,5] → 2 fases; com a garra 3 do Domínio: [0,66, 0,33] → 3 fases |

### 5.1 Ações por fase

| Fase | Ação | Alvo | Efeito |
| --- | --- | --- | --- |
| Todas | `asmodeus_lance` · Estocada | 1 santo, posição 1 ou 2 | [asmodeus_lance_damage] = 12 de Golpe |
| Todas | `asmodeus_breath` · Sopro violeta (recarga 2) | todos os santos | [asmodeus_breath_damage] = 4 de Exorcismo e +[asmodeus_breath_desolation] = 8 de desolação |
| 2 em diante | `asmodeus_gale` · Vendaval de Asmodeu (a cada 2 rodadas) | 2 santos adjacentes | Cobra a lição do círculo: a intenção mostra os dois santos e, no turno do chefe, eles trocam de lugar. As mesmas respostas valem: Clausura de Bento e **Firmar o pé** (§2.2), que dá Firmeza |
| 2 em diante (D-410) | `asmodeus_three_heads` · Três cabeças | 3 golpes em santos ao acaso (RNG `battle`), posições 1 a 3 | [asmodeus_heads_damage] = 5 de Golpe cada |
| Todas (D-410) | `asmodeus_enchant` · Encanto do desejo (recarga 3) | 1 santo | Aplica Encantado, como a Vertigem |
| Última (só com a garra 3, D-411) | `asmodeus_seven_nights` · As sete noites (recarga 4) | 1 santo, o de maior vida, sem marca | Marca de 2 rodadas; ao fim, [seven_nights_damage] = 20 de dano direto. Um companheiro tira a marca intercedendo (toma-a para si) ou abençoando. **[E]** Tobias 3,8: Asmodeu matou os sete maridos de Sara; a forma de jogo é **[J]** |
| Última (só com a garra 3, D-411) | `asmodeus_ring` · Anel da invisibilidade (recarga 3) | si mesmo | Invisível até o fim da rodada seguinte: não pode ser alvo de ataques de um alvo só; ataques em grupo o atingem. **[T]** Goetia e Weyer: Asmodeu torna invisível; a forma de jogo é **[J]** |

- O Vendaval do círculo **não** acontece na luta com Asmodeu: a lição vem pela ação dele, com intenção visível.
- Troca de fase: o chefe recua, a silhueta pisca na cor do círculo e a fase nova aparece na barra (apresentação, T41).

**Implementado na T41 (D-409):** id `boss_asmodeus` (o da arte). A tabela não dá prioridades nem recarga para todas as ações; ficou assim, na ordem: Vendaval (1; fase 2 em diante, rodadas pares), Encanto do desejo (2; desde a fase 1, recarga 3, sem santo Encantado), Sopro violeta (3; recarga 2), Três cabeças (4; fase 2 em diante), Estocada (5). Alan mudou as fases em D-410. Com duas ações, a segunda é a próxima válida diferente da primeira. As posições do Vendaval de Asmodeu são sorteadas quando ele anuncia a ação e trocadas no turno dele. A Clausura não segura este Vendaval (D-402).

### 5.2 Domínio (D-284, D-393 (5))

Asmodeu segura a alma do Peregrino com um Domínio de **3 garras**, visível junto da barra de vida. A companhia sempre pode vencer com as três. **[J]**

| Garra | Vantagem do chefe | Cede quando |
| --- | --- | --- |
| 1 · ~~Escolta~~ | ~~A luta começa com 2 Sombras do Desejo nas posições 3 e 4~~ Asmodeu luta sozinho (D-421); o que esta garra passa a ser está em aberto | A **primeira** vez que a companhia alcança o Peregrino no Círculo 2 (Tentação bem resolvida ou Encontro com a alma) |
| 2 · Ação a mais | +1 ação por rodada | A **segunda** vez |
| 3 · Fase extra | 3 fases em vez de 2, com as Três cabeças e o Encanto do desejo | A companhia leva o **fígado do peixe** (§5.3) |

- "Alcançar o Peregrino" é o resultado novo `dominion` dos eventos (`narrative-system.md` §3.2): o autor o põe nas opções que resolvem bem uma Tentação e no Encontro com a alma do círculo. Conta na expedição atual, no máximo 2 vezes (garras 1 e 2).
- O Domínio é guardado no estado da expedição (`ExpeditionState`) e no save (T42).
- A Vigília (`expedition.md` §7) mostra quantas garras ainda seguram o Peregrino, antes da luta.

### 5.3 O fígado do peixe e São Rafael (D-393 (5) e (6))

- **Onde se acha:** um nó de relíquia **garantido** no trecho 3, "O peixe do Tigre" **[J]**, inspirado em Tobias 6,2–9 **[E]**. É item da expedição (não relíquia equipável); fica no estado da expedição até o chefe e não volta para a vila.
- **Com o fígado:** a luta começa com a fumaça do fígado (cena curta) e a **garra 3 cede** na hora. Na vitória, **São Rafael** aparece como recorte de ouro, sem ser unidade, sem vida, sem ação e sem bônus, e **prende Asmodeu** (Tobias 8,3). Texto com a origem indicada (`writing-guide.md`).
- **Sem o fígado:** Asmodeu luta com a fase extra; na vitória, ele **foge** para o vento (sem a cena de Rafael). A vitória vale igual.
- Rafael nunca intervém durante a luta nem dá bônus: é cena, como Gabriel em Dite (GDD §9).

## 6. Encontros comuns do Círculo 2 (D-175)

Só os 7 inimigos da Família A. Formações que atacam todas as posições dos santos. Grupo fácil no trecho 1; grupo difícil nos trechos 2 e 3 (`expedition.md` §3).

| Id | Grupo | Posição 1 | Posição 2 | Posição 3 | Posição 4 | Ideia |
| --- | --- | --- | --- | --- | --- | --- |
| `c02_easy_01` | fácil | Diabo de Lodo | Moscardo | | | Bruto e atirador |
| `c02_easy_02` | fácil | Escaravelho Infernal | Sombra do Desejo | Moscardo | | Guarda protege a corrupção |
| `c02_easy_03` | fácil | Diabo de Lodo | Sopro Errante | Moscardo | | Empurrão e atirador |
| `c02_easy_04` | fácil | Escaravelho Infernal | Mãe-Enxame | | | Invocação protegida |
| `c02_easy_05` | fácil | Diabo de Lodo | Sombra do Desejo | Sopro Errante | | Pressão espiritual |
| `c02_hard_01` | difícil | Diabo de Lodo | Escaravelho Infernal | Sopro Errante | Moscardo | |
| `c02_hard_02` | difícil | Escaravelho Infernal | Diabo de Lodo | Mãe-Enxame | Sombra do Desejo | |
| `c02_hard_03` | difícil | Diabo de Lodo | Diabo de Lodo | Moscardo | Sombra do Desejo | Dois brutos |
| `c02_hard_04` | difícil | Escaravelho Infernal | Sombra do Desejo | Sopro Errante | Mãe-Enxame | Muito espiritual |
| `c02_hard_05` | difícil | Diabo de Lodo | Escaravelho Infernal | Moscardo | Moscardo | Dois atiradores |
| `c02_elite_minos` | elite | Diabo de Lodo | Escaravelho Infernal | Minos | | §3 |
| `c02_elite_vertigo` | elite | Sombra do Desejo | Vertigem | Sopro Errante | | §4 |
| `c02_boss_asmodeus` | chefe | Asmodeu (1 e 2) | | (Sombra do Desejo) | (Sombra do Desejo) | §5; escolta só com a garra 1 |

Os encontros `m0_*` continuam na arena de teste.

## 7. Casos de teste obrigatórios

| Caso | Regra |
| --- | --- |
| B01 | Firmar o pé de um santo marcado pelo Vendaval impede a troca, gasta a ação dele e dá 1 Firmeza; a rodada seguinte começa com +1 de Fervor, sem passar do limite de ganho extra |
| B02 | Firmar o pé é rejeitado para santo não marcado, que já agiu ou Atordoado; a Clausura de Bento não segura o Vendaval (D-402) |
| B03 | Com um santo Encantado, toda ação inimiga de alvo único que pode mirá-lo o mira; ações em área e ambiente não mudam |
| B04 | Provocação de Jorge vence o Encanto |
| B05 | Uma cura ou bênção de outro santo quebra o Encanto na hora e dá 1 Firmeza; a do próprio santo não quebra |
| B06 | No máximo 1 Firmeza por rodada |
| B07 | Minos puxa o alvo do Rabo de serpente para a posição 1; usa o Rabo enrolado abaixo de 50% de vida; invoca no máximo 1 Sombra |
| B08 | Vertigem não usa Encanto com um santo já Encantado |
| B09 | Asmodeu com 3 garras: começa com 2 Sombras, age 2 vezes por rodada, tem 3 fases |
| B10 | Cada alcance do Peregrino cede uma garra na ordem escolta → ação a mais; o fígado cede sempre a fase extra; o Domínio chega a 0 com os três |
| B11 | Com o fígado, a cena de Rafael acontece na vitória; sem o fígado, Asmodeu foge; a vitória vale igual |
| B12 | A luta com Asmodeu não tem Vendaval do círculo nem retirada de emergência; Firmar o pé contra o Vendaval de Asmodeu impede a troca e dá Firmeza |
| B13 | O mesmo combate com Asmodeu, a mesma semente e o mesmo log dá o mesmo resultado byte a byte |
