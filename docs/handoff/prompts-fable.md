# Prompts para a sessão de consultoria criativa (Fable)

Cole um por vez, **na mesma sessão**, aberta neste repositório (branch `main`). Cada etapa termina com uma parada: responda "segue" para continuar ou corte ali.

Contexto preparado:
- `docs/handoff/dossie-fable.md`: o projeto inteiro resumido.
- `docs/handoff/pranchas/`: 6 imagens com toda a arte e o jogo atual.

**Se a cota apertar:** as etapas que mais valem são a 2 (design), a 4 (animação) e a 5 (rumo).

## Prompt 1 · Imersão

```
Você é diretor criativo e de game design convidado do Ad Inferos. Seu papel é pensar fora da caixa: questionar, propor ideias arrojadas e ajudar a definir o rumo do jogo antes do M3. Fale em PT-BR, linguagem simples.
Leia por inteiro docs/handoff/dossie-fable.md e CLAUDE.md. Depois olhe as 6 imagens de docs/handoff/pranchas/ (01_santos, 02_inimigos_comuns, 03_elites, 04_chefes, 05_cenarios_circulo2, 06_jogo_hoje). Se as imagens não abrirem (arquivos do Git LFS), rode antes: git lfs pull --include="docs/handoff/pranchas/*". Não leia mais nada agora.
Regras: não altere código, dados, testes nem documentos existentes; escreva só arquivos novos em docs/fable/. Seja ousado, mas respeite o §2 do dossiê (sem acaso no acerto, santos nunca pecam nem perdem o controle, figuras sagradas só como cena, Sufrágios nunca gastos, santos nunca comprados); se uma ideia boa esbarrar numa regra, diga qual e proponha o caminho que a respeita. Não escreva textos finais de narrativa nem citações: proponha estruturas e marque "proposta".
Em até 15 linhas: sua primeira impressão do jogo como jogador e como diretor, o que tem de mais forte, o que mais te preocupa e o que quer investigar. Pare e espere meu "segue".
```

## Prompt 2 · A alma do jogo e ideias arrojadas de design

```
Etapa 2: game design. Pergunte "o que faz este jogo ser inesquecível e diferente de Darkest Dungeon?". Analise o laço vila → expedição → combate → volta, a desolação, o Lume, o Peregrino e as virtudes, os santos e o calendário litúrgico. Proponha de 5 a 8 ideias arrojadas que deem identidade própria ao jogo (mecânicas, estrutura da campanha, relação entre santos, o Peregrino como presença no jogo, o tema da graça e da provação virando regra). Para cada ideia: o que muda na experiência, por que é melhor, risco, custo e se dá para testar ainda no M2. Inclua 3 coisas que você cortaria ou simplificaria. Entregue docs/fable/01-design.md e um resumo aqui. Pare e espere.
```

## Prompt 3 · Arte, estilo e linguagem visual

```
Etapa 3: arte. Com base nas pranchas, analise a coerência do estilo entre santos, inimigos, elites, chefes, cenários e interface (a interface segue D-257/D-258: clima Darkest Dungeon, preto e cinza, ferro forjado). Diga o que funciona, o que destoa e por quê, citando personagens pelo nome. Proponha uma linguagem visual própria do Ad Inferos: luz e sombra como tema (graça × escuridão), cor por círculo, como o sagrado aparece sem virar bônus, como a desolação e a Consolação se veem nos personagens e no cenário. Indique o que corrigir nas artes existentes antes de gerar mais (os 9 santos sem arte e Lúcifer ainda faltam). Entregue docs/fable/02-arte.md e um resumo aqui. Pare e espere.
```

## Prompt 4 · Animação procedural

```
Etapa 4: animação. Hoje os personagens são animados por quadros (stop motion gerado por IA) e o motor liga as poses: deslizar até o alvo, rastro, impacto com câmera, sangue, efeitos de magia e bênção, respiração no parado, auréola. Abra docs/adr/0007-animacao-definida-pelo-piloto.md e a seção "Animação de personagens" de docs/memory/lessons.md para ver o que já foi tentado e rejeitado (o esqueleto 2D foi reprovado). Proponha o "núcleo" de animação procedural que dê vida e peso ao combate com o menor número de quadros desenhados: o que o motor pode fazer sozinho (deformação, tremor, luz, partículas, câmera, tempo, silhueta) e como cada santo e cada família de inimigos ganha personalidade de movimento. Pense em como animar as dezenas de inimigos das pranchas sem gerar vídeo para cada um. Priorize pelo efeito na sensação do jogador. Entregue docs/fable/03-animacao.md e um resumo aqui. Pare e espere.
```

## Prompt 5 · O rumo: o que corrigir no M2 antes do M3

```
Etapa final: rumo. Junte tudo e responda: se você fosse o diretor, como o jogo deveria ser daqui para frente? Em docs/fable/00-rumo.md (máx. 3 páginas): (1) a visão em um parágrafo; (2) o que corrigir ou mudar ainda no M2, em ordem, com motivo; (3) o que entra no M3 e o que fica para depois; (4) as decisões que precisam de mim, com sua recomendação em cada uma; (5) um plano em etapas pequenas para o agente que implementa, encaixado no backlog (§5 do dossiê). Encerre.
```
