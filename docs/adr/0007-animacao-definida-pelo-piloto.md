# ADR-0007 · Abordagem de animação definida pelo piloto de arte

**Situação:** Decidida por Alan em 03/11/2026 (primeira abordagem); desde 05/11/2026, quadros e poses-chave com a ligação feita no motor (D-194, seção no fim)

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

## Decisão de 05/11/2026 · quadros e poses-chave (D-194, D-195)

Alan decidiu animar os personagens com esqueleto 2D (D-176). O piloto com São Jorge (peças recortadas da pose neutra, 7 movimentos) foi reprovado: girar peças de uma imagem parada parece um boneco articulado e não chega ao que se espera de Darkest Dungeon. Os GIFs de exemplo de Alan (parado com a capa ao vento; poses de andar, correr, golpe, defesa, golpe recebido e queda) mostraram o caminho, aprovado por ele:

- **Parado e andar:** quadros desenhados em ciclo (6 a 9), entregues como sprite sheet ou GIF (D-196).
- **Ações:** poses-chave (atacar: preparar e golpear; defender; golpe recebido; queda: ajoelhar e caído).
- **Motor:** a ligação entre as poses (deslizar até o alvo, câmera que aproxima, tremor, clarão, esticar e encolher, partículas), respiração e capa sutis; cenário, fundo, almas e milagres com tweens, partículas e shaders.
- A interface `CombatantView` continua a mesma. O código do esqueleto foi retirado antes do merge (PR #45).
