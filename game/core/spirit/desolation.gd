class_name Desolation
extends RefCounted
## Desolation, the Faith check and spiritual states (desolation.md).
## No state means sin or loss of holiness; the saint never loses control.
## Battle-independent: it works on a Combatant and a context, so the
## expedition and the village (later) can use the same rules.

const NORMAL: StringName = &"normal"
const CONSOLATION: StringName = &"consolation"
const DARK_NIGHT: StringName = &"dark_night"
const INJURY_MAJOR: StringName = &"major"


## Gains pass through every multiplier; reductions never do (§2). Then the
## thresholds are checked: 100 (Faith check), < 50 in Dark Night
## (Purification) and 200 (Prostration).
static func change(saint: Combatant, amount: int, source: StringName, ctx: DesolationContext) -> void:
	if amount == 0 or not saint.is_saint():
		return
	var delta: int = amount
	if amount > 0:
		delta = Damage.round_half_up(amount * gain_multiplier(saint, ctx))
	var maximum: int = ctx.constants.get_int(&"desolation_max")
	var before: int = saint.desolation
	saint.desolation = clampi(before + delta, 0, maximum)
	ctx.emit.call(&"desolation_changed", {"target": saint.id, "old": before, "new": saint.desolation, "source": source})
	if saint.desolation >= maximum:
		_prostrate(saint, ctx)
		return
	var threshold: int = ctx.constants.get_int(&"faith_check_threshold")
	if before < threshold and saint.desolation >= threshold and saint.spirit_state != DARK_NIGHT:
		if saint.spirit_state == CONSOLATION:
			_set_state(saint, NORMAL, ctx)
		faith_check(saint, ctx)
	elif saint.spirit_state == DARK_NIGHT and saint.desolation < ctx.constants.get_int(&"dark_night_exit_threshold"):
		_purify(saint, ctx)


static func gain_multiplier(saint: Combatant, ctx: DesolationContext) -> float:
	var mult: float = light_multiplier(ctx)
	mult *= ctx.affinity_mult
	mult *= ctx.trait_mult
	mult *= ctx.relic_mult
	mult *= ctx.season_mult
	if saint.spirit_state == CONSOLATION:
		mult *= ctx.constants.get_float(&"consolation_desolation_mult")
	return mult


## Light bands apply only during expeditions (light < 0 means none).
static func light_multiplier(ctx: DesolationContext) -> float:
	return ExpeditionLight.desolation_multiplier(ctx.light, ctx.constants)


static func faith_chance(saint: Combatant, ctx: DesolationContext) -> float:
	var c: ConstantsDef = ctx.constants
	var chance: float = c.get_float(&"faith_check_base") + c.get_float(&"faith_check_per_point") * saint.faith + ctx.faith_bonus
	return minf(c.get_float(&"faith_check_cap"), chance)


## §3: success → Consolation and desolation back to [consolation_reset_value];
## failure → Dark Night, desolation unchanged.
static func faith_check(saint: Combatant, ctx: DesolationContext) -> bool:
	var chance: float = faith_chance(saint, ctx)
	var roll: float = ctx.rng.next_float()
	var success: bool = roll < chance
	ctx.emit.call(&"faith_check", {"target": saint.id, "chance": chance, "roll": roll, "success": success})
	if success:
		var before: int = saint.desolation
		saint.desolation = ctx.constants.get_int(&"consolation_reset_value")
		ctx.emit.call(&"desolation_changed", {"target": saint.id, "old": before, "new": saint.desolation, "source": &"consolation"})
		_set_state(saint, CONSOLATION, ctx)
	else:
		_set_state(saint, DARK_NIGHT, ctx)
	return success


## Dev tools only (T17, D-117): the outcome of a successful Faith check
## without the roll, so the Consolation look can be checked on screen.
static func force_consolation(saint: Combatant, ctx: DesolationContext) -> void:
	if not saint.is_saint() or saint.spirit_state == CONSOLATION:
		return
	var before: int = saint.desolation
	saint.desolation = ctx.constants.get_int(&"consolation_reset_value")
	ctx.emit.call(&"desolation_changed", {"target": saint.id, "old": before, "new": saint.desolation, "source": &"dev_tools"})
	_set_state(saint, CONSOLATION, ctx)


static func _purify(saint: Combatant, ctx: DesolationContext) -> void:
	_set_state(saint, NORMAL, ctx)
	saint.purified = true
	ctx.emit.call(&"purification", {"target": saint.id})


## §5: Consolation is lost; Dark Night is kept. In battle the saint falls with
## no way to be raised and the allies gain no "ally fallen" desolation.
static func _prostrate(saint: Combatant, ctx: DesolationContext) -> void:
	saint.desolation = ctx.constants.get_int(&"prostration_reset_value")
	saint.pending_injury = INJURY_MAJOR
	if saint.spirit_state == CONSOLATION:
		_set_state(saint, NORMAL, ctx)
	ctx.emit.call(&"prostration", {"target": saint.id, "desolation": saint.desolation})
	if ctx.battle != null and saint.is_standing():
		ctx.battle.prostrate(saint)
		ctx.emit.call(&"fell", {"target": saint.id, "cause": BattleState.CAUSE_PROSTRATION})


static func _set_state(saint: Combatant, new_state: StringName, ctx: DesolationContext) -> void:
	if saint.spirit_state == new_state:
		return
	var old: StringName = saint.spirit_state
	saint.spirit_state = new_state
	ctx.emit.call(&"state_changed", {"target": saint.id, "old": old, "new": new_state})
