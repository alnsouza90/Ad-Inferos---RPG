class_name ExpeditionLight
extends RefCounted
## Light (Lume) rules (expedition §4). Pure functions over an int so the
## expedition, the battle and the desolation rules share one source.
## A light of -1 means "not in an expedition" (the M0 arena): every band
## effect is then neutral.

## Scale of the Light meter (glossary: 0 to 100). Structural bound, like the
## number of formation slots, not a balance number.
const LIGHT_MAX: int = 100
const NONE: int = -1

const BAND_HIGH: StringName = &"high"
const BAND_NEUTRAL: StringName = &"neutral"
const BAND_LOW: StringName = &"low"


static func start_value(constants: ConstantsDef) -> int:
	return constants.get_int(&"light_start")


## Expedition resumed from a consecrated camp (E03).
static func resume_value(constants: ConstantsDef) -> int:
	return constants.get_int(&"light_resume")


## Light lost when the party enters a node. Relics that change it (Vela da
## Candelária) hook in here in T25.
static func per_node(constants: ConstantsDef) -> int:
	return constants.get_int(&"light_per_node")


static func after_entering_node(light: int, constants: ConstantsDef) -> int:
	return clampi(light - per_node(constants), 0, LIGHT_MAX)


static func after_candle(light: int, constants: ConstantsDef) -> int:
	return clampi(light + constants.get_int(&"candle_light"), 0, LIGHT_MAX)


static func band(light: int, constants: ConstantsDef) -> StringName:
	if light < 0:
		return BAND_NEUTRAL
	if light >= constants.get_int(&"light_high_threshold"):
		return BAND_HIGH
	if light <= constants.get_int(&"light_low_threshold"):
		return BAND_LOW
	return BAND_NEUTRAL


static func desolation_multiplier(light: int, constants: ConstantsDef) -> float:
	match band(light, constants):
		BAND_HIGH:
			return constants.get_float(&"light_high_desolation_mult")
		BAND_LOW:
			return constants.get_float(&"light_low_desolation_mult")
	return 1.0


## Low Light: enemies deal more damage (expedition §4).
static func enemy_damage_multiplier(light: int, constants: ConstantsDef) -> float:
	if band(light, constants) == BAND_LOW:
		return constants.get_float(&"light_low_enemy_damage_mult")
	return 1.0


## Low Light: more Alms (expedition §4 and §8).
static func alms_multiplier(light: int, constants: ConstantsDef) -> float:
	if band(light, constants) == BAND_LOW:
		return constants.get_float(&"light_low_alms_mult")
	return 1.0


## High Light: fewer ambushes at camp (expedition §4 and §6).
static func ambush_multiplier(light: int, constants: ConstantsDef) -> float:
	if band(light, constants) == BAND_HIGH:
		return constants.get_float(&"light_high_ambush_mult")
	return 1.0
