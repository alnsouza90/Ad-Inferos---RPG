class_name HealEffect
extends EffectHandler
## combat §10. A heal on a Fallen saint inside the window raises them.


func apply(ctx: EffectContext, effect: EffectDef, target: Combatant) -> void:
	var amount: int = Damage.round_half_up(effect.amount * heal_multiplier(ctx.actor, target))
	var was_fallen: bool = target.is_fallen()
	var gained: int = ctx.state.heal(target, amount)
	if gained > 0 or not was_fallen:
		ctx.emit.call(&"revived" if was_fallen and gained > 0 else &"healed", {"target": target.id, "amount": gained, "hp": target.hp})


## Consolation (T08) and relics multiply healing; 1.0 until then.
func heal_multiplier(_actor: Combatant, _target: Combatant) -> float:
	return 1.0
