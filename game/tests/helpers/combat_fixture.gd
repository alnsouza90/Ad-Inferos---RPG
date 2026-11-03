class_name CombatFixture
extends RefCounted
## Builds battle definitions in code so combat tests never depend on
## game/data (testing.md §2). Numbers here are test values, not balance.

const DESOLATION_ALLY_FALLEN: int = 15
const REVIVE_WINDOW: int = 2
const FERVOR_PER_ROUND: int = 3
const FERVOR_CAP: int = 6
const FERVOR_BONUS_CAP: int = 2


static func constants() -> ConstantsDef:
	var c := ConstantsDef.new()
	c.values = {
		"fallen_revive_window": float(REVIVE_WINDOW),
		"desolation_ally_fallen": float(DESOLATION_ALLY_FALLEN),
		"desolation_max": 200.0,
		"fervor_per_round": float(FERVOR_PER_ROUND),
		"fervor_cap": float(FERVOR_CAP),
		"fervor_bonus_cap_per_round": float(FERVOR_BONUS_CAP),
	}
	return c


static func condition(id: StringName, polarity: StringName) -> ConditionDef:
	var d := ConditionDef.new()
	d.id = id
	d.polarity = polarity
	return d


static func conditions() -> Dictionary:
	return {
		&"stun": condition(&"stun", &"negative"),
		&"bleed": condition(&"bleed", &"negative"),
		&"ward": condition(&"ward", &"positive"),
		&"strength": condition(&"strength", &"positive"),
	}


static func saint(id: StringName, max_hp: int = 30) -> SaintDef:
	var d := SaintDef.new()
	d.id = id
	d.max_hp = max_hp
	return d


static func enemy(id: StringName, max_hp: int = 20, size: int = 1) -> EnemyDef:
	var d := EnemyDef.new()
	d.id = id
	d.max_hp = max_hp
	d.size = size
	return d


## Three saints (a, b, c in slots 1, 2, 3) against the given enemies.
static func battle(enemy_defs: Array[EnemyDef] = []) -> BattleState:
	var saints: Array[SaintDef] = [saint(&"saint_a"), saint(&"saint_b"), saint(&"saint_c")]
	if enemy_defs.is_empty():
		enemy_defs = [enemy(&"enemy_1"), enemy(&"enemy_2"), enemy(&"enemy_3"), enemy(&"enemy_4")]
	return BattleState.create(constants(), conditions(), saints, enemy_defs)
