class_name ExpeditionController
extends RefCounted
## Runs one expedition leg without any screen (architecture §3.4,
## expedition §2.3, §8 and §9). The player acts only through
## ExpeditionCommand; every accepted command is logged, so replaying the log
## on the same starting snapshot rebuilds the expedition exactly.
##
##   AT_FORK → (ChoosePath) → IN_BATTLE | IN_NODE → AT_FORK … → AT_CAMP
##   IN_BATTLE → (defeat or emergency retreat) → ENDED

enum Phase { AT_FORK, IN_BATTLE, IN_NODE, AT_CAMP, ENDED, IN_EVENT, IN_RELIC }

const END_DEFEATED: StringName = &"defeated"
const END_RETREATED: StringName = &"retreated"
const END_PLANNED_RETREAT: StringName = &"planned_retreat"
## M1 only: the leg ends after its camp (expedition §13).
const END_LEG_COMPLETE: StringName = &"leg_complete"

const ACTIVITY_VIGIL: StringName = &"vigil"
const ACTIVITY_SHARE: StringName = &"share"
const ACTIVITY_PRAYER: StringName = &"prayer"
const ACTIVITY_OWN: StringName = &"own"

const REJECT_WRONG_PHASE: StringName = &"wrong_phase"
const REJECT_NOT_AN_ENTRANCE: StringName = &"not_an_entrance"
const REJECT_UNKNOWN_COMMAND: StringName = &"unknown_command"
const REJECT_UNKNOWN_OPTION: StringName = &"unknown_option"
const REJECT_REQUIREMENT: StringName = &"requirement_not_met"
const REJECT_NO_BREAD: StringName = &"no_bread"
const REJECT_ALREADY_RESTED: StringName = &"already_rested"
const REJECT_BAD_ACTIVITY: StringName = &"bad_activity"
const REJECT_NO_SLOT: StringName = &"no_relic_slot"

const EV_NODE_ENTERED: StringName = &"node_entered"
const EV_BATTLE_RESOLVED: StringName = &"battle_resolved"
const EV_NODE_COMPLETED: StringName = &"node_completed"
const EV_CAMP_REACHED: StringName = &"camp_reached"
const EV_EXPEDITION_ENDED: StringName = &"expedition_ended"
const EV_PROVISION_USED: StringName = &"field_provision_used"
const EV_EVENT_STARTED: StringName = &"event_started"
const EV_EVENT_RESOLVED: StringName = &"event_resolved"
const EV_CAMP_RESTED: StringName = &"camp_rested"
const EV_AMBUSH: StringName = &"ambush"
const EV_RELIC_FOUND: StringName = &"relic_found"
const EV_RELIC_PLACED: StringName = &"relic_placed"

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
## The Pilgrim's virtues and narrative flags (campaign data; carried here
## while there is no campaign in the M1).
var virtues: Virtues
var flags: Array[StringName] = []
## The event in progress (IN_EVENT), else null.
var event: EventDef

## Circle of the encounter pools (EncounterDef.ARENA_CIRCLE in the M1).
var ambush_encounter_circle: int = 0

var _initial: Dictionary = {}


## New expedition from the gate: full Light, fresh saints, leg 1 generated
## from `map_seed`. `encounter_circle` selects the battle pool (in the M1 the
## arena groups, EncounterDef.ARENA_CIRCLE; expedition §13).
static func start_new(p_catalog: ExpeditionCatalog, circle: StringName, map_seed: int, party: Array[StringName], provisions: Array[StringName], encounter_circle: int) -> ExpeditionController:
	var c := ExpeditionController.new()
	c.catalog = p_catalog
	c.state = ExpeditionState.create(p_catalog.constants, circle, map_seed, party, provisions)
	c.virtues = Virtues.start(p_catalog.constants)
	for id: StringName in party:
		c.saints[id] = SaintStatus.from_def(p_catalog.saint(id))
	var generator := MapGenerator.new(p_catalog.constants, RngStream.new(map_seed, RngStreams.MAP))
	generator.battle_encounters = p_catalog.encounter_pool(encounter_circle, &"easy")
	c.ambush_encounter_circle = encounter_circle
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


## Like replay(), for data read from disk: returns null instead of failing
## when a logged command is refused (a save that no longer matches the rules).
static func try_replay(p_catalog: ExpeditionCatalog, initial: Dictionary, commands: Array) -> ExpeditionController:
	var c := from_snapshot(p_catalog, initial)
	for entry: Variant in commands:
		if not entry is Dictionary or c.execute(ExpeditionCommand.from_dict(entry)) != &"":
			return null
	return c


## Restores a controller at a fork or node from snapshot() data (no battle
## in progress: battles are rebuilt by replay, save-load §3.2).
static func from_snapshot(p_catalog: ExpeditionCatalog, data: Dictionary) -> ExpeditionController:
	var c := ExpeditionController.new()
	c.catalog = p_catalog
	c.state = ExpeditionState.from_dict(data.get("expedition", {}))
	c.map = LegMap.from_dict(c.state.map)
	# Back in its own format: numbers read from a save come as floats.
	c.state.map = c.map.to_dict()
	var raw_saints: Dictionary = data.get("saints", {})
	for id: Variant in raw_saints:
		c.saints[StringName(str(id))] = SaintStatus.from_dict(raw_saints[id])
	c.phase = int(data.get("phase", Phase.AT_FORK)) as Phase
	c.ended_reason = StringName(str(data.get("ended_reason", "")))
	c.virtues = Virtues.from_dict(data.get("virtues", {}))
	c.ambush_encounter_circle = int(data.get("encounter_circle", 0))
	for f: Variant in data.get("flags", []):
		c.flags.append(StringName(str(f)))
	c._initial = c.snapshot()
	return c


func initial_snapshot() -> Dictionary:
	return _initial.duplicate(true)


func snapshot() -> Dictionary:
	var saint_dicts: Dictionary = {}
	for id: StringName in saints:
		saint_dicts[String(id)] = (saints[id] as SaintStatus).to_dict()
	var flag_list: Array[String] = []
	for f: StringName in flags:
		flag_list.append(String(f))
	return {
		"expedition": state.to_dict(), "saints": saint_dicts, "phase": int(phase), "ended_reason": String(ended_reason),
		"virtues": virtues.to_dict(), "flags": flag_list, "encounter_circle": ambush_encounter_circle,
	}


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
		ExpeditionCommand.USE_PROVISION:
			return _use_provision(cmd)
		ExpeditionCommand.CHOOSE_OPTION:
			return _choose_option(cmd)
		ExpeditionCommand.REST:
			return _rest(cmd)
		ExpeditionCommand.LEAVE_CAMP:
			return _leave_camp(cmd)
		ExpeditionCommand.PLACE_RELIC:
			return _place_relic(cmd)
	return REJECT_UNKNOWN_COMMAND


## Content of a node is known when the gate reaches it (§2.2) or Incense
## revealed it earlier in this leg (D-129, D-137). The type is always known.
func content_visible(n: MapNode) -> bool:
	return LegMap.content_visible(n.layer, current_layer(), state.gate_level) or state.revealed_nodes.has(n.id)


## Reason a provision cannot be used at this bifurcation, or &"" if it can.
func field_provision_problem(provision_id: StringName, target_id: StringName = &"") -> StringName:
	if phase != Phase.AT_FORK:
		return REJECT_WRONG_PHASE
	if not state.provisions.has(provision_id):
		return FieldProvisions.REJECT_NOT_CARRIED
	var def: ProvisionDef = catalog.battle_catalog.provision(provision_id)
	if not FieldProvisions.usable_in_field(def):
		return FieldProvisions.REJECT_NOT_USABLE_HERE
	if FieldProvisions.needs_target(def) and not saints.has(target_id):
		return FieldProvisions.REJECT_NEEDS_TARGET
	for e: EffectDef in def.effects:
		if e.type == &"reveal_or_cancel_ambush" and _nodes_incense_would_reveal().is_empty():
			return FieldProvisions.REJECT_NOTHING_TO_REVEAL
	return &""


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
	state.enter_node(target.id, catalog.constants, RelicEffects.light_per_node(carried_relics(), catalog.constants))
	_emit(EV_NODE_ENTERED, {"node": target.id, "type": target.type, "light": state.light})
	if target.is_battle_like():
		_start_battle(target.encounter_id, target.id)
	elif target.type == MapNode.TYPE_TEMPTATION and _start_event(target):
		pass
	elif target.type == MapNode.TYPE_RELIC and _start_relic_node(target):
		pass
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


## Each field effect of the provision acts; effects that only make sense in
## battle (removing conditions, healing) do nothing out here.
func _use_provision(cmd: ExpeditionCommand) -> StringName:
	var problem: StringName = field_provision_problem(cmd.provision_id, cmd.target_id)
	if problem != &"":
		return problem
	command_log.append(cmd.to_dict())
	state.provisions.erase(cmd.provision_id)
	var def: ProvisionDef = catalog.battle_catalog.provision(cmd.provision_id)
	for e: EffectDef in def.effects:
		match e.type:
			&"light":
				state.light = clampi(state.light + int(e.amount), 0, ExpeditionLight.LIGHT_MAX)
			&"desolation":
				_change_desolation(cmd.target_id, int(e.amount), &"provision")
			&"reveal_or_cancel_ambush":
				for id: StringName in _nodes_incense_would_reveal():
					state.revealed_nodes.append(id)
	_emit(EV_PROVISION_USED, {"provision": cmd.provision_id, "target": cmd.target_id, "light": state.light})
	return &""


## Incense: one layer beyond the gate's reach, only the nodes reachable from
## the entrances of this bifurcation (D-129).
func _nodes_incense_would_reveal() -> Array[StringName]:
	var result: Array[StringName] = []
	var target_layer: int = current_layer() + state.gate_level + 1
	var frontier: Array[MapNode] = entrances()
	while not frontier.is_empty() and frontier[0].layer < target_layer:
		var next: Array[MapNode] = []
		for n: MapNode in frontier:
			for linked: MapNode in map.entrances_from(n):
				if not next.has(linked):
					next.append(linked)
		frontier = next
	for n: MapNode in frontier:
		if n.layer == target_layer and not content_visible(n):
			result.append(n.id)
	return result


## Desolation outside battle goes through the same rules (thresholds,
## Purification), on a temporary combatant built from the saint's status.
func _change_desolation(saint_id: StringName, amount: int, source: StringName) -> void:
	var status: SaintStatus = saints[saint_id]
	var c := Combatant.from_saint(catalog.saint(saint_id))
	status.apply_to(c)
	var ctx := DesolationContext.new()
	ctx.constants = catalog.constants
	ctx.rng = RngStream.new(battle_seed(StringName("field_%d" % command_log.size())), RngStreams.FAITH)
	ctx.light = state.light
	Desolation.change(c, amount, source, ctx)
	status.desolation = c.desolation
	status.spirit_state = c.spirit_state
	status.purified = c.purified
	if c.pending_injury == Desolation.INJURY_MAJOR:
		status.add_injury(SaintStatus.INJURY_MAJOR)


# --- events (narrative-system §3 and §4.1) ---------------------------------------

## The Temptation of the node: one of the circle's Temptations, drawn from a
## stream of its own (node seed, `events`). Without any, the node is a plain
## pass-through.
func _start_event(n: MapNode) -> bool:
	var pool: Array[EventDef] = catalog.events_for(&"temptation", circle_number())
	if pool.is_empty():
		return false
	event = pool[_event_rng().pick_index(pool.size())]
	phase = Phase.IN_EVENT
	_emit(EV_EVENT_STARTED, {"event": event.id, "node": n.id})
	return true


## Draw 1 picks the event, draw 2 rolls the chance; derived from the node so
## replays and saves give the same result.
func _event_rng() -> RngStream:
	return RngStream.new(battle_seed(StringName(String(state.current_node) + "_event")), RngStreams.EVENTS)


func event_context() -> EventContext:
	var ctx := EventContext.new()
	ctx.party = state.party.duplicate()
	ctx.provisions = state.provisions.duplicate()
	ctx.alms = state.alms_unbanked + state.alms_banked
	ctx.virtues = virtues
	ctx.flags = flags.duplicate()
	return ctx


## Reason an option cannot be chosen, or &"" (N01: unmet requirement).
func option_problem(option_id: StringName) -> StringName:
	if phase != Phase.IN_EVENT or event == null:
		return REJECT_WRONG_PHASE
	var option: Dictionary = event.option(option_id)
	if option.is_empty():
		return REJECT_UNKNOWN_OPTION
	if not EventRules.unmet_requirements(option, event_context()).is_empty():
		return REJECT_REQUIREMENT
	return &""


## The chance shown on the option's button (1.0 when it has none).
func option_chance(option_id: StringName) -> float:
	return EventRules.chance(event.option(option_id), event_context())


func _choose_option(cmd: ExpeditionCommand) -> StringName:
	var problem: StringName = option_problem(cmd.node_id)
	if problem != &"":
		return problem
	command_log.append(cmd.to_dict())
	var option: Dictionary = event.option(cmd.node_id)
	var ctx: EventContext = event_context()
	var outcomes: Array = option.get("outcomes", [])
	var success := true
	if EventRules.has_chance(option):
		var value: float = EventRules.chance(option, ctx)
		for m: Dictionary in EventRules.applying_modifiers(option, ctx):
			if m.get("consume", false):
				state.provisions.erase(StringName(str(m.get("id", ""))))
		var rng: RngStream = _event_rng()
		rng.next_u32()
		success = rng.next_float() < value
		outcomes = option.get("on_success", []) if success else option.get("on_failure", [])
	var finished: EventDef = event
	event = null
	phase = Phase.IN_NODE
	var battle_id: StringName = &""
	for out: Dictionary in outcomes:
		var started: StringName = _apply_outcome(out)
		if battle_id == &"":
			battle_id = started
	_emit(EV_EVENT_RESOLVED, {"event": finished.id, "option": cmd.node_id, "success": success})
	if battle_id != &"":
		_start_battle(battle_id, StringName(String(state.current_node) + "_event_battle"))
	else:
		_after_node()
	return &""


## Applies one outcome (narrative-system §3.2). Returns the encounter id of
## start_battle, else &"". Relic, suffrages and unlock have no system in
## the M1 and are only recorded in the history.
func _apply_outcome(out: Dictionary) -> StringName:
	var id := StringName(str(out.get("id", "")))
	var amount: int = int(out.get("amount", 0))
	match str(out.get("type", "")):
		"light":
			state.light = clampi(state.light + amount, 0, ExpeditionLight.LIGHT_MAX)
		"desolation":
			var target := StringName(str(out.get("target", "party")))
			for saint_id: StringName in state.party:
				if target == &"party" or target == saint_id:
					_change_desolation(saint_id, amount, &"event")
		"virtue":
			virtues.change(id, amount, catalog.constants)
		"alms":
			state.alms_unbanked = maxi(state.alms_unbanked + amount, 0)
		"provisions":
			for i: int in absi(amount):
				if amount > 0:
					state.add_provision(id, catalog.constants)
				else:
					state.provisions.erase(id)
		"injury":
			var target := StringName(str(out.get("target", "party")))
			for saint_id: StringName in state.party:
				if target == &"party" or target == saint_id:
					(saints[saint_id] as SaintStatus).add_injury(id)
		"set_flag":
			if not flags.has(id):
				flags.append(id)
		"start_battle":
			return id
		_:
			_emit(&"outcome_not_in_m1", out)
	return &""


# --- relics (expedition §3 and §8, data-schemas §4) ---------------------------------

func carried_relics() -> Array[RelicDef]:
	var result: Array[RelicDef] = []
	for id: StringName in state.party:
		for r: StringName in (saints[id] as SaintStatus).relics:
			var def: RelicDef = catalog.relic(r)
			if def != null:
				result.append(def)
	return result


func relic_slots(_saint_id: StringName) -> int:
	return catalog.constants.get_int(&"relic_slots_start")


func has_free_slot(saint_id: StringName) -> bool:
	return saints.has(saint_id) and (saints[saint_id] as SaintStatus).relics.size() < relic_slots(saint_id)


## The node's relic is drawn on entering (equal chance among the pool) and
## may be guarded by a common battle ([relic_node_guarded_chance]).
func _start_relic_node(n: MapNode) -> bool:
	var pool: Array[StringName] = catalog.relic_node_pool()
	if pool.is_empty():
		return false
	var rng := RngStream.new(battle_seed(StringName(String(n.id) + "_relic")), RngStreams.REWARDS)
	state.pending_relic = pool[rng.pick_index(pool.size())]
	var guarded: bool = rng.chance(catalog.constants.get_float(&"relic_node_guarded_chance"))
	var guards: Array[StringName] = catalog.encounter_pool(ambush_encounter_circle, &"easy")
	if guarded and not guards.is_empty():
		_start_battle(guards[rng.pick_index(guards.size())], StringName(String(n.id) + "_guard"))
	else:
		_award_relic()
	return true


## [reward_relic_node] Alms (× circle band × low Light) and the relic, which
## waits for a carrier (D-146).
func _award_relic() -> void:
	var value: float = catalog.economy.get_float(&"reward_relic_node") * circle_alms_multiplier() * ExpeditionLight.alms_multiplier(state.light, catalog.constants)
	state.alms_unbanked += Damage.round_half_up(value)
	state.relics_found.append(state.pending_relic)
	phase = Phase.IN_RELIC
	_emit(EV_RELIC_FOUND, {"relic": state.pending_relic})


## A saint with a free slot carries it and its effect starts now; with no
## target it goes to the pack, without effect until the village (D-146).
func _place_relic(cmd: ExpeditionCommand) -> StringName:
	if phase != Phase.IN_RELIC:
		return REJECT_WRONG_PHASE
	if cmd.target_id != &"" and not has_free_slot(cmd.target_id):
		return REJECT_NO_SLOT
	command_log.append(cmd.to_dict())
	var relic_id: StringName = state.pending_relic
	state.pending_relic = &""
	if cmd.target_id == &"":
		state.relic_pack.append(relic_id)
	else:
		var status: SaintStatus = saints[cmd.target_id]
		status.relics.append(relic_id)
		RelicEffects.apply_to_carrier(catalog.relic(relic_id), status, catalog.saint(cmd.target_id))
	_emit(EV_RELIC_PLACED, {"relic": relic_id, "saint": cmd.target_id})
	_after_node()
	return &""


## Defeat (§9): relics found in this expedition are lost, with their effects.
func _lose_found_relics() -> void:
	for id: StringName in state.party:
		var status: SaintStatus = saints[id]
		var kept: Array[StringName] = []
		for r: StringName in status.relics:
			if not state.relics_found.has(r):
				kept.append(r)
		if kept.size() == status.relics.size():
			continue
		var def: SaintDef = catalog.saint(id)
		status.relics.clear()
		status.max_hp = def.max_hp
		status.hp = mini(status.hp, status.max_hp)
		status.faith_bonus = 0
		for r: StringName in kept:
			status.relics.append(r)
			RelicEffects.apply_to_carrier(catalog.relic(r), status, def)
	for r: StringName in state.relics_found:
		state.relic_pack.erase(r)
	state.relics_found.clear()
	state.pending_relic = &""


# --- battle -------------------------------------------------------------------

## The battle starts with the party as it is: hit points, desolation, state,
## formation order (D-134), Light and the provisions carried.
func _start_battle(encounter_id: StringName, seed_key: StringName) -> void:
	var enc: EncounterDef = catalog.encounter(encounter_id)
	assert(enc != null, "no encounter %s" % encounter_id)
	var saint_defs: Array[SaintDef] = []
	for id: StringName in state.party:
		saint_defs.append(catalog.saint(id))
	var foes: Array[EnemyDef] = []
	for enemy_id: StringName in enc.slots:
		foes.append(_enemy_def(enemy_id))
	var bs := BattleState.create(catalog.battle_catalog, saint_defs, foes, state.provisions, enc.type, battle_seed(seed_key))
	bs.light = state.light
	bs.prayer_fervor = state.next_battle_fervor
	state.next_battle_fervor = 0
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
			_lose_found_relics()
	_settle_saints(bs)
	last_battle = battle
	battle = null
	_emit(EV_BATTLE_RESOLVED, {"result": _result_name(result), "alms": state.alms_unbanked - alms_before})
	match result:
		BattleController.Phase.VICTORY:
			if state.pending_relic != &"":
				_award_relic()
			else:
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
		_arrive_at_camp()
	else:
		phase = Phase.AT_FORK


## Reaching the camp consecrates it and banks the Alms carried (§6 step 1);
## coming back to it after an ambush banks what that battle gave.
func _arrive_at_camp() -> void:
	phase = Phase.AT_CAMP
	state.alms_banked += state.alms_unbanked
	state.alms_unbanked = 0
	if not state.camp_reached:
		state.camp_reached = true
		_emit(EV_CAMP_REACHED, {"alms_banked": state.alms_banked})


# --- camp (expedition §6) ---------------------------------------------------------

## Reason the rest cannot be taken with these activities, or &"" (E05).
func rest_problem(activities: Array[Dictionary]) -> StringName:
	if phase != Phase.AT_CAMP:
		return REJECT_WRONG_PHASE
	if state.camp_rested:
		return REJECT_ALREADY_RESTED
	if not state.provisions.has(&"bread"):
		return REJECT_NO_BREAD
	var seen: Dictionary = {}
	for a: Dictionary in activities:
		var saint_id := StringName(str(a.get("saint", "")))
		if not state.party.has(saint_id) or seen.has(saint_id):
			return REJECT_BAD_ACTIVITY
		seen[saint_id] = true
		var target := StringName(str(a.get("target", "")))
		match StringName(str(a.get("activity", ""))):
			ACTIVITY_VIGIL, ACTIVITY_PRAYER:
				pass
			ACTIVITY_SHARE:
				# Share cares for another saint, never for oneself (D-144).
				if target == saint_id or not state.party.has(target):
					return REJECT_BAD_ACTIVITY
			ACTIVITY_OWN:
				var skill: CampSkillDef = catalog.saint(saint_id).camp_skill
				if skill == null or (_skill_needs_target(skill) and not state.party.has(target)):
					return REJECT_BAD_ACTIVITY
			_:
				return REJECT_BAD_ACTIVITY
	if seen.size() != state.party.size():
		return REJECT_BAD_ACTIVITY
	return &""


static func _skill_needs_target(skill: CampSkillDef) -> bool:
	return [&"heal_ally_pct", &"ally_desolation", &"remove_minor_injury"].has(skill.effect)


## Rest: 1 Bread, then every activity in party order, then the ambush roll.
func _rest(cmd: ExpeditionCommand) -> StringName:
	var problem: StringName = rest_problem(cmd.activities)
	if problem != &"":
		return problem
	command_log.append(cmd.to_dict())
	state.camp_rested = true
	var c: ConstantsDef = catalog.constants
	var refund := false
	var ambush_mult: float = 1.0
	var prayers: int = 0
	var by_saint: Dictionary = {}
	for a: Dictionary in cmd.activities:
		by_saint[StringName(str(a["saint"]))] = a
	for saint_id: StringName in state.party:
		var a: Dictionary = by_saint[saint_id]
		var target := StringName(str(a.get("target", "")))
		match StringName(str(a["activity"])):
			ACTIVITY_VIGIL:
				_change_desolation(saint_id, -c.get_int(&"desolation_vigil"), &"vigil")
			ACTIVITY_SHARE:
				_heal_pct(target, c.get_float(&"share_heal_pct"))
			ACTIVITY_PRAYER:
				prayers += 1
			ACTIVITY_OWN:
				var skill: CampSkillDef = catalog.saint(saint_id).camp_skill
				var value: float = float(skill.params.get("value", 0.0))
				match skill.effect:
					&"ambush_mult":
						ambush_mult *= value
					&"desolation_party":
						for id: StringName in state.party:
							_change_desolation(id, int(value), &"camp_skill")
					&"heal_party_pct":
						for id: StringName in state.party:
							_heal_pct(id, value)
					&"heal_ally_pct":
						_heal_pct(target, value)
					&"ally_desolation":
						_change_desolation(target, int(value), &"camp_skill")
					&"refund_bread":
						refund = true
					&"alms_bonus":
						state.alms_banked += int(value)
					&"remove_minor_injury":
						var status: SaintStatus = saints[target]
						if status.injury == SaintStatus.INJURY_MINOR:
							status.injury = SaintStatus.INJURY_NONE
					_:
						# next_battle_condition, reveal_next_layer, suffrage_bonus:
						# their saints and systems arrive after the M1.
						_emit(&"camp_skill_not_in_m1", {"skill": skill.id})
	if not refund:
		state.provisions.erase(&"bread")
	state.next_battle_fervor = mini(prayers, c.get_int(&"prayer_fervor_cap"))
	_emit(EV_CAMP_RESTED, {"prayer_fervor": state.next_battle_fervor})
	_roll_ambush(ambush_mult)
	return &""


func _heal_pct(saint_id: StringName, fraction: float) -> void:
	var status: SaintStatus = saints[saint_id]
	status.hp = mini(status.max_hp, status.hp + Damage.round_half_up(status.max_hp * fraction))


## [ambush_chance] × Light band × camp skills (Guard); Incense cancels it
## and is spent (E07). The ambush is a battle from the next leg's pool
## (the hard pool in the M1), with the party as it is.
func ambush_chance(skill_mult: float = 1.0) -> float:
	var c: ConstantsDef = catalog.constants
	return c.get_float(&"ambush_chance") * ExpeditionLight.ambush_multiplier(state.light, c) * skill_mult


func _roll_ambush(skill_mult: float) -> void:
	var rng := RngStream.new(battle_seed(StringName(String(state.current_node) + "_camp")), RngStreams.EVENTS)
	var ambushed: bool = rng.next_float() < ambush_chance(skill_mult)
	if ambushed and state.provisions.has(&"incense"):
		state.provisions.erase(&"incense")
		_emit(EV_AMBUSH, {"cancelled_by": &"incense"})
		return
	if not ambushed:
		return
	var pool: Array[StringName] = catalog.encounter_pool(ambush_encounter_circle, &"hard")
	_emit(EV_AMBUSH, {"cancelled_by": &""})
	if pool.is_empty():
		return
	_start_battle(pool[rng.pick_index(pool.size())], StringName(String(state.current_node) + "_ambush"))


## M1: leaving the camp ends the leg; a planned retreat keeps every Alms
## (§9). The next legs come in the M2.
func _leave_camp(cmd: ExpeditionCommand) -> StringName:
	if phase != Phase.AT_CAMP:
		return REJECT_WRONG_PHASE
	if cmd.mode != ExpeditionCommand.MODE_CONTINUE and cmd.mode != ExpeditionCommand.MODE_RETREAT:
		return REJECT_UNKNOWN_COMMAND
	command_log.append(cmd.to_dict())
	_end(END_PLANNED_RETREAT if cmd.mode == ExpeditionCommand.MODE_RETREAT else END_LEG_COMPLETE)
	return &""


func _end(reason: StringName) -> void:
	phase = Phase.ENDED
	ended_reason = reason
	_emit(EV_EXPEDITION_ENDED, {"reason": reason, "alms_unbanked": state.alms_unbanked})


func _emit(type: StringName, data: Dictionary) -> void:
	history.append({"type": type, "data": data})
