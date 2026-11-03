class_name MoveEffect
extends EffectHandler
## Forced movement (combat §2.3): push moves back, pull moves forward.
## swap with=actor trades places with the user without spending anyone's action.


func apply(ctx: EffectContext, effect: EffectDef, target: Combatant) -> void:
	if not target.is_standing() and not target.is_fallen():
		return
	var before: int = _slot(ctx, target)
	match effect.move_kind:
		&"push":
			_move(ctx, target, effect.n)
		&"pull":
			_move(ctx, target, -effect.n)
		&"swap":
			if str(effect.params.get("with", "")) == "actor" and ctx.actor != null and target.is_saint():
				ctx.state.swap_party_members(ctx.actor, target)
	var after: int = _slot(ctx, target)
	if after != before:
		ctx.emit.call(&"moved", {"target": target.id, "from": before, "to": after})


func _move(ctx: EffectContext, target: Combatant, delta: int) -> void:
	if target.is_saint():
		ctx.state.move_party(target, delta)
	else:
		ctx.state.move_enemy(target, delta)


func _slot(ctx: EffectContext, target: Combatant) -> int:
	return ctx.state.party_slot_of(target) if target.is_saint() else ctx.state.enemy_slot_of(target)
