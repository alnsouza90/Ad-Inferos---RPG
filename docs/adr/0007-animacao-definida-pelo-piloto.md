# ADR-0007 · Abordagem de animação definida pelo piloto de arte

**Situação:** Pendente do piloto

## Contexto

Arte gerada por IA vem em imagens inteiras; rig exige separar e reconstruir partes. A decisão do responsável: testar primeiro só poses; se ficar amador, rig para movimentos simples e poses para o resto.

## Decisão

A `CombatantView` expõe uma interface única (`play_idle`, `play_action`, `play_hit`, `play_fall`) e duas implementações possíveis. O piloto com São Jorge escolhe uma.

## Por quê

- O resto do código não depende da escolha.

## Consequências

- Atualizar este ADR com o resultado do piloto.
