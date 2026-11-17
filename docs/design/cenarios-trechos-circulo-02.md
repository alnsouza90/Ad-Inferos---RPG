# Cenários de cada trecho do Círculo 2 · proposta v2 (D-444, D-445)

Pedido de Alan (17/11/2026): alinhar trecho a trecho qual cenário cada lugar usa, com regras para misturar céus e peças sem enjoar. Folha com tudo o que já existe em pixel: `art_source/environments/circles/circle_02/pixel/`.

## Regras de montagem (Alan, D-445)

1. **Peças únicas nunca se repetem.** O trono de Minos (que já vem no desenho dele e no meio do Trecho 1) aparece **uma vez só**. O mesmo vale para a arena de Asmodeu e para o salão do júri.
2. **Porta só em parede construída** (muro, arcada, claustro). **Caverna só onde há parede de rocha.**
3. **"Seguir em frente" não tem imagem:** a companhia anda até a borda direita e passa para a tela seguinte.
4. **Lutas comuns usam cenários genéricos**, que podem se repetir.
5. **Céus e peças se misturam** para fazer lugares diferentes, desde que respeitem as regras 1 e 2.

## As peças

| Tipo | Peças | Uso |
| --- | --- | --- |
| Céus (fundo) | T1 fundo, céu de tempestade, olho da tempestade, T3 fundo | Livres, misturáveis |
| Meios genéricos | Meio liso, parede de rocha, T2 meio (torres quebradas), T3 meio (claustro tombado) | Livres, misturáveis |
| Meios únicos | T1 meio (com o trono ao longe), arena do chefe, **salão do júri (novo)**, **margem do Tigre (nova)** | Uma vez só, no seu lugar |
| Frentes | T1, T2, T3 e chefe | Por trecho |
| Peças soltas | Muro, arcada, lajes, pináculo; tenda, relicário, almas | O muro e a arcada são "parede construída" (aceitam porta) |
| Entradas | Porta (em muro ou arcada), escada, caverna (só na parede de rocha) | Regra 2 |

## Cada lugar

| Lugar | Céu | Meio | Peças | Observação |
| --- | --- | --- | --- | --- |
| **Chegada ao Círculo 2** (primeira tela do trecho 1) | T1 fundo | **T1 meio com o trono** (única vez) | — | Minos não está ali: o trono vazio ao longe anuncia o juiz |
| Corredor e lutas comuns, trecho 1 | T1 fundo ou tempestade | Meio liso ou parede de rocha | Lajes, pináculo (sorteados) | Genérico |
| Corredor e lutas comuns, trecho 2 | Tempestade | T2 meio ou meio liso | Muro, pináculo | Genérico |
| Corredor e lutas comuns, trecho 3 | T3 fundo ou tempestade | T3 meio ou parede de rocha | Arcada, lajes | Genérico |
| Elite (Pecado Encarnado) | Olho da tempestade | Genérico do trecho | — | O céu muda: algo maior está ali |
| **Minos** (última sala do trecho 1) | — (interior) | **Salão do júri** (calabouço de pedra, sem trono: o trono vem com Minos) | — | Entra-se por uma **porta num muro** no fim do trecho 1 |
| Tentação | Tempestade | Meio liso | Tenda | Abrigo aparente no vento |
| Relíquia | Céu do trecho | Parede de rocha | Arcada + relicário | Nicho protegido |
| Encontro com alma | Tempestade | Meio liso | Almas + pináculo | Lugar aberto |
| **Peixe do Tigre** (trecho 3) | T3 fundo (reaproveitado) | **Margem do Tigre** (nova) | Peixe na água (novo), lajes | Combina com o trecho 3 |
| Asmodeu | Chefe fundo | Arena do chefe (sem trono) | — | Única |
| Pouso / Vigília | — | — | — | Já feitos |

## O que falta gerar

| Peça | Para quê | Custo |
| --- | --- | --- |
| Salão do júri (meio interior: calabouço de pedra, colunas, correntes, luz fraca) | Lugar de Minos | cerca de 25 |
| Margem do Tigre (meio: rocha e água escura parada) | Lugar do Peixe | cerca de 25 |
| Peixe na água | Conteúdo do nó | cerca de 10 |

**Total: cerca de 60 gerações.** No jogo, o motor monta cada tela com céu, meio, peças e frente, segundo estas regras, sorteando com a semente do mapa (a mesma partida sempre igual).

## Continuidade entre os nós · proposta v3, para aprovar

Pedido de Alan (17/11/2026): a passagem de um nó para o outro tem de ser suave e caber no cenário. Exemplo: o nó antes de Minos **tem de acabar numa porta**, então esse nó precisa de uma parede construída. A continuidade é essencial para a imersão.

**Ideia:** cada tela tem uma **entrada** (borda esquerda) e uma **saída** (borda direita). A saída de uma tela e a entrada da seguinte são **a mesma passagem**, vista dos dois lados.

| Passagem | Fim da tela anterior (direita) | Começo da tela seguinte (esquerda) | Como se anda |
| --- | --- | --- | --- |
| Aberta | Chão que continua | **Mesmo céu e mesmo meio**; só as peças e a frente mudam | Os santos saem pela borda direita, a câmera desliza e eles entram pela esquerda |
| Porta | Muro ou arcada com a porta | Interior (salão do júri) ou claustro (trecho 3) | Andam até a porta, a tela escurece, abre do lado de dentro |
| Caverna | Parede de rocha com a boca da caverna | Fundo de rocha (parede de rocha) | Igual à porta |
| Escada | Escada que desce | Outro nível (troca de meio, mesmo céu) | Descem e somem; a tela escurece |

**Regras de montagem:**

1. **Entre duas passagens fechadas (porta, caverna, escada), o lugar é um só:** o céu e o meio ficam iguais e só as peças soltas e a frente variam. Assim a caminhada parece um lugar contínuo, e não telas sorteadas.
2. **O céu só muda depois de uma passagem fechada**, ou devagar, durante a caminhada (por exemplo, a tempestade fecha ao chegar na Elite).
3. **O motor olha para a frente:** antes de montar a tela N, ele vê o que vem em N+1. Se N+1 pede porta, a tela N recebe um muro ou uma arcada com a porta no fim. Se pede caverna, recebe a parede de rocha.
4. **Bifurcação:** a tela da bifurcação mostra as duas saídas no fundo, no mesmo lugar. Por exemplo, o chão que segue para a direita e uma porta num muro. Por isso ela é montada com as peças que as duas saídas pedem.
5. **Minos:** a última tela do trecho 1 antes dele é sempre de **muro com porta**. Entra-se pela porta e o salão do júri abre com a companhia já dentro.
