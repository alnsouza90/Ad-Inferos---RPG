# Ad Inferos em HOLD · perspectivas de Alan (24/11/2026)

**Decisão de Alan:** o Ad Inferos está em **HOLD**. A fatia vertical mostrou que o jogo está longe das expectativas. Alan vai começar **um jogo novo, "Inferno"**, num repositório novo, a partir da experiência daqui:
- o mesmo conceito do Inferno de Dante;
- **classes comuns** (templário, freira etc.) em vez de santos;
- GDD novo, história nova, foco em celular, **sem engenharia demais**;
- Godot, com arte no PixelLab.

**Nada deve ser feito no Ad Inferos** até Alan tirar o HOLD.

**Onde o trabalho parou:**
- o PR #104 (prompts de arte da revisão do M2 e animações dos santos com os props) ficou aberto, sem merge;
- Alan tinha enviado 21 imagens do 01 · cenários dos trechos (Meta AI), que não foram montadas nem guardadas no repositório.

As perspectivas abaixo valem como **direção para o jogo novo**, exceto o que é específico dos santos.

---

## Texto de Alan (sem edição)

> Redsegin para simplificação de mecanica geral identificar mecancicas complicas e overengenerring e vamos simplficiar as coisas, um exemplo? retirar os botões de consolação, intercessão e firmeza, serao habilidade de santos especificos apenas ( são bento pode ter firmeza como uma habilidade selecionavel por exemplo, vamos ver isso po "classe" e colocar nos que fizerem sentido;apenas 3 habilidades selecionadas mais o milagre e o botão de troca de posição,  vamos retirar o lume do jogo oque sera mostrado em uma barra central vai ser o fervor da companhia (o MP compartilhado do grupo), serão apenas 3 inimigos por luta vamos retirar uma posição, chefes sem escolta (vamos aumentar vida, força e habilidades dos chefes para tornalos dificeis), sobre os players começamos com os 3 santos, mas a cada circulo ao inves de chegar um santo especifico o jogador pode escolher quem convocar olhando a ficha de cada um no portão e chamando ele.
>
> UI e HUD: redesign do HUD um hud que seja limpo e visual na paleta preto e cinza mesmo os detalhes ficam apenas nas molduras de arquitetura gostica (pensei em um detalhe de cada lado um anjo de um lado um gargula do outro (esquerda direita) mas coisa simples que não chame tanta atenção. detalhe, sobre funcionalidades lado esquerdo ficha do personagem selecionado e retrato pequeno tirado do persongaem do jogo, as habilidades são mostradas com botoes grandes ao lado do retrato do personagem em quadrados limpos e facilmente identificaveis pelo icone e cores 3 habilidades (das 6 apenas 3 selecionadas) Milagre e troca de posição ( os icones devem ser comuns para todos os personagem temso que rastraer os tipos de habilidade mas por exemplo: ataque fisico, exorcismo, buff, cura,defesa e milagre), o centro do HUDsera uma areaa multifuncional se clicar na mini ficha do personagem a esquerda abre a ficha mais completa no HUD do centro, se clicar em uma habilidade do personagem abre os detalhes dessa habilidade range, dano, efeitos, alem de 2 botoes no centro que tambem sobrepoem o hud central minimpa e inventarios / alforje, o canto da direita é destinado a ficha dos inimigos clicando no inimigo vc tem a ficha deste inimigo o retrato dele tirado do personagem do jogo e os detalhes como intenção e status efeitos negativos e positivos.
>
> Sobre mecanica de movimento e cenarios como dito anteriormente quero algo fluido e organico se anda,se luta, pouso tudo em cenarios que vão se completando como fases de um jogo sidescroller, as ações são feitas pelas bifurcações subir em uma escada, entrar em uma porta mas seguindo o caminho ele volta a ser linear e organico o pouso e a vigialia normalmente ficaram depois de uma porta ou de uma caverna de acordo com o contexto do cenario. Outra coisa IMPORTANTISSIMA os cenarios de nó por nó serão planejados, nada aleatorio vamos montar todos os cenarios um por um nó por nó para garantir essa continuidade de ambientação a unica coisa que pode ser sorteada nas seed são as lutas qual inimigo estara no cenario mas o cenario estara ali pronto. do cenario que temos hoje o unico que salva pra mim é o pouso e o juri de minos ( interno e a parede externa, na parede externa nós temos que ter uma transição de quando começa essa parede. os outros ambientes vamos refazer via pixelllab um por um garantindo a mesma identidade visual e sera planejado cada um dos 3 trechos de cada um dos circulos, o nó de entrada no circulo, os nós de luta (inimigos e dos pecados encarnados) podem ser comuns e se repetir algumas vezes por isso precisam ser mais genericos, o cenario do guardião, cenario das almas, da reliquia das tentações, do chefe, do pouso e da vigilia serão especiais e nao poderam ser repetidos. ( exemplo ao tomar caminho A que é um campo mais aberto podemos ter a sequencia de 3 nós com o mesmo fundo por exemplo e vamos alternar algumas outras camadas mas tudo sera planejado um por um... quando tiver uma porta no nó 5 tem que ter um edificio no fundo dessa porp e o proximo nó tem que ser planejado pra ser dentro desse edificio) ainda sobre necario o elemnto seguir em frente pode ser somente avançar a tela como side sidescrooller ou em alguns momentos adentrar portas que estão  em vista lateral aperece a companhia entrando na porta e carrega o proximo nó dentro do ambiente.
>
> Sobre o cenario, falta elementos animados na cena de acrodo com o contexto lógico, por exemplo velas dentro de aposentos animadas pelo motor, sombras de almas se movendo ao fundo, redemoinho de vendo ao fundo se movendo, almas sendo torturadas ou pedindo por clemencia, isso vai fazer o cenario ser vivo. cenas com prfundidade 4, 5 camadas de profundidade não necessariamente com muita informação mas coisas simples que gerar profundidade. Chefes, guardioes e pecados, ter apresentações antes da luta por exemplo ao entrar no tribunal de Minos ele pode estar condenando uma alma e ela é levada por sombras e some gritando, os chefes soa grandes devem ter peso e tremer a tela, Asmodeus chegando deve ser como um gigante tremendo a terra,a pecado Vertigem pode estar se divertindo com uma alma e a joga par longe antes de começar a luta o pecado Gula pode estar comendo alguma coisa nojenta com a boca da barriga, cerbero pode estar roendo ossos de alguem. tela escurece, musica densa, peso, e tempo a luta nao precisa ser corrida.
>
> Sobre a vila mudança total a vila tambem serão cenarios assim como todo resto do jogo, ou seja se chega ao portao e se anda na vila os nós vão ser os predios e locais de obervação como a praça da estatua de nossa senhora, podemos colocar elementos animados tambem como velas, santos andando no ceu la no fundo podermos colocar talvez ao longe uma coluna de luz com anjos ao redor (trono do senhor) a vila é uma pedacinho do céu a cidade de Deus. dito isso vamos ter que fazer todos os cenarios que compoe a vila tambem com todas as camadas e parallax, ceu animado e props de animação. O jogadro vai entrando nos nós e ao entrar no edificio se entra no interior do edificil, ao entrar no portao e partir vamos para o mapa do inferno

---

## Lições do Ad Inferos para levar ao jogo novo (resumo do agente)

1. **Protótipo antes de especificação.** O Ad Inferos especificou muito antes de jogar. No jogo novo, a "fatia da diversão" vem primeiro: um corredor e uma luta com o tratamento completo, jogados no celular antes de escrever regras longas.
2. **Menos sistemas, mais sensação.** Lume, Consolação, Intercessão, Firmeza, desolação por rodada e escoltas somaram complexidade, e a diversão não acompanhou.
3. **Arte com a referência aprovada primeiro.** Gerar peças antes de aprovar o estilo e a montagem custou retrabalho. Em cenário de camadas, cada prompt descreve só a sua camada (D-526).
4. **Cenários planejados nó por nó**, nunca montados ao acaso.
5. **Celular primeiro:** letras e alvos de toque grandes desde o primeiro protótipo (metas do playtest: texto de 16 px, números de 22 px e alvos de 60 × 60 na tela de 960 × 540).
6. **O que funcionou e pode voltar:**
   - o núcleo de regras separado da tela, testado sem tela;
   - os dados em CSV;
   - a memória do projeto em `docs/memory`;
   - o merge só com CI verde e "aprovado";
   - o APK automático a cada merge;
   - o fluxo do PixelLab, com o custo antes.
7. **O que Alan aprovou e pode servir de referência visual:** o Pouso e o Júri de Minos (interior e parede externa); a vila, os guardiões, o Mapa do Inferno e os medalhões estão neste repositório, para consulta.
