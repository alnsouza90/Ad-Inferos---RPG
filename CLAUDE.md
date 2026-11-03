# CLAUDE.md — Ad Inferos

RPG tático por turnos para Android, em Godot. Design em `docs/gdd_v1.1.md`, arte em `docs/direcao_de_arte_v1.1.md`, estrutura em `architecture.md`.

## Ambiente

- **Godot:** 4.7.2-stable (alvo; série 4.7.x), renderizador Compatibility.
- **`godot --version`:** `PENDENTE — registrar a saída real aqui` (build oficial esperada: `4.7.2.stable.official.ed1daf0bf`).
- **GUT:** 9.7.1, em `game/addons/gut/`.
- O projeto Godot fica em `game/`; todos os comandos abaixo partem da raiz do repositório.

## Comandos

Importar recursos (necessário uma vez após clonar ou ao adicionar assets, antes dos testes):

```bash
godot --headless --path game --import
```

Rodar todos os testes sem tela (lê `game/.gutconfig.json`):

```bash
godot --headless --path game -d -s addons/gut/gut_cmdln.gd
```

Código de saída: `0` se todos passarem, `1` se algum falhar.

Rodar um arquivo de teste específico:

```bash
godot --headless --path game -d -s addons/gut/gut_cmdln.gd -gtest=res://tests/unit/test_exemplo.gd
```

## Convenções

- Lógica de regras separada das cenas, testável no GUT (ver `architecture.md`).
- Números de balanceamento em `game/data/`, nunca fixos no código.
- Todo sistema novo vem com testes em `game/tests/unit/`.
- Arte e áudio pelo Git LFS; não commitar `game/.godot/`.
- Textos do jogo em português (versão 1); nomes de arquivos e código em inglês.
