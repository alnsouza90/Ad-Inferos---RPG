# Pendências

Riscar (~~assim~~) e anotar a data quando resolver.

| Pendência | Depende de | Desde |
| --- | --- | --- |
| ~~Corpo padrão de São Jorge em resolução maior~~ Alan enviou a v02 (848×1264) em 04/11/2026 | Alan | 03/11/2026 |
| Brilho atrás da cabeça na imagem de Consolação de São Jorge: conferir no motor se briga com a auréola | T16 | 03/11/2026 |
| Recalibrar metas "vitória da heurística em difícil" e "Noite Escura na expedição longa" (D-113); forma decidida em D-125 e D-126 | T31 (M1) | 03/11/2026 |
| ~~Criar `docs/backlog/m1.md`~~ Proposta feita e perguntas respondidas por Alan em 04/11/2026 (D-121 a D-126) | Alan | 03/11/2026 |
| Datas das festas dos santos (`feasts.csv`) | Pesquisa do Martirológio (Alan) | 03/11/2026 |
| Heurística do simulador gasta todo o Fervor no milagre de Jorge (rever a política, não os números) | T14+ / M1 | 03/11/2026 |
| Fundos "xadrez" pintados na imagem (JPG não tem transparência): Diabo de Lodo, Sopro Errante, Sombra, Mãe-Enxame, Moscardo, Enxame e camada da frente do cenário. Ideal: PNG com transparência real ou fundo liso cinza; senão, recorte na T16 | Alan / T16 | 03/11/2026 |
| Consolação de São Bento veio com auréola desenhada (a Direção de Arte pede sem); conferir no motor ou pedir versão sem | T16 / Alan | 03/11/2026 |
| ~~Confirmar qual imagem de Teresinha é o padrão e qual é a Consolação~~ Confirmado por Alan em 03/11/2026: muitas pétalas = Consolação; poucas = padrão | Alan | 03/11/2026 |
| Cenário do Círculo 2 veio sem a camada do meio (só fundo e frente); os redemoinhos (`vfx_hazard_gale`) podem servir de camada animada | T16 | 03/11/2026 |
| ~~Revisar os textos da tela de combate em `docs/balance/ui_text.csv`~~ Revisados e aprovados por Alan em 03/11/2026 (D-114) | Alan | 03/11/2026 |
| Salvar a preferência de velocidade das animações em `settings.json` (screens §3) | `SaveService` (M1) | 03/11/2026 |
| Ícones de intenção e de condição: hoje são palavras (`Ataque 6 na posição 1`) | Piloto de arte | 03/11/2026 |
| Consolação de São Jorge: o brilho atrás da cabeça saiu quase todo no recorte, mas sobra uma faixa clara colada ao rosto; Alan julga no jogo se precisa de versão sem brilho | Alan | 03/11/2026 |
| Compressão VRAM (ETC2/ASTC) das texturas de personagem: hoje importação padrão sem perda | T17 | 03/11/2026 |
| Animação de combate "como Darkest Dungeon" (santo vai até o inimigo e ataca; defesa com reação): Alan achou a atual simples demais. Planejada na trava "abordagem de animação" do roadmap (arte final do M2, ADR-0007); ~~proposta de antecipar~~ Alan decidiu manter no M2 (D-116) | M2 | 04/11/2026 |
| Personagens pequenos na tela do celular: continuam pequenos no APK em tela cheia; rever no M2 (D-209) | M2 | 04/11/2026 |
| Forma de testar a auréola sem depender da sorte: botões de teste na T17 (D-117) | T17 | 04/11/2026 |
| Noite Escura e Consolação de Jorge são da leva antiga (traço diferente da pose normal nova): Alan manteve por enquanto (D-205); rever depois do teste | Alan | 04/11/2026 |
| ~~Folhas de produção (D-206): os santos "andam" entre os nós num corredor com parallax (`_mid` emendável), mas `docs/ui/screens.md` §4 e `specs/expedition.md` têm só a tela de mapa de nós. Decidir se a expedição ganha caminhada lateral e atualizar a spec~~ Decidido: caminhada lateral com bifurcações (D-207); detalhar e atualizar a spec no M1/M2 | M1/M2 | 04/11/2026 |
| ~~Folhas de produção (D-206): tela "Mapa do Inferno" (escolha do círculo em faixas que rolam) não está no fluxo de telas (`screens.md` §2). Decidir onde entra~~ Decidido: ao sair pelo portão da vila no Átrio (D-208); atualizar `screens.md` quando a vila for feita | M2 | 04/11/2026 |
| Linha do chão dos cenários a y ≈ 900 de 1080: a tela de combate hoje põe os pés a y ≈ 456 e as figuras com 300 px. Refazer o leiaute do campo quando os cenários entrarem (resolve também "Jorge pequeno"; confirmado por Alan no APK, D-209) | M2 (arte final) | 04/11/2026 |
| ~~Estados espirituais: as folhas pedem só o **rosto** por estado (`face_*`); hoje Jorge usa o corpo inteiro por estado. Escolher no M2~~ Decidido: corpo inteiro por estado, com imagem sobreposta em Consolação e desolação (D-210) | M2 | 04/11/2026 |
| ~~Santa Rita: a pose de ataque segura o crucifixo à frente "em comando". Confirmar que o gesto é devocional e que a habilidade não trata o crucifixo como arma ou fonte de bônus (`writing-guide.md`, figuras sagradas)~~ Aprovado por Alan (D-211) | Alan | 04/11/2026 |
| Animação estilo Darkest Dungeon (D-210): andar, câmera, avanço e ataque; tela especial do milagre (ex.: Jorge a cavalo); imagem sobreposta de Consolação e de agonia. Precisa de imagens novas por santo (Alan) e da etapa de animação | M2 | 04/11/2026 |
| Tempo de um combate no APK (meta do M0: 2 a 4 minutos) ainda não medido | Alan | 04/11/2026 |
| ~~Tela do milagre de São Jorge: em D-210 Alan citou "Jorge atacando com o cavalo", mas a folha `prompts-splash.md` pede Jorge a pé, erguendo a lança, e exclui cavalo e dragão. Confirmar qual vale antes de gerar~~ Vale a folha: a pé, sem cavalo (D-214) | Alan | 04/11/2026 |
| ~~Incenso "revela nós vizinhos" (`expedition.md` §2.2 e §5): com o Portão nível 1, o conteúdo da próxima camada já aparece, então o Incenso só serviria para anular a emboscada. Decidir se ele passa a revelar mais uma camada à frente (mudança de regra)~~ Decidido: revela mais uma camada (D-129) | Alan (T18/T22) | 04/11/2026 |
