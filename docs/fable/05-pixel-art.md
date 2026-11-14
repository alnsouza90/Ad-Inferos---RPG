# Mudar toda a arte para pixel art: análise e impacto

Versão 1.0 · 14/11/2026 · consultor convidado · **proposta**. Nada foi alterado fora de `docs/fable/`.

**A ideia de Alan:** refazer toda a arte em pixel art, mantendo o clima de Darkest Dungeon e o essencial da Bíblia de Arte, com referência a *Blasphemous*, usando o **PixelLab** (que tem conexão para o agente gerar sprites, animações e ambientes). Alan mandou três testes feitos no Meta AI (Jorge, Teresinha, Bento), guardados em `previas/pixel_ref_*_metaai.jpg`.

**Os prompts de teste do M2 estão em `prompts-pixel-m2.md`.**

## 0. Limites desta análise

- Eu **não usei o PixelLab** nesta sessão: ele não está conectado aqui. O que digo sobre ele vem de uma busca na documentação pública, feita hoje, e ela é **incompleta e em parte contraditória** (fontes no fim). Tamanhos e preços precisam ser conferidos na própria ferramenta.
- Não sei como ficam, no PixelLab, personagens tão detalhados quanto os do jogo. Isso só um teste responde.

---

## 1. O veredito

**A ideia tem mérito real, e este é o único momento em que a troca ainda custa pouco código.** Mas eu não decidiria por três imagens paradas. Recomendo um **piloto curto com critérios de aprovação** (§7) e, até lá, **parar de gastar na arte em tinta** (não gerar os vídeos dos nove santos, nem as 210 poses dos inimigos).

Três motivos a favor, três contra:

| A favor | Contra |
| --- | --- |
| **Coerência.** Os três testes parecem feitos pela mesma mão, mais do que os três santos em tinta. E uma paleta única, aplicada por ferramenta, força todo o elenco a combinar | **Joga-se fora quase toda a arte pronta:** 3 santos animados, 20 inimigos, 16 elites, 8 chefes, o Círculo 2, 62 edifícios, 9 interiores, 30 ícones, a interface |
| **Animação barata e de verdade.** O PixelLab anima o sprite por centavos de dólar por chamada. Os nove santos em vídeo custariam cerca de 5.000 créditos | **A sombra de *Blasphemous*.** É um jogo de pixel art sobre religião católica penitencial, de tom transgressor. Um jogo reverente com santos, no mesmo visual, será comparado a ele na primeira captura de tela |
| **Leve.** Sprites de 128 pixels no lugar de figuras de 1.200: some o problema de memória no celular e a cota do Git LFS | **Rostos pequenos.** Num sprite de jogo, o rosto do santo tem uns 12 pixels. A expressão vai para o retrato, a postura e a auréola |

E um motivo que desempata a meu ver: **a Bíblia de Arte fica mais forte em pixel**, não mais fraca (§4). Ouro chapado, borda dura, sem contorno, eclipse, vitral de chumbo: tudo isso é nativo do pixel.

---

## 2. O que as três imagens mostram

**O que está bom**

- Os três **combinam entre si**: mesmo contorno, mesma paleta suja, mesmo pontilhado nas sombras.
- O clima é sombrio e sério; nada de "fofo".
- As silhuetas se leem de longe.

**O que precisa de correção** (já corrigido nos prompts novos)

| Imagem | Problema | Por quê importa |
| --- | --- | --- |
| Jorge | **Manchas de sangue** na saia, no escudo e na ponta da lança; a cruz do escudo parece escorrer | Regra aprovada: sem sangue na roupa de santo |
| Jorge | Couraça em tom **dourado** | O ouro é só da graça. Tem de ser bronze escuro, sem brilho |
| Teresinha | **Pétalas e sombra no chão** desenhadas na imagem | Pétalas são efeito; sombra é do motor. Assim não dá para recortar nem animar |
| Teresinha | O crucifixo tem **detalhe mais fino** que o resto do desenho | Dois tamanhos de pixel na mesma figura: em pixel art isso é o defeito mais visível |
| Bento | **Corvo no chão** e sombra desenhada | O corvo vai no ombro, ou é peça separada |
| Bento | Hábito preto, quase sem contorno claro | No cenário escuro ele some, como já acontecia. Pede o fio âmbar nas costas |

**O ponto técnico que mais pesa: não é pixel art de verdade.**

- Medi a imagem de Jorge: os "pixels" têm entre 5 e 9 pontos de largura, **sem grade regular**. É uma pintura com aparência de pixel.
- Convertida para uma grade real, cada figura teria cerca de **240 pixels de altura**. É muito mais detalhe do que um sprite de jogo. Em *Blasphemous*, o protagonista tem perto de 60.
- **O PixelLab trabalha menor.** Pela documentação que achei: personagem com tela padrão de 48 pixels; animação por esqueleto até 128 × 128; animação por texto até 256 × 256; imagens maiores num modelo próprio. Ou seja: **o que o PixelLab entrega será mais simples e mais "quadrado" que estas três imagens.**

Isso não é ruim. É a escolha a fazer com os olhos abertos: **o visual destas imagens serve para retratos e pranchas; o sprite do jogo será mais simples.**

---

## 3. A decisão técnica que vem antes de tudo: o tamanho

Em pixel art, o jogo inteiro é desenhado numa tela pequena e ampliado por um número inteiro. Tudo depende dessa tela.

**Proposta: tela interna de 640 × 360, ampliada 3 vezes (1920 × 1080).**

| Coisa | Tamanho em pixels | Na tela do celular |
| --- | --- | --- |
| Santo (homem) | 112 de altura, numa tela de 128 × 128 | 336 (hoje: 380) |
| Santa | 104 (os 93% já decididos) | 312 |
| Inimigo comum | 96 a 120 | — |
| Enxame | 48 | — |
| Elite | 128 a 150 | — |
| Chefe (Asmodeu) | cerca de 200, numa tela de 256 | — |
| Retrato (interface e diálogo) | 48 × 64 | 144 × 192 |
| Ícone | 16 × 16 (ação: 24 × 24) | 48 ou 72 |
| Cenário | camadas de 640 × 360 (corredor: mais largas) | tela cheia |

- Esses tamanhos cabem nos limites do PixelLab que encontrei (128 para esqueleto, 256 para animação por texto). **Confirme na ferramenta.**
- Celulares mais compridos (o Redmi 12 é mais largo que 16:9): a altura fica 360 e a largura cresce. O cenário precisa de sobra dos lados.
- **Regra de ouro do pixel: um só tamanho de pixel por tela.** Nada de sprite ampliado 3× ao lado de retrato ampliado 2×, nem de girar ou esticar um sprite fora da grade.

---

## 4. O que muda em cada parte da arte

### 4.1 A Bíblia de Arte: o que fica, o que se traduz

| Regra aprovada | Em pixel |
| --- | --- |
| As quatro matérias (tinta, ferro e vidro, âmbar, ouro) | **Ficam.** "Tinta" passa a ser: contorno preto de 1 pixel, sombra em blocos, pontilhado só na sombra |
| Ouro só da graça, chapado, sem contorno | **Fica, e melhora:** vira **uma cor reservada da paleta**. A ferramenta de paleta impede ouro em inimigo por construção |
| Âmbar é fogo que se gasta | Fica: 3 tons de âmbar na paleta |
| O sagrado sem contorno | Fica: sprite sem o pixel preto de borda |
| Arco, círculo, quebrado | Ficam |
| As duas luzes | **Muda de técnica:** em vez de faixa de cor em degradê, um **fio de 1 pixel** na borda da figura (âmbar nas costas do santo, cor do círculo no inimigo) e troca de paleta do cenário. É a técnica clássica do pixel |
| Auréola em eclipse e clareira | Ficam; são formas simples |
| Instante de ícone | Fica: fundo de uma cor só |
| Estampa dos santos e tinta dos inimigos | Ficam, e ficam mais fáceis: efeito em poucos quadros de cor chapada é o normal do pixel |
| A capela às escuras (interface) | **Fica e combina:** linhas de chumbo e vidro apagado são desenho de pixel por natureza |
| Cor de cada círculo como luz | Fica, por **troca de paleta** no cenário |

### 4.2 Personagens

| Parte | Impacto |
| --- | --- |
| **Santos** | Refeitos. Um sprite parado, e as animações **geradas pelo PixelLab a partir dele** (parado, andar, ações). Deixa de existir a conta dos vídeos |
| **Inimigos comuns** | Os 20 refeitos. Em compensação, as poses de ação saem da mesma ferramenta, do mesmo sprite, em vez de 210 imagens à parte |
| **Elites e Pecados Encarnados** | Refeitos. A Vertigem perde o stop motion que custou tanto; o contorno colorido dos Espirituais vira o fio de 1 pixel |
| **Chefes** | Refeitos, perto do limite de tamanho da ferramenta. Asmodeu (três cabeças, dragão, lança) é o teste mais duro de legibilidade: num sprite de 200 pixels, tem de se ler |
| **Lúcifer** | Continua cenário: uma imagem grande, fora dos limites de sprite |
| **Rostos e estados** | A folha atual pede rostos de Noite Escura e Consolação. Num sprite de 112, o rosto não mostra isso. O estado passa a se ler pela **auréola, postura e cor** (já é a regra aprovada) e pelo **retrato**, que troca |

### 4.3 Cenários

- Refeitos: os três trechos do Círculo 2, a arena do chefe, o Pouso e a Vigília.
- **Paralaxe em camadas continua**, com cada camada na grade de 640 × 360 e movimento em passos de pixel inteiro.
- O corredor da caminhada precisa de camadas **mais largas que 640**: geradas em painéis que emendam, ou com peças repetidas (o PixelLab tem ferramenta de peças de chão para vista lateral; não testei).
- A cor do círculo por troca de paleta poupa arte: um mesmo conjunto de pedras serve a dois círculos.

### 4.4 Vila

- Os 62 edifícios e os 9 interiores em tinta **não servem mais**. É a maior perda: os interiores eram a melhor arte de ambiente do projeto.
- Para o M2 bastam 4 instalações. Sugestão: gerar **só o nível 1** de cada, e mostrar os níveis 2 e 3 com acréscimos pequenos (era a regra original da Direção de Arte).
- Aproveite a troca para resolver a perspectiva: em pixel, os edifícios podem ser **de frente**, como em Darkest Dungeon, e não em três-quartos de cima.

### 4.5 Interface e fontes

- As peças da "capela às escuras" (arco, lanceta, rosácea, porta-velas, moldura quebrada, alforje) ainda **não foram geradas**. Aqui não se perde nada: nascem já em pixel.
- **A fonte muda.** A Pirata One não se lê em letra de 8 a 10 pixels. Proposta:
  - **Títulos:** uma gótica de pixel. Há famílias livres desse tipo (por exemplo *Jacquard 24* e *Jacquarda Bastarda 9*); **confira a licença e os acentos do português**.
  - **Texto corrido e números:** uma fonte de pixel simples e larga (por exemplo *Pixelify Sans* ou a família *Jersey*), com o mesmo cuidado.
  - **Alternativa mais segura para ler:** o cenário em pixel e o **texto na resolução cheia do aparelho**. Muitos jogos de celular fazem isso. Fere a "regra de ouro" do §3, mas o princípio de legibilidade do GDD pesa mais. Vale testar as duas no Redmi.
- Isto **revê D-258** (Pirata One) e o leiaute de D-347 (medidas em 1920 × 1080).

### 4.6 Ícones

- Os 30 que existem são refeitos em 16 × 16; os 10 de ação nascem em 24 × 24.
- É o lote mais fácil: o PixelLab é bom justamente em objeto pequeno e isolado.

### 4.7 Pranchas, retratos e telas de passagem

- **Aqui o estilo das três imagens do Meta AI brilha.** Prancha de cena, retrato de diálogo e tela de milagre são imagens paradas, vistas de perto: pedem o detalhe que o sprite não tem.
- Proposta: **duas densidades, nunca na mesma tela.**
  - No jogo (luta, caminhada, vila): sprites simples, na grade.
  - Nas pranchas do Prólogo, nos flashbacks e nas telas de passagem: ilustração de pixel detalhada, tela cheia, convertida para uma grade real de 640 × 360.
- As figuras sagradas (Nossa Senhora, São José) só aparecem em prancha: mantêm a dignidade que um sprite pequeno não daria.
- As 16 pranchas e os 5 retratos do Prólogo **ainda não foram gerados**: também não se perde nada.

### 4.8 Animação

| Decisão já tomada | Em pixel |
| --- | --- |
| Luta em poses para todos; caminhada fluida | **Fica.** As poses e o ciclo de andar passam a vir do PixelLab |
| Santos em vídeo | **Deixa de ser necessário.** É a maior economia da troca |
| O peso do golpe (parada no impacto, recuo, sombra, poeira, antecipação) | Fica igual; é tempo e posição |
| Esmagar e esticar a figura, onda na roupa | **Cuidado:** só funcionam se feitos **dentro da tela pequena**, antes de ampliar. Feitos depois, quebram a grade e o olho percebe na hora |
| Animar aos pulos | Vira o normal |
| Borrão de velocidade | Troca-se por 1 ou 2 quadros de rastro desenhados |

**O risco:** eu não sei se o PixelLab mantém um personagem complexo igual de um quadro para o outro. Vídeo de IA piscava; animação de IA em pixel pode "ferver" (pixels trocando de lugar). É o primeiro critério do piloto.

### 4.9 O motor e o código

- O jogo passa a ser desenhado numa **tela interna pequena** e ampliado sem suavizar. É mudança de base de apresentação: pede um **registro de decisão técnica** e a sua aprovação.
- O leiaute da T36 (posições, tamanhos, linha do chão) é refeito na medida nova.
- A ferramenta de quadros (`process_frames.py`) perde a maior parte do trabalho de tirar fundo cinza de vídeo; fica a montagem das folhas.
- **Entra uma ferramenta nova e pequena:** levar toda imagem para a grade real e para a **paleta única do jogo**. É ela que garante a coerência.
- **As regras do jogo não mudam em nada.** `core/` não sabe o que é pixel.

---

## 5. O que se perde e o que se aproveita

| Já pronto | Destino |
| --- | --- |
| Regras, simulador, testes, salvamento | **Intactos** |
| Tudo o que esta consultoria propôs de design | **Intacto** |
| A Bíblia de Arte (ideias) | Fica; os códigos de cor viram a paleta; os prompts são reescritos |
| Interface, pranchas do Prólogo, retratos, peças de efeito | **Ainda não geradas**: nascem em pixel, sem perda |
| 3 santos animados em vídeo (cerca de 1.200 créditos) | Perdidos; servem de **referência** para os sprites |
| 20 inimigos, 16 elites, 8 chefes | Perdidos como arte de jogo; servem de **referência de desenho** (o PixelLab tem uma ferramenta que converte imagem em pixel art; não testei) |
| Vertigem em stop motion, Asmodeu, Minos | Perdidos. Foram dias de trabalho |
| Cenários do Círculo 2, 62 edifícios, 9 interiores | Perdidos; referência |
| 30 ícones | Refeitos |
| Código da T35 e da T36 | Em parte refeito (medidas, recorte); a lógica de tocar quadros e de ligar poses continua |
| `art-direction.md` e as folhas de prompts (cerca de 1 MB de texto) | Substituídas por uma direção nova |

**Por que agora é o momento menos ruim:** a arte final do M2 (T52 e T53), a vila (T49), o Prólogo (T51) e toda a interface nova **ainda não foram feitas**. Trocar depois delas custaria o dobro.

---

## 6. Riscos

| Risco | Como tratar |
| --- | --- |
| **"*Blasphemous* com santos."** O tom daquele jogo é o oposto do seu | A resposta é a sua identidade: luta por turnos em formação, ouro que não se gasta, capela às escuras, nenhuma crueldade gratuita. Nos prompts, peça o **clima**, não as figuras de lá. E reforce nos textos que os santos são reverenciados |
| O PixelLab não segurar personagens complexos | Piloto com o mais difícil primeiro (Asmodeu, Vertigem) |
| Animação "fervendo" | Critério do piloto; plano B: poucas poses seguras, como já decidido para a luta |
| Duas ferramentas (Meta AI para o desenho, PixelLab para o sprite) saírem diferentes | A paleta única e a conversão para a grade aproximam; conferir no piloto |
| Texto ilegível | Testar as duas saídas do §4.5 no Redmi |
| Refazer tudo e o M2 atrasar muito | O piloto mede o ritmo real antes de decidir |
| Gastar em dois caminhos ao mesmo tempo | **Congelar a arte em tinta** durante o piloto |

---

## 7. O piloto que eu faria (cerca de uma semana)

**Gerar (15 peças):**

1. Jorge, Teresinha e Bento: sprite parado, 112 de altura.
2. Jorge: andar, preparar, golpear, defender, golpe recebido, queda.
3. Diabo de Lodo (Corpóreo) e Sombra do Desejo (Espiritual): parado e ataque.
4. **Asmodeu** parado: o teste de legibilidade.
5. Cenário do Círculo 2, trecho 1, em três camadas.
6. Interface: arco do retrato, lanceta em 3 estados, rosácea, porta-velas, moldura quebrada.
7. Três ícones de ação, a auréola (disco e eclipse), uma estampa (cruz) e um corte de tinta.
8. Um retrato (Teresinha) e uma prancha (o leito) no estilo detalhado.

**Montar:** primeiro uma **imagem parada da tela de combate**, composta por programa, ampliada 3×. Custa quase nada e já responde à maior parte. Só depois, um golpe animado no motor.

**Aprova se:**

| # | Critério |
| --- | --- |
| 1 | O mesmo personagem continua o mesmo em todos os quadros da animação |
| 2 | Os três santos e os dois inimigos parecem do mesmo jogo, depois da paleta única |
| 3 | Asmodeu se lê num sprite dentro do limite da ferramenta |
| 4 | No Redmi, a um braço de distância, lê-se quem é quem e lê-se o texto |
| 5 | Lado a lado com a tela atual em tinta, **você prefere a de pixel** |
| 6 | O custo real por personagem animado, no PixelLab, é o esperado |

Se passar: abre-se um M2 "em pixel", e o primeiro passo é o registro de decisão técnica da tela interna. Se não passar: volta-se à tinta sem ter perdido nada além de uma semana.

---

## 8. Decisões que isto reabre

Para o agente de implementação registrar, se você seguir adiante:

- **D-194, D-197, D-222 a D-255** (animação por vídeo e stop motion dos personagens atuais).
- **D-257, D-258, D-347, D-348** (interface, fonte Pirata One, medidas do combate).
- **D-206, D-213, D-216 a D-220** (folhas de prompts, telas de passagem, cenários do Círculo 2).
- **D-245, D-246** (o Drive "Art Source" passa a guardar a arte antiga como referência).
- A decisão desta consultoria de **santos em vídeo** e de **210 poses de inimigos** (`03-animacao.md` §14).
- `docs/art/art-direction.md`, `asset-pipeline.md` e `ui/screens.md` precisariam de nova versão; só com o seu pedido.

## 9. O que eu preciso de você

1. **Fazer o piloto** antes de decidir a troca? (Recomendo: sim.)
2. **Congelar a arte em tinta** durante o piloto? (Recomendo: sim.)
3. **Tela interna de 640 × 360**, com santos de 112 pixels? (Recomendo; confirme os limites no PixelLab.)
4. **Duas densidades:** sprite simples no jogo, ilustração detalhada em pranchas e telas de passagem? (Recomendo.)
5. **Texto:** fonte de pixel, ou texto na resolução cheia sobre o cenário em pixel? (Testar as duas.)
6. Quando o PixelLab estiver conectado a um agente, quer que os prompts de `prompts-pixel-m2.md` sejam usados por ele direto?

## Fontes consultadas sobre o PixelLab (14/11/2026)

- Ferramentas da conexão para agentes: [pixellab.ai/vibe-coding](https://www.pixellab.ai/vibe-coding) e [pixellab.ai/mcp](https://www.pixellab.ai/mcp)
- Tamanhos e preços estimados por chamada: [pixellab.ai/pixellab-api](https://pixellab.ai/pixellab-api)
- Animação por texto: [animate-with-text-new](https://www.pixellab.ai/docs/tools/animate-with-text-new) e [animate-with-text-pro](https://www.pixellab.ai/docs/tools/animate-with-text-pro)
- Imagens médias e grandes: [create-image-flux](https://pixellab.ai/docs/tools/create-image-flux)
- Converter imagem em pixel art: [image-to-pixel-art](https://www.pixellab.ai/docs/tools/image-to-pixel-art)
- Parâmetros de personagem (página de terceiros, não oficial): [skillsmp.com](https://skillsmp.com/skills/pmarashian-cursor-agent-skills-pixellab-mcp-skill-md)

As páginas se contradizem sobre o tamanho máximo da animação por esqueleto (128 ou 256) e não deixam claro o tamanho máximo de imagem. Não achei descrição de um sistema de créditos; os preços aparecem como estimativa em dólar por chamada.

---

## 10. Piloto: o que há na galeria de Alan no PixelLab (14/11/2026)

A conta passou a "Tier 1: Pixel Apprentice", com 2.000 gerações. A galeria do Creator tem 7 itens (folha em `previas/pixellab_galeria_alan.png`). Medidas feitas por programa.

| Item | O que é | Medidas | Serve? |
| --- | --- | --- | --- |
| Jorge parado | 256 × 256, figura de 230 de altura | 54 cores, grade real, sem meio-tom | **Sim**, como base |
| Teresinha parada | 256 × 256, figura de 233 | 46 cores, grade real | **Sim**; poucos pixels de pétala soltos perto da mão |
| Jorge, ações (9 quadros) | Guarda, lança em pé, preparar, golpe (2), volta (2), defesa, joelho | Alturas de 135 a 238 | **Em parte.** Preparar, defesa e joelho são boas poses. No golpe, **o escudo some** |
| Jorge, parado animado (9) | Respiração | De 39% a 68% dos pixels mudam de um quadro para o outro | Personagem estável, mas a textura "ferve" |
| Jorge, andar (9) | Passo curto, quase no lugar | De 48% a 82% | Para testar em movimento |
| Teresinha, parada animada (9) | Respiração | De 19% a 40% | **A melhor das cinco** |
| Teresinha, andar (9) | O hábito se move | De 43% a 53% | Boa |

**Três conclusões:**

1. **O personagem continua o mesmo de um quadro para o outro.** Era o primeiro critério do piloto, e passa.
2. **A textura muda muito entre quadros**, mesmo no parado. Em movimento isso pode parecer "fervura". A decisão já tomada de **luta em poses seguras** (2 ou 3 quadros parados) esconde o problema na luta; na caminhada, o movimento disfarça. Precisa ser visto no aparelho.
3. **O tamanho é outro.** Estas figuras têm 230 pixels, o dobro dos 112 que eu propus no §3. Para usá-las como estão, a tela interna passa a ser **960 × 540, ampliada 2 vezes**, e não 640 × 360. Fica mais detalhe (o que agradou a Alan) e pixels menores na tela do celular. O limite de 256 da animação ainda cabe.

**Custos medidos nas descrições das ferramentas:** imagem simples, 1 geração; imagem a partir de um estilo, de 10 a 25 por chamada (vem um conjunto de candidatos); animação por texto, de 1 a 3; tirar fundo e reduzir cores, 1 cada. O piloto inteiro deve ficar abaixo de 200 das 2.000 gerações.

**Regra combinada com Alan:** nenhuma peça é gerada sem a aprovação dele, uma por uma.
