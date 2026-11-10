class_name AnimationStyle
extends RefCounted
## Which animation an action plays (Alan, D-233), read from the data the
## action already has, never from a new rule: a blow (`strike` damage) is a
## physical attack and slides to the target; damage of any other type
## (`exorcism`, `untyped`) is spiritual and is cast from where the caster
## stands; an action on the own side with no damage is a blessing (support).

const PHYSICAL: StringName = &"physical"
const SPIRITUAL: StringName = &"spiritual"
const BLESSING: StringName = &"blessing"

const ENEMY_SIDE: Array[StringName] = [&"enemy", &"all_enemies", &"enemy_group"]


static func of(effects: Array[EffectDef], targeting: StringName) -> StringName:
	var has_damage: bool = false
	for e: EffectDef in effects:
		if e.type != &"damage":
			continue
		if e.damage_type == &"strike":
			return PHYSICAL
		has_damage = true
	if has_damage or _aims_at_enemies(targeting):
		return SPIRITUAL
	return BLESSING


static func _aims_at_enemies(targeting: StringName) -> bool:
	return ENEMY_SIDE.has(targeting) or String(targeting).begins_with("chosen_enemy_slots")
