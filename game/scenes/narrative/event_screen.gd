class_name EventScreen
extends Control
## The narrative event screen (screens §6, narrative-system §3): the
## illustration behind, the text box in the lower third with a tab for who
## speaks (the narrator has none, D-151), the pages one tap at a time, then
## the options as big buttons with their requirement and chance written on
## them, and the origin label in a corner. One tap on an option shows it,
## the second sends ChooseOption; the result text and what changed follow.
## The screen only sends commands and reads the state (architecture §3.2).

## On the pixel grid (D-448): the fonts, the iron plate and the iron buttons
## of every other screen.
const STAGE_SIZE := Vector2(960, 540)
const ART_PATH: String = "res://assets/events/circle_%02d/event_%s.png"
## Without its own illustration, the circle's scenery, darkened.
const FALLBACK_PATH: String = "res://assets/environments/circles/circle_%02d/t1/env_circle_%02d_t1_back.png"
const FALLBACK_TINT := Color(0.45, 0.42, 0.45)
## The text plate in the lower third, over the darker band the story panels
## keep for it; the options stand inside it, on the right, so they never
## cover the illustration (D-448).
const BOX_RECT := Rect2(16, 392, 928, 132)
const TAB_SIZE := Vector2(170, 26)
const TEXT_MARGIN := Vector2(18, 16)
const OPTIONS_WIDTH: float = 330.0
const OPTION_HEIGHT: float = 30.0
const BUTTON_SIZE := Vector2(130, 30)
## The story is read in Jersey 10 at twice its size (a whole multiple, so it
## stays sharp); the options, the hint and the origin keep the size of every
## other button and panel, so three options with their chances fit.
const STORY_SIZE: int = PixelStyle.TEXT_SIZE * 2
const COLOR_BACKGROUND := PixelStyle.COLOR_PITCH
const COLOR_CHOSEN := Color(1.0, 0.9, 0.55)
## The narrator speaks in the grey of the lead; the souls and demons in bone.
const COLOR_NARRATOR := PixelStyle.COLOR_GREY

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
var _tab: Control
var _speaker: Label
var _text: Label
var _hint: Label
var _next_button: Button
var _options_box: VBoxContainer
var _option_buttons: Dictionary = {}
var _result_shown: bool = false
var _before: Dictionary = {}


func setup(p_data: GameData, p_ctrl: ExpeditionController, p_run: Callable = Callable()) -> void:
	data = p_data
	texts = EventTexts.new(p_data)
	ctrl = p_ctrl
	event = p_ctrl.event
	run = p_run if p_run.is_valid() else func(cmd: ExpeditionCommand) -> StringName: return ctrl.execute(cmd)


## A scene of pages only (`story`, T43): the Prologue and other scenes that
## run outside an expedition. No options; after the last page, Continuar
## leaves.
func setup_story(p_data: GameData, p_event: EventDef) -> void:
	data = p_data
	texts = EventTexts.new(p_data)
	ctrl = null
	event = p_event


func is_story() -> bool:
	return event != null and event.options.is_empty()


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
	if _result_shown or (is_story() and page_index >= page_count() - 1):
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
	return not is_story() and not _result_shown and page_index >= page_count() - 1


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
		_options_box.visible = false
		_show_line(EventTexts.NARRATOR, _result_text())
		_next_button.visible = true
		_next_button.text = texts.t(&"event_continue")
		_hint.text = ""
		return
	var page: Dictionary = event.pages[page_index] if page_count() > 0 else {}
	var at_options: bool = options_shown()
	_next_button.visible = not at_options
	var last_page: bool = is_story() and page_index >= page_count() - 1
	_next_button.text = texts.t(&"event_continue" if last_page else &"event_next")
	_options_box.visible = at_options
	_show_line(StringName(str(page.get("speaker", EventTexts.NARRATOR))), str(page.get("text_pt", "")))
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
	_text.add_theme_color_override("font_color", COLOR_NARRATOR if name_text == "" else PixelStyle.COLOR_BONE)
	# Beside the options the text keeps to the left part of the plate.
	var width: float = BOX_RECT.size.x - TEXT_MARGIN.x * 2.0
	if _options_box.visible:
		width -= OPTIONS_WIDTH + TEXT_MARGIN.x
	_text.size.x = width


func _build_options() -> void:
	if event.options.is_empty():
		return
	var ctx: EventContext = ctrl.event_context()
	for option: Dictionary in event.options:
		var id := StringName(str(option.get("id", "")))
		var label: String = str(option.get("text_pt", ""))
		var detail: String = texts.option_detail(option, ctx)
		if detail != "":
			label += "\n" + detail
		var button := _button(label, Vector2(OPTIONS_WIDTH, OPTION_HEIGHT))
		button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		button.disabled = ctrl.option_problem(id) != &""
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
	theme = PixelStyle.theme()
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
	_background = TextureRect.new()
	_background.texture = _art()
	_background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	_background.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_background.size = STAGE_SIZE
	_background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if not ResourceLoader.exists(ART_PATH % [event.circle, event.id]):
		_background.modulate = FALLBACK_TINT
	_stage.add_child(_background)
	_title = _label(event.title_pt, PixelStyle.BIG_TITLE_SIZE)
	PixelStyle.title(_title, PixelStyle.COLOR_BONE, PixelStyle.BIG_TITLE_SIZE)
	_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_title.position = Vector2(20, 12)
	_title.size = Vector2(600, 30)
	_stage.add_child(_title)
	_origin = _label(texts.origin(event.origin), PixelStyle.TEXT_SIZE)
	_origin.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_origin.position = Vector2(STAGE_SIZE.x - 320, 16)
	_origin.size = Vector2(300, 14)
	_origin.add_theme_color_override("font_color", PixelStyle.COLOR_GREY)
	_stage.add_child(_origin)
	_stage.add_child(PixelStyle.iron_plate(BOX_RECT))
	_tab = PixelStyle.iron_plate(Rect2(BOX_RECT.position + Vector2(18, -TAB_SIZE.y + 6), TAB_SIZE))
	_stage.add_child(_tab)
	_speaker = _label("", PixelStyle.TITLE_SIZE)
	PixelStyle.title(_speaker, PixelStyle.COLOR_AMBER)
	_speaker.size = TAB_SIZE
	_speaker.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_tab.add_child(_speaker)
	_text = _label("", STORY_SIZE)
	_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_text.position = BOX_RECT.position + TEXT_MARGIN
	_text.size = Vector2(BOX_RECT.size.x - TEXT_MARGIN.x * 2.0, BOX_RECT.size.y - 50)
	_stage.add_child(_text)
	_options_box = VBoxContainer.new()
	_options_box.position = Vector2(BOX_RECT.end.x - OPTIONS_WIDTH - TEXT_MARGIN.x, BOX_RECT.position.y + 12)
	_options_box.add_theme_constant_override("separation", 4)
	_stage.add_child(_options_box)
	_build_options()
	_hint = _label("", PixelStyle.TEXT_SIZE)
	_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_hint.position = Vector2(BOX_RECT.position.x + TEXT_MARGIN.x, BOX_RECT.end.y - 26)
	_hint.size = Vector2(500, 14)
	_hint.add_theme_color_override("font_color", PixelStyle.COLOR_GREY)
	_stage.add_child(_hint)
	_next_button = _button("", BUTTON_SIZE)
	_next_button.add_theme_font_size_override("font_size", STORY_SIZE)
	_next_button.position = BOX_RECT.end - BUTTON_SIZE - Vector2(14, 12)
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
