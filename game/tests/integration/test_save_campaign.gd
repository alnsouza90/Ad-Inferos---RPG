extends GutTest
## T46, save-load §3.3: the save keeps the campaign (version 6), and a save
## of version 5 opens with the campaign born from it (S08, S09).

var cat: ExpeditionCatalog


func before_all() -> void:
	cat = RealData.expedition_catalog()


func _expedition(seed: int = 3) -> ExpeditionController:
	return ExpeditionController.start_new(cat, &"circle_02", seed, RealData.m0_party_ids(), cat.kit_provisions(&"m1_kit"), 2)


## A save as the version 5 wrote it: no campaign beyond seed, virtues, flags.
func _v5_save(ctrl: ExpeditionController) -> Dictionary:
	var data: Dictionary = JSON.parse_string(JSON.stringify(ExpeditionSave.build(ctrl, 1234)))
	data["save_version"] = 5
	return data


func test_a_save_keeps_the_whole_campaign() -> void:
	var c := Campaign.start(cat, 9)
	Campaign.retreat(c, cat)
	c.alms = 210
	var ctrl := _expedition()
	Campaign.board(c, cat, ctrl)
	var data: Dictionary = JSON.parse_string(JSON.stringify(ExpeditionSave.build(ctrl, 9, &"expedition", {}, c)))
	assert_eq(int(data["save_version"]), 6)
	var back := ExpeditionSave.campaign_of(cat, data)
	assert_eq(back.week, 2)
	assert_eq(back.alms, 210)
	assert_true(back.retreat_used)
	assert_not_null(ExpeditionSave.restore(cat, data), "a expedição abre igual")


func test_s08_a_version_5_save_mid_expedition_goes_on_and_gets_its_campaign() -> void:
	var ctrl := _expedition()
	var first: MapNode = ctrl.entrances()[0]
	assert_eq(ctrl.execute(ExpeditionCommand.choose_path(first.id)), &"")
	var data: Dictionary = SaveMigrations.new().migrate(_v5_save(ctrl))
	assert_eq(int(data["save_version"]), SaveMigrations.CURRENT_VERSION)
	var back := ExpeditionSave.restore(cat, data)
	assert_not_null(back, "a expedição continua")
	assert_eq(back.state.current_node, ctrl.state.current_node)
	var c := ExpeditionSave.campaign_of(cat, data)
	assert_eq(c.week, 1)
	assert_eq(c.unlocked_saints, RealData.m0_party_ids())
	assert_eq(c.seed, 1234)
	# When it ends, the campaign takes it home and the week turns.
	Campaign.finish_expedition(c, cat, back)
	assert_eq(c.week, 2)


func test_s09_a_version_5_save_with_circle_two_done_brings_anthony() -> void:
	var ctrl := _expedition()
	ctrl.flags.append(&"circle_02_completed")
	ctrl.flags.append(&"circle_02_camp_1")
	var data: Dictionary = SaveMigrations.new().migrate(_v5_save(ctrl))
	var c := ExpeditionSave.campaign_of(cat, data)
	assert_true(c.unlocked_saints.has(&"saint_anthony_abbot"))
	assert_eq(c.pending_arrivals, [&"saint_anthony_abbot"] as Array[StringName], "São Cristóvão o anuncia")
	assert_true(c.flags.has(&"circle_02_camp_1"), "os Pousos consagrados passam")


func test_the_saints_of_an_old_save_come_into_the_campaign_as_they_were() -> void:
	var ctrl := _expedition()
	var george: SaintStatus = ctrl.saints[&"saint_george"]
	george.desolation = 55
	george.add_injury(SaintStatus.INJURY_MAJOR)
	var c := ExpeditionSave.campaign_of(cat, SaveMigrations.new().migrate(_v5_save(ctrl)))
	assert_eq(c.saint(&"saint_george").status.desolation, 55)
	assert_eq(c.saint(&"saint_george").status.injury, SaintStatus.INJURY_MAJOR)
	assert_eq(c.saint(&"saint_george").injury_weeks_left, cat.economy.get_int(&"injury_major_weeks"))
