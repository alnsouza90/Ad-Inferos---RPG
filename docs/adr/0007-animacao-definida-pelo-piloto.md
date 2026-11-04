# ADR-0007 · Abordagem de animação definida pelo piloto de arte

**Situação:** Decidida por Alan em 03/11/2026 (primeira abordagem); revisar depois do teste no piloto

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
