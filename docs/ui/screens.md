# Fluxo de telas e leiaute

Versão 1.0 · base: GDD v1.1 e Direção de Arte v1.1 · resolução de referência 1920×1080, paisagem

## 1. Princípios

- Celular em paisagem, segurado com as duas mãos: ações principais ao alcance dos polegares (cantos inferiores).
- Toque mínimo de 48 dp; nada importante a menos de 64 px da borda (áreas de recorte da câmera).
- Uma decisão por vez. Toda ação tem pré-visualização antes de confirmar; não há Desfazer.
- Texto ao jogador sempre vindo dos dados (`name_pt`, `desc_pt`), nunca escrito na cena.
- Molduras e texturas de pergaminho são da interface, não da arte de personagem (Direção de Arte).

## 2. Mapa de telas

```text
Abertura (boot) → Título ─┬─ Continuar ──────────────► (último ponto salvo)
                          ├─ Novo jogo ─► Prólogo ───► Vila
                          └─ Opções

Vila ─┬─ Planejar a semana ─► Mapa da expedição ─┬─ Combate ─► Recompensa ─┐
      ├─ Instalações (cada uma uma tela)         ├─ Evento narrativo ──────┤
      ├─ Martirológio / Arquivo                  ├─ Pouso / Vigília ───────┤
      ├─ Trilha do Purgatório                    └─ Chefe ─► Flashback ─► Conselho ─► Vila
      └─ Retiro (avança a semana)                     ◄──── volta ao mapa ┘

Qualquer tela ─► Pausa (Opções, Salvar e sair)
```

No M0 só existem: **Abertura → Arena de teste → Combate → Resultado**, com um seletor de encontro e semente.

No M1 (protótipo de trecho):

```text
Abertura → Título ─┬─ Continuar ───► (último ponto salvo)
                   └─ Novo trecho ─► Caminhada ─┬─ Combate ─► Recompensa ─┐
                                                ├─ Tentação ──────────────┤
                                                ├─ Relíquia ──────────────┤
                                                │     ◄──── volta ao corredor ┘
                                                └─ Pouso ─► (emboscada?) ─► Resumo do trecho
```

A arena do M0 continua acessível só na versão de desenvolvimento (botão no título). "Novo trecho" com um trecho salvo pede um segundo toque (o salvo é apagado). A preparação mostra a equipe e o kit e tem "Partir". A relíquia encontrada abre um painel para escolher quem a carrega (D-146) ou guardá-la na mochila; o fim do trecho mostra um resumo com Esmolas, santos, relíquias e virtudes (D-324).

## 3. Combate (tela principal do jogo)

```text
┌──────────────────────────────────────────────────────────────────────────┐
│ [Pausa]   Rodada 3              Fervor ◆◆◆◆◇◇ (4/6)           [Velocidade]│ ← barra superior
│                                                                          │
│   [intenção] [intenção] [intenção]        [intenção] [intenção] [int.]   │ ← intenções inimigas
│                                                                          │
│   ┌─────┐   ┌─────┐   ┌─────┐   │   ┌─────┐   ┌─────┐   ┌─────┐   ┌─────┐ │
│   │  3  │   │  2  │   │  1  │   │   │  1  │   │  2  │   │  3  │   │  4  │ │ ← personagens
│   │Teres│   │Bento│   │Jorge│   │   │Diabo│   │Escar│   │Mosc.│   │Sombr│ │
│   └─────┘   └─────┘   └─────┘   │   └─────┘   └─────┘   └─────┘   └─────┘ │
│   vida/desol vida/desol vida/des    vida       vida      vida      vida    │ ← barras e condições
│                                                                          │
│ [retrato do santo ativo]  [Hab1] [Hab2] [Hab3] [Hab4]  [Milagre] [Trocar]│ ← barra de ações
│ [Provisões]                                              [Encerrar turno]│
└──────────────────────────────────────────────────────────────────────────┘
```

- Santos à esquerda, com a posição 1 (vanguarda) junto ao centro; inimigos à direita, posição 1 junto ao centro.
- **Intenções:** ícone (`intent_icon`) + número previsto + linha até a posição-alvo ao tocar.
- **Condições:** no máximo 3 ícones por personagem, depois "+N"; tocar abre a lista com descrições.
- **Auréola:** desenhada pelo motor sobre a cabeça do santo; brilho e estado mudam com a desolação (`ADR-0008`). A desolação também aparece como número na barra.
- **Barra de ações:** do santo selecionado. Habilidades indisponíveis ficam em cinza com o motivo ("Posição errada", "Fervor insuficiente", "Noite Escura"). Custo em Fervor no canto do botão.
- **Seleção:** tocar no santo para escolher quem age → tocar na habilidade → as posições-alvo válidas acendem → tocar no alvo mostra a pré-visualização (dano final, condições, desolação) → tocar de novo confirma.
- Santo que já agiu fica esmaecido. "Encerrar turno" pede confirmação se ainda houver santo sem agir.
- **Velocidade:** 1×, 2× e instantâneo (preferência salva em `settings.json`).

## 4. Caminhada da expedição (corredor) e mini-mapa

Regras em `specs/expedition.md` §2.3 (D-207, D-121; caminhada interativa do M2: D-158, D-178, D-184 a D-186).

```text
┌──────────────────────────────────────────────────────────────────────────┐
│ [Pausa] Lume ▮▮▮▮▮▮▮▮▯▯ 80   Esmolas 70 (+140 não garantidas)  [Mini-mapa]│ ← barra superior
│                                                                          │
│  (fundo, meio e frente com parallax)        ┌──────┐                     │
│                                             │ tenda│                     │
│      Teres  Bento  Jorge  ►                 └──────┘          ┌────┐  ══►│ ← porta (desvio) e caminho reto
│  ═══════════════════ chão (y ≈ 900) ═════════════════════════ └────┘     │
│ [Provisões]            ‹‹ segurar: voltar │ segurar: andar ››   [Entrar] │
└──────────────────────────────────────────────────────────────────────────┘
```

- **Andar:** segurar o dedo na metade direita do corredor anda para a frente; na esquerda, para trás; soltar para (D-178). A câmera acompanha a equipe; as camadas do cenário se movem em velocidades diferentes (parallax). Animação de andar dos santos com esqueleto 2D (D-176). A velocidade segue a preferência de animação.
- **Conteúdo do nó no caminho:** ao chegar, a equipe para e aparecem os botões do conteúdo, perto dele: tenda com **Entrar** e **Passar ao largo** (com o custo à vista), baú ou relicário com **Abrir** (animação por quadros, fechado e aberto), alma com **Falar**. Inimigos chegam sozinhos e o combate começa, com a animação de chegada (D-185).
- **Bifurcação:** as entradas ficam no trecho final do corredor; parado diante de uma, o painel mostra o ícone e o nome do tipo de nó (nunca só o ícone) e o que se sabe do conteúdo; o botão **Entrar** confirma.
- **Barra superior:** Lume (barra e número), Esmolas garantidas e não garantidas, botão do mini-mapa. Botão de provisões no canto inferior esquerdo, com a equipe parada.
- **Luz:** o cenário escurece com o Lume baixo (só aparência).
- **Mini-mapa:** sobreposto ao corredor, camadas da esquerda para a direita, ícone do tipo de todo nó, ligações, caminho já feito e posição atual. Só consulta; fecha com um toque fora ou no botão.
- **Arte:** cenário em 4 camadas com o chão a y ≈ 900 e a camada do meio emendável (D-159); entradas desenhadas (porta, caverna, escada, tenda...) no pedido de arte da T34. Referência de clima e tamanho dos personagens: `docs/art/reference/` (D-187).
- Nomes dos caminhos: o reto é "Seguir em frente"; os desvios são Porta, Caverna ou Escada (D-149).
- **No M1:** a equipe deslizava sozinha até a bifurcação, e as entradas eram retângulos tocados duas vezes (mostrar e confirmar).

## 5. Pouso e Vigília

- Retratos dos 3 santos com vida e desolação; para cada um, os botões de atividade.
- Botões fixos: Descansar (mostra o custo de 1 Pão), Seguir, Retirada planejada.
- O resultado da emboscada aparece depois de confirmar as atividades.
- No M1: cartão por santo (retrato, vida, desolação, ferimento) com os botões de atividade; Partilha e atividades próprias de alvo pedem o santo; Descansar, Seguir e Retirada planejada confirmam no segundo toque; o resultado lista o que mudou e a emboscada (D-323).

## 6. Evento narrativo

- Ilustração do evento ao fundo, caixa de texto no terço inferior, nome do falante.
- Opções como botões grandes; requisito e chance escritos no botão ("Exige Caridade 3", "Chance 70%: Bento na equipe").
- Rótulo de origem discreto no canto (ex.: "Inspirado em Dante").
- Nome de quem fala numa aba sobre o canto esquerdo da caixa; o narrador não tem aba e fala em itálico (D-151). Opções: primeiro toque mostra, segundo confirma; depois aparece o texto do resultado com o que mudou (Lume, virtudes, desolação, Esmolas, provisões).

## 7. Vila

- Panorama da vila com os edifícios tocáveis (arte separada: edifício e fundo, conforme a Direção de Arte).
- Topo: semana, tempo litúrgico (cor do tempo), Esmolas, Sufrágios.
- Botão principal: **Planejar a semana** (tela única com as 7 etapas de `village-economy.md` §2, em abas na mesma tela).

## 8. Acessibilidade e opções

- Tamanho do texto (3 níveis), velocidade das animações, vibração, volume separado de música e efeitos.
- Nunca usar só cor para informar algo: todo estado tem ícone ou texto.
- Contraste mínimo 4.5:1 para texto.

## 9. Pendências

- Wireframes finais das telas de vila e instalações (M2).
- Ícones definitivos das intenções e condições (piloto de arte).
