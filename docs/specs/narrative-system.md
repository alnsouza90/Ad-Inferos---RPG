# Especificação · Sistema narrativo

Versão 1.1 (12/11/2026: orientação, Narrador, Tentação e assédio, Domínio, lembranças; D-266 e D-267 a D-362) · base: GDD v1.1 §9 e §10 · regras de escrita em `docs/narrative/writing-guide.md`

Este documento define **como** os eventos narrativos funcionam. **O que** eles dizem é escrito pelo responsável (com apoio) seguindo o guia de roteiro. O agente nunca escreve textos narrativos finais por conta própria.

## 1. Tipos de evento

| Tipo | Código | Onde ocorre |
| --- | --- | --- |
| Tentação | `temptation` | `node_temptation` |
| Encontro com alma | `soul_meeting` | `node_soul` |
| Flashback | `flashback` | Após o chefe de cada círculo |
| Conselho da vila | `council` | Na vila, após o flashback |
| Missão de Intercessão | `intercession_mission` | Marcos 1 e 7 da trilha do Purgatório |
| Cena | `story` | Prólogo, portões de Dite, final etc. |
| Flashback de antes | `flashback_before` | Antes da primeira expedição de cada círculo |
| Vinheta do leito | `deathbed` | Depois do flashback pós-chefe, na primeira conclusão de cada círculo |
| Ato de contrição | `contrition` | Depois da vitória sobre Lúcifer |
| Epílogo | `epilogue` | Depois da contrição: unção, boa morte, Purgatório e Paraíso |

**Orientação (D-362):** o Peregrino não entra na luta nem na jornada; a companhia está numa missão de resgate, não de escolta, e tudo é alegoria da salvação e da intercessão dos santos. Ele aparece só como o que está em jogo (rastros, Domínio do chefe, lembranças), nunca como unidade.

**Aprovado para o M3 (D-277):** o **Narrador** do Prólogo fala também dentro do jogo, com poucas frases, só texto, nos momentos fortes (teste de Fé, Consolação, Noite Escura, Purificação, santo caído, chefe vencido, Lume baixo). A escrita é toda de Alan, com a origem marcada.

## 2. Virtudes do Peregrino

- `virtue_faith`, `virtue_hope`, `virtue_charity`: inteiros de 0 a 5, sempre visíveis.
- Valor inicial: [virtue_start] (2) cada.
- Alteradas apenas por escolhas em eventos da primeira passagem por um círculo. Revisitas nunca alteram virtudes.
- As virtudes não escolhem o final. No evento `contrition`, a soma define a versão do ato de contrição: 11–15 `contrition_perfect`, 6–10 `contrition_imperfect`, 0–5 `contrition_fragile` (premissa a validar). O final é sempre `good_death` (D-198).

## 3. Formato de um evento (dados)

Eventos ficam em `game/data/events/*.tres`, gerados a partir de arquivos de texto em `docs/narrative/events/` (formato a seguir).

```yaml
id: c03_temptation_feast
type: temptation
circle: 3
title_pt: "A mesa posta"
origin: game_fiction           # ver §6
pages:
  - speaker: demon_tempter      # ID de personagem ou "narrator"
    text_pt: "..."
options:
  - id: refuse
    text_pt: "Recusar e seguir"
    safe: true                  # toda Tentação tem pelo menos uma opção segura
    result_pt: "..."            # opcional: texto mostrado depois da escolha (D-141)
    outcomes:
      - { type: light, amount: -5 }
  - id: accept
    text_pt: "Aceitar o banquete"
    chance:                     # opcional; quando presente, a chance é sempre exibida
      base: 0.5
      modifiers:
        - { if: saint_in_party, id: saint_benedict, add: 0.2 }
        - { if: provision, id: holy_water, add: 0.2, consume: true }
    success_pt: "..."           # opcionais: textos do sucesso e da falha (D-141)
    failure_pt: "..."
    on_success:
      - { type: provisions, id: bread, amount: 2 }
    on_failure:
      - { type: virtue, id: virtue_hope, amount: -1 }
      - { type: desolation, target: party, amount: 15 }
requirements: []                # requisitos do evento inteiro (opcional)
```

Leitura dos arquivos: ADR-0012 (subconjunto de YAML, leitor próprio). Formatos usados nas listas:

- requisito: `{ type: virtue_at_least, id: virtue_faith, value: 3 }`;
- modificador de chance: `{ if: saint_in_party, id: saint_benedict, add: 0.2 }`, com `consume: true` para gastar a provisão quando o modificador vale;
- resultado: `{ type: desolation, target: party, amount: 15 }`.

Toda chance precisa de pelo menos um modificador (erro `chance_without_modifier`). O sorteio usa o fluxo `events`, derivado do nó.

### 3.1 Requisitos de opção (`requires`)

| Requisito | Exemplo |
| --- | --- |
| `virtue_at_least` | `{ virtue_charity: 3 }` |
| `saint_in_party` | `saint_nicholas` |
| `provision` | `holy_water` (com `consume: true` para gastar) |
| `alms_at_least` | `100` |
| `flag_set` | `c02_forgave_brother` (bandeira narrativa simples) |

Opção bloqueada aparece desabilitada, com o requisito escrito ("Exige Caridade 3"). Não há rolagem escondida.

### 3.2 Resultados (`outcomes`)

`virtue`, `desolation` (`target: party` ou um santo), `light`, `alms`, `provisions`, `relic`, `injury`, `suffrages`, `set_flag`, `start_battle` (encontro), `unlock`.

No M1, `relic`, `suffrages` e `unlock` ainda não têm sistema: ficam só registrados no histórico da expedição.

## 4. Regras por tipo

### 4.1 Tentação

- Pelo menos uma opção `safe: true`, com custo pequeno. Na caminhada interativa, **Passar ao largo** da tenda aplica a primeira opção `safe: true` do evento, sem abrir o evento (`expedition.md` §2.3, D-184).
- Toda chance é visível e pode ser melhorada por pelo menos um santo, provisão ou relíquia.
- Consequências ficam na expedição ou nas virtudes do Peregrino. **Nunca** ferimento permanente além do sistema normal, e **nunca** o santo comete pecado.
- A tenda **não muda** com o assédio (D-267): ela continua sendo o eco da tentação do Peregrino (D-141). O assédio dos pecados aos santos é outra coisa, acontece **no combate**, aplicado de fora pelos inimigos, e está em `expedition.md` §10.1 (Provação do Círculo).
- **Aprovado, a especificar na T38 (D-284):** resolver bem uma Tentação (ou o Encontro com alma) pode **ceder um ponto do Domínio** do chefe do círculo, além de mudar a virtude. O resultado novo entra em §3.2 com `bosses.md`.

### 4.2 Encontro com alma

- Sem combate. Diálogo com a alma inspirada em Dante (sem o nome original).
- No máximo uma escolha, que altera uma virtude em ±1.

### 4.3 Flashback

- Mostra a queda do Peregrino ligada ao círculo e a lição.
- Bloco `testimony`: para cada santo presente na equipe, uma fala curta a partir da vida do santo. Os testemunhos **não** alteram opções nem resultados.

```yaml
testimony:
  saint_george: "..."
  saint_therese: "..."
```

### 4.4 Conselho da vila

- Duração-alvo: menos de 2 minutos.
- Exatamente uma decisão, com efeito concreto (virtude, bandeira, desconto numa instalação ou evento no próximo círculo).

### 4.5 Contrição e epílogo

- `contrition` tem uma única opção ("Arrepender-se"), sem chance e sem opção de recusa; o texto da opção e das falas vem da versão definida pela soma das virtudes. A liberdade do Peregrino está no caminho inteiro (as escolhas que formaram as virtudes); o botão é o gesto final dessa conversão (D-198).
- `epilogue` lê o número de marcos da Trilha do Purgatório: 8–10 `purgatory_brief`, 4–7 `purgatory_middle`, 0–3 `purgatory_long`. A diferença é o número de pranchas e falas da subida da montanha; o fim é sempre o Paraíso.
- Sacramentos e figuras sagradas aparecem só como cena; nenhum deles concede bônus.

**Aprovado para o M3 e M4 (D-287):** os Vestígios do corredor são objetos da vida do Peregrino; recolhidos, viram lembranças no Diário do Peregrino (Biblioteca), e o ato de contrição é **montado com as lembranças recolhidas**. A versão do ato continua definida pela soma das virtudes (§2). Escrita de Alan.

### 4.6 Vinheta do leito (`deathbed`)

Nove versões (`deathbed_01` a `deathbed_09`), uma por círculo, sem escolhas. A vela fica mais baixa a cada versão; a partir da `deathbed_07`, o frei é chamado; na `deathbed_09`, ele chega à porta.

## 5. Bandeiras narrativas

- Booleanos com ID `cNN_descricao`. Usadas só para abrir ou fechar falas e eventos futuros.
- Lista mantida em `docs/narrative/flags.md` (criada no M2).

## 6. Origem do conteúdo

Todo evento, ficha do Martirológio e entrada do Arquivo declara `origin`:

| Valor | Significado |
| --- | --- |
| `scripture` | Sagrada Escritura (com referência) |
| `catechism` | Catecismo da Igreja Católica (com parágrafo) |
| `tradition` | Tradição da Igreja, patrística, liturgia |
| `hagiography` | Vida documentada do santo |
| `legend` | Lenda ou tradição popular |
| `apocrypha` | Literatura não canônica (ex.: 1 Enoque) |
| `dante` | *Divina Comédia* |
| `demonology` | Demonologia histórica (Binsfeld, Weyer, Collin de Plancy) |
| `game_fiction` | Criação do jogo |

A interface do Martirológio e do Arquivo mostra esse rótulo.

## 7. Martirológio e Arquivo

| Registro | Conteúdo | Formato |
| --- | --- | --- |
| Martirológio (`martyrology`) | Santos e arcanjos | Ficha com os campos de `writing-guide.md` §5.3 |
| Arquivo de Santo Tomás (`archive`) | Demônios, almas, lugares, fontes literárias | Nome, descrição, origem, divergências do jogo |

Entradas são desbloqueadas ao encontrar o personagem ou lugar.

## 8. Casos de teste obrigatórios

| # | Cenário | Esperado |
| --- | --- | --- |
| N01 | Opção com `virtue_at_least` não cumprido | Exibida desabilitada com o requisito |
| N02 | Tentação sem opção `safe` | Importador rejeita o evento |
| N03 | Chance 0,5 + Bento na equipe | Chance exibida 70% |
| N04 | Virtude 5 recebe +1 | Fica em 5 |
| N05 | Evento em revisita | Resultados de virtude ignorados |
| N06 | Soma de virtudes 10 na contrição | Versão `contrition_imperfect`; final `good_death` |
| N07 | 9 marcos de Sufrágios no epílogo | `purgatory_brief` |
| N08 | Evento `contrition` | Uma única opção, sem recusa |
