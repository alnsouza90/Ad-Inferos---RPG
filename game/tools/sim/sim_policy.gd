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
## T61: Interceder for an ally at or above this, when the intercessor is at
## or below INTERCEDE_OWN_MAX; give the Consolation to an ally at or above
## GIFT_ABOVE_DESOLATION (or in the Dark Night, or Fallen).
const INTERCEDE_ALLY_MIN: int = 70
const INTERCEDE_OWN_MAX: int = 50
const GIFT_ABOVE_DESOLATION: int = 60
## The miracle is kept for when it pays: this much better than the best
## ability, or when the Fervor would be wasted at the cap (T61, step 0).
const MIRACLE_ADVANTAGE: float = 1.5

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
		var support: Array[BattleCommand] = options.filter(func(c: BattleCommand) -> bool: return c.type == BattleCommand.INTERCEDE or c.type == BattleCommand.GIVE_CONSOLATION)
		var stunned: bool = saint.has_condition(&"stun")
		var cmd: BattleCommand
		match kind:
			RANDOM:
				var acts: Array[BattleCommand] = options.filter(func(c: BattleCommand) -> bool: return c.type != BattleCommand.USE_PROVISION)
				cmd = acts[rng.pick_index(acts.size())]
			GREEDY:
				cmd = _best_damage(ctrl, useful)
			_:
				cmd = _heuristic(ctrl, saint, useful, support)
		if cmd == null:
			cmd = BattleCommand.pass_turn(saint.id)
		return {"cmd": cmd, "saint": saint.id, "useful": stunned or not useful.is_empty()}
	return {"cmd": BattleCommand.end_party_turn(), "saint": &"", "useful": true}


func _heuristic(ctrl: BattleController, saint: Combatant, useful: Array[BattleCommand], support: Array[BattleCommand] = []) -> BattleCommand:
	var gift: BattleCommand = _gift(ctrl, support)
	if gift != null:
		return gift
	var miracles: Array[BattleCommand] = useful.filter(func(c: BattleCommand) -> bool: return c.type == BattleCommand.USE_MIRACLE)
	if not miracles.is_empty() and _miracle_pays(ctrl, miracles, useful):
		return _best_overall(ctrl, miracles)
	useful = useful.filter(func(c: BattleCommand) -> bool: return c.type != BattleCommand.USE_MIRACLE)
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
	var intercede: BattleCommand = _intercede(ctrl, saint, support)
	if intercede != null:
		return intercede
	return _best_damage(ctrl, useful)


## T61 step 0: the old heuristic spent all the Fervor on George's miracle as
## soon as it could. Now the miracle waits until it beats the best ability
## clearly, or until the Fervor would overflow the cap next round.
func _miracle_pays(ctrl: BattleController, miracles: Array[BattleCommand], useful: Array[BattleCommand]) -> bool:
	var c: ConstantsDef = ctrl.state.constants
	if ctrl.fervor.amount + c.get_int(&"fervor_per_round") > c.get_int(&"fervor_cap"):
		return true
	var others: Array[BattleCommand] = useful.filter(func(cmd: BattleCommand) -> bool: return cmd.type != BattleCommand.USE_MIRACLE)
	if others.is_empty():
		return true
	var best_miracle: Dictionary = _score(ctrl, _best_overall(ctrl, miracles))
	var best_other: Dictionary = _score(ctrl, _best_overall(ctrl, others))
	var m: float = float(best_miracle["damage"]) + float(best_miracle["heal"])
	var o: float = float(best_other["damage"]) + float(best_other["heal"])
	return m >= o * MIRACLE_ADVANTAGE


## The gift of Consolation (D-285): to an ally in the Dark Night first, then
## a Fallen one, then the most desolate one above GIFT_ABOVE_DESOLATION.
func _gift(ctrl: BattleController, support: Array[BattleCommand]) -> BattleCommand:
	var best: BattleCommand = null
	var best_value := -1
	for cmd: BattleCommand in support:
		if cmd.type != BattleCommand.GIVE_CONSOLATION:
			continue
		var t: Combatant = ctrl.state.party_at(cmd.target_slots[0])
		var value := -1
		if t.spirit_state == Desolation.DARK_NIGHT:
			value = 1000
		elif t.is_fallen():
			value = 500
		elif t.desolation >= GIFT_ABOVE_DESOLATION:
			value = t.desolation
		if value > best_value:
			best_value = value
			best = cmd
	return best if best_value >= 0 else null


## Interceder (D-268): for the most desolate ally at or above
## INTERCEDE_ALLY_MIN, when the intercessor himself is calm enough.
func _intercede(ctrl: BattleController, saint: Combatant, support: Array[BattleCommand]) -> BattleCommand:
	if saint.desolation > INTERCEDE_OWN_MAX or saint.spirit_state == Desolation.DARK_NIGHT:
		return null
	var best: BattleCommand = null
	var best_value := INTERCEDE_ALLY_MIN - 1
	for cmd: BattleCommand in support:
		if cmd.type != BattleCommand.INTERCEDE:
			continue
		var t: Combatant = ctrl.state.party_at(cmd.target_slots[0])
		if t.desolation > best_value:
			best_value = t.desolation
			best = cmd
	return best


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
