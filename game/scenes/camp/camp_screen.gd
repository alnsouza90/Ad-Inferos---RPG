class_name CampScreen
extends Control
## The camp (screens §5, expedition §6): the camp scenery, one card per saint
## with portrait, hit points, desolation and injury, and the activity buttons
## (Vigil, Share, Prayer, the saint's own skill; Share and some skills ask
## whom). Fixed buttons: Rest (shows the cost of 1 Bread), Continue and
## Planned retreat, each confirmed by a second tap. After resting, the result
## shows what changed and the ambush roll. The screen only sends commands
## (Rest, LeaveCamp) and reads the state (architecture §3.2).

const STAGE_SIZE := Vector2(1920, 1080)
const ART_PATH: String = "res://assets/environments/camp/env_circle_%02d_camp.png"
const PORTRAIT_PATH: String = "res://assets/characters/saints/%s/portrait/%s_portrait.png"
const CARD_SIZE := Vector2(580, 640)
const CARD_Y: float = 150.0
const CARD_STEP: float = 610.0
const PORTRAIT_SIZE := Vector2(210, 280)
const ACTIVITY_SIZE := Vector2(266, 70)
const TARGET_SIZE := Vector2(266, 60)
const FIXED_SIZE := Vector2(420, 100)
const COLOR_BACKGROUND := Color(0.06, 0.05, 0.06)
const COLOR_CARD := Color(0.07, 0.06, 0.07, 0.86)
const COLOR_CHOSEN := Color(1.0, 0.9, 0.55)
const COLOR_DIM := Color(0, 0, 0, 0.8)
const ACTIVITIES: Array[StringName] = [
	ExpeditionController.ACTIVITY_VIGIL, ExpeditionController.ACTIVITY_SHARE,
	ExpeditionController.ACTIVITY_PRAYER, ExpeditionController.ACTIVITY_OWN,
]
const FIXED_REST: StringName = &"rest"
const FIXED_CONTINUE: StringName = &"continue"
const FIXED_RETREAT: StringName = &"retreat"

## The ambush started a battle: the host plays it, then calls refresh().
signal battle_started
## LeaveCamp was accepted (continue or planned retreat).
signal left_camp

var data: GameData
var ctrl: ExpeditionController
var run: Callable
## saint id -> {"activity": StringName, "target": StringName}
var choices: Dictionary = {}
## Saint whose activity waits for a target.
var asking_target: StringName = &""
## Fixed button armed by a first tap (the second confirms).
var armed: StringName = &""

var _stage: Control
var _light: Label
var _alms: Label
var _bread: Label
var _cards: Dictionary = {}
var _info: Label
var _fixed: Dictionary = {}
var _result: Control
var _result_text: Label
var _before: Dictionary = {}


func setup(p_data: GameData, p_ctrl: ExpeditionController, p_run: Callable = Callable()) -> void:
	data = p_data
	ctrl = p_ctrl
	run = p_run if p_run.is_valid() else func(cmd: ExpeditionCommand) -> StringName: return ctrl.execute(cmd)


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_build()
	_center_stage()
	refresh()


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_center_stage()


# --- player input (also called by the tests) ------------------------------------

func choose_activity(saint_id: StringName, activity: StringName) -> void:
	if not _can_plan():
		return
	armed = &""
	choices[saint_id] = {"activity": activity, "target": &""}
	asking_target = saint_id if _needs_target(saint_id, activity) else &""
	_info.text = _activity_desc(saint_id, activity)
	refresh()


func choose_target(saint_id: StringName, target_id: StringName) -> void:
	if not choices.has(saint_id) or not ctrl.state.party.has(target_id):
		return
	(choices[saint_id] as Dictionary)["target"] = target_id
	if asking_target == saint_id:
		asking_target = &""
	refresh()


func press_rest() -> void:
	if not _can_plan():
		return
	var problem: StringName = ctrl.rest_problem(activities())
	if problem != &"":
		armed = &""
		_info.text = data.ui.text(StringName("camp_reason_%s" % problem))
		refresh()
		return
	if armed != FIXED_REST:
		armed = FIXED_REST
		_info.text = data.ui.text(&"camp_confirm_rest")
		refresh()
		return
	armed = &""
	_before = _measure()
	var reason: StringName = run.call(ExpeditionCommand.rest(activities()))
	if reason != &"":
		_info.text = data.ui.text(StringName("camp_reason_%s" % reason))
		refresh()
		return
	_show_result()


func press_continue() -> void:
	_leave(FIXED_CONTINUE, ExpeditionCommand.MODE_CONTINUE, &"camp_confirm_continue")


func press_retreat() -> void:
	_leave(FIXED_RETREAT, ExpeditionCommand.MODE_RETREAT, &"camp_confirm_retreat")


## Leaves the result: into the ambush battle, or back to the camp.
func press_result_continue() -> void:
	_result.visible = false
	if ctrl.phase == ExpeditionController.Phase.IN_BATTLE:
		battle_started.emit()
		return
	refresh()


## Redraws from the state (the host calls it when coming back from the ambush).
func refresh() -> void:
	if _stage == null:
		return
	_light.text = data.ui.text(&"walk_light", {"value": ctrl.state.light})
	_alms.text = data.ui.text(&"walk_alms", {"banked": ctrl.state.alms_banked, "unbanked": ctrl.state.alms_unbanked})
	_bread.text = data.ui.text(&"camp_bread", {"count": ctrl.state.provisions.count(&"bread")})
	for saint_id: StringName in _cards:
		_refresh_card(saint_id)
	var rest_button: Button = _fixed[FIXED_REST]
	rest_button.disabled = not _can_plan()
	for key: StringName in _fixed:
		(_fixed[key] as Button).modulate = COLOR_CHOSEN if key == armed else Color.WHITE
	if ctrl.state.camp_rested and armed == &"" and not _result.visible:
		_info.text = data.ui.text(&"camp_reason_already_rested")


# --- queries for the tests ---------------------------------------------------------

## The activities as the Rest command takes them, in party order.
func activities() -> Array[Dictionary]:
	var list: Array[Dictionary] = []
	for saint_id: StringName in ctrl.state.party:
		if choices.has(saint_id):
			var c: Dictionary = choices[saint_id]
			list.append({"saint": saint_id, "activity": c["activity"], "target": c["target"]})
	return list


func card_text(saint_id: StringName) -> String:
	var card: Dictionary = _cards.get(saint_id, {})
	return (card["stats"] as Label).text if not card.is_empty() else ""


func activity_button(saint_id: StringName, activity: StringName) -> Button:
	var card: Dictionary = _cards.get(saint_id, {})
	return (card["activities"] as Dictionary).get(activity) if not card.is_empty() else null


func target_buttons_shown(saint_id: StringName) -> bool:
	var card: Dictionary = _cards.get(saint_id, {})
	return not card.is_empty() and (card["targets"] as Control).visible


func portrait_of(saint_id: StringName) -> Texture2D:
	var card: Dictionary = _cards.get(saint_id, {})
	return (card["portrait"] as TextureRect).texture if not card.is_empty() else null


func info_text() -> String:
	return _info.text


func fixed_button(key: StringName) -> Button:
	return _fixed.get(key)


func result_shown() -> bool:
	return _result.visible


func result_text() -> String:
	return _result_text.text


func stage_position() -> Vector2:
	return _stage.position if _stage != null else Vector2.ZERO


# --- flow ------------------------------------------------------------------------

func _can_plan() -> bool:
	return ctrl.phase == ExpeditionController.Phase.AT_CAMP and not ctrl.state.camp_rested


func _needs_target(saint_id: StringName, activity: StringName) -> bool:
	if activity == ExpeditionController.ACTIVITY_SHARE:
		return true
	if activity == ExpeditionController.ACTIVITY_OWN:
		var skill: CampSkillDef = _skill(saint_id)
		return skill != null and ExpeditionController.camp_skill_needs_target(skill)
	return false


func _skill(saint_id: StringName) -> CampSkillDef:
	var def: SaintDef = data.saints.get(saint_id)
	return def.camp_skill if def != null else null


func _leave(key: StringName, mode: StringName, confirm_key: StringName) -> void:
	if ctrl.phase != ExpeditionController.Phase.AT_CAMP:
		return
	if armed != key:
		armed = key
		_info.text = data.ui.text(confirm_key)
		refresh()
		return
	armed = &""
	var reason: StringName = run.call(ExpeditionCommand.leave_camp(mode))
	if reason != &"":
		_info.text = data.ui.text(StringName("camp_reason_%s" % reason))
		refresh()
		return
	left_camp.emit()


func _measure() -> Dictionary:
	var saints: Dictionary = {}
	for id: StringName in ctrl.state.party:
		var status: SaintStatus = ctrl.saints[id]
		saints[id] = {"hp": status.hp, "desolation": status.desolation, "injury": status.injury}
	return {"saints": saints, "bread": ctrl.state.provisions.count(&"bread"), "incense": ctrl.state.provisions.count(&"incense"), "alms": ctrl.state.alms_banked}


func _show_result() -> void:
	var t: UiTextDef = data.ui
	var lines: Array[String] = []
	var after: Dictionary = _measure()
	for id: StringName in ctrl.state.party:
		var b: Dictionary = _before["saints"][id]
		var a: Dictionary = after["saints"][id]
		var parts: Array[String] = []
		if int(a["hp"]) != int(b["hp"]):
			parts.append(t.text(&"camp_change_hp", {"delta": EventTexts.signed(int(a["hp"]) - int(b["hp"]))}))
		if int(a["desolation"]) != int(b["desolation"]):
			parts.append(t.text(&"camp_change_desolation", {"delta": EventTexts.signed(int(a["desolation"]) - int(b["desolation"]))}))
		if a["injury"] != b["injury"]:
			parts.append(t.text(&"camp_change_injury_healed"))
		if not parts.is_empty():
			lines.append("%s: %s" % [_saint_name(id), ", ".join(parts)])
	var bread: int = int(after["bread"]) - int(_before["bread"])
	lines.append(t.text(&"camp_change_bread", {"delta": EventTexts.signed(bread)}) if bread != 0 else t.text(&"camp_bread_kept"))
	if ctrl.state.next_battle_fervor > 0:
		lines.append(t.text(&"camp_change_fervor", {"value": ctrl.state.next_battle_fervor}))
	var alms: int = int(after["alms"]) - int(_before["alms"])
	if alms != 0:
		lines.append(t.text(&"event_change_alms", {"delta": EventTexts.signed(alms)}))
	lines.append("")
	lines.append(t.text(_ambush_key()))
	_result_text.text = "\n".join(lines)
	_result.visible = true
	refresh()


## What the ambush roll after this rest gave (expedition §6 step 4).
func _ambush_key() -> StringName:
	for i: int in range(ctrl.history.size() - 1, -1, -1):
		var entry: Dictionary = ctrl.history[i]
		if entry["type"] == ExpeditionController.EV_CAMP_RESTED:
			return &"camp_ambush_none"
		if entry["type"] == ExpeditionController.EV_AMBUSH:
			if StringName(str((entry["data"] as Dictionary).get("cancelled_by", ""))) != &"":
				return &"camp_ambush_cancelled"
			return &"camp_ambush_battle"
	return &"camp_ambush_none"


func _activity_desc(saint_id: StringName, activity: StringName) -> String:
	var c: ConstantsDef = ctrl.catalog.constants
	match activity:
		ExpeditionController.ACTIVITY_VIGIL:
			return data.ui.text(&"camp_vigil_desc", {"value": c.get_int(&"desolation_vigil")})
		ExpeditionController.ACTIVITY_SHARE:
			return data.ui.text(&"camp_share_desc", {"pct": roundi(c.get_float(&"share_heal_pct") * 100.0)})
		ExpeditionController.ACTIVITY_PRAYER:
			return data.ui.text(&"camp_prayer_desc", {"cap": c.get_int(&"prayer_fervor_cap")})
	var skill: CampSkillDef = _skill(saint_id)
	return skill.desc_pt if skill != null else ""


func _activity_name(saint_id: StringName, activity: StringName) -> String:
	if activity == ExpeditionController.ACTIVITY_OWN:
		var skill: CampSkillDef = _skill(saint_id)
		return skill.name_pt if skill != null else ""
	return data.ui.text(StringName("camp_%s" % activity))


func _saint_name(id: StringName) -> String:
	var def: SaintDef = data.saints.get(id)
	return def.name_pt if def != null else String(id)


# --- drawing -----------------------------------------------------------------------

func _refresh_card(saint_id: StringName) -> void:
	var card: Dictionary = _cards[saint_id]
	var status: SaintStatus = ctrl.saints[saint_id]
	var lines: Array[String] = [
		data.ui.text(&"hp", {"hp": status.hp, "max": status.max_hp}),
		data.ui.text(&"desolation", {"value": status.desolation}),
	]
	if status.spirit_state != Desolation.NORMAL:
		lines.append(data.ui.text(StringName("spirit_%s" % status.spirit_state)))
	if status.injury != SaintStatus.INJURY_NONE:
		lines.append(data.ui.text(StringName("camp_injury_%s" % status.injury)))
	(card["stats"] as Label).text = "\n".join(lines)
	var choice: Dictionary = choices.get(saint_id, {})
	var chosen: StringName = choice.get("activity", &"")
	var buttons: Dictionary = card["activities"]
	for activity: StringName in buttons:
		var button: Button = buttons[activity]
		button.modulate = COLOR_CHOSEN if activity == chosen else Color.WHITE
		button.disabled = not _can_plan()
	var targets: Control = card["targets"]
	targets.visible = _can_plan() and chosen != &"" and _needs_target(saint_id, chosen)
	for child: Node in targets.get_children():
		if child is Button:
			var target_id: StringName = (child as Button).get_meta(&"saint")
			(child as Button).modulate = COLOR_CHOSEN if choice.get("target", &"") == target_id else Color.WHITE
	var summary: String = ""
	if chosen != &"":
		summary = _activity_name(saint_id, chosen)
		var target: StringName = choice.get("target", &"")
		if target != &"":
			summary += " → " + _saint_name(target)
		elif _needs_target(saint_id, chosen):
			summary += " → " + data.ui.text(&"camp_choose_target")
	(card["choice"] as Label).text = summary


func _center_stage() -> void:
	if _stage != null:
		_stage.position = ((_screen_size() - STAGE_SIZE) * 0.5).floor()


## Never centre on a zero size (the T17 phone bug, lessons.md).
func _screen_size() -> Vector2:
	if size.x > 0.0 and size.y > 0.0:
		return size
	return get_viewport_rect().size if is_inside_tree() else STAGE_SIZE


func _build() -> void:
	var ui_theme := Theme.new()
	ui_theme.default_font_size = 28
	theme = ui_theme
	clip_contents = true
	var background := ColorRect.new()
	background.color = COLOR_BACKGROUND
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)
	_stage = Control.new()
	_stage.size = STAGE_SIZE
	_stage.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_stage)
	var art := TextureRect.new()
	var path: String = ART_PATH % ctrl.circle_number()
	if ResourceLoader.exists(path):
		art.texture = load(path) as Texture2D
	art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	art.stretch_mode = TextureRect.STRETCH_SCALE
	var art_width: float = STAGE_SIZE.y * 2560.0 / 1080.0
	art.size = Vector2(art_width, STAGE_SIZE.y)
	art.position = Vector2((STAGE_SIZE.x - art_width) * 0.5, 0)
	art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(art)
	var bar := ColorRect.new()
	bar.color = Color(0, 0, 0, 0.55)
	bar.size = Vector2(STAGE_SIZE.x, 110)
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(bar)
	var title := _label(data.ui.text(&"node_camp"), 40)
	title.position = Vector2(70, 26)
	title.size = Vector2(300, 60)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_stage.add_child(title)
	_light = _label("", 28)
	_light.position = Vector2(380, 34)
	_light.size = Vector2(260, 50)
	_stage.add_child(_light)
	_alms = _label("", 28)
	_alms.position = Vector2(640, 34)
	_alms.size = Vector2(800, 50)
	_stage.add_child(_alms)
	_bread = _label("", 28)
	_bread.position = Vector2(1460, 34)
	_bread.size = Vector2(390, 50)
	_stage.add_child(_bread)
	for i: int in ctrl.state.party.size():
		_build_card(ctrl.state.party[i], Vector2(40 + i * CARD_STEP, CARD_Y))
	_info = _label("", 28)
	_info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_info.position = Vector2(80, 806)
	_info.size = Vector2(1760, 96)
	_info.add_theme_color_override("font_shadow_color", Color.BLACK)
	_stage.add_child(_info)
	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 40)
	row.position = Vector2(0, 920)
	row.size = Vector2(STAGE_SIZE.x, FIXED_SIZE.y)
	_stage.add_child(row)
	var cost: String = data.ui.text(&"camp_rest", {"cost": data.ui.text(&"camp_rest_cost")})
	for entry: Array in [[FIXED_REST, cost, press_rest], [FIXED_CONTINUE, data.ui.text(&"camp_continue"), press_continue], [FIXED_RETREAT, data.ui.text(&"camp_retreat"), press_retreat]]:
		var button := _button(str(entry[1]), FIXED_SIZE)
		button.pressed.connect(entry[2] as Callable)
		row.add_child(button)
		_fixed[entry[0]] = button
	_build_result()


func _build_card(saint_id: StringName, at: Vector2) -> void:
	var card := Panel.new()
	var style := StyleBoxFlat.new()
	style.bg_color = COLOR_CARD
	style.set_corner_radius_all(14)
	card.add_theme_stylebox_override("panel", style)
	card.position = at
	card.size = CARD_SIZE
	card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(card)
	var portrait := TextureRect.new()
	var path: String = PORTRAIT_PATH % [saint_id, saint_id]
	if ResourceLoader.exists(path):
		portrait.texture = load(path) as Texture2D
	portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	portrait.position = Vector2(14, 14)
	portrait.size = PORTRAIT_SIZE
	portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.add_child(portrait)
	var name_label := _label(_saint_name(saint_id), 32)
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	name_label.position = Vector2(240, 20)
	name_label.size = Vector2(320, 50)
	card.add_child(name_label)
	var stats := _label("", 26)
	stats.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	stats.position = Vector2(240, 80)
	stats.size = Vector2(320, 160)
	card.add_child(stats)
	var choice := _label("", 24)
	choice.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	choice.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	choice.position = Vector2(240, 236)
	choice.size = Vector2(320, 60)
	choice.modulate = COLOR_CHOSEN
	card.add_child(choice)
	var grid := GridContainer.new()
	grid.columns = 2
	grid.position = Vector2(16, 310)
	grid.add_theme_constant_override("h_separation", 16)
	grid.add_theme_constant_override("v_separation", 12)
	card.add_child(grid)
	var buttons: Dictionary = {}
	for activity: StringName in ACTIVITIES:
		if activity == ExpeditionController.ACTIVITY_OWN and _skill(saint_id) == null:
			continue
		var button := _button(_activity_name(saint_id, activity), ACTIVITY_SIZE)
		button.pressed.connect(choose_activity.bind(saint_id, activity))
		grid.add_child(button)
		buttons[activity] = button
	var targets := HBoxContainer.new()
	targets.position = Vector2(16, 480)
	targets.add_theme_constant_override("separation", 16)
	targets.visible = false
	card.add_child(targets)
	for other: StringName in ctrl.state.party:
		if other == saint_id:
			continue
		var target_button := _button(_saint_name(other), TARGET_SIZE)
		target_button.set_meta(&"saint", other)
		target_button.pressed.connect(choose_target.bind(saint_id, other))
		targets.add_child(target_button)
	_cards[saint_id] = {"stats": stats, "choice": choice, "activities": buttons, "targets": targets, "portrait": portrait}


func _build_result() -> void:
	_result = Control.new()
	_result.size = STAGE_SIZE
	_result.visible = false
	_stage.add_child(_result)
	var dim := ColorRect.new()
	dim.color = COLOR_DIM
	dim.size = STAGE_SIZE
	_result.add_child(dim)
	_result_text = _label("", 32)
	_result_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_result_text.position = Vector2(260, 200)
	_result_text.size = Vector2(1400, 560)
	_result_text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_result.add_child(_result_text)
	var button := _button(data.ui.text(&"event_next"), FIXED_SIZE)
	button.position = Vector2((STAGE_SIZE.x - FIXED_SIZE.x) * 0.5, 820)
	button.pressed.connect(press_result_continue)
	_result.add_child(button)


func _label(text: String, font_size: int) -> Label:
	var label := Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", font_size)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return label


func _button(text: String, button_size: Vector2) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = button_size
	button.size = button_size
	return button
