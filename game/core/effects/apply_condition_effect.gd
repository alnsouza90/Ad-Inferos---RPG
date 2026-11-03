class_name ApplyConditionEffect
extends EffectHandler
## Applies a condition through the condition engine (immunity, Will,
## stacking mode, limit; conditions.md §3.1). The engine emits the events.


func apply(ctx: EffectContext, effect: EffectDef, target: Combatant) -> void:
	ctx.state.engine.apply(target, effect.condition_id, effect.stacks, ctx.actor)
