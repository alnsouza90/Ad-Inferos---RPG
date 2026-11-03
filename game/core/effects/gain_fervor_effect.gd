class_name GainFervorEffect
extends EffectHandler
## Extra Fervor for the party, within the per-round extra limit (combat §5).


func per_target() -> bool:
	return false


func apply(ctx: EffectContext, effect: EffectDef, _target: Combatant) -> void:
	var gained: int = ctx.fervor.gain_bonus(int(effect.amount))
	ctx.emit.call(&"fervor_gained", {"amount": gained, "total": ctx.fervor.amount, "bonus": true})
