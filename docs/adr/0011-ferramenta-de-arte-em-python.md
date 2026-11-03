# ADR-0011 · Tratamento de arte com Python e Pillow

**Situação:** Aceita (T16, 03/11/2026)

## Contexto

`docs/art/asset-pipeline.md` §1 deixa o agente automatizar remoção de fundo, recorte e redimensionamento em `tools/art/`, sem alterar `art_source/`. O Godot não faz isso bem sem tela, e as imagens chegam como JPG com fundo cinza-claro liso.

## Decisão

- `tools/art/process_art.py` (Python 3 com Pillow) lê `art_source/` e grava `game/assets/`.
- Corpos: o fundo é a área cinza ligada às bordas (preenchimento a partir da borda), com borda suave; o cinza dentro da figura fica. Brilhos cinza-claros pintados atrás da cabeça também saem; o contorno branco do desenho os separa da figura.
- Auréola: todo pixel cinza de fundo sai, inclusive o buraco dos raios.
- Tamanhos do §4: corpo 1024×1536 com figura de 1200 px e pés a 96 px da base; auréola 512×512.
- É ferramenta de desenvolvimento: nada dela vai para o jogo.

## Por quê

- Repetível: rodar de novo regenera tudo quando Alan mandar versões novas.
- Pillow é a biblioteca de imagem mais comum em Python e já existe no ambiente.

## Consequências

- Quem roda precisa de `pip install pillow`.
- Fundo pintado em xadrez (alguns inimigos) não é removido por esta regra; tratar quando a arte deles entrar.
