class_name BlowWeight
extends RefCounted
## The weight of a character and the timing of its blow (D-353; the
## "phrase of the blow", docs/fable/03-animacao.md §3). Presentation only:
## seconds at speed 1, pixels at the view's own scale. The weight of each
## character is in tools/art/animation_characters.csv (CharacterFrames.weight).

const LIGHT: StringName = &"light"
const MEDIUM: StringName = &"medium"
const HEAVY: StringName = &"heavy"
const COLOSSAL: StringName = &"colossal"
const ALL: Array[StringName] = [LIGHT, MEDIUM, HEAVY, COLOSSAL]

## Light, medium and heavy follow the table of §3. Colossal (bosses, §9) is
## one step above heavy: the longest freeze, the strongest shake.
##   anticipation: crouch and widen before the blow
##   dash: stretch and slide
##   freeze: everything stops on the impact
##   consequence: the target recoils past its place and comes back
##   recovery: back home, settling with a small sway
##   recoil: how far this character is pushed back when hit (px)
##   overshoot: share of the recoil it swings past its place on the way back
##   shake: strength of the camera shake of its blow (1: as before)
##   push: how far the camera is pushed toward the side of its blow (px)
##   squash: how much it crouches (and widens) in the anticipation
const TABLE: Dictionary = {
	LIGHT: {"anticipation": 0.10, "dash": 0.10, "freeze": 0.06, "consequence": 0.20, "recovery": 0.25, "recoil": 22.0, "overshoot": 0.35, "shake": 0.7, "push": 10.0, "squash": 0.04},
	MEDIUM: {"anticipation": 0.18, "dash": 0.14, "freeze": 0.09, "consequence": 0.25, "recovery": 0.30, "recoil": 16.0, "overshoot": 0.3, "shake": 1.0, "push": 16.0, "squash": 0.06},
	HEAVY: {"anticipation": 0.32, "dash": 0.18, "freeze": 0.14, "consequence": 0.30, "recovery": 0.40, "recoil": 10.0, "overshoot": 0.25, "shake": 1.3, "push": 24.0, "squash": 0.08},
	COLOSSAL: {"anticipation": 0.40, "dash": 0.22, "freeze": 0.18, "consequence": 0.34, "recovery": 0.48, "recoil": 5.0, "overshoot": 0.2, "shake": 1.6, "push": 32.0, "squash": 0.09},
}


## The values of a weight; an unknown weight counts as medium.
static func of(weight: StringName) -> Dictionary:
	return TABLE.get(weight, TABLE[MEDIUM])


static func value(weight: StringName, key: String) -> float:
	return float(of(weight).get(key, 0.0))


## Seconds of the whole phrase (§3: light 0.71, medium 0.96, heavy 1.34).
static func phrase_time(weight: StringName) -> float:
	var w: Dictionary = of(weight)
	return float(w["anticipation"]) + float(w["dash"]) + float(w["freeze"]) + float(w["consequence"]) + float(w["recovery"])
