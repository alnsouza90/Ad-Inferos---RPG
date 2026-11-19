# Apresentação da vila: falas dos guardiões · v2 para Alan aprovar (T43, peça 5c)

**Situação:** aprovado por Alan (D-468), com a fala do Portão a ajustar depois da decisão sobre o Portão. v2 (18/11/2026), com as correções de Alan:
- só Santo Agostinho na Capela, com uma fala das *Confissões*;
- uma fala mais essencial para Santo Tomás;
- "Santa Helena, imperatriz";
- cada fala seguida da instrução do prédio.

**Como aparece:** na primeira chegada à vila, depois do Prólogo, a câmera passa por cada prédio.
1. O guardião diz a frase.
2. Logo abaixo aparece a **instrução** do prédio: o que ele faz e como funciona.
3. Os prédios ainda não liberados mostram o **aviso** de quando abrem (D-459).

Depois, tocar no guardião repete a fala e a instrução. As referências ficam só no Arquivo (D-465). As instruções são texto de interface: seguem `village-economy.md` §3, e a T45 confirma os números do M2.

| Prédio | Guardião | Fala | Instrução (como funciona) | De onde vem a fala (só no Arquivo) |
| --- | --- | --- | --- | --- |
| Capela | Santo Agostinho | Fizeste-nos para ti, e inquieto está o nosso coração enquanto não repousa em ti. | Deixe um santo rezando na Capela durante a semana: ele não vai à expedição, mas a companhia ganha Sufrágios e ele descansa da desolação. | *Confissões* I, 1 (tradução própria) |
| Enfermaria | São Cosme e São Damião | Fomos médicos dos pobres. Aqui o corpo descansa, e a ferida tem tempo de fechar. | Os ferimentos saram com as semanas. Um santo deitado num leito sara mais depressa do ferimento grave. | Tradição: os irmãos médicos "anárgiros", que não cobravam |
| Despensa | Santa Isabel da Hungria | O pão que guardo não é meu. É de quem vai precisar dele lá embaixo. | Compre aqui, com Esmolas, as provisões da expedição: pão, velas, água benta, ataduras e incenso. | Hagiografia: a rainha que dava pão aos pobres |
| Portão | São Cristóvão | Eu levo até a margem. Dali em diante, o caminho é de vocês. | Daqui se parte. O Portão diz quantas provisões cabem no alforje e quanto do caminho a companhia vê antes de entrar. | Já aprovada (D-463) |
| Casa de Exercícios | Santo Inácio de Loyola | Também fui soldado, e uma ferida me ensinou mais que todas as vitórias. | Os santos sobem de nível com a experiência das expedições. Aqui eles aprendem as versões melhores das habilidades. | *Autobiografia* de Santo Inácio (a ferida em Pamplona e a conversão) |
| Forja | Santo Elói | Trabalhei o ouro para reis. Aqui o ferro serve melhor. | *(aviso: em reconstrução)* Aqui se faz e se melhora o equipamento dos santos. | Hagiografia: ourives do rei franco, depois bispo |
| Biblioteca | Santo Tomás de Aquino | Escrevi muito. No fim, tudo me pareceu palha diante do que vi. | *(aviso: abre depois do Círculo 3)* Aqui se estuda o que se viu lá embaixo: os inimigos, as almas e as obras da companhia. | Tradição contada pelo companheiro dele, frei Reginaldo |
| Carmelo | Santa Teresa d'Ávila | A alma é um castelo de muitas moradas. Esta casa também é, e ainda está em ruínas. | *(aviso: reforma depois do Círculo 3)* Reformado o Carmelo, uma nova morada se abre a cada círculo vencido. | *Castelo Interior* de Santa Teresa |
| Relicário | Santa Helena, imperatriz | Fui longe procurar a Cruz. Cada relíquia também é um caminho. | *(aviso: abre depois do Círculo 4)* Aqui se guardam as relíquias, e as iguais se unem numa só, mais forte. | Tradição: Santa Helena e a Vera Cruz em Jerusalém |

**Uma divergência para Alan decidir:** o GDD diz que a Casa de Exercícios e a Forja abrem "depois do Limbo", mas a especificação da vila (`village-economy.md` §3) diz "depois do Prólogo". No M2 a Casa de Exercícios já está aberta (D-173). Pela regra do projeto vale a especificação. Para a Forja, que só entra no M3, deixei o aviso genérico "em reconstrução".

**O que Alan precisa decidir:**
- se as falas novas de Agostinho e de Tomás servem;
- se as instruções estão claras;
- qual vale para a abertura da Casa de Exercícios e da Forja: depois do Prólogo (a especificação) ou depois do Limbo (o GDD).

## Pendências da D-469 · aprovadas (D-471)

| Prédio | Guardião | Fala | Instrução (como funciona) | De onde vem a fala (só no Arquivo) |
| --- | --- | --- | --- | --- |
| Portão (papel novo) | São Cristóvão | Por esta porta chega quem foi chamado, e por ela sai quem vai buscar. | Aqui chegam os santos novos. Escolha os três que descem e a ordem deles, e abra o Mapa do Inferno para partir. | Criação do jogo, na imagem do barqueiro que leva e traz (*Legenda Áurea*) |
| Jardim e Claustro (volta, D-469, D-474) | São Francisco de Assis | Louvado sejas, meu Senhor, com todas as tuas criaturas. | Deixe um santo descansar no Jardim e Claustro durante a semana: ele não vai à expedição e volta com a desolação aliviada. | *Cântico do Irmão Sol*, de São Francisco (tradução própria) |

Com isso, a instrução da Capela muda: "Deixe um santo rezando na Capela durante a semana: ele não vai à expedição, e a companhia ganha Sufrágios." Sai o "descansa da desolação", que agora é do Jardim e Claustro.

## Carmelo · fala nova de Santa Teresa d'Ávila (D-491: Alan escolheu o "Nada te perturbe")

O Carmelo agora é **inteiro**, fica bloqueado no motor e tem uma **reforma espiritual** (D-489). Por isso a fala aprovada, que termina em *"e ainda está em ruínas"*, muda. Alan pediu uma fala sobre as sete moradas.

| Proposta | Fala | De onde vem (só no Arquivo) |
| --- | --- | --- |
| A (recomendada) | A alma é um castelo de sete moradas. Quem reza encontra a porta da primeira. | *Castelo Interior*, Moradas I, 1: a alma como um castelo com muitas moradas, e a oração como a porta de entrada (paráfrase, tradução própria) |
| B | Sete moradas tem a alma, e no centro mora o Rei. Esta casa espera quem quiser entrar. | *Castelo Interior*, Moradas I, 1 e VII: o Rei na morada do centro (paráfrase) |

A instrução do prédio continua: *(aviso: reforma depois do Círculo 3)* "Reformado o Carmelo, uma nova morada se abre a cada círculo vencido."

**Aprovada por Alan (D-492):** o texto curto do poema de Santa Teresa (tradução própria):

> Nada te perturbe, nada te espante. Tudo passa; Deus não muda. Só Deus basta.

**De onde vem (só no Arquivo):** o poema "Nada te turbe", encontrado no breviário de Santa Teresa de Ávila; atribuído a ela pela tradição carmelita. Tradução própria; o texto completo diz ainda "a paciência tudo alcança; quem a Deus tem nada lhe falta".
