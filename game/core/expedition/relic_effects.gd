class_name RelicEffects
extends RefCounted
## Relic modifiers the engine applies (data-schemas §4). Only those listed in
## IMPLEMENTED reach the M1 relic node; the others arrive with their systems.

const IMPLEMENTED: Array[StringName] = [&"light_per_node", &"stat_mult", &"stat_add"]


## Light lost per node: the smallest value among the carried light_per_node
## relics, else the constant (§4: they do not stack, the smallest wins).
static func light_per_node(carried: Array[RelicDef], constants: ConstantsDef) -> int:
	var value: int = ExpeditionLight.per_node(constants)
	for r: RelicDef in carried:
		if r.modifier == &"light_per_node":
			value = mini(value, int(r.params.get("value", value)))
	return value


## Puts a relic's stat effect on the carrier's status: stat_mult on max_hp
## raises max and current hit points by the same amount; stat_add on faith
## adds to every battle.
static func apply_to_carrier(r: RelicDef, status: SaintStatus, def: SaintDef) -> void:
	var stat: String = str(r.params.get("stat", ""))
	var value: float = float(r.params.get("value", 0.0))
	match r.modifier:
		&"stat_mult":
			if stat == "max_hp":
				var new_max: int = Damage.round_half_up(def.max_hp * value)
				var gained: int = maxi(new_max - status.max_hp, 0)
				status.max_hp = maxi(status.max_hp, new_max)
				status.hp = mini(status.max_hp, status.hp + gained)
		&"stat_add":
			if stat == "faith":
				status.faith_bonus += int(value)
