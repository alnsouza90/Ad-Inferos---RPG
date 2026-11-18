class_name AbilityUpgrade
extends RefCounted
## The "+" version of an ability (village-economy §9): what a level's
## improvement, applied at the Retreat House, turns it into. With the
## `upgrade` field empty, the general rule: the first effect with a number
## gains [upgrade_gain] (+30%), rounded half up, at least +1 (negative
## desolation counts by its size); without a number, `hp_fraction` gains
## [upgrade_hp_fraction] (+0.1); without either, the first condition applied
## gains one stack. The cost in Fervor never changes. A filled `upgrade`
## field holds the exceptions, `e<order>.<field>+<value>;...` (data-schemas
## §3.3). The definitions are never changed: the result is a copy.

const NAME_MARK: String = "+"


static func upgraded(def: AbilityDef, constants: ConstantsDef) -> AbilityDef:
	var copy: AbilityDef = def.duplicate(false)
	var effects: Array[EffectDef] = []
	for e: EffectDef in def.effects:
		effects.append(e.duplicate(false))
	copy.effects = effects
	copy.name_pt = def.name_pt + NAME_MARK
	if not def.upgrade.strip_edges().is_empty():
		_apply_exceptions(copy, def.upgrade)
		return copy
	for e: EffectDef in effects:
		if not is_zero_approx(e.amount):
			var size: float = absf(e.amount)
			var gain: int = maxi(1, Damage.round_half_up(size * constants.get_float(&"upgrade_gain")))
			e.amount = signf(e.amount) * (size + gain)
			return copy
	for e: EffectDef in effects:
		if e.params.has("hp_fraction"):
			var params: Dictionary = e.params.duplicate()
			params["hp_fraction"] = float(params["hp_fraction"]) + constants.get_float(&"upgrade_hp_fraction")
			e.params = params
			return copy
	for e: EffectDef in effects:
		if e.type == &"apply_condition":
			e.stacks += 1
			return copy
	return copy


## "e1.amount+4;e2.stacks+1": the effect of that order gains the value.
static func _apply_exceptions(copy: AbilityDef, raw: String) -> void:
	for part: String in raw.split(";", false):
		var m := RegEx.create_from_string("^e(\\d+)\\.(\\w+)\\+(-?[\\d.]+)$").search(part.strip_edges())
		if m == null:
			continue
		var order: int = int(m.get_string(1))
		for e: EffectDef in copy.effects:
			if e.order == order:
				var field: String = m.get_string(2)
				var value: float = float(m.get_string(3))
				match field:
					"amount":
						e.amount += signf(e.amount if e.amount != 0.0 else 1.0) * value
					"stacks":
						e.stacks += int(value)
					"n":
						e.n += int(value)
