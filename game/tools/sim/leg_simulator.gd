class_name LegSimulator
extends RefCounted
## Plays whole M1 legs without a screen (T31, testing.md §5.3): the real
## ExpeditionController from the gate to the end, with a battle policy of
## testing.md §5.1 plus simple choices for paths, the Temptation, relics,
## field provisions and the camp. Every action is an ExpeditionCommand, as
## in the game. Pure logic: run_sim.gd handles the command line and files.

## Path choices at a fork.
const PATH_RANDOM: StringName = &"random"
const PATH_SAFE: StringName = &"safe"
## Holy Water at a fork when a saint reaches this desolation (policy, not balance).
const HOLY_WATER_AT: int = 50
## At camp, a saint at or above this desolation keeps Vigil (policy).
const VIGIL_AT: int = 40
## Event options: the risky one is taken when its chance reaches this (policy).
const RISK_CHANCE_AT: float = 0.7
## Incense: KEEP saves it for the camp (it cancels the ambush); REVEAL burns
## it at the first fork where it shows something (policy, D-129).
const INCENSE_KEEP: StringName = &"keep"
const INCENSE_REVEAL: StringName = &"reveal"
## Safety stop for a leg that would never end.
const MAX_COMMANDS: int = 5000

var catalog: ExpeditionCatalog
var circle: StringName = &"circle_02"
var kit: StringName = &"m1_kit"
var incense_policy: StringName = INCENSE_REVEAL
## One Dictionary per leg played.
var legs: Array[Dictionary] = []
## One Dictionary per battle played inside the legs.
var battles: Array[Dictionary] = []


func _init(p_catalog: ExpeditionCatalog) -> void:
	catalog = p_catalog


func run(runs: int, battle_policies: Array[StringName], path_policy: StringName, seed: int) -> void:
	for policy: StringName in battle_policies:
		for i: int in runs:
			legs.append(play_leg(policy, path_policy, seed + i))


## One leg from the gate. Returns its metrics; its battles go to `battles`.
func play_leg(battle_policy: StringName, path_policy: StringName, campaign_seed: int) -> Dictionary:
	var map_seed: int = ExpeditionController.map_seed_for(campaign_seed, circle, 1)
	var ctrl := ExpeditionController.start_new(catalog, circle, map_seed, GameData.M0_FORMATION, catalog.kit_provisions(kit), EncounterDef.ARENA_CIRCLE)
	var rng := RngStream.new(campaign_seed, &"sim_leg")
	var policy := SimPolicy.new(battle_policy, RngStream.new(campaign_seed, &"sim_policy"))
	var dark_night: Dictionary = {}
	var leg := {
		"policy": battle_policy, "seed": campaign_seed, "battles": 0, "ambush": false, "event_option": &"",
		"event_success": true, "relic": false, "commands": 0, "rounds": 0, "peak_desolation": 0,
	}
	var battle_kind: StringName = &"easy"
	var battle_rounds_start := 0
	var history_seen := 0
	for i: int in MAX_COMMANDS:
		if ctrl.is_over():
			break
		var cmd: ExpeditionCommand = _next(ctrl, policy, rng, path_policy)
		if cmd == null:
			break
		var phase_before: ExpeditionController.Phase = ctrl.phase
		var battle_before: BattleController = ctrl.battle
		var reason: StringName = ctrl.execute(cmd)
		assert(reason == &"", "leg policy chose a refused command: %s (%s)" % [cmd.to_dict(), reason])
		leg["commands"] = int(leg["commands"]) + 1
		if ctrl.battle != null and ctrl.battle != battle_before:
			# A new battle: the ambush after resting is from the hard pool (M1).
			battle_kind = &"hard" if phase_before == ExpeditionController.Phase.AT_CAMP else &"easy"
			if battle_kind == &"hard":
				leg["ambush"] = true
		if battle_before != null and ctrl.battle == null:
			battles.append(_battle_row(battle_policy, battle_kind, battle_before))
			leg["battles"] = int(leg["battles"]) + 1
			leg["rounds"] = int(leg["rounds"]) + battle_before.state.round_number
			for e: BattleEvent in battle_before.history:
				if e.type == &"state_changed" and e.data["new"] == Desolation.DARK_NIGHT:
					dark_night[e.data["target"]] = true
		for id: StringName in ctrl.state.party:
			var status: SaintStatus = ctrl.saints[id]
			if status.spirit_state == Desolation.DARK_NIGHT:
				dark_night[id] = true
			leg["peak_desolation"] = maxi(int(leg["peak_desolation"]), status.desolation)
		if ctrl.battle != null:
			for saint: Combatant in ctrl.battle.state.party:
				leg["peak_desolation"] = maxi(int(leg["peak_desolation"]), saint.desolation)
		while history_seen < ctrl.history.size():
			var entry: Dictionary = ctrl.history[history_seen]
			history_seen += 1
			if entry["type"] == ExpeditionController.EV_EVENT_RESOLVED:
				leg["event_option"] = (entry["data"] as Dictionary)["option"]
				leg["event_success"] = (entry["data"] as Dictionary)["success"]
			elif entry["type"] == ExpeditionController.EV_RELIC_FOUND:
				leg["relic"] = true
	var hp := 0
	var max_hp := 0
	var desolation := 0
	for id: StringName in ctrl.state.party:
		var s: SaintStatus = ctrl.saints[id]
		hp += s.hp
		max_hp += s.max_hp
		desolation += s.desolation
	leg["end"] = ctrl.ended_reason
	leg["dark_night_saints"] = dark_night.size()
	leg["hp_left"] = float(hp) / float(maxi(max_hp, 1))
	leg["desolation_end"] = float(desolation) / float(maxi(ctrl.state.party.size(), 1))
	leg["light_end"] = ctrl.state.light
	leg["alms"] = ctrl.state.alms_banked + ctrl.state.alms_unbanked
	leg["virtues"] = ctrl.virtues.total()
	return leg


func _battle_row(policy: StringName, kind: StringName, battle: BattleController) -> Dictionary:
	var hp := 0
	var max_hp := 0
	for saint: Combatant in battle.state.party:
		hp += saint.hp
		max_hp += saint.max_hp
	return {
		"policy": policy, "pool": kind, "won": battle.phase == BattleController.Phase.VICTORY,
		"rounds": battle.state.round_number, "hp_left": float(hp) / float(maxi(max_hp, 1)),
	}


## The next command for the phase the leg is in.
func _next(ctrl: ExpeditionController, policy: SimPolicy, rng: RngStream, path_policy: StringName) -> ExpeditionCommand:
	match ctrl.phase:
		ExpeditionController.Phase.AT_FORK:
			var water: ExpeditionCommand = _holy_water(ctrl)
			if water != null:
				return water
			if incense_policy == INCENSE_REVEAL and ctrl.field_provision_problem(&"incense") == &"":
				return ExpeditionCommand.use_provision(&"incense")
			return ExpeditionCommand.choose_path(_path(ctrl, rng, path_policy))
		ExpeditionController.Phase.IN_BATTLE:
			if ctrl.battle.state.round_number > BattleSimulator.MAX_ROUNDS:
				return ExpeditionCommand.battle(BattleCommand.retreat())
			return ExpeditionCommand.battle(policy.next(ctrl.battle)["cmd"])
		ExpeditionController.Phase.IN_EVENT:
			return ExpeditionCommand.choose_option(_event_option(ctrl))
		ExpeditionController.Phase.IN_RELIC:
			for id: StringName in ctrl.state.party:
				if ctrl.has_free_slot(id):
					return ExpeditionCommand.place_relic(id)
			return ExpeditionCommand.place_relic()
		ExpeditionController.Phase.IN_NODE:
			return ExpeditionCommand.complete_node()
		ExpeditionController.Phase.AT_CAMP:
			if not ctrl.state.camp_rested and ctrl.rest_problem(_camp_plan(ctrl)) == &"":
				return ExpeditionCommand.rest(_camp_plan(ctrl))
			return ExpeditionCommand.leave_camp(ExpeditionCommand.MODE_CONTINUE)
	return null


## Random entrance, or (safe) the entrance that avoids battles when it can.
func _path(ctrl: ExpeditionController, rng: RngStream, path_policy: StringName) -> StringName:
	var entrances: Array[MapNode] = ctrl.entrances()
	if path_policy == PATH_SAFE:
		for n: MapNode in entrances:
			if not n.is_battle_like():
				return n.id
	return entrances[rng.pick_index(entrances.size())].id


func _holy_water(ctrl: ExpeditionController) -> ExpeditionCommand:
	var worst: StringName = &""
	var worst_value: int = HOLY_WATER_AT - 1
	for id: StringName in ctrl.state.party:
		var d: int = (ctrl.saints[id] as SaintStatus).desolation
		if d > worst_value:
			worst_value = d
			worst = id
	if worst == &"" or ctrl.field_provision_problem(&"holy_water", worst) != &"":
		return null
	return ExpeditionCommand.use_provision(&"holy_water", worst)


## Prayer when it can be chosen; the risky option when its chance is high;
## otherwise the safe one (narrative-system §4.1: there is always one).
func _event_option(ctrl: ExpeditionController) -> StringName:
	var safe: StringName = &""
	var risky: StringName = &""
	var other: StringName = &""
	for option: Dictionary in ctrl.event.options:
		var id := StringName(str(option.get("id", "")))
		if ctrl.option_problem(id) != &"":
			continue
		if option.get("safe", false):
			safe = id
		elif EventRules.has_chance(option):
			if ctrl.option_chance(id) >= RISK_CHANCE_AT:
				risky = id
		else:
			other = id
	if other != &"":
		return other
	if risky != &"":
		return risky
	return safe


## Own skill for everyone, Vigil for a troubled saint (camp, expedition §6).
func _camp_plan(ctrl: ExpeditionController) -> Array[Dictionary]:
	var plan: Array[Dictionary] = []
	for id: StringName in ctrl.state.party:
		var status: SaintStatus = ctrl.saints[id]
		var skill: CampSkillDef = catalog.saint(id).camp_skill
		var activity: StringName = ExpeditionController.ACTIVITY_OWN
		if status.desolation >= VIGIL_AT or skill == null or ExpeditionController.camp_skill_needs_target(skill):
			activity = ExpeditionController.ACTIVITY_VIGIL
		plan.append({"saint": id, "activity": activity, "target": &""})
	return plan
