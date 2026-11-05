# Ad Inferos: A Companhia dos Santos — GDD v1.1

Nov 3, 2026 · @Alan

Esta versão substitui o GDD v1.0 e incorpora as decisões tomadas na Revisão Crítica e na Análise de Roteiro e Pipeline de Arte. As recomendações das revisões, aprovadas em bloco, estão na seção 12.

## O que mudou da v1.0

| Área | Mudança |
| --- | --- |
| Título | *Ad Inferos: A Companhia dos Santos* |
| Princípio | Tudo é alegoria; divergências das fontes são registradas, sem gerar mecânica nova; sistemas simplificados |
| Combate | Mover-se gasta a ação; acerto determinístico; Precisão removida; sem Desfazer; vulnerabilidade ×1,25 e resistência ×0,75 |
| Habilidades | 4 básicas, 2 de Fervor e milagre fixo; melhoria por nível, sem moeda própria |
| Condições | Esquema padronizado; 6 condições centrais e 3 de ambiente |
| Desolação | Valores iniciais definidos; Prostração não gera desolação nos aliados |
| Elenco | Teresa d'Ávila vira Guardiã do Carmelo; João da Cruz é desbloqueado com o Carmelo; entram Nicolau de Mira (Natal) e Santa Gertrudes (Purgatório, no lugar de Nicolau de Tolentino) |
| Expedição | 4 nós por trecho (3 no último); nó de Vigília antes do chefe; tipos de nó visíveis; Pão por equipe; retomada do Pouso com Lume 75 |
| Economia | Custos reduzidos; habilidades fora da economia de Esmolas |
| Carmelo | Sete Moradas, uma por círculo concluído |
| Vila | Afinidades com guardiões removidas |
| Narrativa | Peregrino resgatado e alegórico; flashback ao fim de cada círculo; almas inspiradas em Dante sem os nomes originais; São Gabriel em Dite; epílogo do Céu sempre presente |
| Círculos | Estrutura de Dante preservada: três anéis no Círculo 7, dez valas no Círculo 8, gigantes na transição |
| Fontes | Hierarquia de fontes; Martirológio só para santos e arcanjos; Arquivo de Santo Tomás para o resto |

**Dois ajustes derivados**, que decorrem das decisões e foram aprovados em 03/11/2026:

1. **Carmelo disponível após o Círculo 3**, e não após o 4. Com uma Morada por círculo concluído, só assim as sete Moradas cabem na campanha (construção = Morada 1; Círculos 4 a 9 = Moradas 2 a 7).
2. **Condições:** a simplificação aprovada previa 8; ficaram 6 centrais e 3 que só existem nos seus círculos, porque Provocação é necessária para o kit de Sebastião.

## 1. Visão geral e princípios

RPG tático por turnos para Android, classificação 18 anos, em que uma companhia de santos católicos segue um Peregrino vivo pelos nove círculos do Inferno de Dante para libertar sua alma das garras de Lúcifer.

| Item | Definição |
| --- | --- |
| Plataforma | Android primeiro, orientação paisagem |
| Engine | Godot, desenvolvimento assistido por Claude Code |
| Gênero | RPG tático por turnos, com gestão de companhia e mapa de nós |
| Classificação | 18 anos |
| Sessão | Expedições de 30 a 45 min, com salvamento a cada nó |
| Época | Medieval em toda a ambientação |
| Modelo de negócio | Sem compras dentro do jogo; preço do download a decidir; projeto de portfólio |
| Arte | Gerada por IA, com correções pontuais |
| Idioma | Português na versão 1 |

**Princípios**

1. **Base nas fontes, forma alegórica.** O jogo se apoia em Dante, nas Escrituras e na tradição judaico-cristã, com fundo catequético. Tudo é apresentado como visão alegórica, nunca como afirmação doutrinal.
2. **Divergências são registradas, não viram mecânica.** Quando o jogo se afasta de uma fonte, isso fica anotado no Martirológio (santos) ou no Arquivo de Santo Tomás (o resto), sem criar regra nova.
3. **Simplicidade de sistemas.** Uma ideia só entra como mecânica se melhorar uma decisão do jogador; o resto fica em narrativa.
4. **Reverência.** Tradição católica tratada com respeito, numa fantasia sombria e adulta. A vitória final pertence a Cristo.
5. **Legibilidade mobile.** Informação essencial sempre visível; o restante ao tocar.

**Referências de design**

| Referência | O que se aproveita | O que fica de fora |
| --- | --- | --- |
| Darkest Dungeon | Posições, mover gasta a ação, estrutura comum de personagens, vila com instalações, tocha (Lume), acampamento (Pouso), estresse (desolação), poses de impacto | Morte permanente, heróis descartáveis |
| Darkest Dungeon II | Caminhos (Carismas), fichas de condição | Corrida única |
| Slay the Spire | Mapa de nós visível, intenções visíveis, energia por turno (Fervor), Ascensão (Escalada) | Cartas |
| The Life and Suffering of Sir Brante | Escolhas com requisitos visíveis | Consequências nas revisitas |
| Fear & Hunger | Tentações com risco visível | Aleatoriedade cruel, punições permanentes |

## 2. Combate

Turno de equipe com intenções inimigas visíveis: os três santos agem, depois os inimigos executam o que anunciaram; o resultado de cada ação é sempre previsível.

**Formação e movimento**

- 3 santos em 3 posições (vanguarda, centro, retaguarda); inimigos em até 4 posições; chefes ocupam 2 ou 3.
- Cada habilidade declara de onde pode ser usada e quais posições atinge.
- **Trocar de lugar com um aliado adjacente gasta a ação do santo.**

**Turno de equipe**

1. A equipe recebe +3 de Fervor.
2. Cada santo age no máximo uma vez, na ordem escolhida pelo jogador.
3. No máximo 1 provisão por turno, sem gastar ação.
4. Os inimigos executam as intenções exibidas (com número de dano).
5. Efeitos de ambiente do círculo.

Não há Desfazer: a pré-visualização de alvo mostra o resultado antes da confirmação.

**Acerto e dano**

- Acerto **determinístico**: habilidades sempre acertam. Não existe atributo de Precisão.
- Golpe e Exorcismo: dano **×1,25** contra o tipo vulnerável e **×0,75** contra o resistente.
- Críticos só por efeito explícito de habilidade ou de chefe, nunca por sorte.

**Fervor**

| Regra | Valor |
| --- | --- |
| Ganho por turno | +3 |
| Máximo acumulado | 6 |
| Sobra entre turnos | Acumula até o máximo |
| Habilidades básicas | Custo 0 ou 1 |
| Habilidades de Fervor | Custo 2 |
| Milagres | Custo 3 ou 4 |
| Entre combates | Reinicia |

**Estrutura de habilidades**

- 6 habilidades por santo: 4 básicas e 2 de Fervor. O santo equipa 4.
- Milagre-assinatura fora dos espaços, sempre disponível.
- Sem recargas; habilidades excepcionais são "1 vez por combate".

**Condições**

Toda condição tem os mesmos campos: tipo (**ficha**, consumida ao disparar, ou **duração**), intensidade, limite, acúmulo, decaimento, momento do efeito, resistência (subtração fixa de pilhas, sem sorte), remoção e exibição.

| Condição | Tipo | Regra |
| --- | --- | --- |
| Atordoamento | Ficha, máx. 1 | Cancela a próxima ação ou intenção; ao sair, imunidade a novo atordoamento por 1 turno |
| Sangramento | Duração, máx. 5 | Dano igual às pilhas no início do turno do afetado; −1 por turno; removido por Ataduras |
| Corrupção | Duração, máx. 5 | Desolação igual a 3× pilhas no início do turno; removida por Água Benta e Exorcismo |
| Amparo | Ficha, máx. 3 | Próximo golpe recebido −50% |
| Força | Ficha, máx. 3 | Próxima ação +25% de dano |
| Provocação | Ficha, máx. 1 | Inimigos de alvo único precisam atacar este alvo |
| Congelamento (só Círculo 9) | Duração, máx. 3 | +1 por turno sem mudar de posição; com 3, perde a ação e zera |
| Fúria (só Círculo 5, inimigos) | Permanente no combate, máx. 5 | +10% de dano por pilha |
| Torpor (só Círculo 5, santos) | Duração, máx. 3 | +1 por turno sem milagre; com 3, −1 de Fervor no turno seguinte |

No máximo 3 ícones por personagem, com "+N" para o restante. Ferimento (estado de vila) e estados de desolação (na auréola) não aparecem como condição.

**Queda em combate**

- Com 0 de vida, o santo fica Caído; pode ser levantado por cura em até 2 turnos.
- Se terminar o combate caído, volta com 1 de vida e ferimento leve; a segunda queda na mesma expedição gera ferimento grave.
- Três santos caídos ao mesmo tempo = derrota. Não há morte permanente.

## 3. Santos

Doze santos jogáveis com estrutura comum e habilidades derivadas da vida de cada um; o elenco inicial tem três santos, e o quarto chega no primeiro Natal.

**Estrutura comum**

- Atributos: Vigor (vida), Proteção, Fé (resistência à desolação) e Vontade (resistência a condições).
- Rótulos de função: Protetor, Curador, Combatente, Exorcista (controle) e Intercessor (suporte).
- 6 habilidades (4 básicas, 2 de Fervor), 4 equipadas; milagre-assinatura fixo; 1 traço passivo; 2 Carismas; 1 atividade própria de Pouso; 2 espaços de relíquia.
- Nível de 1 a 5; santos na reserva recebem 50% da experiência.

**Progressão \[Premissa a validar\]**

| Nível | Ganho |
| --- | --- |
| 2 | +atributos e 1 melhoria de habilidade à escolha |
| 3 | +atributos, 1 melhoria e acesso aos Carismas |
| 4 | +atributos, 1 melhoria e segundo espaço de relíquia |
| 5 | +atributos e versão aprimorada do milagre |

As melhorias vêm do nível, sem custo em Esmolas. A Casa de Exercícios é onde elas são aplicadas e onde se troca de Carisma, por um custo pequeno.

**Elenco**

| Desbloqueio | Santo | Função | Posição | Traço | Milagre (Fervor) | Carismas |
| --- | --- | --- | --- | --- | --- | --- |
| Inicial | São Jorge | Combatente, Protetor | Vanguarda | Duelo: o alvo marcado recebe mais dano de Jorge e sofre contra-ataque ao atingi-lo | Lança do Dragão \[lenda\] (3) | Cavaleiro · Matador de Dragões |
| Inicial | São Bento | Exorcista, Protetor | Vanguarda, Centro | Clausura: aliados adjacentes resistem a deslocamento e desolação | Vade Retro (3): empurra 2 posições e atordoa | Abade · Exorcista |
| Inicial | Santa Teresinha | Curadora | Retaguarda | Pequeno Caminho: 3 ações básicas tornam a próxima cura gratuita | Chuva de Rosas (3) | Pequena Via · Padroeira das Missões |
| 1º Natal (semana 3) | São Nicolau de Mira | Intercessor, Protetor | Centro | Caridade: provisões usadas por ele num aliado têm efeito dobrado *(proposta)* | As Três Bolsas \[tradição\] (3): Força e Amparo a todos os aliados *(proposta)* | Bispo de Mira · Protetor dos Necessitados *(proposta)* |
| Círculo 2 | Santo Antão | Exorcista, Combatente | Vanguarda, Centro | Ermitão: mais forte quanto mais desolação carrega | Combate no Sepulcro (3) | Asceta · Pai do Deserto |
| Círculo 3 | Santa Joana d'Arc | Combatente, Intercessora | Vanguarda, Centro | Estandarte: aliados causam mais dano enquanto ela está na vanguarda | Libertação de Orléans (3) | Comandante · Donzela de Guerra |
| Carmelo (após o Círculo 3) | São João da Cruz | Intercessor | Centro, Retaguarda | Noite Escura: converte desolação de um aliado em consolação | Chama Viva de Amor (3) | Místico · Reformador |
| Círculo 4 | São Padre Pio | Exorcista, Curador | Centro | Bilocação: age de duas posições ou troca de lugar sem gastar ação | Estigmas (3) | Confessor de Pietrelcina · Combatente Espiritual |
| Círculo 5 | Santa Rita de Cássia | Curadora, Protetora | Centro | Causas Impossíveis: efeitos dobram com aliado abaixo de 25% de vida | Rosa no Inverno \[lenda\] (3) | Pacificadora · Espinho da Coroa |
| Círculo 6 | Santo Antônio de Pádua | Intercessor, Exorcista | Centro, Retaguarda | Achados: recupera um consumível ou Fervor gasto | Sermão aos Peixes \[lenda\] (3): atordoa inimigos em duas posições escolhidas | Pregador · Martelo dos Hereges |
| Círculo 7 | São Sebastião | Protetor | Vanguarda | Sobrevivente: na primeira queda, levanta com 1 de vida | Muralha de Flechas (3) | Soldado da Guarda · Mártir |
| Trilha do Purgatório, marco 3 | Santa Gertrudes | Curadora, Intercessora | Retaguarda | Almas Benditas: no início de cada rodada, remove 1 pilha de condição negativa do aliado mais afetado *(proposta)* | Sufrágio (3): bênção que cresce com os Sufrágios acumulados | Mística de Helfta · Intercessora das Almas *(proposta)* |

Os itens marcados *(proposta)* foram aprovados em 03/11/2026.

**Tutorial da Noite Escura:** com João da Cruz fora do elenco inicial, quem ensina o sistema é Santa Teresinha, cuja provação de fé nos últimos meses de vida deve ser confirmada na pesquisa do Martirológio.

**Afinidades (só em combate)**

| Afinidade | Membros | Bônus |
| --- | --- | --- |
| Carmelo | João da Cruz, Teresinha | Resistência à desolação |
| Franciscanos | Antônio de Pádua, Padre Pio | +1 de Fervor no primeiro turno |
| Pais do Monaquismo | Antão, Bento, Gertrudes | Exorcismo ampliado |
| Soldados de Cristo | Jorge, Joana d'Arc, Sebastião | Golpe ampliado |

A Afinidade Agostiniana sai com Nicolau de Tolentino.

## 4. Expedição

Cada círculo é uma expedição de 3 trechos num mapa de nós sempre visível; o progresso fica salvo nos Pousos consagrados, e cada círculo se completa em 1 ou 2 expedições.

**Estrutura:** Portão → Trecho 1 (4 nós) → Pouso → Trecho 2 (4 nós) → Pouso → Trecho 3 (3 nós) → Vigília → Chefe.

- **Tipos de nó sempre visíveis.** O Portão e a Biblioteca revelam o **conteúdo** (família de inimigos, recompensa).
- Composição de cada trecho, escolhida pela rota: 2 combates, 1 Tentação ou Encontro, 1 nó variável (elite, relíquia ou combate).
- **Nó de Vigília garantido antes do chefe.**
- Pouso alcançado fica consagrado; a próxima expedição pode partir dele, com **Lume 75**.
- Duração-alvo: expedição longa de 40 a 45 min; salvamento a cada nó.

**Lume:** de 0 a 100, −5 por nó, Velas +25. Com 11 nós, a equipe chega ao chefe com Lume 45 sem usar Velas.

| Lume | Efeito |
| --- | --- |
| 75–100 | Menos emboscadas; desolação −20% |
| 25–74 | Neutro |
| 0–24 | Desolação +30%; inimigos +10% de dano; Esmolas +50% e mais relíquias ocultas |

**Provisões:** o Portão define os espaços (8, 10 ou 12); cada espaço guarda uma unidade.

| Item | Uso |
| --- | --- |
| Pão | 1 por equipe para descansar no Pouso; cura um pouco |
| Vela | +25 de Lume |
| Água Benta | Remove Corrupção e reduz desolação |
| Ataduras | Removem Sangramento |
| Incenso | Revela nós vizinhos ou impede emboscada no Pouso |

Sacramentos nunca viram consumíveis.

**Pouso:** descansar custa 1 Pão para a equipe. Cada santo escolhe uma atividade: Vigília (reduz muito a própria desolação), Partilha (cura um aliado), Oração (+1 de Fervor no próximo combate) ou sua atividade própria. Há 25% de chance de emboscada noturna, anulada por Incenso. Esmolas levadas até o Pouso ficam garantidas.

**Retirada e derrota**

| Situação | Quando | Consequência |
| --- | --- | --- |
| Retirada planejada | No Pouso | Sem custo além da semana; mantém Esmolas e progresso |
| Retirada de emergência | Em combate, exceto chefe | Perde 50% das Esmolas não garantidas; +25 de desolação e 1 ferimento leve em cada santo |
| Derrota | Três santos caídos | Perde Esmolas não garantidas e relíquias encontradas; ferimento grave em todos; Pousos consagrados mantidos |

## 5. Desolação e consolação

A desolação substitui o estresse de Darkest Dungeon com vocabulário de Santo Inácio e São João da Cruz; nenhum estado representa pecado ou perda de santidade, e o santo nunca perde o controle.

Cada santo tem uma escala de 0 a 200.

**Valores iniciais \[a validar no protótipo\]**

| Fonte | Desolação por santo |
| --- | --- |
| Combate comum | +12 |
| Elite | +20 |
| Chefe | +35 |
| Tentação mal resolvida | +15 |
| Aliado caído | +15 nos outros (não se aplica à Prostração) |
| Vigília no Pouso | −40 |
| Lume 75–100 / 0–24 | ×0,8 / ×1,3 |

**Estados**

| Gatilho | Estado | Efeito |
| --- | --- | --- |
| Chega a 100 e passa no teste de Fé | Consolação | Fortalecimento até o fim da expedição; desolação volta a 50 |
| Chega a 100 e falha no teste | Noite Escura | Não pode gastar Fervor; mantém habilidades básicas e traços passivos |
| Chega a 200 | Prostração | Caído até o fim do combate e ferimento grave; fora de combate, ferimento grave e volta a 150 |
| Cai abaixo de 50 durante a Noite Escura | Purificação | Fim da Noite Escura; +25% de experiência na expedição |

**Teste de Fé:** chance de Consolação = 10% + 4% × Fé (Fé de 0 a 10, teto de 60%). A chance aparece na tela quando a desolação passa de 75.

**Recuperação:** João da Cruz e outros intercessores em combate, Vigília no Pouso, Água Benta, Capela e Jardim na vila.

## 6. Vila, calendário e economia

A vila fica no Átrio, um lugar fora do tempo medido pelos dias do Peregrino na terra; cada retorno de expedição avança 1 semana, e as Esmolas pagam instalações, equipamentos, provisões e tratamento.

**Instalações e guardiões**

| Instalação | Guardião | Função | Desbloqueio |
| --- | --- | --- | --- |
| Capela | Santo Agostinho e Santa Mônica | 1 a 3 vagas de oração; gera Sufrágios; vitrais | Inicial |
| Enfermaria | São Cosme e São Damião | Cura ferimentos; leitos de tratamento acelerado | Inicial |
| Despensa | Santa Isabel da Hungria | Provisões | Inicial |
| Portão | São Cristóvão | Espaços de provisão; conteúdo dos nós | Inicial |
| Casa de Exercícios | Santo Inácio de Loyola | Aplicar melhorias de nível; trocar Carisma | Após o Limbo |
| Forja | Santo Elói | Equipamento até o nível 3 | Após o Limbo |
| Biblioteca | Santo Tomás de Aquino | Bestiário; Arquivo de Santo Tomás | Após o Círculo 3 |
| **Carmelo** | **Santa Teresa d'Ávila** | Desbloqueia João da Cruz; avança uma Morada por círculo concluído | Após o Círculo 3, por 1.500 Esmolas |
| Relicário | Santa Helena | Espaços e fusão de relíquias | Após o Círculo 4 |
| Jardim | São Francisco de Assis | 1 a 3 vagas de recuperação de desolação | Após o Círculo 5 |
| Coro (expansão) | Santa Cecília | — | Fora da versão 1 |

Cada instalação tem 3 níveis, exceto o Carmelo, que tem 7 Moradas.

**As Sete Moradas do Carmelo**

Inspiradas em *O Castelo Interior*, de Santa Teresa; a construção é a Morada 1, e cada círculo concluído depois dela abre a seguinte, até a 7ª no fim da campanha. São uma abstração lúdica, nunca a sugestão de que estágios espirituais se compram. Cada Morada concede um benefício pequeno a toda a companhia, nesta ordem: recolhimento e consolação, resistência à desolação, recuperação, proteção espiritual, fortalecimento da comunidade, preparação para a jornada, intercessão.

**Designação semanal:** um santo na Capela fica fora da expedição, gera Sufrágios e recupera um pouco de desolação; no Jardim, recupera muita desolação. Não há bônus por afinidade com o guardião.

**Calendário litúrgico (20 semanas, cíclico; a campanha começa no 1º domingo do Advento)**

| Tempo | Semanas | Efeito |
| --- | --- | --- |
| Advento | 1–2 | Provisões 20% mais baratas; santos começam o combate com consolação |
| Natal | 3–4 | Evento especial; ferimentos curam em dobro; **São Nicolau de Mira se junta à companhia na semana 3** |
| Tempo Comum I | 5–8 | Neutro |
| Quaresma | 9–12 | Desolação +25%; Sufrágios +50%; Exorcismo +10% |
| Páscoa | 13–16 | +1 de Fervor inicial; evento especial |
| Tempo Comum II | 17–20 | Todos os Santos (+experiência) e Finados (Sufrágios em dobro) |

Na semana da festa de um santo jogável, ele recebe +50% de experiência e começa o combate com consolação.

**Economia**

- **Esmolas:** moeda única; vêm de nós de recompensa, chefes, conclusão de círculos e eventos.
- **Sufrágios:** nunca gastos; avançam a trilha do Purgatório.

| Item | Esmolas |
| --- | --- |
| Expedição média, Círculos 1–3 | 500–800 |
| Expedição média, Círculos 7–9 | 2.000–3.000 |
| Instalação nível 2 / nível 3 | 1.500 / 2.500 |
| Equipamento nível 2 / nível 3 | 300 / 800 |
| Leito da Enfermaria por semana | 300 |
| Carmelo | 1.500 |

Meta: ao fim da campanha, o jogador pagou 70 a 80% do essencial e cerca de 35% de tudo. Revisitas diminuem a recompensa (100%, 75%, 50%, 25%) dentro do mesmo tempo litúrgico.

**Ferimentos**

| Tipo | Penalidade | Cura natural | Com leito |
| --- | --- | --- | --- |
| Leve | −10% em um atributo | 1 semana | — |
| Grave | −20% em dois atributos | 3 semanas | 1 semana |

**Imersão:** vitrais da Capela como tela de conquistas; Conselho da vila ao fim de cada círculo; Martirológio dos santos.

## 7. Trilha do Purgatório

Os Sufrágios nunca são gastos: avançam 10 marcos que narram almas chegando ao Céu pela misericórdia de Deus; as recompensas representam a gratidão das Almas Benditas, não uma compra.

| Marco | Recompensa |
| --- | --- |
| 1 | Missão de Intercessão I e um vitral |
| 2, 4, 6, 8 | Bênção permanente pequena |
| 3 | **Santa Gertrudes** se junta à companhia |
| 5, 9 | Relíquia exclusiva |
| 7 | Missão de Intercessão II |
| 10 | Cena final da trilha e último vitral |

**Fontes de Sufrágios:** santos em oração na Capela, Missões de Intercessão, bônus da Quaresma e de Finados.

**Missões de Intercessão:** eventos narrativos sem combate, com requisitos visíveis.

**Regras de coerência:** o Purgatório não é círculo do Inferno; não há combate contra almas; nenhuma recompensa sugere que a salvação é comprada. O epílogo do Céu no final 3 acontece sempre, com ou sem a trilha completa.

## 8. Círculos, inimigos e chefes

A estrutura moral de Dante é preservada; os inimigos são demônios, guardiões do poema e pecados encarnados, num total de 19 comuns, 16 elites e 9 chefes.

**Funções táticas e famílias**

| Função | Família A · Incontinência (2–5) | Família B · Dite e Violência (6–7) | Família C · Fraude e Traição (8–9) |
| --- | --- | --- | --- |
| Bruto | Diabo de Lodo (C) | Cornífero de Ferro (C) | Malebranche (C) |
| Guarda | Escaravelho Infernal (C) | Sentinela de Dite (E) | Sentinela Gélida (E) |
| Atirador | Moscardo (C) | Arqueiro Centauro (C) | Arpoeiro (C) |
| Corruptor | Sombra do Desejo (E) | Caído de Dite (E) | Vulto Mascarado (E) |
| Manipulador | Sopro Errante (E) | Harpia (C) | Serpente Ladra (C) |
| Invocador | Mãe-Enxame (C) | Fornalheiro (C) | Arauto da Mentira (E) |

(C) Corpóreo, fraco a Golpe · (E) Espiritual, fraco a Exorcismo. Abadom e Legião ficam como reserva de elites. Caído das Muralhas (C, Guarda): anjo caído de armadura negra, inimigo comum exclusivo do Círculo 6, o 19º comum. Pecados Encarnados são todos Espirituais; Asmodeu e Azazel também. Medusa e as Fúrias: na saída do Círculo 5, bloqueiam os portões de Dite e São Gabriel os abre (cena); recuadas para dentro da cidade, voltam como a elite do Círculo 6. O olhar da Medusa marca uma posição e atordoa quem estiver nela no turno seguinte (usa a condição de Atordoamento, sem mecânica nova); as Fúrias, como escolta, aplicam desolação.

**Estrutura de cada círculo**

| Círculo | Estrutura (Dante) | Mecânica de ambiente | Guardião | Pecado Encarnado | Chefe |
| --- | --- | --- | --- | --- | --- |
| Antinferno e Limbo | Ignavos; Limbo sem tormento físico, só Encontros | Indecisão | — | — | Caronte |
| 2 Luxúria | Tempestade incessante | Vendaval | Minos | Vertigem | Asmodeu |
| 3 Gula | Chuva imunda e lama | Fome | Cérbero | Voracidade | Belzebu |
| 4 Avareza e Prodigalidade | Pesos empurrados em choque | Ouro Maldito | Pluto | Cobiça | Mamom |
| 5 Ira e Acídia | Iracundos na superfície do Estige; rancorosos submersos | Fúria e Torpor | Flégias | Rancor | Belfegor |
| 6 Heresia | Túmulos ardentes em Dite | Túmulos | Medusa, com as Fúrias como escolta | Cisma | Belial |
| 7 Violência | Três anéis: contra o próximo, contra si mesmo, contra Deus e a arte (representado por blasfemos e usurários) | Chuva de Fogo | Minotauro | Crueldade | Moloque |
| 8 Fraude | Dez valas (abaixo) | Ilusão | Malacoda e os Malebranche; Efialtes acorrentado na transição | Engano | Azazel |
| 9 Traição | Caína, Antenora, Ptolomeia, Judeca | Congelamento | Traidores Atados (ambiente) | Perfídia | Lúcifer |

**As dez valas do Círculo 8**

| Trecho | Valas |
| --- | --- |
| 1 | 1 Sedutores · 2 Aduladores · 3 Simoníacos |
| 2 | 4 Adivinhos · 5 Barateiros (Malebranche no piche) · 6 Hipócritas (capas de latão de brilho falso) · 7 Ladrões (serpentes) |
| 3 | 8 Conselheiros fraudulentos · 9 Semeadores de discórdia · 10 Falsificadores |
| Transição | Poço dos Gigantes; Anteu desce a companhia ao Cocito como cena |

**Chefes e fundamentação**

| Chefe | Mecânica | Fonte | Cuidado |
| --- | --- | --- | --- |
| Caronte | Barca e empurrões; ensina posições | *Eneida* VI; *Inferno* III | Figura clássica, não bíblica |
| Asmodeu | O fígado do peixe permite a intervenção de Rafael | Tobias 3 | Três cabeças vêm do *Dictionnaire Infernal* |
| Belzebu | Devora os servos para se fortalecer | 2 Reis 1; Mateus 12,24 | Não fundir com Lúcifer |
| Mamom | Converte Fervor em escudo; vencido por renúncia | Mateus 6,24; Lucas 16,13 | Personificação posterior |
| Belfegor | Dorme; acorda com fúria proporcional ao dano | Baal-Peor, Números 25 | Ligação com a preguiça é de Binsfeld |
| Belial | Converte fortalecimentos em penalidades | 2 Coríntios 6,15; Qumran | — |
| Moloque | Ídolo-fornalha com contagem regressiva | Levítico 18,21; 2 Reis 23,10 | Demônio pessoal é tradição posterior |
| Azazel | Copia habilidades e se esconde | Levítico 16; 1 Enoque | 1 Enoque não é canônico |
| Lúcifer | Três faces, seis asas, congelamento; São Miguel na fase final | Isaías 14,12; Lucas 10,18; Apocalipse 12; *Inferno* XXXIV | Aplicação de Isaías 14 a Satanás é leitura patrística |

**Escalada (revisitas sem narrativa):** cinco níveis cumulativos (+15% de vida; Lume −10 por nó; elites em dobro; Pouso intermediário não consagra; chefe com fase extra); recompensa +25% por nível.

## 9. Narrativa

O Céu envia a companhia de santos para resgatar a alma de um Peregrino vivo, figura alegórica de toda pessoa, que está sendo arrastada pelo Inferno; a companhia o segue logo atrás, círculo por círculo, e ao fim de cada círculo um flashback mostra a queda e a lição daquele pecado.

**Premissa**

- **O Peregrino:** alegoria da condição humana, sem nome e com biografia mínima: só o necessário para os flashbacks e o leito. Não é moralmente superior aos condenados; está diante do que também poderia se tornar.
- **A verdade da história:** o Peregrino está morrendo numa cama. A viagem pelo Inferno é a alegoria das falhas da vida dele; a companhia intercede por uma alma ainda viva. O jogo segue a estrutura da *Comédia*: Inferno, Purgatório e Paraíso.
- **Quem envia:** Nossa Senhora se compadece e manda Santa Luzia com o recado, como no canto II do *Inferno*. Beatriz é omitida.
- **Guia:** o Anjo da Guarda do Peregrino, no papel de Virgílio.
- **A vila:** o Átrio, concedido pela graça para a companhia se preparar.

**Ritmo de cada círculo**

1. A companhia chega ao círculo logo atrás do Peregrino.
2. Flashback curto **antes** da primeira expedição do círculo: o momento da tentação.
3. Expedição: combates, Tentações e o Encontro com uma alma.
4. Chefe.
5. Flashback **depois** do chefe: a queda e a lição, com o testemunho dos santos (cada santo presente acrescenta uma fala a partir da própria vida, sem alterar opções).
6. Vinheta do leito de morte.
7. Conselho da vila, com uma decisão.

**Encontros com almas inspiradas em Dante**

As almas mantêm a função das figuras do poema, mas não os nomes; a inspiração fica registrada no Arquivo de Santo Tomás.

| Círculo | Alma | Pecado e lição |
| --- | --- | --- |
| Limbo | Os sábios sem fé | A tristeza da ausência de Deus, sem tormento físico |
| 2 | Os amantes no vento | Paixão desordenada e responsabilidade pelas escolhas |
| 3 | O glutão na lama | O desejo desordenado, não só o excesso de comida |
| 4 | Os que empurram pesos | Apego e desperdício |
| 5 | O iracundo do Estige | A ira; os rancorosos submersos |
| 6 | O orgulhoso no túmulo | O orgulho intelectual |
| 7 | O mestre na areia ardente | Fama e legado |
| 8 | O conselheiro na chama | O conhecimento que transgride limites |
| 9 | O traidor no gelo | Traição e desespero |

**Virtudes e escolhas**

- As escolhas nos Encontros, Tentações e Conselhos alteram as três virtudes teologais do Peregrino: Fé, Esperança e Caridade, de 0 a 5 cada, sempre visíveis.
- Opções bloqueadas mostram o requisito; não há rolagem de dados.
- Revisitas não alteram as virtudes.

**Tentações**

- A Tentação é o eco das tentações do Peregrino: um demônio oferece atalho, poder ou alívio.
- Chance sempre visível, ao menos uma forma de melhorá-la e uma opção segura de recusar.
- O custo recai sobre as virtudes do Peregrino, o Lume, a desolação ou os recursos. **O santo nunca peca.**
- Resistir é sempre apresentado como vitória: ser tentado não é pecar.

**Intervenções angélicas**

| Momento | Anjo | Fonte |
| --- | --- | --- |
| Círculo 2 | Arcanjo Rafael prende Asmodeu | Livro de Tobias |
| Portões de Dite | **São Gabriel** abre os portões, como cena e não como combate | Criação do jogo, inspirada no mensageiro do Canto IX |
| Círculo 8 | Rafael pode intervir contra Azazel | 1 Enoque (não canônico) |
| Final | São Miguel segura Lúcifer | Tradição e Apocalipse 12 |

O jogo reúne assim os três arcanjos nomeados nas Escrituras.

**Confronto final**

O objetivo é libertar a alma do Peregrino antes que o gelo da Judeca a prenda. São Miguel intervém na fase final; a companhia escala o corpo de Lúcifer e emerge para rever as estrelas. Lúcifer continua preso: a vitória definitiva pertence a Cristo.

Ao sair do Inferno a companhia revê as estrelas; a cena corta para o leito, onde o jogador faz o **ato de contrição** pelo Peregrino.

**Finais**

**Final único: a boa morte**

| Etapa | O que acontece | O que varia |
| --- | --- | --- |
| Ato de contrição | Escolha do jogador, depois de Lúcifer | As virtudes definem as palavras: soma 11–15 contrição perfeita, por amor; 6–10 contrição imperfeita, por temor, mas sincera; 0–5 contrição frágil, quase só um pedido de socorro. Todas são válidas \[premissa a validar no roteiro\] |
| Extrema-unção | O frei unge o Peregrino; a mulher idosa reza | — |
| Boa morte | São José e Nossa Senhora à cabeceira | Tom da cena segundo a contrição |
| Purgatório | A alma sobe a montanha do Purgatório | Os Sufrágios acumulados encurtam a purificação: marcos 8–10 passagem breve; 4–7 média; 0–3 longa \[premissa\] |
| Paraíso | A entrada na luz, com a companhia dos santos | — |

O Peregrino sai transformado não por ter ficado imune ao pecado, mas por compreender sua condição e a necessidade de permanecer no caminho.

**Catequese integrada:** pecado, conversão, virtude, graça, intercessão, oração, sacrifício, esperança e Cristo aparecem por meio dos sistemas e da narrativa. Fora do Martirológio, nenhuma explicação doutrinal passa de três frases.

## 10. Fontes, figuras sagradas e conteúdo

Cada elemento do jogo tem origem identificável; figuras sagradas nunca viram unidades nem fontes de bônus; a classificação 18 anos libera violência e horror, mas não sexo explícito, vítimas infantis ou profanação.

**Hierarquia de fontes**

| Nível | Fonte | Uso |
| --- | --- | --- |
| 1 | Sagrada Escritura e Catecismo da Igreja Católica | Fundamentos: Deus, Cristo, Maria, anjos, demônios, pecado, salvação |
| 2 | Tradição, Padres da Igreja, liturgia, hagiografia | Vidas dos santos, separando fato, tradição e lenda |
| 3 | Literatura apocalíptica (ex.: 1 Enoque, não canônico) | Anjos caídos e Sentinelas |
| 4 | Dante, *Divina Comédia* | Geografia e simbolismo do Inferno, nunca como doutrina |
| 5 | Demonologia histórica (Binsfeld, Weyer, Collin de Plancy) | Figuras demoníacas; tradições, não classificação da Igreja |
| 6 | Licença poética | Criações do jogo, sempre identificadas |

**Registros**

- **Martirológio:** só santos e arcanjos. Ficha de cada um: nome e título, época e lugar, contexto, biografia, virtudes, obras, martírio quando houver, memória litúrgica, relação com o jogo, oração ou referência devocional, relíquias com fundamento, e divergências do jogo em relação às fontes. Cada dado é marcado como fato documentado, tradição ou lenda. São mártires no elenco: Jorge e Sebastião; Joana d'Arc foi canonizada como virgem (a confirmar).
- **Arquivo de Santo Tomás** (Biblioteca): demônios, almas, lugares, inspirações em Dante e demais fontes, com as divergências do jogo.
- Nenhuma ficha é escrita sem pesquisa em fontes confiáveis, citadas na própria ficha.

**Orações**

- Aparecem em momentos narrativos, de recolhimento e no final, como expressão de fé, nunca como fórmula mágica.
- A autoria é sempre indicada: texto do próprio santo, oração tradicional ou devoção posterior.
- Textos em latim ou traduções próprias ou de domínio público.
- A atividade Oração do Pouso mantém o efeito de +1 de Fervor, apresentado como disposição para o combate, não como poder da recitação.

**Relíquias**

- Só relíquias de segunda e terceira classe e sacramentais; nenhuma relíquia de primeira classe nem de Cristo é equipável (a Vera Cruz fica no Relicário apenas como objeto de veneração).
- Cada relíquia é ligada a um santo e a um episódio, com a origem marcada, e seu efeito expressa a virtude daquele santo.
- A relíquia aponta para o santo e para Deus, nunca é fonte autônoma de poder.
- A lista aprovada da versão 1 está abaixo (25 relíquias); itens marcados \[tradição\] ou \[a confirmar\] passam por pesquisa antes de entrar no Martirológio.

**Sacramentais (comuns, em nós de relíquia)**

| Relíquia | Efeito |
| --- | --- |
| Medalha de São Bento | −1 pilha de Corrupção recebida |
| Crucifixo de madeira | +1 de Fé |
| Cruz em tau | +5% de Vigor |
| Vela da Candelária | O Lume da equipe cai 4 por nó, em vez de 5 |
| Sal bento | Exorcismo +10% |
| Pão de Santo Antônio | A Partilha no Pouso cura 50% a mais |

**Dos santos do elenco (raras)**

| Relíquia | Classe | Efeito |
| --- | --- | --- |
| Pano tocado no túmulo de São Jorge em Lida \[tradição\] | 3ª | Golpe +10% |
| Fragmento de hábito de Montecassino (Bento) | 2ª | Clausura também protege contra Atordoamento |
| Pétala tocada em relíquia de Santa Teresinha | 3ª | Curas +15% |
| Frasco do maná do túmulo de São Nicolau, em Bari \[tradição\] | 3ª | Provisões usadas pelo portador valem 25% a mais |
| Sino de Santo Antão | Objeto devocional | Desolação recebida −10% |
| Anel atribuído a Santa Joana d'Arc \[a confirmar\] | 2ª | Começa o combate com 1 Força |
| Fragmento de hábito de São João da Cruz | 2ª | Purificação também cura 20% da vida |
| Meia-luva de São Padre Pio | 2ª | Estigmas custa 25% menos vida |
| Rosa benta no dia de Santa Rita | Sacramental | Rosa no Inverno levanta com 60% da vida |
| Lírio tocado no túmulo de Santo Antônio, em Pádua | 3ª | Atordoamento aplicado dura 1 turno a mais em inimigos comuns |
| Ponta de flecha venerada (Sebastião) \[tradição\] | 3ª | Começa o combate com 1 Amparo |
| Véu tocado em Helfta (Gertrudes) | 3ª | Remove 1 condição negativa do portador no início de cada turno |

**Dos guardiões (raras)**

| Relíquia | Efeito |
| --- | --- |
| *Confissões* tocadas no túmulo de Santo Agostinho, em Pavia | +25% de experiência após a Purificação |
| Cíngulo de Santo Tomás \[tradição, a confirmar\] | +1 de Vontade |
| Fragmento de batina de Santo Inácio | +5% de chance de Consolação |
| Cordão franciscano tocado em Assis | Cura recebida pelo portador +10% |
| Caixa de remédios tocada em relíquias de Cosme e Damião | Ferimentos do portador curam 1 semana mais rápido |

**Exclusivas da trilha do Purgatório (marcos 5 e 9)**

| Relíquia | Efeito |
| --- | --- |
| Vela de Finados | +1 Sufrágio por semana quando o portador está na Capela |
| Pequena cruz de Cluny (São Odilo e a comemoração dos fiéis defuntos) \[a confirmar\] | Uma vez por expedição, impede uma Prostração |

**Figuras sagradas**

| Figura | Presença |
| --- | --- |
| Deus Pai e Espírito Santo | Luz, voz, a pomba |
| Jesus Cristo | Iconografia; a vitória final é atribuída a Ele |
| Nossa Senhora | Prólogo e cena final; nunca dá bônus |
| São José | Cena da boa morte, com Nossa Senhora |
| Anjos | Anjo da Guarda, Rafael, Gabriel, Miguel |

**Conteúdo (18 anos)**

- Permitido: violência gráfica, gore, horror demoníaco, os castigos de Dante, nudez artística das almas, blasfêmias na boca dos demônios.
- Proibido: atos sexuais explícitos; sexualização dos santos; crianças como vítimas; métodos de suicídio; profanação de santos e figuras sagradas; representação de figuras de outras religiões.
- Almas e heresias sem caricatura: a dimensão humana é mostrada sem relativizar o pecado.

## 11. Escopo e próximos passos

A versão 1 tem 12 santos, 9 círculos e o prólogo, 19 inimigos comuns, 16 elites, 9 chefes e 11 instalações; a produção segue em fatias, com o combate validado antes de qualquer conteúdo em escala.

**Marcos**

| Marco | Conteúdo | Critério de saída |
| --- | --- | --- |
| M0 · Protótipo de combate | 3 santos, 1 família de inimigos, Fervor, intenções, condições, desolação, simulador | Combate de 2 a 4 min; menos de 5% de ações sem opção útil; nenhuma estratégia dominante |
| M1 · Protótipo de trecho | Mapa de 4 nós, Lume, provisões, Tentação, Pouso, salvamento | Trecho de 10 a 14 min; retomada exata após fechar o app |
| M2 · Fatia vertical no Android | Prólogo e Círculo 2 completos, vila mínima, arte final do trecho | 45 a 60 min de jogo contínuo |
| M3 · Produção por família | Famílias A, B e C em sequência | Cada família aprovada antes da próxima |
| M4 · Narrativa e acabamento | Contrição, boa morte, Purgatório e Paraíso, Conselhos, Martirológio, revisão teológica | Campanha completa; revisão teológica aprovada |

Em paralelo ao M0: piloto de arte com São Jorge e com a Capela (Direção de Arte).

**Questões em aberto**

- [ ] Habilidades completas de cada santo, com números
- [ ] Kits de Nicolau de Mira e Santa Gertrudes (proposta no elenco)
- [ ] Atributos-base e curva de nível
- [ ] Lista de equipamentos (relíquias aprovadas)
- [ ] Números finais de inimigos e fases dos chefes
- [ ] Roteiro dos flashbacks, Encontros, Tentações, Conselhos e Missões de Intercessão
- [ ] Fichas do Martirológio, com pesquisa
- [ ] Datas das festas dos santos no ano de 20 semanas
- [ ] Abordagem de animação (definida pelo piloto)
- [ ] Preço do download

## 12. Regras complementares (aprovadas em 03/11/2026)

Recomendações das revisões aprovadas em bloco; valem como regras e prevalecem sobre trechos anteriores deste documento em caso de conflito.

| # | Proposta | Origem |
| --- | --- | --- |
| P1 | Todo santo tem ao menos uma habilidade básica utilizável de qualquer posição (evita turnos mortos com a movimentação que gasta ação) | Revisão Crítica, G1 |
| P2 | Inimigo morto: a fila avança; santo caído mantém a posição | G1 |
| P3 | Limite de +2 de Fervor extra por turno, além dos +3 da base | G1 |
| P4 | Jorge com **Duelo** (dano extra e contra-ataque) e Sebastião com **Provocação**, para separar os dois | G5 |
| P5 | Todo santo com uma básica de dano; curas distintas: Teresinha em área, Rita no limite, Gertrudes limpando condições | G5 |
| P6 | Equilíbrio Corpóreo/Espiritual: Sentinela de Dite Espiritual (Moscardo e Fornalheiro permanecem Corpóreos), Pecados Encarnados Espirituais, Asmodeu e Azazel Espirituais | G7 |
| P7 | Vendaval anunciado como intenção de ambiente; Fome como cura −50% até usar um Pão; Chuva de Fogo vira contrapasso (cada Golpe causa Sangramento em quem o desfere); Ilusão vira intenções veladas ("?") | G7 |
| P8 | Torpor não se aplica na luta contra Belfegor | E8 |
| P9 | Ajustes de chefes: Asmodeu sem o item ganha só uma fase extra; Mamom aceita renúncia de Esmolas ou relíquia; limiar de Belfegor variável; Belial converte uma ficha por turno; Azazel com pista visual do verdadeiro | G7 |
| P10 | Lúcifer: prisão de gelo do Peregrino como alvo; Contador da Judeca de 0 a 10; atingir uma face silencia sua intenção; São Miguel intervém com a prisão abaixo de 50%; derrota recomeça na Vigília | G7 |
| P11 | Equipamentos: 2 espaços por santo (Instrumento e Hábito), próprios de cada santo, 3 níveis na Forja | G6 |
| P12 | Semana sem expedição só por Retiro, uma vez entre duas expedições; tela única "Planejar a semana" | G6 |
| P13 | Encontros de combate com pelo menos duas funções táticas; grupos fácil e difícil por trecho | G7 |
| P14 | Biblioteca revela resistências, segunda fase dos chefes e conteúdo dos nós | G6 |
| P15 | Kits de Nicolau de Mira e Santa Gertrudes marcados como proposta no elenco | Seção 3 |
| P16 | O Peregrino no leito de morte; final único com ato de contrição | Decisão de 05/11/2026 |

## 13. Kits dos santos (proposta de 03/11/2026, números a calibrar)

Cada santo tem 4 básicas, 2 de Fervor e um milagre de custo 3; os números ficam nas tabelas de balanceamento do repositório e no documento de kits.

- **Milagres:** custo mínimo 3.
- **Noite Escura:** só habilidades de custo 0; todo conjunto equipado precisa ter ao menos uma de custo 0.
- **Amparo** é o novo nome da condição que corta à metade o próximo golpe; **Proteção** fica só como atributo de armadura.
- **Pais do Monaquismo:** Gertrudes incluída (Helfta seguia a Regra de São Bento).
- **Melhoria (+):** o efeito principal cresce 30% (mínimo +1); sem número, +1 pilha.

| Santo | Básicas (custo) | Fervor (custo 2) | Milagre (custo 3) |
| --- | --- | --- | --- |
| São Jorge | Estocada (0), Golpe de Escudo (1), Escudo Erguido (0), Arremesso (0) | Desafio Formal, Investida do Cavaleiro | Lança do Dragão: dano dobrado contra elites e chefes |
| São Bento | Cruz de São Bento (0), Ora et Labora (0), A Regra (1), Báculo (0) | Crux Sacra, O Cálice Partido | Vade Retro: empurra 2 posições e atordoa |
| Santa Teresinha | Oração Ardente (0), Pétala de Rosa (0), Confiança (0), Oferecimento (1) | Abandono, Pequena Flor | Chuva de Rosas: cura todos e alivia a desolação |
| São Nicolau de Mira | Báculo de Mira (0), Trigo dos Navios (0), Repreensão de Niceia (1), Acalmar a Tempestade (1) | Dote Secreto, Os Três Inocentes | As Três Bolsas: 1 Força e 1 Amparo para todos os aliados |
| Santo Antão | Sinal da Cruz (0), Cajado em Tau (0), Vigília no Deserto (0), Desprezo do Inimigo (1) | As Feras do Sepulcro, Perseverança | Combate no Sepulcro: exorcismo em todos os inimigos; Antão recupera vida |
| Santa Joana d'Arc | Espada de Fierbois (0), Haste do Estandarte (0), Avançar (1), A Flecha de Les Tourelles (1) | Ordem de Batalha, Rumo a Reims | Libertação de Orléans: golpe em todos os inimigos |
| São João da Cruz | Palavra Ardente (0), Nada, nada, nada (0), Fuga de Toledo (1), Cântico Espiritual (1) | Na Noite Escura, Subida do Monte Carmelo | Chama Viva de Amor: −20 de desolação em todos e exorcismo em todos os inimigos |
| São Padre Pio | O Terço (0), Bênção do Frade (0), Confessionário (1), Leitura das Almas (1) | Casa Alívio do Sofrimento, Combate Espiritual | Estigmas: custa 15% da vida; exorcismo em todos os inimigos e cura todos os aliados |
| Santa Rita de Cássia | Espinho (0), Bálsamo (0), Paciência (0), Pacificadora (1) | Última Esperança, As Abelhas de Cássia | Rosa no Inverno: levanta um Caído com 40% da vida (ou cura 40% em quem está de pé) |
| Santo Antônio de Pádua | Pregação (0), Pão dos Pobres (0), Martelo dos Hereges (1), Achar o Perdido (0) | Conversão, O Saltério Roubado | Sermão aos Peixes: atordoa e fere os inimigos de duas posições escolhidas |
| São Sebastião | Gládio (0), Escudo da Guarda (0), Tribuno da Guarda (1), Encorajar os Presos (0) | Os Cuidados de Irene, Diante do Imperador | Muralha de Flechas: Provocação e 3 Amparo em si; 1 Amparo nos aliados |
| Santa Gertrudes | Salmodia (0), Purificar (0), O Arauto (1), Lembrança dos Defuntos (0) | Coro de Helfta, Oração pelas Almas | Sufrágio: cura (cresce com os marcos do Purgatório) e remove todas as condições negativas |

Pendente: as variantes dos Carismas (2 por santo), antes do M3.
