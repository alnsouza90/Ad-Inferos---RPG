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

A arena do M0 continua acessível só na versão de desenvolvimento.

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

Regras em `specs/expedition.md` §2.3 (D-207, D-121).

```text
┌──────────────────────────────────────────────────────────────────────────┐
│ [Pausa] Lume ▮▮▮▮▮▮▮▮▯▯ 80   Esmolas 70 (+140 não garantidas)  [Mini-mapa]│ ← barra superior
│                                                                          │
│   (fundo com parallax)                          ┌────┐                   │
│                                                 │porta│  ⚔ Combate       │ ← desvio
│   Teres  Bento  Jorge  ───── andam ─────►       └────┘                   │
│                                                        ═══► ✦ Tentação   │ ← segue reto
│                                                                          │
│ [Provisões]                                         [painel da entrada]  │
└──────────────────────────────────────────────────────────────────────────┘
```

- A equipe anda da esquerda para a direita. A velocidade da caminhada segue a preferência de animação (1×, 2×, instantâneo).
- Na bifurcação, cada entrada mostra o ícone do tipo de nó e o nome do tipo em texto (nunca só o ícone). Tocar mostra no painel o que se sabe do nó; o segundo toque confirma a ida.
- Barra superior: Lume (barra e número), Esmolas garantidas e não garantidas, botão do mini-mapa. Botão de provisões no canto inferior esquerdo.
- **Mini-mapa:** sobreposto ao corredor, camadas da esquerda para a direita, ícone do tipo de todo nó, ligações, caminho já feito e posição atual. Só consulta; fecha com um toque fora ou no botão.
- Arte do M1: provisória (cenário do Círculo 2, trecho 1, e retângulos para as entradas); Jorge usa a arte que já existe. Arte final e animação de andar no M2 (D-210).
- Nomes dos caminhos no M1: o reto é "Seguir em frente"; os desvios são Porta, Caverna ou Escada (D-149). Enquanto as telas dos nós não existem, a caminhada se testa pelo botão "Caminhada (teste)" da arena (D-149).

## 5. Pouso e Vigília

- Retratos dos 3 santos com vida e desolação; para cada um, os botões de atividade.
- Botões fixos: Descansar (mostra o custo de 1 Pão), Seguir, Retirada planejada.
- O resultado da emboscada aparece depois de confirmar as atividades.

## 6. Evento narrativo

- Ilustração do evento ao fundo, caixa de texto no terço inferior, nome do falante.
- Opções como botões grandes; requisito e chance escritos no botão ("Exige Caridade 3", "Chance 70%: Bento na equipe").
- Rótulo de origem discreto no canto (ex.: "Inspirado em Dante").

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
