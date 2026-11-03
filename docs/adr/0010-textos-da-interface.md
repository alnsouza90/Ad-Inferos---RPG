# ADR-0010 · Textos da interface em `ui_text.csv`

**Situação:** Aceita (T15, 03/11/2026)

## Contexto

O ADR-0009 proíbe texto ao jogador escrito no código. Nomes e descrições de santos, habilidades e condições já vêm dos CSVs, mas a tela de combate também precisa de textos próprios: "Encerrar turno", "Rodada 3", "Fervor insuficiente", "Toque de novo para confirmar".

## Decisão

- Os textos da interface ficam em `docs/balance/ui_text.csv` (`id`, `text_pt`), importados como os outros CSVs para `game/data/ui_text.tres` (`UiTextDef`).
- As telas pedem o texto pela chave (`ui.text(&"end_turn")`); números entram por campos entre chaves (`Rodada {round}`).
- Chave ausente aparece na tela como `[chave]`, para a falha ser visível, e um teste confere todas as chaves que a tela usa.
- Não usamos o sistema de tradução do Godot (`.translation`) por enquanto: a versão 1 é só em português e o CSV de tradução do Godot exige outro formato e outra etapa de importação. Se o jogo ganhar outros idiomas, este CSV vira a fonte da tradução.

## Por quê

- Alan revisa e muda qualquer texto da tela num único arquivo, sem mexer em código.
- O mesmo importador valida IDs repetidos e textos vazios, e o CI acusa `game/data` desatualizado.

## Consequências

- Toda tela nova acrescenta suas chaves ao `ui_text.csv` e ao teste de chaves.
