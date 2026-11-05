class_name RigPreviewScreen
extends Control
## Test screen of the 2D skeleton (T35): São Jorge big on the stage and one
## button per motion, so Alan can judge the animation on the phone. Dev
## builds only (reached from the arena).

const STAGE_SIZE := Vector2(1920, 1080)
const COLOR_BACKGROUND := Color(0.11, 0.09, 0.11)
const COLOR_GROUND := Color(0.2, 0.17, 0.18)
const ART_PATH: String = "res://scenes/battle/combatants/saint_george_art.tres"
## Figure height on this screen, in stage pixels (about half the stage, like
## the reference images of docs/art/reference/).
const FIGURE_HEIGHT: float = 560.0
const GROUND_Y: float = 900.0
## Height of the figures cut by tools/art/rig_cut.py (asset-pipeline §4).
const RIG_FIGURE_HEIGHT: float = 1200.0
const BUTTON_SIZE := Vector2(250, 90)

signal back_requested

var data: GameData
var figure: RigFigure
var _stage: Control


func setup(p_data: GameData) -> void:
	data = p_data


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	if data == null:
		data = GameData.load_all()
	_build()
	_center_stage()


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_center_stage()


## Plays one motion (also called by the tests).
func play(motion: StringName) -> float:
	figure.rest()
	return figure.play(motion)


func press_back() -> void:
	back_requested.emit()


func _build() -> void:
	var ui_theme := Theme.new()
	ui_theme.default_font_size = 28
	theme = ui_theme
	var background := ColorRect.new()
	background.color = COLOR_BACKGROUND
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)
	_stage = Control.new()
	_stage.size = STAGE_SIZE
	_stage.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_stage)
	var ground := ColorRect.new()
	ground.color = COLOR_GROUND
	ground.position = Vector2(0, GROUND_Y)
	ground.size = Vector2(STAGE_SIZE.x, STAGE_SIZE.y - GROUND_Y)
	ground.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(ground)
	var title := Label.new()
	title.text = data.ui.text(&"rig_title")
	title.add_theme_font_size_override("font_size", 44)
	title.position = Vector2(60, 40)
	_stage.add_child(title)
	var art: CombatantArt = load(ART_PATH)
	figure = RigFigure.new()
	figure.setup(art.rig)
	var s: float = FIGURE_HEIGHT / RIG_FIGURE_HEIGHT
	figure.scale = Vector2(s, s)
	figure.position = Vector2(STAGE_SIZE.x * 0.38, GROUND_Y)
	_stage.add_child(figure)
	figure.play(RigMotions.IDLE)
	var box := GridContainer.new()
	box.columns = 2
	box.position = Vector2(STAGE_SIZE.x - 2 * BUTTON_SIZE.x - 100, 150)
	box.add_theme_constant_override("h_separation", 20)
	box.add_theme_constant_override("v_separation", 20)
	_stage.add_child(box)
	for motion: StringName in RigMotions.names():
		var button := Button.new()
		button.text = data.ui.text(StringName("rig_%s" % motion))
		button.custom_minimum_size = BUTTON_SIZE
		button.pressed.connect(play.bind(motion))
		box.add_child(button)
	var back := Button.new()
	back.text = data.ui.text(&"rig_back")
	back.custom_minimum_size = BUTTON_SIZE
	back.pressed.connect(press_back)
	box.add_child(back)


func _center_stage() -> void:
	if _stage == null:
		return
	var area: Vector2 = size if size.x > 0.0 and size.y > 0.0 else (get_viewport_rect().size if is_inside_tree() else STAGE_SIZE)
	_stage.position = ((area - STAGE_SIZE) * 0.5).floor()
