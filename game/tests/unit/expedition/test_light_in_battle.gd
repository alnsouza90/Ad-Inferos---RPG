extends GutTest
## T19: Light bands inside a battle (expedition §4): enemy damage +10% with
## low Light; saints unaffected; desolation multiplier (also D01 and D08 in
## tests/unit/spirit/test_desolation.gd).

var c: BattleController
var s: BattleState


func before_each() -> void:
	c = BattleController.new(CombatFixture.battle())
	s = c.state
	c.start()


func _hit(actor: Combatant, target: Combatant, amount: float) -> int:
	var before: int = target.hp
	var effects: Array[EffectDef] = [CombatFixture.effect(&"damage", amount, &"untyped")]
	c.resolve_effects(actor, &"test", effects, [target] as Array[Combatant])
	return before - target.hp


func test_enemy_deals_10_percent_more_with_low_light() -> void:
	s.light = 20
	assert_eq(_hit(s.enemy_at(1), s.party_at(1), 10), 11)


func test_enemy_damage_is_normal_with_neutral_and_high_light() -> void:
	s.light = 50
	assert_eq(_hit(s.enemy_at(1), s.party_at(1), 10), 10)
	s.light = 90
	assert_eq(_hit(s.enemy_at(1), s.party_at(2), 10), 10)


func test_saints_damage_is_not_changed_by_low_light() -> void:
	s.light = 10
	assert_eq(_hit(s.party_at(1), s.enemy_at(1), 10), 10)


func test_enemy_intent_preview_includes_low_light() -> void:
	s.light = 20
	var enemy: Combatant = s.enemy_at(1)
	var effect: EffectDef = CombatFixture.effect(&"damage", 10, &"untyped")
	assert_eq(int(Damage.compute(s, enemy, s.party_at(1), effect, false)["damage"]), 11)


func test_high_light_reduces_desolation_gains_in_battle() -> void:
	s.light = 90
	var saint: Combatant = s.party_at(1)
	s.add_desolation(saint, 10, &"test")
	assert_eq(saint.desolation, 8)
