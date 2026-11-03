class_name EffectContext
extends RefCounted
## What every effect of one command can see: the battle, the Fervor pool, who
## acts, the targets chosen for the ability, and a way to emit events.
## Strength is decided once per action (combat §9: consumed once, applies to
## every target and hit of that action).

var state: BattleState
var fervor: FervorPool
var actor: Combatant
var source_id: StringName
var targets: Array[Combatant] = []
var queue: EffectQueue
var emit: Callable

## False for reactions such as the Duel counter-attack, which are not the
## saint's own action and must not spend their Strength.
var allow_strength: bool = true

var _strength_checked: bool = false
var _strength_active: bool = false


## Called by the first damage effect of the action. Consumes one Strength
## stack the first time if the actor has it; later calls repeat the answer.
func use_strength() -> bool:
	if not _strength_checked:
		_strength_checked = true
		if allow_strength and actor != null and actor.has_condition(&"strength"):
			state.remove_condition_stacks(actor, &"strength", 1)
			_strength_active = true
			emit.call(&"condition_consumed", {"target": actor.id, "condition": &"strength"})
	return _strength_active
