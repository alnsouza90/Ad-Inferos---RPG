# ADR-0007 · Abordagem de animação definida pelo piloto de arte

**Situação:** Decidida por Alan em 03/11/2026 (primeira abordagem); esqueleto 2D para os personagens desde 05/11/2026 (D-176, seção no fim)

## Contexto

Arte gerada por IA vem em imagens inteiras; rig exige separar e reconstruir partes. A decisão do responsável: testar primeiro só poses; se ficar amador, rig para movimentos simples e poses para o resto.

## Decisão

A `CombatantView` expõe uma interface única (`play_idle`, `play_action`, `play_hit`, `play_fall`) e duas implementações possíveis. O piloto com São Jorge escolhe uma.

## Por quê

- O resto do código não depende da escolha.

## Consequências

- Atualizar este ADR com o resultado do piloto.

## Decisão de 03/11/2026

As poses de ataque, golpe recebido e queda não saíram satisfatórias na geração por IA. Alan aprovou **animar no motor a partir de uma única imagem por estado** (padrão, Noite Escura, Consolação):

- **Ataque:** avanço rápido na direção do alvo, inclinação e retorno; rastro ou faísca no golpe.
- **Golpe recebido:** clarão vermelho breve, tremor e pequeno recuo.
- **Queda:** tombar devagar, escurecer e dessaturar; a auréola se apaga.

Plano B, se ficar amador no piloto: recortar a imagem em partes e animar com `Skeleton2D`. A interface `CombatantView` não muda em nenhum dos casos.

## Atualização de 04/11/2026

Alan gerou poses de ataque, golpe recebido e queda de São Jorge com qualidade suficiente. A animação no motor passa a **trocar para a pose durante o movimento**: avanço com a pose de ataque, recuo com a pose de golpe, pose de queda enquanto caído. Sem a pose, vale o comportamento anterior (só a imagem do estado se move). A animação completa no estilo Darkest Dungeon continua no M2 (D-116). Uma pose neutra para recorte em partes ficou guardada em `art_source/` para o plano B.

## Decisão de 05/11/2026 · esqueleto 2D (D-176, D-180)

Para animar como em Darkest Dungeon (andar, atacar com avanço, defender, golpe recebido e queda), Alan decidiu usar **esqueleto 2D** nos personagens (santos, inimigos, elites e chefes); cenário, fundo, almas e milagres seguem com animação no motor (tweens, partículas, shaders), e troca de quadros só quando indicada (ex.: relicário fechado e aberto). Substitui "uma imagem por estado" de 03/11/2026 para os personagens.

Como ficou no piloto com São Jorge (T35):

- **Arte:** Alan entrega a pose neutra (`rig_base`). O agente recorta as peças com `tools/art/rig_cut.py` a partir de um mapa de corte por personagem (`tools/art/rigs/<id>.json`: contorno, junta, pai e ordem de desenho de cada peça). O que fica escondido atrás de uma peça da frente é pintado a partir das cores da própria peça; sob objetos finos (lança) a cor é copiada de logo acima ou abaixo, para as pregas e dobras continuarem retas. Sai um PNG por peça e um `RigDef` (`assets/characters/<grupo>/<id>/rig/<id>_rig.tres`).
- **Motor:** `RigFigure` monta um `Skeleton2D` com um `Bone2D` por peça; as peças são desenhadas numa lista à parte, na ordem de profundidade, e cada uma segue o seu osso por um `RemoteTransform2D` (a ordem de desenho não depende da árvore dos ossos e não usa `z_index`, que vazaria para o resto da tela).
- **Movimentos compartilhados:** `RigMotions` guarda os movimentos de um corpo humano (parado, parado em Noite Escura, andar, atacar, defender, golpe recebido, queda) por nome de osso; todo personagem com os mesmos nomes de osso usa os mesmos movimentos. Corpos diferentes (inseto voador, fera, chefes) ganham o seu conjunto.
- **Tela de combate:** a interface da `CombatantView` não mudou (`play_idle`, `play_action`, `play_hit`, `play_fall`); com `CombatantArt.rig` preenchido, ela usa o esqueleto no lugar das imagens de pose. Sem esqueleto, vale o comportamento anterior.
- **Estratégia para muitos personagens (proposta a Alan em 05/11/2026, aguardando decisão):** pose neutra "de mãos vazias" (sem arma, escudo e capa, membros afastados) mais cada objeto gerado sozinho; o agente marca as juntas, recorta e reaproveita os movimentos por tipo de corpo.
