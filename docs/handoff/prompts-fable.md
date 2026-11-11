# Prompts para a sessão de consultoria (Fable)

Cole um por vez, **na mesma sessão**, aberta neste repositório. Cada etapa termina com uma parada: responda "segue" para continuar ou corte ali. Contexto: `docs/handoff/dossie-fable.md`.

## Prompt 1 · Orientação

```
Você vai atuar como consultor sênior de game design, sistemas e direção de arte do Ad Inferos. Fale comigo em PT-BR, em linguagem simples.
Leia primeiro, por inteiro, docs/handoff/dossie-fable.md: ele resume todo o projeto e as decisões até hoje. Depois leia CLAUDE.md. Não leia mais nada nesta etapa.
Regras: NÃO altere código, dados, testes nem documentos existentes; escreva só arquivos novos em docs/fable/. Economize tokens: só abra outro arquivo se o dossiê não bastar, e diga antes qual e por quê (use a tabela do §9 do dossiê). Respeite as regras do §2 do dossiê; se uma ideia sua quebrar alguma, diga e ofereça alternativa.
Tarefa: em até 15 linhas, diga (1) o que entendeu do jogo, (2) as 5 maiores fragilidades que já enxerga, (3) o plano das próximas etapas com os arquivos que pretende abrir. Pare e espere meu "segue".
```

## Prompt 2 · Núcleo do jogo

```
Etapa 2: núcleo do jogo. Analise o laço vila → expedição → combate → volta e como Desolação, Lume, Fervor, provisões, Esmolas e semanas se reforçam ou se anulam (§§3–4 do dossiê). Para cada problema: causa, efeito no jogador, proposta concreta, sistemas afetados, custo (baixo/médio/alto), risco e se precisa de simulação. Números só como proposta para o simulador. Entregue em docs/fable/01-nucleo.md (máx. 4 páginas) e um resumo de 10 linhas aqui. Pare e espere.
```

## Prompt 3 · Combate e progressão

```
Etapa 3: combate e progressão. Avalie a profundidade tática (posições, intenções, tipos de dano, condições, restos dos Corpóreos), a curva dos círculos e a progressão dos santos (níveis, equipamento, relíquias, Carismas e o desbloqueio de santos sempre por mecânica, D-262). Use os números do dossiê; abra um CSV só se for indispensável e diga qual. No máximo 8 melhorias, em ordem de impacto ÷ custo. Entregue em docs/fable/02-combate-progressao.md e um resumo aqui. Pare e espere.
```

## Prompt 4 · Arte, apresentação e identidade

```
Etapa 4: arte e apresentação. Com base no dossiê (e, se precisar, só nas seções de direção visual de docs/art/art-direction.md, lembrando que a interface agora segue D-257/D-258), proponha a identidade da abertura, da vila, da conclusão de círculo e das conquistas opcionais, no clima de Darkest Dungeon mas com identidade católica própria e respeitando o §2 do dossiê (figuras sagradas só como cena). Inclua uma lista priorizada das artes a gerar (o que é, para qual tela, tamanho). Entregue em docs/fable/03-arte.md e um resumo aqui. Pare e espere.
```

## Prompt 5 · Síntese e plano

```
Etapa final: junte tudo em docs/fable/00-sintese.md (máx. 3 páginas): as 10 recomendações mais importantes em ordem; o que mudaria em cada documento de especificação (sem editá-los); as decisões que precisam de mim; e um plano em etapas pequenas para o agente que implementa, encaixado no backlog do M2/M3 (§5 do dossiê). Encerre.
```

**Para gastar ainda menos:** junte os prompts 3 e 4 numa etapa só.
