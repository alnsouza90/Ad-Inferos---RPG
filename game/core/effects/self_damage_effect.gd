class_name SelfDamageEffect
extends EffectHandler
## A life cost paid by the user (Estigmas): amount, or hp_fraction of max hp.
## It ignores armor and Ward because it is a cost, not an attack.


func per_target() -> bool:
	return false


func apply(ctx: EffectContext, effect: EffectDef, _target: Combatant) -> void:
	var actor: Combatant = ctx.actor
	if actor == null or not actor.is_standing():
		return
	var cost: int = int(effect.amount)
	if effect.params.has("hp_fraction"):
		cost = Damage.round_half_up(actor.max_hp * float(effect.params["hp_fraction"]))
	var lost: int = ctx.state.lose_hp(actor, maxi(cost, 1))
	ctx.emit.call(&"self_damaged", {"target": actor.id, "amount": lost, "hp": actor.hp})
	if not actor.is_standing():
		ctx.emit.call(&"fell", {"target": actor.id})
