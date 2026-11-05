# Especificação · Salvamento e retomada

Versão 1.0 · ADR-0005

## 1. Requisitos

- O jogador nunca perde progresso por fechar o app, receber uma ligação ou o Android matar o processo.
- Ao reabrir, o jogo volta **exatamente** ao ponto anterior, inclusive no meio do turno da equipe.
- Um save corrompido nunca impede o jogo de abrir.
- Versão 1: um único espaço de save.

## 2. Arquivos

| Arquivo | Conteúdo |
| --- | --- |
| `user://saves/slot_1.json` | Save atual |
| `user://saves/slot_1.bak` | Save anterior válido |
| `user://saves/slot_1.tmp` | Escrita em andamento (temporário) |
| `user://settings.json` | Preferências (texto, velocidade, áudio, acessibilidade); separado do save |

## 3. Estrutura do save

```json
{
  "save_version": 1,
  "game_version": "0.1.0",
  "saved_at_unix": 0,
  "campaign": {
    "seed": 123456789,
    "week": 3,
    "alms": 420,
    "suffrages": 6,
    "facilities": { "chapel": 1, "gate": 1 },
    "carmel_mansion": 0,
    "provisions_stock": { "bread": 4 },
    "virtues": { "virtue_faith": 2, "virtue_hope": 2, "virtue_charity": 2 },
    "flags": [],
    "circles": { "circle_02": { "completed": false, "consecrated_camp": 1, "revisits_this_season": 0 } },
    "unlocked_saints": ["saint_george", "saint_benedict", "saint_therese"],
    "rng_counters": { "map": 12, "rewards": 7, "events": 3, "faith": 2 }
  },
  "saints": {
    "saint_george": {
      "level": 1, "xp": 0, "hp": 32, "desolation": 0, "spirit_state": "normal",
      "injury": null, "injury_weeks_left": 0,
      "equipped_abilities": ["george_spear_thrust", "george_shield_bash", "george_raised_shield", "george_formal_challenge"],
      "upgrades": [], "charism": null, "equipment": { "instrument": 1, "habit": 1 }, "relics": []
    }
  },
  "expedition": null,
  "battle": null,
  "scene": { "kind": "village", "id": null }
}
```

### 3.0 Como o M1 grava a expedição (D-320)

Em vez de guardar o estado do combate à parte (§3.2), o M1 guarda a expedição inteira como **retrato inicial + log de comandos**, com os comandos de combate dentro do log (`ExpeditionSave`):

```json
"expedition": { "initial": { "...": "retrato no Portão" }, "commands": [ { "type": "ChoosePath", "node": "l1_n0" } ], "check": { "...": "retrato atual" } },
"battle": { "in_progress": true }
```

Ao carregar, os comandos são reaplicados e o resultado precisa bater com `check`; se não bater, o save conta como corrompido e o jogo tenta o `.bak` (§6). O efeito para o jogador é o mesmo do §3.2: volta exatamente ao mesmo ponto, inclusive no meio do turno.

### 3.1 Expedição em andamento

```json
"expedition": {
  "circle": "circle_02", "map_seed": 99, "map": { "...": "estrutura gerada" },
  "current_node": "l1_n2", "visited": ["l1_n0"], "light": 85,
  "provisions": ["bread", "candle"], "alms_unbanked": 140, "alms_banked": 0,
  "party": ["saint_george", "saint_benedict", "saint_therese"], "fallen_once": []
}
```

A partir do M2, o save guarda também a **posição da equipe no corredor** (`expedition.md` §2.3, regra 11) num bloco de apresentação, fora do log e fora da conferência do retrato: `"presentation": { "corridor_x": 0.42 }` (fração do corredor, de 0 a 1). Ela é gravada quando a equipe para de andar e nos salvamentos de §4; se faltar ou vier inválida, a equipe aparece no começo do corredor (ou diante do conteúdo pendente), sem contar como save corrompido.

### 3.2 Combate em andamento

O combate **não** guarda o estado completo; guarda o necessário para reconstruí-lo:

```json
"battle": {
  "encounter_id": "c03_easy_02",
  "battle_seed": 4242,
  "initial_party_snapshot": { "...": "vida, desolação, condições e posições no início" },
  "commands": [
    { "type": "UseAbility", "actor": "saint_george", "ability": "george_spear_thrust", "target": 1 },
    { "type": "EndPartyTurn" }
  ]
}
```

Ao carregar: criar o combate com a semente e o retrato inicial, reaplicar os comandos em ordem, com animação instantânea. O estado final deve ser idêntico ao que existia.

## 4. Quando salvar

| Momento | Observação |
| --- | --- |
| Após cada comando resolvido em combate | Só acrescenta o comando ao log |
| Ao entrar em cada nó do mapa | |
| Ao fim de cada combate, evento e Pouso | |
| Na vila, a cada confirmação | |
| `NOTIFICATION_APPLICATION_PAUSED` e `NOTIFICATION_WM_CLOSE_REQUEST` | Salvamento imediato |

## 5. Escrita atômica

1. Serializar para texto.
2. Gravar em `slot_1.tmp`.
3. Se existir `slot_1.json`, renomeá-lo para `slot_1.bak`.
4. Renomear `slot_1.tmp` para `slot_1.json`.

## 6. Leitura

1. Ler `slot_1.json`. Se o JSON for inválido ou faltar campo obrigatório, tentar `slot_1.bak`.
2. Se ambos falharem: oferecer novo jogo e preservar os arquivos ruins renomeados como `slot_1.corrupt.<data>.json`.
3. Se `save_version` for menor que a atual, aplicar as migrações em sequência (§7).
4. Se `save_version` for maior que a atual (save de versão mais nova), recusar com mensagem clara.

## 7. Versionamento e migração

- `save_version` começa em 1 e sobe a cada mudança de estrutura **ou** de regra que altere o resultado de comandos já gravados.
- Cada migração é uma função `migrate_v{n}_to_v{n+1}(data: Dictionary) -> Dictionary` em `autoload/save_migrations.gd`, com teste próprio.
- Se a mudança de regra impedir a reconstrução de um combate gravado, a migração **reinicia esse combate** a partir do retrato inicial (o jogador perde apenas os comandos daquele combate) e registra o fato.

## 8. Casos de teste obrigatórios

| # | Cenário | Esperado |
| --- | --- | --- |
| S01 | Salvar e carregar na vila | Estado idêntico |
| S02 | Salvar no meio do turno da equipe e carregar | Mesmo estado, mesmos santos já tendo agido |
| S03 | `slot_1.json` truncado | Carrega `slot_1.bak` |
| S04 | Ambos corrompidos | Oferece novo jogo; arquivos preservados como `.corrupt` |
| S05 | Save versão 1 com código na versão 2 | Migração aplicada e testada |
| S06 | Save de versão futura | Recusado com mensagem |
| S07 | 100 ciclos salvar/carregar em combate com comandos aleatórios válidos | Sempre idêntico |
