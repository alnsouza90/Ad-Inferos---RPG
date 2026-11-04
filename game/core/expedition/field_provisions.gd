class_name FieldProvisions
extends RefCounted
## Provisions outside battle (expedition §5): pack capacity by gate level and
## what each provision does at a bifurcation. Driven by the provision's
## effects (provisions.csv / effects.csv): a provision can be used outside
## battle only if one of its effects acts there. Bread is spent only to rest
## at camp (T24); Bandages only remove Bleed, which ends with each battle,
## so they stay battle-only (D-136).

const FIELD_EFFECTS: Array[StringName] = [&"light", &"desolation", &"reveal_or_cancel_ambush"]

const REJECT_NOT_CARRIED: StringName = &"not_carried"
const REJECT_NOT_USABLE_HERE: StringName = &"not_usable_here"
const REJECT_NEEDS_TARGET: StringName = &"needs_target"
const REJECT_NOTHING_TO_REVEAL: StringName = &"nothing_to_reveal"


## Pack slots for gate levels 1 to 3; each slot holds one unit (§5).
static func capacity(gate_level: int, constants: ConstantsDef) -> int:
	return constants.get_int(StringName("gate_slots_l%d" % clampi(gate_level, 1, 3)))


static func usable_in_field(def: ProvisionDef) -> bool:
	if def == null:
		return false
	for e: EffectDef in def.effects:
		if FIELD_EFFECTS.has(e.type):
			return true
	return false


static func needs_target(def: ProvisionDef) -> bool:
	return def.targeting == &"ally" or def.targeting == &"self"
