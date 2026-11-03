# ADR-0002 · Regras do jogo separadas da apresentação

**Situação:** Aceita

## Contexto

Regras misturadas com cenas não podem ser testadas sem abrir o jogo, dificultam o balanceamento e são o erro mais comum em código gerado por IA.

## Decisão

Toda regra mora em `game/core/` como classes RefCounted sem Node. As cenas enviam comandos e reagem a eventos.

## Por quê

- Testes automáticos sem tela.
- Simulador de balanceamento com milhares de combates.
- A tela pode mudar (inclusive a abordagem de animação) sem tocar nas regras.

## Consequências

- Um pouco mais de código de ligação entre tela e regras.
- `core` nunca pode chamar `get_tree()`, `await` ou autoloads.
