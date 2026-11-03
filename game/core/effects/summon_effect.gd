class_name SummonEffect
extends EffectHandler
## Enemies only: adds `summon_id` at the first free slot, if there is room and
## fewer than `max_alive` of it are alive.


func per_target() -> bool:
	return false


func apply(ctx: EffectContext, effect: EffectDef, _target: Combatant) -> void:
	var def: EnemyDef = ctx.state.catalog.enemies.get(effect.summon_id)
	if def == null:
		return
	var alive: int = ctx.state.enemies.filter(func(e: Combatant) -> bool: return e.def_id == effect.summon_id and e.is_alive_enemy()).size()
	if alive >= effect.max_alive or ctx.state.occupied_enemy_slots() + def.size > BattleState.MAX_ENEMY_SLOTS:
		return
	var summoned: Combatant = ctx.state.add_enemy(def)
	ctx.emit.call(&"summoned", {"enemy": summoned.id, "slot": ctx.state.enemy_slot_of(summoned)})
