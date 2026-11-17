# Acabamento do HUD e mapa do trecho · plano para aprovar (T44, D-440)

Pedido de Alan (17/11/2026): os botões, o HUD e as barras de vida precisam de acabamento (molduras, fundo), e o mapa precisa de um desenho de jogo, inspirado nos mapas dos jogos de referência. Antes de gerar, o plano das peças, com o custo. Tudo no conceito aprovado da "capela às escuras" (ferro forjado, chumbo, vidro, pedra; `biblia-de-arte.md` §9), na paleta do jogo, gerado no PixelLab e mostrado peça por peça.

## 1. Acabamento do HUD

| # | Peça | Onde entra | Como é | Tamanho | Custo |
| --- | --- | --- | --- | --- | --- |
| H1 | Fundo do painel | Os 180 px de baixo, na luta, na caminhada, no Pouso | Pedra escura de capela com uma borda de ferro rebitada no alto; repete na horizontal | 480 × 90 (mostrado 2×) | 25 |
| H2 | Moldura de bloco de ação | Trocar, Passar, Interceder, Consolação, Firmeza, Alforje | Quadrado de ferro forjado com rebites nos cantos; 3 estados (normal, escolhido com aresta âmbar, apagado) | 3 × 56 × 50 | 10 |
| H3 | Moldura de painel em 9 partes | Observação do canto, ficha do inimigo, mini-fichas dos santos, alforje aberto, janelas de confirmação | Placa de ferro com cantos rebitados, centro escuro liso; os cantos e as bordas se esticam sem deformar | 48 × 48 | 10 |
| H4 | Barras de vida e desolação | Debaixo de cada figura, nas mini-fichas, na ficha | Cápsula de ferro fina com o enchimento em vidro: vermelho-sangue (vida) e violeta (desolação) | 2 peças de 64 × 8 | 5 |
| H5 | Barra do chefe | No alto da luta contra o chefe | Barra longa de ferro com as pontas em garra; a vida em vermelho-sangue e as garras do Domínio presas nela | 230 × 20 (mostrado 2×) | 10 |
| H6 | Faixa do alto | Rodada, dica, Pausa, Velocidade | Faixa de ferro estreita, como a trave de um vitral, com os dois botões de ferro já aprovados | 480 × 16 (2×) | 10 |

**Subtotal: cerca de 70 gerações.** O texto continua nas fontes aprovadas (Jacquard 12 e Jersey 10).

## 2. Mapa do trecho

### Referências

- **Slay the Spire:** o mapa é um caminho com bifurcações em camadas, com ícones de nó, e o caminho feito aparece riscado. É o mais parecido com o nosso trecho, que também tem camadas e bifurcações.
- **Darkest Dungeon:** as salas são quadrados ligados por corredores de pedrinhas, o lugar atual tem uma tocha e tudo fica sobre um pergaminho escuro com moldura. Dele vem o clima e o "você está aqui".
- **Blasphemous:** as regiões são células em moldura de ferro e vitral. Dele vem o material.

### Conceito

O trecho é uma **descida**: o mapa abre como uma **lápide de pedra escura com moldura de ferro**, lida de cima para baixo, do Portão ao Pouso, porque a companhia desce o Inferno.

- **Nós:** medalhões redondos de ferro com o ícone do nó dentro, como os óculos de intenção. Há quatro estados:
  - por visitar: escuro, só o contorno;
  - visitado: aceso em osso;
  - atual: aceso em âmbar, com a lamparina do Lume ao lado;
  - desconhecido: escuro, com "?".
- **Caminhos:** pedrinhas cinzeladas na pedra entre um nó e outro. O caminho feito fica aceso em âmbar, como luz da lanterna; os outros ficam apagados.
- **Portão e Pouso:** um arco no alto e uma fogueira embaixo.
- **Luz do círculo:** um brilho violeta fraco nas bordas da pedra.
- **Mini-mapa da caminhada:** os mesmos medalhões numa trave de ferro horizontal, com as pedrinhas entre eles.

### Peças

| # | Peça | Como é | Tamanho | Custo |
| --- | --- | --- | --- | --- |
| M1 | Lápide do mapa | Pedra escura cinzelada, moldura de ferro rebitada, brilho violeta fraco nas bordas, centro liso para os nós | 430 × 220 (mostrado 2×) | 25 |
| M2 | Medalhões dos nós | Moldura redonda de ferro em 4 estados (por visitar, visitado, atual, desconhecido) | 4 × 40 × 40 | 10 |
| M3 | Pedrinhas do caminho | Pedrinha cinzelada apagada e acesa em âmbar | 2 × 8 × 8 | 2 |
| M4 | Portão e Pouso | Arco de pedra pequeno e fogueira pequena, no estilo dos medalhões | 2 × 40 × 40 | 2 |
| M5 | Trave do mini-mapa | Trave de ferro horizontal, onde os medalhões encaixam | 145 × 40 (2×) | 10 |

**Subtotal: cerca de 50 gerações.** Os ícones dos nós já existem e entram dentro dos medalhões.

## Total

Cerca de **120 gerações** (saldo atual perto de 1.070). Ordem sugerida: H1, H2 e H3 primeiro (mudam mais a cara da tela), depois o mapa, depois H4 a H6.
