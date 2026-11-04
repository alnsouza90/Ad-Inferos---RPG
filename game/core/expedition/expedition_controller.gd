class_name ExpeditionController
extends RefCounted
## Runs one expedition leg without any screen (architecture §3.4,
## expedition §2.3, §8 and §9). The player acts only through
## ExpeditionCommand; every accepted command is logged, so replaying the log
## on the same starting snapshot rebuilds the expedition exactly.
##
##   AT_FORK → (ChoosePath) → IN_BATTLE | IN_NODE → AT_FORK … → AT_CAMP
##   IN_BATTLE → (defeat or emergency retreat) → ENDED

enum Phase { AT_FORK, IN_BATTLE, IN_NODE, AT_CAMP, ENDED }

const END_DEFEATED: StringName = &"defeated"
const END_RETREATED: StringName = &"retreated"

const REJECT_WRONG_PHASE: StringName = &"wrong_phase"
const REJECT_NOT_AN_ENTRANCE: StringName = &"not_an_entrance"
const REJECT_UNKNOWN_COMMAND: StringName = &"unknown_command"

const EV_NODE_ENTERED: StringName = &"node_entered"
const EV_BATTLE_RESOLVED: StringName = &"battle_resolved"
const EV_NODE_COMPLETED: StringName = &"node_completed"
const EV_CAMP_REACHED: StringName = &"camp_reached"
const EV_EXPEDITION_ENDED: StringName = &"expedition_ended"

var catalog: ExpeditionCatalog
var state: ExpeditionState
var map: LegMap
## saint_id -> SaintStatus
var saints: Dictionary = {}
var phase: Phase = Phase.AT_FORK
var ended_reason: StringName = &""
## The battle in progress (IN_BATTLE), else null.
var battle: BattleController
## The last finished battle, kept for the screens (result, events).
var last_battle: BattleController
## Accepted commands, in order (ExpeditionCommand.to_dict()).
var command_log: Array[Dictionary] = []
## {"type": StringName, "data": Dictionary} in order, for the screens.
var history: Array[Dictionary] = []

var _initial: Dictionary = {}


## New expedition from the gate: full Light, fresh saints, leg 1 generated
## from `map_seed`. `encounter_circle` selects the battle pool (in the M1 the
## arena groups, EncounterDef.ARENA_CIRCLE; expedition §13).
static func start_new(p_catalog: ExpeditionCatalog, circle: StringName, map_seed: int, party: Array[StringName], provisions: Array[StringName], encounter_circle: int) -> ExpeditionController:
	var c := ExpeditionController.new()
	c.catalog = p_catalog
	c.state = ExpeditionState.create(p_catalog.constants, circle, map_seed, party, provisions)
	for id: StringName in party:
		c.saints[id] = SaintStatus.from_def(p_catalog.saint(id))
	var generator := MapGenerator.new(p_catalog.constants, RngStream.new(map_seed, RngStreams.MAP))
	generator.battle_encounters = p_catalog.encounter_pool(encounter_circle, &"easy")
	c.map = generator.generate(1, p_catalog.reserves.get(1))
	c.state.map = c.map.to_dict()
	c._initial = c.snapshot()
	return c


## Rebuilds an expedition from its starting snapshot and command log.
static func replay(p_catalog: ExpeditionCatalog, initial: Dictionary, commands: Array) -> ExpeditionController:
	var c := from_snapshot(p_catalog, initial)
	for entry: Variant in commands:
		var reason: StringName = c.execute(ExpeditionCommand.from_dict(entry))
		assert(reason == &"", "replay rejected a logged command: %s (%s)" % [entry, reason])
	return c


## Restores a controller at a fork or node from snapshot() data (no battle
## in progress: battles are rebuilt by replay, save-load §3.2).
static func from_snapshot(p_catalog: ExpeditionCatalog, data: Dictionary) -> ExpeditionController:
	var c := ExpeditionController.new()
	c.catalog = p_catalog
	c.state = ExpeditionState.from_dict(data.get("expedition", {}))
	c.map = LegMap.from_dict(c.state.map)
	var raw_saints: Dictionary = data.get("saints", {})
	for id: Variant in raw_saints:
		c.saints[StringName(str(id))] = SaintStatus.from_dict(raw_saints[id])
	c.phase = int(data.get("phase", Phase.AT_FORK)) as Phase
	c.ended_reason = StringName(str(data.get("ended_reason", "")))
	c._initial = c.snapshot()
	return c


func initial_snapshot() -> Dictionary:
	return _initial.duplicate(true)


func snapshot() -> Dictionary:
	var saint_dicts: Dictionary = {}
	for id: StringName in saints:
		saint_dicts[String(id)] = (saints[id] as SaintStatus).to_dict()
	return {"expedition": state.to_dict(), "saints": saint_dicts, "phase": int(phase), "ended_reason": String(ended_reason)}


func current_node() -> MapNode:
	return map.find(state.current_node) if state.current_node != &"" else null


## 0 at the gate, else the layer of the node the party is in or just left.
func current_layer() -> int:
	var n: MapNode = current_node()
	return 0 if n == null else n.layer


## The entrances of the bifurcation the party stands at (§2.3).
func entrances() -> Array[MapNode]:
	if phase != Phase.AT_FORK:
		return [] as Array[MapNode]
	return map.entrances_from(current_node())


func is_over() -> bool:
	return phase == Phase.ENDED


## Returns &"" when accepted, else the rejection reason (nothing changes).
func execute(cmd: ExpeditionCommand) -> StringName:
	match cmd.type:
		ExpeditionCommand.CHOOSE_PATH:
			return _choose_path(cmd)
		ExpeditionCommand.BATTLE:
			return _battle_command(cmd)
		ExpeditionCommand.COMPLETE_NODE:
			return _complete_node(cmd)
	return REJECT_UNKNOWN_COMMAND


# --- commands -----------------------------------------------------------------

func _choose_path(cmd: ExpeditionCommand) -> StringName:
	if phase != Phase.AT_FORK:
		return REJECT_WRONG_PHASE
	var target: MapNode = null
	for n: MapNode in entrances():
		if n.id == cmd.node_id:
			target = n
	if target == null:
		return REJECT_NOT_AN_ENTRANCE
	command_log.append(cmd.to_dict())
	state.enter_node(target.id, catalog.constants)
	_emit(EV_NODE_ENTERED, {"node": target.id, "type": target.type, "light": state.light})
	if target.is_battle_like():
		_start_battle(target)
	else:
		phase = Phase.IN_NODE
	return &""


func _battle_command(cmd: ExpeditionCommand) -> StringName:
	if phase != Phase.IN_BATTLE or cmd.battle_command == null:
		return REJECT_WRONG_PHASE
	var result: CommandResult = battle.execute(cmd.battle_command)
	if not result.ok:
		return result.reason
	command_log.append(cmd.to_dict())
	if battle.is_over():
		_resolve_battle()
	return &""


func _complete_node(cmd: ExpeditionCommand) -> StringName:
	if phase != Phase.IN_NODE:
		return REJECT_WRONG_PHASE
	command_log.append(cmd.to_dict())
	_emit(EV_NODE_COMPLETED, {"node": state.current_node})
	_after_node()
	return &""


# --- battle -------------------------------------------------------------------

## The battle starts with the party as it is: hit points, desolation, state,
## formation order (D-134), Light and the provisions carried.
func _start_battle(n: MapNode) -> void:
	var enc: EncounterDef = catalog.encounter(n.encounter_id)
	assert(enc != null, "node %s has no encounter" % n.id)
	var saint_defs: Array[SaintDef] = []
	for id: StringName in state.party:
		saint_defs.append(catalog.saint(id))
	var foes: Array[EnemyDef] = []
	for enemy_id: StringName in enc.slots:
		foes.append(_enemy_def(enemy_id))
	var bs := BattleState.create(catalog.battle_catalog, saint_defs, foes, state.provisions, enc.type, battle_seed(n.id))
	bs.light = state.light
	for c: Combatant in bs.party:
		(saints[c.id] as SaintStatus).apply_to(c)
	battle = BattleController.new(bs)
	phase = Phase.IN_BATTLE
	battle.start()


## Each battle has its own seed, derived from the map seed and the node, so
## a battle never depends on how many draws earlier battles made.
func battle_seed(node_id: StringName) -> int:
	return RngStream.hash32(state.map_seed ^ RngStream.fnv1a32(String(node_id)))


func _enemy_def(enemy_id: StringName) -> EnemyDef:
	var enemies: Dictionary = catalog.battle_catalog.enemies
	if enemies.has(enemy_id):
		return enemies[enemy_id]
	return enemies.get(String(enemy_id))


## Combat §8 and §11, expedition §8 and §9.
func _resolve_battle() -> void:
	var bs: BattleState = battle.state
	var c: ConstantsDef = catalog.constants
	var result: BattleController.Phase = battle.phase
	var alms_before: int = state.alms_unbanked
	state.party.clear()
	for saint: Combatant in bs.party:
		state.party.append(saint.id)
	state.provisions = bs.provisions.duplicate()
	match result:
		BattleController.Phase.VICTORY:
			var key: StringName = &"desolation_battle_end_elite" if bs.encounter_type == &"elite" else &"desolation_battle_end_common"
			for saint: Combatant in bs.party:
				bs.add_desolation(saint, c.get_int(key), &"battle_end")
			state.alms_unbanked += battle_alms(bs.encounter_type)
		BattleController.Phase.RETREAT:
			for saint: Combatant in bs.party:
				bs.add_desolation(saint, c.get_int(&"desolation_emergency_retreat"), &"emergency_retreat")
				(saints[saint.id] as SaintStatus).add_injury(SaintStatus.INJURY_MINOR)
			var loss: int = Damage.round_half_up(state.alms_unbanked * catalog.economy.get_float(&"emergency_retreat_alms_loss"))
			state.alms_unbanked -= loss
		BattleController.Phase.DEFEAT:
			for saint: Combatant in bs.party:
				(saints[saint.id] as SaintStatus).add_injury(SaintStatus.INJURY_MAJOR)
			state.alms_unbanked = 0
	_settle_saints(bs)
	last_battle = battle
	battle = null
	_emit(EV_BATTLE_RESOLVED, {"result": _result_name(result), "alms": state.alms_unbanked - alms_before})
	match result:
		BattleController.Phase.VICTORY:
			_after_node()
		BattleController.Phase.RETREAT:
			_end(END_RETREATED)
		_:
			_end(END_DEFEATED)


## Whoever ended Fallen or out comes back with 1 hp and a minor injury, or a
## major one if they had already fallen in this expedition; Prostration is
## always major (combat §8, desolation §5).
func _settle_saints(bs: BattleState) -> void:
	for saint: Combatant in bs.party:
		var status: SaintStatus = saints[saint.id]
		var down: bool = saint.is_fallen() or saint.is_out()
		if down:
			saint.hp = catalog.constants.get_int(&"fallen_minor_injury_hp")
			status.add_injury(SaintStatus.INJURY_MAJOR if state.fallen_once.has(saint.id) else SaintStatus.INJURY_MINOR)
			if not state.fallen_once.has(saint.id):
				state.fallen_once.append(saint.id)
		if saint.pending_injury == Desolation.INJURY_MAJOR:
			status.add_injury(SaintStatus.INJURY_MAJOR)
		status.hp = saint.hp
		status.desolation = saint.desolation
		status.spirit_state = saint.spirit_state
		status.purified = saint.purified


## Alms of a won battle (expedition §8): base × circle band × low Light.
func battle_alms(encounter_type: StringName) -> int:
	var e: ConstantsDef = catalog.economy
	var base: float = e.get_float(&"reward_elite") if encounter_type == &"elite" else e.get_float(&"reward_battle")
	var value: float = base * circle_alms_multiplier() * ExpeditionLight.alms_multiplier(state.light, catalog.constants)
	return Damage.round_half_up(value)


## Circle bands of expedition §8: 0–3, 4–6, 7–9.
func circle_alms_multiplier() -> float:
	var number: int = circle_number()
	var key: StringName = &"tier_mult_c0_3"
	if number >= 7:
		key = &"tier_mult_c7_9"
	elif number >= 4:
		key = &"tier_mult_c4_6"
	return catalog.economy.get_float(key)


## "circle_02" → 2 (0 when the id has no number).
func circle_number() -> int:
	var digits: String = String(state.circle).get_slice("_", 1)
	return digits.to_int() if digits.is_valid_int() else 0


static func _result_name(result: BattleController.Phase) -> StringName:
	match result:
		BattleController.Phase.VICTORY:
			return &"victory"
		BattleController.Phase.RETREAT:
			return &"retreat"
	return &"defeat"


# --- flow ---------------------------------------------------------------------

func _after_node() -> void:
	if current_layer() >= map.layer_count():
		phase = Phase.AT_CAMP
		_emit(EV_CAMP_REACHED, {})
	else:
		phase = Phase.AT_FORK


func _end(reason: StringName) -> void:
	phase = Phase.ENDED
	ended_reason = reason
	_emit(EV_EXPEDITION_ENDED, {"reason": reason, "alms_unbanked": state.alms_unbanked})


func _emit(type: StringName, data: Dictionary) -> void:
	history.append({"type": type, "data": data})
