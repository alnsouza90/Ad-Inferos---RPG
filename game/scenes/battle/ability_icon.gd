class_name AbilityIcon
extends RefCounted
## The stained-glass mosaic of an ability's lancet (D-297, D-436 to D-438):
## one per kind of ability, chosen by its main effect (Art Bible §8.2: an
## ability with two effects uses the icon of the first one that names a
## kind). Presentation only: reads the effects, never decides a rule.

const STRIKE: StringName = &"strike"
const EXORCISM: StringName = &"exorcism"
const HEAL: StringName = &"heal"
const RELIEF: StringName = &"relief"
const WARD: StringName = &"ward"
const STRENGTH: StringName = &"strength"
const CLEANSE: StringName = &"cleanse"
const RAISE: StringName = &"raise"
const DISPLACE: StringName = &"displace"
const STRIP: StringName = &"strip"
## A shield blow: the shield in a blood tint, apart from the shield that
## protects (D-440).
const SHIELD_STRIKE: StringName = &"shield_strike"
## Abilities whose drawing is not the one of their main effect (Alan,
## D-440): George's Golpe de Escudo strikes with the shield, not the spear.
const DRAWN_AS: Dictionary = {&"george_shield_bash": SHIELD_STRIKE}
const LANCET_PATH: String = "res://assets/pixel/ui/lancets/lancet_%s_%s.png"
const ROSE_PATH: String = "res://assets/pixel/ui/roses/rose_%s_%s.png"


static func of(def: AbilityDef) -> StringName:
	if def == null:
		return STRIKE
	if DRAWN_AS.has(def.id):
		return DRAWN_AS[def.id]
	for e: EffectDef in def.effects:
		var kind: StringName = _kind_of(e)
		if kind != &"":
			return kind
	# Only conditions that name no kind (a duel, a stun): by whom it aims at.
	return STRIKE if def.targeting.begins_with("enemy") else WARD


static func _kind_of(e: EffectDef) -> StringName:
	match e.type:
		&"damage":
			return STRIKE if e.damage_type == &"strike" else EXORCISM
		&"heal":
			return HEAL
		&"revive":
			return RAISE
		&"desolation":
			return RELIEF if e.amount < 0 else &""
		&"remove_condition":
			return CLEANSE
		&"strip_positive_tokens":
			return STRIP
		&"move":
			return DISPLACE
		&"apply_condition":
			if e.condition_id == &"ward":
				return WARD
			if e.condition_id == &"strength":
				return STRENGTH
	return &""


## The lancet of `kind` in a state ("on", "chosen", "off"); null without art.
static func lancet(kind: StringName, state: String) -> Texture2D:
	var path: String = LANCET_PATH % [kind, state]
	return load(path) as Texture2D if ResourceLoader.exists(path) else null


## The rose of a saint's miracle ("on", "off"); null without art (the
## plain rose stays).
static func rose(saint_def_id: StringName, state: String) -> Texture2D:
	var path: String = ROSE_PATH % [saint_def_id, state]
	return load(path) as Texture2D if ResourceLoader.exists(path) else null
