class_name ApplyConditionEffect
extends EffectHandler
## Adds stacks of a condition. The full rules (Will, immunity, stacking modes)
## arrive with the condition engine (conditions.md, T07).


func apply(ctx: EffectContext, effect: EffectDef, target: Combatant) -> void:
	if not target.is_standing():
		return
	var added: int = ctx.state.add_condition_stacks(target, effect.condition_id, effect.stacks)
	ctx.emit.call(&"condition_applied", {"target": target.id, "condition": effect.condition_id, "stacks": added, "total": target.stacks(effect.condition_id)})
