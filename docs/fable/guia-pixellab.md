# Guia do PixelLab para o Ad Inferos

Versão 1.0 · 14/11/2026 · consultor convidado · **para o agente que gera a arte**

O que aprendi lendo a documentação da ferramenta, a ajuda embutida dela e gerando as peças do piloto. Custos em **gerações** do plano de Alan (Tier 1, 2.000 por ciclo). Onde algo não foi testado, está dito.

## 1. Acesso

- Servidor para agentes: `https://api.pixellab.ai/mcp` (HTTP), com `Authorization: Bearer <chave>`. A mesma chave serve à API em `https://api.pixellab.ai/v2`.
- **A chave não entra no repositório nem em documento.** Guarde como segredo do ambiente (por exemplo `PIXELLAB_API_KEY`) e leia de lá. A chave usada no piloto ficou escrita no chat: **peça a Alan que gere outra** em pixellab.ai/account.
- Saldo: ferramenta `get_balance`. Galeria de Alan: `list_images` e `get_image("gallery:<id>")`.
- Todo resultado tem um endereço de baixar **sem senha**: `https://api.pixellab.ai/mcp/images/<job>/download` (com `?index=N` para o quadro N de uma animação). Sem o índice vem só o primeiro quadro.
- Referência completa de uma ferramenta, grátis: `search_help(tool="<nome>")`. Dúvida em texto: `search_help(question="...")`.

## 2. As três regras de coerência

1. **Uma âncora de estilo.** O Jorge parado de Alan (`piloto-pixel/jorge_parado.png`) vai como imagem de estilo em **toda** geração.
2. **Uma paleta.** `piloto-pixel/paleta.json` (campo `completa`) vai no parâmetro `palette`, com `palette_name: "Ad Inferos"`. A ferramenta então só usa essas cores.
3. **Um tamanho.** Tela de 256 × 256, figura de 230. A ferramenta **não redimensiona** pixel art: o estilo traz a escala. Nunca amplie ou reduza um sprite para caber.

## 3. Qual ferramenta para quê

| Quero | Ferramenta | Custo | Observação |
| --- | --- | --- | --- |
| Personagem novo no estilo do jogo | `create_image_pro_from_style` | 10 (em 256, vem 1 imagem) | Foi como o Bento saiu, de primeira |
| Redesenhar um personagem que já existe em tinta | `create_image_pro` com `reference_images` (o desenho antigo, com `usage`), `style_image_url` (Jorge) e `palette` | 10 | Foi como saíram o Diabo de Lodo e a Sombra do Desejo |
| Animar um sprite | `animate_image_pixminimax` | 1 para 4 a 8 quadros; 2 para 12 a 16 | É a que Alan usou. Descrição de no máximo 1.000 letras |
| Cenário | `create_image_pro` com `no_background: false` | 25 (acima de 341 de lado) | Teto: 688 × 384 em 16:9; 792 × 336 o mais largo |
| Objeto pequeno, ícone | `create_image_pixen` | 1 | Sem imagem de estilo: confira a coerência; ou `create_image_pro_flash` com `style_image` (5 a 9) |
| Peça de interface | `create_ui_asset` | 10 até 341 × 192 | **Mande as formas** em `pieces`; ver §7 |
| Efeito animado | `vfx_workbench` | Grátis para assinante | Não testei; ver §8 |
| Corrigir um detalhe | `edit_image` (10) ou `inpaint_image` | — | Mantém o resto igual |
| Tirar sujeira, pixel solto | `correct_pixelart`, `pixelart_workbench repair` | — | Não testei |
| Travar a paleta em vários quadros | `reduce_colors` com todos os quadros numa chamada | 0,1 | Quantiza **juntos**, para a cor não variar entre quadros |
| Converter uma imagem do Meta AI | `image_to_pixelart_pro_flash` | 6 | Não testei |

Ferramentas de personagem com 4 ou 8 direções (`create_character`) são para jogo visto de cima. **Este jogo é de lado:** use as de imagem solta.

## 4. Receita: personagem parado

```text
ferramenta: create_image_pro_from_style
description: <quem é, o que veste, o que segura, a pose>, full body side view facing right,
             standing, dark gothic, no blood, no gold, no ground shadow, no scenery
style_images: [ { url: <Jorge parado> } ]
style_description: dark gothic 16-bit pixel art game sprite, grim mood of Darkest Dungeon,
                   chunky black outline, heavy black shadows, muted desaturated palette, selective dithering
palette: <paleta.json> · palette_name: Ad Inferos · no_background: true
```

- Inimigos: `facing left`, e a descrição diz `bone and ash grey with dark blood red`.
- Espirituais: `body made of smoke and flowing ink drawn with a pale bone-white outline instead of black`.
- Santo de hábito preto: peça `drawn in dark charcoal greys, readable folds`. Funcionou no Bento.
- As descrições de cada personagem estão em `prompts-pixel-m2.md` (linhas "PixelLab").

## 5. Receita: animação

**O que funcionou (parado e andar, 1 geração cada):**

```text
ferramenta: animate_image_pixminimax
first_frame_url: <o sprite parado>      frame_count: 8      direction: east      view: side
subject_description: <uma frase dizendo quem é>
description: <só o movimento>. The exact same character in every frame, same costume, colors,
  proportions and line style, strict side view, locked camera, same size and framing, feet on the
  same ground line. No morphing, no extra limbs, no motion blur, no glow, no particles.
```

- A descrição fala do **movimento**; a aparência vem da imagem.
- O resultado tem 9 imagens: a de origem e 8 novas.
- Inimigos: `direction: west`.

**O que não funcionou: oito poses num clipe só.** No Bento surgiu um arco branco de rastro; na Teresinha, riscos de sangue; no Jorge de Alan, o escudo sumiu. A própria ajuda da ferramenta confirma: não há parâmetro para poses intermediárias, e objetos na mão podem sumir.

**Receita para as ações (uma ação por clipe, 1 geração cada):**

| Clipe | De | Até | Descrição (movimento) |
| --- | --- | --- | --- |
| Preparar | parado | — | `drawing the weapon back, about to strike, then holding the pose` |
| Golpear | último quadro do Preparar | — | `lunging forward and striking, then holding the pose` |
| Defender | parado | — | `raising the guard and bracing, then holding the pose` |
| Golpe recebido | parado | — | `recoiling backward from a blow, then holding the pose` |
| Queda | parado | — | `dropping to one knee, then collapsing, head bowed` |

- Use `frame_count: 4` para ações curtas (custa o mesmo 1).
- Para fixar onde a ação termina, passe `last_frame_url` com uma pose já aprovada.
- Em **toda** descrição de ação, acrescente: `no slash arc, no speed lines, no light effects, no blood, no wounds, the <objeto> stays in the hand in every frame`.
- Na luta o jogo usa **poses seguras** (decisão de Alan): de cada clipe, escolhem-se 1 ou 2 quadros bons. Um clipe imperfeito ainda rende a pose.
- Se um objeto insistir em sumir, a ajuda sugere animar **sem** o objeto e recolocá-lo como camada. Não testei.

**A "fervura".** Mesmo no parado, de 15% a 68% dos pixels mudam de um quadro para o outro. Meça sempre (o programa `ferramentas/piloto_pixellab_mock.py` e o trecho de medição usado no piloto servem de base) e mostre o GIF a Alan. Se incomodar: menos quadros, seguros por mais tempo, ou `reduce_colors` em todos os quadros juntos.

## 6. Receita: cenário

- O maior quadro é 688 × 384. A tela do jogo tem 960 × 540 e o campo, 960 × 360.
- No piloto, o fundo foi cortado para 688 × 360 e **espelhado** 136 pixels de cada lado. Serve para ver; não serve para o jogo.
- Caminhos para o jogo, a decidir com Alan:
  1. **Dois painéis** de 480 × 360 pedidos para emendar (sem garantia de emenda).
  2. **Camadas e peças:** um céu que se repete, e ruínas, pedras e arcos como imagens soltas com fundo transparente, montadas pelo motor em paralaxe. É o mais seguro e o que mais rende, porque as peças se reaproveitam entre trechos.
- Descrição que funcionou: ver `prompts-pixel-m2.md` §5, com `no_background: false`, o Jorge de estilo e a paleta. Peça sempre `a wide flat ledge across the whole bottom as an empty floor for characters, a smooth dark band behind where the characters will stand`.
- O violeta saiu mais vivo do que a Bíblia de Arte pede ("a cor do círculo é luz"). Alan decide se gosta; se quiser menos, acrescente `desaturated violet, mostly black and ash grey`.

## 7. Receita: interface

**O que deu errado no piloto:** pedi "lanceta, rosácea, arco" em texto, com elementos genéricos (`panel`, `button`, `icon_button`, `avatar`). Veio um painel comum, com a palavra "QUEST", uma chave e um retrato de cavaleiro. O material (ferro com rebites) acertou; a forma, não.

**Como pedir da próxima vez:**

- Use `pieces`, que aceita formas com posição: `rounded_rect`, `circle` e `polygon`. Um arco ogival não é uma forma pronta; peça a peça mais próxima e corte o arco por programa, ou gere cada peça como **imagem** (`create_image_pro_from_style`, 10 cada, com a descrição de `prompts-pixel-m2.md` §6).
- Diga sempre: `no text, no letters, no icons, no portrait, empty glass`.
- Estados (apagado, disponível, aceso): `create_ui_states`, depois de dividir o painel com `update_ui_asset(split=True)`. Não testei.
- Texto e números são **sempre do motor**, nunca da imagem.
- Alternativa barata e fiel: as peças da "capela às escuras" são formas simples; o motor pode desenhá-las, como na prévia. A arte entra só como textura de ferro.

## 8. Efeitos

- `vfx_workbench` é grátis para assinante e exporta GIF e folha de quadros. Comandos para conhecer o catálogo: `describe presets`, `describe parts`, `describe recipe`. **Não testei.**
- O que a Bíblia de Arte pede: efeito de santo em **ouro ou branco chapado, borda dura, sem brilho**; efeito de inimigo em **tinta preta de borda escorrida**. A ajuda da ferramenta não soube dizer como se configura "sem brilho": é para descobrir no catálogo.
- Alternativa: gerar cada efeito como animação de imagem (`animate_image_pixminimax`) a partir de um primeiro quadro desenhado (uma cruz chapada, uma mancha), 1 geração cada.

## 9. Conferir antes de mostrar a Alan

- [ ] 256 × 256, fundo transparente, sem meio-tom
- [ ] Figura com 230 de altura (ou a medida combinada para aquele personagem)
- [ ] Todas as cores dentro da paleta
- [ ] Santo virado para a direita; inimigo, para a esquerda
- [ ] Nenhum ouro fora da graça; nenhum sangue em santo; nenhuma letra
- [ ] Animação: mesma altura em todos os quadros, objeto na mão em todos, nenhum efeito inventado
- [ ] Medida de quanto muda entre quadros, e o GIF
- [ ] Lado a lado com as peças já aprovadas

## 10. Custos de referência

| Peça | Custo |
| --- | --- |
| Personagem parado | 10 |
| Parado animado + andar | 2 |
| Cinco ações em clipes curtos | 5 |
| **Um santo completo** | **cerca de 17** |
| Um inimigo completo (parado, parado animado, cinco ações) | cerca de 16 |
| Um cenário de 688 × 384 | 25 |
| Uma peça de interface como imagem | 10 |

Estimativa para o M2 inteiro (3 santos, 7 inimigos, 2 elites, 1 chefe, Círculo 2, interface, vila mínima, Prólogo): **de 600 a 900 gerações**, contando refazer. Cabe no plano atual. Os nove santos que faltam: cerca de 150, contra os cerca de 5.000 créditos estimados para vídeo.

## 11. Fontes

- Guia das ferramentas para agentes: https://api.pixellab.ai/mcp/docs
- Documentação da API: https://api.pixellab.ai/v2/llms.txt
- Página da conexão: https://www.pixellab.ai/mcp
