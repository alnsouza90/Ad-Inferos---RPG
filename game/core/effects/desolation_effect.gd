class_name DesolationEffect
extends EffectHandler
## Changes desolation (positive raises, negative lowers) through the
## desolation rules. dark_night_amount replaces the amount when the target is
## in Dark Night (Na Noite Escura).


func apply(ctx: EffectContext, effect: EffectDef, target: Combatant) -> void:
	if not target.is_saint() or not target.is_standing():
		return
	var amount: float = effect.amount
	if target.is_dark_night() and effect.params.has("dark_night_amount"):
		amount = float(effect.params["dark_night_amount"])
	ctx.state.add_desolation(target, int(amount), ctx.source_id)
