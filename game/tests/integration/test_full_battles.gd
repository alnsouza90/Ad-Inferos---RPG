extends GutTest
## T12: full battles with a fixed policy (C18) and the determinism test of
## testing.md §4, on the 4 m0_* encounters with the real M0 kits.

const SEED: int = 4242
const MAX_ROUNDS: int = 40


func _new(encounter_id: String, seed: int) -> BattleController:
	var ctrl := BattleController.new(RealData.battle(encounter_id, seed))
	ctrl.start()
	return ctrl


## Full serialized result: state, Fervor, phase and every event, in order.
func _serialize(ctrl: BattleController) -> String:
	var events: Array = []
	for e: BattleEvent in ctrl.history:
		events.append(e.to_dict())
	return JSON.stringify({"state": ctrl.state.to_dict(), "fervor": ctrl.fervor.amount, "phase": ctrl.phase, "events": events, "errors": ctrl.errors}, "", true)


func test_every_m0_encounter_plays_to_the_end_without_engine_errors() -> void:
	for encounter_id: String in RealData.m0_encounter_ids():
		var ctrl := _new(encounter_id, SEED)
		var sent: int = FirstValidPolicy.play(ctrl, MAX_ROUNDS)
		assert_true(ctrl.is_over(), "%s terminou" % encounter_id)
		assert_eq(ctrl.errors, [] as Array[String], "%s sem erros do motor" % encounter_id)
		gut.p("%s: %s em %d rodadas, %d comandos" % [encounter_id, ["", "", "", "", "", "", "vitória", "derrota", "retirada"][ctrl.phase], ctrl.state.round_number, sent])


func test_C18_same_seed_and_commands_give_identical_final_states() -> void:
	for encounter_id: String in RealData.m0_encounter_ids():
		var played := _new(encounter_id, SEED)
		FirstValidPolicy.play(played, MAX_ROUNDS)
		# The log goes through JSON text, as in a save file (ADR-0005).
		var log_text: String = JSON.stringify(played.command_log)
		var replayed := _new(encounter_id, SEED)
		for data: Variant in JSON.parse_string(log_text):
			assert_true(replayed.execute(BattleCommand.from_dict(data as Dictionary)).ok)
		assert_eq(_serialize(replayed), _serialize(played), "%s idêntico byte a byte" % encounter_id)


func test_policy_is_deterministic_run_after_run() -> void:
	for encounter_id: String in RealData.m0_encounter_ids():
		var a := _new(encounter_id, SEED)
		var b := _new(encounter_id, SEED)
		FirstValidPolicy.play(a, MAX_ROUNDS)
		FirstValidPolicy.play(b, MAX_ROUNDS)
		assert_eq(JSON.stringify(a.command_log), JSON.stringify(b.command_log))
		assert_eq(_serialize(a), _serialize(b))


func test_the_seed_matters_for_random_choices() -> void:
	# m0_hard_02 has the Swarm Mother, whose sting picks a random target.
	var results: Dictionary = {}
	for seed: int in range(1, 21):
		var ctrl := _new("m0_hard_02", seed)
		FirstValidPolicy.play(ctrl, MAX_ROUNDS)
		results[_serialize(ctrl).sha256_text()] = true
	assert_gt(results.size(), 1, "sementes diferentes produzem combates diferentes")
