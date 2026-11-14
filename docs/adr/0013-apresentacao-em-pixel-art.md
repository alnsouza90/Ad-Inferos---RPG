# ADR-0013 · Apresentação em pixel art

**Situação:** Proposta (T63, 14/11/2026), a partir da decisão de Alan D-367; aceita quando Alan aprovar o PR

Revê, para a arte nova, parte do ADR-0007 (origem dos quadros) e do ADR-0011 (tratamento de arte). Os dois continuam valendo para a arte antiga enquanto ela estiver no jogo.

## Contexto

Alan decidiu trocar toda a arte por pixel art gerada no PixelLab (D-367), com o piloto aprovado em `docs/fable/piloto-pixel/` (D-368). Hoje o jogo é desenhado sobre um palco de 1920 × 1080 (D-310) com figuras de 380 px vindas de vídeo e recortadas de fundo cinza (D-329 a D-348). Pixel art só fica nítida se cada pixel do desenho virar um bloco inteiro de pixels da tela, sem suavizar e sem tamanhos quebrados. A especificação técnica do consultor está em `docs/fable/06-rumo-pixel.md` §3.

## Decisão

### Tela

- **Tela interna de 960 × 540.** O jogo é desenhado nessa grade e ampliado por um número inteiro (2× no Redmi 12, cuja tela tem 1080 de altura).
- Configuração do projeto: `window/size/viewport_width=960`, `viewport_height=540`, `window/stretch/mode="viewport"`, `window/stretch/aspect="expand"` (a altura fica em 540 e a largura cresce em aparelhos mais compridos; no Redmi, cerca de 1.230), `window/stretch/scale_mode="integer"`.
- Filtro de textura padrão **"mais próximo"** (`rendering/textures/canvas_textures/default_texture_filter=0`), sem mipmaps nas imagens em pixel.
- Posições e movimentos em **pixel inteiro** (`rendering/2d/snap/snap_2d_transforms_to_pixel=true`); nada girado nem esticado fora da grade. Deformações do motor (antecipação, borrão do peso do golpe) são feitas dentro da tela de 960 × 540, por isso continuam em blocos de pixel.
- Campo de batalha nos 360 de cima e painel nos 180 de baixo; chão em y = 338 (detalhe na T65).

### Imagens

- **Uma paleta:** `docs/fable/piloto-pixel/paleta.json` (campo `completa`, 54 cores) vai em toda geração. A ferramenta de entrada acusa cor fora dela. Ouro `#D9A520` só para a graça.
- **Personagens:** tela de 256 × 256, figura de cerca de 230 de altura, pés na mesma linha em todos os quadros. Santos virados para a direita, inimigos para a esquerda.
- **Clipes:** uma ação por clipe, no máximo 9 quadros (o primeiro é o sprite de origem), cerca de 8 quadros por segundo. Cada clipe vira **uma folha horizontal em PNG** (quadros de 256 lado a lado) e entra no recurso `CharacterFrames` que já existe, de modo que a interface `CombatantView` (ADR-0007) não muda.
- **PNG sem perda**, sem meio-tom de transparência (cada pixel é opaco ou vazio).
- **Fora do Git LFS:** as imagens em pixel do jogo ficam em `game/assets/pixel/` e não passam pelo LFS (exceção em `.gitattributes`). São pequenas (poucos KB), e assim o CI e as sessões na nuvem as recebem sem `git lfs pull`. Os originais do PixelLab continuam em `docs/fable/piloto-pixel/` e, daqui em diante, em `art_source/` (com LFS, como toda a arte de origem).

### Ferramenta

- A entrada dos clipes é uma ferramenta nova em `tools/art/` (Python e Pillow, como no ADR-0011): confere tamanho, grade e paleta, alinha os pés, apaga pixels soltos e o **arco branco** dos quadros rápidos (D-368) e grava as folhas e os `CharacterFrames`. É ferramenta de desenvolvimento; nada dela vai para o jogo (T64).

### Chave do PixelLab

- A chave fica como **segredo de rede do ambiente** das sessões (`api.pixellab.ai`); o intermediário de rede a põe em cada pedido. **Nunca** no repositório, que é público, nem em variável, script ou documento (D-369). Nenhum código do jogo chama o PixelLab: ele só é usado para produzir a arte.

## Por quê

- Ampliação inteira e filtro "mais próximo" são a única forma de cada pixel ter o mesmo tamanho na tela; com 1080 de altura no Redmi, 540 é exatamente a metade.
- `aspect="expand"` mantém o que já acontece hoje: a largura extra dos celulares compridos mostra mais cenário, sem faixas pretas.
- Usar `CharacterFrames` e `CombatantView` como estão limita a troca à arte e ao leiaute; regras, peso do golpe (T59) e luta em poses (T60) não mudam.
- Imagens fora do LFS: a cota de 1 GB do LFS gratuito (D-245) deixa de ser preocupação para a arte do jogo, e os testes que leem imagens funcionam sem passo extra.

## Consequências

- Todo o leiaute do combate, da caminhada e das telas feitas em 1920 × 1080 precisa ser refeito na grade de 960 × 540 (T65 para combate e caminhada; as outras telas na tarefa de cada uma). Até lá, telas antigas ficam com tudo pela metade.
- Em aparelhos com menos de 1.080 de altura (720, por exemplo), a ampliação inteira é 1× e sobra margem em volta. Fica registrado para o teste do M4; o Redmi de Alan não tem esse problema.
- Texto: a fonte Pirata One (D-258) não se lê nesta grade. Fonte de pixel com acentos e licença livre a propor na T65 (D-367, `open-questions.md`).
- Os efeitos e partículas feitos em código (D-335 a D-339) usam luz aditiva e brilho suave, que não combinam com pixel; saem quando os efeitos em pixel forem aprovados (`06-rumo-pixel.md` §4, passo 10).
- `process_frames.py` e o recorte de fundo cinza deixam de ser usados para a arte nova; ficam enquanto houver arte antiga no jogo.
