class_name ReviveEffect
extends EffectHandler
## Raises a Fallen saint with hp_fraction of max hp. With heal_if_alive=1 a
## standing target is healed by the same fraction instead (Rosa no Inverno).


func apply(ctx: EffectContext, effect: EffectDef, target: Combatant) -> void:
	var amount: int = Damage.round_half_up(target.max_hp * float(effect.params.get("hp_fraction", 0.0)))
	if target.is_fallen():
		var gained: int = ctx.state.revive(target, amount)
		if gained > 0:
			ctx.emit.call(&"revived", {"target": target.id, "amount": gained, "hp": target.hp})
	elif target.is_standing() and float(effect.params.get("heal_if_alive", 0.0)) > 0.0:
		var healed: int = ctx.state.heal(target, amount)
		ctx.emit.call(&"healed", {"target": target.id, "amount": healed, "hp": target.hp})
