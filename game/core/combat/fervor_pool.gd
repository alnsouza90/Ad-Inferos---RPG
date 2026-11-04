class_name FervorPool
extends RefCounted
## The party's shared Fervor (combat §5). Base gain at each ROUND_START, a cap,
## and a per-round limit on extra gains. Only Fervor that actually enters the
## pool counts against the extra limit (decision of 03/11/2026).

var amount: int = 0
var cap: int
var per_round: int
var bonus_cap_per_round: int
var bonus_gained_this_round: int = 0


func _init(constants: ConstantsDef) -> void:
	cap = constants.get_int(&"fervor_cap")
	per_round = constants.get_int(&"fervor_per_round")
	bonus_cap_per_round = constants.get_int(&"fervor_bonus_cap_per_round")


## ROUND_START step 1. Returns the Fervor actually gained.
func start_round() -> int:
	bonus_gained_this_round = 0
	return _add(per_round)


## Extra Fervor from abilities, traits or affinities. Returns what entered.
func gain_bonus(value: int) -> int:
	if value <= 0:
		return 0
	var allowed: int = mini(value, bonus_cap_per_round - bonus_gained_this_round)
	var gained: int = _add(allowed)
	bonus_gained_this_round += gained
	return gained


## Starting Fervor from camp Prayers (expedition §6): enters at round 1
## within the cap, outside the per-round extra limit.
func add_initial(value: int) -> int:
	return _add(value)


func can_afford(cost: int) -> bool:
	return cost <= amount


func spend(cost: int) -> bool:
	if cost < 0 or not can_afford(cost):
		return false
	amount -= cost
	return true


## Between battles Fervor returns to 0 (combat §11).
func reset() -> void:
	amount = 0
	bonus_gained_this_round = 0


func _add(value: int) -> int:
	if value <= 0:
		return 0
	var gained: int = mini(value, cap - amount)
	amount += gained
	return gained
