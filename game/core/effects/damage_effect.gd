class_name DamageEffect
extends EffectHandler
## combat §9. Fallen saints and dead enemies cannot be damaged. A single-target
## hit from an enemy in Duel on the saint who declared it triggers the Duel
## counter-attack, queued after the hit (conditions §5).


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
	_maybe_duel_counter(ctx, effect, target)


func _maybe_duel_counter(ctx: EffectContext, effect: EffectDef, target: Combatant) -> void:
	var attacker: Combatant = ctx.actor
	if attacker == null or attacker.is_saint() or not target.is_saint():
		return
	if not attacker.has_condition(&"duel") or attacker.condition_sources.get(&"duel") != target.id:
		return
	if ctx.targets.size() != 1 or effect.target_override != &"":
		return
	if not target.is_standing() or target.has_condition(&"stun") or not attacker.is_standing():
		return
	var counter := EffectDef.new()
	counter.type = &"damage"
	counter.damage_type = &"strike"
	counter.amount = ctx.state.constants.get_float(&"duel_counter_damage")
	var counter_ctx := EffectContext.new()
	counter_ctx.state = ctx.state
	counter_ctx.fervor = ctx.fervor
	counter_ctx.actor = target
	counter_ctx.source_id = &"duel_counter"
	counter_ctx.targets = [attacker] as Array[Combatant]
	counter_ctx.queue = ctx.queue
	counter_ctx.emit = ctx.emit
	counter_ctx.allow_strength = false
	ctx.emit.call(&"duel_counter", {"saint": target.id, "target": attacker.id})
	ctx.queue.enqueue(counter_ctx, counter)
