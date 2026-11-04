extends GutTest
## T17 (D-117): development-build helpers to see the halo change.

var c: BattleController
var s: BattleState


func before_each() -> void:
	c = BattleController.new(CombatFixture.battle())
	s = c.state
	c.start()


func _types(events: Array[BattleEvent]) -> Array[StringName]:
	var types: Array[StringName] = []
	for e: BattleEvent in events:
		types.append(e.type)
	return types


func test_desolation_goes_up_and_down_through_the_rules() -> void:
	var saint: Combatant = s.find(&"saint_a")
	var events: Array[BattleEvent] = c.dev_change_desolation(&"saint_a", 25)
	assert_eq(saint.desolation, 25)
	assert_true(_types(events).has(&"desolation_changed"))
	c.dev_change_desolation(&"saint_a", -10)
	assert_eq(saint.desolation, 15)
	c.dev_change_desolation(&"saint_a", -100)
	assert_eq(saint.desolation, 0, "não fica negativa")


func test_reaching_the_threshold_runs_the_faith_check() -> void:
	var saint: Combatant = s.find(&"saint_a")
	saint.desolation = 90
	var events: Array[BattleEvent] = c.dev_change_desolation(&"saint_a", 25)
	assert_true(_types(events).has(&"faith_check"))
	assert_ne(saint.spirit_state, Desolation.NORMAL)


func test_force_consolation() -> void:
	var saint: Combatant = s.find(&"saint_a")
	saint.desolation = 80
	var events: Array[BattleEvent] = c.dev_force_consolation(&"saint_a")
	assert_eq(saint.spirit_state, Desolation.CONSOLATION)
	assert_eq(saint.desolation, s.constants.get_int(&"consolation_reset_value"))
	assert_true(_types(events).has(&"state_changed"))


func test_dev_tools_are_not_logged_and_need_the_party_turn() -> void:
	c.dev_change_desolation(&"saint_a", 25)
	assert_eq(c.command_log, [] as Array[Dictionary], "não entram no log de comandos")
	c.end_party_turn()
	if c.phase != BattleController.Phase.PARTY_TURN:
		assert_eq(c.dev_change_desolation(&"saint_a", 25), [] as Array[BattleEvent])
	assert_eq(c.dev_change_desolation(&"enemy_1_1", 25), [] as Array[BattleEvent], "só santos")
