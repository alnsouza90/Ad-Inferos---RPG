# Novo rumo · arte em pixel gerada no PixelLab

Versão 1.0 · 14/11/2026 · consultor convidado · **para o agente que implementa (Opus 5.5) e para Alan**

**Decisão de Alan (14/11/2026, no chat):** toda a arte do jogo passa a ser **pixel art gerada no PixelLab**. Motivo dado por ele: "fica muito mais simples". Esta decisão ainda **não está** em `docs/memory/decisions.md`; registrar é o passo 1 abaixo.

Leia junto: `guia-pixellab.md` (como gerar), `05-pixel-art.md` (análise e impacto), `prompts-pixel-m2.md` (descrições de cada peça), `00-rumo.md` (o rumo de design, que **continua valendo**), `04-respostas-de-alan.md` (tudo o que Alan aprovou).

## 1. O que muda e o que não muda

| Não muda | Muda |
| --- | --- |
| Todas as regras (`game/core/`), dados, simulador, testes, salvamento | Toda a arte de personagens, inimigos, cenários, vila, ícones e interface |
| O design aprovado nesta consultoria (Interceder, Domínio, Súplica, Laços, peso do golpe, luta em poses etc.) | A base da apresentação: o jogo passa a ser desenhado numa **tela interna de 960 × 540**, ampliada 2× sem suavizar |
| A Bíblia de Arte como **ideia** (quatro matérias, ouro só da graça, arco/círculo/quebrado, duas luzes, eclipse, capela às escuras) | A técnica: contorno e sombra em pixel, paleta única, fio de luz de 1 pixel |
| A interface `CombatantView` (ADR-0007) | Os quadros vêm do PixelLab, não de vídeo; some o recorte de fundo cinza |
| "Luta em poses, caminhada fluida" | A decisão de **santos em vídeo** e das **210 poses avulsas** de inimigos (`03-animacao.md` §14) deixa de valer |

## 2. O piloto: o que já existe e o que ele mostrou

Arquivos em `docs/fable/piloto-pixel/` (originais do PixelLab, 256 × 256, fundo transparente) e prévias em `docs/fable/previas/pixellab_*`.

| Peça | Arquivo | Estado |
| --- | --- | --- |
| Jorge parado | `jorge_parado.png` | Feito por Alan; **aprovado como base de estilo** |
| Teresinha parada | `teresinha_parada.png` | Feito por Alan; serve |
| Bento parado | `bento_v1.png` | **Aprovado por Alan** |
| Bento parado animado (9 quadros) | `bento_idle.png` | **Aprovado por Alan**; um risco solto no 3º quadro, a limpar |
| Bento andar (9) | `bento_walk.png` | Consistente; passo discreto. Aguarda Alan |
| Bento ações (9) | `bento_acoes.png` | **Em parte:** preparar, joelho e caído servem; no golpe surgiu um **arco branco** (rastro) que não foi pedido |
| Teresinha ações (9) | `tere_acoes.png` | **Em parte:** poses boas; no golpe recebido surgiram **riscos de sangue**, proibidos em santo |
| Diabo de Lodo | `mud_devil.png` | Muito bom; fiel ao desenho em tinta. Aguarda Alan |
| Sombra do Desejo | `shade.png` | Muito bom; manteve o contorno claro dos Espirituais. Aguarda Alan |
| Fundo do Círculo 2 (688 × 384) | `fundo_c2.png` | Muito bom. É menor que a tela; na prévia foi **espelhado nas bordas**, o que é provisório |
| Kit de interface | `ui_kit.png` | **Não serve como está:** saiu um painel genérico, com a palavra "QUEST" e um retrato de elmo. O ferro com rebites está certo; as formas, não |
| Tela de combate montada | `previas/pixellab_piloto_combate_x2.png` | Composta por programa (`ferramentas/piloto_pixellab_mock.py`); a interface ali é desenhada por código |
| Paleta | `paleta.json` | 54 cores: 40 tiradas dos três santos e 14 reservadas da Bíblia de Arte |

**Custo do piloto até aqui:** 69 gerações (10 do Bento, 1 do parado, 58 do lote). Saldo: cerca de 1.930 de 2.000.

**O que o piloto ensinou (detalhe em `guia-pixellab.md`):**

1. O personagem **se mantém** de um quadro para o outro. É o que faltava ao vídeo.
2. Um clipe com **oito poses diferentes** inventa efeitos e perde objetos. As ações devem ser **clipes curtos, uma ação por clipe**, proibindo efeitos no texto.
3. Arte em tinta que já existe serve de **referência de desenho**: os dois inimigos saíram fiéis. Os 20 comuns, 16 elites e 8 chefes não precisam ser reinventados, só redesenhados.
4. A ferramenta de interface precisa receber as **formas** (peças), ou devolve um painel genérico.
5. Nenhum cenário passa de 688 × 384. Um fundo de 960 de largura tem de ser **montado**.

## 3. Especificação técnica (proposta; vira ADR)

| Item | Valor |
| --- | --- |
| Tela interna | **960 × 540**, ampliada por 2 inteiro, filtro "mais próximo". Altura fixa em 540; a largura cresce em aparelhos mais compridos |
| Campo de batalha | Os 360 de cima; painel nos 180 de baixo (mesma proporção de hoje, D-347) |
| Linha do chão | y = 338 (como na prévia) |
| Santo | Tela de 256 × 256; figura de **230** de altura (mulheres: a mesma tela, figura como vier; a regra dos 93% é revista com Alan) |
| Inimigo comum | Tela de 256 × 256 |
| Elite e chefe | Tela de 256 × 256 é o teto da animação. Chefe maior que isso: **partes** (corpo e cabeça como objetos separados) ou ampliação inteira 2× só do chefe. Decidir com Alan em Asmodeu |
| Animação | 8 quadros por clipe, ~8 quadros por segundo; 9 arquivos por clipe (o primeiro é o sprite de origem) |
| Paleta | `piloto-pixel/paleta.json`, passada em **toda** geração; ouro `#D9A520` reservado à graça |
| Formato | PNG com transparência, sem meio-tom. Tão pequenos que **dispensam o Git LFS** e a compressão com perda |
| Regras de pixel | Um só tamanho de pixel por tela; nada girado nem esticado fora da grade; deslocamento em pixel inteiro; efeitos e deformações feitos **dentro** da tela de 960 × 540 |
| Texto | A decidir com Alan no aparelho: fonte de pixel, ou texto na resolução cheia por cima (ver `05-pixel-art.md` §4.5). A Pirata One (D-258) não se lê em corpo pequeno nesta grade |

## 4. O que fazer no M2, em ordem

Um passo por PR, como sempre. "Novo" é tarefa a acrescentar ao backlog. As tarefas de regra do `00-rumo.md` §5 (peso do golpe, simulação, T38 com o Domínio) **continuam**; aqui está só o que a troca de arte muda.

| Passo | Tarefa | O que fazer | Pronto quando |
| --- | --- | --- | --- |
| 1 | Novo · só documentos | Registrar em `decisions.md`: a decisão da arte em pixel no PixelLab; as aprovações desta consultoria (`04-respostas-de-alan.md`); o que deixa de valer (D-194 em parte, D-197, D-222 a D-255, D-257, D-258, D-347, D-348, santos em vídeo). Atualizar `progress.md` e `open-questions.md`. Reescrever `backlog/m2.md` com os passos abaixo | Alan aprova o PR |
| 2 | Novo · ADR | "Apresentação em pixel art": tela interna de 960 × 540, ampliação inteira, paleta única, origem dos quadros no PixelLab, guarda da chave fora do repositório | Alan aprova |
| 3 | Novo · acesso | Configurar o PixelLab para as sessões do agente (ver `guia-pixellab.md` §1). A chave vai como segredo do ambiente, **nunca** no repositório | O agente lista a galeria e lê o saldo |
| 4 | Novo · ferramenta de entrada | `tools/art/`: importar um clipe do PixelLab (9 PNGs) para `CharacterFrames`; conferir tamanho, grade e paleta; alinhar os pés; apagar pixels soltos. Substitui a maior parte de `process_frames.py` | Os três santos e os dois inimigos do piloto entram no jogo por ela, com teste |
| 5 | T36 (refazer) | Tela de combate e caminhada em 960 × 540: campo, linha do chão, posições, painel. Teste de leiaute atualizado | Alan vê no APK os cinco personagens do piloto parados |
| 6 | T52 (refeita) · santos | Jorge, Bento e Teresinha: parado, andar e **uma ação por clipe** (preparar, golpear, defender, golpe recebido, queda), pela receita do guia. Na luta, poses seguras; na caminhada, o ciclo inteiro | Alan aprova cada clipe |
| 7 | T52 (refeita) · inimigos | Os 7 da família A, depois Minos, Vertigem e Asmodeu, redesenhados a partir da arte em tinta (referência) e do estilo de Jorge; parado e ações | Alan aprova cada um |
| 8 | T53 (refeita) · cenários | Círculo 2: três trechos, arena do chefe, Pouso e Vigília, montados em camadas; objetos do corredor | Alan aprova no APK |
| 9 | T44 e T53 · interface | Peças da "capela às escuras" (arco, lanceta em 3 estados, rosácea, porta-velas, moldura quebrada, alforje, painel), ícones e fonte | Alan aprova no APK |
| 10 | Efeitos | Estampa dos santos e tinta dos inimigos; auréola (disco, coberta, eclipse, clareira) | Alan aprova |
| 11 | T49 · vila | As 4 instalações do M2 de frente, a praça, céu e chão | Como no backlog |
| 12 | T51 · Prólogo | 16 pranchas e 5 retratos em pixel detalhado | Como no backlog |
| 13 | T55 a T57 | Como no backlog | Critério de saída do M2 |

**Ordem com as tarefas de regra:** os passos 1 a 5 vêm antes de tudo. Depois, as tarefas de regra do `00-rumo.md` e as de arte daqui podem alternar; nenhuma depende da outra.

## 5. Regras de trabalho com Alan (ditas por ele nesta conversa)

1. **Nenhuma peça é gerada sem ele saber o custo e autorizar.** Para lotes, mande a lista com o custo total antes.
2. **Ele aprova peça por peça.** Mande a imagem (e o GIF, se for animação) e espere o "aprovado" ou a troca de rota.
3. Mostre sempre **lado a lado** com o que já foi aprovado, para ele julgar a coerência.
4. Fale em português simples; ele não é técnico.
5. Custos em **gerações**, com o saldo depois de cada lote.

## 6. O que fazer com a arte antiga

- Fica onde está (repositório e Drive "Art Source") como **referência de desenho**. Não apagar.
- `docs/art/art-direction.md`, as folhas de prompts e `asset-pipeline.md` ficam desatualizados. **Só mudam com pedido explícito de Alan** (`CLAUDE.md` §10). Proponha a ele uma direção de arte nova, curta, baseada em `biblia-de-arte.md` e neste arquivo.
- Os vídeos do Wan 3 e o stop motion da Vertigem saem do jogo quando o substituto em pixel for aprovado, não antes.

## 7. Pendências de decisão para Alan

1. A regra das mulheres a 93% da altura (D-259): Teresinha veio com 233, igual a Jorge. Manter assim ou pedir menor?
2. Texto: fonte de pixel ou texto em resolução cheia.
3. Chefes maiores que 256: por partes, ou ampliados.
4. O fundo: dois painéis emendados ou peças soltas montadas pelo motor.
5. A origem das Esmolas (pendente desde antes) e as demais decisões de `00-rumo.md` §4.

## 8. Texto pronto para abrir a próxima sessão

```text
Leia o CLAUDE.md e a memória do projeto. Depois leia, nesta ordem, em docs/fable/:
06-rumo-pixel.md, guia-pixellab.md, 00-rumo.md e 04-respostas-de-alan.md.
Decidi mudar toda a arte para pixel art gerada no PixelLab.
Execute o passo 1 de 06-rumo-pixel.md §4 (só documentos): registre as decisões,
atualize a memória e reescreva o backlog do M2. Antes de escrever, me diga em
5 linhas o que vai fazer. Não gere nenhuma arte sem me mandar o custo e pedir permissão.
```
