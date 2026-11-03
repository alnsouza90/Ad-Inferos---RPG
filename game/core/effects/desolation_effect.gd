class_name DesolationEffect
extends EffectHandler
## Changes desolation (positive raises, negative lowers). dark_night_amount
## replaces the amount when the target is in Dark Night. Multipliers and the
## Faith check arrive with the desolation system (T08).


func apply(ctx: EffectContext, effect: EffectDef, target: Combatant) -> void:
	if not target.is_saint() or target.is_out():
		return
	var amount: float = effect.amount
	if target.is_dark_night() and effect.params.has("dark_night_amount"):
		amount = float(effect.params["dark_night_amount"])
	var before: int = target.desolation
	ctx.state.add_desolation(target, int(amount))
	ctx.emit.call(&"desolation_changed", {"target": target.id, "old": before, "new": target.desolation, "source": ctx.source_id})
