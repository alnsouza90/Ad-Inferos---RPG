# Plano de revisão · playtest da fatia vertical (19/11/2026)

Resposta ao documento `2026-11-19-playtest-vertical-slice.md`. **Estado: proposta para Alan aprovar.** O jogo não muda nada até a aprovação.

**Como a auditoria foi feita:**
- leitura do código e dos dados;
- duas provas rodadas no motor:
  - uma luta contra Asmodeu e duas lutas comuns, rodada a rodada, comparando as intenções com as ações;
  - o toque na vila.
- Onde a causa não foi confirmada, a tabela diz "a investigar". Nada foi inventado.

---

## 1. Resumo para Alan

**Três bugs têm causa encontrada e correção simples (P):**
1. **Estátua (B03) e contornos (B04).** No celular, cada toque chega duas vezes à vila: uma como toque e outra como "clique" que o próprio Godot imita.
   - Na estátua, o primeiro toque abre a Ave Maria e o segundo, no mesmo instante, fecha.
   - Nos prédios, a vila entra no prédio já no primeiro toque, então o contorno nem chega a aparecer, em qualquer tempo litúrgico.
   - Correção: aceitar só um dos dois eventos e passar a acender no primeiro toque e entrar no segundo (V01).
2. **Santo do Jardim na equipe (B13).** A sugestão da equipe no Portão não exclui quem está no Jardim nem quem está no leito; só a regra de partir recusa depois.
3. **Derrota sem saída (D10).** Com menos de 3 santos aptos, hoje só existe o Retiro (uma vez entre expedições). O jogador pode ficar preso: isso confirma a necessidade de "Passar a semana" (D9).

**Dois bugs de combate não se reproduzem no núcleo das regras:**
- **B01:** os inimigos escolhem e executam as intenções certas.
  - Na prova, Asmodeu e as duas Sombras agiram em todas as 6 rodadas.
  - Na luta difícil, os inimigos de frente ficaram "esperando" só quando não havia alvo ao alcance deles.
- **B02:** as escoltas de Asmodeu também agiram em todas as rodadas da prova.
- **Causa mais provável dos dois:** apresentação.
  - O "Sussurro" da Sombra só aumenta a desolação e quase não aparece na tela.
  - "Esperar" (sem alvo) não tem aviso claro.
- **Correção:** entra na fase de sensação de combate (C05, C10), com um teste que compara, rodada a rodada, as intenções com o que a tela mostra.

**O maior trabalho é a D3 (andar e lutar no mesmo cenário).** Hoje a caminhada, o combate e o Pouso são três telas separadas (`WalkScreen`, `BattleScreen`, `CampScreen`), trocadas pela `LegScreen`. Unir as três é uma reforma de arquitetura (G+), e por isso precisa de um ADR. Ela combina com a refatoração já prevista (T66): o combate tem 2.438 linhas e a caminhada 1.465.

**Medidas de legibilidade.** O jogo desenha numa tela interna de 960 × 540 e amplia 2× no celular. As metas do §1.2 (feitas para 1920 × 1080) viram, na tela interna:

| Elemento | Meta do documento | Na tela interna |
| --- | --- | --- |
| Texto corrido | 32 px | 16 px |
| Rótulo de botão | 36 px | 18 px |
| Números importantes | 44 px | 22 px |
| Alvo de toque | 120 × 120 | 60 × 60 |
| Espaço entre alvos | 16 | 8 |

- **Já atendem:** os textos novos (vila, prédios, mapa) usam 20 px, acima da meta.
- **Abaixo da meta:** combate, caminhada, Pouso e fichas ainda usam 10 a 12 px em vários pontos (metade da meta), e muitos alvos têm 30 a 34 px.

---

## 2. Conflitos com as decisões e especificações atuais (Alan decide)

| ID | Conflito | O que proponho |
| --- | --- | --- |
| D1 | O Modelo B da ficha (D-477) e `equipped_abilities = 4` (`constants.csv`) dizem 4 habilidades e a roseta | Mudar para 3 + milagre em vitral dourado; `equipped_abilities` vira 3; manter "pelo menos 1 sem custo"; simular antes de fechar (T61) |
| D2 | `combat.md` §4 e o texto `end_turn` / `confirm_end_turn` | O turno acaba sozinho quando todos agiram ou passaram. **Pergunta:** e o santo atordoado ou caído? Proponho que conte como "já agiu" |
| D3 | `architecture.md` (telas separadas), `LegScreen` e ADR-0013 | Novo **ADR-0014 "mundo contínuo"**: uma cena de expedição com o cenário, a companhia e camadas de estado (andar, lutar, pousar). As regras não mudam; só a apresentação |
| D7 | `expedition.md` §1–2 (nó variável sorteado, Minos no fim do Trecho 1) | Minos no fim do Trecho 1 já existe. **Novo:** o nó pré-guardião. **Pergunta do §7.1:** proponho **Tentação, alma e elite em posições fixas** por trecho, para casar com os cenários planejados (M05). Isso troca o sorteio por um roteiro, e as bifurcações ficam só nos combates comuns |
| D9 | Retiro: uma vez entre expedições (`village-economy.md`) | "Passar a semana" sempre disponível. Ele vira a semana como o Retiro, mas o Retiro continua sendo o único que dá o bônus do Retiro |
| D11 | D-504 (cadeado com o nome e o motivo de quem vai chegar) | Volta atrás: só vagas vazias, sem nomes nem rostos. Os textos `lock_*` saem |
| D12 | O filtro do círculo (D-379) hoje pinta a camada inteira do combate | O filtro vale só para o cenário e os inimigos; itens, relíquias, ícones e interface ficam fora |
| B03 / V09 | A Ave Maria hoje é **texto** (D-497); o playtest pede **áudio** | Manter o texto e acrescentar uma gravação da Ave Maria latina em canto gregoriano, de domínio público. Depende do ADR de áudio (T54) |

---

## 3. Fases propostas

A ordem do §8 do playtest está boa. Ajustei três pontos:
- **F1 + V01:** a correção do toque duplo já resolve a vila.
- **A refatoração T66 entra no começo da F4:** a D3 é uma reforma e só deve ser feita sobre um código dividido.
- **Áudio:** a parte de áudio mínima (Ave Maria, sino, toque) entra cedo, porque o playtest pede som no toque.

| Fase | Conteúdo | Tamanho | Build no fim |
| --- | --- | --- | --- |
| **F1 · Correções e saídas** | B03, B04, V01 (toque duplo); B13 e D8; D9, D10 e V06; B05, B06, B07, B09, B11, B12; D11 e V04 | M (3–4 dias) | Sim |
| **F2 · HUD e legibilidade** | D1, D2, D4 (desenho), D12; H01–H10; metas do §1.2 em todas as telas; V07, V08, V03, V05; P02, P03, B10 | G (1–2 semanas) | Sim |
| **F3 · Sensação de combate** | C01–C11, C13; B01, B02 (visibilidade das ações e da espera); B08 (só estampa); áudio mínimo (ADR, sino, toque, Ave Maria) | G (1–2 semanas) | Sim |
| **F4 · Mundo contínuo** | T66 (refatoração da caminhada e do combate); D3, D5, C12, M02, M04; P01 | G+ (2–3 semanas) | Sim |
| **F5 · Cenários do Círculo 2** | D6, D7, M03, M05–M09, B14, B15; §7 | G (depende da arte de Alan) | Sim |
| **F6 · Vila e mapa** | V02, M01; o restante da vila | M | Sim |

O que já estava no backlog muda de lugar assim:
- **T50 (santo novo) e T51 (Prólogo):** passam para depois da F2, para já nascerem no HUD novo.
- **Simulação (T61, T55):** roda com a D1 (3 habilidades) antes de fechar a F2.

---

## 4. Tabela de auditoria

**Estados:** I = implementado · P = parcial · N = não existe · B = bug confirmado · NR = não reproduzido.

**Tamanhos:** P = horas · M = 1–2 dias · G = 3+ dias.

### 4.1 Decisões

| ID | Estado | Onde | Observação | Tam. | Depende |
| --- | --- | --- | --- | --- | --- |
| D1 | N | `constants.csv` `equipped_abilities`, `AbilityLoadout`, `SaintCard`, `battle_selection.gd`, `combat.md` §2.5 | Hoje 4 + roseta | M | simulação |
| D2 | N | `battle_controller.gd` `end_party_turn`, `battle_screen.gd`, `ui_text` `end_turn` | O fim automático já cabe no núcleo (a fase muda) | P | — |
| D3 | N | `leg_screen.gd`, `walk_screen.gd`, `battle_screen.gd`, `camp_screen.gd` | Reforma de cenas; ADR-0014 | G+ | T66, D4 |
| D4 | N | HUD repetido em três telas | Um `ExpeditionHud` único | G | D1, D2 |
| D5 | P | `walk_screen.gd` (botão "Entrar" nos nós) | Andar já existe; falta seguir sem botão e os props | M | D3, M04 |
| D6 | P | `scenery_plan.gd` (cenário sorteado por nó) | Os nós de evento passam a ter cenário fixo | M | arte |
| D7 | P | `expedition.md`, `map_templates.csv`, `encounters.csv` | Minos já no fim do Trecho 1; falta o pré-guardião | M | decisão das posições fixas |
| D8 | B | `Village.suggestions` não exclui o Jardim nem o leito | Mesma causa da B13 | P | — |
| D9 | N | `Campaign` (falta "passar a semana"), prédio ou vila | `advance_week` já existe | P | — |
| D10 | B | `Campaign.party_refusal` sem saída quando há menos de 3 aptos | Resolvido pela D9 | P | D9 |
| D11 | I (contrário) | `building_screen.gd` `_locked_cell`, `lock_*` | Hoje mostra nome e motivo (D-504) | P | — |
| D12 | B | `battle_screen.gd`: o filtro do círculo cobre a camada inteira | Separar cenário e inimigos da interface | M | D4 |

### 4.2 Bugs

| ID | Estado | Onde | Causa provável | Tam. | Depende |
| --- | --- | --- | --- | --- | --- |
| B01 | NR (núcleo) | `enemy_brain.gd`, `battle_screen.gd` | Na prova, toda intenção de ação foi executada. "Esperar" (sem alvo ao alcance) e as ações só de desolação aparecem pouco | M | C05, C10 |
| B02 | NR (núcleo) | `battle_state.setup_boss`, `shade_whisper` | As Sombras agem todas as rodadas; o Sussurro (desolação) não tem efeito visível | P | C10 |
| B03 | B | `village_screen.gd` `_gui_input` | Toque e clique imitado chegam juntos: abre e fecha no mesmo instante | P | — |
| B04 | B | `village_screen.gd` `tap_at` e `VillageFlow` | Entra no prédio no primeiro toque (e o toque chega duplicado) | P | — |
| B05 | B | `saint_benedict_*.png` (quadros) | Pixels do fundo da geração na perna direita | P | — |
| B06 | a investigar | `saint_therese_walk.png` (2304 × 256), `walk_screen.gd` | O arquivo existe; suspeita: o quadro de Teresinha não é carregado na caminhada | P | — |
| B07 | a investigar | `saint_therese_fall.png`, `combatant_view.gd` | Suspeita: o quadro de queda tem transparência parcial ou recebe o esmaecimento do "caído" duas vezes | P | — |
| B08 | B | `battle_screen.gd` (efeitos antigos de cruz e escudo ainda chamados antes de `saint_stamp.gd`) | Duas camadas de efeito em vez de uma | M | C07 |
| B09 | a investigar | Quadros de golpe de Jorge | A ponta da lança fica fora do recorte do quadro | P | — |
| B10 | P | `walk_screen.gd` (tem), `battle_screen.gd` (pequeno), `camp_screen.gd` (não tem) | O alforje mora em cada tela | M | D4 |
| B11 | B | `battle_screen.gd` (ficha do inimigo) | O rótulo não quebra a linha dentro de um contêiner (lições: Label só quebra dentro de container) | P | — |
| B12 | B | `saint_card.gd` (traço e descrição sobre a posição e o alvo) | Altura fixa; o texto longo de Bento estoura | P | — |
| B13 | B | `Village.suggestions` | Ver D8 | P | — |
| B14 | B | Peças de primeiro plano em `scenery_plan.gd` e arte | Recortes das peças e escala | M | arte, F5 |
| B15 | B | Peça central do cenário da Vigília | Arte | P | arte |

### 4.3 Vila

| ID | Estado | Onde | Observação | Tam. | Depende |
| --- | --- | --- | --- | --- | --- |
| V01 | P | `village_screen.gd` | Acender no 1º toque e entrar no 2º; junto com a B03 e a B04 | P | — |
| V02 | N | `village_sunset.gdshader`, `LiturgicalCalendar` | Natal à noite com estrelas: shader do motor | P | — |
| V03 | N | Despensa (`building_screen.gd`) | Tocar mostra o efeito; segurar ou tocar de novo compra | P | — |
| V04 | P | Portão | D11 e D8 | P | D8, D11 |
| V05 | P | Casa de Exercícios | **Atenção:** hoje a melhoria **não custa esmolas** (`village-economy.md` §9, sem custo). Mostrar "melhorias disponíveis: N" e o que muda. **Pergunta:** quer que passe a custar? | P | — |
| V06 | N | Ver D9 | | P | D9 |
| V07 | P | `SaintRoster` mostra ferido; `SaintCard` não mostra o estado | Ferimento leve ou grave, Noite Escura, Consolação | P | — |
| V08 | N | Ver D1 | | M | D1 |
| V09 | P | Texto existe; áudio não | ADR de áudio | P | T54 |

### 4.4 Mapa, caminhada e nós

| ID | Estado | Onde | Observação | Tam. | Depende |
| --- | --- | --- | --- | --- | --- |
| M01 | P | `hell_map_screen.gd` (trilha seguindo a geografia) | Linha reta: ícone · ● ● ● · ícone · ● ● ● · ícone, com alvos de 60 px | P | — |
| M02 | N | Ver D5 | | M | D3 |
| M03 | P | `scenery_plan.gd` | Bifurcações peça por peça | M | arte |
| M04 | N | — | Props na escala dos santos e quadros de interação (virar, subir, entrar) | G | arte, animação |
| M05 | N | `scenery_plan.gd` hoje sorteia peças | Trechos de cenário pré-definidos | M | D7 |
| M06 | — | Arte da tenda da Tentação | Refazer | P | arte |
| M07 | N | Ver D6 | | M | D6 |
| M08 | N | Cena da alma | Almas do fundo com movimento no motor | P | — |
| M09 | B | Ver B14 | | M | arte |
| P01 | N | `camp_screen.gd` com HUD próprio | | M | D4 |
| P02 | P | `camp_screen.gd` (atividades em texto pequeno) | Tela de atividades por santo, com letra grande | M | D4 |
| P03 | N | Ver B10 | | P | D4 |

### 4.5 Combate e HUD

| ID | Estado | Onde | Observação | Tam. | Depende |
| --- | --- | --- | --- | --- | --- |
| H01 | P | Todas as telas da expedição | Área útil dentro dos tijolos | M | D4 |
| H02 | P | Fervor e Lume em pontos diferentes por tela | Lugar fixo | P | D4 |
| H03 | N | Ver D1 | | M | D1 |
| H04 | P | Ações comuns hoje pequenas, de moldura grossa | Junto das habilidades, grandes, moldura fina | M | D4 |
| H05 | P | Alforje sim, mapa (mini-mapa) só na caminhada | Dois botões fixos | P | D4 |
| H06 | P | O núcleo já dá o motivo da recusa (`validate`) | Mostrar cinza com o motivo | P | — |
| H07 | P | O vitral mostra o detalhe na seleção | 1º toque mostra o quadro, 2º toque usa | P | — |
| H08 | P | `RelicView` pequeno | Espaço das relíquias, tocar mostra o efeito | P | D4 |
| H09 | N | Ver D2 | | P | D2 |
| H10 | B | Ver D12 | | M | D12 |
| C01 | N | — | Recomendo a opção 1 (sino e mancha de tinta com a espada e a cruz) | P | áudio |
| C02 | N | `battle_screen.gd` (golpe hoje no lugar) | Close com desfoque e deslize | M | — |
| C03 | P | O "peso do golpe" (T59) existe; tremor e pausa fracos | Tabela do §6.3 num recurso de apresentação, como `halo_settings.tres` | M | — |
| C04 | N | — | Projétil que viaja (Moscardo, Arqueiro, Arpoeiro) | M | arte do projétil |
| C05 | N | Ícones de condição existem | Nome grande sobre o alvo, depois o ícone | P | — |
| C06 | P | `ink_*.png` existem | Mancha em todo golpe físico | P | C03 |
| C07 | P | 3 estampas de santo e 4 genéricas | Faltam estampas por habilidade | M | arte |
| C08 | P | O milagre já escurece | Segurar e tremer depois | P | — |
| C09 | — | `stamp_saint_therese.png` | Nova arte | P | arte |
| C10 | N | Ações espirituais dos inimigos sem efeito próprio | Tinta violeta e desolação visível no santo | M | — |
| C11 | P | O aviso de vitória existe | Caixa com os ícones dos ganhos | P | — |
| C12 | N | Ver D3 | | — | D3 |
| C13 | P | Ver H05 e H07 | | P | D4 |

---

## 5. Mudanças de especificação (depois da aprovação)

| Arquivo | Mudança |
| --- | --- |
| `docs/specs/combat.md` | §2.5: 3 habilidades + milagre (D1); §4: fim de turno automático e o caso do atordoado ou caído (D2); efeitos só de estampa (B08) |
| `docs/balance/constants.csv` | `equipped_abilities` = 3 (D1) |
| `docs/design/saint-kits.md` | Regenerado dos CSV |
| `docs/specs/expedition.md` | §1–2: pré-guardião e posições fixas de Tentação, alma e elite (D7); cenário fixo dos nós de evento (D6); seguir sem "Entrar" (D5); §9: derrota sem substitutos (D10) |
| `docs/balance/map_templates.csv`, `encounters.csv` | Nova estrutura dos trechos (D7) |
| `docs/specs/village-economy.md` | §1: "Passar a semana" (D9); §4: designado vai para a reserva (D8); D10 sem estado sem saída |
| `docs/ui/screens.md` | HUD único (D4), metas de legibilidade, Portão sem nomes (D11), Mapa em linha reta (M01), toque duplo da vila (V01) |
| `docs/architecture.md` + **ADR-0014** | Mundo contínuo (D3) |
| **ADR de áudio** (T54) | Origem dos sons e licenças; o tocador de áudio, que talvez precise de um autoload novo e pede a sua aprovação (`CLAUDE.md` §9) |
| `docs/art/` | Filtro do círculo só no cenário e nos inimigos (D12); lista de assets da §6 |
| `docs/gdd/gdd-v1.1.md` | D1, D2, D3 e D9 mudam o GDD: só com o seu pedido explícito, que este playtest dá depois da aprovação do plano |

---

## 6. Assets que faltam (para Alan gerar os prompts)

### 6.1 Arte

| Peça | Fase | Observação |
| --- | --- | --- |
| Vitral dourado do milagre (um por santo: Jorge, Bento, Teresinha, Antão) | F2 | Formato das lancetas atuais, fundo dourado |
| Moldura fina de botão para ações comuns e alvos grandes | F2 | Pode ser do PixelLab |
| Ícone do botão do Mapa e do Alforje em tamanho grande | F2 | |
| Estampa de início de luta: espada cruzada com a cruz | F3 | C01 |
| Estampas por habilidade (as que faltam), começando por Teresinha | F3 | C07; a lista exata sai na F3 |
| Nova estampa do milagre de Teresinha | F3 | C09 |
| Projéteis: ferrão do Moscardo, flecha do Arqueiro, arpão do Arpoeiro | F3 | C04 |
| Tinta espiritual (violeta) para os ataques espirituais dos inimigos | F3 | C10 |
| Caixa de recompensa da vitória | F3 | C11 |
| Props na escala dos santos: escada, porta, caverna, ponte | F4 e F5 | M04 |
| Quadros dos santos interagindo: virar de costas, subir, entrar (3 santos e Antão) | F4 | M04 |
| Cenários do Círculo 2 conforme o §7.2: entrada com o trono de Minos, 9 corredores, Tentação, alma, pré-guardião, Júri de Minos, Pouso, Vigília nova | F5 | Cada corredor com pista, primeiro plano, segundo plano e fundo |
| Tenda da Tentação nova | F5 | M06 |
| Correções de sprite: perna de Bento (B05), ponta da lança de Jorge (B09) | F1 | O agente corrige no motor ou pelo PixelLab, com o custo antes |

### 6.2 Áudio

| Som | Fase |
| --- | --- |
| Ave Maria em latim, canto gregoriano, gravação de domínio público | F3 (V09) |
| Sino grave de início de luta | F3 (C01) |
| Toque válido (pena riscando) e toque inválido (som seco) | F3 |
| Golpes: leve, médio, pesado; milagre | F3 |
| Música por ambiente: vila, caminhada, combate, chefe | T54 |

---

## 7. Riscos e perguntas

**Riscos:**
1. **D3 é grande:** não pode ser feita em pedaços que deixem o jogo quebrado entre um PR e outro. Proposta: a cena nova cresce ao lado da antiga e troca de uma vez, com os testes de expedição inteira passando nas duas.
2. **D1 muda o equilíbrio:** com 3 habilidades, menos opções por turno. A simulação (T61) roda antes de fechar a F2.
3. **A F5 depende da sua arte:** são cerca de 15 cenários e os props. Para não travar, as fases F1 a F4 seguem com os cenários atuais.
4. **Áudio pede um ADR e talvez um autoload novo:** preciso do seu sim.

**Perguntas:**
1. **D2:** o santo atordoado ou caído conta como "já agiu" para o turno acabar sozinho?
2. **D7:** Tentação, alma e elite em **posições fixas** por trecho (recomendo, para casar com os cenários planejados) ou continuam sorteadas?
3. **D9:** "Passar a semana" sempre disponível, deixando o Retiro com o bônus próprio (recomendo), ou só quando não há 3 santos aptos?
4. **V05:** a melhoria da Casa de Exercícios hoje não custa esmolas. Continua grátis (só pelos níveis) ou passa a custar?
5. **B03:** a Ave Maria fica com o texto **e** o áudio (recomendo) ou só com o áudio?
6. **Fases:** aprova a ordem F1 → F6, com a T66 no começo da F4 e a T50 e a T51 depois da F2?
