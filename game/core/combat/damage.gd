class_name Damage
extends RefCounted
## Damage formula (combat §9). Every multiplier is applied to the real value
## and rounding happens once, at the end, half up; then armor, then minimum.
## Multipliers owned by later tasks (Duel and affinities T10, Fury M3,
## relics, Consolation T08) are hooks that return 1.0 for now.

## Tolerance so values like 37.4999999 from float products round as 37.5.
const ROUNDING_EPSILON: float = 0.000001


static func round_half_up(value: float) -> int:
	return int(floor(value + 0.5 + ROUNDING_EPSILON))


## Returns {"damage": int, "ward": bool}. `ward` tells the caller to consume
## one Amparo stack from the target. `strength_active` is decided once per
## action by the effect context.
static func compute(state: BattleState, attacker: Combatant, target: Combatant, effect: EffectDef, strength_active: bool) -> Dictionary:
	var constants: ConstantsDef = state.constants
	var value: float = effect.amount
	value *= type_multiplier(constants, effect.damage_type, target)
	value *= category_multiplier(effect, target)
	if strength_active:
		value *= constants.get_float(&"strength_mult")
	value *= duel_multiplier(attacker, target)
	value *= fury_multiplier(attacker)
	value *= affinity_multiplier(attacker, effect.damage_type)
	value *= relic_multiplier(attacker, effect.damage_type)
	var warded: bool = target.has_condition(&"ward")
	if warded:
		value *= constants.get_float(&"ward_mult")
	var damage: int = round_half_up(value) - target.armor
	if effect.amount > 0.0:
		damage = maxi(damage, constants.get_int(&"min_damage"))
	return {"damage": maxi(damage, 0), "ward": warded}


## Corporeal: vulnerable to strike, resistant to exorcism. Spiritual: the
## opposite. Untyped damage and saints as targets: 1.0.
static func type_multiplier(constants: ConstantsDef, damage_type: StringName, target: Combatant) -> float:
	if damage_type == &"untyped" or target.nature == &"":
		return 1.0
	var vulnerable: StringName = &"strike" if target.nature == &"corporeal" else &"exorcism"
	var resistant: StringName = &"exorcism" if target.nature == &"corporeal" else &"strike"
	if damage_type == vulnerable:
		return constants.get_float(&"vulnerable_mult")
	if damage_type == resistant:
		return constants.get_float(&"resistant_mult")
	return 1.0


## Per-category multipliers declared on the effect (e.g. elite=2.0;boss=2.0).
static func category_multiplier(effect: EffectDef, target: Combatant) -> float:
	if target.category == &"" or not effect.params.has(String(target.category)):
		return 1.0
	return float(effect.params[String(target.category)])


## Duel with Saint George (conditions §5): T10.
static func duel_multiplier(_attacker: Combatant, _target: Combatant) -> float:
	return 1.0


## Fury, Circle 5 only: M3.
static func fury_multiplier(_attacker: Combatant) -> float:
	return 1.0


## Affinities (combat §12): T10.
static func affinity_multiplier(_attacker: Combatant, _damage_type: StringName) -> float:
	return 1.0


## Relics: after M0.
static func relic_multiplier(_attacker: Combatant, _damage_type: StringName) -> float:
	return 1.0
