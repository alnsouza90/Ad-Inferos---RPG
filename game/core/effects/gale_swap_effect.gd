class_name GaleSwapEffect
extends EffectHandler
## The Vendaval of Asmodeus (bosses.md §5.1): the two saints marked when the
## intent was chosen swap places in the boss's turn, unless a saint stood firm
## (§2.2). The marks are cleared either way.


func per_target() -> bool:
	return false


func apply(ctx: EffectContext, _effect: EffectDef, _target: Combatant) -> void:
	var state: BattleState = ctx.state
	var slots: Array[int] = state.gale_slots.duplicate()
	if slots.size() != 2:
		return
	if state.gale_will_swap():
		var a: Combatant = state.party_at(slots[0])
		var b: Combatant = state.party_at(slots[1])
		state.swap_party_members(a, b)
		ctx.emit.call(&"gale_swapped", {"slots": slots})
		ctx.emit.call(&"moved", {"target": a.id, "from": slots[0], "to": slots[1]})
		ctx.emit.call(&"moved", {"target": b.id, "from": slots[1], "to": slots[0]})
	else:
		ctx.emit.call(&"gale_held", {"slots": slots, "reason": &"stood_firm"})
	state.gale_slots.clear()
	state.gale_held = false
