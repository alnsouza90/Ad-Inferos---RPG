# Etapa 3 · Arte: coerência, linguagem própria e o que corrigir

Versão 1.0 · 12/11/2026 · consultor convidado · **tudo aqui é proposta**. Nada foi alterado em `docs/art/` nem em `art_source/`.

## 0. Em que esta análise se apoia (e os limites dela)

- **Vi:** as 6 pranchas de `docs/handoff/pranchas/` (3 santos, 20 inimigos comuns, 16 elites, 8 chefes, cenários do Círculo 2 e 4 capturas do jogo).
- **Li:** `art-direction.md` §1 (conceito, paleta, regras), a parte da auréola e a da interface; os prompts de Jorge, Santa Rita, São Sebastião, Caronte, Asmodeu e Lúcifer; o começo de `prompts-saints.md` e de `prompts-splash.md`; as decisões de arte (D-163, D-194, D-233 a D-259, D-333 a D-348).
- **Não vi:** os 62 edifícios da vila, os interiores, as telas de passagem, as animações em movimento e a arte em tamanho cheio. As pranchas são miniaturas: **defeitos de recorte e de traço fino eu não consigo julgar**.
- Por isso, onde digo "destoa", leia "destoa na prancha; confira no arquivo cheio".

---

## 1. O veredito em poucas linhas

1. **Os inimigos são a melhor parte.** As três famílias de comuns parecem do mesmo mundo, e a regra "Espiritual tem traço claro" funciona de longe.
2. **Os santos são a parte mais frágil**, e são eles que o jogador olha o tempo todo. Os três não parecem desenhados pela mesma mão, e os de hábito escuro somem no cenário escuro.
3. **Elites e chefes oscilam.** Há três ou quatro que parecem de outro jogo (Fúria, Sentinela Gélida, Belial, Belzebu) e dois pares que o jogador vai confundir (Medusa e Fúria; Caronte e Flégias).
4. **O cenário do Círculo 2 é sólido**, e o Pouso e a Vigília, com a luz âmbar, são o que o jogo tem de mais bonito. Esse contraste (roxo frio fora, âmbar quente no refúgio) é a semente da linguagem própria.
5. **A interface cumpre D-257/D-258**, mas gasta o ouro em coisas que não são sagradas. É o ponto mais fácil de corrigir.
6. **O que falta para ser "Ad Inferos" e não "Darkest Dungeon"** não é mais arte. São **regras de luz** aplicadas pelo motor, que custam pouco e mudam tudo. É o §4.

---

## 2. O que funciona (e deve virar regra)

| O que | Onde se vê | Por que funciona |
| --- | --- | --- |
| Osso, cinza e preto, com vermelho escuro como único acento | Diabo de Lodo, Escaravelho, Cornífero de Ferro, Malebranche, Minotauro, Moloque | O conjunto fica unido mesmo com formas muito diferentes |
| Contorno claro nos Espirituais | Sombra do Desejo, Sopro Errante, Sentinela de Dite, Caído de Dite | Lê-se "este é de fumaça, use Exorcismo" sem ler texto |
| Um ponto de luz própria no corpo do inimigo | A fornalha do Fornalheiro e de Moloque | O olho vai direto para lá; é a "luz do abismo" (§4.1) |
| Silhuetas de chefe sentadas e pesadas | Mamom no monte de moedas, Belfegor no tronco, Minos no trono | Dizem "eu não saio daqui", que é o que um chefe do Inferno deve dizer |
| O ouro só na auréola | As capturas do combate | No meio do preto e do roxo, as três auréolas são a única coisa quente. É a assinatura do jogo |
| Âmbar no Pouso e na Vigília | Cenários do Círculo 2 | O refúgio é quente; o abismo é frio. O jogador sente alívio antes de ler qualquer coisa |
| Gerar o inimigo comum em tom neutro e colorir no motor | Regra da Direção de Arte §1 | Economiza gerações e garante a cor certa por círculo |

---

## 3. O que destoa, e por quê

Três tipos de problema. Para cada item, a saída mais barata: **M** = resolver no motor · **R** = regenerar · **D** = deixar como está.

### 3.1 Traço diferente do resto

| Quem | O que destoa | Por quê | Saída |
| --- | --- | --- | --- |
| **São Jorge** (corpo) | Mais limpo e mais claro que Bento e Teresinha: pouca sombra preta, quase nenhum respingo, anatomia de quadrinho clássico. O **retrato** dele é mais carregado que o corpo | Os três foram gerados em momentos e ferramentas diferentes | **D + M.** Ele já está animado (D-225); refazer é caro. Um tratamento único de cor no motor para todos os santos (§5.2) aproxima os três |
| **Fúria** (escolta da Medusa) | Traço fino, muito detalhe, sombra suave, verde por cima. Parece ilustração de livro, não tinta de quadrinho | Faltou a referência de estilo na geração | **R** |
| **Sentinela Gélida** | Azul saturado e brilho "de vidro", com reflexos nítidos | Idem; e o azul veio na arte, não no motor | **R**, em tom neutro, com o gelo só nas bordas |
| **Vertigem** | Linha mais fina e elegante, contorno violeta | Aqui o desvio **serve ao personagem** (é a sedução) e ela já está animada | **D** |
| **Belial** | Duas figuras pequenas e delicadas num carro com fogo laranja vivo; não parece ameaça | Composição com muito espaço vazio e fogo saturado | **R** ou **M** (escurecer o fogo para brasa e aumentar a figura) |
| **Belzebu** | A caveira com ossos cruzados nas asas lê como bandeira pirata | Vem da gravura do *Dictionnaire Infernal*, que é a fonte declarada. É fiel, mas no celular vira logotipo | **R leve:** a caveira fundida nas nervuras da asa, sem contorno próprio |
| **Enxame** (o invocado) | Arredondado e claro; fica simpático | Forma de larva sem sombra pesada | **R** ou escurecer no motor |
| **Cérbero** | Verde mais vivo que o resto e olhos vermelhos acesos | Cor do círculo aplicada na arte | **D**, baixando a saturação no motor |

### 3.2 Personagens que o jogador vai confundir

| Par | Problema | Sugestão |
| --- | --- | --- |
| **Medusa × Fúria** | As duas têm cabelo de serpentes e asas de morcego. Na mesma luta, lado a lado | Dante dá serpentes às Fúrias também, então o cabelo fica. Diferenciar pelo resto: **Medusa sem asas**, de pedra cinza, olhos como única luz; **Fúrias com asas**, magras, manchadas de sangue. Você confere as fontes |
| **Caronte × Flégias** | Dois homens fortes num barco com um remo | Dante tem os dois barqueiros. Diferenciar: Caronte **velho, parado, olhos de brasa** (já é assim); Flégias **em movimento, furioso, sem barco na figura** (o barco vira cenário) e na cor de lodo do Círculo 5 |
| **Malebranche × Arpoeiro × Malacoda × Caído das Muralhas** | Quatro demônios alados de pé com arma de haste | Na família C, variar a **postura**: um agachado, um voando, um de costas viradas |
| **Diabo de Lodo × Mãe-Enxame × Voracidade × Rancor × Pluto × Belfegor × Fornalheiro** | Sete "corpulentos pálidos e carecas" | Não é erro em nenhum deles; é repetição no conjunto. Para os próximos, evitar essa silhueta |
| **São Jorge × São Sebastião** (ainda sem arte) | Dois soldados romanos do século III, de capa vermelha, na mesma companhia | O prompt de Sebastião já ajuda (armadura de placas, elmo, escudo retangular com flechas). Reforçar: **elmo sempre na cabeça**, **sem capa vermelha**, mais velho e mais largo que Jorge |

### 3.3 Problemas de valor e de limpeza

| Onde | Problema | Saída |
| --- | --- | --- |
| **Bento no combate** | Hábito preto sobre cenário escuro: some. E vêm aí Antão, Rita, Gertrudes, Pio, Antônio e João da Cruz, todos de hábito escuro | **M:** a regra das duas luzes (§4.1) dá a todo santo um fio de luz âmbar nas costas. É a correção mais importante deste documento |
| **Respingos vermelhos em Bento e Teresinha** | Parecem sangue na roupa dos santos | Vem do próprio prompt ("dark blood red accents, ink splatter"). **Tirar do prompt dos santos** (§5.3). Nos três atuais, **D** |
| **Retrato de Bento com capuz, corpo sem capuz** | O jogador não liga o retrato à figura | **R** do retrato, ou recorte do corpo (a folha de santos já permite) |
| **Retratos com borda branca de adesivo** | Na prancha, os três retratos têm um contorno branco grosso | Se o contorno está no arquivo, tirar. Se é só da prancha, ignore |
| **Trecho 2 · meio** | Franja magenta nas bordas das ruínas | Sobra de recorte. **M:** a ferramenta de tratamento resolve |
| **Trecho 3 · fundo** | Névoa lilás muito clara atrás dos personagens: os Espirituais de traço claro vão sumir | **M:** escurecer a faixa atrás das figuras |
| **Brilhos coloridos de contorno** | Asmodeu e Vertigem em violeta, Azazel, Engano e Malacoda em verde, Perfídia em azul: cada um numa força | Virar regra: **só Espirituais** têm contorno colorido, sempre na cor do círculo, sempre na mesma força (§4.4) |
| **Escala dos chefes** | Caronte e Asmodeu ocupam pouco do quadro; Moloque e Belfegor, muito | O motor já escala (D-332). Fixar uma tabela de altura por chefe em `bosses.md` |
| **Mamom** | Corpo de moedas em tom dourado-castanho | A regra é "nenhum ouro em inimigo". Conferir se está em **latão oxidado** (a cor do Círculo 4), esverdeado, sem brilho |

---

## 4. Uma linguagem visual própria

Darkest Dungeon tem uma ideia visual: **a tocha contra o escuro**. Ad Inferos pode ter uma mais rica, porque aqui há **duas luzes que disputam a tela**, e uma terceira que não é deste mundo.

Seis regras. Quase todas são do **motor**, não de arte nova.

### 4.1 As duas luzes

- **A luz da lanterna** (âmbar, quente) vem do lado da companhia. É a luz acesa por Santa Luzia no Prólogo.
- **A luz do abismo** (a cor do círculo, fria ou doentia) vem do lado dos inimigos e de baixo.
- No combate, a tela tem um **encontro de luzes** no meio do campo. Cada santo recebe um fio âmbar nas costas; cada inimigo, um fio da cor do círculo.
- **O Lume move a fronteira.** Com a lanterna cheia, o âmbar alcança os primeiros inimigos. Com a lanterna baixa, a cor do círculo avança sobre os santos. O jogador *vê* o Lume no campo inteiro, não só na lamparina.
- Isso casa com o que você aprovou: "luz é ver" (o que o âmbar toca, a companhia enxerga) e "quem leva a lanterna" (a luz sai de um santo).

**Como fazer:** duas faixas de cor em degradê por cima do campo (uma âmbar, uma na cor do círculo), com mistura aditiva, mais um contorno fino por personagem com o mesmo material do contorno roxo já aprovado (D-237). Nada de luz dinâmica, que pesa no celular.
**Custo:** baixo a médio. **Testa no M2:** sim.

### 4.2 Ouro é graça; âmbar é fogo

Hoje as duas coisas são "amarelo". Proponho separar para sempre:

| Cor | O que é | Onde aparece | Como se comporta |
| --- | --- | --- | --- |
| **Ouro chapado** | A graça. Não se gasta | Auréola, milagre, Consolação, Interceder, Súplica | **Sem sombra, sem degradê, sem tremer.** Como folha de ouro num ícone |
| **Âmbar** | A luz humana. Gasta-se | Lanterna, Lume, Pouso, velas, a vela do leito | **Treme, tem fumaça, diminui** |

- A frase de Luzia no Prólogo ("ela vai se gastar") vale para o âmbar. O ouro nunca diminui: ele se **esconde** (§4.5).
- Consequência na interface: ver §6.

### 4.3 O sagrado não tem contorno

- **Tudo** no jogo tem contorno grosso de tinta preta. É a marca do traço.
- Proposta: o que vem do Céu aparece **sem contorno nenhum**. Só forma chapada de luz: branco para os anjos (a Direção de Arte já reserva o branco para eles), ouro para a graça, ultramar para Nossa Senhora.
- O efeito é imediato: o olho entende que aquilo **não é feito da mesma matéria** que o resto.
- Vale para São Rafael contra Asmodeu, São Gabriel em Dite, São Miguel contra Lúcifer, e para a Súplica (o santo que reza de longe aparece como um recorte de ouro, não como personagem).
- **Como o sagrado aparece sem virar bônus:** como **luz e forma**, nunca como unidade com barra de vida, ícone de habilidade ou número. Uma ideia de imagem: a luz de uma **rosácea** de catedral projetada no chão do Inferno, sem que exista janela nenhuma acima. O jogador vê o desenho de luz no chão e sabe que alguém interveio.
- **Atenção:** as pranchas narrativas do Prólogo (Nossa Senhora, Luzia) foram escritas **com** contorno de tinta. Esta regra valeria para o que aparece **dentro do jogo** (combate e caminhada). Nas pranchas, a decisão é sua.

### 4.4 A cor do círculo é luz, e tocar um santo é assédio

- A Direção de Arte já dá uma cor a cada círculo. Proponho usá-la **só como luz** (névoa, contorno, brilho), nunca como tinta dos objetos. As pedras continuam de osso e cinza; o que muda é a luz que bate nelas.
- E uma regra de leitura com três estados, que o jogador aprende no Círculo 2 e usa até o 9:

| O que se vê no santo | O que significa |
| --- | --- |
| **Ouro** | Graça (Consolação, milagre, intercessão) |
| **Sem cor** (cinza) | Provação (desolação, Noite Escura) |
| **A cor do círculo** | Assédio (a Provação do Círculo, que você aprovou) |

- O contorno roxo da Vertigem (D-237) já é isso. Vira o padrão: Fome em verde-oliva, Ouro Maldito em latão, Torpor em vermelho-lodo, e assim por diante.
- **A descida em temperatura:** os Círculos 2 a 5 são úmidos e turvos; o 6 e o 7 queimam; o 8 e o 9 esfriam até quase não haver cor. O Círculo 9 pode ser **quase preto e branco**, com o azul-gelo só nas bordas. Quando a companhia sair e rever as estrelas, a cor volta de uma vez.

### 4.5 Eclipse e clareira: como se vê a desolação e a Consolação

A Direção de Arte já diz que a auréola fica "eclipsada" na Noite Escura. Proponho levar isso ao pé da letra, porque é a imagem certa: **num eclipse, a luz continua lá; só está escondida.** É provação, não queda.

| Estado | Auréola | Corpo | Chão |
| --- | --- | --- | --- |
| Normal | Disco de ouro chapado | Cores normais | Sombra curta |
| Desolação subindo (75+) | O disco escurece **de um lado**, como a lua cobrindo o sol | Perde cor aos poucos (já existe) | A sombra **cresce** na direção dos inimigos |
| **Noite Escura** | **Disco preto com um anel fino de ouro** em volta | Quase silhueta; só o fio âmbar da lanterna nas costas | Sombra longa |
| **Consolação** | Disco cheio e raios (já existe) | Cores vivas | **Sem sombra: uma clareira de ouro no chão**, que alcança os vizinhos |
| **Purificação** | O anel fino **abre-se** de novo em disco | A cor volta de dentro para fora | — |

- **A clareira da Consolação** é o desenho perfeito para a ideia que você aprovou ("a consolação é dom"): quando o santo dá a Consolação, a clareira **anda** pelo chão até o companheiro.
- **No cenário:** não escurecer a tela inteira pela desolação (confunde com o Lume). O cenário reage só no ponto alto: na entrada em Noite Escura, a cor do círculo some por um instante da tela toda; na Consolação, um instante de ouro.
- **Custo:** baixo. A auréola já é do motor (ADR-0008); o anel é uma segunda arte de auréola; a sombra é uma mancha no chão que estica.
- **Testa no M2:** sim, com os botões de teste que já existem.

### 4.6 O instante de ícone

- Darkest Dungeon tem a tela de aflição e de virtude: o herói em close, sobre vermelho ou sobre luz.
- Para as telas de passagem já previstas (milagre, Consolação, Noite Escura; D-210, D-213), proponho uma imagem que só este jogo pode ter: por um instante, **o Inferno some e o fundo vira folha de ouro lisa**, como num ícone ou numa iluminura. O santo aparece em tinta preta sobre o ouro, com o nome em letra de manuscrito.
- Na **Noite Escura**, o inverso: fundo **preto total**, o santo em contorno claro, e só o anel fino de ouro.
- Na arte, nada muda: a folha de telas de passagem já pede o santo sozinho em fundo neutro, e diz que o motor monta a cena. Muda só o que o motor põe atrás.
- **Custo:** baixo. **Testa no M2:** sim (T44).

---

## 5. O que corrigir antes de gerar mais

### 5.1 A ordem

1. **Decidir as regras do §4** (ao menos 4.1, 4.2 e 4.5). Elas mudam o que se pede nos prompts.
2. **Escolher uma âncora de estilo por categoria** e usá-la como referência de estilo em toda geração nova:
   - santos: **Santa Teresinha** (tem o traço pesado e, ao mesmo tempo, roupa clara que se lê no escuro);
   - inimigos corpóreos: **Cornífero de Ferro**;
   - inimigos espirituais: **Sentinela de Dite**;
   - chefes: **Moloque**.
3. **Regenerar só quatro peças:** Fúria, Sentinela Gélida, Belial e o retrato de Bento. O resto se resolve no motor ou fica.
4. **Gerar um santo de hábito escuro como teste** (prompt T-1) e vê-lo **no combate, sobre o Círculo 2**, antes de gerar os outros oito.
5. Só então: os 9 santos, os cenários dos Círculos 3 a 5 e Lúcifer.

### 5.2 Um tratamento único no motor para os três santos atuais

Sem refazer nada: o mesmo ajuste para todo santo (contraste um pouco maior, sombras puxadas para o preto, o fio âmbar nas costas). Aproxima Jorge de Bento e Teresinha e resolve o hábito preto. Vocês já fazem ajustes desse tipo na ferramenta de quadros (D-332).

### 5.3 Três mudanças no bloco comum dos prompts de santos

O prompt atual de todo santo diz: `dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light`.

| Hoje | Proposta | Por quê |
| --- | --- | --- |
| `dark blood red accents` | `dark red only on the saint's own garments and attributes` | Tira o "sangue" da roupa |
| `ink splatter on the figure only` | `sparse black ink splatter on the figure only, no red splatter, no blood stains` | Idem |
| `dramatic rim light` | `a thin warm amber rim light along the back edge of the figure, the front in deep shadow` | A luz da lanterna já vem na arte, e o hábito escuro ganha contorno |

E acrescentar ao `--no`: `blood on clothes, gold, glowing eyes`.

### 5.4 Os 9 santos: onde está o risco de cada um

Só sobre o que os prompts e os kits já dizem; fatos e iconografia são seus.

| Santo | Risco visual | Sugestão |
| --- | --- | --- |
| Santo Antão | Mais um velho de barba e hábito escuro, ao lado de Bento | Diferenciar pela **silhueta**: magro, curvado, cajado em tau bem alto, sem capuz |
| Santa Rita | Hábito e véu pretos: o maior risco de sumir | É o santo ideal para o teste T-1. As rosas vermelhas são o único acento |
| Santa Gertrudes | Outra monja de preto, ao lado de Rita | Postura e objeto diferentes (de pé, ereta, livro aberto); nunca as duas com o mesmo gesto |
| São Padre Pio | Hábito marrom, figura do século XX num mundo medieval | O GDD pede época medieval "em toda a ambientação". O hábito capuchinho já é atemporal: evitar qualquer objeto moderno |
| Santo Antônio de Pádua | Hábito franciscano marrom, parecido com Pio | Um jovem e um velho; um com livro, outro com terço. Cores de marrom diferentes |
| São João da Cruz | Carmelita, como Teresinha | Capa branca sobre marrom ajuda a ler; baixo e franzino na silhueta |
| São Nicolau | Bispo: a tentação é pôr **ouro** na mitra e no báculo | Ouro é só da graça. Mitra e paramentos em **osso e vermelho**, báculo de madeira ou ferro |
| Santa Joana d'Arc | Armadura de placas brilhante, de outro século que a de Jorge | Aço **fosco e escuro**, e o estandarte claro como a grande forma da silhueta |
| São Sebastião | Confusão com Jorge | Ver §3.2 |

**Uma regra de conjunto:** antes de aprovar um santo, ponha a silhueta dele **toda em preto** ao lado das outras 11. Se não der para dizer quem é, a silhueta precisa mudar.

### 5.5 Cenários dos próximos círculos

- Manter a receita do Círculo 2 (fundo, meio emendável, frente só nos cantos).
- **A cor do círculo entra na névoa e na luz, não nas pedras** (§4.4). No prompt: trocar `palette of black, bone, ash grey and <cor>` por `palette of black, bone and ash grey, lit by a dim <cor> glow from below and from the far distance`.
- **Sempre uma faixa escura e lisa atrás de onde ficam as figuras** (o erro do fundo do trecho 3).
- **Pouso e Vigília sempre em âmbar**, em todos os círculos. É o fio que liga a campanha.

### 5.6 Lúcifer

O prompt já existe (três faces, seis asas de morcego, preso no gelo até a cintura, visto de frente). Sugestões:

1. **Ele não é um personagem na cena; ele é a cena.** Gerar em paisagem bem larga, com o busto ocupando toda a largura do campo. As três faces viram os três "lugares" do chefe (o GDD já prevê que atingir uma face silencia a intenção dela, P10).
2. **As três faces bem separadas e legíveis**, cada uma do tamanho de um santo.
3. **A face "branco-amarelada" de Dante em osso**, nunca em ouro.
4. **Quase sem cor** (§4.4): preto, branco e o azul-gelo nas bordas. A única luz quente da tela é a lanterna.
5. **A prisão de gelo do Peregrino** (P10) como um bloco de gelo com a **luz pálida** dentro, o mesmo desenho do Mapa do Inferno que você aprovou.
6. **São Miguel sem contorno** (§4.3): uma forma branca, a única coisa na tela sem tinta preta.

Prompt de teste em §7 (T-6).

---

## 6. HUD e interface: respostas às dúvidas

D-257 e D-258 ficam como estão: preto e cinza, ferro forjado, Pirata One, vermelho só para perigo, dourado só para o especial. O que proponho é **cumprir essa regra à risca**, porque hoje ela vaza.

### 6.1 Onde o ouro e o vermelho estão sendo gastos

| Elemento hoje | Problema | Proposta |
| --- | --- | --- |
| Marcador tracejado **dourado** sob quem age | Ouro usado para "selecionado" | **Osso** (claro). Ouro é só graça |
| Botão **Milagre** em dourado | Certo | Manter: milagre é graça |
| Fervor em quadradinhos amarelos | Certo, mas com cara de bateria | **Chamas pequenas de ouro** (a Direção de Arte original já pedia 6 chamas) |
| Lume: lamparina e número | O número é âmbar ou ouro? | **Âmbar**, sempre (§4.2). A chama em 3 tamanhos, um por faixa |
| **Todos** os discos de intenção em vermelho | Vermelho deveria ser só perigo | **Vermelho só no ataque.** Deslocar, corromper, invocar e defender em disco de ferro com o desenho em osso |
| Estandartes vermelhos com chaves douradas nos dois lados do painel | Bonitos, mas são vermelho e ouro permanentes, competindo com as auréolas | Deixar **só um**, ou escurecer bastante. Decisão de gosto, sua |

### 6.2 Três camadas de informação (para o celular)

| Camada | O que fica | Regra |
| --- | --- | --- |
| **Sempre na tela** | Vida, desolação, auréola, intenção e alvo, Fervor, Lume, rodada | Lê-se a um braço de distância, sem tocar |
| **Ao tocar** | Ficha do inimigo, descrição da habilidade, condições com nome | No painel de ferro, como já é |
| **Nunca no combate** | Atributos, equipamento, relíquias, Laços em detalhe | Só na vila e no Pouso |

### 6.3 Onde entram as mecânicas que você aprovou

O risco agora é encher a tela. Uma sugestão de lugar para cada uma, sem criar painel novo:

| Mecânica | Onde aparece | Como |
| --- | --- | --- |
| Interceder | Na fila de Trocar e Passar | Um terceiro botão, com um fio de ouro como ícone |
| Súplica | Ao lado de Provisões | Um retrato pequeno com auréola por santo na Capela; apaga depois de usado |
| Domínio do chefe | Junto da barra de vida do chefe | De 0 a 3 **garras** na cor do círculo; cada uma que cede se desfaz |
| Desolação por rodada | Junto de "Rodada 1" | Um número pequeno que sobe |
| Aviso do teste de Fé | No disco da intenção inimiga | Uma pequena auréola em eclipse ao lado do número |
| Fidelidade | Sob a auréola em eclipse | Até 3 chamas pequenas |
| Laços | Entre os retratos, só na vila e no Pouso | Um fio fino; no combate, nada |
| Quem leva a lanterna | Na própria figura | A lanterna desenhada pelo motor junto do santo; some da haste lateral |

### 6.4 A vila

D-257 e D-258 falam do combate e da caminhada. Para a vila, sugiro **o mesmo ferro**, mas **iluminado por vela**: as molduras iguais, a luz âmbar. O jogador sente que saiu do abismo sem que a interface vire outro jogo.

### 6.5 Leitura

Mantendo a Pirata One (D-258): definir um **tamanho mínimo** para texto corrido e testar no Redmi as descrições de habilidade. Se cansar, a saída é aumentar o corpo e cortar texto, não trocar a fonte.

---

## 7. Efeitos (VFX): uma gramática

Você reprovou os primeiros efeitos por não serem "2D e com a identidade do jogo" (D-235) e depois aprovou seis modelos (D-237, D-238). O que proponho é **a regra por trás** deles, para os próximos saírem certos de primeira.

### 7.1 Três matérias

| Matéria | De quem é | Como se desenha | Exemplos aprovados |
| --- | --- | --- | --- |
| **Ouro e branco** | Graça e anjos | Formas **recortadas**, de borda dura, chapadas, como papel dourado. Nunca nuvem, nunca brilho borrado | Cruzes em órbita (E1), anel de Bento (B2), escudo de luz de Jorge (B3) |
| **Tinta** | O abismo | Mancha preta que escorre, respinga e se espalha; fumaça **desenhada**, com traço, na cor do círculo | Contorno roxo da Vertigem (V1), sopro de Asmodeu |
| **Corpo** | Golpes físicos | A câmera e o próprio personagem: aproximar, tremer, um corte de tinta preta e vermelha | Câmera de impacto (G1) |

**Regra de ouro:** se um efeito sagrado tem borda borrada, está errado. Se um efeito demoníaco tem borda limpa, está errado.

### 7.2 Uma forma por santo

Cada santo abençoa e faz milagre com **uma forma só**, tirada do que o kit dele já tem. As três primeiras já estão aprovadas; as outras são **proposta**, e a origem de cada uma é sua:

| Santo | Forma |
| --- | --- |
| Jorge | Escudo com cruz (aprovado) |
| Bento | Anel (aprovado) |
| Teresinha | Pétalas (aprovado) |
| Nicolau | Três bolsas ou três moedas de osso |
| Antão | Cruz em tau |
| Joana | Estandarte que se desenrola |
| João da Cruz | Uma chama |
| Padre Pio | Contas de terço em fila |
| Rita | Rosa e espinho |
| Antônio | Peixes ou pão |
| Sebastião | Flechas que se cravam no chão em muralha |
| Gertrudes | Notas de canto ou um livro aberto |

### 7.3 Efeitos novos para o que foi aprovado

| Mecânica | Efeito |
| --- | --- |
| **Interceder** | Um fio de ouro liga os dois santos; uma gota de tinta preta corre pelo fio de um para o outro. O peso anda, não some |
| **A consolação é dom** | A clareira de ouro escorre pelo chão até o companheiro; a auréola de quem deu volta ao disco simples |
| **Súplica** | Um recorte de ouro do santo que reza aparece no alto, sem contorno, por um instante |
| **Domínio que cede** | Uma garra na cor do círculo se abre e vira cinza |
| **Firmeza** (resistir à provação) | O contorno da cor do círculo em volta do santo **estilhaça** para fora |
| **Lanterna no chão** | O âmbar do campo recua de uma vez; a cor do círculo avança |
| **Entrada na Noite Escura** | O disco de ouro é coberto de lado, como eclipse; fica o anel |
| **Purificação** | O anel se abre em disco, de dentro para fora |

### 7.4 Limites para o celular

- No máximo **um** efeito de tela cheia por ação.
- Nada de luz dinâmica; só faixas de cor e contornos.
- Todo efeito termina em menos de 1 segundo na velocidade normal, e é pulado no modo rápido.

---

## 8. Prompts de teste

Sete testes baratos. Cada um responde a **uma** pergunta. Seguem o formato das suas folhas; use a âncora de estilo como referência (§5.1). Não gerei nenhuma imagem: os créditos são seus, e o saldo estava baixo.

### T-1 · Um santo de hábito preto se lê no escuro?

Santa Rita, com as três mudanças do §5.3. Depois de gerar, veja a figura **sobre o cenário do Círculo 2**.

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, entire figure from head to feet fully inside the frame, figure height about 78 percent of the image height, feet resting about 6 percent above the bottom edge, figure centered horizontally, Saint Rita of Cascia as a 15th-century Augustinian nun, black habit and black veil over white wimple, a thorn wound on her forehead, the crucifix held forward in one hand, red roses in the other, determined resolute expression, thick irregular black ink outlines, heavy black shadows engulfing the front half of the figure, angular blocky shading, muted desaturated colors with painterly flat fills, bone and ash grey, dark red only on the roses, sparse black ink splatter on the figure only, no red splatter, no blood stains, a thin warm amber rim light along the whole back edge of the figure from head to hem, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, gold, blood on clothes, glowing eyes, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

### T-2 · A auréola em eclipse (Noite Escura)

```text
2D gothic game VFX asset in the style of Darkest Dungeon, a single perfectly circular solid black disk with a very thin irregular ring of flat gold around its edge, like a total solar eclipse drawn in ink, hand-inked texture, no rays, no glow, centered, front view, isolated on a plain flat solid light grey background --ar 1:1 --no face, head, person, rays, lens flare, soft glow, text, glossy, 3D, photorealistic
```

### T-3 · A auréola sendo coberta (desolação subindo)

```text
2D gothic game VFX asset in the style of Darkest Dungeon, a flat gold halo disk with a thick irregular black ink outline, one third of the disk covered by a solid black circular shadow sliding in from the right side like a partial eclipse, hand-inked texture, centered, front view, isolated on a plain flat solid light grey background --ar 1:1 --no face, head, person, rays, soft glow, text, glossy, 3D, photorealistic
```

### T-4 · A clareira da Consolação (no chão)

```text
2D gothic game VFX asset in the style of Darkest Dungeon, a flat elliptical pool of gold leaf light lying on the ground seen from a low side view, hard cut-paper edges with a few short straight rays along the rim, completely flat gold with no gradient and no shading, hand-inked irregular edge, isolated on a plain flat solid light grey background --ar 21:9 --no person, feet, shadow, soft glow, blur, text, glossy, 3D, photorealistic
```

### T-5 · O sagrado sem contorno (São Rafael na luta de Asmodeu)

Pergunta: uma figura **sem tinta preta** funciona ao lado das outras?

```text
2D gothic game art, a single tall winged archangel figure rendered only as a flat pure white cut-paper silhouette with no outline and no inner lines, a traveller's staff in one hand and a fish held in the other, a flat gold disk behind the head, serene upright stance, absolutely no black ink, no shading, no facial features, hard clean edges, isolated on a plain flat solid dark grey background --ar 2:3 --no black outline, ink, shadows, face details, armor details, texture, glow, text, 3D, photorealistic
```

A iconografia de São Rafael (cajado de viajante e peixe, do Livro de Tobias) é para você conferir.

### T-6 · Lúcifer como cenário

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, in the spirit of Gustave Dore engravings, extreme wide front view, Lucifer as described by Dante, the colossal upper body of a fallen angel rising from a frozen lake and filling the entire width of the image, three huge faces on one head set wide apart and each clearly readable, the central face dark red, the right face pale bone white, the left face black, six enormous bat-like wings spread to both edges of the frame, tears and bloody foam on the three chins, ice sheet across the bottom of the image, almost monochrome, palette of black, white and ash grey with only a faint icy pale blue on the edges of the ice, massive black ink shadows, thick irregular black ink outlines, angular blocky shading, isolated on a plain flat solid light grey background above the ice line, no text, front view --ar 21:9 --no gold, yellow, halo, feathered wings, fire, warm light, small figure, cartoon, anime, glossy, 3D, photorealistic
```

### T-7 · Cenário com a cor na luz, não na pedra (Círculo 3, trecho 1)

Compare com o que sair do prompt atual do Lamaçal.

```text
Darkest Dungeon style 2D side-view dungeon background, hand-painted gothic horror, hand-inked comic art, a vast swamp of filthy mud under endless dirty rain and hail, bloated shapes half sunk in the mire far away, broken stone troughs, all stone and mud painted only in black, bone and ash grey, lit by a dim sickly olive green glow rising from the mud and from the far distance, a smooth dark band across the middle of the image behind where characters will stand, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, bright green, saturated colors, warm light, text, UI, cartoon, 3D, photorealistic
```

---

## 9. Custo e ordem

| # | O que | Quem | Custo | Quando |
| --- | --- | --- | --- | --- |
| 1 | As duas luzes no combate (§4.1) e o tratamento único dos santos (§5.2) | Motor | Baixo a médio | M2 (cabe na T52 ou T53) |
| 2 | Ouro × âmbar na interface; vermelho só no ataque (§6.1) | Motor | Baixo | M2 (T44) |
| 3 | Auréola em eclipse, sombra e clareira (§4.5); testes T-2, T-3, T-4 | Você gera 3 peças; motor | Baixo | M2 (T44) |
| 4 | Telas de passagem como instante de ícone (§4.6) | Motor | Baixo | M2 (T44) |
| 5 | Teste T-1 e, se passar, os 9 santos com o bloco novo de prompt | Você | Médio | Antes do M3 |
| 6 | Regenerar Fúria, Sentinela Gélida, Belial e o retrato de Bento | Você | Baixo | Antes dos Círculos 6 e 9 |
| 7 | Cenários dos Círculos 3 a 5 com a cor na luz (T-7) | Você | Médio | M3 |
| 8 | Lúcifer (T-6) e o sagrado sem contorno (T-5) | Você | Baixo para testar | Quando quiser; decide cedo o tom do final |

## 10. O que eu preciso que você decida

1. **As duas luzes** (âmbar da lanterna contra a cor do círculo, com o Lume movendo a fronteira): aprova para testar?
2. **Ouro só para a graça, âmbar para o fogo**, inclusive na interface (o marcador de seleção deixa de ser dourado)?
3. **O sagrado sem contorno de tinta** dentro do jogo (anjos, Súplica)? E nas pranchas narrativas, fica como está?
4. **A auréola em eclipse** com o anel fino de ouro na Noite Escura, e a clareira de ouro na Consolação?
5. **As telas de passagem** com fundo de folha de ouro (milagre, Consolação) e fundo preto (Noite Escura)?
6. **Regenerar** Fúria, Sentinela Gélida, Belial e o retrato de Bento? E diferenciar Medusa das Fúrias, e Flégias de Caronte?
7. **O bloco novo dos prompts de santos** (sem vermelho de sangue, com o fio âmbar nas costas)?
8. **Lúcifer como cenário** e quase sem cor?
9. Quer que eu gere algum dos testes pelo ImagineArt? Diga quais; eu aviso o custo antes.

E uma pergunta aberta: você disse que ainda tem dúvidas sobre HUD, interface e efeitos. **Quais são?** Respondi no §6 e no §7 ao que imaginei; se a dúvida for outra, me diga e eu aprofundo.
