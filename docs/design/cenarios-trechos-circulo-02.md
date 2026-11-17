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
