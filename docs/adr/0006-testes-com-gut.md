# ADR-0006 · Testes com GUT

**Situação:** Aceita

## Contexto

Precisamos de testes automáticos rodando sem tela, inclusive em CI.

## Decisão

Usar GUT (Godot Unit Test) para Godot 4, instalado em `game/addons/gut/`.

## Por quê

- Linha de comando simples para rodar sem tela.
- Bem documentado.

## Consequências

- Se o GUT não suportar a versão do Godot instalada, avaliar gdUnit4 e registrar novo ADR.
