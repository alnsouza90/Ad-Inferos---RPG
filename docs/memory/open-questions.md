# Pendências

Riscar (~~assim~~) e anotar a data quando resolver.

| Pendência | Depende de | Desde |
| --- | --- | --- |
| ~~Corpo padrão de São Jorge em resolução maior~~ Alan enviou a v02 (848×1264) em 04/11/2026 | Alan | 03/11/2026 |
| Brilho atrás da cabeça na imagem de Consolação de São Jorge: conferir no motor se briga com a auréola | T16 | 03/11/2026 |
| Recalibrar metas "vitória da heurística em difícil" e "Noite Escura na expedição longa" (D-113); forma decidida em D-125 e D-126. Feito na T31 (D-164, D-165); o difícil volta a ser medido no M2 | M2 | 03/11/2026 |
| ~~Criar `docs/backlog/m1.md`~~ Proposta feita e perguntas respondidas por Alan em 04/11/2026 (D-121 a D-126) | Alan | 03/11/2026 |
| Datas das festas dos santos (`feasts.csv`) | Pesquisa do Martirológio (Alan) | 03/11/2026 |
| Heurística do simulador gasta todo o Fervor no milagre de Jorge (rever a política, não os números); entra no passo 0 da rodada de simulação (D-280) | `m2.md` T61 | 03/11/2026 |
| Fundos "xadrez" pintados na imagem (JPG não tem transparência): Diabo de Lodo, Sopro Errante, Sombra, Mãe-Enxame, Moscardo, Enxame e camada da frente do cenário. Ideal: PNG com transparência real ou fundo liso cinza; senão, recorte na T16 | Alan / T16 | 03/11/2026 |
| Consolação de São Bento veio com auréola desenhada (a Direção de Arte pede sem); conferir no motor ou pedir versão sem | T16 / Alan | 03/11/2026 |
| ~~Confirmar qual imagem de Teresinha é o padrão e qual é a Consolação~~ Confirmado por Alan em 03/11/2026: muitas pétalas = Consolação; poucas = padrão | Alan | 03/11/2026 |
| Cenário do Círculo 2 veio sem a camada do meio (só fundo e frente); os redemoinhos (`vfx_hazard_gale`) podem servir de camada animada | T16 | 03/11/2026 |
| ~~Revisar os textos da tela de combate em `docs/balance/ui_text.csv`~~ Revisados e aprovados por Alan em 03/11/2026 (D-114) | Alan | 03/11/2026 |
| ~~Salvar a preferência de velocidade das animações em `settings.json` (screens §3)~~ Feito na T26 | `SaveService` (M1) | 03/11/2026 |
| Ícones de intenção e de condição: hoje são palavras (`Ataque 6 na posição 1`); a T44 também põe ícones de ação nas habilidades, com detalhe ao tocar (D-297, D-299) | `m2.md` T44 | 03/11/2026 |
| Consolação de São Jorge: o brilho atrás da cabeça saiu quase todo no recorte, mas sobra uma faixa clara colada ao rosto; Alan julga no jogo se precisa de versão sem brilho | Alan | 03/11/2026 |
| Compressão VRAM (ETC2/ASTC) das texturas de personagem: hoje importação padrão sem perda | T17 | 03/11/2026 |
| Animação de combate "como Darkest Dungeon" (santo vai até o inimigo e ataca; defesa com reação): Alan achou a atual simples demais. Planejada na trava "abordagem de animação" do roadmap (arte final do M2, ADR-0007); ~~proposta de antecipar~~ Alan decidiu manter no M2 (D-116) | M2 (`m2.md` T35, T52; D-176) | 04/11/2026 |
| Personagens pequenos na tela do celular: continuam pequenos no APK em tela cheia; rever no M2 (D-209) | M2 (`m2.md` T36) | 04/11/2026 |
| Forma de testar a auréola sem depender da sorte: botões de teste na T17 (D-117) | T17 | 04/11/2026 |
| Noite Escura e Consolação de Jorge são da leva antiga (traço diferente da pose normal nova): Alan manteve por enquanto (D-205); rever depois do teste | Alan | 04/11/2026 |
| ~~Folhas de produção (D-206): os santos "andam" entre os nós num corredor com parallax (`_mid` emendável), mas `docs/ui/screens.md` §4 e `specs/expedition.md` têm só a tela de mapa de nós. Decidir se a expedição ganha caminhada lateral e atualizar a spec~~ Decidido: caminhada lateral com bifurcações (D-207); detalhar e atualizar a spec no M1/M2 | M1/M2 | 04/11/2026 |
| ~~Folhas de produção (D-206): tela "Mapa do Inferno" (escolha do círculo em faixas que rolam) não está no fluxo de telas (`screens.md` §2). Decidir onde entra~~ Decidido: ao sair pelo portão da vila no Átrio (D-208); atualizar `screens.md` quando a vila for feita | M2 | 04/11/2026 |
| Linha do chão dos cenários a y ≈ 900 de 1080: a tela de combate hoje põe os pés a y ≈ 456 e as figuras com 300 px. Refazer o leiaute do campo quando os cenários entrarem (resolve também "Jorge pequeno"; confirmado por Alan no APK, D-209) | M2 (arte final) | 04/11/2026 |
| ~~Estados espirituais: as folhas pedem só o **rosto** por estado (`face_*`); hoje Jorge usa o corpo inteiro por estado. Escolher no M2~~ Decidido: corpo inteiro por estado, com imagem sobreposta em Consolação e desolação (D-210) | M2 | 04/11/2026 |
| ~~Santa Rita: a pose de ataque segura o crucifixo à frente "em comando". Confirmar que o gesto é devocional e que a habilidade não trata o crucifixo como arma ou fonte de bônus (`writing-guide.md`, figuras sagradas)~~ Aprovado por Alan (D-211) | Alan | 04/11/2026 |
| Animação estilo Darkest Dungeon (D-210): andar, câmera, avanço e ataque; tela especial do milagre (ex.: Jorge a cavalo); imagem sobreposta de Consolação e de agonia. Precisa de imagens novas por santo (Alan) e da etapa de animação | M2 (`m2.md` T44, T52; D-176) | 04/11/2026 |
| Tempo de um combate no APK (meta do M0: 2 a 4 minutos) ainda não medido | Alan | 04/11/2026 |
| ~~Tela do milagre de São Jorge: em D-210 Alan citou "Jorge atacando com o cavalo", mas a folha `prompts-splash.md` pede Jorge a pé, erguendo a lança, e exclui cavalo e dragão. Confirmar qual vale antes de gerar~~ Vale a folha: a pé, sem cavalo (D-214) | Alan | 04/11/2026 |
| ~~Incenso "revela nós vizinhos" (`expedition.md` §2.2 e §5): com o Portão nível 1, o conteúdo da próxima camada já aparece, então o Incenso só serviria para anular a emboscada. Decidir se ele passa a revelar mais uma camada à frente (mudança de regra)~~ Decidido: revela mais uma camada (D-129) | Alan (T18/T22) | 04/11/2026 |
| ~~Texto da Tentação do Círculo 2 ("O abrigo do vento")~~ Aprovado por Alan (D-142) | Alan (T23) | 04/11/2026 |
| ~~Nomes dos falantes dos eventos (`narrator`, `demon_tempter`) na tela: definir onde ficam os nomes exibidos~~ O agente decide e Alan revisa ao testar (D-151) | T28 | 04/11/2026 |
| Cenário do Círculo 2, trecho 1: os originais têm só 1584×672; ampliados para 2560×1080 ficam pouco nítidos. Pedir versão maior (e a camada `_mid` emendável) para a arte final | Alan (M2) | 04/11/2026 |
| Caminhada: entradas são retângulos com texto e o andar é só um deslize com balanço; ícones de tipo de nó, desenhos de porta/caverna/escada e animação de andar ficam para o M2 (D-210) | M2 (`m2.md` T34, T37, T53) | 04/11/2026 |
| ~~Ilustração do evento "O abrigo do vento" em tamanho maior~~ v02 recebida com 1376×768 (D-153); se houver versão ≥ 1920×1080, fica mais nítida | Alan (T28) | 04/11/2026 |
| Tela do evento: fonte própria (com itálico de verdade) e moldura de pergaminho da caixa de texto ficam para a arte de interface (M2) | M2 | 04/11/2026 |
| ~~Pouso do Círculo 2 em tamanho cheio~~ v02 recebida com 1600×672 (D-156); se houver versão de 2560×1080, fica mais nítida | Alan (T29) | 04/11/2026 |
| Teste de Alan no celular (04/11/2026): nós, provisões, mini-mapa e Tentação funcionam. Problemas: animação de andar, personagens pequenos, parallax da frente ruim. Pedido: caminhada **interativa** — andar até a tenda da Tentação e escolher entrar; no fim do corredor, andar até a entrada da derivação e entrar (em vez de botões). Decidido: entra no M2 com a arte final (D-158); levar ao `backlog/m2.md` | M2 (`m2.md` T33, T37; D-178) | 04/11/2026 |
| ~~T31: com 25 de desolação no fim do combate e Lume alto ×1,0 (D-164), a Noite Escura dá 0,21 por trecho, acima da meta aprovada (0,02–0,10). Escolher: manter e subir a meta, ou 20 e ×1,0 (recomendado: 0,097 e 83% no difícil)~~ Escolhida a A: 20 e ×1,0 (D-165) | Alan | 05/11/2026 |
| ~~Ataques na posição 3 (teste de Alan, 05/11/2026): o Moscardo (`gadfly_sting`, alvo `back_most` nas posições 2 e 3) acerta Teresinha em 90% das vezes e está em 3 dos 4 encontros do M0; a Sombra (`lowest_hp`) também a escolhe. Em 1.200 combates simulados Teresinha recebeu 17 mil de dano, Jorge 13 mil e Bento 3 mil. Decidir se fica assim, se o Moscardo passa a sortear entre 2 e 3, ou se os encontros do M2 ganham variedade~~ Moscardo sorteia entre 2 e 3 (D-168); mais variedade de encontros fica para o M2 | Alan | 05/11/2026 |
| ~~Testes de abuso (glitches, exploits, meta que quebra mecânicas), pedido de Alan em 05/11/2026. Proposta do agente: (1) desde já, testes automáticos de regras invioláveis em cada tarefa; (2) uma tarefa "Caça a exploits" no fim do M2, quando existirem vila, economia e expedição completa; (3) repetir a cada família no M3; (4) teste com jogadores de fora no M4.~~ Aprovado (D-170); entra no backlog do M2 | M2 | 05/11/2026 |
| ~~Roteiro do Prólogo (D-172)~~ Recebido (`docs/narrative/prologue.md`, D-190); faltam as artes (`m2-art-prompts.md`, prioridade 4) | Alan | 05/11/2026 |
| ~~Esqueleto 2D (D-176, D-180)~~ Testado e reprovado; substituído por quadros e poses-chave (D-194, D-195) | — | 05/11/2026 |
| ~~Santo Antão ao vencer Asmodeu: só a tela de novo santo no M2~~ Confirmado por Alan (D-179) | Alan | 05/11/2026 |
| ~~Conselho da vila depois de Asmodeu entra no M2?~~ Fica para o M3 (D-181) | M3 | 05/11/2026 |
| Downloads de bancos de som pela nuvem podem ser bloqueados; se forem, o agente manda a lista e onde baixar, e Alan baixa e envia (D-182) | T54 | 05/11/2026 |
| ~~Sem combate de ensino no M2: dicas na tela?~~ Sim, no primeiro combate e na primeira caminhada (D-191) | T51 | 05/11/2026 |
| ~~Salto do Círculo 1 na fatia do M2~~ Aceito, com o Círculo 1 bloqueado no Mapa do Inferno (D-192) | T49 | 05/11/2026 |
| Prólogo: confirmar na pesquisa do Martirológio a frase de Santa Teresinha (17/07/1897), a abertura da Regra de São Bento e os dados de Santa Luzia (`prologue.md` §7) | Alan | 05/11/2026 |
| ~~Formato dos quadros de animação~~ GIFs do Meta AI com os prompts de `animation-prompts.md`; os de Jorge chegaram (D-197) | — | 05/11/2026 |
| Texto do ato de contrição nas três versões (roteiro, com revisão teológica) (D-198) | Alan | 05/11/2026 |
| Texto das nove vinhetas do leito (D-198) | Alan | 05/11/2026 |
| Roteiro dos flashbacks de antes, por círculo, com as três pessoas da selva (D-198) | Alan | 05/11/2026 |
| Revisão teológica de toda a sequência final antes do M4 (D-198) | Alan | 05/11/2026 |
| A cópia do GDD no Claude Docs (fora do repositório) precisa receber as mudanças de D-198 | Alan | 05/11/2026 |
| Auréola sobre os quadros animados: medir o ponto da cabeça em cada quadro (ou seguir a cabeça de outro jeito) antes de usar os quadros no combate (D-331) | T36/T52 | 10/11/2026 |
| Memória do celular com os quadros: cada personagem ocupa dezenas de MB descomprimido; comprimir texturas no Android e conferir no Redmi (D-330) | T53 | 10/11/2026 |
| ~~Vertigem: fiapos de fundo cinza entre os véus~~ Removidos (D-332) | — | 10/11/2026 |
| Tamanho dos chefes (2 ou 3 lugares) e de Asmodeu: provisório 1,25× a altura dos santos (D-233, D-332); confirmar com a tela de combate nova | T36/T38 (Alan) | 10/11/2026 |
| Alcance do ataque de cada inimigo no combate: hoje vem da tabela de arte (`attack_style`); quando `bosses.md` definir as ações de Asmodeu, Minos e Vertigem, conferir se o tipo de dano de cada ação bate com a animação | T38/T52 | 10/11/2026 |
| ~~Estilo dos efeitos~~ Escolhidos (D-237, D-238) | — | 10/11/2026 |
| Usar no combate de verdade o estilo de cada ação (`AnimationStyle`: golpe, exorcismo, bênção) e a câmera de impacto; os efeitos em código saem e entram folhas de quadros desenhados (D-295) | `m2.md` T59, T52 | 10/11/2026 |
| Arquivos do Drive sem nome descritivo (bosses 5, saints 3, portraits 3, ui/icons 30, vfx 3, props 2, raiz de circle_02): identificar com Alan e renomear ao trazer para o repositório (`drive-inventory.md`) | Tarefa de cada arte | 10/11/2026 |
| Almas, relicário, redemoinhos do Vendaval e faixa de névoa: pedir a Alan na T39/T53 (ele sobe ao Drive ou manda pelo chat, D-246) | Alan / T39, T53 | 10/11/2026 |
| ~~Tentação: trocar "o santo peca e perde o controle" por assédio dos inimigos ou manter só como evento do Peregrino~~ Assédio dos inimigos, como Provação do Círculo; a tenda não muda (D-266, D-267), 12/11/2026 | — | 11/11/2026 |
| ~~Ordem da abertura: abertura → título → Prólogo na primeira vez?~~ Sim (D-266); a tela de entrada com a lanterna convive com essa abertura (D-300), 12/11/2026 | — | 11/11/2026 |
| ~~Mecânica de desbloqueio para cada santo de expansões futuras~~ Pela Obra de Misericórdia ligada à vida do santo (D-275), 12/11/2026. **Falta:** Alan escolher os pares obra–santo | Alan (M3) | 11/11/2026 |
| ~~Qual edifício guarda as conquistas opcionais e a lista~~ Livro das Obras, na Biblioteca; as 14 Obras de Misericórdia (D-275), 12/11/2026. **Falta:** Alan escolher os pares obra–feito, com a fonte | Alan (M3) | 11/11/2026 |
| Simulação das variantes do Lume: as quatro de D-262 e "luz é ver" (D-273), com o prêmio do escuro em experiência (D-274) | `m2.md` T61 | 11/11/2026 |
| ~~Nove decisões da consultoria do Fable~~ Respondidas por Alan (D-266), 12/11/2026 | — | 12/11/2026 |
| ~~Transcrever `docs/fable/04-respostas-de-alan.md` em `decisions.md` (Passo 1 do rumo)~~ Feito: D-267 a D-300 e D-350 a D-362 (`m2.md` T58), 12/11/2026 | — | 12/11/2026 |
| ~~Nove decisões do rumo do Fable, Tentação e ordem da abertura~~ Respondidas (D-266) | — | 12/11/2026 |
| Revisão teológica de Súplica, Domínio, penitências e Esmolas: agente prepara o material com fontes para Alan revisar (D-266) | Agente + Alan, antes dos textos do M3 | 12/11/2026 |
| Números das regras novas (Interceder, desolação por rodadas, Fidelidade, preparo do teste de Fé, dar a Consolação, variante do Lume): só depois do relatório, uma regra de cada vez, mantendo a meta de Noite Escura (D-266 (3) e (4)) | `m2.md` T61 (Alan escolhe) | 12/11/2026 |
| Testar no Redmi as cores da Bíblia de Arte que podem confundir: latão do Círculo 4 e brasa do Círculo 6 contra ouro e âmbar; carmesim do Círculo 7 contra o vermelho de perigo; tamanhos de letra e de toque (D-266 (6), `biblia-de-arte.md` §15) | Alan (APK da T44) | 12/11/2026 |
| Moradas em 3 marcos (D-266 (5)): o que cada marco (Moradas 1, 4 e 7) muda de forma visível para o jogador; decidir antes do Carmelo (`village-economy.md` §5) | Alan + simulador (M3) | 12/11/2026 |
| Texto da origem das Esmolas (restituição, D-279), como criação do jogo, e os nomes "Despojos" e "Esmolas" em `ui_text.csv` | Alan (antes da T42) | 12/11/2026 |
| Frases do Narrador nos momentos fortes (D-277) | Alan (M3) | 12/11/2026 |
| Nomes das peças de equipamento de cada santo (D-278) | Alan (M3, Forja) | 12/11/2026 |
| Papel de São Francisco sem o Jardim (D-292) | Alan | 12/11/2026 |
| ~~O GDD ainda descreve o que mudou: atualizar ou deixar as specs valerem?~~ Atualizar: GDD v1.2 (D-364), 12/11/2026 | — | 12/11/2026 |
| Arte para o M2 vinda da consultoria: poses sentadas dos 3 santos e a fogueira (prompts em `docs/fable/03-animacao.md` §16.2, D-361); 35 poses de ação dos 7 inimigos (D-354); peças da interface "capela às escuras", 10 ícones de ação e 3 peças da auréola (`biblia-de-arte.md` §13, lotes 1 a 3) | Alan (T44, T52, T53) | 12/11/2026 |
| Santo piloto em vídeo (Santo Antão, cerca de 450 créditos no Wan 3; saldo atual 10) no começo do M3 (D-266 (7), D-356) | Alan (M3) | 12/11/2026 |
