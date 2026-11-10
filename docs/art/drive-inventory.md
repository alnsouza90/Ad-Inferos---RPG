# Inventário do Drive "Art Source" e arte no repositório

Varredura de 10/11/2026 (D-245). O Drive "Art Source" (`owner.md`, D-230) é o **arquivo de toda a arte aprovada**; o repositório guarda **só a arte que o jogo ou as ferramentas usam hoje**. Quando uma tarefa começa, o agente busca no Drive a arte dela, traz para `art_source/` e processa.

## 1. O que há no Drive e em que tarefa entra

| Pasta do Drive | Conteúdo | Tarefa |
| --- | --- | --- |
| Characters/Enemies | 7 da Família A (Diabo de Lodo, Escaravelho, Moscardo, Sombra do Desejo, Mãe do Enxame, Enxame (prévia), Sopro Errante) | **T52** (quadros e poses) |
| Characters/Enemies | Vertigem (`elite_sin_vertigo`) | já no jogo (T35); T40 |
| Characters/Enemies | 13 inimigos de outros círculos (Chifre de Ferro, Sentinela de Dite, Centauro Arqueiro, Caído de Dite, Harpia, Sentinela do Gelo, Malebranche, Caído das Muralhas, Homem-Fornalha, Arpoador, Sombra Mascarada, Serpente Ladra, Arauto da Mentira) | M3 em diante |
| Characters/Enemies | 7 Pecados Encarnados de outros círculos (Cobiça, Engano, Rancor, Perfídia, Cisma, Crueldade, Voracidade) | M3 em diante |
| Characters/Boss | Minos (pose de ataque) | já no jogo (T35) |
| Characters/Boss | Chefes de outros círculos: Caronte, Belzebu, Mamon (2 versões), Belfegor (+ referência em pé), Moloch (+ braços abertos), Belial, Azazel; elites: Cérbero, Pluto, Flégias, Medusa, Minotauro, Malacoda; cena: Anteu | M3 em diante (Caronte no Antinferno, D-172) |
| Characters/Boss | 5 arquivos sem nome descritivo (números / `file_…`) | a identificar |
| Characters/Saints | 3 arquivos sem nome descritivo (`file_…png`) | a identificar |
| Characters/Retratos | 3 retratos sem nome descritivo | T50 (tela de novo santo) / T44 |
| Characters/Splash Scenes | 8 telas de passagem (`prompts-splash.md`) | **T44** |
| Environments/Circle 02 | Trechos 1 a 3 (fundo, meio, frente), cenário do chefe (fundo, meio, frente), Vigília, Pouso (2560×1080), 3 nós, entradas (caverna, porta, escada, seguir em frente), tenda | **T36, T37** (trecho 1), **T42** (trechos 2 e 3, Vigília), **T41** (chefe), **T53** |
| Environments (Antinferno, Village, Circle 01, 03 a 09) | pastas vazias | — |
| Village | vista geral (2), edifícios níveis 1 a 3 de dia e de noite (62), interiores (9) | **T49** (telas da vila); níveis 2 e 3 no M3 |
| UI/Icons | 30 ícones sem nome descritivo | **T53** (interface) |
| VFX | 3 imagens sem nome descritivo | T53 / efeitos |
| Prop | 2 imagens sem nome descritivo | T37 / T53 |
| Prancha | vazia | — |

Observações:
- Vários arquivos têm nomes de câmera ou do Meta AI (números). Na tarefa de cada um, o agente abre a imagem, confirma o que é com Alan e renomeia no padrão `categoria_nome_parte_variante` ao trazer para o repositório.
- Há arquivos repetidos em Circle 02 (escada, seguir em frente e tenda aparecem duas vezes).
- **Não estão no Drive:** os vídeos do Wan 3 (no repositório e na biblioteca do ImagineArt) e algumas artes recebidas pelo chat nas sessões 2 a 5 (ver §3).

## 2. O que fica no repositório (`art_source/`)

Só o que as ferramentas usam (`tools/art/process_art.py` e `tools/art/animation_clips.csv`):

- Santos: vídeos do Wan 3 de Jorge, Bento e Teresinha; imagens de Jorge usadas na tela de combate (padrão, ataque, golpe, queda, Noite Escura, Consolação, retrato v02); retratos de Bento e Teresinha.
- Minos: vídeo parado e as 4 poses desenhadas (preparar, chicotada v02, defesa, derrota) + a pose parada desenhada (referência de escala).
- Vertigem e Asmodeu: vídeos do Wan 3 (Asmodeu: parado, ações e o sopro novo, D-242).
- Cenário do trecho 1 (fundo e frente v01), Pouso v02, evento "O abrigo do vento" v02, auréola (disco e raios).

## 3. O que saiu do repositório (D-245) e onde recuperar

Tudo o que saiu continua no **histórico do Git** (commit `5be06ed`, antes da limpeza): `git checkout 5be06ed -- <caminho>` traz de volta.

| Saiu | Motivo | Também no Drive? |
| --- | --- | --- |
| Minos: vídeo de ações, vídeo do rabo reprovado, pose de ataque v01 | reprovados (D-228, D-231) | pose de ataque: sim (Boss) |
| Jorge: GIFs do Meta AI, vídeo parado v02, imagem parada v01 e v03, retrato v01, peças do esqueleto 2D | substituídos ou reprovados (D-195, D-225, D-233) | não |
| Bento e Teresinha: imagens paradas v01 e v02, Noite Escura e Consolação; andar v01 de Bento | ainda não usados no jogo (T52) ou substituídos (D-224) | conferir em Saints |
| Asmodeu e Vertigem: imagens paradas | referências de geração dos vídeos | Vertigem: sim (Enemies) |
| 7 inimigos da Família A | ainda não usados (T52) | sim (Enemies) |
| Cenário do trecho 1 v02 e meio v01, Pouso v01, evento v01, ambiente do Círculo 2, entradas, tendas, almas, relicário, redemoinhos do Vendaval, faixa de névoa | ainda não usados (T36, T37, T39, T53) ou substituídos | entradas, tenda e trechos: sim (Circle 02); almas, relicário, redemoinhos, névoa: **só no Git** |

**Atenção à cota do Git LFS:** apagar arquivos do repositório **não libera** a cota de 1 GB, porque o histórico continua guardando cada versão. A limpeza deixa o repositório organizado e o download do projeto menor, mas não devolve espaço da cota.
