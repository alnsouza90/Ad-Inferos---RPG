# Especificação · Sistema narrativo

Versão 1.0 · base: GDD v1.1 §9 e §10 · regras de escrita em `docs/narrative/writing-guide.md`

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

## 2. Virtudes do Peregrino

- `virtue_faith`, `virtue_hope`, `virtue_charity`: inteiros de 0 a 5, sempre visíveis.
- Valor inicial: [virtue_start] (2) cada.
- Alteradas apenas por escolhas em eventos da primeira passagem por um círculo. Revisitas nunca alteram virtudes.
- Final pela soma (premissa, a validar no roteiro): 11–15 `awakening`, 6–10 `restless_awakening`, 0–5 `good_death`.

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
    outcomes:
      - { type: light, amount: -5 }
  - id: accept
    text_pt: "Aceitar o banquete"
    chance:                     # opcional; quando presente, a chance é sempre exibida
      base: 0.5
      modifiers:
        - { if: saint_in_party, id: saint_benedict, add: 0.2 }
        - { if: provision, id: holy_water, add: 0.2, consume: true }
    on_success:
      - { type: provisions, id: bread, amount: 2 }
    on_failure:
      - { type: virtue, id: virtue_hope, amount: -1 }
      - { type: desolation, target: party, amount: 15 }
requirements: []                # requisitos do evento inteiro (opcional)
```

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

## 4. Regras por tipo

### 4.1 Tentação

- Pelo menos uma opção `safe: true`, com custo pequeno.
- Toda chance é visível e pode ser melhorada por pelo menos um santo, provisão ou relíquia.
- Consequências ficam na expedição ou nas virtudes do Peregrino. **Nunca** ferimento permanente além do sistema normal, e **nunca** o santo comete pecado.

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
| N06 | Soma de virtudes 10 ao final | `restless_awakening` |
