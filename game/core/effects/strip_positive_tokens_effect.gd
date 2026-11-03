class_name StripPositiveTokensEffect
extends EffectHandler
## Removes every positive token from the target (O Cálice Partido...).


func apply(ctx: EffectContext, _effect: EffectDef, target: Combatant) -> void:
	var removed: Array[StringName] = ctx.state.strip_positive_tokens(target)
	if not removed.is_empty():
		ctx.emit.call(&"tokens_stripped", {"target": target.id, "conditions": removed})
