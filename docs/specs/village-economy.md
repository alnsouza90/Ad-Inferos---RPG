# Especificação · Vila, calendário, economia e progressão

Versão 1.2 (18/11/2026: nova divisão da vila, D-469, D-474; simplificações do M2, §13) · versão 1.1 (12/11/2026: decisões da consultoria do Fable, D-266 e D-267 a D-362) · base: GDD v1.1 §3, §6, §7 e §12 · números em `docs/balance/economy.csv`, `facilities.csv` e `constants.csv`

> **Aviso (12/11/2026):** esta versão marca o que mudou de direção com a consultoria. Onde diz "a definir", o número sai do simulador e do aprovado de Alan (D-363); os CSVs ainda não mudaram. O GDD descreve a versão anterior e só muda com pedido de Alan.

## 1. A semana

- A campanha começa na **semana 1** (1º domingo do Advento) do ano litúrgico de 20 semanas.
- Na vila, o jogador prepara a semana numa tela única ("Planejar a semana") e então parte para uma expedição.
- A semana avança quando a expedição termina (por qualquer motivo) ou quando o jogador faz um **Retiro**.
- **Retiro:** avançar uma semana sem expedição. Permitido no máximo uma vez entre duas expedições.
- Ao virar a semana, nesta ordem: efeitos da Capela e do Jardim e Claustro (D-469) → cura de ferimentos → Sufrágios → mudança de tempo litúrgico → eventos da semana (Natal, festa de santo, Conselho pendente).

## 2. Planejar a semana

A semana se prepara nos próprios edifícios, como em *Darkest Dungeon* (D-469): cada etapa acontece no edifício dela, e o **Portão** reúne o fim da preparação. Sugestões automáticas que o jogador apenas confirma ou ajusta:

1. Escolher a equipe (3 santos) e a ordem de posições, **no Portão**.
2. Designar santos para a Capela (Sufrágios) ou para o Jardim e Claustro (descanso da desolação). Eles ficam fora da expedição.
3. Aplicar melhorias de nível e trocar Carismas (Casa de Exercícios).
4. Melhorar equipamentos (Forja) e equipar relíquias.
5. Comprar provisões (Despensa).
6. Pagar leitos da Enfermaria.
7. Abrir o **Mapa do Inferno** pelo Portão e escolher o círculo e o ponto de partida (Portão do círculo ou Pouso consagrado).

Sugestões automáticas: santos com ferimento grave são sugeridos para a Enfermaria, e os com desolação ≥ 100 para o Jardim e Claustro; melhorias de equipamento possíveis (D-278); provisões sugeridas pelo histórico do círculo.

## 3. Instalações

| Instalação | Desbloqueio | Nível 1 | Nível 2 | Nível 3 |
| --- | --- | --- | --- | --- |
| Capela | Inicial | 1 vaga de oração | 2 vagas | 3 vagas (só Sufrágios, D-469) |
| Enfermaria | Inicial | 1 leito | 2 leitos | 3 leitos |
| Despensa | Inicial | Provisões básicas; alforje de 8 espaços | Preços −15%; alforje de 10 espaços | Preços −30%; alforje de 12 espaços |
| Portão | Inicial | Sem níveis (D-469): chegada dos santos novos, escolha da equipe, acesso ao Mapa do Inferno. O caminho revela sempre 1 camada à frente | — | — |
| Jardim e Claustro | Após o Limbo (D-474) | 1 vaga de descanso | 2 vagas | 3 vagas |
| Casa de Exercícios | Após o Prólogo | Aplica melhorias de nível | Troca de Carisma −50% | Troca de Carisma grátis |
| Forja | Após o Prólogo | Equipamento até nível 2 | Até nível 3 | Melhorias −20% |
| Biblioteca | Após o Círculo 3 | Resistências dos inimigos; **Livro das Obras** (§10.1, D-275) | + conteúdo dos nós | + fases dos chefes |
| Carmelo | Após o Círculo 3, por [carmel_cost] (1.500) | Ver §5 | — | — |
| Relicário | Após o Círculo 4 | Equipar relíquias raras | — | Fundir 2 sacramentais iguais em 1 aprimorado (+50% do efeito) |

Custo de melhoria: nível 2 = [facility_l2_cost] (1.500); nível 3 = [facility_l3_cost] (2.500).

**Nova divisão (D-469, D-474):** o Jardim volta com o nome **Jardim e Claustro**, guardado por São Francisco de Assis, e é o lugar da cura da desolação; abre logo depois do Limbo, para que haja como curar a desolação desde o começo. A Capela fica só com os Sufrágios. O alforje maior passa do Portão para a Despensa, com os mesmos números (`gate_slots_l*` muda de nome na T48). O Portão perde a revelação de camadas por nível: vale sempre a do nível 1.

## 4. Designação semanal

| Lugar | Efeito por semana |
| --- | --- |
| Capela | +[chapel_suffrages] (3) Sufrágios |
| Jardim e Claustro | −[garden_desolation_per_week] (50) de desolação |

O santo designado não participa da expedição da semana. Não há bônus por afinidade com o guardião.

**Aprovado, a simular (D-283, M3):** cada santo na Capela dá à expedição uma **Súplica**: a atividade de Pouso dele, usada à distância, uma vez, quando o jogador quiser, sem gastar a vez de ninguém nem Fervor e sem consumir Sufrágios. Limite proposto: uma Súplica por combate. Revisão teológica antes do texto.

## 5. Carmelo e Moradas

- O Carmelo está **em ruínas desde o início**; "construir" é **reformar**, pelo mesmo custo e com os mesmos efeitos (D-262).
- A reforma desbloqueia **São João da Cruz** e concede a **Morada 1**.
- Cada círculo concluído (chefe vencido pela primeira vez) depois da reforma concede a Morada seguinte, até a 7ª.
- **Cada Morada acende uma das sete janelas do Carmelo** na vila (efeito do motor). As sete janelas continuam.
- **Três marcos visíveis** (D-266 (5)), no lugar dos 7 bônus pequenos: só as Moradas **1, 4 e 7** dão benefício, e cada um é uma mudança que o jogador sente. As outras Moradas acendem a janela e não mudam regra.

| Morada | Janela | Marco |
| --- | --- | --- |
| 1 | Acende | **Marco 1** (a definir) |
| 2 | Acende | — |
| 3 | Acende | — |
| 4 | Acende | **Marco 2** (a definir) |
| 5 | Acende | — |
| 6 | Acende | — |
| 7 | Acende | **Marco 3** (a definir) |

O conteúdo de cada marco é decisão de Alan, com o simulador, antes do Carmelo (M3; `open-questions.md`). Os 7 bônus antigos (teste de Fé +5%, desolação × 0,95, Vigília −10, Corrupção −1 pilha, vida +5%, +1 espaço de provisão, +1 Sufrágio na Capela) ficam só como **ponto de partida** para essa escolha; nenhum deles está em vigor.

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

**Aprovado, a desenhar antes da T45 e construir no M3 (D-288, D-351):** cada tempo ganha um verbo e muda **uma regra**, não só um número (conteúdo de Alan); na Quaresma o jogador escolhe uma prática (oração, jejum ou esmola) para as quatro semanas, com prêmio que não é poder; o dia e a noite da vila acompanham o tempo litúrgico. As **penitências** substituem a Escalada nas revisitas (D-290, `expedition.md` §11). Revisão teológica antes dos textos.

**Festas dos santos:** na semana da festa de um santo jogável, ele ganha +50% de experiência e começa cada combate com −10 de desolação. As semanas de festa ficam em `docs/balance/feasts.csv`, convertendo a data litúrgica real para o tempo correspondente do ano de 20 semanas (a preencher após a pesquisa do Martirológio).

## 7. Economia

- **Esmolas:** única moeda gasta. Fontes em `expedition.md` §8. **Origem na história (D-266 (1), D-279):** restituição: o que os homens negaram aos pobres, guardado pelos demônios, é restituído pela companhia e consagrado no Pouso; na vila, tudo vai para obras de cuidado. Texto de Alan, como criação do jogo, com revisão teológica; palavra-chave "restituir", nunca "saquear" ou "ganhar".
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
| 3 | 100 | Atributos + 1 melhoria + segundo Carisma (D-281) |
| 4 | 180 | Atributos + 1 melhoria + 2º espaço de relíquia |
| 5 | 280 | Atributos + milagre aprimorado |

- Ganho de atributos por nível em `saints.csv` (`hp_per_level`, `faith_per_level`).
- **Melhoria de habilidade:** escolher uma habilidade ainda não melhorada; ela passa à versão `+`. Sem custo em Esmolas; aplicada na Casa de Exercícios.
- **Regra geral da versão `+`** (vale quando o campo `upgrade` de `abilities.csv` está vazio): o primeiro efeito com número ganha +30%, arredondando meio para cima, com mínimo de +1 (desolação negativa conta pelo valor absoluto); se a habilidade não tiver número, a primeira condição aplicada ganha +1 pilha; `hp_fraction` ganha +0,1. O custo em Fervor nunca muda. O milagre aprimorado do nível 5 segue a mesma regra.
- **Carismas (nível 3), simplificados (D-272, D-281):** o kit atual do santo **é o primeiro Carisma** (com o nome do GDD §3; Jorge: "Cavaleiro"). O **segundo Carisma** troca só **o traço e uma habilidade** (24 peças no total; conteúdo de Alan) e abre no **nível 3**. O jogador escolhe entre os dois na Casa de Exercícios; troca paga como hoje. Os dois são trocas, nunca melhoria. A Purificação não abre Carisma. M3.
- **Equipamento:** 2 espaços por santo (Instrumento e Hábito), próprios do santo, 3 níveis melhorados na Forja. Instrumento: +10% de dano/cura por nível acima do 1. Hábito: +8% de vida máxima por nível acima do 1. **Só números**, sem efeito especial por peça na versão 1 (D-282). Complementos (D-278): (1) a Forja mostra o antes e o depois antes de pagar ("Estocada 7 → 8", "Vida 32 → 35"); (2) cada peça tem nome, tirado do que o santo carrega na arte (nomes de Alan); (3) o nível (I, II, III) aparece na ficha do santo; (4) "Planejar a semana" sugere a melhoria; (5) uma rodada do simulador de economia com a Forja ligada. Equipamento se forja, relíquia se encontra, santo chega: nada sagrado se compra.
- **Relíquias:** 1 espaço (2 no nível 4). Lista e efeitos em `relics.csv`.

## 10. Desbloqueio de santos

| Santo | Desbloqueio |
| --- | --- |
| Jorge, Bento, Teresinha | Início |
| Nicolau de Mira | Semana 3 (Natal) |
| Antão, Joana, Pio, Rita, Antônio, Sebastião | Conclusão dos Círculos 2 a 7, respectivamente |
| João da Cruz | Construção do Carmelo |
| Gertrudes | Marco 3 da trilha do Purgatório |

**Santos de expansão (D-262, D-275):** todo santo novo além destes 12 chega quando a companhia pratica, no jogo, a **Obra de Misericórdia ligada à vida dele** (§10.1). Nunca por compra nem por sorte. Os pares obra–santo são de Alan.

### 10.1 Livro das Obras (conquistas opcionais, D-275, M3)

- Uma seção da **Biblioteca** com as **14 Obras de Misericórdia** da tradição (7 corporais e 7 espirituais; formulação e fonte conferidas por Alan no Catecismo).
- Cada obra tem um feito de jogo que a espelha (pares de Alan; preferir feitos de qualidade a contadores de quantidade).
- **Sem prêmio de poder:** só a página preenchida e um registro no Martirológio.
- Os contadores são gravados no save desde o início; a página aparece pronta quando a Biblioteca abrir.
- Os vitrais da Capela continuam sendo os capítulos da história (D-262).

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
| V08 | Experiência 100 | Nível 3; segundo Carisma liberado |

## 13. Simplificações do M2 (D-173, D-459, D-469, D-474)

O M2 é a fatia vertical: Prólogo, vila mínima e o Círculo 2 inteiro. O resto deste documento vale para o jogo completo; no M2, vale assim:

| Assunto | No M2 | Fica para o M3 |
| --- | --- | --- |
| Edifícios abertos | **Despensa**, **Portão** e **Enfermaria** no nível 1; **Casa de Exercícios** (só as melhorias de nível, sem Carismas) | Melhorias de nível dos edifícios |
| Edifícios com aviso | Capela, Jardim e Claustro, Forja, Biblioteca, Carmelo e Relicário aparecem na vila com o guardião e o aviso de quando abrem (D-459, falas em `docs/design/rascunho-falas-guardioes-vila.md`) | Abrir cada um |
| Alforje | 8 espaços (Despensa nível 1) | 10 e 12 espaços com a Despensa melhorada |
| Semanas | Contam desde a semana 1; a expedição e o Retiro (no máximo um entre expedições) viram a semana | Calendário litúrgico, festas e o "ano que se vive" (D-288) |
| Virada da semana | Cura de ferimentos → eventos de desbloqueio | Capela, Jardim e Claustro, Sufrágios, tempos litúrgicos |
| Ferimentos | Como no §8, com os leitos da Enfermaria nível 1 | — |
| Experiência e níveis | Como no §9: atributos e melhorias de habilidade na Casa de Exercícios | Carismas, equipamento e Forja; 2º espaço de relíquia no nível 4 vale se algum santo chegar lá |
| Relíquias | Equipadas no Portão, na escolha da equipe | Relicário |
| Santos | Jorge, Bento e Teresinha desde o início; **Santo Antão** chega ao concluir o Círculo 2, anunciado por São Cristóvão no Portão (D-458), com o cartão do santo (D-464) | Nicolau de Mira (semana 3) e os demais |
| Mapa do Inferno | Aberto pelo Portão. Mostra a descida inteira (Átrio, Porta, Antinferno, Limbo e os círculos), só com o **Círculo 2** aberto; o resto aparece bloqueado com aviso (D-459). No Círculo 2, escolher a entrada: o Portão do círculo ou um Pouso consagrado | Os outros círculos |
| Desolação na vila | Sem Capela nem Jardim e Claustro, a desolação só baixa nas expedições (Pouso, Vigília, habilidades) e na Purificação | Jardim e Claustro, −50 por semana |

**Pendente (Alan):** no M2 o Limbo não existe, e a campanha começa no Círculo 2. A regra "o Jardim e Claustro abre depois do Limbo" deixa o M2 sem cura de desolação na vila. A proposta é abrir o Jardim e Claustro no nível 1 já no M2, com a arte antiga do Jardim, e o −50 por semana.

**Casos de teste do M2** (somam-se ao §12):

| # | Cenário | Esperado |
| --- | --- | --- |
| V09 | Comprar provisões sem Esmolas suficientes | Recusado, sem mudar nada |
| V10 | Comprar a 9ª provisão com a Despensa no nível 1 | Recusado: alforje cheio |
| V11 | Leito pago para um ferido grave | Curado na semana seguinte; Esmolas −300 |
| V12 | Retiro logo depois de outro Retiro | Recusado (V01) |
| V13 | Concluir o Círculo 2 pela primeira vez | Antão entra no elenco; São Cristóvão o anuncia ao voltar à vila |
| V14 | Abrir o Mapa do Inferno no M2 | Só o Círculo 2 aceita entrada; o Pouso consagrado aparece como entrada |

