# ADR-0005 · Salvamento em JSON com log de comandos

**Situação:** Aceita

## Contexto

O Android pode fechar o app a qualquer momento; o jogador precisa voltar exatamente onde estava, inclusive no meio do turno.

## Decisão

Save em JSON versionado, escrita atômica com backup; o combate salva semente e log de comandos e é reconstruído por reaplicação.

## Por quê

- Retomada exata.
- Reprodução de bugs a partir do save.

## Consequências

- Toda mudança de regra que altere o resultado de comandos antigos exige incrementar `save_version` e tratar saves em combate (ver save-load.md).
