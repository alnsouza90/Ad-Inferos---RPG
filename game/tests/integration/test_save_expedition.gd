extends GutTest
## T26: saving and resuming an expedition exactly (save-load §1 and §8:
## S01 adapted to the walk, S02, S07), with the real M0 data.

const DIR: String = "user://test_save_expedition"

var cat: ExpeditionCatalog
var store: SaveStore


func before_all() -> void:
	cat = RealData.expedition_catalog()


func before_each() -> void:
	store = SaveStore.new(DIR)
	store.delete_all()
	store.validator = func(data: Dictionary) -> bool: return ExpeditionSave.restore(cat, data) != null


func after_all() -> void:
	SaveStore.new(DIR).delete_all()


func _new(seed: int) -> ExpeditionController:
	return ExpeditionController.start_new(cat, &"circle_02", seed, RealData.m0_party_ids(), cat.kit_provisions(&"m1_kit"), EncounterDef.ARENA_CIRCLE)


func _save_and_load(ctrl: ExpeditionController) -> ExpeditionController:
	assert_true(store.write(ExpeditionSave.build(ctrl, 1234)))
	var result: Dictionary = store.read()
	assert_eq(result["status"], SaveStore.STATUS_OK)
	return ExpeditionSave.restore(cat, result["data"])


## Compared as they read back from JSON (numbers as floats), like the save.
static func _same(a: ExpeditionController, b: ExpeditionController) -> bool:
	return JSON.stringify(ExpeditionSave._plain(a.snapshot()), "", true) == JSON.stringify(ExpeditionSave._plain(b.snapshot()), "", true)


## One step of a fixed policy through every phase of the leg.
func _step(ctrl: ExpeditionController) -> void:
	match ctrl.phase:
		ExpeditionController.Phase.AT_FORK:
			ctrl.execute(ExpeditionCommand.choose_path(ctrl.entrances()[0].id))
		ExpeditionController.Phase.IN_NODE:
			ctrl.execute(ExpeditionCommand.complete_node())
		ExpeditionController.Phase.IN_EVENT:
			ctrl.execute(ExpeditionCommand.choose_option(&"follow_tracks"))
		ExpeditionController.Phase.IN_RELIC:
			ctrl.execute(ExpeditionCommand.place_relic(&"saint_george"))
		ExpeditionController.Phase.IN_BATTLE:
			ctrl.execute(ExpeditionCommand.battle(FirstValidPolicy.choose(ctrl.battle)))
		ExpeditionController.Phase.AT_CAMP:
			ctrl.execute(ExpeditionCommand.leave_camp(ExpeditionCommand.MODE_CONTINUE))


func test_S01_save_and_load_in_the_middle_of_the_walk() -> void:
	var ctrl := _new(1)
	for i: int in 40:
		if ctrl.phase == ExpeditionController.Phase.AT_FORK and ctrl.current_layer() >= 2:
			break
		_step(ctrl)
	assert_eq(ctrl.phase, ExpeditionController.Phase.AT_FORK)
	var loaded := _save_and_load(ctrl)
	assert_not_null(loaded)
	assert_true(_same(ctrl, loaded))
	assert_eq(loaded.entrances().size(), ctrl.entrances().size(), "mesma bifurcação (E13)")


func test_S02_save_in_the_middle_of_the_party_turn() -> void:
	var ctrl := _new(2)
	for i: int in 40:
		if ctrl.phase == ExpeditionController.Phase.IN_BATTLE:
			break
		_step(ctrl)
	assert_eq(ctrl.phase, ExpeditionController.Phase.IN_BATTLE)
	# One saint acts, the others have not acted yet.
	ctrl.execute(ExpeditionCommand.battle(FirstValidPolicy.choose(ctrl.battle)))
	var loaded := _save_and_load(ctrl)
	assert_eq(loaded.phase, ExpeditionController.Phase.IN_BATTLE)
	assert_eq(JSON.stringify(loaded.battle.state.to_dict()), JSON.stringify(ctrl.battle.state.to_dict()))
	assert_eq(loaded.battle.fervor.amount, ctrl.battle.fervor.amount)
	for i: int in ctrl.battle.state.party.size():
		assert_eq(loaded.battle.state.party[i].has_acted, ctrl.battle.state.party[i].has_acted)


func test_tampered_save_falls_back_to_the_previous_one() -> void:
	var ctrl := _new(3)
	store.write(ExpeditionSave.build(ctrl, 1))
	_step(ctrl)
	var data: Dictionary = ExpeditionSave.build(ctrl, 1)
	data["expedition"]["check"]["expedition"]["light"] = 7
	store.write(data)
	var result: Dictionary = store.read()
	assert_eq(result["status"], SaveStore.STATUS_FROM_BACKUP)


func test_S07_100_save_load_cycles_with_random_valid_commands() -> void:
	var ctrl := _new(4)
	var rng := RngStream.new(99, &"test")
	var cycles: int = 0
	var guard: int = 0
	while cycles < 100 and guard < 2000:
		guard += 1
		if ctrl.is_over():
			ctrl = _new(4 + guard)
		if ctrl.phase == ExpeditionController.Phase.IN_BATTLE:
			var options: Array[BattleCommand] = CommandCandidates.all_valid(ctrl.battle, true)
			var cmd: BattleCommand = options[rng.pick_index(options.size())] if not options.is_empty() else BattleCommand.end_party_turn()
			if ctrl.execute(ExpeditionCommand.battle(cmd)) != &"":
				ctrl.execute(ExpeditionCommand.battle(BattleCommand.end_party_turn()))
		else:
			_step(ctrl)
		var loaded := _save_and_load(ctrl)
		assert_true(_same(ctrl, loaded), "ciclo %d" % cycles)
		if ctrl.phase == ExpeditionController.Phase.IN_BATTLE:
			assert_eq(JSON.stringify(loaded.battle.state.to_dict()), JSON.stringify(ctrl.battle.state.to_dict()), "ciclo %d" % cycles)
		ctrl = loaded
		cycles += 1
	assert_eq(cycles, 100)
