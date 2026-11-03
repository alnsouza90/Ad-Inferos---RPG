class_name DamageEffect
extends EffectHandler
## combat §9. Fallen saints and dead enemies cannot be damaged.


func apply(ctx: EffectContext, effect: EffectDef, target: Combatant) -> void:
	if not target.is_standing():
		return
	var strength: bool = ctx.use_strength() if effect.amount > 0.0 else false
	var result: Dictionary = Damage.compute(ctx.state, ctx.actor, target, effect, strength)
	if result["ward"]:
		ctx.state.remove_condition_stacks(target, &"ward", 1)
		ctx.emit.call(&"condition_consumed", {"target": target.id, "condition": &"ward"})
	var lost: int = ctx.state.lose_hp(target, int(result["damage"]))
	ctx.emit.call(&"damage_dealt", {"source": ctx.actor.id if ctx.actor != null else &"", "target": target.id, "amount": lost, "type": effect.damage_type, "warded": result["ward"], "strength": strength, "hp": target.hp})
	if not target.is_standing():
		ctx.emit.call(&"fell" if target.is_saint() else &"enemy_died", {"target": target.id})
