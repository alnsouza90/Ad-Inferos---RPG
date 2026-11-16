class_name Dominion
extends RefCounted
## The Domínio of a circle's boss (bosses.md §5.2, D-284, D-393): three claws
## that hold the Pilgrim's soul, each a concrete advantage of the boss. Each
## time the company reaches the Pilgrim a claw yields, in the order escort →
## extra action; the fish's liver always yields the extra phase.

const ESCORT: StringName = &"escort"
const EXTRA_ACTION: StringName = &"extra_action"
const EXTRA_PHASE: StringName = &"extra_phase"
## Order in which reaching the Pilgrim opens the claws.
const REACH_ORDER: Array[StringName] = [ESCORT, EXTRA_ACTION]


## Claws still holding, given how many times the company reached the
## Pilgrim in this expedition and whether it carries the fish's liver.
static func claws(reached: int, has_liver: bool) -> Array[StringName]:
	var held: Array[StringName] = []
	for i: int in REACH_ORDER.size():
		if reached <= i:
			held.append(REACH_ORDER[i])
	if not has_liver:
		held.append(EXTRA_PHASE)
	return held
