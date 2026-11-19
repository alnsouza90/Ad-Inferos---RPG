# Revisão criativa · diversão e imersão (19/11/2026)

Complemento do plano de revisão (`2026-11-19-plano-de-revisao.md`). O plano corrige o que o playtest apontou; este documento olha o jogo de fora, com olho crítico, e propõe **o que precisa mudar para ser divertido e imersivo no celular**. **Estado: proposta para Alan.** Nada muda no jogo antes da aprovação.

---

## 1. Diagnóstico crítico: por que o jogo está monótono

O jogo tem uma base forte:
- um tema único (santos no Inferno de Dante);
- a arte de pixel gótica aprovada;
- regras táticas com profundidade (Fervor, Lume, desolação, intenções dos inimigos, posições).

O problema não é o conteúdo; é **como o jogador sente o que acontece**. Seis causas:

### 1.1 O jogo é mudo
Não há nenhum som: nem música, nem passos, nem golpe, nem sino, nem respiração do Inferno. Em jogos como *Darkest Dungeon* e *Blasphemous*, **metade da imersão é som**: o narrador, o gemido do inimigo, o estalo da tocha. **É a maior falha do jogo hoje**, e a mais barata de corrigir em relação ao ganho.

### 1.2 Nada reage ao toque
O jogador toca e espera. Faltam vários retornos:
- a vibração;
- o brilho;
- o som de seleção;
- o número que salta;
- a câmera que se move.

Por isso o playtest diz "não sei em quem cliquei" e "não sinto o peso". **Cada toque precisa de resposta em menos de 100 ms.**

### 1.3 O ritmo é parado
- A caminhada é passiva e não pede decisão.
- O "Entrar" interrompe a caminhada, a troca de tela quebra o fluxo, e a luta tem muitos toques pequenos (escolher, confirmar, encerrar turno).
- O jogo alterna entre **"espera" e "menu"**, sem momentos de tensão e alívio.

### 1.4 O jogador não sente a ameaça
O Lume (a luz) e a desolação são as tensões centrais do jogo, mas são **números e barras**.
- Quando o Lume cai, o mundo devia escurecer de verdade: a tela fecha nas bordas, o som abafa, o inimigo fica mais nítido que os santos.
- Quando um santo entra em desolação alta, ele devia **parecer** abatido: a postura, a auréola, um tremor.

Hoje o perigo se lê, mas não se sente.

### 1.5 As recompensas não acontecem
Hoje as conquistas passam sem cerimônia:
- vencer uma luta;
- subir de nível;
- achar uma relíquia;
- consagrar um Pouso;
- ver um santo novo chegar.

Tudo vira linha de texto ou número. Em jogos de campanha longa, **a recompensa é um momento**: pausa, luz, som, a coisa ganha aparecendo grande. Sem isso, o jogador não sente progresso. O playtest notou: "não fica claro quando sobe de nível".

### 1.6 Os santos não têm voz nem presença
Os santos são o coração do jogo, mas em campo são figuras que esperam ordem.
- Eles não reagem: ao golpe que levam, ao companheiro que cai, à vitória, à escuridão.
- Em *Darkest Dungeon*, as falas curtas dos heróis ("barks") e as posturas de estresse fazem o jogador se apegar.

Aqui o equivalente seria rezar, encorajar, lembrar uma frase da própria vida. **As falas são texto narrativo: Alan escreve; o agente só monta o sistema.**

---

## 2. Pilares de diversão e imersão (para aprovar)

Somam-se aos pilares do playtest (celular primeiro, mundo contínuo, HUD único, cada toque responde, golpes com peso, arte de estampa, variedade com intenção).

| Pilar | Em uma frase | Como se mede no playtest |
| --- | --- | --- |
| **O Inferno respira** | Nada fica parado: fogo tremula, poeira cai, almas se movem, o vento do círculo sopra; o som ambiente nunca some | Alan nunca vê uma tela "congelada" |
| **A luz é a vida** | O Lume é sentido no mundo: menos luz = mais escuro, mais estreito, mais abafado | Sem olhar o número, Alan sabe se o Lume está baixo |
| **Cada conquista é um momento** | Vitória, nível, relíquia, Pouso, santo novo: pausa, luz, som, coisa grande na tela | Alan percebe toda subida de nível sem procurar |
| **Os santos estão vivos** | Reagem, falam pouco e bem, mostram o estado no corpo | Alan sabe como cada santo "está" sem abrir a ficha |
| **Um polegar, uma decisão** | Cada toque é uma escolha que importa; nada de toques de confirmação vazios | Menos toques por turno que hoje, sem perder a profundidade |

---

## 3. Propostas, por momento do jogo

**Marcação:**
- **(M)**: feito pelo motor, sem arte nova.
- **(A)**: precisa de arte de Alan ou do PixelLab.
- **(S)**: precisa de som.
- **(T)**: precisa de texto de Alan.

### 3.1 Combate, o coração do jogo

1. **Câmera viva (M).** Zoom leve no santo que age; close no golpe (C02); recuo no milagre; tremor pelo peso (C03).
2. **Intenção legível de longe (M).** O ícone da intenção do inimigo grande, sobre a cabeça, com o alvo marcado por uma linha de tinta até o santo ameaçado. O jogador decide olhando o campo, não um painel.
3. **Turno sem burocracia (M).**
   - Tocar no santo, tocar na habilidade e tocar no alvo: a ação acontece.
   - O turno fecha sozinho (D2).
   - Segurar o dedo sobre qualquer coisa mostra o detalhe; tocar faz.
   - Sem "confirmar".
4. **Números que contam a história (M).** Dano grande, com o tamanho pelo peso. Cura em âmbar subindo, desolação em violeta escorrendo. "Crítico" não existe (o combate é determinístico), mas o **golpe que derruba** ganha uma pausa e um som próprio.
5. **O inimigo também atua (M, A).**
   - Antes de agir, o inimigo faz um gesto de preparo (os quadros "preparar" existem para a Família A).
   - O ataque espiritual (C10) tem uma tinta violeta que corre do inimigo até o santo, com um sussurro.
   - Isso também resolve a impressão de que "o inimigo não ataca" (B01, B02).
6. **Santos que reagem (M, T).** Golpe recebido: recuo e, às vezes, uma fala curta. Companheiro caído: os outros olham. Desolação alta: postura curvada e auréola apagando (as auréolas de estado já existem: coberta, eclipse).
7. **Fim de luta com cerimônia (M, A, S).** A última estocada em câmera lenta; o silêncio; o sino; a caixa de ganhos abrindo (C11); a companhia volta a andar (C12).

### 3.2 Caminhada: transformar a espera em expectativa

1. **O corredor tem coisas (M, A).**
   - Velas que se acendem ao passar, almas ao fundo, chuva na Gula, vento na Luxúria.
   - O som do passo muda com o chão.
2. **O Lume no mundo (M).** A vinheta escura fecha conforme o Lume cai; a lanterna do grupo tremula mais.
3. **Ameaça anunciada (M, S).** Antes de uma luta, a música baixa, um som grave e uma sombra passando ao fundo. A luta começa no corredor (D3), sem corte.
4. **Bifurcação como decisão (M).** As duas portas ou caminhos mostram uma pista do que há adiante (o ícone do nó já aparece hoje), e os santos olham para elas.
5. **Os Vestígios (M3/M4, D-262):** quando entrarem, serão o grande atrativo da caminhada.

### 3.3 Pouso e Vigília: o respiro

1. **A fogueira como lugar (M, A).** Os santos sentados (as poses de Pouso existem), o fogo crepitando, o rosto deles na luz.
2. **Tela de atividades por santo (P02)**, em letra grande; cada escolha com uma animação curta do santo fazendo (rezar, cuidar, vigiar).
3. **Conversa à fogueira (T).** Uma fala curta de um santo por Pouso, escrita por Alan. É o momento de apego.
4. **Vigília solene (M, S).** Os santos ajoelhados, a lanterna, o silêncio antes do chefe, o coração batendo.

### 3.4 Vila: o lar entre as descidas

1. **A vila viva (M).** Fumaça das chaminés, sinos nas horas litúrgicas, os guardiões respirando (balanço leve), luz nas janelas à noite.
2. **A volta para casa (M, S).** Após a expedição, uma cena curta: a companhia sobe a escada do abismo até o Portão, o sino toca, e a semana vira com um efeito visível no céu.
3. **Anúncios como eventos (M, T).** Subida de nível, santo novo e prédio liberado aparecem na volta, um a um, com São Cristóvão ou o guardião falando.

### 3.5 Celular: conforto acima de tudo

1. **Alvos de toque de no mínimo 60 × 60 na tela interna** e textos de 16 a 22 px (metas do plano).
2. **Segurar para ver o detalhe, tocar para fazer**, em todo o jogo, igual. Uma regra só, aprendida uma vez.
3. **Vibração** curta nos toques válidos e dupla nos inválidos (S01).
4. **Polegares:** as ações da luta na parte de baixo; a informação no alto.
5. **Velocidade da animação** nas opções (já existe) e **"acelerar segurando"** nas cenas.

---

## 4. Método: a "fatia da diversão"

**Proposta central desta revisão.** Em vez de espalhar melhorias pouco a pouco pelo jogo inteiro, fazer primeiro **um pedaço pequeno com o tratamento completo**:

> Um corredor do Trecho 1 + uma luta comum (Diabo de Lodo e Moscardo) + a volta à caminhada, já com:
> - o HUD novo;
> - som (ambiente, passos, golpes, sino);
> - câmera;
> - peso;
> - vibração;
> - reação dos santos;
> - cerimônia de vitória;
> - letras grandes.

Alan joga só isso no celular, e aprova ou corrige **a sensação**. Depois, o mesmo tratamento é replicado no resto (o combate inteiro, o Pouso, o chefe, a vila).

**Por quê:** é a forma mais barata de acertar o "gosto" do jogo. Mudar a sensação depois de aplicada em tudo custa o triplo, e foi o que aconteceu com as telas da vila e com a arte no M2 (lições aprendidas, T68).

**Onde entra:** como **F1.5**, logo depois das correções (F1) e antes das fases F2, F3 e F4. Ela antecipa um pedaço de cada uma, e essas fases passam a "replicar o que foi aprovado".

---

## 5. O que precisa de Alan

| O quê | Para quê | Quando |
| --- | --- | --- |
| **Falas curtas dos santos** (5 a 10 por santo: golpe recebido, companheiro caído, vitória, escuridão, desolação alta, fogueira) | Santos vivos (§1.6, §3.1, §3.3) | Antes da F1.5 (2 ou 3 por santo bastam para o protótipo) |
| **Direção de som:** referências do que você imagina (canto gregoriano, órgão, silêncio, sinos, coro?) | ADR de áudio e escolha dos bancos de som livres | Antes da F1.5 |
| **Aprovar os pilares do §2** | Critério de todo o redesign | Agora |
| **Arte nova** listada no plano (§6) e aqui: velas, almas e partículas por círculo | Mundo que respira | Ao longo das fases |

---

## 6. Perguntas

1. Aprova os **cinco pilares** do §2?
2. Aprova a **fatia da diversão (F1.5)**: um corredor e uma luta com o tratamento completo antes de replicar?
3. **Falas dos santos (barks):** quer que o jogo tenha? Se sim, você escreve as primeiras (2 ou 3 por santo) para o protótipo. As falas seguem o `writing-guide.md`: curtas, com a origem marcada (Escritura, tradição ou criação do jogo).
4. **Som:** que referências você tem em mente? Recomendo partir de **canto gregoriano e sinos para a vila**, **coro grave e silêncio tenso na descida**, e **órgão e percussão no chefe**, todos de bancos de uso livre, com a lista de licenças.
5. **"Segurar para ver, tocar para fazer"** como regra única de toque em todo o jogo?
6. **Volta para casa:** a cena curta da companhia subindo a escada até o Portão, com o sino, a cada fim de expedição? Pode ser pulada com um toque.
