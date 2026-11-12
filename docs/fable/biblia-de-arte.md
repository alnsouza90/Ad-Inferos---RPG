# Bíblia de Arte · Ad Inferos

Versão 0.3 · 12/11/2026 · consultor convidado · **proposta de guia**

**O que é:** um só lugar com as regras visuais do jogo, da tela de entrada ao final. Junta o que Alan aprovou nas Etapas 3 e 3b (`02-arte.md`, `03-interface-e-efeitos.md`, página de modelos) e estende para inimigos, ícones, inventário, vila, mapa e narrativa.

**O que não é:** não substitui `docs/art/art-direction.md` enquanto Alan não mandar. Onde este guia muda algo de lá, está dito. Cores em código (hex) e tamanhos são **pontos de partida** para testar no aparelho.

**Versão para ver:** a página "Bíblia de Arte" (link no resumo do chat; fonte em `modelos/biblia-de-arte.html`) mostra a paleta, as formas, os ícones e os efeitos dos inimigos.

---

## 1. A ideia

> **Uma capela às escuras, no fundo do abismo, e uma luz que desce.**

Tudo o que o jogador vê é feito de **quatro matérias**. Cada uma tem dono, e nenhuma invade a outra.

| Matéria | De quem é | Como se reconhece |
| --- | --- | --- |
| **Tinta** | O mundo e o abismo: personagens, cenários, inimigos, golpes | Contorno preto grosso e irregular, sombra que engole metade da figura, respingo, textura de impressão gasta |
| **Ferro e vidro escuro** | A interface | Ferro forjado com rebites, linhas de chumbo, vidro fosco. Preto e cinza |
| **Âmbar** | O fogo humano: lanterna, Lume, velas, Pouso, o leito | Treme, tem fumaça, **se gasta** |
| **Ouro e branco** | A graça: auréola, milagre, Consolação, intercessão, anjos | **Chapado, sem contorno, sem sombra, sem degradê.** Nunca se gasta; só se esconde |

**Os cinco mandamentos visuais**

1. **Ouro é só da graça.** Nem seleção, nem moeda, nem inimigo, nem enfeite.
2. **O sagrado não tem contorno de tinta.** O que vem do Céu é forma de luz.
3. **Há sempre duas luzes:** o âmbar do lado dos santos, a cor do círculo do lado do abismo.
4. **Três formas:** arco é santo, círculo é graça, quebrado é inimigo.
5. **As coisas acendem e apagam.** Nada desliza, nada pisca, nada gira à toa.

---

## 2. Cor

### 2.1 A base (interface e mundo)

| Nome | Hex | Uso |
| --- | --- | --- |
| Breu | `#0D0C10` | Fundo de tela, sombra |
| Ferro | `#1B1A20` | Painéis, molduras |
| Chumbo | `#33313A` | Linhas, bordas, vidro apagado |
| Cinza | `#8A8791` | Texto secundário, vidro disponível |
| Osso | `#E4DDCF` | Texto, seleção, luz neutra, carne dos inimigos |
| Sangue | `#9B1C1C` | **Só perigo:** dano, ataque inimigo, vida |

### 2.2 As cores com dono

| Nome | Hex | Dono | Proibido em |
| --- | --- | --- | --- |
| Ouro | `#D9A520` | Graça | Inimigos, moeda, seleção, cenário |
| Branco angélico | `#F1ECE0` | Anjos, o instante do golpe sagrado | Interface comum |
| Âmbar | `#E07B1F` | Fogo humano | Efeitos de santo (aí é ouro) |
| Ultramar | `#1F3A8A` | Nossa Senhora | Todo o resto |
| Cinábrio | `#B5362A` | Esmolas, rubricas de texto | Efeitos |

**Ouro × âmbar no dia a dia:** se a coisa **acaba** (Lume, vela, Fervor comum), é âmbar. Se **não acaba** (auréola, milagre, Consolação, Interceder, Súplica), é ouro.

### 2.3 A cor de cada círculo

A cor do círculo é **luz** (névoa, brilho, contorno), nunca tinta das pedras. Quando toca um santo, é **assédio**.

| Círculo | Cor | Hex | Atenção |
| --- | --- | --- | --- |
| Antinferno e Limbo | Cinza perolado | `#B9B7C2` | — |
| 2 Luxúria | Violeta de tempestade | `#5B3F7A` | — |
| 3 Gula | Verde-oliva doentio | `#6F7A3A` | — |
| 4 Avareza | Latão oxidado | `#7F7A45` | Puxado para o **verde**, para nunca parecer ouro |
| 5 Ira e Acídia | Vermelho-lodo | `#6E2A25` | Mais marrom que o Sangue da interface |
| 6 Heresia | Laranja-brasa | `#B8401A` | Puxado para o **vermelho**, para não se confundir com o âmbar da lanterna |
| 7 Violência | Carmesim | `#8C1220` | Aqui o vermelho da interface perde força: reforçar o perigo com **forma** (o óculo quebrado), não só com cor |
| 8 Fraude | Verde-veneno | `#4F9A4A` | — |
| 9 Traição | Azul-gelo | `#9FC3D6` | Círculo quase sem cor: preto, branco e o azul só nas bordas |

**A descida em temperatura:** 2 a 5 úmidos e turvos · 6 e 7 queimam · 8 e 9 esfriam até quase o preto e branco · ao rever as estrelas, a cor volta de uma vez.

### 2.4 A leitura de um santo em três cores

| Vejo no santo | Significa |
| --- | --- |
| Ouro | Graça |
| Sem cor (cinza) | Provação: desolação, Noite Escura |
| A cor do círculo | Assédio: a Provação do Círculo |

### 2.5 O tempo litúrgico na vila

A cor do tempo aparece num **pano** pendurado no ferro da interface da vila (como o paramento do altar), e em mais nada.

| Tempo | Cor do pano |
| --- | --- |
| Advento e Quaresma | Roxo |
| Natal e Páscoa | Branco (osso) |
| Tempo Comum | Verde escuro |

(As cores são as da liturgia; você confere.)

---

## 3. Forma

| Forma | Sentido | Onde |
| --- | --- | --- |
| **Arco ogival** | Santo, refúgio | Retrato do santo, botões de habilidade (lancetas), portas da vila, os trípticos |
| **Círculo** | Graça | Auréola, rosácea do milagre, a clareira, o anel |
| **Quebrado e torto** | Inimigo, abismo | Ficha do inimigo, o óculo de intenção rachado, as garras do Domínio |
| **Retângulo liso** | Coisa neutra | Botões comuns (Trocar, Passar, Encerrar turno), texto |

- **Linhas dos santos:** verticais, firmes. **Linhas dos inimigos:** curvas, caídas, tortas.
- **Simetria é do sagrado.** A interface dos santos é simétrica; a do inimigo, não.

---

## 4. Luz

1. **As duas luzes.** Âmbar vindo da esquerda (a lanterna), cor do círculo vindo da direita e de baixo. Cada santo com um fio âmbar nas costas; cada inimigo com um fio da cor do círculo.
2. **O Lume move a fronteira.** Lanterna cheia: o âmbar chega aos primeiros inimigos. Lanterna baixa: a cor do círculo avança sobre os santos.
3. **A auréola:**

| Estado | Auréola | Corpo | Chão |
| --- | --- | --- | --- |
| Normal | Disco de ouro | Cores normais | Sombra curta |
| Desolação 75+ | Coberta de lado | Perde cor | Sombra cresce |
| Noite Escura | Disco preto, anel fino de ouro | Quase silhueta, só o fio âmbar | Sombra longa |
| Consolação | Disco e raios | Cores vivas | Clareira de ouro, sem sombra |
| Purificação | O anel se abre em disco | A cor volta | — |

4. **O instante de ícone.** No milagre e na Consolação, por um momento o fundo vira ouro liso e o santo fica em tinta preta. Na Noite Escura, fundo preto e contorno claro.
5. **Nada de luz dinâmica.** Tudo isso é faixa de cor, contorno e troca de imagem. O celular agradece.

---

## 5. Personagens

### 5.1 Santos

- Olham para a direita. Traço pesado, sombra na frente, fio âmbar nas costas.
- **Sem vermelho de sangue na roupa.** Vermelho só no que é do santo (a capa de Jorge, as rosas).
- **Nenhum ouro na figura** (nem mitra, nem báculo, nem bordado). O ouro é a auréola, e ela é do motor.
- **Teste da silhueta:** todo santo, pintado de preto, tem de ser reconhecido entre os outros 11.
- Âncora de estilo: **Santa Teresinha**.

### 5.2 Inimigos comuns

- Olham para a esquerda. Gerados em **tom neutro** (osso, cinza, preto, vermelho escuro); a cor do círculo vem do motor, como luz.
- **Corpóreo:** carne sólida, sombra pesada, contorno preto. Fraco a Golpe.
- **Espiritual:** corpo de fumaça e tinta, **contorno claro**. Fraco a Exorcismo.
- Âncoras de estilo: **Cornífero de Ferro** (corpóreo) e **Sentinela de Dite** (espiritual).
- Para os próximos: variar a **postura** (agachado, voando, de costas), não só o desenho.

### 5.3 Elites e chefes

- Já nascem com a luz do círculo.
- **Contorno colorido só em Espirituais**, sempre na cor do círculo e sempre na mesma força.
- Chefes: silhueta que diz "não saio daqui" (sentado, plantado, preso). Âncora: **Moloque**.
- Uma tabela de altura por chefe em `bosses.md` (hoje cada um ocupa um tanto diferente).
- **Lúcifer é cenário**, visto de frente, quase sem cor.

### 5.4 O sagrado

- Anjos: **forma branca, sem contorno**, com o disco de ouro. Nunca unidade, nunca barra de vida.
- A Súplica (o santo que reza de longe): **recorte de ouro**, sem contorno.
- Nossa Senhora, Cristo, São José: só em prancha narrativa, como já decidido.
- Uma imagem para intervenções: a luz de uma **rosácea** projetada no chão do Inferno, sem janela nenhuma acima.

---

## 6. Efeitos

**Regra geral:** efeito é **desenho**, de 4 a 6 quadros, tocado devagar (por volta de 8 por segundo). Nada de brilho borrado calculado pelo motor. O motor só posiciona, escala, treme a câmera e faz sumir.

### 6.1 Santos: a estampa

- Matéria: **ouro ou branco, chapado, borda dura, sem contorno**, com falhas de impressão. A referência é a xilogravura de santinho.
- Sequência: **gesto → sinal (a estampa) → instante de silhueta no alvo → marca que fica**.
- Uma forma por santo (as três primeiras aprovadas; as outras são proposta):

| Santo | Forma | Santo | Forma |
| --- | --- | --- | --- |
| Jorge | Escudo com cruz | Padre Pio | Contas de terço em fila |
| Bento | Anel; cruz | Rita | Rosa e espinho |
| Teresinha | Pétalas | Antônio | Peixes ou pão |
| Nicolau | Três bolsas | Sebastião | Muralha de flechas |
| Antão | Cruz em tau | Gertrudes | Livro aberto |
| Joana | Estandarte | João da Cruz | Uma chama |

### 6.2 Inimigos: a tinta

O contrário da estampa em tudo.

| | Santos | Inimigos |
| --- | --- | --- |
| Matéria | Folha de ouro | **Tinta preta** |
| Borda | Dura, limpa | **Escorrida, rasgada, respingada** |
| Movimento | Aparece de uma vez e some como tinta secando | **Escorre, sobe, se espalha, gruda** |
| Cor | Ouro, branco | Preto, vermelho escuro e a cor do círculo |
| Direção | De cima para baixo | **De baixo para cima** |

**Por tipo de ação inimiga:**

| Ação | Como se vê |
| --- | --- |
| **Golpe de Corpóreo** | O inimigo desliza até o alvo (já é assim); no impacto, um **corte de tinta** preto e vermelho atravessa o santo, com respingo |
| **Ação de Espiritual** | O inimigo não se move. Uma **mancha de tinta** nasce aos pés do santo e **sobe** pela figura; o contorno do santo fica na cor do círculo por um instante |
| **Desolação em área** (Lamento) | A tinta sobe do chão sob os três santos ao mesmo tempo; as auréolas escurecem de lado |
| **Deslocar** (Vendaval, empurrão) | **Linhas de vento desenhadas**, em poucos quadros, na cor do círculo; os santos trocam de lugar deslizando |
| **Invocar** | Uma **poça de tinta** se abre no chão vazio e a criatura sai dela |
| **Defender** | Uma casca de tinta endurece em volta do inimigo, com rachaduras |
| **Assédio do Pecado Encarnado** | O contorno na cor do círculo **fica** no santo enquanto durar. Ao resistir, o contorno **estilhaça** para fora |

**Condições nos santos (a marca que fica):**

| Condição | Marca |
| --- | --- |
| Sangramento | Gotas de tinta vermelha escorrendo da figura |
| Corrupção | **Veias de tinta preta** subindo pela roupa, mais altas a cada pilha |
| Atordoamento | Um **borrão** de tinta sobre os olhos |
| Torpor | A figura afunda um pouco; tinta escorre dos ombros |
| Congelamento | Lascas claras subindo dos pés |
| Amparo | Um escudinho de ouro ao lado (é graça: estampa) |
| Força | Uma chama pequena de ouro ao lado |

**Morte do inimigo:** o Corpóreo desaba e **deixa os restos** (já decidido); o Espiritual **se desfaz em tinta que evapora** para cima.

### 6.3 O que é do corpo

- Golpe físico de santo: a câmera de impacto já aprovada (aproximar, tremer, um corte de tinta).
- No máximo **um** efeito de tela cheia por ação.

---

## 7. Interface

### 7.1 As peças

| Peça | Forma | Estados |
| --- | --- | --- |
| **Lanceta** (habilidade) | Janela de arco estreita, ferro e chumbo | Fosca (bloqueada) · Apagada com luz fraca (disponível) · Acesa em âmbar (escolhida) · Vazia (sem habilidade) |
| **Rosácea** (milagre) | Redonda | Apagada · Acesa em **ouro** (Fervor suficiente) |
| **Porta-velas** (Fervor) | Fileira de 6 velas em ferro | Vela acesa (âmbar) · apagada com fumaça · acesa em ouro (a que paga o milagre) |
| **Arco do retrato** | Ogival | Normal · contorno de osso (agindo) · tingido pela desolação (já existe) |
| **Moldura quebrada** (inimigo) | Torta, sem arco | Normal · rachada a cada fase de chefe |
| **Óculo** (intenção) | Redondo pequeno, de ferro | **Vermelho** (ataque) · ferro com desenho em osso (o resto) · "?" (velada) · com mini-auréola em eclipse (vai causar teste de Fé) |
| **Garra** (Domínio do chefe) | Quebrada, na cor do círculo | Presa · cedida (cinza) |
| **Alforje** (provisões) | Fileira de ganchos de ferro com saquinhos | Com item e quantidade · vazio · apagado (já usou uma neste turno) |
| **Botão comum** | Retângulo de ferro | Normal · apertado · indisponível |
| **Lanterna** (Lume) | A lamparina na haste | Chama em 3 tamanhos, um por faixa; na mão do portador, quando houver |

### 7.2 Regras de cor da interface

- **Selecionado = osso.** Nunca ouro.
- **Vermelho = dano.** Só o ataque inimigo, a barra de vida e os números de dano.
- **Ouro = graça.** Rosácea, auréola, Interceder, Súplica.
- **Âmbar = o que se gasta.** Lume, velas do Fervor, a janela escolhida.

### 7.3 Texto e toque (base 1920 × 1080; confirmar no Redmi)

| Item | Mínimo proposto |
| --- | --- |
| Título (Pirata One) | 44 px |
| Nome de habilidade, botão | 30 px |
| Texto corrido, descrição | 30 px, no máximo 3 linhas |
| Número pequeno (vida, custo) | 28 px |
| Área de toque | 96 × 96 px |

- Pirata One fica (D-258). Em texto longo, **cortar texto** antes de diminuir a letra.
- **Ícone primeiro, palavra depois.** O nome da habilidade aparece embaixo da lanceta e no detalhe, não espremido dentro dela.

### 7.4 Três camadas

| Camada | O que fica |
| --- | --- |
| Sempre na tela | Vida, desolação, auréola, intenção e alvo, Fervor, Lume, rodada, alforje |
| Ao tocar | Detalhe da habilidade, do item, do inimigo, da condição |
| Só na vila e no Pouso | Atributos, equipamento, relíquias, Laços |

---

## 8. Ícones

### 8.1 Três famílias, três molduras

| Família | Moldura | Traço |
| --- | --- | --- |
| **Ação de santo** | Dentro da lanceta | **Gravura clara no vidro escuro**: linha de osso, grossa, como chumbo de vitral |
| **Intenção e ação inimiga** | Dentro do óculo | Tinta preta e vermelha, torta |
| **Item** (provisão, relíquia, equipamento) | Etiqueta ou saquinho no gancho | Objeto desenhado em tinta, com uma cor de acento |

Os ícones de recursos, intenções, estados e nós **já existem** (30 no Drive). O que falta é a família das **ações dos santos**.

### 8.2 Os ícones genéricos de ação (novos)

Um por **tipo** de habilidade. Servem a todos os 12 santos; o que distingue um santo do outro é o **milagre** (a forma dele, na rosácea).

| Ícone | Para que tipo de habilidade | Desenho |
| --- | --- | --- |
| **Golpe** | Dano físico | Uma lança ou lâmina em diagonal |
| **Exorcismo** | Dano espiritual | Uma cruz com raios curtos |
| **Cura** | Devolve vida | Uma gota dentro de uma mão aberta |
| **Alívio** | Tira desolação | Uma auréola que se descobre (o eclipse saindo) |
| **Amparo** | Protege (ficha de Amparo) | Um escudo |
| **Força** | Fortalece (ficha de Força) | Uma chama de pé |
| **Limpeza** | Tira condições | Uma gota caindo sobre uma mancha |
| **Levantar** | Ergue um Caído | Uma mão puxando outra |
| **Deslocar** | Empurra, puxa, troca | Duas setas tortas |
| **Retirar** | Tira fichas positivas do inimigo | Um escudo rachado |

Ações comuns (botões de ferro, não lancetas): **Interceder** (um fio entre dois círculos, em ouro), **Trocar**, **Passar**.

Habilidade com dois efeitos usa o ícone do **efeito principal**; o detalhe mostra os dois.

### 8.3 O que aparece em volta do ícone

- **Custo:** velinhas embaixo da lanceta (0, 1 ou 2), no mesmo desenho do porta-velas.
- **Alcance:** não cabe no ícone. Aparece no detalhe e na marcação dos alvos.
- **Uma vez por combate:** um ponto de chumbo no canto; some quando usada.

### 8.4 Tocar no ícone

| Toque | O que acontece |
| --- | --- |
| **Primeiro** | A janela acende. O painel mostra o **detalhe**: nome, tipo, custo, de onde se usa, quem atinge, números, efeitos. Os alvos possíveis ficam marcados no campo |
| **Toque no alvo** | Mostra a **prévia exata** (como hoje) |
| **Segundo toque no alvo** | Confirma |
| **Segurar o ícone** | Abre o detalhe sem escolher (para só ler) |

Vale igual para habilidade, milagre, item do alforje, condição e intenção inimiga. **Tudo que tem ícone abre detalhe ao toque.**

---

## 9. O inventário na luta: o alforje

**Hoje:** um botão "Provisões" que abre uma lista.

**Proposta:** o alforje fica **sempre à vista** no painel, entre o porta-velas e a ficha do inimigo.

- Uma fileira de **ganchos de ferro**, um por **tipo** de provisão que a companhia leva (no máximo 5: Pão, Vela, Água Benta, Ataduras, Incenso), com a **quantidade** em número.
- O que não serve em combate (Vela, Incenso) aparece **apagado**, para o jogador saber que tem, sem poder usar.
- **Tocar** num item: abre o detalhe (o que faz, quanto resta) e marca quem pode receber.
- **Tocar no santo:** prévia; segundo toque confirma.
- Usada uma provisão no turno, os outros ganchos **apagam** até o próximo turno (a regra de uma por turno fica visível).
- **Relíquias e equipamento** não ficam no alforje: aparecem ao **tocar no retrato** do santo, na ficha dele.
- **Súplicas** (os santos na Capela) ficam ao lado do alforje, como retratos pequenos em recorte de ouro.

Na caminhada e no Pouso, o mesmo alforje, no mesmo lugar.

---

## 10. Do começo ao fim: cada tela

A ideia que amarra tudo: **a interface também faz a viagem.** Ela começa como uma capela apagada, vai acendendo com o que a companhia faz e, no final, o ferro some.

| # | Tela | Matéria que manda | A imagem |
| --- | --- | --- | --- |
| 1 | **Entrada (título)** | Breu e âmbar | Tela preta. No centro, **uma lanterna apagada**. O botão de começar é **acender a lanterna**: a luz revela o título e, atrás, a Porta |
| 2 | **Prólogo** | Tinta | Pranchas, como no roteiro. Texto numa faixa de ferro fina. Os cortes do leito, só em âmbar |
| 3 | **Vila (Átrio)** | Tinta e âmbar | **Montada como em Darkest Dungeon** (decisão de Alan): céu e fundo em camadas, e os **edifícios soltos** por cima, cada um tocável e mudando com o nível. O panorama pintado é só referência. A interface é uma faixa de ferro à luz de vela, com o pano do tempo litúrgico. Tocar num edifício abre o interior dele, com os painéis em arco por cima. Regras de montagem no §10A |
| 4 | **Planejar a semana** | Ferro e arcos | Um **tríptico**: quem desce (centro), quem reza (esquerda), quem descansa (direita) |
| 5 | **Mapa do Inferno** | Vidro apagado | **Nove janelas** em fila que desce. As vencidas, acesas; a atual, com a lanterna; a **luz pálida** um círculo à frente |
| 6 | **Caminhada** | Tinta e as duas luzes | Quase sem interface: a lanterna, o alforje e uma faixa fina. É hora de olhar o cenário |
| 7 | **Combate** | Tudo | A capela às escuras inteira |
| 8 | **Pouso e Vigília** | Âmbar | Os três santos em **três arcos**, como retábulo. As atividades são velas acesas diante de cada um |
| 9 | **Tentação** | Tinta, cor do círculo | A tenda. As opções em lancetas; a opção segura sempre a primeira. A voz do tentador **sem retrato**, só o contorno na cor do círculo |
| 10 | **Encontro com a alma** | Cinza perolado | Sem ferro. Só a alma, a companhia e o texto. É a tela mais silenciosa do jogo |
| 11 | **Chefe** | Tinta, garras | A moldura quebrada cresce; as garras do Domínio junto da vida |
| 12 | **Milagre, Consolação, Noite Escura** | Ouro, ou preto | O instante de ícone |
| 13 | **Novo santo** | Ouro | O santo chega num instante de ícone; depois a ficha dele, num arco |
| 14 | **Flashback** | Tinta desbotada | A vida do Peregrino em **sépia e osso, sem preto puro**: é memória, não é abismo. As três pessoas da selva sem os mantos de fera |
| 15 | **Vinheta do leito** | Âmbar | **Nenhuma interface.** Só o quarto e a vela, cada vez mais baixa |
| 16 | **Retirada e derrota** | Breu | A lanterna baixa, não apaga. Sem "fim de jogo": a companhia volta ao Átrio |
| 17 | **Rever as estrelas** | A cor volta | Depois de Lúcifer (quase preto e branco), o céu abre. Primeira tela com azul que não é gelo |
| 18 | **Ato de contrição** | Âmbar, depois ouro | O leito. A interface some: um botão só, em osso. As lembranças recolhidas aparecem uma a uma |
| 19 | **Purgatório** | Amanhecer | A montanha, com luz que sobe. **O ferro não aparece mais** |
| 20 | **Paraíso** | Ouro e branco | A única tela do jogo **inteira em ouro e sem contorno de tinta**. Tudo o que o jogador viu de ouro até aqui eram pedaços disto |

**O arco de luz da campanha:** entrada no breu → âmbar pequeno → nove círculos esfriando até o gelo → estrelas → amanhecer → ouro. Se o jogador puser as telas em fila, vê a história só pelas cores.

---

## 10A. A vila que já existe (amostra do Drive, 12/11/2026)

Vi 14 das cerca de 71 imagens da pasta `environments/village` do Drive (folha em `previas/vila_amostra_drive.jpg`): o panorama, o céu, 5 edifícios de nível 1 de dia, 2 de noite, 2 de nível 3 e 3 interiores. **Não vi as outras**; o que segue vale para a amostra.

**O que está muito bom e vira regra**

- Os **interiores** (despensa, claustro com o poço, a cela com o livro e a vela) são a melhor arte de ambiente do projeto. Luz âmbar, tinta pesada, nada de ouro. São exatamente "o refúgio é quente".
- As **janelas em âmbar** em todo edifício. É a mesma luz da lanterna e do Pouso.
- O **panorama** do mosteiro na beira do abismo, com o escuro embaixo e a aurora em cima, resume o jogo numa imagem.

**Três ajustes neste guia por causa da vila**

1. **A aurora do Átrio é uma exceção permitida.** O §14 diz "nenhum ouro em cenário". O céu do Átrio tem uma aurora pálida, entre o âmbar e o ouro. Fica: o Prólogo chama o Átrio de lugar "que a graça deixou de pé". É o único cenário com essa luz antes do Purgatório, e a anuncia. Regra: aurora **pálida e pintada**, nunca ouro chapado.
2. **A noite azul.** As versões de noite têm fundo azul-marinho. Este guia reserva o azul (o ultramar é de Nossa Senhora; o primeiro céu azul do jogo é o das estrelas, no fim). Sugestão: no motor, puxar a noite da vila para **cinza-violeta escuro**, sem azul vivo.
3. **Dia e noite precisam de um sentido.** O Átrio está fora do tempo. Em vez de relógio, proposta: **noite** no Advento e na Quaresma, **dia** no Natal, na Páscoa e no Tempo Comum. Assim o tempo litúrgico se vê na vila inteira, não só no pano.

**Decisões de Alan (12/11/2026)**

- A vila usa os **edifícios soltos, montados pelo motor, como em Darkest Dungeon**. O panorama é só orientativo.
- A **noite** vai para **cinza-violeta escuro**, sem azul vivo.
- **Dia e noite seguem o tempo litúrgico:** noite no Advento e na Quaresma; dia no Natal, na Páscoa e no Tempo Comum.
- Alan dispensou a revisão das outras 57 imagens.

**Como montar (para a vila parecer um lugar, e não uma colagem)**

| Regra | Por quê |
| --- | --- |
| **Lugares fixos.** Cada instalação tem um ponto de apoio marcado no chão da vila; o edifício de nível 1, 2 ou 3 troca **no mesmo ponto** | O jogador aprende onde fica cada coisa, e vê a vila crescer sem nada mudar de lugar |
| **Três fileiras de profundidade.** Fundo (menor e mais escuro), meio, frente (maior). O panorama serve para decidir quem fica em qual fileira | Dá profundidade com peças vistas todas do mesmo ângulo |
| **Todos assentados no mesmo chão.** Cortar o pedaço de chão de cada edifício e pintar um chão único por baixo; uma sombra igual para todos, feita pelo motor | É o chão diferente em cada peça que denuncia a colagem. Resolve também a sombra clara do edifício de nível 3 |
| **Uma luz só.** Janelas em âmbar; a luz geral vem da esquerda (já é a regra da Direção de Arte). De noite, o motor escurece tudo para cinza-violeta e deixa as janelas | Dia e noite com a mesma arte de dia: as versões de noite em azul podem nem ser necessárias |
| **O céu em camada própria**, andando devagar | A imagem do céu já existe |
| **O abismo sempre visível** numa borda da tela, escuro | Lembra onde a vila está |
| **Edifício fechado = ruína ou silhueta escura** no lugar dele (o Carmelo já é assim) | O jogador vê o que ainda vai chegar |
| **Aviso de novidade em osso**, um pequeno sino ou vela acesa sobre o edifício; some ao abrir | Sem ouro e sem ponto de exclamação colorido |
| **A praça com a estátua no centro**, sem toque e sem efeito | Cena, como decidido em D-262 |
| **Os santos que ficaram** aparecem como retratos em arco na faixa de ferro, não andando pela vila | Menos arte, e liga com "Planejar a semana" |

**Cuidados com os arquivos**

| Ponto | O que vi | Sugestão |
| --- | --- | --- |
| Sombras | Um edifício de nível 3 tem sombra projetada clara no fundo | Tirar no recorte |
| Noites | Fundo azul-marinho com textura | Preferir a arte de dia escurecida pelo motor; usar a de noite só se o recorte ficar limpo |
| Nomes | Todos numéricos (Meta AI) | Identificar e renomear antes da T49 |
| Jardim | Existe arte de um claustro com jardim | Pode servir à Capela nível 3 ou ao Carmelo |

## 11. Movimento e som (em uma página)

| Coisa | Movimento |
| --- | --- |
| Interface | Acende com um tremor curto e firma; apaga com um fio de fumaça |
| Personagens | Quadros desenhados; o motor liga as poses (como hoje) |
| Efeitos de santo | Carimbam: aparecem de uma vez, falham e secam |
| Efeitos de inimigo | Escorrem: nascem embaixo e sobem |
| Câmera | Só no golpe físico e no milagre |
| Velocidade | Todo efeito abaixo de 1 segundo; pulável no modo rápido |

**Som (para a tarefa de áudio):** fósforo e pavio para a interface; sino pequeno para a graça; madeira e ferro para golpes; algo molhado e baixo para a tinta. Silêncio no leito.

---

## 12. Blocos de prompt

Trechos para colar. O que muda de um prompt para outro vai no lugar de `<...>`.

**Base de todo personagem (tinta):**

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, distressed print texture, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text
```

**Acréscimo para santo:**

```text
bone and ash grey, dark red only on the saint's own garments and attributes, sparse black ink splatter on the figure only, no red splatter, no blood stains, a thin warm amber rim light along the whole back edge of the figure, the front in deep shadow, facing right --no halo, gold, blood on clothes, glowing eyes
```

**Acréscimo para inimigo comum (tom neutro):**

```text
palette of black, bone, ash grey and dark blood red only, no other colors, facing left --no gold, halo, bright colors, glowing outline
```

**Acréscimo para Espiritual:**

```text
body made of smoke and flowing ink, pale inverted outline instead of black, faint and translucent at the edges
```

**Cenário (cor na luz):**

```text
Darkest Dungeon style 2D side-view dungeon background, hand-painted gothic horror, hand-inked comic art, <lugar>, all stone and ground painted only in black, bone and ash grey, lit by a dim <cor do círculo> glow from below and from the far distance, a smooth dark band across the middle behind where characters will stand, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, distressed print texture, dark vignette --no characters, people, creatures, saturated colors, warm light, text, UI
```

**Efeito de santo (estampa), folha de 6 quadros:**

```text
2D game VFX sprite sheet, six frames in a single horizontal row, medieval woodcut print style, <forma> printed in completely flat <gold | white> ink with rough hand-carved edges and small gaps like a worn woodblock stamp, <o que muda em cada quadro>, no outline, no gradient, no glow, hard cut edges, each frame centered in its cell, isolated on a plain flat solid dark grey background --no black outline, soft glow, blur, particles, 3D, text
```

**Efeito de inimigo (tinta), folha de 6 quadros:**

```text
2D game VFX sprite sheet, six frames in a single horizontal row, hand-inked comic art in the style of Darkest Dungeon, <forma: a slash | a rising stain | a pool> of thick black ink with dripping ragged edges and heavy splatter, a few accents of <dark blood red | cor do círculo>, frame 1 to 6 <como cresce e escorre>, wet and irregular, no clean edges, each frame centered in its cell, isolated on a plain flat solid light grey background --no gold, glow, light rays, clean geometric shapes, 3D, text
```

**Ícone de ação de santo (gravura no vidro):**

```text
2D game UI icon, <objeto>, drawn only in thick bone-white lines like the lead lines of a stained glass window, simple bold readable silhouette, no fill, no shading, centered, on a plain flat solid very dark grey background --ar 1:1 --no color, gold, text, letters, gradient, 3D, glossy
```

**Peça de interface (ferro e vidro):**

```text
2D game UI asset in the style of Darkest Dungeon, hand-inked comic art, <peça>, rough black forged iron with rivets, dark smoked glass divided by thick lead lines, no figures and no symbols in the glass, thick irregular black ink outlines, palette of black and ash grey, front view, isolated on a plain flat solid light grey background --no people, faces, text, gold, bright colors, glossy, 3D
```

---

## 13. O que produzir, em ordem

| Ordem | Lote | Peças | Quem |
| --- | --- | --- | --- |
| 1 | **Interface nova do combate** | Lanceta (3 estados), rosácea (2), porta-velas, vela, arco do retrato, moldura quebrada, óculo, gancho do alforje | Você gera; o motor troca as molduras |
| 2 | **Ícones de ação** | Os 10 genéricos e os 3 comuns | Você gera, ou o motor desenha em linha |
| 3 | **Auréola** | Eclipse, coberta, clareira | Você gera 3 peças |
| 4 | **Estampas dos 3 santos** | 5 ou 6 folhas de 6 quadros | Você gera |
| 5 | **Tinta dos inimigos** | 4 folhas: corte, mancha que sobe, poça de invocação, vento | Você gera |
| 6 | **As duas luzes** | Nenhuma arte: é do motor | Motor |
| 7 | **Santo de teste em hábito escuro** (Santa Rita) | 1 imagem | Você gera; ver sobre o Círculo 2 |
| 8 | **Regenerar** Fúria, Sentinela Gélida, Belial, retrato de Bento | 4 imagens | Você |
| 9 | **Os 9 santos**, com o bloco novo | 9 conjuntos | Você, depois do teste 7 |
| 10 | **Vila à luz de vela, Mapa do Inferno em janelas, tela de entrada** | Conforme as telas do §10 | M3 |
| 11 | **Lúcifer** e as telas finais | — | M4 |

---

## 14. Nunca

- Ouro em inimigo, em moeda, em seleção ou em cenário (exceção: a aurora pálida do Átrio, §10A).
- Contorno preto em anjo ou em efeito de graça.
- Brilho borrado, partícula de luz, degradê macio em efeito de santo.
- Borda limpa e geométrica em efeito de inimigo.
- Vermelho na interface para algo que não é dano.
- Sangue na roupa de santo.
- Santo ou figura sagrada desenhado **dentro** de botão, vidro ou ícone.
- Cor do círculo pintada na pedra.
- Fundo claro atrás de onde ficam as figuras.
- Painel que desliza, ícone que pisca, número que salta sem motivo.
- Texto pequeno para caber: corta-se o texto.

---

## 15. Em aberto

1. **Latão do Círculo 4 e brasa do Círculo 6:** conferir no aparelho se não se confundem com ouro e âmbar.
2. **Carmesim do Círculo 7:** conferir se o vermelho de perigo da interface ainda se lê.
3. **Flashbacks em sépia:** é sugestão de matéria; o roteiro e as pranchas são seus.
4. ~~Tela de entrada~~ **Decidido por Alan (12/11/2026):** a lanterna **convive** com a abertura pelo Mapa do Inferno.
5. ~~Ícones de ação~~ **Decidido por Alan (12/11/2026):** gerados por IA, como os outros ícones (prompt no §12).
6. **Tamanhos de letra e de toque:** só o Redmi responde.
