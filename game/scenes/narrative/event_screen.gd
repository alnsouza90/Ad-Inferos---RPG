class_name EventScreen
extends Control
## The narrative event screen (screens §6, narrative-system §3): the
## illustration behind, the text box in the lower third with a tab for who
## speaks (the narrator has none, D-151), the pages one tap at a time, then
## the options as big buttons with their requirement and chance written on
## them, and the origin label in a corner. One tap on an option shows it,
## the second sends ChooseOption; the result text and what changed follow.
## The screen only sends commands and reads the state (architecture §3.2).

const STAGE_SIZE := Vector2(1920, 1080)
const ART_PATH: String = "res://assets/events/circle_%02d/event_%s.png"
## Without its own illustration, the circle's scenery, darkened.
const FALLBACK_PATH: String = "res://assets/environments/circles/circle_%02d/t1/env_circle_%02d_t1_back.png"
const FALLBACK_TINT := Color(0.45, 0.42, 0.45)
const BOX_RECT := Rect2(80, 712, 1760, 320)
const TAB_SIZE := Vector2(460, 64)
const OPTION_SIZE := Vector2(860, 150)
const OPTION_POS := Vector2(980, 150)
const BUTTON_SIZE := Vector2(300, 90)
const COLOR_BACKGROUND := Color(0.06, 0.05, 0.06)
const COLOR_BOX := Color(0.08, 0.06, 0.07, 0.9)
const COLOR_TAB := Color(0.3, 0.22, 0.28, 0.95)
const COLOR_OPTION := Color(0.16, 0.12, 0.15, 0.94)
const COLOR_CHOSEN := Color(1.0, 0.9, 0.55)
## Slant of the narrator's lines (no italic font in the project yet); the
## FontVariation docs slant with the x axis (1, slant).
const ITALIC_SKEW: float = 0.2

## Emitted when the player leaves the result: the controller is already in
## its next phase (back to the walk, a battle, the camp).
signal finished

var data: GameData
var texts: EventTexts
var ctrl: ExpeditionController
## Takes an ExpeditionCommand and returns the refusal reason (&"" accepted).
var run: Callable
## The event shown; kept after the choice to write its result text.
var event: EventDef
var page_index: int = 0
var selected_option: StringName = &""
var chosen_option: StringName = &""

var _stage: Control
var _background: TextureRect
var _title: Label
var _origin: Label
var _tab: Panel
var _speaker: Label
var _text: Label
var _hint: Label
var _next_button: Button
var _options_box: VBoxContainer
var _option_buttons: Dictionary = {}
var _italic: FontVariation
var _result_shown: bool = false
var _before: Dictionary = {}


func setup(p_data: GameData, p_ctrl: ExpeditionController, p_run: Callable = Callable()) -> void:
	data = p_data
	texts = EventTexts.new(p_data)
	ctrl = p_ctrl
	event = p_ctrl.event
	run = p_run if p_run.is_valid() else func(cmd: ExpeditionCommand) -> StringName: return ctrl.execute(cmd)


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_build()
	_center_stage()
	_refresh()


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_center_stage()


# --- player input (also called by the tests) ------------------------------------

## Next page; after the last one the options appear; after the result, leave.
func press_next() -> void:
	if _result_shown:
		finished.emit()
		return
	if page_index < page_count() - 1:
		page_index += 1
		_refresh()


func tap_option(option_id: StringName) -> void:
	if not options_shown() or not _option_buttons.has(option_id):
		return
	if ctrl.option_problem(option_id) != &"":
		_hint.text = texts.t(&"event_option_blocked")
		return
	if selected_option == option_id:
		_choose(option_id)
		return
	selected_option = option_id
	_refresh()


# --- queries for the tests ---------------------------------------------------------

func page_count() -> int:
	return event.pages.size() if event != null else 0


func options_shown() -> bool:
	return not _result_shown and page_index >= page_count() - 1


func result_shown() -> bool:
	return _result_shown


func option_ids() -> Array[StringName]:
	var ids: Array[StringName] = []
	for option: Dictionary in event.options:
		ids.append(StringName(str(option.get("id", ""))))
	return ids


func option_text(option_id: StringName) -> String:
	var button: Button = _option_buttons.get(option_id)
	return button.text if button != null else ""


func option_disabled(option_id: StringName) -> bool:
	var button: Button = _option_buttons.get(option_id)
	return button == null or button.disabled


func text_shown() -> String:
	return _text.text


func speaker_shown() -> String:
	return _speaker.text if _tab.visible else ""


func origin_shown() -> String:
	return _origin.text


func hint_shown() -> String:
	return _hint.text


func background_texture() -> Texture2D:
	return _background.texture


func stage_position() -> Vector2:
	return _stage.position if _stage != null else Vector2.ZERO


# --- flow ------------------------------------------------------------------------

func _choose(option_id: StringName) -> void:
	_before = _measure()
	var reason: StringName = run.call(ExpeditionCommand.choose_option(option_id))
	if reason != &"":
		_hint.text = texts.t(StringName("event_reason_%s" % reason))
		return
	chosen_option = option_id
	selected_option = &""
	_result_shown = true
	_refresh()


## The numbers the result lines compare before and after the choice.
func _measure() -> Dictionary:
	var desolation: Dictionary = {}
	for id: StringName in ctrl.state.party:
		desolation[id] = (ctrl.saints[id] as SaintStatus).desolation
	var virtues: Dictionary = {}
	for id: StringName in Virtues.ALL:
		virtues[id] = ctrl.virtues.get_value(id)
	var provisions: Dictionary = {}
	for id: StringName in ctrl.state.provisions:
		provisions[id] = int(provisions.get(id, 0)) + 1
	return {"light": ctrl.state.light, "alms": ctrl.state.alms_unbanked, "desolation": desolation, "virtues": virtues, "provisions": provisions}


## Result text of the option (narrative-system §3, D-141), then what changed.
func _result_text() -> String:
	var option: Dictionary = event.option(chosen_option)
	var key: String = "result_pt"
	if EventRules.has_chance(option):
		key = "success_pt" if _last_success() else "failure_pt"
	var lines: Array[String] = []
	var story: String = str(option.get(key, ""))
	if story != "":
		lines.append(story)
	lines.append_array(_changes())
	return "\n".join(lines)


func _last_success() -> bool:
	for i: int in range(ctrl.history.size() - 1, -1, -1):
		var entry: Dictionary = ctrl.history[i]
		if entry["type"] == ExpeditionController.EV_EVENT_RESOLVED:
			return bool((entry["data"] as Dictionary).get("success", true))
	return true


func _changes() -> Array[String]:
	var after: Dictionary = _measure()
	var parts: Array[String] = []
	var light: int = after["light"] - _before["light"]
	if light != 0:
		parts.append(texts.t(&"event_change_light", {"delta": EventTexts.signed(light)}))
	for id: StringName in Virtues.ALL:
		var delta: int = int(after["virtues"][id]) - int(_before["virtues"][id])
		if delta != 0:
			parts.append(texts.t(&"event_change_virtue", {"virtue": texts.t(id), "delta": EventTexts.signed(delta)}))
	for id: StringName in ctrl.state.party:
		var delta: int = int(after["desolation"].get(id, 0)) - int(_before["desolation"].get(id, 0))
		if delta != 0:
			parts.append(texts.t(&"event_change_desolation", {"saint": texts.saint_name(id), "delta": EventTexts.signed(delta)}))
	var alms: int = after["alms"] - _before["alms"]
	if alms != 0:
		parts.append(texts.t(&"event_change_alms", {"delta": EventTexts.signed(alms)}))
	var seen: Dictionary = {}
	for id: Variant in (after["provisions"] as Dictionary).keys() + (_before["provisions"] as Dictionary).keys():
		if seen.has(id):
			continue
		seen[id] = true
		var delta: int = int(after["provisions"].get(id, 0)) - int(_before["provisions"].get(id, 0))
		if delta != 0:
			parts.append(texts.t(&"event_change_provision", {"provision": texts.provision_name(id), "delta": EventTexts.signed(delta)}))
	if ctrl.phase == ExpeditionController.Phase.IN_BATTLE:
		parts.append(texts.t(&"event_change_battle"))
	if parts.is_empty():
		return [] as Array[String]
	var result: Array[String] = ["", " · ".join(parts)]
	return result


# --- drawing -----------------------------------------------------------------------

func _refresh() -> void:
	if _stage == null or event == null:
		return
	if _result_shown:
		_show_line(EventTexts.NARRATOR, _result_text())
		_options_box.visible = false
		_next_button.visible = true
		_next_button.text = texts.t(&"event_continue")
		_hint.text = ""
		return
	var page: Dictionary = event.pages[page_index] if page_count() > 0 else {}
	_show_line(StringName(str(page.get("speaker", EventTexts.NARRATOR))), str(page.get("text_pt", "")))
	var at_options: bool = options_shown()
	_next_button.visible = not at_options
	_next_button.text = texts.t(&"event_next")
	_options_box.visible = at_options
	for id: StringName in _option_buttons:
		(_option_buttons[id] as Button).modulate = COLOR_CHOSEN if id == selected_option else Color.WHITE
	if at_options:
		_hint.text = texts.t(&"event_hint_confirm") if selected_option != &"" else texts.t(&"event_hint_choose")
	else:
		_hint.text = ""


func _show_line(speaker_id: StringName, line: String) -> void:
	var name_text: String = texts.speaker(speaker_id)
	_tab.visible = name_text != ""
	_speaker.text = name_text
	_text.text = line
	if name_text == "":
		_text.add_theme_font_override("font", _italic)
	else:
		_text.remove_theme_font_override("font")


func _build_options() -> void:
	var ctx: EventContext = ctrl.event_context()
	for option: Dictionary in event.options:
		var id := StringName(str(option.get("id", "")))
		var label: String = str(option.get("text_pt", ""))
		var detail: String = texts.option_detail(option, ctx)
		if detail != "":
			label += "\n" + detail
		var button := _button(label, OPTION_SIZE)
		button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		button.disabled = ctrl.option_problem(id) != &""
		var style := StyleBoxFlat.new()
		style.bg_color = COLOR_OPTION
		style.set_corner_radius_all(12)
		style.set_content_margin_all(16)
		button.add_theme_stylebox_override("normal", style)
		button.pressed.connect(tap_option.bind(id))
		_options_box.add_child(button)
		_option_buttons[id] = button


func _center_stage() -> void:
	if _stage != null:
		_stage.position = ((_screen_size() - STAGE_SIZE) * 0.5).floor()


## Never centre on a zero size (the T17 phone bug, lessons.md).
func _screen_size() -> Vector2:
	if size.x > 0.0 and size.y > 0.0:
		return size
	return get_viewport_rect().size if is_inside_tree() else STAGE_SIZE


func _art() -> Texture2D:
	var own: String = ART_PATH % [event.circle, event.id]
	if ResourceLoader.exists(own):
		return load(own) as Texture2D
	var fallback: String = FALLBACK_PATH % [event.circle, event.circle]
	if ResourceLoader.exists(fallback):
		return load(fallback) as Texture2D
	return null


func _build() -> void:
	var ui_theme := Theme.new()
	ui_theme.default_font_size = 30
	theme = ui_theme
	clip_contents = true
	_italic = FontVariation.new()
	_italic.base_font = ThemeDB.fallback_font
	_italic.variation_transform = Transform2D(Vector2(1, ITALIC_SKEW), Vector2(0, 1), Vector2.ZERO)
	var background := ColorRect.new()
	background.color = COLOR_BACKGROUND
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)
	_stage = Control.new()
	_stage.size = STAGE_SIZE
	_stage.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_stage)
	_background = TextureRect.new()
	_background.texture = _art()
	_background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	_background.size = STAGE_SIZE
	_background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if not ResourceLoader.exists(ART_PATH % [event.circle, event.id]):
		_background.modulate = FALLBACK_TINT
	_stage.add_child(_background)
	_title = _label(event.title_pt, 38)
	_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_title.position = Vector2(80, 50)
	_title.size = Vector2(880, 60)
	_title.add_theme_color_override("font_shadow_color", Color.BLACK)
	_stage.add_child(_title)
	_origin = _label(texts.origin(event.origin), 22)
	_origin.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_origin.position = Vector2(STAGE_SIZE.x - 680, 40)
	_origin.size = Vector2(600, 40)
	_origin.modulate = Color(1, 1, 1, 0.7)
	_origin.add_theme_color_override("font_shadow_color", Color.BLACK)
	_stage.add_child(_origin)
	_options_box = VBoxContainer.new()
	_options_box.position = OPTION_POS
	_options_box.add_theme_constant_override("separation", 18)
	_stage.add_child(_options_box)
	_build_options()
	var box := Panel.new()
	var box_style := StyleBoxFlat.new()
	box_style.bg_color = COLOR_BOX
	box_style.set_corner_radius_all(14)
	box.add_theme_stylebox_override("panel", box_style)
	box.position = BOX_RECT.position
	box.size = BOX_RECT.size
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(box)
	_tab = Panel.new()
	var tab_style := StyleBoxFlat.new()
	tab_style.bg_color = COLOR_TAB
	tab_style.set_corner_radius_all(10)
	_tab.add_theme_stylebox_override("panel", tab_style)
	_tab.position = BOX_RECT.position + Vector2(30, -TAB_SIZE.y + 8)
	_tab.size = TAB_SIZE
	_tab.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(_tab)
	_speaker = _label("", 30)
	_speaker.size = TAB_SIZE
	_speaker.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_tab.add_child(_speaker)
	_text = _label("", 32)
	_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_text.position = BOX_RECT.position + Vector2(40, 36)
	_text.size = Vector2(BOX_RECT.size.x - 80, BOX_RECT.size.y - 130)
	_stage.add_child(_text)
	_hint = _label("", 26)
	_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_hint.position = BOX_RECT.position + Vector2(40, BOX_RECT.size.y - 80)
	_hint.size = Vector2(1100, 60)
	_hint.modulate = Color(1, 1, 1, 0.75)
	_stage.add_child(_hint)
	_next_button = _button("", BUTTON_SIZE)
	_next_button.position = BOX_RECT.end - BUTTON_SIZE - Vector2(30, 24)
	_next_button.pressed.connect(press_next)
	_stage.add_child(_next_button)


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
