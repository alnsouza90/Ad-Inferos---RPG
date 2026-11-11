# 4 · Respostas de Alan e encaminhamento

Versão 1.0 · 11/11/2026 · registro das respostas dadas por Alan no chat, mais os três estudos que ele pediu (Carismas, equipamento, origem das Esmolas).

**Para o agente de implementação:** este arquivo **não** substitui `docs/memory/decisions.md`. O consultor não pode editar documentos existentes. Leve cada linha da tabela do §1 para o registro de decisões, com o número D seguinte, e só então mexa em especificações.

## 1. Respostas de Alan (11/11/2026)

| # | Assunto | Resposta de Alan | O que significa |
| --- | --- | --- | --- |
| 1 | Pecados como assédio dos inimigos (pendência de D-262) | **Sim** | O assédio é a mecânica de ambiente do círculo (a "Provação do Círculo"): o Pecado Encarnado a aplica com força, o chefe a cobra, resistir dá prêmio. A tenda da Tentação não muda (D-141). Entra na T38 (`bosses.md`). Proposta F-09. |
| 2 | Interceder | **Sim, simular** | Ação comum de todo santo: tomar para si desolação ou uma condição do companheiro. Proposta F-01. |
| 3 | Desolação de fim de combate por rodadas | **Sim, simular** | Reabre o valor 20 de D-165; a meta de Noite Escura fica a mesma. Proposta F-07. |
| 4 | Preparar o teste de Fé | **Aviso e bônus** | Aviso na intenção inimiga e bônus pequeno pela oração da companhia e pela Vigília. Proposta F-04. |
| 5 | Sair da Noite Escura jogando | **Sim, simular** | Segunda saída pela Fidelidade. Proposta F-05. |
| 6 | Purificação e Carismas | **"Quero simplificar os Carismas"** | Os Carismas ficam, mais simples. Estudo no §2. |
| 7 | Lume: "luz é ver" | **Sim, incluir na simulação** | Quinta variante, ao lado das 4 de D-262. Propostas F-12 e F-13. |
| 8 | Esmolas ×1,5 com Lume baixo | **Trocar por outro prêmio** | Sugestão para o simulador: experiência (ver §5). |
| 9 | Conquistas opcionais e santos de expansão (pendências de D-262) | **Sim, "Livro das Obras" na Biblioteca** | As 14 Obras de Misericórdia, sem prêmio de poder; cada santo de expansão chega pela obra ligada à vida dele (Alan escolhe os pares). Proposta F-14. |
| 10 | A luz pálida no Mapa do Inferno | **Sim** | Proposta F-03. |
| 11 | O Narrador do Prólogo dentro do jogo | **Sim** | Poucas frases; a escrita é de Alan. Proposta F-15. |
| 12 | Equipamento | **Não cortar.** "Se tiver compra de itens no futuro, seria uma boa: equipamentos melhores melhoram o personagem. Pensar nisso, validar e, se sim, criar o que precisa para complementar de forma simples." | Estudo no §3. Retiro a recomendação de "um espaço só". |
| 13 | De onde vêm as Esmolas | **Não está definido; é um problema.** "Trazer esmolas do Inferno." Pediu sugestões coerentes com a proposta; se não houver jeito, fica só como mecânica. | Estudo no §4. |
| 14 | Rodada de simulação antes de produzir os Círculos 3 a 5 | **Sim, aceito** | Regras 2, 3, 5 e 7 simuladas antes da produção. Plano no §5. |

## 2. Estudo · Carismas mais simples

**Como está hoje:** 2 Carismas por santo; cada um troca até 2 habilidades e o traço. São 24 Carismas e cerca de 72 peças ainda por desenhar. A troca custa 150 Esmolas.

**Proposta (uma regra só):**

1. **O santo como ele é hoje já é o primeiro Carisma.** Nada a desenhar: o kit atual ganha o primeiro nome que o GDD já dá (Jorge: "Cavaleiro").
2. **O segundo Carisma troca o traço e uma habilidade.** Só isso. (Jorge: "Matador de Dragões" teria outro traço e uma habilidade diferente.)
3. O jogador escolhe entre os dois na Casa de Exercícios, como já previsto.

**Quanto se economiza:** de cerca de 72 peças para **24** (12 traços e 12 habilidades). E os três santos iniciais não mudam em nada.

**O que continua:** os nomes dos Carismas do GDD §3; a troca na Casa de Exercícios; o custo de troca.

**A Purificação (proposta F-06) se encaixa aqui sem conteúdo novo.** Em vez de "marcas", a Purificação pode ser **o que abre o segundo Carisma**: o santo que atravessou a Noite Escura amadurece um novo modo de servir. Para ninguém ficar travado, o nível 4 também abre.

- **Problema que resolve:** o tamanho do conteúdo, e a Purificação fraca (+25% de experiência).
- **Impacto no jogador:** uma escolha clara por santo, em vez de uma tela de montagem; e um motivo para atravessar a Noite.
- **Sistemas:** `village-economy.md` §9, `combat.md` §13, `saint-kits.md`, `desolation.md` §4.3.
- **Custo:** médio (24 peças; o conteúdo de cada uma é de Alan).
- **Risco:** o segundo Carisma virar "o melhor". Os dois precisam ser trocas, não melhorias.
- **Simulação:** sim, por santo, quando as peças existirem.

**Pergunta para Alan (A):** o segundo Carisma abre **(a)** no nível 3, como hoje; ou **(b)** na primeira Purificação do santo, ou no nível 4 se ele nunca passou pela Noite? Recomendo **b**.

## 3. Estudo · Equipamento: vale a pena?

**Validação: sim, vale.** Três motivos:

1. **Combina com a sua visão de dificuldade (D-166):** voltar, se equipar e tentar de novo faz parte da estratégia. O equipamento é o jeito mais claro de o jogador sentir "gastei e fiquei mais forte".
2. **A economia precisa dele.** A meta é o jogador pagar 70% a 80% do essencial. Sem equipamento, sobram Esmolas no meio da campanha.
3. **Com dois espaços há decisão de verdade:** primeiro o ataque ou a resistência? Primeiro Jorge ou Teresinha? Por isso **retiro** a minha sugestão de juntar tudo num espaço só.

**O que já existe na especificação e eu manteria igual:**

- 2 espaços por santo, próprios dele: **Instrumento** (+10% de dano e cura por nível acima do 1) e **Hábito** (+8% de vida por nível acima do 1).
- 3 níveis; nível 2 por 300 Esmolas, nível 3 por 800; feito na Forja (Santo Elói), que entra no M3.

**O que falta para ficar completo, de forma simples (proposta):**

| # | Complemento | Por quê | Custo |
| --- | --- | --- | --- |
| 1 | **Prévia na Forja:** antes de pagar, a tela mostra o antes e o depois ("Estocada 7 → 8", "Vida 32 → 35") | O jogador vê o que está comprando | Baixo |
| 2 | **Nome de cada peça**, tirado do que o santo já carrega na arte (a lança e o escudo de Jorge, o báculo de Bento, o crucifixo com rosas de Teresinha) | Dá cara ao item sem inventar nada; os nomes e a origem são de Alan | Baixo |
| 3 | **A peça aparece na ficha do santo** com o nível (I, II, III) | O progresso fica visível | Baixo |
| 4 | **Sugestão automática em "Planejar a semana"**: "Você pode melhorar o Hábito de Bento" | Combina com as sugestões que a tela já terá | Baixo |
| 5 | **Uma rodada do simulador de economia** com a Forja ligada | Confirmar a meta de 70% a 80% | Médio |

**O que eu não faria agora:** efeitos especiais por peça (por exemplo, "nível 3 dá um poder novo"). Seriam 24 efeitos a desenhar e equilibrar, e as relíquias já fazem esse papel. Se um dia quiser, entra só no nível 3 e só no Instrumento.

**Cuidado de tom:** equipamento se **forja**; relíquia se **encontra**; santo **chega**. Nada sagrado se compra. Isso já está respeitado.

- **Simulação:** sim (economia).
- **Regras do §2 do dossiê:** respeita.

**Pergunta para Alan (B):** o equipamento fica só com números melhores **(a)**, ou você quer também um efeito especial no nível 3 **(b)**? Recomendo **a** na versão 1.

## 4. Estudo · De onde vêm as Esmolas

Tudo aqui é **proposta, criação do jogo**, e deve passar pela revisão teológica prevista. Não escrevi texto final; só a ideia de cada caminho.

**O que a explicação precisa cobrir (as regras que já existem):**

- as Esmolas aparecem ao vencer combates;
- ficam "não garantidas" até o Pouso, que as **consagra**;
- perdem-se na derrota;
- no Círculo 4, recebê-las pesa na alma (Ouro Maldito);
- Mamom é vencido pela **renúncia**;
- na vila, pagam obras: Enfermaria, Despensa, Forja, reformas.

### Caminho 1 · O que foi negado aos pobres (recomendado)

- **A ideia:** o Inferno guarda o que os homens **negaram a quem precisava**: o ouro retido, o pão não partilhado. Os demônios vigiam esse tesouro. A companhia não saqueia: ela **restitui**. O que era ganância volta a ser esmola.
- **Como cobre cada regra:**
  - vem dos combates, porque são os demônios que guardam;
  - **só vira Esmola no Pouso**, quando é consagrado. Antes disso é só ouro do abismo. Dá até para ter dois nomes na tela: "Despojos" no caminho e "Esmolas" depois do Pouso, no lugar de "não garantidas" e "garantidas";
  - perde-se na derrota, porque o abismo toma de volta;
  - o **Ouro Maldito** do Círculo 4 e a renúncia de Mamom ganham sentido pleno: ali o ouro ainda está "vivo", e segurá-lo custa;
  - na vila, tudo é gasto em obras de cuidado, nunca guardado.
- **Por que eu recomendo:** é o único caminho que explica **todas** as regras sem mudar nenhuma, e ainda dá uma lição: o mesmo ouro condena quem o retém e socorre quando é dado.
- **Risco:** a imagem de santos "pegando ouro". O texto precisa dizer **restituir**, nunca "saquear" ou "ganhar". E o prêmio do Lume baixo já não será ouro (resposta 8), o que ajuda.

### Caminho 2 · As esmolas dos vivos

- **A ideia:** as Esmolas não vêm do Inferno. Vêm **da terra**: são as esmolas e as orações que os fiéis oferecem pelo moribundo, em nome dos santos. A mulher idosa à cabeceira é o rosto disso. Cada vitória da companhia no abismo corresponde a alguém, na terra, fazendo o bem por ele.
- **Ponto forte:** é a comunhão dos santos, que já fundamenta o jogo (D-198), e liga a vila ao leito.
- **Ponto fraco:** não explica bem por que a esmola depende de vencer combates, nem por que se perde na derrota, nem o Ouro Maldito.
- **Risco:** pode soar como "pagar pela salvação". Precisa de cuidado no texto.

### Caminho 3 · As boas obras esquecidas do Peregrino

- **A ideia:** em cada círculo estão, perdidas, as poucas esmolas que o Peregrino deu em vida. Os demônios as escondem; os santos as recolhem como testemunho a favor dele. O Livro de Tobias, que já é a fonte de Asmodeu e de São Rafael no Círculo 2, fala do valor da esmola (Alan confere os capítulos 4 e 12).
- **Ponto forte:** é a ideia mais bonita e a mais ligada ao leito.
- **Ponto fraco, e grave:** essas obras **não poderiam ser gastas** na Forja. Seria o mesmo erro que você evitou com os Sufrágios. Por isso **não recomendo como moeda**.
- **Uso possível:** como **narrativa**, não como moeda. Por exemplo, uma boa obra esquecida por círculo, encontrada no Encontro com a alma ou no flashback.

### Caminho 4 · Só mecânica

- Nenhuma explicação. A palavra "Esmolas" fica, e o jogo não comenta.
- É honesto e não cria risco. Mas deixa um buraco bem no nome da moeda.

**Pergunta para Alan (C):** qual caminho? **(1)** restituição · **(2)** esmolas dos vivos · **(3)** só como narrativa, junto com 1 ou 4 · **(4)** só mecânica. Recomendo **1**, com a ideia do **3 guardada para a narrativa**.

## 5. Plano da rodada de simulação (resposta 14)

Ordem sugerida, uma regra de cada vez e depois todas juntas. Todos os números são pontos de partida.

| Passo | Regra | O que variar | Meta |
| --- | --- | --- | --- |
| 0 | Preparar a heurística do simulador | Ensinar a Interceder, a contar rodadas e a jogar sem ver o alvo; corrigir o gasto de todo o Fervor no milagre de Jorge (pendência antiga) | Sem isso, os resultados enganam |
| 1 | Desolação por rodadas (resposta 3) | Base 6, 8 ou 10; +2, +3 ou +4 por rodada a partir da 3ª | Luta média perto de 20; Noite Escura por trecho em 0,02 a 0,10 (D-164); equipe de dano e equipe de proteção com diferença menor que 25% |
| 2 | Interceder (resposta 2) | Transferência de 10, 15 ou 20; sem multiplicadores | Metas atuais de Noite Escura; conferir o abuso com a Consolação |
| 3 | Fidelidade (resposta 5) | 2, 3 ou 4 combates de pé | Metade das Noites terminando pela Fidelidade; Prostração rara |
| 4 | Teste de Fé com preparo (resposta 4) | +5% por companheiro (máx. +10%); Vigília +5%; teto 60% ou 70% | Alan escolhe a taxa de Consolação pelo relatório |
| 5 | Lume (respostas 7 e 8) | As 4 variantes de D-262 e a quinta ("luz é ver"); prêmio do Lume baixo em experiência (+25% ou +50%) no lugar das Esmolas | Diferença sentida entre as faixas; a Vela vira compra comum |
| 6 | Tudo junto | — | Expedição longa com 0,5 a 1,5 Noite Escura (D-126) |

Relatório em `docs/balance/sim-reports/`, com os números novos só depois da aprovação de Alan, como já é a regra.

## 6. O que cada resposta destrava

| Quando | O quê |
| --- | --- |
| Já, na T38 | A Provação do Círculo 2 em `bosses.md`: a ação de assédio da Vertigem, o prêmio por resistir, e o Vendaval com uma resposta comum |
| Na T55 e T56 | A rodada de simulação do §5; incluir "enrolar o combate" na lista da caça a exploits |
| Na tela do Mapa do Inferno (T49) | A luz pálida, um círculo à frente da lanterna |
| No M3 | Carismas simples (§2), Forja com os complementos (§3), Livro das Obras na Biblioteca, Narrador nas telas de passagem |
| Escrita de Alan | As frases do Narrador; os pares obra–feito e obra–santo; o texto da origem das Esmolas |

## 7. Respostas às três perguntas finais (Alan, 11/11/2026)

| Pergunta | Resposta | O que significa |
| --- | --- | --- |
| A · Quando abre o segundo Carisma | **a** | No **nível 3**, como hoje. A Purificação **não** abre Carisma; continua com o efeito atual (+25% de experiência). A proposta F-06 (marcas) fica arquivada. |
| B · Equipamento no nível 3 | **a** | **Só números melhores.** Sem efeito especial por peça na versão 1. Valem os cinco complementos do §3. |
| C · Origem das Esmolas | **"a"** (as opções eram numeradas de 1 a 4) | Lida como a **primeira opção: restituição** (o que foi negado aos pobres, guardado pelos demônios, restituído pela companhia e consagrado no Pouso). **A confirmar com Alan**, porque a letra não batia com a numeração. A ideia das boas obras esquecidas do Peregrino não foi pedida; fica só anotada no §4. |

**Resumo dos Carismas, como ficou:** o kit atual de cada santo é o primeiro Carisma; o segundo troca o traço e uma habilidade (24 peças no total); abre no nível 3; troca na Casa de Exercícios.

**Resumo do equipamento, como ficou:** Instrumento e Hábito, 3 níveis, só números; Forja no M3, com prévia antes de pagar, nome de cada peça (de Alan), nível na ficha do santo, sugestão em "Planejar a semana" e uma rodada do simulador de economia.

**Texto da origem das Esmolas:** é de Alan, marcado como criação do jogo, com revisão teológica. Palavra-chave sugerida: **restituir**, nunca "saquear" ou "ganhar". Nomes "Despojos" (antes do Pouso) e "Esmolas" (depois) são sugestão para `ui_text.csv`, a aprovar.

## 8. Etapa 2 (`01-design.md`) · resposta de Alan (11/11/2026)

Alan respondeu: **"1, 2, 3 aprovados"**.

**Leitura do consultor (a confirmar com Alan):** a resposta se refere à última lista numerada da mensagem, "O que preciso que você confira":

| # | Item conferido | Resultado |
| --- | --- | --- |
| 1 | O Domínio (G-2) respeita a orientação de que o Peregrino não entra na luta | **Aprovado.** O Peregrino aparece como o que está em jogo, não como unidade. G-2 pode entrar no desenho de Asmodeu (T38). |
| 2 | G-1, G-2 e G-6 tocam teologia e pedem a revisão já prevista | **Aprovado**, com a revisão teológica. |
| 3 | G-5 (Vestígios como objetos da vida do Peregrino, compondo a contrição) combina com os flashbacks e as três pessoas da selva | **Aprovado.** |

**Ainda sem resposta explícita:** G-3 (a consolação é dom), G-4 (Laços), G-7 (quem leva a lanterna) e os três cortes (Escalada e retorno decrescente; Afinidades fixas; Jardim). A mensagem também tinha uma lista de cortes numerada de 1 a 3; se "1, 2, 3" se referia a ela, a leitura acima muda.
