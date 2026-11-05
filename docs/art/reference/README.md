# Referências visuais (D-187)

Imagens de exemplo enviadas por Alan em 05/11/2026 para mostrar, "mais ou menos", o que ele espera da arte final do M2. São **referência de clima, tamanho e composição**, não arte do jogo nem especificação de interface: nomes, números e telas continuam vindo de `docs/specs/`, `docs/ui/screens.md` e dos CSVs.

| Arquivo | Tamanho | O que mostra |
| --- | --- | --- |
| `m2_mockup_combat_01.jpg` | 1376×768 | Combate contra um chefe-inseto numa cripta em ruínas, com painel inferior de retratos e habilidades |
| `m2_mockup_combat_02.jpg` | 2112×1168 | Jorge, Bento e Teresinha contra Diabo de Lodo, Moscardo e Sombra do Desejo num cenário de cinzas e brasas |

## O que levar para o jogo

- **Personagens grandes:** as figuras ocupam cerca de metade da altura da tela, com os pés numa linha de chão comum perto de 75–80% da altura (no nosso palco de 1920×1080, y ≈ 800–900; D-159, D-209). Santos à esquerda, inimigos à direita, frente a frente.
- **Traço:** tinta escura, alto contraste, sombras duras, como a Direção de Arte já pede.
- **Cenário em camadas:** ruínas e arcos ao fundo, névoa, escombros no meio e pedaços na frente; dá a profundidade do parallax.
- **Elementos vivos:** brasas e partículas no ar, fumaça, luz quente de um lado; feitos no motor (tweens e partículas, D-176).
- **Auréola** atrás da cabeça dos santos (já feita no motor, ADR-0008).
- **Marcas no chão:** elipse sob cada personagem (dourada para santo, vermelha para alvo inimigo) e barras de vida logo abaixo dos pés, com os ícones de condição embaixo.
- **Chefe:** barra própria no alto, com nome e ícones.
- **Painel inferior:** retratos com vida e desolação e os botões de habilidade com ícone e nome.

## O que não levar

- Textos e números das imagens (nomes em inglês, "Health/Stress", valores): o jogo usa os termos de `docs/glossary.md` e os textos de `ui_text.csv`.
- A tocha e o mapa das imagens: no jogo são o **Lume** e o **mini-mapa** já especificados; a interface segue a identidade própria do jogo (molduras de pergaminho, Direção de Arte), sem copiar a interface de outro jogo.
- Santos que ainda não estão na companhia (Sebastião, Joana) e o chefe-inseto: só exemplos de composição.
