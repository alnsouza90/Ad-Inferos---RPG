# Arquitetura — Ad Inferos

Documento de referência da estrutura do repositório e do projeto Godot. Regras de jogo ficam no [GDD](docs/gdd_v1.1.md); regras de arte na [Direção de Arte](docs/direcao_de_arte_v1.1.md).

## Projeto Godot

| Item | Valor |
| --- | --- |
| Engine | Godot 4.7 (série 4.7.x) |
| Renderizador | Compatibility (`gl_compatibility`, também no mobile) |
| Resolução base | 1920 × 1080 |
| Orientação | Paisagem (`window/handheld/orientation=0`) |
| Esticamento | `canvas_items`, aspecto `expand` |
| Compressão de textura | ETC2/ASTC ligada (Android) |
| Testes | GUT 9.7.1 (`addons/gut/`), compatível com Godot 4.7 |

## Árvore do repositório

```text
/
├── CLAUDE.md                 ← comandos e convenções para o Claude Code
├── architecture.md           ← este documento
├── docs/                     ← GDD, Direção de Arte e demais documentos de design
└── game/                     ← raiz do projeto Godot (res://)
    ├── project.godot
    ├── .gutconfig.json       ← configuração do GUT (lida por padrão pelo CLI)
    ├── addons/
    │   └── gut/              ← GUT 9.7.1, sem modificações
    ├── art_source/           ← .gdignore; matrizes, camadas e versões (fora da importação)
    ├── assets/               ← arte e áudio prontos para o jogo (Git LFS)
    │   ├── characters/
    │   │   ├── saints/<nome>/{body,portrait,rig}/
    │   │   ├── enemies/  elites/  bosses/  guardians/  narrative/
    │   ├── environments/
    │   │   ├── village/hub/<edificio>/   village/interiors/<instalacao>/
    │   │   ├── camp/
    │   │   └── circles/circle_NN/tN/
    │   ├── vfx/{halo,miracles,impacts,particles,ground_markers}/
    │   ├── ui/{icons,frames}/
    │   ├── audio/{music,sfx}/
    │   └── fonts/
    ├── data/                 ← dados e tabelas de balanceamento (Resources .tres / JSON)
    │   ├── saints/  enemies/  conditions/  relics/  provisions/  circles/
    │   └── balance/
    ├── scenes/               ← cenas .tscn por domínio
    │   ├── main/  combat/  expedition/  village/  narrative/  ui/
    ├── scripts/              ← GDScript por domínio
    │   ├── autoload/         ← singletons (estado global, calendário, salvamento)
    │   ├── core/             ← tipos e utilitários sem dependência de cena
    │   ├── combat/           ← turno de equipe, Fervor, condições, intenções
    │   ├── expedition/       ← mapa de nós, Lume, provisões, Pouso
    │   ├── village/          ← instalações, semana, economia
    │   ├── narrative/        ← Encontros, Tentações, Conselhos, virtudes
    │   ├── save/             ← salvamento a cada nó e retomada
    │   └── ui/
    ├── tests/
    │   ├── unit/             ← testes de lógica pura (prefixo test_)
    │   └── integration/      ← testes que instanciam cenas
    └── tools/
        └── simulator/        ← simulador de combate sem tela (M0)
```

Pastas vazias levam um `.gitkeep` até receberem conteúdo.

## Princípios de código

1. **Lógica separada da apresentação.** Regras (dano, condições, Fervor, desolação, Lume) ficam em `scripts/core` e nos domínios, como classes sem dependência de nós da cena, para serem testadas no GUT e usadas pelo simulador.
2. **Dados fora do código.** Números de balanceamento ficam em `data/`, nunca fixos nos scripts.
3. **Determinismo.** O acerto é determinístico; a única aleatoriedade (teste de Fé, emboscada no Pouso) passa por um gerador com semente injetável, para que testes e simulador sejam reproduzíveis.
4. **Salvamento a cada nó.** O estado da expedição é serializável e a retomada é exata.

## Nomes de arquivos

- Inglês, minúsculas e sublinhado: `categoria_nome_parte_variante` (Direção de Arte).
- Scripts e cenas em `snake_case`; classes (`class_name`) em `PascalCase`.
- Testes: `tests/<tipo>/test_<assunto>.gd`, estendendo `GutTest`.

## Git e LFS

- Imagens, áudio, fontes e arquivos de Spine vão pelo Git LFS (`.gitattributes`).
- `game/addons/` fica fora do LFS.
- `.godot/` (cache de importação) não é versionado.
