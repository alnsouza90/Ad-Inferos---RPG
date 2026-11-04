# ADR-0012 · Eventos narrativos em YAML simples, lidos por um leitor próprio

**Situação:** Aceita (T23, 04/11/2026)

## Contexto

`narrative-system.md` §3 e `writing-guide.md` §5.1 definem os eventos em YAML, um arquivo por evento em `docs/narrative/events/<círculo>/`. O formato é bom para quem escreve e revisa textos (Alan). O Godot, porém, não lê YAML, e adicionar um plugin ou biblioteca externa exige ADR e aumenta o risco.

## Decisão

- `game/tools/data/event_yaml.gd` (`EventYaml`) lê só o subconjunto de YAML que os eventos usam:
  - mapas e listas por indentação (2 espaços);
  - itens com `- `;
  - mapas e listas de uma linha (`{ type: light, amount: -5 }`, `[a, b]`);
  - textos entre aspas ou sem aspas, números, `true`, `false` e `null`;
  - comentários com `#`.
- Qualquer coisa fora disso é erro (`[bad_yaml]`, com arquivo e linha): um erro de digitação nunca vira dado silencioso.
- O importador (`import_balance.gd`) lê `docs/narrative/events/**/*.yaml`, valida (`narrative-system.md` §3 e §4) e gera `game/data/events/<id>.tres` (`EventDef`). A conferência do CI (`--check`) também cobre os eventos.
- Formatos fixados para o que a especificação deixou em aberto:
  - requisitos: `{ type, id, value }`;
  - modificadores de chance: `{ if, id, add, consume }`;
  - resultados: `{ type, id, target, amount }`.

## Por quê

- Sem dependência externa e sem mudar o formato que Alan já conhece.
- O subconjunto é pequeno, testado (`tests/unit/narrative/test_event_yaml.gd`) e cobre o exemplo da especificação.

## Consequências

- Recursos avançados de YAML (âncoras, textos em várias linhas com `|`, tabulação) não são aceitos; textos longos ficam numa linha entre aspas.
