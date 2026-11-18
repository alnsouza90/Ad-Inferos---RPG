class_name AbilityLoadout
extends RefCounted
## Which abilities a saint takes into battle (GDD §3, combat.md §2): exactly
## [equipped_abilities] of the ones it knows, at least one costing nothing so
## a saint in the Dark Night always has something to use. Chosen in the
## village, on the saint's sheet, by touching the stained glass (D-477).

const OK: StringName = &""
const FULL: StringName = &"loadout_full"
const UNKNOWN: StringName = &"loadout_unknown"
const INCOMPLETE: StringName = &"loadout_incomplete"
const NEEDS_FREE: StringName = &"loadout_needs_free"


## Why `ability_id` cannot be added to `equipped` (OK when it can).
static func add_refusal(saint: SaintDef, equipped: Array[StringName], ability_id: StringName, constants: ConstantsDef) -> StringName:
	if not saint.abilities.has(ability_id):
		return UNKNOWN
	if not equipped.has(ability_id) and equipped.size() >= constants.get_int(&"equipped_abilities"):
		return FULL
	return OK


## `equipped` with `ability_id` added or taken out; unchanged when refused.
static func toggle(saint: SaintDef, equipped: Array[StringName], ability_id: StringName, constants: ConstantsDef) -> Array[StringName]:
	var result: Array[StringName] = equipped.duplicate()
	if result.has(ability_id):
		result.erase(ability_id)
	elif add_refusal(saint, equipped, ability_id, constants) == OK:
		result.append(ability_id)
	# Keep the order of the saint's own list, so the bar reads the same.
	var ordered: Array[StringName] = []
	for id: StringName in saint.abilities:
		if result.has(id):
			ordered.append(id)
	return ordered


## Why `equipped` cannot go into battle (OK when it can).
static func refusal(saint: SaintDef, equipped: Array[StringName], abilities: Dictionary, constants: ConstantsDef) -> StringName:
	for id: StringName in equipped:
		if not saint.abilities.has(id):
			return UNKNOWN
	if equipped.size() != constants.get_int(&"equipped_abilities"):
		return INCOMPLETE
	for id: StringName in equipped:
		if (abilities[id] as AbilityDef).cost == 0:
			return OK
	return NEEDS_FREE
