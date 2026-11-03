# ADR-0001 · Engine Godot 4 e GDScript tipado

**Situação:** Aceita

## Contexto

O jogo precisa de 2D de qualidade, exportação para Android, custo zero de licença e boa compatibilidade com desenvolvimento assistido por IA.

## Decisão

Usar Godot 4 (série estável 4.7) com GDScript e tipagem estática obrigatória. Sem C#.

## Por quê

- GDScript tem a maior quantidade de exemplos e documentação para Godot 4, o que reduz erros do agente.
- Tipagem estática pega erros cedo e documenta o código.
- C# exigiria .NET e complica a exportação Android.

## Consequências

- Toda nova versão do Godot exige revisar este ADR antes de atualizar o projeto.
- Proibido usar sintaxe do Godot 3.
