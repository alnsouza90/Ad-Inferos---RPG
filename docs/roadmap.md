# Roteiro de produção (marcos)

Base: GDD v1.1 §11. Cada marco só começa depois que o anterior cumpre o critério de saída e o responsável aprova.

| Marco | Conteúdo | Critério de saída | Backlog |
| --- | --- | --- | --- |
| **M0 · Protótipo de combate** | Projeto Godot, importador de dados, combate completo com 3 santos e Família A, condições, desolação, IA, simulador, tela de combate com arte provisória | Combate de 2 a 4 min; menos de 5% de ações sem opção útil; nenhuma estratégia dominante; metas de `testing.md` §5.2 | `backlog/m0.md` |
| **M1 · Protótipo de trecho** | Mapa de 4 nós, Lume, provisões, uma Tentação, Pouso, salvamento e retomada | Trecho de 10 a 14 min; retomada exata após fechar o app | `backlog/m1.md` |
| **M2 · Fatia vertical no Android** | Prólogo e Círculo 2 completos (incluindo Asmodeu), vila mínima, arte final do trecho, áudio provisório | 45 a 60 min de jogo contínuo no celular | `backlog/m2.md` |
| **M3 · Produção por família** | Famílias A, B e C em sequência: círculos, inimigos, chefes, santos restantes, instalações | Cada família aprovada antes da próxima | `backlog/m3.md` |
| **M4 · Narrativa e acabamento** | Finais, Trilha do Purgatório, Conselhos, Martirológio, revisão teológica, polimento, publicação | Campanha completa; revisão teológica aprovada | `backlog/m4.md` |

## Trilhas paralelas

| Trilha | Quando | Responsável |
| --- | --- | --- |
| Piloto de arte (São Jorge e Capela) | Durante o M0 | Alan gera as imagens; o agente monta o teste de animação e da auréola no motor |
| Kits completos dos santos | Antes do M3 de cada santo | Alan aprova a proposta do agente |
| Roteiro (flashbacks, Encontros, Tentações) | A partir do M1, um círculo por vez | Alan, com apoio, seguindo `narrative/writing-guide.md` |
| Pesquisa do Martirológio | A partir do M2 | Alan, com apoio; nunca inventar fontes |

## Decisões que travam marcos

| Decisão | Trava | ADR |
| --- | --- | --- |
| Abordagem de animação (recortes com esqueleto 2D ou quadros) | Arte final do M2 | ADR-0007 |
| Kits propostos dos 12 santos (`design/saint-kits.md`) | Fim do M0 (Jorge, Bento, Teresinha); M3 para os demais | — |
| Variantes dos Carismas | M3 | — |
| Preço do download | Publicação (M4) | — |
