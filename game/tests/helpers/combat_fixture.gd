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
		"provisions_per_turn": 1.0,
		"vulnerable_mult": 1.25,
		"resistant_mult": 0.75,
		"strength_mult": 1.25,
		"ward_mult": 0.5,
		"min_damage": 1.0,
		"effect_queue_limit": 64.0,
		"duel_damage_mult": 1.25,
		"duel_counter_damage": 3.0,
		"corruption_desolation_per_stack": 3.0,
		"faith_check_threshold": 100.0,
		"faith_check_base": 0.1,
		"faith_check_per_point": 0.04,
		"faith_check_cap": 0.6,
		"consolation_reset_value": 50.0,
		"consolation_output_mult": 1.15,
		"consolation_desolation_mult": 0.5,
		"dark_night_exit_threshold": 50.0,
		"prostration_reset_value": 150.0,
		"light_high_threshold": 75.0,
		"light_low_threshold": 24.0,
		"light_high_desolation_mult": 0.8,
		"light_low_desolation_mult": 1.3,
	}
	return c


static func condition(id: StringName, polarity: StringName, kind: StringName = &"token", max_stacks: int = 3, priority: int = 5, stacking: StringName = &"add", hook: StringName = &"", tick: StringName = &"none", decay: StringName = &"none", resisted_by_will: bool = false) -> ConditionDef:
	var d := ConditionDef.new()
	d.id = id
	d.polarity = polarity
	d.kind = kind
	d.max_stacks = max_stacks
	d.display_priority = priority
	d.stacking = stacking
	d.hook = hook
	d.tick = tick
	d.decay = decay
	d.resisted_by_will = resisted_by_will
	return d


## Mirrors docs/balance/conditions.csv for the conditions combat tests use.
static func conditions() -> Dictionary:
	return {
		&"stun": condition(&"stun", &"negative", &"token", 1, 1, &"none", &"stun_cancel"),
		&"bleed": condition(&"bleed", &"negative", &"duration", 5, 3, &"add", &"bleed_tick", &"owner_turn_start", &"minus_one_after_tick", true),
		&"corruption": condition(&"corruption", &"negative", &"duration", 5, 2, &"add", &"corruption_tick", &"owner_turn_start", &"minus_one_after_tick", true),
		&"ward": condition(&"ward", &"positive", &"token", 3, 5, &"add", &"ward_halve"),
		&"strength": condition(&"strength", &"positive", &"token", 3, 6, &"add", &"strength_boost"),
		&"taunt": condition(&"taunt", &"positive", &"token", 1, 4, &"refresh", &"taunt_redirect", &"none", &"expire_round_end"),
		&"duel": condition(&"duel", &"negative", &"permanent", 1, 2, &"refresh", &"duel_mark"),
	}


static func saint(id: StringName, max_hp: int = 30, will: int = 0) -> SaintDef:
	var d := SaintDef.new()
	d.id = id
	d.max_hp = max_hp
	d.will = will
	return d


static func enemy(id: StringName, max_hp: int = 20, size: int = 1, nature: StringName = &"corporeal", armor: int = 0, family: StringName = &"a") -> EnemyDef:
	var d := EnemyDef.new()
	d.id = id
	d.max_hp = max_hp
	d.size = size
	d.nature = nature
	d.armor = armor
	d.family = family
	return d


static func action(id: StringName, priority: int, effects: Array[EffectDef], targeting: StringName = &"single", target_slots: Array[int] = [1, 2, 3], use_slots: Array[int] = [1, 2, 3, 4], rule: StringName = &"front_most", conditions: Array[Dictionary] = [{"name": "always", "param": null}], cooldown: int = 0) -> EnemyActionDef:
	var a := EnemyActionDef.new()
	a.id = id
	a.priority = priority
	a.effects = effects
	a.targeting = targeting
	a.target_slots = target_slots
	a.use_slots = use_slots
	a.target_rule = rule
	a.conditions = conditions
	a.cooldown = cooldown
	a.intent_icon = &"attack"
	return a


static func effect(type: StringName, amount: float = 0.0, damage_type: StringName = &"", condition_id: StringName = &"", stacks: int = 0, params: Dictionary = {}) -> EffectDef:
	var e := EffectDef.new()
	e.type = type
	e.amount = amount
	e.damage_type = damage_type
	e.condition_id = condition_id
	e.stacks = stacks
	e.params = params
	return e


static func ability(id: StringName, kind: StringName, cost: int, use_slots: Array[int], targeting: StringName, target_slots: Array[int] = [], allow_self: bool = false, once_per_battle: bool = false, target_count: int = 0) -> AbilityDef:
	var d := AbilityDef.new()
	d.id = id
	d.kind = kind
	d.cost = cost
	d.use_slots = use_slots
	d.targeting = targeting
	d.target_slots = target_slots
	d.allow_self = allow_self
	d.once_per_battle = once_per_battle
	d.target_count = target_count
	return d


## One ability of each targeting rule, all usable from any slot unless noted.
static func abilities() -> Dictionary:
	var any: Array[int] = [1, 2, 3]
	var list: Array[AbilityDef] = [
		ability(&"strike", &"basic", 0, any, &"enemy", [1, 2] as Array[int]),
		ability(&"front_only", &"basic", 0, [1] as Array[int], &"enemy", [1] as Array[int]),
		ability(&"costly", &"basic", 1, any, &"enemy", [1, 2, 3, 4] as Array[int]),
		ability(&"heal_other", &"basic", 0, any, &"ally", any),
		ability(&"heal_any", &"basic", 0, any, &"ally", any, true),
		ability(&"raise", &"fervor", 2, any, &"ally_fallen", any),
		ability(&"guard_self", &"basic", 0, any, &"self"),
		ability(&"rally", &"fervor", 2, any, &"all_allies"),
		ability(&"sweep", &"fervor", 2, any, &"enemy_group", [1, 2] as Array[int]),
		ability(&"once", &"basic", 0, any, &"self", [] as Array[int], false, true),
		ability(&"miracle_all", &"miracle", 3, any, &"all_enemies"),
		ability(&"miracle_two", &"miracle", 3, any, &"chosen_enemy_slots", [1, 2, 3, 4] as Array[int], false, false, 2),
	]
	var result: Dictionary = {}
	for a: AbilityDef in list:
		result[a.id] = a
	return result


static func provisions() -> Dictionary:
	var bread := ProvisionDef.new()
	bread.id = &"bread"
	bread.usable_in_battle = true
	bread.targeting = &"ally"
	var candle := ProvisionDef.new()
	candle.id = &"candle"
	candle.targeting = &"none"
	return {&"bread": bread, &"candle": candle}


static func catalog() -> BattleCatalog:
	return BattleCatalog.create(constants(), conditions(), abilities(), provisions())


## A saint with every fixture ability equipped (equipped size is not limited
## here: the 4-ability rule belongs to loadouts, not to the battle).
static func kit_saint(id: StringName, miracle_id: StringName = &"miracle_all") -> SaintDef:
	var d := saint(id)
	for ability_id: StringName in abilities():
		if not String(ability_id).begins_with("miracle"):
			d.default_equipped.append(ability_id)
	d.miracle = miracle_id
	return d


## Three saints (a, b, c in slots 1, 2, 3) against the given enemies.
static func battle(enemy_defs: Array[EnemyDef] = [], p_provisions: Array[StringName] = [], encounter_type: StringName = &"common") -> BattleState:
	var saints: Array[SaintDef] = [kit_saint(&"saint_a"), kit_saint(&"saint_b"), kit_saint(&"saint_c", &"miracle_two")]
	if enemy_defs.is_empty():
		enemy_defs = [enemy(&"enemy_1"), enemy(&"enemy_2"), enemy(&"enemy_3"), enemy(&"enemy_4")]
	return BattleState.create(catalog(), saints, enemy_defs, p_provisions, encounter_type)
