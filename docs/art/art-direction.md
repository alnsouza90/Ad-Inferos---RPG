# Ad Inferos — Direção de Arte v1.1

Oct 29, 2026 · @Alan

## Direção oficial a partir de 12/11/2026: a Bíblia de Arte (D-266)

Por decisão de Alan (D-266 (6), com pedido explícito para atualizar este documento), a **Bíblia de Arte** (`docs/fable/biblia-de-arte.md`, com as páginas de `docs/fable/modelos/`) passa a ser a **direção de arte oficial** do jogo.

| Regra | Como fica |
| --- | --- |
| Precedência | Onde a Bíblia e este documento divergem, **vale a Bíblia**. O que a Bíblia não trata continua valendo daqui (prompts por personagem e por cenário, seções 2 a 11, e as folhas de produção de `docs/art/`) |
| Condição | As cores que podem se confundir são testadas no Redmi: latão do Círculo 4 e brasa do Círculo 6 contra ouro e âmbar; carmesim do Círculo 7 contra o vermelho de perigo (Bíblia §15). Se uma falhar, só aquela cor é revista |
| Cores e tamanhos | Os valores em hex e os tamanhos da Bíblia são pontos de partida, confirmados no aparelho |
| O que muda de cara | Quatro matérias com dono (tinta, ferro e vidro, âmbar, ouro e branco); ouro só para a graça; o sagrado sem contorno de tinta; as duas luzes; auréola em eclipse e clareira; interface "capela às escuras" (substitui o pergaminho e ouro da seção 12, que D-257 e D-258 já tinham deixado); efeitos dos santos em estampa e dos inimigos em tinta; ícones de ação nas habilidades; alforje à vista; Pouso em volta da fogueira; vila montada com edifícios soltos |
| Decisões ligadas | D-293 a D-300, D-350 a D-361 (`docs/memory/decisions.md`) |

O texto abaixo continua como estava; leia-o com esta precedência.

## Atualização v1.1 (03/11/2026)

Esta versão corrige os prompts para produção no Godot e incorpora o novo elenco; as regras abaixo prevalecem sobre qualquer trecho antigo deste documento.

| Mudança | Detalhe |
| --- | --- |
| Fundo | Todo personagem é gerado em **fundo liso cinza-claro**, com a textura só na figura, para facilitar a remoção de fundo |
| Auréolas | Removidas de todos os prompts; a auréola é um elemento do motor (abaixo) |
| Elenco | Santa Teresa d'Ávila passa a Guardiã do Carmelo (retrato já gerado); São Nicolau de Tolentino sai; entram **São Nicolau de Mira** e **Santa Gertrudes** (prompts na seção 4) |
| Vila | Edifícios externos separados e fundo vazio (seção 10A) |
| Fervor | Barra da equipe na interface; a auréola mostra só o estado espiritual |
| Animação | A definir pelo piloto com São Jorge: primeiro só poses; se ficar amador, rig para movimentos simples e poses para o resto |
| Círculo 8 | Capas dos hipócritas em latão de brilho falso, nunca em ouro |

### Auréola e estados espirituais (motor)

- Uma única arte de auréola, presa à cabeça do personagem e desenhada atrás dela pelo Godot.
- Os estados são alegoria do momento espiritual, nunca perda de santidade.

| Estado | Auréola | Luz e cor | Rosto |
| --- | --- | --- | --- |
| Normal | Ouro chapado, brilho discreto | Neutra | Padrão |
| Desolação (acima de 75) | Perde brilho aos poucos | Leve dessaturação | Padrão |
| Noite Escura | Obscurecida | Dessaturação forte | Angústia |
| Consolação | Reluzente, com raios | Luz dourada suave | Serenidade |

As imagens de Noite Escura e Consolação já geradas servem de fonte para os rostos; quando a pose muda muito (João da Cruz ajoelhado, Sebastião atrás do escudo), a imagem vale como pose própria do estado.

Arte da auréola:

```text
2D gothic game VFX asset in the style of Darkest Dungeon, a single flat gold halo disk with a thick irregular black ink outline and subtle hand-inked texture, perfectly circular, centered, front view, isolated on a plain flat solid light grey background --ar 1:1 --no face, head, person, rays, text, glossy, 3D, photorealistic
```

Raios para a Consolação e os milagres:

```text
2D gothic game VFX asset in the style of Darkest Dungeon, straight radiating rays of light in flat gold around an empty circular center, hand-inked edges, symmetrical, isolated on a plain flat solid light grey background --ar 1:1 --no face, person, text, glossy, 3D, photorealistic
```

### Padrões técnicos (provisórios, a confirmar no piloto)

| Item | Padrão |
| --- | --- |
| Corpo inteiro | 2:3; tela de trabalho 1024 × 1536; figura do santo com 1200 px; pivô no centro dos pés, a 96 px da base |
| Elites e chefes | 2:3, 4:3 ou 1:1 conforme o tamanho; pivô no centro da base |
| Retratos | 3:4, 768 × 1024, recortados da matriz |
| Fundos de combate | 2560 × 1080 na versão de jogo |
| Formato | PNG; matrizes em resolução máxima guardadas fora da importação do Godot (pasta com `.gdignore`) |
| Nomes | Inglês, minúsculas e sublinhado: `categoria_nome_parte_variante` |
| Versões | Git com Git LFS; versões numeradas só nos originais |

Estrutura de pastas:

```text
art_source/                  ← contém .gdignore; matrizes, camadas e versões
assets/
  characters/saints/<nome>/   body/  portrait/  rig/
  characters/enemies/  elites/  bosses/  guardians/  narrative/
  environments/village/hub/<edificio>/  village/interiors/<instalacao>/
  environments/camp/  environments/circles/circle_03/t1/ ...
  vfx/  halo/  miracles/  impacts/  particles/  ground_markers/
  ui/  icons/  frames/
```

## 1. Conceito, paleta e regras

O estilo é arte de jogo gótica desenhada à mão, no padrão Darkest Dungeon com influência de Mike Mignola; o ouro é a única cor exclusiva do sagrado, e cada círculo tem uma cor de destaque própria. Toda a produção é feita por IA, com os prompts deste documento prontos para colar.

**Traço (comum a tudo)**

- Contornos de tinta pretos, grossos e irregulares.
- Sombras pretas que engolem metade da figura; sombreamento angular em blocos.
- Cores dessaturadas aplicadas como pintura chapada.
- Textura de pergaminho e de impressão desgastada; respingos de tinta.
- Proporções levemente alongadas e exageradas.
- Sangue sempre vermelho escuro.
- Tela em paisagem; arte 2D com animação por esqueleto (Spine).

**Paleta sagrada**

| Cor | Uso |
| --- | --- |
| Ouro chapado | Auréolas, milagres, Fervor, interface ativa. Proibido em inimigos. |
| Ultramar | Reservado a Nossa Senhora e cenas marianas |
| Cinábrio | Rubricas, Esmolas, acentos de interface |
| Branco | Intervenções angélicas |

**Paleta dos círculos**

| Círculo | Cor de destaque | Termo no prompt |
| --- | --- | --- |
| Antinferno e Limbo | Cinza perolado | pale pearl grey |
| 2 Luxúria | Violeta de tempestade | stormy violet |
| 3 Gula | Verde-oliva doentio | sickly olive green |
| 4 Avareza | Latão oxidado | tarnished oxidized brass |
| 5 Ira e Acídia | Vermelho-lodo | muddy dark red |
| 6 Heresia | Laranja-brasa | ember orange |
| 7 Violência | Carmesim | deep crimson |
| 8 Fraude | Verde-veneno | poison green |
| 9 Traição | Azul-gelo | icy pale blue |
| Vila no Átrio | Âmbar de vela | warm amber candlelight |

**Regras de representação**

- Traço uniforme para todos; trajes e atributos historicamente e iconograficamente corretos para cada santo.
- Santos olham para a direita (lado esquerdo da tela); inimigos olham para a esquerda.
- Rostos dos santos expressivos: determinados no padrão, angustiados na Noite Escura, serenos e radiantes na Consolação.
- Corpóreos têm carne sólida e sombra pesada; Espirituais têm corpo de fumaça e tinta, com traço claro invertido.
- Cristo aparece apenas como iconografia (crucifixo, vitrais, o Menino com Cristóvão), nunca em sprite de combate.
- Limites de conteúdo do GDD (seção 11) valem para toda imagem.

**Pipeline de geração**

1. Gerar cada peça separada: personagem com fundo transparente, cenário vazio. Cenas com várias figuras servem só como referência de clima.
2. Escolher a melhor imagem de estilo e usá-la como referência de estilo em todas as gerações (`--sref` no Midjourney ou equivalente).
3. Para cada santo, aprovar a imagem do estado padrão e usá-la como referência de personagem nas variações de estado.
4. Demônios comuns são gerados em tons neutros; a cor de destaque de cada círculo é aplicada no motor por troca de paleta, o que poupa gerações.
5. Elites, chefes e cenários já são gerados na cor do círculo.
6. Nomear arquivos por categoria, nome e estado: `santo_jorge_padrao.png`, `chefe_asmodeu.png`, `cenario_c3_t1.png`.

**Checklist de pós-edição**

- [ ] Auréola só em santos e figuras sagradas
- [ ] Nenhum ouro em inimigos
- [ ] Atributos iconográficos corretos e presentes
- [ ] Mãos, armas e anatomia sem defeitos
- [ ] Nenhum texto, letra ou logo gerado
- [ ] Direção do olhar correta
- [ ] Recorte transparente limpo

## 2. Santos iniciais

Cada santo tem 3 prompts: padrão, Noite Escura e Consolação. Gere o padrão primeiro e use a imagem aprovada como referência de personagem nos outros dois.

### São Jorge

Oficial romano do séc. III–IV, sem barba, couraça e capa vermelha, lança e escudo redondo com cruz.

Padrão:

```plain
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Saint George as a young Roman military officer of the late  3rd century, beardless with short curly hair as in Eastern icons, bronze muscle cuirass with pteruges, flowing red paludamentum cloak, Roman military boots, long spear and round shield bearing a cross, spear held low ready to strike, broad heroic silhouette, determined resolute expression, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, medieval knight, plate armor, great helm, tabard, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

Noite Escura:

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Saint George as a young Roman military officer of the late 3rd century, beardless with short curly hair as in Eastern icons, bronze muscle cuirass with pteruges, flowing red paludamentum cloak, Roman military boots, long spear and round shield bearing a cross, leaning heavily on the spear, anguished exhausted expression, eyes downcast, shoulders slumped, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, medieval knight, plate armor, great helm, tabard, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

Consolação:

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Saint George as a young Roman military officer of the late 3rd century, beardless with short curly hair as in Eastern icons, bronze muscle cuirass with pteruges, flowing red paludamentum cloak, Roman military boots, long spear and round shield bearing a cross, standing tall with spear raised, peaceful radiant expression, faint gold light on the face, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, medieval knight, plate armor, great helm, tabard, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

### São Bento

Abade idoso do séc. VI, hábito beneditino negro, báculo, livro da Regra, corvo, cálice com serpente.

Padrão:

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Saint Benedict of Nursia as an elderly 6th-century abbot with a long white beard, black Benedictine habit with hood and scapular, abbot's crozier, book of the Rule at his belt, a raven on his shoulder, a chalice with a small serpent rising from it, raising the crozier in a warding gesture, determined resolute expression, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

Noite Escura:

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Saint Benedict of Nursia as an elderly 6th-century abbot with a long white beard, black Benedictine habit with hood and scapular, abbot's crozier, book of the Rule at his belt, a raven on his shoulder, a chalice with a small serpent rising from it, bent over and gripping the crozier for support, anguished exhausted expression, eyes downcast, shoulders slumped, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

Consolação:

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Saint Benedict of Nursia as an elderly 6th-century abbot with a long white beard, black Benedictine habit with hood and scapular, abbot's crozier, book of the Rule at his belt, a raven on his shoulder, a chalice with a small serpent rising from it, standing upright with the crozier held high, peaceful radiant expression, faint gold light on the face, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

### Santa Teresinha

Jovem carmelita do séc. XIX, hábito marrom, manto branco, véu negro, crucifixo envolto em rosas.

Padrão:

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Saint Therese of Lisieux as a young 19th-century Carmelite nun with a gentle round face, brown Carmelite habit and scapular, white mantle, black veil over white wimple, a crucifix wrapped in roses held against her chest, rose petals falling, one hand extended in blessing, determined resolute expression, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

Noite Escura:

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Saint Therese of Lisieux as a young 19th-century Carmelite nun with a gentle round face, brown Carmelite habit and scapular, white mantle, black veil over white wimple, a crucifix wrapped in withered roses clutched tightly, falling dry petals, anguished exhausted expression, eyes downcast, shoulders slumped, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

Consolação:

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Saint Therese of Lisieux as a young 19th-century Carmelite nun with a gentle round face, brown Carmelite habit and scapular, white mantle, black veil over white wimple, a crucifix wrapped in blooming red roses, a shower of rose petals around her, peaceful radiant expression, faint gold light on the face, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

### São João da Cruz

Frade carmelita descalço do séc. XVI, pequeno e magro, tonsurado, hábito marrom, capa branca, cruz grande.

Padrão:

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Saint John of the Cross as a small, thin 16th-century Discalced Carmelite friar with tonsure and short dark beard, brown habit, white cape with hood, sandals, a large wooden cross held forward, a quill and a small book at his belt, determined resolute expression, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

Noite Escura:

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Saint John of the Cross as a small, thin 16th-century Discalced Carmelite friar with tonsure and short dark beard, brown habit, white cape with hood, sandals, kneeling and embracing a large wooden cross, a quill and a small book at his belt, anguished exhausted expression, eyes downcast, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

Consolação:

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Saint John of the Cross as a small, thin 16th-century Discalced Carmelite friar with tonsure and short dark beard, brown habit, white cape with hood, sandals, a large wooden cross raised high, a small flame of living light above his hand, peaceful radiant expression, faint gold light on the face, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

## 3. Santos da campanha

Mesma regra: padrão primeiro, depois as variações com a referência de personagem.

### Santo Antão

Eremita do séc. IV, muito idoso, barba branca longa, cajado em tau, sino, porco.

Padrão:

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Saint Anthony the Great as a very old 4th-century desert hermit with a long white beard, rough hooded hermit tunic, a tau-shaped staff gripped like a weapon, a small hand bell at his belt, a tau symbol on his shoulder, a small pig at his feet, leaning forward in a fighting stance, determined resolute expression, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

Noite Escura:

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Saint Anthony the Great as a very old 4th-century desert hermit with a long white beard, rough hooded hermit tunic, a tau-shaped staff, a small hand bell at his belt, a tau symbol on his shoulder, a small pig at his feet, hunched and gripping the staff with both hands, anguished exhausted expression, eyes downcast, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

Consolação:

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Saint Anthony the Great as a very old 4th-century desert hermit with a long white beard, rough hooded hermit tunic, a tau-shaped staff raised high, a small hand bell at his belt, a tau symbol on his shoulder, a small pig at his feet, peaceful radiant expression, faint gold light on the face, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

### Santa Joana d'Arc

Jovem guerreira do séc. XV, armadura de placas, cabelo curto em corte de pajem, estandarte branco com flores-de-lis, espada.

Padrão:

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Saint Joan of Arc as a young 15th-century warrior maiden with short page-boy haircut, full plate armor, a white battle standard with fleur-de-lis held high, a sword at the ready, determined resolute expression, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, long hair, letters, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

Noite Escura:

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Saint Joan of Arc as a young 15th-century warrior maiden with short page-boy haircut, dented full plate armor, a torn white battle standard with fleur-de-lis lowered, sword point resting on the ground, anguished exhausted expression, eyes downcast, shoulders slumped, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, long hair, letters, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

Consolação:

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Saint Joan of Arc as a young 15th-century warrior maiden with short page-boy haircut, full plate armor, a white battle standard with fleur-de-lis raised in triumph, sword lifted, peaceful radiant expression, faint gold light on the face, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, long hair, letters, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

### São Padre Pio

Frade capuchinho do séc. XX, barba grisalha, hábito marrom de capuz pontudo, meias-luvas sobre os estigmas, terço.

Padrão:

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Saint Padre Pio of Pietrelcina as a grey-bearded 20th-century Capuchin friar, brown Capuchin habit with long pointed hood, white rope belt, fingerless brown half-gloves covering the stigmata, a rosary wrapped around one hand, the other hand raised against evil, determined resolute expression, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

Noite Escura:

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Saint Padre Pio of Pietrelcina as a grey-bearded 20th-century Capuchin friar, brown Capuchin habit with long pointed hood, white rope belt, fingerless brown half-gloves stained with blood from the stigmata, clutching a rosary to his chest, bruised face, anguished exhausted expression, eyes downcast, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

Consolação:

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Saint Padre Pio of Pietrelcina as a grey-bearded 20th-century Capuchin friar, brown Capuchin habit with long pointed hood, white rope belt, fingerless brown half-gloves covering the stigmata, both hands raised in blessing, a rosary hanging from one hand, peaceful radiant expression, faint gold light on the face, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

### Santa Rita de Cássia

Monja agostiniana do séc. XV, hábito e véu negros, ferida de espinho na testa, crucifixo, rosas.

Padrão:

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Saint Rita of Cascia as a 15th-century Augustinian nun, black habit and black veil over white wimple, a thorn wound on her forehead, a crucifix held forward in one hand, red roses in the other, determined resolute expression, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

Noite Escura:

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Saint Rita of Cascia as a 15th-century Augustinian nun, black habit and black veil over white wimple, a bleeding thorn wound on her forehead, a crucifix pressed against her chest, wilted roses falling from her hand, anguished exhausted expression, eyes downcast, shoulders slumped, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

Consolação:

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Saint Rita of Cascia as a 15th-century Augustinian nun, black habit and black veil over white wimple, a thorn wound on her forehead, a crucifix raised, a blooming red rose in the other hand blossoming out of snow, peaceful radiant expression, faint gold light on the face, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

### Santo Antônio de Pádua

Frade franciscano jovem do séc. XIII, tonsurado e sem barba, hábito marrom, cordão de três nós, lírio, livro. Sem o Menino Jesus no sprite de combate.

Padrão:

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Saint Anthony of Padua as a young 13th-century Franciscan friar with tonsure, beardless, brown habit with a rope belt with three knots, a white lily in one hand, an open book in the other, preaching gesture, determined resolute expression, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, infant, child, baby, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

Noite Escura:

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Saint Anthony of Padua as a young 13th-century Franciscan friar with tonsure, beardless, brown habit with a rope belt with three knots, a drooping white lily, a closed book held tight, anguished exhausted expression, eyes downcast, shoulders slumped, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, infant, child, baby, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

Consolação:

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Saint Anthony of Padua as a young 13th-century Franciscan friar with tonsure, beardless, brown habit with a rope belt with three knots, a white lily held high, an open book glowing faintly, peaceful radiant expression, faint gold light on the face, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, infant, child, baby, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

### São Sebastião

Soldado da guarda pretoriana do séc. III, armado, com flechas cravadas no escudo e na armadura.

Padrão:

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Saint Sebastian as a young 3rd-century Roman Praetorian guard, Roman segmented armor over a red tunic, Roman helmet, large rectangular scutum shield, arrows embedded in his shield and armor, broken arrow shafts, bracing behind the shield in a defensive stance, determined resolute expression, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, naked, nude, shirtless, medieval knight, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

Noite Escura:

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Saint Sebastian as a young 3rd-century Roman Praetorian guard, Roman segmented armor over a red tunic, Roman helmet, large rectangular scutum shield, many arrows piercing his armor and shield, kneeling behind the shield, bleeding, anguished exhausted expression, eyes downcast, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, naked, nude, shirtless, medieval knight, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

Consolação:

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Saint Sebastian as a young 3rd-century Roman Praetorian guard, Roman segmented armor over a red tunic, Roman helmet, large rectangular scutum shield, arrows embedded in his shield and armor, standing firm and unbroken, peaceful radiant expression, faint gold light on the face, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, naked, nude, shirtless, medieval knight, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

## 4. Santos especiais

Santa Teresa d'Ávila (fundação do Carmelo) e São Nicolau de Tolentino (trilha do Purgatório).

**Atualização v1.1:** Santa Teresa d'Ávila deixa de ser jogável e passa a Guardiã do Carmelo; os prompts abaixo ficam como referência da arte já gerada. São Nicolau de Tolentino sai do elenco. Os novos santos especiais são São Nicolau de Mira (Natal) e Santa Gertrudes (trilha do Purgatório), no fim desta seção.

### Santa Teresa d'Ávila

Carmelita madura do séc. XVI, hábito marrom, manto branco, véu negro, pena e livro, coração atravessado por flecha flamejante, pomba.

Padrão:

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Saint Teresa of Avila as a mature 16th-century Carmelite nun, brown habit and scapular, white mantle, black veil over white wimple, a quill raised in one hand and a book in the other, a heart pierced by a flaming arrow on her chest, a white dove near her head, determined resolute expression, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, letters, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

Noite Escura:

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Saint Teresa of Avila as a mature 16th-century Carmelite nun, brown habit and scapular, white mantle, black veil over white wimple, a closed book clutched to her chest, the quill fallen from her hand, a heart pierced by a dim arrow on her chest, anguished exhausted expression, eyes downcast, shoulders slumped, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, letters, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

Consolação:

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Saint Teresa of Avila as a mature 16th-century Carmelite nun in mystical ecstasy, brown habit and scapular, white mantle, black veil over white wimple, a quill and a book, a heart pierced by a brightly flaming arrow on her chest, a white dove near her head, peaceful radiant expression, eyes lifted upward, faint gold light on the face, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, letters, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

**Fora do elenco na v1.1** (substituído por Santa Gertrudes); prompts mantidos só como histórico.

### São Nicolau de Tolentino

Frade agostiniano do séc. XIII, tonsurado, hábito negro com cinto de couro, estrela no peito, lírios, pães, crucifixo.

Padrão:

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Saint Nicholas of Tolentino as a 13th-century Augustinian friar with tonsure, black Augustinian habit with leather belt, a radiant gold star on his chest, white lilies and a crucifix in one hand, small loaves of bread in a cloth offered forward in the other, determined resolute expression, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

Noite Escura:

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Saint Nicholas of Tolentino as a 13th-century Augustinian friar with tonsure, black Augustinian habit with leather belt, a dim star on his chest, wilted lilies and a crucifix held close, empty cloth in his other hand, anguished exhausted expression, eyes downcast, shoulders slumped, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

Consolação:

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Saint Nicholas of Tolentino as a 13th-century Augustinian friar with tonsure, black Augustinian habit with leather belt, a brightly shining gold star on his chest, white lilies and a crucifix raised, blessed loaves of bread glowing softly in a cloth, peaceful radiant expression, faint gold light on the face, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

### São Nicolau de Mira (novo)

Bispo de Mira do séc. IV, idoso e de barba branca, vestes episcopais orientais, báculo, três bolsas de dote \[tradição\], livro dos Evangelhos. Nunca a figura do Papai Noel.

Padrão:

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Saint Nicholas of Myra as an elderly 4th-century Greek bishop with a full white beard, eastern bishop's vestments with an omophorion stole marked with crosses, a bishop's crozier in one hand, three small closed leather purses held forward in the other in a gesture of giving, a book of the Gospels at his side, determined resolute expression, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, santa claus, red suit, fur trim, sleigh, gold coins, children, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

Noite Escura:

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Saint Nicholas of Myra as an elderly 4th-century Greek bishop with a full white beard, eastern bishop's vestments with an omophorion stole marked with crosses, leaning heavily on his crozier, empty leather purses hanging from his hand, anguished exhausted expression, eyes downcast, shoulders slumped, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, santa claus, red suit, fur trim, sleigh, gold coins, children, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

Consolação:

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Saint Nicholas of Myra as an elderly 4th-century Greek bishop with a full white beard, eastern bishop's vestments with an omophorion stole marked with crosses, crozier raised, one hand lifted in blessing, three leather purses at his belt, peaceful radiant expression, faint gold light on the face, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, santa claus, red suit, fur trim, sleigh, gold coins, children, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

### Santa Gertrudes (nova)

Monja e mística de Helfta do séc. XIII, hábito e véu negros, coração em chamas (devoção ao Sagrado Coração), livro aberto. Sem báculo de abadessa, que pertence a outra Gertrudes.

Padrão:

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Saint Gertrude the Great as a 13th-century mystic nun of Helfta, black habit and black veil over a white wimple, a small flaming heart held against her chest, an open book in the other hand, determined resolute expression, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, crozier, crown, letters, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

Noite Escura:

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Saint Gertrude the Great as a 13th-century mystic nun of Helfta, black habit and black veil over a white wimple, kneeling and clutching a dimly burning heart to her chest, the book closed at her side, anguished exhausted expression, eyes downcast, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, crozier, crown, letters, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

Consolação:

```text
2D gothic horror game character art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Saint Gertrude the Great as a 13th-century mystic nun of Helfta, black habit and black veil over a white wimple, a brightly burning heart raised in her hand, small pale flames rising gently around her like freed souls, eyes lifted upward, peaceful radiant expression, faint gold light on the face, thick irregular black ink outlines, heavy black shadows engulfing half the figure, angular blocky shading, muted desaturated colors with painterly flat fills, dark blood red accents, bone and ash grey, ink splatter on the figure only, dramatic rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, crozier, crown, letters, cartoon, anime, smile, glossy, 3D, photorealistic, white background, facing left
```

Retratos 3:4 dos dois novos santos: recortar da arte aprovada de corpo inteiro, como os demais.

## 5. Demônios comuns

Os 18 comuns são gerados em tons neutros (preto, osso, cinza e vermelho-sangue); a cor de destaque do círculo é aplicada no motor. (C) = Corpóreo, (E) = Espiritual.

### Família A · Incontinência

Diabo de Lodo (C):

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, a hulking hunched mud demon with long dragging arms and a toothed mouth gaping in its chest, dripping black filth, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

Escaravelho Infernal (C):

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, a man-sized infernal beetle standing on its hind legs, its thick cracked carapace raised like a shield, serrated mandibles, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

Moscardo (C):

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, a gaunt insect-man hybrid with membranous wings and a long proboscis spitting venomous stingers, too many joints, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

Sombra do Desejo (E):

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, a tall faceless silhouette with many elongated reaching hands, translucent body of smoke and ink, pale inverted linework on black, glowing pale edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, nude, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

Sopro Errante (E):

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, a swirling whirlwind with screaming faces trapped inside it, translucent body of smoke and ink, pale inverted linework on black, glowing pale edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

Mãe-Enxame (C):

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, a bloated swollen demon covered in flies, open hive-like sores across its body, a swarm circling it, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

### Família B · Dite e Violência

Cornífero de Ferro (C):

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, a brutish horned demon in heavy riveted iron armor wielding a glowing red-hot mace, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

Sentinela de Dite (C):

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, a towering demon soldier like a living fortress, holding a massive gate-shaped iron shield and a long spear, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

Arqueiro Centauro (C):

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, a demonic centaur archer with a gaunt horse body, drawing a bow made of bone, quiver of barbed arrows, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

Caído de Dite (E):

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, a fallen angel with charred burnt wings, a featureless erased face, tattered dark robes, translucent body of smoke and ink, pale inverted linework on black, glowing pale edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

Harpia (C):

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, a gaunt emaciated harpy with a haggard old woman's face, body fully covered in ragged dark feathers, wide ragged wings, iron talons, non-sexualized, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, nude, breasts, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

Fornalheiro (C):

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, a demon blacksmith with an open furnace burning inside its chest, a heavy hammer and long tongs, soot-covered, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

### Família C · Fraude e Traição

Malebranche (C):

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, a lean black-skinned winged demon with bat wings, a leering fanged mouth and a long barbed hooked pitchfork, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

Sentinela Gélida (E):

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, an empty hollow suit of ancient armor made of ice, frost mist leaking from its joints, holding an icy blade and shield, translucent body of smoke and ink, pale inverted linework on black, glowing pale edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

Arpoeiro (C):

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, a winged demon hurling a barbed harpoon attached to a rattling chain, more harpoons on its back, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

Vulto Mascarado (E):

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, an empty floating cloak with several cracked porcelain masks with frozen grins arranged where a face should be, translucent body of smoke and ink, pale inverted linework on black, glowing pale edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

Serpente Ladra (C):

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, a large coiled serpent rearing up, with grasping human hands sprouting along its body, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

Arauto da Mentira (E):

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, a tall gaunt robed figure with a long tarnished trumpet growing in place of its mouth, translucent body of smoke and ink, pale inverted linework on black, glowing pale edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone and ash grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

## 6. Elites

As 16 elites já são geradas na cor de destaque do círculo; a natureza (C ou E) indicada é a proposta inicial para balanceamento.

### Guardiões de Dante

Minos · Círculo 2 (C):

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Minos the infernal judge as a towering demonic king on a stone seat of judgment, crowned, snarling, his enormous serpent tail coiled many times around his body, one clawed hand pointing in condemnation, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and stormy violet, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

Cérbero · Círculo 3 (C):

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Cerberus as a huge three-headed hellhound caked in filthy mud, three snarling heads with red eyes, matted black fur, enormous claws, bloated greedy belly, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and sickly olive green, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 4:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

Pluto · Círculo 4 (C):

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Plutus as a bloated wolf-headed demon standing upright, jaws gaping wide in a deafening howl, swollen belly, clawed hands clutching tarnished coins, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and tarnished oxidized brass, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

Flégias · Círculo 5 (C):

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Phlegyas the furious boatman of the Styx, a wild-haired raging demon standing in a small rotten boat, swinging a heavy oar overhead, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and muddy dark red, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 4:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

Caído das Muralhas · inimigo comum do Círculo 6 (C, Guarda) na v1.1; arte aprovada mantida:

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, a fallen angel guardian of the walls of Dis in blackened ornate armor, great bat-like wings, a long cruel spear, a proud contemptuous face, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and ember orange, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, feathered white wings, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

Medusa · elite do Círculo 6 (C), v1.1:

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Medusa the Gorgon as a terrible gaunt winged woman with a crown of living hissing serpents for hair, a petrifying stare with pale glowing eyes, scaled bronze claws, tattered dark robes covering her body, stone dust crumbling at her feet, non-sexualized, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and ember orange, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, nude, breasts, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

Fúria · escolta da Medusa (C), v1.1 (gerar uma imagem e variar no motor, ou três variações com o mesmo prompt):

```text
2D gothic horror game enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, one of the three Furies from Dante's Inferno, a gaunt blood-stained winged woman with serpents for hair and green water-snakes coiled around her waist, tearing at her own ragged robes with long claws, screaming, tattered bat-like wings, non-sexualized, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and ember orange, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, nude, breasts, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

Minotauro · Círculo 7 (C):

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, the Minotaur as a colossal bull-headed brute, blood-soaked, chained wrists, a massive crude axe, lowered horns ready to charge, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and deep crimson, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

Malacoda · Círculo 8 (C):

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Malacoda, leader of the Malebranche demons, tall black-skinned winged demon with torn bat wings, a long barbed pitchfork, a leering fanged grin, a crude crown of hooks, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and poison green, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

Anteu · Círculo 8 (C):

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, colossal giant Antaeus seen from the waist up, rising from a deep pit, enormous muscular torso, primitive face, one gigantic hand reaching down, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and poison green, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 1:1 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

### Pecados Encarnados

Vertigem · Luxúria (E):

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Vertigo, allegorical personification of lust as a faceless androgynous figure spinning in a vortex, torn veils whipped by wind, many long arms clutching at the air, non-sexualized, translucent body of smoke and ink, pale inverted linework on black, glowing stormy violet edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and stormy violet, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, nude, breasts, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

Voracidade · Gula (C):

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Voracity, allegorical personification of gluttony as a grotesquely swollen figure with a huge toothed mouth gaping open in its belly, tiny head, stuffing scraps into the belly mouth, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and sickly olive green, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

Cobiça · Avareza (C):

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Covetousness, allegorical personification of greed as a long gaunt hunched figure bent over heavy sacks, many arms ending in tarnished brass claws, hoarding coins, sunken greedy eyes, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and tarnished oxidized brass, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

Rancor · Ira (C):

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Rancor, allegorical personification of wrath as a mud-soaked figure in blind fury, biting into its own forearm, veins bulging, teeth bared, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and muddy dark red, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

Cisma · Heresia (E):

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Schism, allegorical personification of heresy as a robed figure split vertically down the middle, its two halves pulling apart with burning edges, each half with its own half-face, translucent body of smoke and ink, pale inverted linework on black, glowing ember orange edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and ember orange, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

Crueldade · Violência (C):

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Cruelty, allegorical personification of violence as a hooded executioner with bare scarred arms, holding meat hooks and red-hot branding irons, blood-stained leather apron, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and deep crimson, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

Engano · Fraude (E):

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Deceit, allegorical personification of fraud inspired by Dante's Geryon, a handsome serene wax human face atop a long scaly serpent body, hairy clawed forelimbs, a scorpion stinger tail, translucent body of smoke and ink, pale inverted linework on black, glowing poison green edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and poison green, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 4:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

Perfídia · Traição (E):

```text
2D gothic horror game elite enemy art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Perfidy, allegorical personification of treachery as a robed figure whose face is half gentle human and half frozen skull of ice, one hand extended in false friendship, the other hiding a dagger behind its back, translucent body of smoke and ink, pale inverted linework on black, glowing icy pale blue edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and icy pale blue, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 2:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

## 7. Chefes

Os chefes ocupam 2 ou 3 posições e usam enquadramento maior (4:3 ou 1:1); a fonte de cada design fica registrada no Martirológio.

Caronte · Antinferno (Dante):

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Charon the demon ferryman of the Acheron, a gaunt ancient old man with a long white beard and wheels of flame around his eyes, standing in a long black rotten boat, raising a heavy oar to strike, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and pale pearl grey, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 4:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

Asmodeu · Luxúria (*Dictionnaire Infernal*):

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Asmodeus the demon king with three heads, a bull head, a crowned human head and a ram head, rooster legs and clawed feet, a serpent tail, holding a lance with a banner, riding a winged infernal dragon, non-sexualized, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and stormy violet, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 4:3 --no gold, halo, parchment background, textured background, vignette, nude, letters, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

Belzebu · Gula (*Dictionnaire Infernal*):

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Beelzebub the Lord of the Flies as a colossal fly-demon with a skull-and-crossbones pattern on its wings, compound eyes, bristling legs and dripping proboscis, surrounded by a dense swarm of flies, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and sickly olive green, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 1:1 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

Mamom · Avareza (ficção do jogo):

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Mammon as a colossal demon made of fused tarnished brass coins and heavy chains, a crown of false brass, many grasping hands emerging from its body, hollow eyes leaking coins, seated on a mound of coins, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and tarnished oxidized brass, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 1:1 --no gold, shiny gold, halo, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

Belfegor · Ira e Acídia (adaptado da tradição):

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Belphegor the demon of sloth as a huge bloated horned demon slumped asleep on a throne of black mud, heavy-lidded eyes half closed, long curved horns, a thick tail, mud slowly swallowing his limbs, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and muddy dark red, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 1:1 --no gold, halo, parchment background, textured background, vignette, toilet, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

Belial · Heresia (*Pseudomonarchia Daemonum*):

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Belial as two disturbingly beautiful fallen angels with cold empty eyes standing together in a chariot of fire, dark ornate robes, black wings, a cracked inverted scepter, flames trailing behind the chariot, translucent body of smoke and ink, pale inverted linework on black, glowing ember orange edges, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and ember orange, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 4:3 --no gold, halo, parchment background, textured background, vignette, white feathered wings, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

Moloque · Violência (Antigo Testamento e tradição):

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Moloch as a colossal hollow bronze idol with a bull head and outstretched arms, a roaring furnace burning inside its open belly, cracked metal glowing red-hot, smoke pouring from its nostrils, no victims shown, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and deep crimson, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 1:1 --no gold, halo, parchment background, textured background, vignette, children, infants, babies, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

Azazel · Fraude (Livro de Enoque e Levítico 16):

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, full body side view, Azazel the fallen Watcher as a tall goat-headed fallen angel with long curved horns, great dark wings, forged weapons and smithing tools hanging from his belt, holding a mirror and a dagger, a cloak of porcelain masks, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and poison green, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing left --ar 4:3 --no gold, halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background, facing right
```

Lúcifer · Traição (Dante):

```text
2D gothic horror game boss art in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, Lucifer as described by Dante, a colossal fallen angel frozen waist-deep in a lake of ice, three faces on one head, the central face red, the right face pale yellowish white, the left face black, six huge bat-like wings beating to create freezing wind, tears and bloody foam running down his three chins, each mouth chewing a struggling sinner, solid heavy flesh, massive black ink shadows, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and icy pale blue, dark blood red, ink splatter on the figure only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no text, front view --ar 4:3 --no gold, halo, parchment background, textured background, vignette, feathered wings, cartoon, anime, glossy, 3D, photorealistic, white background
```

Lúcifer é a exceção à direção do olhar: aparece de frente, como na tradição de Dante, porque está imóvel no gelo.

## 8. Guardiões da vila

Os guardiões são retratos da cabeça à cintura, em 3:4, no mesmo traço, com luz quente de vela no contorno; aparecem nas telas das instalações e no Conselho.

Santo Agostinho · Capela:

```text
Dark gothic graphic novel illustration in the style of Darkest Dungeon character art, hand-inked comic art, Mike Mignola influence, head to waist portrait, Saint Augustine of Hippo as a 4th-century bishop with a grey beard, bishop's mitre and cope, a crozier, an open book, a flaming heart held in one hand, calm wise expression, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of bone, ash grey, black and warm amber candlelight, warm candlelight rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 3:4 --no halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background
```

Santa Mônica · Capela:

```text
Dark gothic graphic novel illustration in the style of Darkest Dungeon character art, hand-inked comic art, Mike Mignola influence, head to waist portrait, Saint Monica as a 4th-century North African widow of mature age, dark widow's veil and plain dark robes, hands joined in prayer, tears on her cheeks, calm sorrowful expression, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of bone, ash grey, black and warm amber candlelight, warm candlelight rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 3:4 --no halo, parchment background, textured background, vignette, rosary, cartoon, anime, glossy, 3D, photorealistic, white background
```

Santo Tomás de Aquino · Biblioteca:

```text
Dark gothic graphic novel illustration in the style of Darkest Dungeon character art, hand-inked comic art, Mike Mignola influence, head to waist portrait, Saint Thomas Aquinas as a stout 13th-century Dominican friar with tonsure, white habit and black cape, a radiant sun emblem on his chest, a large book and a quill, calm wise expression, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of bone, ash grey, black and warm amber candlelight, warm candlelight rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 3:4 --no halo, parchment background, textured background, vignette, letters, cartoon, anime, glossy, 3D, photorealistic, white background
```

Santo Inácio de Loyola · Casa de Exercícios:

```text
Dark gothic graphic novel illustration in the style of Darkest Dungeon character art, hand-inked comic art, Mike Mignola influence, head to waist portrait, Saint Ignatius of Loyola as a 16th-century balding Jesuit priest with a short dark beard and intense eyes, plain black cassock, a book held against his chest, calm piercing expression, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of bone, ash grey, black and warm amber candlelight, warm candlelight rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 3:4 --no halo, parchment background, textured background, vignette, letters, cartoon, anime, glossy, 3D, photorealistic, white background
```

São Cosme e São Damião · Enfermaria:

```text
Dark gothic graphic novel illustration in the style of Darkest Dungeon character art, hand-inked comic art, Mike Mignola influence, head to waist portrait of two figures side by side, Saints Cosmas and Damian as twin 3rd-century physicians, identical faces with short beards, red physician's robes and caps, one holding a medicine box, the other a glass flask, calm caring expressions, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of bone, ash grey, black and warm amber candlelight, warm candlelight rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 4:3 --no halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background
```

Santo Elói · Forja:

```text
Dark gothic graphic novel illustration in the style of Darkest Dungeon character art, hand-inked comic art, Mike Mignola influence, head to waist portrait, Saint Eligius as a 7th-century goldsmith with rolled sleeves and a heavy leather apron over plain robes, a smith's hammer in one hand and a finely wrought chalice in the other, soot on his face, calm focused expression, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of bone, ash grey, black and warm amber forge light, warm firelight rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 3:4 --no halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background
```

Santa Helena · Relicário:

```text
Dark gothic graphic novel illustration in the style of Darkest Dungeon character art, hand-inked comic art, Mike Mignola influence, head to waist portrait, Saint Helena as an elderly 4th-century Roman empress, imperial crown and veil, rich but worn robes, embracing a large wooden cross, calm devout expression, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of bone, ash grey, black and warm amber candlelight, warm candlelight rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 3:4 --no halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background
```

Santa Isabel da Hungria · Despensa:

```text
Dark gothic graphic novel illustration in the style of Darkest Dungeon character art, hand-inked comic art, Mike Mignola influence, head to waist portrait, Saint Elizabeth of Hungary as a young 13th-century queen with a simple crown over a white veil, plain humble robes, holding up her apron full of red roses with loaves of bread among them, calm kind expression, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of bone, ash grey, black and warm amber candlelight, warm candlelight rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 3:4 --no halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background
```

São Francisco de Assis · Jardim:

```text
Dark gothic graphic novel illustration in the style of Darkest Dungeon character art, hand-inked comic art, Mike Mignola influence, head to waist portrait, Saint Francis of Assisi as a thin 13th-century friar with tonsure and short beard, patched brown habit with a rope belt, stigmata wounds on his hands, a small bird perched on one hand, calm gentle expression, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of bone, ash grey, black and warm amber candlelight, warm candlelight rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 3:4 --no halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background
```

São Cristóvão · Portão:

```text
Dark gothic graphic novel illustration in the style of Darkest Dungeon character art, hand-inked comic art, Mike Mignola influence, head to waist portrait, Saint Christopher as a giant bearded man with a tunic hitched up, gripping a tall staff sprouting blossoms, carrying the Christ Child on his shoulder, the Child blessing with a small raised hand, calm steadfast expression, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of bone, ash grey, black and warm amber candlelight, warm candlelight rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 3:4 --no halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background
```

Santa Cecília · Coro (expansão):

```text
Dark gothic graphic novel illustration in the style of Darkest Dungeon character art, hand-inked comic art, Mike Mignola influence, head to waist portrait, Saint Cecilia as a young 3rd-century Roman noblewoman, simple veil and dark robes, a wreath of roses on her head, playing a small portative organ, calm serene expression, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of bone, ash grey, black and warm amber candlelight, warm candlelight rim light, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 3:4 --no halo, parchment background, textured background, vignette, cartoon, anime, glossy, 3D, photorealistic, white background
```

## 9. Cenários dos círculos

Cada círculo tem 4 fundos (3 trechos e o chefe), todos vazios, em 21:9, com uma faixa de chão livre na frente para os personagens e camadas para parallax.

### Antinferno e Limbo

T1 · Campo dos ignavos:

```text
Darkest Dungeon style 2D side-view dungeon background, hand-painted gothic horror, hand-inked comic art, the vestibule of Hell, a barren plain under a starless sky, a tattered empty banner on a pole whipped by the wind, swarms of wasps in the air, a colossal dark gate in the far distance, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and pale pearl grey, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, UI, cartoon, 3D, photorealistic
```

T2 · Margem do Aqueronte:

```text
Darkest Dungeon style 2D side-view dungeon background, hand-painted gothic horror, hand-inked comic art, the dark muddy shore of the river Acheron, mist over black water, dead reeds, a rotting wooden jetty, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and pale pearl grey, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, UI, cartoon, 3D, photorealistic
```

T3 · Castelo do Limbo:

```text
Darkest Dungeon style 2D side-view dungeon background, hand-painted gothic horror, hand-inked comic art, the noble castle of Limbo with seven high walls encircled by a small stream, a pale green meadow under dim pearly light, quiet and melancholic, no fire and no torment, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and pale pearl grey, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, fire, text, UI, cartoon, 3D, photorealistic
```

Chefe · A barca:

```text
Darkest Dungeon style 2D side-view dungeon background, hand-painted gothic horror, hand-inked comic art, the wide river Acheron in eternal night, black water, the far shore lost in fog, a rotten landing stage, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and pale pearl grey, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, boat, text, UI, cartoon, 3D, photorealistic
```

### Círculo 2 · Luxúria

T1 · Penhasco de Minos:

```text
Darkest Dungeon style 2D side-view dungeon background, hand-painted gothic horror, hand-inked comic art, the cliff entrance of the second circle of Hell, a jagged stone seat of judgment carved into the rock, howling darkness beyond, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, UI, cartoon, 3D, photorealistic
```

T2 · Furacão:

```text
Darkest Dungeon style 2D side-view dungeon background, hand-painted gothic horror, hand-inked comic art, an endless howling hurricane over a broken rocky ledge, debris and torn cloth whirling through a dark sky, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, UI, cartoon, 3D, photorealistic
```

T3 · Ruínas varridas pelo vento:

```text
Darkest Dungeon style 2D side-view dungeon background, hand-painted gothic horror, hand-inked comic art, ruins of a gothic cloister battered by eternal wind, arches leaning, torn curtains frozen in motion, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, UI, cartoon, 3D, photorealistic
```

Chefe · Olho da tempestade:

```text
Darkest Dungeon style 2D side-view dungeon background, hand-painted gothic horror, hand-inked comic art, the eye of a vast storm, a calm circular platform of black stone ringed by walls of spinning wind, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and stormy violet, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, UI, cartoon, 3D, photorealistic
```

### Círculo 3 · Gula

T1 · Lamaçal:

```text
Darkest Dungeon style 2D side-view dungeon background, hand-painted gothic horror, hand-inked comic art, a vast swamp of black stinking mud under heavy filthy rain, sunken carts and broken barrels, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and sickly olive green, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, UI, cartoon, 3D, photorealistic
```

T2 · Ruínas sob chuva imunda:

```text
Darkest Dungeon style 2D side-view dungeon background, hand-painted gothic horror, hand-inked comic art, ruined gothic stone arches sinking into black mud under filthy rain, broken columns, scattered bones, sickly fog, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and sickly olive green, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, UI, cartoon, 3D, photorealistic
```

T3 · Covil de Cérbero:

```text
Darkest Dungeon style 2D side-view dungeon background, hand-painted gothic horror, hand-inked comic art, the lair of a monstrous hound, a hollow of mud and gnawed bones before a great rotten archway, heavy chains on the ground, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and sickly olive green, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, UI, cartoon, 3D, photorealistic
```

Chefe · Salão das moscas:

```text
Darkest Dungeon style 2D side-view dungeon background, hand-painted gothic horror, hand-inked comic art, a cavernous rotten banquet hall, collapsed long tables, rotting food, clouds of flies, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and sickly olive green, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, UI, cartoon, 3D, photorealistic
```

### Círculo 4 · Avareza

T1 · Vale dos pesos:

```text
Darkest Dungeon style 2D side-view dungeon background, hand-painted gothic horror, hand-inked comic art, a barren valley where enormous stone and metal weights have carved deep grooves into cracked earth, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and tarnished oxidized brass, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, UI, cartoon, 3D, photorealistic
```

T2 · Montes de moedas:

```text
Darkest Dungeon style 2D side-view dungeon background, hand-painted gothic horror, hand-inked comic art, dunes of tarnished coins and broken treasure chests under a dull sky, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and tarnished oxidized brass, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, shiny gold, text, UI, cartoon, 3D, photorealistic
```

T3 · Rochas de Pluto:

```text
Darkest Dungeon style 2D side-view dungeon background, hand-painted gothic horror, hand-inked comic art, jagged rocks at the edge of the fourth circle of Hell, a crude altar of coins topped by a wolf skull, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and tarnished oxidized brass, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, UI, cartoon, 3D, photorealistic
```

Chefe · Tesouraria de Mamom:

```text
Darkest Dungeon style 2D side-view dungeon background, hand-painted gothic horror, hand-inked comic art, a vast underground treasury vault, towering stacks of tarnished coins, heavy chains hanging from the ceiling, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and tarnished oxidized brass, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, shiny gold, text, UI, cartoon, 3D, photorealistic
```

### Círculo 5 · Ira e Acídia

T1 · Pântano do Estige:

```text
Darkest Dungeon style 2D side-view dungeon background, hand-painted gothic horror, hand-inked comic art, the marsh of the Styx, black bubbling water, dead trees and mud banks under a low red-black sky, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and muddy dark red, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, UI, cartoon, 3D, photorealistic
```

T2 · Barca de Flégias:

```text
Darkest Dungeon style 2D side-view dungeon background, hand-painted gothic horror, hand-inked comic art, the open Styx seen from a narrow muddy causeway, the distant towers of the city of Dis glowing faintly, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and muddy dark red, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, UI, cartoon, 3D, photorealistic
```

T3 · Lodo profundo:

```text
Darkest Dungeon style 2D side-view dungeon background, hand-painted gothic horror, hand-inked comic art, fields of deep sucking mud with half-sunken shapes, bubbles rising, heavy fog, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and muddy dark red, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, UI, cartoon, 3D, photorealistic
```

Chefe · Muralhas de Dite:

```text
Darkest Dungeon style 2D side-view dungeon background, hand-painted gothic horror, hand-inked comic art, the foot of the iron walls of the city of Dis, towering red-hot walls and closed iron gates, the Styx lapping at their base, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and muddy dark red, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, UI, cartoon, 3D, photorealistic
```

### Círculo 6 · Heresia

T1 · Portões de Dite:

```text
Darkest Dungeon style 2D side-view dungeon background, hand-painted gothic horror, hand-inked comic art, the gates of the city of Dis torn open, massive iron doors hanging from broken hinges, burning streets beyond, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and ember orange, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, UI, cartoon, 3D, photorealistic
```

T2 · Campo de túmulos:

```text
Darkest Dungeon style 2D side-view dungeon background, hand-painted gothic horror, hand-inked comic art, an endless field of open stone sarcophagi with flames rising from inside them, heavy lids leaning against their sides, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and ember orange, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, UI, cartoon, 3D, photorealistic
```

T3 · Necrópole em chamas:

```text
Darkest Dungeon style 2D side-view dungeon background, hand-painted gothic horror, hand-inked comic art, a burning necropolis of gothic mausoleums, collapsed domes, embers drifting through the air, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and ember orange, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, UI, cartoon, 3D, photorealistic
```

Chefe · Trono de Belial:

```text
Darkest Dungeon style 2D side-view dungeon background, hand-painted gothic horror, hand-inked comic art, a vast hall of black stone with inverted columns hanging from the ceiling, a throne of fused tombstones, fire glowing through cracks in the floor, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and ember orange, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, crosses, altar, text, UI, cartoon, 3D, photorealistic
```

### Círculo 7 · Violência

T1 · Flegetonte:

```text
Darkest Dungeon style 2D side-view dungeon background, hand-painted gothic horror, hand-inked comic art, the bank of the Phlegethon, a wide river of boiling blood steaming between red rocks, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and deep crimson, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, UI, cartoon, 3D, photorealistic
```

T2 · Selva escura:

```text
Darkest Dungeon style 2D side-view dungeon background, hand-painted gothic horror, hand-inked comic art, a dark twisted forest of gnarled leafless trees with knotted black bark and thorny branches, dense gloom, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and deep crimson, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, hanging, rope, text, UI, cartoon, 3D, photorealistic
```

T3 · Areia ardente:

```text
Darkest Dungeon style 2D side-view dungeon background, hand-painted gothic horror, hand-inked comic art, a desert of burning sand under a slow rain of falling fire flakes, scorched rocks, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and deep crimson, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, UI, cartoon, 3D, photorealistic
```

Chefe · Fornalha de Moloque:

```text
Darkest Dungeon style 2D side-view dungeon background, hand-painted gothic horror, hand-inked comic art, a colossal furnace chamber of bronze and stone, glowing grates in the floor, chains and pipes, thick smoke, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and deep crimson, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, children, text, UI, cartoon, 3D, photorealistic
```

### Círculo 8 · Fraude

T1 · Pontes sobre as valas:

```text
Darkest Dungeon style 2D side-view dungeon background, hand-painted gothic horror, hand-inked comic art, crumbling stone bridges arching over deep concentric ditches in a vast funnel of grey rock, poisonous mist below, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and poison green, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, UI, cartoon, 3D, photorealistic
```

T2 · Vala de piche:

```text
Darkest Dungeon style 2D side-view dungeon background, hand-painted gothic horror, hand-inked comic art, a ditch of boiling black pitch, wooden planks and iron hooks along the bank, bubbles of tar bursting, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and poison green, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, UI, cartoon, 3D, photorealistic
```

T3 · Poço dos Gigantes:

```text
Darkest Dungeon style 2D side-view dungeon background, hand-painted gothic horror, hand-inked comic art, the rim of a colossal pit, gigantic stone pillars like towers looming in fog, a sheer drop into darkness, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and poison green, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, UI, cartoon, 3D, photorealistic
```

Chefe · Oficina de Azazel:

```text
Darkest Dungeon style 2D side-view dungeon background, hand-painted gothic horror, hand-inked comic art, a cluttered infernal workshop of dark forges, cracked mirrors and porcelain masks hanging on the walls, weapons on racks, green flames, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and poison green, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, UI, cartoon, 3D, photorealistic
```

### Círculo 9 · Traição

T1 · Caína:

```text
Darkest Dungeon style 2D side-view dungeon background, hand-painted gothic horror, hand-inked comic art, Caina, a vast frozen lake of grey-blue ice under total darkness, dim shapes frozen beneath the surface, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and icy pale blue, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, UI, cartoon, 3D, photorealistic
```

T2 · Antenora e Ptolomeia:

```plain
Darkest Dungeon style 2D side-view dungeon background, hand-painted gothic horror, hand-inked comic art, jagged ice ridges and frozen crevasses, wind-blown frost, a frozen lake stretching into darknessck, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and icy pale blue, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, UI, cartoon, 3D, photorealistic
```

T3 · Judeca:

```text
Darkest Dungeon style 2D side-view dungeon background, hand-painted gothic horror, hand-inked comic art, Judecca, a perfectly smooth sheet of ice with contorted human figures entirely frozen inside it, freezing mist, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and icy pale blue, distressed print texture, dark vignette --ar 21:9 --no characters standing, creatures, text, UI, cartoon, 3D, photorealistic
```

Chefe · Centro do Inferno:

```text
Darkest Dungeon style 2D side-view dungeon background, hand-painted gothic horror, hand-inked comic art, the frozen center of Hell, an immense lake of ice, a towering wall of ice and darkness in the background where a colossal figure will stand, howling icy wind, empty flat floor strip in the foreground for characters, layered depth for parallax, thick black ink outlines, heavy black shadows, muted desaturated palette of black, bone, ash grey and icy pale blue, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, UI, cartoon, 3D, photorealistic
```

## 10. Cenários da vila e do Pouso

A vila usa o mesmo traço com paleta quente: âmbar de vela, luz de aurora e pequenos toques de ouro. Telas de instalação em 16:9, sem personagens (o guardião entra como retrato sobreposto).

Vista geral do Átrio:

```text
Darkest Dungeon style 2D hand-painted gothic illustration, hand-inked comic art, a small fortified medieval monastery village perched on the rim of an immense dark abyss, stone chapel with a bell tower, cloister, forge smoke, candlelit windows, a pale gold dawn sky above and endless darkness below the cliff, warm amber candlelight and pale dawn gold, palette of black, bone, ash grey and warm amber with small touches of flat gold, thick black ink outlines, heavy black shadows, distressed print texture, dark vignette --ar 16:9 --no characters, people, text, UI, cartoon, 3D, photorealistic
```

Capela:

```text
Darkest Dungeon style 2D hand-painted gothic illustration, hand-inked comic art, interior of a small gothic stone chapel, a simple altar with a crucifix, rows of votive candles, tall stained glass windows with empty dark panes waiting to be filled, kneelers, warm amber candlelight and pale dawn gold, palette of black, bone, ash grey and warm amber with small touches of flat gold, thick black ink outlines, heavy black shadows, distressed print texture, dark vignette --ar 16:9 --no characters, people, text, UI, cartoon, 3D, photorealistic
```

Enfermaria:

```text
Darkest Dungeon style 2D hand-painted gothic illustration, hand-inked comic art, a vaulted medieval monastic infirmary, three simple wooden beds with linen, shelves of herbs, flasks and bandages, a mortar and pestle on a table, warm amber candlelight and pale dawn gold, palette of black, bone, ash grey and warm amber with small touches of flat gold, thick black ink outlines, heavy black shadows, distressed print texture, dark vignette --ar 16:9 --no characters, people, text, UI, cartoon, 3D, photorealistic
```

Despensa:

```text
Darkest Dungeon style 2D hand-painted gothic illustration, hand-inked comic art, a medieval monastery storeroom, loaves of bread on wooden racks, bundles of candles, small vials of holy water, rolls of bandages, sacks of grain, hanging herbs, warm amber candlelight and pale dawn gold, palette of black, bone, ash grey and warm amber with small touches of flat gold, thick black ink outlines, heavy black shadows, distressed print texture, dark vignette --ar 16:9 --no characters, people, text, UI, cartoon, 3D, photorealistic
```

Portão:

```text
Darkest Dungeon style 2D hand-painted gothic illustration, hand-inked comic art, a massive fortified stone gate at the edge of the village opening onto a steep stairway descending into the abyss, torches on the walls, a tall flowering staff leaning by the door, warm amber candlelight against the cold darkness below, palette of black, bone, ash grey and warm amber with small touches of flat gold, thick black ink outlines, heavy black shadows, distressed print texture, dark vignette --ar 16:9 --no characters, people, text, UI, cartoon, 3D, photorealistic
```

Casa de Exercícios:

```text
Darkest Dungeon style 2D hand-painted gothic illustration, hand-inked comic art, a sparse stone retreat house for spiritual exercises, a simple wooden table with an open book and a candle, a plain crucifix on the wall, a training yard with wooden practice weapons visible through an arch, warm amber candlelight and pale dawn gold, palette of black, bone, ash grey and warm amber with small touches of flat gold, thick black ink outlines, heavy black shadows, distressed print texture, dark vignette --ar 16:9 --no characters, people, text, UI, cartoon, 3D, photorealistic
```

Forja:

```text
Darkest Dungeon style 2D hand-painted gothic illustration, hand-inked comic art, a medieval monastery forge and goldsmith workshop, glowing furnace, anvil and hammers, chalices and armor pieces on the workbench, sparks in the air, warm amber forge light, palette of black, bone, ash grey and warm amber with small touches of flat gold, thick black ink outlines, heavy black shadows, distressed print texture, dark vignette --ar 16:9 --no characters, people, text, UI, cartoon, 3D, photorealistic
```

Biblioteca:

```text
Darkest Dungeon style 2D hand-painted gothic illustration, hand-inked comic art, a vaulted medieval monastic library and scriptorium, tall shelves of chained books, a lectern with an open bestiary, scrolls and inkwells, warm amber candlelight and pale dawn gold, palette of black, bone, ash grey and warm amber with small touches of flat gold, thick black ink outlines, heavy black shadows, distressed print texture, dark vignette --ar 16:9 --no characters, people, readable text, letters, UI, cartoon, 3D, photorealistic
```

Relicário:

```text
Darkest Dungeon style 2D hand-painted gothic illustration, hand-inked comic art, a small vaulted reliquary chamber, ornate reliquary caskets in wall niches, a large wooden cross fragment behind an iron grille, candles and incense smoke, warm amber candlelight and pale dawn gold, palette of black, bone, ash grey and warm amber with small touches of flat gold, thick black ink outlines, heavy black shadows, distressed print texture, dark vignette --ar 16:9 --no characters, people, text, UI, cartoon, 3D, photorealistic
```

Jardim e claustro:

```text
Darkest Dungeon style 2D hand-painted gothic illustration, hand-inked comic art, a quiet medieval cloister garden, a stone well at the center, herbs and a few flowers, birds on the arches, soft dawn light, palette of black, bone, ash grey and warm amber with small touches of flat gold and muted green, thick black ink outlines, heavy black shadows, distressed print texture, dark vignette --ar 16:9 --no characters, people, text, UI, cartoon, 3D, photorealistic
```

Carmelo:

```text
Darkest Dungeon style 2D hand-painted gothic illustration, hand-inked comic art, a newly built small Carmelite convent within the village, plain whitewashed stone walls, a simple bell gable, a wooden cross over the door, humble and austere, warm amber candlelight and pale dawn gold, palette of black, bone, ash grey and warm amber with small touches of flat gold, thick black ink outlines, heavy black shadows, distressed print texture, dark vignette --ar 16:9 --no characters, people, text, UI, cartoon, 3D, photorealistic
```

Pouso (acampamento na expedição):

```text
Darkest Dungeon style 2D side-view camp background, hand-painted gothic horror, hand-inked comic art, a small campfire in a sheltered hollow of dark rock deep in Hell, a few candles placed on a stone, bedrolls, the surrounding darkness pressing in, warm firelight in a small circle against cold shadow, empty flat floor strip in the foreground for characters, palette of black, bone, ash grey and warm amber, distressed print texture, dark vignette --ar 21:9 --no characters, people, creatures, text, UI, cartoon, 3D, photorealistic
```

## 10A. Vila: edifícios externos e fundo (v1.1)

A vista geral da vila é montada no Godot a partir de um fundo vazio e de cada edifício gerado isolado; as telas de interior da seção 10 continuam como estão.

**Regras de consistência**

- Mesma câmera em todos os edifícios: vista três-quartos frontal, levemente de cima.
- Mesma luz: velas âmbar nas janelas e luz suave vinda da esquerda.
- Cada edifício sobre um pequeno pedaço de chão plano, em fundo liso cinza-claro, para recorte.
- Escala: a porta da Capela é a referência de altura humana; os demais edifícios são ajustados a ela no motor.
- Níveis de melhoria aparecem como **camadas** sobre o edifício-base (andaimes, estandartes e lanternas, sino ou vitral), não como imagens novas.
- As Moradas do Carmelo aparecem acendendo, uma a uma, as **sete janelas** do Carmelo, efeito feito no motor.

**Modelo de prompt de edifício**

Troque `[EDIFÍCIO]` pela descrição da tabela:

```text
Darkest Dungeon style 2D hand-painted gothic illustration, hand-inked comic art, Mike Mignola influence, a single isolated [EDIFÍCIO] of a small medieval monastery village, three-quarter front view from slightly above, standing on a small patch of flat ground, warm amber candlelight in the windows and soft light from the left, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and warm amber with small touches of flat gold, ink texture on the building only, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal --ar 1:1 --no people, characters, sky, background scenery, other buildings, parchment background, textured background, vignette, text, cartoon, 3D, photorealistic
```

| Edifício | \[EDIFÍCIO\] |
| --- | --- |
| Capela | small gothic stone chapel with a bell tower, tall stained glass windows and an arched wooden door |
| Enfermaria | long low stone infirmary hall with a tiled roof, herb garden beds along its side and a small cross over the door |
| Despensa | sturdy stone storehouse with a wide wooden loading door, barrels and grain sacks stacked outside |
| Portão | massive fortified stone gatehouse with iron-bound double doors and wall torches, a stone stair descending behind it into darkness |
| Casa de Exercícios | sparse stone retreat house with a small walled training yard and a plain banner on a pole |
| Forja | stone forge with a large chimney and an open front showing an anvil and a glowing furnace |
| Biblioteca | tall narrow stone library tower with lancet windows and a small scriptorium annex |
| Relicário | small domed stone reliquary chapel with an iron grille door |
| Jardim e claustro | square cloister arcade around a small garden with a stone well at its center |
| Carmelo | plain whitewashed Carmelite convent with a simple bell gable, a wooden cross over the door and seven small windows in a row |

**Fundo da vila (sem edifícios)**

```text
Darkest Dungeon style 2D hand-painted gothic illustration, hand-inked comic art, Mike Mignola influence, the empty rocky plateau of a medieval monastery village site on the rim of an immense dark abyss, three-quarter view from slightly above, flat open ground with dirt paths connecting empty building plots, low dry-stone walls, a few bare trees, a pale gold dawn sky above, endless darkness and rising mist below the cliff edge, warm amber and pale gold light, palette of black, bone, ash grey and warm amber with small touches of flat gold, thick black ink outlines, heavy black shadows, distressed print texture, soft vignette --ar 16:9 --no buildings, houses, chapel, towers, people, characters, text, UI, cartoon, 3D, photorealistic
```

Camada separada do céu, para movimento lento das nuvens:

```text
Darkest Dungeon style 2D hand-painted gothic sky, hand-inked comic art, a pale gold dawn sky with long slow drifting clouds over a dark horizon, palette of bone, ash grey, pale gold and warm amber, thick black ink outlines on the clouds, distressed print texture --ar 21:9 --no land, buildings, people, text, cartoon, 3D, photorealistic
```

**Camadas de melhoria (genéricas, usadas em qualquer edifício)**

Andaimes (nível 1):

```text
Darkest Dungeon style 2D hand-painted gothic illustration, hand-inked comic art, rough wooden scaffolding with ropes and planks, built to lean against a stone wall, three-quarter front view from slightly above, palette of black, bone, ash grey and warm amber, thick irregular black ink outlines, isolated on a plain flat solid light grey background --ar 1:1 --no building, wall, people, text, cartoon, 3D, photorealistic
```

Estandartes e lanternas (nível 2):

```text
Darkest Dungeon style 2D hand-painted gothic illustration, hand-inked comic art, a set of two hanging cloth banners with simple crosses and three iron lanterns with candlelight, three-quarter front view, palette of black, bone, ash grey, cinnabar red and warm amber, thick irregular black ink outlines, isolated on a plain flat solid light grey background --ar 1:1 --no building, people, text, letters, cartoon, 3D, photorealistic
```

Sino e vitral (nível 3):

```text
Darkest Dungeon style 2D hand-painted gothic illustration, hand-inked comic art, a small bronze bell hanging in a wooden yoke and a separate small round stained glass window with muted jewel colors and thick black lead lines, three-quarter front view, palette of black, bone, ash grey, warm amber and small touches of flat gold, thick irregular black ink outlines, isolated on a plain flat solid light grey background --ar 1:1 --no building, people, text, letters, cartoon, 3D, photorealistic
```

**Animações ambientais (feitas no Godot, sem novas imagens):** luz pulsante nos vitrais e janelas, sino oscilando, fumaça e fagulhas da Forja, portas do Portão abrindo na partida da expedição, estandarte ondulando, vegetação do Jardim balançando, névoa do abismo e cinzas subindo, nuvens do céu em movimento lento.

## 11. Pranchas narrativas

As cenas da história são pranchas ilustradas em 16:9 com texto sobreposto pelo jogo; cada prancha pode ter várias figuras porque é imagem única, não asset de combate.

### Figuras da história

O Peregrino (retrato):

```text
Dark gothic graphic novel illustration in the style of Darkest Dungeon character art, hand-inked comic art, Mike Mignola influence, head to waist portrait, the Pilgrim, a weary 14th-century man in his thirties with an unkempt beard and haunted sunken eyes, worn hooded pilgrim's cloak, a scallop shell badge, gripping a pilgrim's staff, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of bone, ash grey, black and dark blood red, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 3:4 --no halo, parchment background, textured background, vignette, halo, gold, cartoon, anime, smile, glossy, 3D, photorealistic, white background
```

Prólogo · O Peregrino perdido na selva escura:

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, a lone 14th-century pilgrim lost in a dark tangled forest at night, gnarled trees closing in, three beasts watching from the shadows, a leopard, a lion and a she-wolf, a faint hill glowing far away, cinematic composition, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and dark blood red, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

Nossa Senhora (prólogo):

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, reverent iconographic image of the Virgin Mary, veiled, in a deep ultramarine mantle over a dark red dress, gazing downward with grieving compassion, hands open in intercession, surrounded by a soft flat gold radiance, cinematic composition, thick irregular black ink outlines, deep black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ultramarine blue and flat gold, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, cartoon, anime, glossy, 3D, photorealistic, sensual
```

Santa Luzia (mensageira):

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, Saint Lucy as a young 4th-century Sicilian martyr, simple veil and robes, holding a burning oil lamp and a martyr's palm, a small dish with two eyes at her side as in traditional iconography, flat gold halo, descending a stair of light into darkness to deliver a message, cinematic composition, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and flat gold, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

O Anjo da Guarda (guia):

```text
Dark gothic graphic novel illustration in the style of Darkest Dungeon character art, hand-inked comic art, Mike Mignola influence, full body side view, the Guardian Angel of the pilgrim as a tall solemn androgynous angel in a plain white robe, large feathered white wings folded, holding a lantern, calm watchful expression, thick irregular black ink outlines, heavy black shadows engulfing part of the figure, angular blocky shading, muted desaturated colors with painterly flat fills, palette of white, bone, ash grey and flat gold, isolated on a plain flat solid light grey background, clean cutout silhouette for background removal, no scenery, no text, facing right --ar 2:3 --no halo, parchment background, textured background, vignette, cartoon, anime, cherub, baby, glossy, 3D, photorealistic, white background
```

Arcanjo Rafael prende Asmodeu (Círculo 2):

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, the archangel Raphael as a traveler-angel with white wings, pilgrim's staff and a fish at his side, binding a three-headed demon king with glowing chains while smoke rises from a burning fish heart and liver in a brazier, cinematic composition, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey, stormy violet, white and flat gold, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

São Gabriel abre Dite (saída do Círculo 5):

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, Saint Gabriel the Archangel as the heavenly messenger, tall and solemn with great white wings and a flat gold halo, crossing the Styx dry-footed, touching the iron gates of the city of Dis with a slender wand so they burst open, the Furies and Medusa recoiling on the towers above, cinematic composition, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey, muddy dark red, white and flat gold, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

São Miguel no confronto final:

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, Saint Michael the Archangel in dark Roman-style armor with great white wings and a flat gold halo, holding back a colossal three-faced bat-winged Lucifer frozen in ice with a raised spear and shield, a blinding white light pushing the darkness away, cinematic composition, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, icy pale blue, white and flat gold, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

### Encontros com as almas de Dante

Francesca e Paolo (Círculo 2):

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, two damned lovers, Francesca and Paolo, wrapped in torn grey shrouds, clinging to each other as they are swept endlessly through a howling dark hurricane, sorrowful faces, non-sexual, cinematic composition, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and stormy violet, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, nudity, cartoon, anime, glossy, 3D, photorealistic
```

Ciacco (Círculo 3):

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, Ciacco, a bloated damned glutton lying in black filthy mud under heavy freezing rain, lifting his head to speak, eyes rolling, cinematic composition, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and sickly olive green, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

Filippo Argenti (Círculo 5):

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, Filippo Argenti, a furious damned man covered in mud rising from the Styx, grabbing at a boat, then turning his teeth on his own arm in rage, other wrathful souls tearing at him, cinematic composition, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and muddy dark red, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

Farinata (Círculo 6):

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, Farinata degli Uberti, a proud damned nobleman rising from the waist out of a burning open tomb, chin lifted in disdain as if he scorned Hell itself, flames licking around him, cinematic composition, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and ember orange, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

Brunetto Latini (Círculo 7):

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, Brunetto Latini, an old damned scholar with a scorched burnt face walking on burning sand under a slow rain of fire, reaching out to grasp a passing traveler's robe in recognition, cinematic composition, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and deep crimson, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

Ulisses (Círculo 8):

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, a single tall twin-tipped flame drifting in a dark rocky ditch, inside it the suggestion of the faces of Ulysses and Diomedes, the flame bending as if speaking, a ghostly ship on a black sea painted in the smoke above, cinematic composition, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and poison green, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

Ugolino (Círculo 9):

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, Count Ugolino, a gaunt damned man frozen to the neck in a hole in the ice, gnawing savagely on the skull of another frozen sinner beside him, lifting his head from the grim meal to speak, blood on his beard, cinematic composition, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey, icy pale blue and dark blood red, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, children, cartoon, anime, glossy, 3D, photorealistic
```

### Desfecho e finais

Rever as estrelas (saída do Inferno):

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, a company of saints with flat gold halos and a pale pilgrim emerging from a narrow rocky passage into the open night, a vast sky full of stars above them, the darkness of Hell left behind, cinematic composition, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey, deep night blue and flat gold, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, cartoon, anime, glossy, 3D, photorealistic
```

Personagens recorrentes do leito e do final (usar a primeira imagem aprovada de cada um como referência de personagem nas seguintes): **o Peregrino no leito**, o mesmo homem do retrato `R01` do Prólogo, mais magro e pálido; **a mulher idosa**, véu escuro simples, mãos enrugadas, contas de oração de madeira (séc. XIV: contas de oração, não terço); **o frei**, franciscano idoso, hábito marrom, cordão de três nós, tonsura, estola roxa para o sacramento. Pranchas 16:9, PNG 1920 × 1080; pastas `assets/characters/narrative/deathbed/` e `assets/characters/narrative/ending/` (decisão D-198).

Final · O ato de contrição (`F02`):

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, the dying pale bearded man in the wooden bed with his eyes open at last, tears running down his face, his weak hands joined around a small wooden cross, the elderly Franciscan friar with a purple stole leaning close to listen, the elderly woman weeping quietly behind with her prayer beads, the candle stub glowing, a faint warm light beginning to fill the room, cinematic composition, the lower third of the image darker for subtitles, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and warm amber, distressed print texture, soft vignette --ar 16:9 --no text, letters, UI, halo, demons, cartoon, anime, glossy, 3D, photorealistic
```

Final · A extrema-unção (`F03`):

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, the elderly Franciscan friar with a purple stole tracing a small cross of holy oil on the forehead of the dying man in the wooden bed, a small open wooden box of oils on the stool, the elderly woman kneeling in prayer with wooden prayer beads, the candle light steady and calm now, reverent and peaceful, cinematic composition, the lower third of the image darker for subtitles, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and warm amber, distressed print texture, soft vignette --ar 16:9 --no text, letters, UI, halo, gold, cartoon, anime, glossy, 3D, photorealistic
```

Final · A boa morte (`F04`):

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, a dying 14th-century man at peace in a simple wooden bed with a small cross in his hands and a faint smile of relief, Saint Joseph as an elderly bearded carpenter with a staff blossoming with lilies and a flat gold halo standing gently at the head of the bed, the Virgin Mary veiled in a deep ultramarine mantle with a flat gold halo standing beside him with open compassionate hands, both seen only by the viewer, the friar and the elderly woman praying unaware in the warm candlelight, cinematic composition, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey, ultramarine blue, warm amber and flat gold, distressed print texture, soft vignette --ar 16:9 --no text, letters, UI, demons, cartoon, anime, glossy, 3D, photorealistic, sensual
```

Final · O Purgatório (o motor usa uma, duas ou três variações conforme os Sufrágios) (`F05`):

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, in the spirit of Gustave Dore engravings of Dante's Purgatorio, a soul in a plain white robe climbing the terraces of a vast mountain rising from the sea at dawn, other humble souls praying along the stone ledges, a gentle wall of purifying flame near the summit, a calm angel at a gate of three steps, hopeful and serene, cinematic composition, the lower third of the image darker for subtitles, thick irregular black ink outlines, angular blocky shading, crosshatched engraving texture, muted desaturated colors with painterly flat fills, palette of bone, white, ash grey, pale dawn blue and flat gold, distressed print texture, soft vignette --ar 16:9 --no text, letters, UI, demons, torture, cartoon, anime, glossy, 3D, photorealistic
```

Final · O Paraíso (Deus aparece só como luz; nenhuma figura no centro da rosa) (`F06`):

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, inspired by the celestial rose of Dante's Paradiso, a soul in a white robe rising into an immense rose of light made of countless tiers of small haloed figures, among them a company of saints with flat gold halos welcoming him, the center of the rose an overwhelming flat gold light with no figure inside it, awe and peace, cinematic composition, thick irregular black ink outlines, angular blocky shading, muted desaturated colors with painterly flat fills, palette of white, bone, pale blue and flat gold, distressed print texture, soft vignette --ar 16:9 --no text, letters, UI, demons, face of God, old bearded god, cartoon, anime, glossy, 3D, photorealistic
```

### Leito de morte

O leito (Prólogo e vinhetas) (`P16`):

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, a poor 14th-century room at night, a gaunt pale bearded man lying gravely ill in a simple wooden bed breathing with difficulty, a single candle burning on a stool beside the bed, an elderly woman in a plain dark veil kneeling at the bedside praying with wooden prayer beads, a small wooden cross on the bare wall, long shadows, quiet and heavy atmosphere, cinematic composition, the lower third of the image darker for subtitles, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and warm amber candlelight, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, halo, gold, rosary with crucifix pendant, modern objects, cartoon, anime, glossy, 3D, photorealistic
```

A vela e a mão (Prólogo) (`P17`):

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, extreme close-up of a guttering candle flame on a stool beside a bed at night and a thin pale man's hand lying limp on a rough linen sheet, wax dripping, the flame bending as if from a weak breath, intimate cinematic framing, the lower third of the image darker for subtitles, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and warm amber candlelight, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, halo, gold, blood, cartoon, anime, glossy, 3D, photorealistic
```

Vinheta do leito: a vela baixa (vinhetas 1 a 6; o motor varia a altura da vela e a luz) (`D01`):

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, the same poor 14th-century room at night, the gravely ill pale bearded man in the wooden bed, eyes closed, the candle beside him burned halfway down, the elderly woman in a dark veil asleep in a chair with wooden prayer beads still in her hands, deep stillness, cinematic composition, the lower third of the image darker for subtitles, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and dim warm amber, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, halo, gold, cartoon, anime, glossy, 3D, photorealistic
```

Vinheta do leito: chamam o frei (vinhetas 7 e 8) (`D02`):

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, the same poor 14th-century room at night, the elderly woman in a dark veil standing at the open door speaking urgently into the darkness outside, the dying pale bearded man in the bed behind her, the candle almost burned down, cold night air stirring the flame, cinematic composition, the lower third of the image darker for subtitles, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey and dim warm amber, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, halo, gold, cartoon, anime, glossy, 3D, photorealistic
```

Vinheta do leito: o frei chega (vinheta 9) (`D03`):

```text
Dark gothic illustrated story panel in the style of Darkest Dungeon, hand-inked comic art, Mike Mignola influence, an elderly 14th-century Franciscan friar with tonsure, brown habit and a rope belt with three knots, entering the poor room through the doorway at night carrying a small lantern and a little wooden box for the holy oils, a purple stole over his shoulders, the elderly woman stepping aside, the dying man in the bed, the candle a stub, cinematic composition, the lower third of the image darker for subtitles, thick irregular black ink outlines, heavy black shadows, angular blocky shading, muted desaturated colors with painterly flat fills, palette of black, bone, ash grey, brown and warm amber, distressed print texture, dark vignette --ar 16:9 --no text, letters, UI, halo, gold, cartoon, anime, glossy, 3D, photorealistic
```

## 12. Interface

A interface segue o manuscrito iluminado em pedra escura e pergaminho, com o ouro reservado ao que é sagrado ou ativo; as barras e números são desenhados pelo motor, e só ícones, molduras e vitrais são gerados por IA.

**Elementos de combate**

| Elemento | Representação |
| --- | --- |
| Molduras | Pedra escura entalhada com rendilhado gótico e painéis de pergaminho |
| Auréola | Dourada e acesa com Fervor disponível; escurecida com a desolação; eclipsada na Noite Escura |
| Fervor | 6 chamas de vela douradas |
| Lume | Vela grande no topo da tela, que se consome |
| Vida | Barra vermelho-sangue escuro |
| Desolação | Barra de pergaminho coberta progressivamente por tinta preta |
| Intenções inimigas | Ícones de tinta acima de cada inimigo |

**Tipografia**

- Títulos: [Uncial Antiqua](https://fonts.google.com/specimen/Uncial+Antiqua) (licença OFL).
- Textos e números: [EB Garamond](https://fonts.google.com/specimen/EB+Garamond) (licença OFL).
- Corpo de texto com no mínimo 16 px na tela do celular; uncial só em títulos curtos, por legibilidade.

**Modelo de ícone**

Troque `[OBJETO]` e `[COR]` pelo valor de cada linha das tabelas abaixo:

```text
2D gothic horror game UI icon in the style of Darkest Dungeon, hand-inked comic art, [OBJETO], centered, bold readable silhouette, thick irregular black ink outlines, angular blocky shading, muted desaturated flat colors, palette of black, bone, ash grey and [COR], distressed print texture, isolated on a plain flat solid light grey background, no text --ar 1:1 --no letters, numbers, cartoon, anime, glossy, 3D, photorealistic, white background
```

**Ícones de recursos e provisões**

| Ícone | \[OBJETO\] | \[COR\] |
| --- | --- | --- |
| Fervor | a single candle flame | flat gold |
| Lume | a tall wax candle half burned with dripping wax | warm amber |
| Esmolas | a small leather alms purse with a few coins spilling out | cinnabar red |
| Sufrágios | a small votive oil lamp with a steady flame | flat gold |
| Pão | a round loaf of bread with a cross scored on top | warm amber |
| Vela | a single short candle on a small iron holder | warm amber |
| Água Benta | a small glass ampoule of water with a tiny cross on the stopper | pale blue |
| Ataduras | a roll of linen bandages | bone white |
| Incenso | a swinging thurible trailing smoke | warm amber |

**Ícones de intenção inimiga (nunca ouro)**

| Ícone | \[OBJETO\] | \[COR\] |
| --- | --- | --- |
| Ataque | a jagged black sword | dark blood red |
| Corrupção | a staring bloodshot eye dripping ink | dark blood red |
| Deslocamento | a curved claw-shaped arrow | dark blood red |
| Defesa | a cracked demonic shield | dark blood red |
| Invocação | a curled horn blowing black smoke | dark blood red |

**Ícones de estado e dano**

| Ícone | \[OBJETO\] | \[COR\] |
| --- | --- | --- |
| Consolação | a radiant halo disk with short rays | flat gold |
| Noite Escura | a halo disk eclipsed by a black moon shape | ash grey |
| Desolação | a spreading ink blot over a parchment scrap | black |
| Purificação | a small flame inside a halo ring | flat gold |
| Ferida | a single heavy drop of blood | dark blood red |
| Corrupção | twisting black veins | sickly olive green |
| Atordoado | a spiral of ink with small stars | bone white |
| Marcado | three deep claw marks | dark blood red |
| Dano Golpe | a clenched mailed fist | dark blood red |
| Dano Exorcismo | a radiant cross of light | flat gold |

**Ícones do mapa de nós**

| Nó | \[OBJETO\] | \[COR\] |
| --- | --- | --- |
| Combate | two crossed swords | dark blood red |
| Elite | a horned demon skull | dark blood red |
| Tentação | an apple coiled by a serpent | dark blood red |
| Encontro | a hooded lantern with a pale ghostly flame | pale pearl grey |
| Relíquia oculta | a small ornate reliquary casket | flat gold |
| Pouso | a small campfire | warm amber |
| Chefe | a crown of horns | dark blood red |

**Moldura de painel**

```text
2D gothic horror game UI frame in the style of Darkest Dungeon, hand-inked comic art, an ornate border of dark carved stone with gothic tracery and small pointed arches surrounding an empty aged parchment panel, symmetrical, thick irregular black ink outlines, muted desaturated colors, palette of black, bone, ash grey and small cinnabar red accents, distressed print texture, isolated on a plain flat solid light grey background, no text --ar 16:9 --no letters, numbers, cartoon, glossy, 3D, photorealistic, white background
```

**Mapa de nós (fundo)**

```text
2D gothic horror game map background in the style of Darkest Dungeon, hand-inked comic art, an aged parchment sheet in the manner of a medieval illuminated manuscript showing a winding path descending through rocky terrain into darkness, empty spaces for node markers, stained edges, faint marginal drawings of demons, palette of black, bone, ash grey and [COR DO CÍRCULO], distressed print texture --ar 16:9 --no text, letters, numbers, cartoon, glossy, 3D, photorealistic
```

**Vitral de conquista (modelo)**

Troque `[CENA]` pelo marco conquistado; exemplo para Asmodeu derrotado: `the archangel Raphael binding a three-headed demon king with chains`.

```text
A gothic stained glass window panel with a pointed arch top, thick black lead lines in the style of Darkest Dungeon hand-inked comic art, depicting [CENA], jewel-toned but muted glass colors, flat gold halos, distressed print texture, isolated on a plain flat solid light grey background --ar 1:2 --no text, letters, cartoon, glossy, 3D, photorealistic
```

## 13. Fontes de referência

As referências abaixo orientam o design e devem ser registradas no Martirológio quando inspirarem um elemento do jogo.

| Referência | Uso no projeto |
| --- | --- |
| [Darkest Dungeon](https://www.darkestdungeon.com/darkest-dungeon/) | Referência principal de traço, composição de combate e interface |
| Mike Mignola (*Hellboy*) | Massas de preto chapado e silhuetas fortes |
| Dante Alighieri, *Inferno* | Geografia dos círculos, guardiões, Encontros, Lúcifer |
| *Dictionnaire Infernal* (Collin de Plancy, 1818; gravuras de Louis Le Breton, 1863; domínio público) | Asmodeu e Belzebu |
| *Pseudomonarchia Daemonum* (Johann Weyer, 1577) | Belial |
| Peter Binsfeld (1589) | Associação entre príncipes demoníacos e pecados |
| Livro de Enoque e Levítico 16 | Azazel |
| Livro de Tobias | Asmodeu e o arcanjo Rafael |
| Prudêncio, *Psicomaquia* | Personificação dos pecados |
| Xilogravuras da *Ars Moriendi* (séc. XV) | Disputa entre anjos e demônios pela alma; textura de impressão |
| Iconografia tradicional dos santos | Trajes e atributos de cada santo e guardião |
| [Uncial Antiqua](https://fonts.google.com/specimen/Uncial+Antiqua) e [EB Garamond](https://fonts.google.com/specimen/EB+Garamond) | Tipografia |

Datas e atribuições das obras históricas vêm do conhecimento geral e não foram verificadas em fonte nesta versão.
