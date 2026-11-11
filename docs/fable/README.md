# Consultoria de direção criativa · Ad Inferos

Versão 1.2 · 11/11/2026 · autor: consultor convidado (modelo de IA) · **nada aqui é decisão**

Esta pasta guarda a análise pedida por Alan antes do M3. Tudo é **proposta**. Nenhum código, dado, teste ou documento existente foi alterado.

## Ordem de leitura

| Arquivo | O que tem | Tempo |
| --- | --- | --- |
| `01-visao.md` | A tese: o que só este jogo faz, o que é forte e o que preocupa | 5 min |
| `02-propostas.md` | As propostas F-01 a F-18 (uma retirada), cada uma com problema, impacto, sistemas, custo, risco, simulação e decisões ligadas | 20 min |
| `03-decisoes-e-ordem.md` | As 13 perguntas que são suas, com a minha recomendação; a ordem sugerida; a lista para o simulador | 5 min |

## Orientação recebida de Alan nesta conversa (11/11/2026)

> O Peregrino **não** entra na luta nem na jornada. Os santos estão numa **missão de resgate, não de escolta**. Tudo é alegoria da **salvação** e da **intercessão dos santos**.

Isso bate com o que já estava decidido: o Peregrino vai sempre à frente e nunca está lá (D-141, D-199). Sugiro que o agente de implementação registre a frase acima como decisão, porque eu não posso editar `docs/memory/decisions.md`.

## O que mudou da versão 1.0 para a 1.1

A versão 1.0 foi escrita sem ler `decisions.md` inteiro nem o Prólogo. Alan apontou o erro. Li os dois, mais as pendências, e corrigi:

| O que eu tinha escrito | Por que estava errado | O que fiz |
| --- | --- | --- |
| "Há um buraco: quem é tentado na tenda?" (F-02) | Já decidido em D-141: a Tentação é o eco da tentação do Peregrino; os santos nunca cedem | **Retirei a F-02** |
| "O resgate não tem símbolo; proponho nove correntes" (F-03) | O Prólogo já tem a luz pálida da alma, a lanterna de Santa Luzia e a vela do leito | **Refiz a F-03** usando só esses três símbolos |
| Conquistas nos vitrais da Capela (F-14) | Os vitrais são os capítulos da história; as conquistas ficam em outro edifício (D-262) | Mudei para a Biblioteca |
| "Onde está o Anjo da Guarda? Quem narra?" (F-15) | O Anjo espera na Porta, no Círculo 1 (D-190); o Prólogo já tem um Narrador | **Refiz a F-15** com o Narrador que existe |
| Seis problemas de leitura no celular (F-16) | Cinco já estavam decididos ou resolvidos (D-117, D-257, D-258, D-314, D-347); a fonte foi escolha de Alan | Reduzi a um pedido de teste |
| "Dividir o M3 em dois passos" (F-18) | O M3 já é por família (D-170), e o Círculo 1 também ficou para o M3 (D-192) | Refiz: só a ordem e a rodada de regras |
| Relógio do combate sem ressalva (F-07) | O valor 20 foi calibrado e escolhido por Alan (D-164, D-165) | Mantive, avisando que reabre esse número |

As propostas F-01, F-04, F-05, F-06, F-08 a F-13 e F-17 não contrariam nenhuma decisão que encontrei. Cada uma ganhou a linha "Decisões ligadas" quando havia alguma.

## O que eu li

- Por inteiro: `docs/handoff/dossie-fable.md`, `CLAUDE.md`, as 6 pranchas, **`docs/memory/decisions.md`**, **`docs/narrative/prologue.md`**, **`docs/memory/open-questions.md`**, `docs/memory/owner.md`.
- Especificações: `desolation.md`, `narrative-system.md`, `village-economy.md`, `enemy-ai.md`; `design/saint-kits.md`, `design/analise-referencias-dd.md`, `narrative/writing-guide.md`.
- Em parte: `specs/expedition.md` (§10 e §11), `specs/combat.md` (§5), `gdd/gdd-v1.1.md` (§7 e §9), e os CSVs de inimigos, ações, encontros e condições.

## Leitura completa (versão 1.2)

A pedido de Alan, li também `specs/combat.md` e `specs/expedition.md` inteiros, o GDD §1 a §12, `backlog/m2.md`, `roadmap.md` e as metas de `testing.md`. Mudou:

- **Ferimento leve:** retirei o corte da F-17. Ele é a consequência de cair e da retirada de emergência.
- **Trava contra enrolar:** confirmei que não existe; anotado na F-07.
- **Ouro Maldito:** a "renúncia" que sugeri na F-09 já é a mecânica de Mamom no GDD; as duas se encaixam.

Não li: `lessons.md` (lições técnicas), os ADRs, a direção de arte e o §13 do GDD (kits, já lidos em `saint-kits.md`).

## Regras que eu segui

- §2 do dossiê inteiro: sem acaso no acerto, santos nunca pecam nem perdem o controle, figuras sagradas só como cena, Sufrágios nunca gastos, santos nunca comprados.
- Quando uma ideia esbarra numa regra ou numa decisão, o texto diz qual e mostra o caminho que a respeita.
- Nenhum texto final de narrativa, nenhuma citação. Onde aparece nome ou frase de exemplo, está marcado **proposta**.
- Todo número novo é **proposta para o simulador**, nunca valor final.
