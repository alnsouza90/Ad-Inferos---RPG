class_name SimPolicy
extends RefCounted
## Automatic players for the balance simulator (testing.md §5.1). A policy
## picks the next command for the first saint who can still act; when nobody
## can, it ends the party turn.

const RANDOM: StringName = &"random"
const GREEDY: StringName = &"greedy"
const HEURISTIC: StringName = &"heuristic"
const ALL: Array[StringName] = [RANDOM, GREEDY, HEURISTIC]
## Heuristic thresholds come from testing.md §5.1 (they describe the policy,
## not the game's balance).
const HEAL_BELOW_HP_PCT: float = 0.40
const RELIEVE_ABOVE_DESOLATION: int = 80

var kind: StringName
var rng: RngStream


func _init(p_kind: StringName, p_rng: RngStream) -> void:
	kind = p_kind
	rng = p_rng


## Next command, plus whether the acting saint had a useful option (an
## ability or miracle) at all. Returns {"cmd": BattleCommand, "saint": id or &"", "useful": bool}.
func next(ctrl: BattleController) -> Dictionary:
	for saint: Combatant in ctrl.state.party:
		if not saint.is_standing() or saint.has_acted:
			continue
		var options: Array[BattleCommand] = CommandCandidates.for_saint(ctrl, saint, true)
		var useful: Array[BattleCommand] = options.filter(func(c: BattleCommand) -> bool: return c.type == BattleCommand.USE_ABILITY or c.type == BattleCommand.USE_MIRACLE)
		var stunned: bool = saint.has_condition(&"stun")
		var cmd: BattleCommand
		match kind:
			RANDOM:
				var acts: Array[BattleCommand] = options.filter(func(c: BattleCommand) -> bool: return c.type != BattleCommand.USE_PROVISION)
				cmd = acts[rng.pick_index(acts.size())]
			GREEDY:
				cmd = _best_damage(ctrl, useful)
			_:
				cmd = _heuristic(ctrl, saint, useful)
		if cmd == null:
			cmd = BattleCommand.pass_turn(saint.id)
		return {"cmd": cmd, "saint": saint.id, "useful": stunned or not useful.is_empty()}
	return {"cmd": BattleCommand.end_party_turn(), "saint": &"", "useful": true}


func _heuristic(ctrl: BattleController, saint: Combatant, useful: Array[BattleCommand]) -> BattleCommand:
	var miracles: Array[BattleCommand] = useful.filter(func(c: BattleCommand) -> bool: return c.type == BattleCommand.USE_MIRACLE)
	if not miracles.is_empty():
		return _best_overall(ctrl, miracles)
	var wounded: bool = ctrl.state.party.any(func(c: Combatant) -> bool: return c.is_fallen() or (c.is_standing() and c.hp < HEAL_BELOW_HP_PCT * c.max_hp))
	if wounded:
		var heal: BattleCommand = _best_heal(ctrl, useful)
		if heal != null:
			return heal
	var troubled: bool = ctrl.state.party.any(func(c: Combatant) -> bool: return c.is_standing() and c.desolation > RELIEVE_ABOVE_DESOLATION)
	if troubled:
		var relief: BattleCommand = _best_relief(ctrl, useful)
		if relief != null:
			return relief
	return _best_damage(ctrl, useful)


## Fast estimate of the immediate damage to enemies and healing to saints,
## with the real damage formula on the current state (no copy of the battle).
func _score(ctrl: BattleController, cmd: BattleCommand) -> Dictionary:
	var damage := 0
	var heal := 0
	var actor: Combatant = ctrl.state.find(cmd.actor_id)
	var ability: AbilityDef = ctrl.state.catalog.ability(actor.miracle if cmd.type == BattleCommand.USE_MIRACLE else cmd.ability_id)
	if ability == null:
		return {"damage": 0, "heal": 0}
	var targets: Array[Combatant] = ctrl._resolve_targets(actor, ability, cmd.target_slots)
	var ctx: EffectContext = ctrl.new_effect_context(actor, ability.id, targets)
	var strength: bool = actor.has_condition(&"strength")
	for effect: EffectDef in ability.effects:
		for target: Combatant in EffectQueue.resolve_targets(ctx, effect):
			match effect.type:
				&"damage":
					if not target.is_saint() and target.is_standing():
						damage += mini(target.hp, int(Damage.compute(ctrl.state, actor, target, effect, strength)["damage"]))
				&"heal":
					var amount: int = Damage.round_half_up(effect.amount * Damage.consolation_multiplier(ctrl.state.constants, actor))
					heal += amount if target.is_fallen() else mini(amount, target.max_hp - target.hp)
				&"revive":
					if target.is_fallen():
						heal += Damage.round_half_up(target.max_hp * float(effect.params.get("hp_fraction", 0.0)))
	return {"damage": damage, "heal": heal}


func _best_damage(ctrl: BattleController, cmds: Array[BattleCommand]) -> BattleCommand:
	return _best_by(ctrl, cmds, func(sc: Dictionary) -> int: return int(sc["damage"]))


func _best_heal(ctrl: BattleController, cmds: Array[BattleCommand]) -> BattleCommand:
	var best: BattleCommand = _best_by(ctrl, cmds, func(sc: Dictionary) -> int: return int(sc["heal"]))
	return best if best != null and int(_score(ctrl, best)["heal"]) > 0 else null


func _best_overall(ctrl: BattleController, cmds: Array[BattleCommand]) -> BattleCommand:
	return _best_by(ctrl, cmds, func(sc: Dictionary) -> int: return int(sc["damage"]) + int(sc["heal"]))


## Desolation relief: the command that lowers the party's desolation the most.
func _best_relief(ctrl: BattleController, cmds: Array[BattleCommand]) -> BattleCommand:
	var best: BattleCommand = null
	var best_value := 0
	for cmd: BattleCommand in cmds:
		var copy: BattleController = ctrl.clone()
		var before := 0
		for c: Combatant in copy.state.party:
			before += c.desolation
		copy.execute(cmd)
		var after := 0
		for c: Combatant in copy.state.party:
			after += c.desolation
		if before - after > best_value:
			best_value = before - after
			best = cmd
	return best


func _best_by(ctrl: BattleController, cmds: Array[BattleCommand], value: Callable) -> BattleCommand:
	var best: BattleCommand = null
	var best_value := -1
	for cmd: BattleCommand in cmds:
		var v: int = value.call(_score(ctrl, cmd))
		if v > best_value:
			best_value = v
			best = cmd
	return best
