# Mosaicos das lancetas e da rosácea · conceito para aprovar (T44, D-436)

Pedido de Alan (17/11/2026): os ícones das habilidades viram **mosaicos de vitral** dentro da lanceta, e o milagre, um mosaico na rosácea. Antes de gerar, o conceito de cada peça, o que vai ser pedido e como encaixa. Base: `docs/fable/biblia-de-arte.md` §8.2 (um desenho por **tipo** de habilidade, D-297) e as peças aprovadas da capela (`game/assets/pixel/ui/`).

## Como encaixa

- **Lanceta** (64 × 153): o rendilhado de cima e a moldura de ferro ficam como estão. A **área de vidro** de baixo (cerca de 44 × 92) deixa de ser a grade de vidros lisos e passa a ser o **mosaico** do tipo da habilidade: o símbolo feito de pedaços de vidro colorido, separados por chumbo escuro grosso, sobre um fundo de vidrinhos violeta e azul-escuro.
- **Três estados**, feitos pelo motor sobre o mesmo mosaico (nenhuma geração a mais):
  - **apagada** (sem Fervor ou indisponível): vidro escuro, quase sem cor;
  - **acesa** (disponível): as cores do vidro aparecem, como luz pálida por trás;
  - **escolhida**: luz âmbar quente atravessando o vidro.
- Embaixo da lanceta: o **nome** e o **custo** em velinhas (Bíblia §8.3); "uma vez por combate" é um ponto de chumbo no canto.
- **Rosácea do milagre** (79 × 78): o anel de ferro fica; o miolo vira um **medalhão de vitral** com o emblema do milagre de cada santo. É o único lugar com **ouro** (a graça). Apagada sem Fervor bastante; acesa quando dá para usar.

## O que vai ser pedido (PixelLab)

`create_image_pixen`, 1 geração por peça, com a lanceta e a rosácea aprovadas como imagem de estilo e a paleta do jogo. Lancetas em 48 × 96 (recortadas pelo motor no formato do vidro); rosáceas em 64 × 64.

**Bloco comum das lancetas:**

```text
pixel art stained glass window panel, tall and narrow, <SÍMBOLO>, built from small pieces of coloured glass, each piece one flat colour, every piece separated by thick dark lead lines, the background made of small irregular deep violet and dark blue glass pieces, the symbol large, centred and readable at small size, 16-bit, crisp hard pixel edges, no gradient, no text, no letters, no gold
```

| Tipo | Para quê | Conceito do mosaico | `<SÍMBOLO>` |
| --- | --- | --- | --- |
| Golpe | Dano físico | Lança em diagonal | `a long spear in diagonal, bone-coloured shaft and pale grey blade` |
| Exorcismo | Dano espiritual | Cruz com raios curtos | `an upright cross in bone-white glass with short pale rays around it` |
| Cura | Devolve vida | Gota dentro de mão aberta | `an open hand in bone glass holding a single drop of soft red glass` |
| Alívio | Tira desolação | Auréola que se descobre (eclipse saindo) | `a round halo of pale glass half covered by a dark disc sliding away` |
| Amparo | Protege | Escudo | `a round shield in grey and bone glass with a plain cross` |
| Força | Fortalece | Chama de pé | `a single upright flame in amber glass` |
| Limpeza | Tira condições | Gota caindo sobre mancha | `a clear drop of pale blue glass falling onto a dark stain` |
| Levantar | Ergue um Caído | Mão puxando outra | `one hand reaching down and pulling another hand up, bone glass` |
| Deslocar | Empurra, puxa, troca | Duas setas tortas | `two curved arrows in bone glass pointing in opposite directions` |
| Retirar | Tira fichas do inimigo | Escudo rachado | `a cracked shield in grey glass split in two` |

**Rosáceas (milagres; ouro permitido):**

```text
pixel art round stained glass medallion, <EMBLEMA>, built from small pieces of coloured glass, each piece one flat colour, separated by thick dark lead lines, a ring of small gold glass pieces around the edge, 16-bit, crisp hard pixel edges, no gradient, no text, no faces
```

| Santo | Milagre | Conceito | `<EMBLEMA>` |
| --- | --- | --- | --- |
| Jorge | Lança do Dragão (lenda) | A lança atravessando o dragão enrolado | `a golden spear piercing a coiled green-black dragon` |
| Bento | Vade Retro (tradição da medalha) | A cruz da medalha de São Bento afastando a fumaça escura | `a bold bone-white cross with a small round medal at its centre, dark smoke pushed back to the edges` |
| Teresinha | Chuva de Rosas (promessa da santa) | Rosas caindo sobre fundo de ouro | `red roses falling over a field of gold glass` |

## Ícones que não são mosaico (botões e condições)

No traço dos ícones que já existem (linha de osso para ações comuns; tinta para condições), 32 × 32, `create_image_pixen`, 1 geração cada:

| Ícone | Onde | Desenho |
| --- | --- | --- |
| Consolação | Botão da luta | `a small hand offering a lit candle`, linha de osso |
| Firmar o pé | Botão da luta | `a sandaled foot planted firmly on cracked stone`, linha de osso |
| Encanto | Condição | `a violet ribbon tied in a loop`, tinta |
| As sete noites | Condição | `seven small dark crescent moons in a ring`, tinta |
| Oculto (Anel) | Condição | `a ring with a closed eye on it`, tinta |
| Vendaval | Condição / aviso | `curved wind lines in bone and violet` |
| Firmeza | Condição | `a heavy boot on a flat stone with a short line under it`, tinta |

## Custo

10 lancetas + 3 rosáceas + 7 ícones = **20 gerações** (1 cada). Se algum não ficar legível pequeno, refazer custa 1; uma versão em alta (`create_image_pro`) custaria 10 e só com permissão.
