# ADR-0004 · Conteúdo em Resources gerados a partir de CSV

**Situação:** Aceita

## Contexto

O jogo tem 12 santos, 72+ habilidades, 43+ inimigos, relíquias e eventos. Codificar conteúdo gera duplicação e impede balancear sem programar.

## Decisão

Números em `docs/balance/*.csv`; um importador gera `.tres` em `game/data/`. Habilidades são listas de efeitos em dados.

## Por quê

- O responsável pode ajustar números numa planilha.
- Conteúdo novo não exige código novo.

## Consequências

- O importador precisa validar referências (IDs inexistentes falham na importação).
