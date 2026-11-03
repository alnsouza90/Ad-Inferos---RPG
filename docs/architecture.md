# Arquitetura técnica

Como o código de Ad Inferos é organizado. O princípio central: **as regras do jogo rodam sem tela**. A interface só envia comandos e mostra o que aconteceu.

## 1. Camadas

```text
┌───────────────────────────────────────────────────────────────┐
│ APRESENTAÇÃO  game/scenes/                                    │
│ Telas, animação, auréola por shader, áudio, entrada de toque  │
│ Envia comandos · Lê o estado · Reage a eventos                │
└──────────────┬───────────────────────────────▲────────────────┘
               │ comandos                      │ eventos
┌──────────────▼───────────────────────────────┴────────────────┐
│ REGRAS  game/core/                                            │
│ RefCounted puro, sem Node · determinístico com semente        │
│ combat · conditions · effects · ai · expedition · village ·   │
│ narrative · progression · rng                                 │
└──────────────┬────────────────────────────────────────────────┘
               │ lê
┌──────────────▼──────────────────┐  ┌──────────────────────────┐
│ DADOS  game/data/ (.tres)       │  │ SERVIÇOS game/autoload/  │
│ gerados de docs/balance/*.csv   │  │ GameState · SaveService  │
│                                 │  │ EventBus                 │
└─────────────────────────────────┘  └──────────────────────────┘
```

**Regras de dependência**

- `scenes` pode usar `core`, `data` e `autoload`.
- `autoload` pode usar `core` e `data`.
- `core` só usa `core` e `data`. Nunca `scenes` nem `autoload`.
- `data` não tem lógica além de validação.

## 2. Estrutura de pastas do projeto Godot

```text
game/
├── project.godot
├── addons/gut/                    framework de testes
├── autoload/
│   ├── event_bus.gd               sinais globais de alto nível (troca de tela, save concluído)
│   ├── game_state.gd              estado da campanha em memória + referência ao save
│   └── save_service.gd            leitura/escrita atômica e migração
├── core/
│   ├── rng/rng_stream.gd          gerador com semente, contado (reprodutível)
│   ├── combat/
│   │   ├── battle_state.gd        estado completo do combate (dados puros, serializável)
│   │   ├── combatant.gd           santo ou inimigo em campo
│   │   ├── battle_controller.gd   máquina de estados do combate; recebe comandos
│   │   ├── commands/              UseAbility, SwapSlots, UseProvision, EndPartyTurn
│   │   ├── targeting.gd           valida posições de uso e de alvo
│   │   ├── damage.gd              fórmula de dano
│   │   ├── fervor_pool.gd
│   │   └── battle_events.gd       lista de eventos gerados (para a tela e para o log)
│   ├── effects/                   uma classe por tipo de efeito
│   ├── conditions/                motor de condições (ver specs/conditions.md)
│   ├── spirit/desolation.gd       desolação, teste de Fé, estados
│   ├── ai/enemy_brain.gd          escolha de intenções
│   ├── expedition/                mapa, nós, Lume, provisões, Pouso
│   ├── village/                   semanas, calendário, instalações, economia
│   ├── progression/               experiência, níveis, melhorias, Carismas, relíquias
│   └── narrative/                 eventos com requisitos, virtudes, flashbacks
├── data/
│   ├── defs/                      scripts das classes Resource (SaintDef, AbilityDef...)
│   ├── saints/  abilities/  enemies/  encounters/  conditions/
│   ├── relics/  provisions/  circles/  events/  facilities/
│   └── constants.tres             números globais (Fervor, Lume, desolação...)
├── scenes/
│   ├── boot/  title/  village/  map/  battle/  camp/  narrative/  ui/  common/
├── assets/                        arte e áudio prontos (ver docs/art/asset-pipeline.md)
├── shaders/                       auréola, dissolução, corrupção, ondulação
├── tests/
│   ├── unit/                      uma pasta por sistema de core
│   ├── integration/               combate completo, expedição completa
│   └── sim/                       cenários do simulador
└── tools/
    ├── data/import_balance.gd     CSV → .tres
    ├── sim/run_sim.gd             simulador sem tela
    └── rig/                       scripts de montagem de personagem (após o piloto)
```

## 3. Estado e comandos

### 3.1 Estado puro

Todo o estado de um combate fica em `BattleState`: posições, vida, condições, desolação, Fervor, rodada, intenções, semente e contador do RNG. É serializável para JSON sem perda.

O mesmo vale para `ExpeditionState` e `CampaignState`. A tela nunca guarda estado de regra.

### 3.2 Comandos

O jogador nunca altera o estado diretamente. A tela cria um comando e o entrega ao controlador:

```gdscript
var cmd := UseAbilityCommand.new(actor_id, ability_id, target_slot)
var result: CommandResult = battle_controller.execute(cmd)
```

O controlador:

1. Valida o comando (é a vez da equipe? o santo já agiu? há Fervor? alvo válido?).
2. Resolve os efeitos em ordem, numa fila.
3. Registra o comando no log.
4. Devolve a lista de `BattleEvent` gerados (dano aplicado, condição aplicada, santo caiu...).

A tela anima os eventos na ordem recebida. Animação nunca altera regras: se a animação for pulada (velocidade instantânea), o resultado é o mesmo.

### 3.3 Fila de efeitos

Habilidades são **listas de efeitos** (dados). Um efeito pode gerar novos efeitos (ex.: contra-ataque do Duelo). A fila processa até esvaziar, com limite de segurança de 64 efeitos por comando (proteção contra laço infinito; ultrapassar o limite é erro registrado em log).

### 3.4 Máquinas de estado

**Combate**

```text
SETUP → ROUND_START → PARTY_TURN ⇄ (comandos) → ENEMY_TURN → HAZARD → ROUND_END
          ▲                                                            │
          └──────────────────────── (ninguém venceu) ◄─────────────────┘
ROUND_END → VICTORY | DEFEAT | RETREAT
```

**Expedição:** `AT_GATE → ON_MAP → IN_NODE (battle | event | camp) → ON_MAP … → ENDED (boss_won | retreated | defeated)`.

**Campanha:** `IN_VILLAGE → IN_EXPEDITION → IN_VILLAGE` (a semana avança na volta); `IN_STORY` para cenas.

## 4. Aleatoriedade

- Todo acaso usa `RngStream` (semente + contador de chamadas). Nunca `randi()` global.
- Cada sistema tem seu fluxo derivado da semente da campanha: `battle`, `map`, `rewards`, `events`, `faith`.
- Com a mesma semente e os mesmos comandos, o resultado é sempre idêntico. Isso permite retomar combates (save-load.md), reproduzir bugs e simular balanceamento.
- O combate em si é determinístico; o RNG de combate só é usado pela IA quando há empate entre alvos e pelo teste de Fé.

## 5. Dados

- A fonte de verdade dos números é `docs/balance/*.csv`.
- `tools/data/import_balance.gd` lê os CSVs e gera/atualiza os `.tres` em `game/data/`. Rodar após qualquer mudança nos CSVs.
- Classes de definição (`SaintDef`, `AbilityDef`...) são imutáveis em tempo de jogo. O estado mutável fica em `Combatant`, `SaintProgress` etc.
- Textos exibidos ao jogador ficam nos Resources em português (versão 1 só em português). Chaves estáveis permitem traduzir no futuro.
- Formato de cada definição: `docs/data-schemas.md`.

## 6. Salvamento

Resumo (detalhes em `docs/specs/save-load.md`):

- JSON em `user://saves/slot_1.json`, com `save_version`.
- Escrita atômica: grava em `.tmp`, renomeia, mantém `.bak` da versão anterior.
- No combate, salva a semente e o log de comandos; ao reabrir, reaplica os comandos e chega ao mesmo estado.
- Salva após cada comando resolvido, ao trocar de nó e quando o Android põe o app em segundo plano (`NOTIFICATION_APPLICATION_PAUSED`).

## 7. Eventos para a tela

- `core` não emite sinais globais. O controlador devolve eventos na resposta do comando e também os expõe por um sinal local `events_emitted(events: Array[BattleEvent])`.
- A cena de combate escuta esse sinal e enfileira animações.
- O `EventBus` global serve só para eventos de aplicação (trocar de tela, salvar concluído, pausa).

## 8. Apresentação

- Cada santo e inimigo em tela é uma cena `CombatantView` que recebe um ID e se atualiza a partir dos eventos.
- A auréola é um nó `HaloView` com um único shader; o estado espiritual muda parâmetros (ver `docs/art/asset-pipeline.md`).
- A abordagem de animação (só poses ou rig híbrido) será definida pelo piloto de arte. A `CombatantView` expõe uma interface única (`play_idle`, `play_action(pose_id)`, `play_hit`, `play_fall`) para que a escolha não afete o resto do código.

## 9. Ferramentas

| Ferramenta | Uso |
| --- | --- |
| `tools/data/import_balance.gd` | CSV → Resources, com validação de referências |
| `tools/sim/run_sim.gd` | Roda milhares de combates com políticas automáticas; gera relatório CSV em `tools/out/` |
| Log de combate | Texto legível com cada comando e evento; exportável no aparelho por um menu de depuração |
| Menu de depuração | Só em builds de desenvolvimento: pular combate, dar Esmolas, mudar semana, ver estado |

## 10. Android

- Renderizador Compatibility. Orientação paisagem travada.
- Resolução base 1920×1080, `stretch_mode = canvas_items`, `aspect = expand` (telas 20:9 ganham largura lateral).
- Texturas: VRAM comprimida (ETC2/ASTC) para fundos e personagens; sem perda para ícones e interface.
- Meta: 60 quadros por segundo em aparelho de entrada; memória de textura é o principal risco.
- Toque: áreas mínimas de 48 dp.

## 11. Riscos de desenvolvimento assistido por IA e mitigação

| Risco | Mitigação |
| --- | --- |
| Sintaxe do Godot 3 (`export`, `yield`, `onready` sem `@`) | CLAUDE.md fixa Godot 4; revisão de cada mudança |
| APIs inventadas | Testes obrigatórios; rodar o projeto a cada tarefa |
| Inconsistência de nomes entre sessões | `docs/glossary.md` obrigatório |
| Regras espalhadas na tela | Regra de dependência; testes de `core` sem cena |
| Números no código | Revisão: todo número de jogo vem de `docs/balance/` |
| Tarefas grandes demais | Backlog em tarefas pequenas, uma por pedido |
| Decisões silenciosas | ADR para toda decisão técnica relevante |
