class_name RemoveConditionEffect
extends EffectHandler
## Removes stacks of one condition, or of any condition with a polarity.


func apply(ctx: EffectContext, effect: EffectDef, target: Combatant) -> void:
	var removed: int
	if effect.condition_id != &"":
		removed = ctx.state.remove_condition_stacks(target, effect.condition_id, effect.stacks)
	else:
		removed = ctx.state.remove_stacks_by_polarity(target, effect.polarity, effect.stacks)
	if removed > 0:
		ctx.emit.call(&"condition_removed", {"target": target.id, "condition": effect.condition_id, "polarity": effect.polarity, "stacks": removed})
