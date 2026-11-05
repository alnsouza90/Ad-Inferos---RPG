# Prólogo · Roteiro e pranchas

Versão 1.3 · 05/11/2026 · base: GDD v1.1 §9 e §10, Direção de Arte v1.1 §11, *Inferno* de Dante, Cantos I e II
Estado: **rascunho de roteiro para revisão do responsável (Alan)**. v1.3: cortes para o leito de morte (decisão de 05/11/2026, D-198). v1.1: as três feras dão lugar a três figuras humanas que respondem ao Peregrino, uma para cada parte do Inferno de Dante. Os textos marcados como tradução são traduções próprias e literais do italiano de Dante (domínio público).

## 1. Decisões

| Tema | Decisão |
| --- | --- |
| Formato | Só cenas narrativas (pranchas e diálogos). O combate tutorial fica fora do prólogo e será definido depois, provavelmente no Antinferno |
| Abertura | Na selva escura, com o Peregrino, como no Canto I |
| A descida | O Peregrino desmaia na selva; o corpo fica à beira da morte e a alma é arrastada para o abismo. Isso liga o prólogo ao final único do GDD, a boa morte (D-198) |
| A selva | O Peregrino pergunta onde se perdeu. Três figuras respondem, uma para cada divisão de pecados de Dante (*Inf.* XI): incontinência, violência e fraude. Ele cai de terror |
| As três feras | Não aparecem. Cada figura carrega um traço da fera que lhe corresponde (easter egg): loba → incontinência, leão → violência, lonza → fraude |
| Quem são as três figuras | Alegorias com o rosto de **pessoas que o Peregrino conheceu e com quem pecou**. No prólogo são os próprios pecados dele que o atormentam, vestidos com esses rostos; nos flashbacks dos círculos, as mesmas pessoas aparecem como eram na vida dele. Não entram no Arquivo de Santo Tomás. Para não confundir com as elites do jogo, não são chamadas de "Pecados Encarnados" |
| Uso de Dante | Base e referência, sem paráfrase ao pé da letra; citação só onde serve de referência (o verso de abertura e a fala do Canto II) |
| Nossa Senhora | Aparece em imagem icônica (ultramar) e diz uma única frase, a do Canto II |
| Peregrino | Fala pouco, só nas cenas da selva |
| O chamado dos santos | Montagem rápida: três quadros, quase sem diálogo |
| Anjo da Guarda | **Não aparece no prólogo**; espera a companhia na Porta do Inferno, na abertura do Círculo 1 |
| Escolhas | Nenhuma. O prólogo é conduzido; as escolhas começam no Círculo 1 |
| Fim | No Átrio, antes da Porta. A Porta, a inscrição e o Anjo abrem o Círculo 1 |
| Duração-alvo | 5 a 7 minutos, com texto avançado por toque |
| O leito | Cortes rápidos para a cama mostram, desde o início, que o Peregrino está morrendo; a selva é alegoria |

## 2. Regras deste roteiro

- Figuras sagradas: Nossa Senhora só em imagem e numa fala; nunca dá bônus. Os santos nunca pecam.
- Toda fala tirada de fonte indica a origem. O que não tem fonte é criação do jogo e está marcado como `[jogo]`.
- Nenhuma explicação doutrinal com mais de três frases (`writing-guide.md` §3).
- Formato das telas: prancha de fundo em 16:9, texto na faixa de baixo, retrato do falante à esquerda (Peregrino, Luzia) ou nenhum (narrador).
- Avanço por toque; segurar o toque acelera; há botão de pular cena (o prólogo é pulável depois da primeira vez).

## 3. Elenco

| Personagem | Papel no prólogo | Imagem |
| --- | --- | --- |
| O Peregrino | Perdido na selva; cai e tem a alma arrastada | Retrato `R01` e pranchas |
| A Faminta | Incontinência; sedutora, oferece consolo e uma taça vazia | Retrato `R03` e pranchas |
| O Coroado | Violência; acusador, lembra cada culpa | Retrato `R04` e pranchas |
| O Mercador Manchado | Fraude; zomba do Peregrino | Retrato `R05` e pranchas |
| Nossa Senhora | Vê o Peregrino e pede socorro a Luzia | Prancha `P08` |
| Santa Luzia | Mensageira; reúne os santos e os leva ao Átrio | Retrato `R02` e pranchas |
| São Jorge, São Bento, Santa Teresinha | Recebem o chamado; uma fala cada no Átrio | Pranchas `P10` a `P14`; retratos de `prompts-saints-v1.md` |
| Narrador | Versos de Dante e passagens curtas | Sem retrato |
| A mulher idosa | Reza à cabeceira; sem identidade definida | Pranchas `P16` e `P17` |

## 4. Roteiro

A coluna **Tela** diz qual imagem aparece. `NARRADOR` = texto sem retrato, em itálico na tela.

### Cena 1 · O verso

| Tela | Texto |
| --- | --- |
| Tela preta | NARRADOR: *No meio do caminho da nossa vida / encontrei-me numa selva escura, / pois a via reta estava perdida.* |
| Tela preta | Rodapé pequeno: *Dante Alighieri, Inferno, Canto I* |

Origem: Dante, *Inf.* I, 1–3 (tradução própria). Som: silêncio, depois vento entre árvores.

### Cena 2 · A selva escura

| Tela | Texto |
| --- | --- |
| `P02` | NARRADOR: *Ninguém sabe dizer quando começou a se perder. Só que, um dia, já não via o caminho.* `[jogo]` |
| `P02` + `R01` | PEREGRINO: Eu conhecia esta estrada... Eu a conhecia. `[jogo]` |
| `P02` + `R01` | PEREGRINO: Está tudo escuro... `[jogo]` |
| `P16` | Corte rápido, sem diálogo (cerca de 2 s): um quarto pobre à noite. Um homem respira com dificuldade numa cama; uma vela acesa; uma mulher idosa reza com contas de oração. |

### Cena 3 · A pergunta

| Tela | Texto |
| --- | --- |
| `P03` + `R01` | PEREGRINO: Onde foi que eu me perdi? `[jogo]` |
| `P03` | Uma voz de mulher responde da escuridão, e uma figura se aproxima. |
| `P03` + `R03` | A FAMINTA (doce, sedutora): Talvez nos desejos, querido. Você nunca soube dizer basta... e por que diria? `[jogo]` |
| `P03` + `R03` | A FAMINTA: Fique. Ainda há tanto. Beba. `[jogo]` (ela oferece a taça; está vazia) |
| `P04` + `R04` | O COROADO (frio, acusador): Na força. Na raiva com que tomou o que julgava ser seu. `[jogo]` |
| `P04` + `R04` | O COROADO: Eu me lembro de cada vez. Você também se lembra. `[jogo]` |
| `P05` + `R05` | O MERCADOR MANCHADO (rindo, zombando): Ah, não, não! Foi nas palavras! Tantas mentirinhas, tão levinhas... `[jogo]` |
| `P05` + `R05` | O MERCADOR MANCHADO: Quem diria que pesassem tanto, hein? `[jogo]` |

Referências escondidas (não ditas na tela):
- **A Faminta** traz um xale de pele de loba e a magreza de quem nunca se sacia, como a loba "carregada de todas as fomes" (*Inf.* I). Representa a **incontinência** (Círculos 2 a 5).
- **O Coroado** tem a cabeça erguida e um manto de juba, como o leão de "fome raivosa" (*Inf.* I). Representa a **violência** (Círculo 7; no jogo, a família Dite e Violência cobre os Círculos 6 e 7).
- **O Mercador Manchado** veste um manto malhado como a lonza e leva uma corda na cintura, a mesma com que Dante quis prender a lonza e que Virgílio lança ao abismo para chamar Gerião (*Inf.* XVI). Representa a **fraude** (Círculos 8 e 9).
- As três respostas espelham a divisão moral do Canto XI, que é também a divisão das três famílias de inimigos do jogo.
- Os rostos das três são de pessoas da vida do Peregrino. O jogador só descobre isso nos flashbacks, quando reconhece os mesmos rostos sem os mantos de fera.

### Cena 4 · O cerco

| Tela | Texto |
| --- | --- |
| `P06` | As três figuras fecham o círculo em volta dele. |
| `P06` + `R01` | PEREGRINO (aterrorizado): Não... não fui eu. Não só eu... `[jogo]` |
| `P06` + `R03` | A FAMINTA: Shh. `[jogo]` |
| `P06` | O Peregrino recua, tropeça nas raízes e cai. |

### Cena 5 · A queda

| Tela | Texto |
| --- | --- |
| `P07` | PEREGRINO (fraco): Alguém... `[jogo]` |
| `P07` | NARRADOR: *O corpo ficou entre as raízes, ainda respirando. A alma, não. Algo a puxava para baixo, para dentro da terra.* `[jogo]` |
| `P07` | As três figuras observam, imóveis, e se desfazem na escuridão. |
| Tela escurece | Som: um último fôlego; o vento para. |
| `P17` | Corte rápido, sem diálogo (cerca de 2 s): close da vela tremendo e da mão do homem sobre o lençol. A respiração fica mais fraca. |

### Cena 6 · O Céu se move

| Tela | Texto |
| --- | --- |
| `P08` | NARRADOR: *Mas houve quem visse.* `[jogo]` |
| `P08` | NOSSA SENHORA: *Agora o teu fiel precisa de ti, e eu o confio a ti.* |

Origem: Dante, *Inf.* II, 98–99 (tradução própria de *Or ha bisogno il tuo fedele / di te, e io a te lo raccomando*). Única fala de Nossa Senhora no prólogo. Som: um coro curto, sem palavras.

### Cena 7 · A mensageira

| Tela | Texto |
| --- | --- |
| `P09` | NARRADOR: *Luzia de Siracusa, inimiga de toda crueldade, ergueu sua lâmpada e desceu.* |
| `P09` + `R02` | LUZIA: Ele não pode subir sozinho. Então alguém tem de descer. `[jogo]` |

Origem: "inimiga de toda crueldade" traduz *nimica di ciascun crudele* (*Inf.* II, 100). Santa Luzia, virgem e mártir de Siracusa (por volta de 304), é padroeira da visão; a lâmpada alude ao nome (*lux*, luz) `[tradição]`.

### Cena 8 · O chamado (montagem)

Três quadros rápidos, cerca de 3 segundos cada, sem diálogo. A luz da lâmpada de Luzia entra em cada quadro e o santo se levanta.

| Tela | Texto |
| --- | --- |
| `P10` | Nome na tela: **São Jorge** |
| `P11` | Nome na tela: **São Bento** |
| `P12` | Nome na tela: **Santa Teresinha** |

Som: três toques de sino, um por santo.

### Cena 9 · O Átrio

| Tela | Texto |
| --- | --- |
| `P13` | NARRADOR: *À beira do abismo há um lugar que a graça deixou de pé. Os antigos o chamam de Átrio.* `[jogo]` |
| `P13` + `R02` | LUZIA: Daqui para baixo, só há os círculos. A alma dele cai por eles, um a um. `[jogo]` |
| `P13` + retrato de Jorge | SÃO JORGE: Já enfrentei um dragão por uma cidade que nem era a minha. Por uma alma, desço quanto for preciso. `[jogo, alusão à lenda do dragão: lenda]` |
| `P13` + retrato de Bento | SÃO BENTO: A minha Regra começa com uma palavra: escuta. Ele já não escuta ninguém. Iremos até onde a nossa voz alcance. `[jogo, alusão ao Prólogo da Regra, "Ausculta, o fili": hagiografia]` |
| `P13` + retrato de Teresinha | SANTA TERESINHA: Prometi passar o meu Céu fazendo o bem na terra. Debaixo dela também. `[jogo, a partir da frase de 17/07/1897 nos Últimos Colóquios: a confirmar na pesquisa do Martirológio]` |

### Cena 10 · A lanterna

| Tela | Texto |
| --- | --- |
| `P14` | NARRADOR: *Luzia inclinou sua lâmpada e acendeu nela a lanterna da companhia.* `[jogo]` |
| `P14` + `R02` | LUZIA: Lá embaixo, ela vai se gastar. Cuidem para que não se apague. `[jogo]` |

Ligação com o jogo: a lanterna é o **Lume** da expedição e o marcador da companhia no mapa dos círculos.

### Cena 11 · A beira do abismo

| Tela | Texto |
| --- | --- |
| `P15` | NARRADOR: *Muito abaixo, uma luz pálida descia. E, mais abaixo ainda, esperava uma porta.* `[jogo]` |
| `P15` + `R02` | LUZIA: Descansem esta noite. Ao amanhecer, alguém os espera diante dela. `[jogo]` |
| `P16` | Corte rápido, sem diálogo (cerca de 2 s): o mesmo quarto, com a vela um pouco mais baixa. |
| `P15` | Título na tela: **AD INFEROS** · *A Companhia dos Santos* |

Fim do prólogo. O jogo segue para a vila; a primeira expedição abre com a Porta do Inferno, a inscrição do Canto III e o Anjo da Guarda (Círculo 1).

## 5. Prompts das imagens

### 5.1 Formatos

| Tipo | Proporção | Arquivo final | Observação |
| --- | --- | --- | --- |
| Prancha (`P`) | 16:9 | PNG RGB **1920 × 1080 px**, 72 ppi, sRGB; matriz **3840 × 2160 px** em `art_source/` | Imagem completa, sem recorte. Terço de baixo mais escuro para o texto |
| Retrato de diálogo (`R`) | 3:4 | PNG RGBA **768 × 1024 px** | Fundo cinza para recorte; Peregrino e Luzia olham para a direita, as três figuras para a esquerda |

- Gerar com `--ar 16:9` (pranchas) ou `--ar 3:4` (retratos) e Upscale 2×, depois ajustar ao tamanho final.
- Nas pranchas com santos, use os `body_idle` aprovados como referência de personagem (`--cref`/`--oref`) e a imagem de estilo como `--sref`.
- Nas pranchas, figuras sagradas e santos levam auréola de ouro chapado, como nas pranchas da Direção de Arte §11. Nos retratos de diálogo, sem auréola (o motor desenha).
- Pasta: `assets/characters/narrative/prologue/`. Nomes: `prologue_p02_forest.png`, `prologue_r02_lucy.png` etc.

### 5.2 Retratos de diálogo

**`R01` · O Peregrino** (prompt da Direção de Arte §11, sem mudança)

```text
Dark gothic graphic novel illustration in the style of Darkest Dungeon character art, hand-inked comic art, Mike Mignola influence, head to waist portrait, the Pilgrim, a weary 14th-century man in his thirties with an unkempt beard and haunted sunken eyes, worn hooded pilgrim's cloak, a scallop shell badge, gripping a pilgrim's staff, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of bone, ash grey, black and dark blood red, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 3:4 --no halo, parchment background, textured background, vignette, gold, cartoon, anime, smile, glossy, 3D, photorealistic, white background
```

**`R02` · Santa Luzia**

```text
Dark gothic graphic novel illustration in the style of Darkest Dungeon character art, hand-inked comic art, Mike Mignola influence, head to waist portrait, three-quarter view facing right, Saint Lucy as a young 4th-century Sicilian virgin martyr with a calm resolute face, simple light veil and plain dark red robes, holding a burning clay oil lamp close to her chest, a martyr's palm in the other hand, warm lamplight on her face, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of bone, ash grey, black, dark red and warm amber, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 3:4 --no halo, parchment background, textured background, vignette, eyes on a dish, blood, cartoon, anime, smile, glossy, 3D, photorealistic, white background
```

O prato com os olhos (iconografia tradicional) fica só na prancha `P09`, para o retrato de diálogo ficar sereno.

**`R03` · A Faminta**

```text
Dark gothic graphic novel illustration in the style of Darkest Dungeon character art, hand-inked comic art, Mike Mignola influence, head to waist portrait, three-quarter view facing left, a tall strikingly beautiful but terribly emaciated woman with sunken hungry eyes and a sweet inviting smile, a she-wolf pelt draped over her shoulders like a shawl, modest dark gown, holding an empty ornate cup forward, non-sexualized, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and dark blood red, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 3:4 --no halo, gold, nude, cleavage, lingerie, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`R04` · O Coroado**

```text
Dark gothic graphic novel illustration in the style of Darkest Dungeon character art, hand-inked comic art, Mike Mignola influence, head to waist portrait, three-quarter view facing left, a towering proud man with his head held high and a cold accusing stare, a heavy cloak made from a lion's mane and hide, a crude iron crown, scarred bruised knuckles, one finger pointing in accusation, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and dark blood red, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 3:4 --no halo, gold, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

**`R05` · O Mercador Manchado**

```text
Dark gothic graphic novel illustration in the style of Darkest Dungeon character art, hand-inked comic art, Mike Mignola influence, head to waist portrait, three-quarter view facing left, a lean merchant with a sweet treacherous grin, laughing mockingly, a long cloak of spotted dappled leopard-like hide, a rope cord tied around his waist, a merchant's purse and small scales at his belt, one hand raised in a mocking flourish, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and dark blood red, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 3:4 --no halo, gold, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

As três figuras olham para a **esquerda**, de frente para o Peregrino, que olha para a direita.

### 5.3 Pranchas

**`P02` · A selva escura** (sem as feras)

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, a lone weary 14th-century pilgrim with a hooded cloak and a staff lost in a dark tangled forest at night, gnarled trees and thorny branches closing in on all sides, no path visible, the pilgrim small in the frame looking around in fear, cinematic composition, the lower third of the image darker for subtitles, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and dark blood red, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, animals, beasts, cartoon, anime, glossy, 3D, photorealistic
```

**`P03` · A Faminta**

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, in a dark tangled forest at night a tall strikingly beautiful but terribly emaciated woman steps out of the shadows toward a frightened 14th-century pilgrim, a she-wolf pelt draped over her shoulders like a shawl, sunken hungry eyes, a sweet inviting smile, offering him an empty ornate cup with a thin hand, modest dark gown, non-sexualized, cinematic composition, the lower third of the image darker for subtitles, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and dark blood red, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, nude, cleavage, lingerie, wolf animal, cartoon, anime, glossy, 3D, photorealistic
```

**`P04` · O Coroado**

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, in a dark tangled forest at night a towering proud man with his head held high looms over a frightened 14th-century pilgrim, a heavy cloak made from a lion's mane and hide, a crude iron crown, scarred bruised knuckles, a cold accusing stare, pointing at the pilgrim, cinematic composition, the lower third of the image darker for subtitles, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and dark blood red, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, lion animal, gold, cartoon, anime, glossy, 3D, photorealistic
```

**`P05` · O Mercador Manchado**

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, in a dark tangled forest at night a lean smiling merchant leans in mockingly close to a frightened 14th-century pilgrim, a long cloak of spotted dappled leopard-like hide, a rope cord tied around his waist, a merchant's purse and a set of scales, a sweet treacherous grin, laughing, one hand patting the pilgrim's shoulder, cinematic composition, the lower third of the image darker for subtitles, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and dark blood red, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, leopard animal, gold, cartoon, anime, glossy, 3D, photorealistic
```

**`P06` · O cerco**

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, a terrified 14th-century pilgrim stumbling backward among the roots of a dark forest at night, surrounded by three looming figures closing in: an emaciated woman with a she-wolf pelt and an empty cup, a proud crowned man in a lion-mane cloak, and a grinning merchant in a spotted cloak with a rope at his waist, faces half lost in shadow, the pilgrim's staff slipping from his hand, claustrophobic cinematic composition, the lower third of the image darker for subtitles, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and dark blood red, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, animals, nude, gold, cartoon, anime, glossy, 3D, photorealistic
```

**`P07` · A queda**

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, the body of a 14th-century pilgrim lying unconscious among the roots of the dark forest, still breathing, his staff fallen beside him, above him a pale translucent ghostly double of the same man being pulled downward into cracks in the earth by long shadowy hands, three dim human silhouettes watching from the darkness, a woman with a shawl, a crowned man and a man in a long cloak, cinematic composition, the lower third of the image darker for subtitles, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and dark blood red, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, blood, gore, cartoon, anime, glossy, 3D, photorealistic
```

**`P08` · Nossa Senhora** (prompt da Direção de Arte §11, sem mudança)

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, reverent iconographic image of the Virgin Mary, veiled, in a deep ultramarine mantle over a dark red dress, gazing downward with grieving compassion, hands open in intercession, surrounded by a soft flat gold radiance, cinematic composition, thick irregular black ink outlines, deep black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ultramarine blue and flat gold, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, sensual
```

**`P09` · Santa Luzia desce** (prompt da Direção de Arte §11, com faixa para texto)

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, Saint Lucy as a young 4th-century Sicilian martyr, simple veil and robes, holding a burning oil lamp and a martyr's palm, a small dish with two eyes at her side as in traditional iconography, flat gold halo, descending a stair of light into darkness to deliver a message, cinematic composition, the lower third of the image darker for subtitles, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and flat gold, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`P10` · O chamado: São Jorge**

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, Saint George as a young beardless Roman military officer of the late 3rd century with short curly hair, bronze muscle cuirass and red paludamentum cloak, kneeling in prayer in the darkness with his long spear planted beside him and his round cross shield at his side, a warm beam of lamplight falling on him from the left as he lifts his head and begins to rise, flat gold halo, close cinematic framing, the lower third of the image darker for the name, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey, dark blood red and warm amber, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, medieval knight, plate armor, horse, cartoon, anime, glossy, 3D, photorealistic
```

**`P11` · O chamado: São Bento**

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, Saint Benedict of Nursia as an elderly abbot with a long white beard in a black Benedictine habit, sitting in a bare stone monastic cell reading the book of his Rule by a small window at night, a raven perched on the sill, a warm beam of lamplight falling on him from the left as he closes the book and looks up, flat gold halo, close cinematic framing, the lower third of the image darker for the name, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and warm amber, distressed print texture, dark vignette --ar 16:9 --no text, letters, readable text, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`P12` · O chamado: Santa Teresinha**

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, Saint Therese of Lisieux as a young Carmelite nun with a gentle round face, brown habit, white mantle and black veil, standing in a quiet Carmelite cloister garden at night among rose bushes, holding a crucifix wrapped in roses, a warm beam of lamplight falling on her from the left as she turns toward it with a small confident nod, a few rose petals in the air, flat gold halo, close cinematic framing, the lower third of the image darker for the name, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey, dark red and warm amber, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`P13` · Chegada ao Átrio**

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, Saint Lucy with a burning oil lamp leading three saints, a young Roman officer with spear and round shield, an elderly black-robed abbot with a crozier and a young Carmelite nun with a crucifix of roses, through the gate of a small fortified medieval monastery village perched on the rim of an immense dark abyss, candlelit windows, a pale gold dawn sky above and endless darkness below the cliff, all four with flat gold halos, wide cinematic composition, the lower third of the image darker for subtitles, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey, warm amber and small touches of flat gold, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`P14` · A lanterna da companhia**

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, close-up of Saint Lucy tilting her burning clay oil lamp to light a small iron hanging lantern held up by a young Roman officer's hand in a bronze bracer, the flame passing from one to the other in flat gold, faces of the saints softly lit around the flame in the darkness, intimate cinematic framing, the lower third of the image darker for subtitles, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey, warm amber and flat gold, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`P15` · A beira do abismo**

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, in the spirit of Gustave Dore engravings, four small figures seen from behind standing at the edge of a cliff at dusk, a woman with a lamp and three companions with spear, crozier and veil, one holding up a small lantern, looking down into an immense funnel-shaped abyss, far below a tiny pale light falling into the darkness, and deeper still the faint red glow of a colossal gate, immense scale, the upper half of the sky empty for a title, cinematic composition, thick irregular black ink outlines, heavy black shadows, crosshatched engraving texture, muted desaturated palette of black, bone, ash grey, warm amber and a touch of dark red, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

**`P16` · O leito** (pasta `assets/characters/narrative/deathbed/`)

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, a poor 14th-century room at night, a gaunt pale bearded man lying gravely ill in a simple wooden bed breathing with difficulty, a single candle burning on a stool beside the bed, an elderly woman in a plain dark veil kneeling at the bedside praying with wooden prayer beads, a small wooden cross on the bare wall, long shadows, quiet and heavy atmosphere, cinematic composition, the lower third of the image darker for subtitles, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and warm amber candlelight, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, halo, gold, rosary with crucifix pendant, modern objects, cartoon, anime, glossy, 3D, photorealistic
```

**`P17` · A vela e a mão**

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, extreme close-up of a guttering candle flame on a stool beside a bed at night and a thin pale man's hand lying limp on a rough linen sheet, wax dripping, the flame bending as if from a weak breath, intimate cinematic framing, the lower third of the image darker for subtitles, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and warm amber candlelight, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, halo, gold, blood, cartoon, anime, glossy, 3D, photorealistic
```

O Peregrino no leito é o mesmo homem do retrato `R01`, mais magro e pálido; a mulher idosa usa véu escuro simples e contas de oração de madeira (no séc. XIV, contas de oração, não terço). O corte do fim da Cena 11 reaproveita `P16`; o motor baixa a vela e a luz.

## 6. Para o Claude Code

- Este prólogo é um evento do tipo `story` (`docs/specs/narrative-system.md` §1), com id `prologue_main`, de `circle_00`.
- Cada linha das tabelas da seção 4 é uma página (`pages`); `speaker` = `narrator`, `pilgrim`, `the_starving`, `the_crowned`, `the_spotted_merchant`, `our_lady`, `saint_lucy`, `saint_george`, `saint_benedict` ou `saint_therese`; a coluna Tela indica a prancha e o retrato.
- Sem `options` nem `outcomes`; ao terminar, grava a bandeira `prologue_done` e abre a vila.
- O título final (Cena 11) é texto do motor sobre a prancha `P15`, com as fontes da interface (Direção de Arte §12).

## 7. Pendências

- [ ] Revisão do texto por Alan (tom, falas das três figuras, dos santos e de Luzia).
- [ ] Flashbacks: criar as versões humanas das três pessoas (sem os traços das feras), a partir dos rostos de `R03` a `R05`, quando o roteiro de cada círculo for escrito.
- [ ] Confirmar na pesquisa do Martirológio a frase de Santa Teresinha (17/07/1897, *Últimos Colóquios*), a abertura da Regra de São Bento e os dados de Santa Luzia.
- [ ] Combate tutorial: definir com o Claude Code (provavelmente no Antinferno).
- [ ] Música e sons do prólogo (indicados como notas nas cenas).
- [ ] Vinhetas do leito e cena final: decisão D-198 em `docs/memory/decisions.md` (GDD §9, `narrative-system.md` §4.5 e §4.6, Direção de Arte §11).
