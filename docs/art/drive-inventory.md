# Inventário do Drive "Art Source" e arte no repositório

Varredura de 10/11/2026 (D-245). O Drive "Art Source" (`owner.md`, D-230) é o **arquivo de toda a arte aprovada**; o repositório guarda **só a arte que o jogo ou as ferramentas usam hoje**. Quando uma tarefa começa, o agente busca no Drive a arte dela, traz para `art_source/` e processa.

## 1. Estrutura do Drive (espelho do repositório, D-246)

Reorganizado em 10/11/2026 com autorização de Alan. As pastas seguem a mesma árvore de `art_source/` e os nomes seguem o padrão `categoria_nome_parte_variante` (`docs/art/asset-pipeline.md`).

```
Art Source/
  characters/
    saints/                  3 arquivos sem nome descritivo (a identificar)
    portraits/               3 retratos sem nome descritivo (T50 / T44)
    enemies/                 20 inimigos comuns: enemy_<id>_body_idle_v01.png
                             (7 da Família A → T52; 13 de outros círculos → M3)
    elites/
      elite_minos/           pose de ataque (já no jogo, T35)
      elite_sin_<pecado>/    8 Pecados Encarnados (Vertigem já no jogo; 7 → M3)
      elite_<id>/            Cérbero, Pluto, Flégias, Medusa, Minotauro, Malacoda → M3
    bosses/
      boss_<id>/             Caronte (Antinferno, D-172), Belzebu, Mamon, Belfegor,
                             Moloch, Belial, Azazel → M3
                             + 5 arquivos sem nome descritivo na raiz (a identificar)
    narrative/               scene_antaeus_body_idle_v01.png
  environments/
    circles/
      antinferno/, circle_01/, circle_03/ … circle_09/   vazias
      circle_02/
        t1/      env_circle_02_t1_mid_v02, _front_v03          → T36, T37
        t2/      env_circle_02_t2_mid_v01, _front_v01          → T42
        t3/      env_circle_02_t3_back_v01, _mid_v01, _front_v01 → T42
        boss/    env_circle_02_boss_back_v01, _mid_v01, _front_cutout_v01 → T41
        vigil/   env_circle_02_vigil_v01                       → T42
        camp/    env_circle_02_camp_v03 (Pouso, 2560×1080)     → T53
        nodes/   env_circle_02_node_v01 a v03                  → T53
        props/   prop_c02_entry_cave/door/stair/straight_v02, prop_c02_tent_v03 → T37, T53
        common/  env_circle_02_back_storm_v01, _back_storm_eye_v01, _mid_plain_v01, _mid_rock_wall_v01 (camadas comuns aos trechos, D-345)
        souls/   env_circle_02_souls_sheet_v01, _souls_crowd_v01 (almas do Encontro e do Vendaval)
        (raiz)   fx_circle_02_ambient_v01 (folha de partículas)
    props/                   2 imagens sem nome descritivo (T37 / T53)
    village/
      buildings/level_1..3/day|night/   62 edifícios → T49 (níveis 2 e 3 no M3)
      interiors/                        9 interiores → T49
  splash/                    8 telas de passagem (`prompts-splash.md`) → T44
  ui/icons/                  23 ícones nomeados (icon_intent_*, icon_state_*, icon_condition_*, icon_damage_*, icon_node_*, icon_item_*, D-345); 7 ainda numéricos → T36, T53
  vfx/halo/                  vfx_halo_disk_v01, vfx_halo_rays_v01 (auréola)
  Prancha/                   vazia
  _vazia_pode_apagar/        pasta vazia, Alan apaga
```

Observações:
- Arquivos com nome numérico (câmera ou Meta AI) ficaram onde estavam: na tarefa de cada um, o agente abre a imagem, confirma o que é com Alan e renomeia no Drive e no repositório.
- Não há arquivos repetidos no Círculo 2: o que parecia repetido era o mesmo arquivo em duas páginas da listagem.
- **Não estão no Drive:** os vídeos do Wan 3 (no repositório e na biblioteca do ImagineArt). Almas, relicário, redemoinhos do Vendaval e faixa de névoa: Alan sobe ou manda pelo chat quando a tarefa pedir (D-246).

## 2. O que fica no repositório (`art_source/`)

Só o que as ferramentas usam (`tools/art/process_art.py` e `tools/art/animation_clips.csv`):

- Santos: vídeos do Wan 3 de Jorge, Bento e Teresinha; imagens de Jorge usadas na tela de combate (padrão, ataque, golpe, queda, Noite Escura, Consolação, retrato v02); retratos de Bento e Teresinha.
- Minos: vídeo parado e as 4 poses desenhadas (preparar, chicotada v02, defesa, derrota) + a pose parada desenhada (referência de escala).
- Vertigem: desenhos em stop motion (GIFs parado, ataque, magia v02 e queda; imagens parada, guarda, defesa e salto, D-247, D-248). Asmodeu: vídeos do Wan 3 (parado, ações e o sopro novo, D-242).
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

**Cota do Git LFS (D-246):** apagar arquivos do repositório **não libera** a cota de 1 GB, porque o histórico continua guardando cada versão. Recuperar a cota exige reescrever o histórico do Git **e** pedir ao suporte do GitHub que apague os objetos LFS antigos (ou apagar e recriar o repositório, perdendo PRs e lançamentos). Uso medido em 10/11/2026: ~214 MB de 1 GB (só ~93 MB estão apenas no histórico). Não compensa agora; reavaliar se passar de ~700 MB.
