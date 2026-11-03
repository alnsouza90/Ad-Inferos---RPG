class_name BattleSimulator
extends RefCounted
## Plays many battles with automatic policies and measures the M0 targets of
## testing.md §5.2. Pure logic: run_sim.gd handles the command line and files.

## A battle that has not ended after this many rounds counts as a loss.
const MAX_ROUNDS: int = 50
## Expedition model for the Dark Night metric (documented in the report).
const EXPEDITION_BATTLES: int = 6
## Pousos (with Vigil) after these battle numbers (1-based).
const EXPEDITION_CAMPS_AFTER: Array[int] = [2, 4]
## Nodes walked before battle k (1-based): 2k - 1 (two nodes per battle).
const NODES_PER_BATTLE: int = 2

var data: SimData
## One Dictionary per battle played.
var battles: Array[Dictionary] = []
## One Dictionary per simulated expedition.
var expeditions: Array[Dictionary] = []


func _init(p_data: SimData) -> void:
	data = p_data


func run(encounter_ids: Array[String], runs: int, policies: Array[StringName], seed: int) -> void:
	for policy: StringName in policies:
		for e: int in encounter_ids.size():
			for i: int in runs:
				var battle_seed: int = seed + 1000003 * e + i
				battles.append(play(policy, encounter_ids[e], battle_seed))
	if policies.has(SimPolicy.HEURISTIC):
		for i: int in runs:
			expeditions.append(play_expedition(encounter_ids, seed + 7919 * i))


## One battle from scratch. Returns its metrics.
func play(policy_kind: StringName, encounter_id: String, battle_seed: int, ctrl: BattleController = null) -> Dictionary:
	if ctrl == null:
		ctrl = BattleController.new(data.battle(encounter_id, battle_seed))
		ctrl.start()
	var policy := SimPolicy.new(policy_kind, RngStream.new(battle_seed, &"sim_policy"))
	var saint_turns := 0
	var no_useful := 0
	var usage: Dictionary = {}
	while not ctrl.is_over() and ctrl.state.round_number <= MAX_ROUNDS:
		var choice: Dictionary = policy.next(ctrl)
		var cmd: BattleCommand = choice["cmd"]
		if choice["saint"] != &"":
			saint_turns += 1
			if not choice["useful"]:
				no_useful += 1
		var result: CommandResult = ctrl.execute(cmd)
		assert(result.ok, "policy %s chose an invalid command: %s (%s)" % [policy_kind, cmd.to_dict(), result.reason])
		if cmd.type == BattleCommand.USE_ABILITY:
			usage[cmd.ability_id] = int(usage.get(cmd.ability_id, 0)) + 1
		elif cmd.type == BattleCommand.USE_MIRACLE:
			var miracle_id: StringName = ctrl.state.find(cmd.actor_id).miracle
			usage[miracle_id] = int(usage.get(miracle_id, 0)) + 1
	var hp := 0
	var max_hp := 0
	for saint: Combatant in ctrl.state.party:
		hp += saint.hp
		max_hp += saint.max_hp
	var enc: EncounterDef = data.encounters[StringName(encounter_id)]
	return {
		"policy": policy_kind, "encounter": encounter_id, "pool": enc.pool,
		"won": ctrl.phase == BattleController.Phase.VICTORY, "rounds": ctrl.state.round_number,
		"hp_left": float(hp) / float(max_hp), "saint_turns": saint_turns, "no_useful": no_useful,
		"usage": usage, "errors": ctrl.errors.size(),
	}


## Long expedition model (testing.md §5.2, last row): 6 battles in a row with
## the heuristic; desolation and spiritual state carry over; common battle-end
## desolation after each win; Light falls per node; Pousos with Vigil after
## battles 2 and 4; hit points are restored before each battle.
func play_expedition(encounter_ids: Array[String], seed: int) -> Dictionary:
	var c: ConstantsDef = data.catalog.constants
	var carried: Dictionary = {}
	var dark_night: Dictionary = {}
	var completed := 0
	for b: int in EXPEDITION_BATTLES:
		var encounter_id: String = encounter_ids[b % encounter_ids.size()]
		var state: BattleState = data.battle(encounter_id, seed + b)
		state.light = c.get_int(&"light_start") - c.get_int(&"light_per_node") * (NODES_PER_BATTLE * (b + 1) - 1)
		for saint: Combatant in state.party:
			if carried.has(saint.id):
				saint.desolation = int(carried[saint.id]["desolation"])
				saint.spirit_state = carried[saint.id]["state"]
		var ctrl := BattleController.new(state)
		ctrl.start()
		var result: Dictionary = play(SimPolicy.HEURISTIC, encounter_id, seed + b, ctrl)
		for saint: Combatant in state.party:
			if result["won"]:
				state.add_desolation(saint, c.get_int(&"desolation_battle_end_common"), &"battle_end")
			if EXPEDITION_CAMPS_AFTER.has(b + 1):
				state.add_desolation(saint, -c.get_int(&"desolation_vigil"), &"vigil")
			if saint.spirit_state == Desolation.DARK_NIGHT:
				dark_night[saint.id] = true
			carried[saint.id] = {"desolation": saint.desolation, "state": saint.spirit_state}
		for e: BattleEvent in ctrl.history:
			if e.type == &"state_changed" and e.data["new"] == Desolation.DARK_NIGHT:
				dark_night[e.data["target"]] = true
		if not result["won"]:
			break
		completed += 1
	return {"battles_won": completed, "dark_night_saints": dark_night.size()}
