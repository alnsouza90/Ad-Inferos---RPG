extends GutTest
## T62 (D-396): Fidelity (D-271) and the Vigil that prepares the Faith test
## (D-270), with the real data. Both live in the expedition and go into the
## save: the marks in each saint's status, the Vigil in the expedition state.

const G: StringName = &"saint_george"
const B: StringName = &"saint_benedict"
const T: StringName = &"saint_therese"

var cat: ExpeditionCatalog


func before_all() -> void:
	cat = RealData.expedition_catalog()


func _at_camp() -> ExpeditionController:
	var ctrl := ExpeditionController.start_new(cat, &"circle_02", 1, RealData.m0_party_ids(), cat.kit_provisions(&"m1_kit"), EncounterDef.ARENA_CIRCLE)
	ctrl.state.current_node = ctrl.map.node(4, 0).id
	ctrl.state.light = 80
	ctrl._arrive_at_camp()
	return ctrl


## Starts a battle and ends it at once with the given result, so each test
## controls who is standing and in which state.
func _end_battle(ctrl: ExpeditionController, n: int, result: BattleController.Phase = BattleController.Phase.VICTORY) -> BattleState:
	ctrl._start_battle(&"m0_easy_01", StringName("fidelity_%d" % n))
	var bs: BattleState = ctrl.battle.state
	ctrl.battle.phase = result
	ctrl._resolve_battle()
	return bs


func _dark_night(ctrl: ExpeditionController, id: StringName, desolation: int) -> void:
	var status: SaintStatus = ctrl.saints[id]
	status.spirit_state = Desolation.DARK_NIGHT
	status.desolation = desolation


func test_a_won_battle_in_the_dark_night_gives_a_mark_and_no_battle_end_desolation() -> void:
	var ctrl := _at_camp()
	_dark_night(ctrl, G, 120)
	var before_b: int = (ctrl.saints[B] as SaintStatus).desolation
	var bs: BattleState = _end_battle(ctrl, 1)
	var george: SaintStatus = ctrl.saints[G]
	assert_eq(george.fidelity_marks, 1)
	assert_eq(george.desolation, 120, "sem desolação de fim de combate em Noite Escura")
	assert_eq((ctrl.saints[B] as SaintStatus).desolation, before_b + ExpeditionController.battle_end_desolation(bs, 0), "os outros recebem 20 + 3 por rodada")


func test_three_marks_end_the_dark_night_with_purification_at_50() -> void:
	var ctrl := _at_camp()
	_dark_night(ctrl, G, 140)
	for n: int in 3:
		_end_battle(ctrl, n)
	var george: SaintStatus = ctrl.saints[G]
	assert_eq(george.spirit_state, Desolation.NORMAL, "Purificação pela Fidelidade")
	assert_true(george.purified)
	assert_eq(george.desolation, cat.constants.get_int(&"fidelity_reset_value"))
	assert_eq(george.fidelity_marks, 0, "as marcas recomeçam")
	assert_eq(ctrl.fidelity_exits, 1)


func test_marks_need_the_saint_standing_and_a_victory() -> void:
	var ctrl := _at_camp()
	_dark_night(ctrl, G, 120)
	ctrl._start_battle(&"m0_easy_01", &"fidelity_down")
	for c: Combatant in ctrl.battle.state.party:
		if c.id == G:
			c.hp = 0
			c.state = Combatant.State.FALLEN
	ctrl.battle.phase = BattleController.Phase.VICTORY
	ctrl._resolve_battle()
	assert_eq((ctrl.saints[G] as SaintStatus).fidelity_marks, 0, "caído não ganha marca")


func test_marks_are_lost_when_the_dark_night_ends_another_way() -> void:
	var ctrl := _at_camp()
	_dark_night(ctrl, G, 120)
	_end_battle(ctrl, 1)
	var george: SaintStatus = ctrl.saints[G]
	assert_eq(george.fidelity_marks, 1)
	george.spirit_state = Desolation.NORMAL
	george.desolation = 40
	_end_battle(ctrl, 2)
	assert_eq(george.fidelity_marks, 0)


func test_marks_go_into_the_save() -> void:
	var ctrl := _at_camp()
	_dark_night(ctrl, G, 120)
	_end_battle(ctrl, 1)
	var data: Dictionary = JSON.parse_string(JSON.stringify(ctrl.snapshot()))
	var again := ExpeditionController.from_snapshot(cat, data)
	assert_eq((again.saints[G] as SaintStatus).fidelity_marks, 1)
	assert_eq(SaintStatus.from_dict({"id": "saint_george"}).fidelity_marks, 0, "save antigo, sem o campo: zero marcas")


func test_the_vigil_prepares_the_faith_test_of_the_next_battles_and_is_saved() -> void:
	var ctrl := _at_camp()
	var acts: Array[Dictionary] = [
		{"saint": G, "activity": &"vigil", "target": &""},
		{"saint": B, "activity": &"prayer", "target": &""},
		{"saint": T, "activity": &"vigil", "target": &""},
	]
	assert_eq(ctrl.execute(ExpeditionCommand.rest(acts)), &"")
	assert_eq(ctrl.state.vigil_saints, [G, T] as Array[StringName])
	ctrl._start_battle(&"m0_easy_01", &"vigil_battle")
	var bs: BattleState = ctrl.battle.state
	assert_almost_eq(bs.prepared_bonus(bs.find(G)), cat.constants.get_float(&"faith_prepared_vigil"), 0.0001)
	assert_eq(bs.prepared_bonus(bs.find(B)), 0.0, "quem rezou não fez a Vigília")
	var data: Dictionary = JSON.parse_string(JSON.stringify(ctrl.snapshot()))
	assert_eq(ExpeditionController.from_snapshot(cat, data).state.vigil_saints, [G, T] as Array[StringName])


# --- saves from before the new rules (save-load §7, version 2 → 3) ------------------

func _played_save() -> Dictionary:
	var ctrl := ExpeditionController.start_new(cat, &"circle_02", 3, RealData.m0_party_ids(), cat.kit_provisions(&"m1_kit"), EncounterDef.ARENA_CIRCLE)
	for i: int in 400:
		match ctrl.phase:
			ExpeditionController.Phase.AT_FORK:
				ctrl.execute(ExpeditionCommand.choose_path(ctrl.entrances()[0].id))
			ExpeditionController.Phase.PENDING:
				ctrl.execute(ExpeditionCommand.engage_node())
			ExpeditionController.Phase.IN_NODE:
				ctrl.execute(ExpeditionCommand.complete_node())
			ExpeditionController.Phase.IN_EVENT:
				ctrl.execute(ExpeditionCommand.choose_option(&"follow_tracks"))
			ExpeditionController.Phase.IN_RELIC:
				ctrl.execute(ExpeditionCommand.place_relic())
			ExpeditionController.Phase.IN_BATTLE:
				ctrl.execute(ExpeditionCommand.battle(FirstValidPolicy.choose(ctrl.battle)))
		if ctrl.last_battle != null and ctrl.phase != ExpeditionController.Phase.IN_BATTLE:
			break
	assert_not_null(ctrl.last_battle, "um combate jogado")
	return ExpeditionSave.build(ctrl, 1)


func test_a_version_2_save_is_rebuilt_under_the_new_rules() -> void:
	var save: Dictionary = _played_save()
	var expected: String = JSON.stringify(save["expedition"]["check"])
	save["save_version"] = 2
	# Under the old rules the check had other numbers (20 fixed at the end).
	save["expedition"]["check"]["saints"]["saint_george"]["desolation"] = 999
	assert_null(ExpeditionSave.restore(cat, save), "sem migração, o save antigo não abre")
	var migrated: Dictionary = SaveMigrations.new().migrate(save)
	assert_eq(int(migrated["save_version"]), 3)
	var ctrl := ExpeditionSave.restore(cat, migrated)
	assert_not_null(ctrl, "com a migração, abre")
	assert_eq(JSON.stringify(ExpeditionSave._plain(ctrl.snapshot())), expected, "refeito com as regras novas")


func test_a_rebuilt_save_stops_at_the_first_refused_command() -> void:
	var save: Dictionary = _played_save()
	var kept: int = (save["expedition"]["commands"] as Array).size()
	(save["expedition"]["commands"] as Array).append({"type": "ChoosePath", "node": "no_such_node"})
	(save["expedition"]["commands"] as Array).append({"type": "CompleteNode"})
	save["save_version"] = 2
	var ctrl := ExpeditionSave.restore(cat, SaveMigrations.new().migrate(save))
	assert_not_null(ctrl)
	assert_eq(ctrl.command_log.size(), kept, "o que as regras novas recusam fica de fora")
