extends GutTest
## T23: event import validations and option rules (narrative-system §3,
## §4.1 and §8).

const VALID_EVENT: String = """id: t_temptation
type: temptation
circle: 2
title_pt: "Teste"
origin: game_fiction
pages:
  - speaker: narrator
    text_pt: "Texto."
options:
  - id: refuse
    text_pt: "Recusar"
    safe: true
    outcomes:
      - { type: light, amount: -5 }
  - id: gamble
    text_pt: "Arriscar"
    chance:
      base: 0.5
      modifiers:
        - { if: saint_in_party, id: saint_t, add: 0.2 }
    on_success:
      - { type: provisions, id: bread, amount: 2 }
    on_failure:
      - { type: virtue, id: virtue_hope, amount: -1 }
      - { type: desolation, target: party, amount: 15 }
  - id: faithful
    text_pt: "Rezar"
    requires:
      - { type: virtue_at_least, id: virtue_charity, value: 3 }
    outcomes:
      - { type: alms, amount: 10 }
"""


func _import(event_text: String) -> BalanceImporter:
	var tables := BalanceFixture.valid_tables()
	tables["_events"] = {"circle_02/t.yaml": event_text}
	var imp := BalanceImporter.new()
	imp.import_tables(tables)
	return imp


func _has_error(imp: BalanceImporter, code: String) -> bool:
	return imp.errors.any(func(e: String) -> bool: return e.contains("[%s]" % code))


func _ctx(party: Array[StringName] = []) -> EventContext:
	var ctx := EventContext.new()
	ctx.party = party
	ctx.virtues = Virtues.start(_constants())
	return ctx


func _constants() -> ConstantsDef:
	var c := ConstantsDef.new()
	c.values = {"virtue_start": 2.0, "virtue_max": 5.0}
	return c


func test_valid_event_imports_with_defaults_filled() -> void:
	var imp := _import(VALID_EVENT)
	assert_eq(imp.errors, [] as Array[String])
	var e: EventDef = imp.events["t_temptation"]
	assert_eq(e.type, &"temptation")
	assert_eq(e.options.size(), 3)
	assert_eq(e.option(&"refuse")["safe"], true)
	assert_eq(e.option(&"gamble")["safe"], false)
	assert_eq_deep(e.option(&"refuse")["chance"], {})


func test_N02_temptation_without_a_safe_option_is_rejected() -> void:
	assert_true(_has_error(_import(VALID_EVENT.replace("    safe: true\n", "")), "no_safe_option"))


func test_chance_that_nothing_can_improve_is_rejected() -> void:
	var text := VALID_EVENT.replace("      modifiers:\n        - { if: saint_in_party, id: saint_t, add: 0.2 }\n", "")
	assert_true(_has_error(_import(text), "chance_without_modifier"))


func test_unknown_references_are_rejected() -> void:
	assert_true(_has_error(_import(VALID_EVENT.replace("id: bread", "id: caviar")), "unknown_id"))
	assert_true(_has_error(_import(VALID_EVENT.replace("type: light", "type: teleport")), "bad_enum"))


func test_N01_unmet_virtue_requirement_disables_the_option() -> void:
	var e: EventDef = _import(VALID_EVENT).events["t_temptation"]
	var unmet: Array[Dictionary] = EventRules.unmet_requirements(e.option(&"faithful"), _ctx())
	assert_eq(unmet.size(), 1)
	assert_eq(unmet[0]["id"], "virtue_charity")
	assert_true(EventRules.unmet_requirements(e.option(&"refuse"), _ctx()).is_empty())


func test_N03_chance_05_with_the_saint_in_party_shows_70() -> void:
	var e: EventDef = _import(VALID_EVENT).events["t_temptation"]
	assert_almost_eq(EventRules.chance(e.option(&"gamble"), _ctx()), 0.5, 0.0001)
	var party: Array[StringName] = [&"saint_t"]
	assert_almost_eq(EventRules.chance(e.option(&"gamble"), _ctx(party)), 0.7, 0.0001)


func test_N04_virtue_5_plus_1_stays_5_and_never_below_0() -> void:
	var v := Virtues.start(_constants())
	v.change(Virtues.HOPE, 9, _constants())
	assert_eq(v.get_value(Virtues.HOPE), 5)
	v.change(Virtues.HOPE, -9, _constants())
	assert_eq(v.get_value(Virtues.HOPE), 0)
	assert_eq(Virtues.start(_constants()).total(), 6)
