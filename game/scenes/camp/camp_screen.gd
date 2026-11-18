class_name CampScreen
extends Control
## The camp (screens §5, expedition §6) and the Vigil (§7) on the pixel grid
## (D-429): the scenery in layers with a slow parallax, the animated fire in
## the ring of stones and the saints sitting around it, each in their own
## camp pose (`<id>_camp.png`, D-423) with the halo of their spiritual state
## (D-432). Touching a saint shows, in the panel below (the "chapel"), the
## saint's portrait, hit points, desolation and the activities they may take
## (Vigil, Share, Prayer, their own skill; Share and some skills ask whom).
## Fixed buttons: Rest (shows the cost of 1 Bread), Continue and Planned
## retreat, each confirmed by a second tap. After resting, the result shows
## what changed and the ambush roll. The screen only sends commands (Rest,
## LeaveCamp) and reads the state (architecture §3.2).

const STAGE_SIZE := Vector2(960, 540)
const FIELD_SIZE := Vector2(960, 360)
const ENV_PATH: String = "res://assets/pixel/environments/%s/env_%s_%s_%s.png"
const POSE_PATH: String = "res://assets/pixel/characters/%s/%s_camp.png"
const FIRE_PATH: String = "res://assets/pixel/vfx/camp_fire.png"
const HALO_PATH: String = "res://assets/pixel/vfx/halo_%s.png"
## The layers are drawn 2× (one pixel of the art is two of the screen) and
## pushed down so the ring of stones of each scene sits where the fire burns.
const LAYER_DROP: Dictionary = {&"camp": 74.0, &"vigil": 42.0}
## Parallax of the back, middle and front layers while the scene breathes.
const PARALLAX_BACK: float = 0.5
const PARALLAX_FRONT: float = 1.6
const SWAY_PIXELS: float = 6.0
const SWAY_SECONDS: float = 7.0
## Where the fire burns (its base, in each scene) and its frames.
const FIRE_BASE: Dictionary = {&"camp": Vector2(482, 322), &"vigil": Vector2(488, 332)}
const FIRE_FRAME: int = 64
const FIRE_FRAMES: int = 8
const FIRE_FPS: float = 9.0
## One pixel of the fire is one of the screen, like the saints (D-434).
const FIRE_SCALE: float = 1.0
## Rows of the fire frame below the logs (empty), so the logs rest on the ring.
const FIRE_FOOT_GAP: float = 6.0
## The saints breathe and the fire's light trembles on the side of each one
## that faces it (D-361): the breath stretches the pose this much, in this
## many seconds (each saint out of step); the light is an amber edge.
const BREATH_STRETCH: float = 0.012
const BREATH_SECONDS: float = 3.6
const FIRELIGHT := Color("E07B1F")
const FIRELIGHT_MIN: float = 0.45
const FIRELIGHT_MAX: float = 0.95
const FIGURE_SHADER_PATH: String = "res://shaders/halo.gdshader"
## Seats around the fire, in party order: feet (centre, bottom), mirrored to
## face the fire. The third sits further back, beyond the stones (D-432).
const SEATS: Array[Dictionary] = [
	{"feet": Vector2(232, 340), "mirror": false},
	{"feet": Vector2(668, 340), "mirror": true},
	{"feet": Vector2(392, 286), "mirror": false},
	{"feet": Vector2(120, 330), "mirror": false},
]
## Centre of the halo over each camp pose, in pixels of the pose (facing
## right); a saint without an entry gets one over the top of the pose.
const HALO_POINTS: Dictionary = {
	&"saint_george": Vector2(57, 13),
	&"saint_benedict": Vector2(66, 28),
	&"saint_therese": Vector2(82, 2),
}
const PANEL_TOP: float = 360.0
## The arch of the portrait in the card (as in the battle's panel).
const ARCH_POS := Vector2(6, 6)
## The activities right beside the portrait, centred on it (D-443); the
## name and state of the saint after them.
const GRID_X: float = 118.0
const NAME_X: float = 362.0
const ACTIVITY_SIZE := Vector2(116, 28)
const TARGET_SIZE := Vector2(116, 26)
const FIXED_SIZE := Vector2(136, 30)
const COLOR_CHOSEN := Color(1.0, 0.9, 0.55)
const COLOR_DIM := Color(0, 0, 0, 0.8)
const COLOR_UNSELECTED := Color(0.78, 0.74, 0.72)
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
## The saint whose card the panel shows (touched in the scene).
var selected: StringName = &""

var _stage: Control
var _scenery: ParallaxScenery
var _front: ParallaxScenery
var _fire: TextureRect
var _fire_glow: TextureRect
var _seats: Dictionary = {}
var _clock: float = 0.0
var _halo_settings: HaloSettings
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

## Touching a saint in the scene shows their card in the panel.
func select_saint(saint_id: StringName) -> void:
	if not _cards.has(saint_id):
		return
	selected = saint_id
	refresh()


func choose_activity(saint_id: StringName, activity: StringName) -> void:
	if not _can_plan():
		return
	armed = &""
	selected = saint_id
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
		_info.text = data.ui.text(&"camp_vigil_confirm" if is_vigil() else &"camp_confirm_rest")
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
		(_cards[saint_id]["root"] as Control).visible = saint_id == selected
		_refresh_seat(saint_id)
	var rest_button: Button = _fixed[FIXED_REST]
	rest_button.disabled = not _can_plan()
	for key: StringName in _fixed:
		(_fixed[key] as Button).modulate = COLOR_CHOSEN if key == armed else Color.WHITE
	if is_vigil() and armed == &"" and not _result.visible and _info.text == "":
		_info.text = data.ui.text(&"camp_vigil_info")
	elif ctrl.state.camp_rested and armed == &"" and not _result.visible and not is_vigil():
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


## The halo shown over a sitting saint ("disk", "covered", "eclipse"; with
## "rays" and the clearing in Consolation), for the tests.
func halo_of(saint_id: StringName) -> StringName:
	var seat: Dictionary = _seats.get(saint_id, {})
	return seat.get("halo_kind", &"") if not seat.is_empty() else &""


func seat_rect(saint_id: StringName) -> Rect2:
	var seat: Dictionary = _seats.get(saint_id, {})
	return (seat["button"] as Control).get_rect() if not seat.is_empty() else Rect2()


# --- flow ------------------------------------------------------------------------

func _can_plan() -> bool:
	if is_vigil():
		return true
	return ctrl.phase == ExpeditionController.Phase.AT_CAMP and not ctrl.state.camp_rested


## The Vigil before the boss (expedition §7): the same screen, only Vigil
## and Share, no Bread, no ambush, no way back.
func is_vigil() -> bool:
	return ctrl.phase == ExpeditionController.Phase.AT_VIGIL


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


## "Seguir" names the next leg when there is one (T42).
func _continue_text() -> String:
	if ctrl.state.leg < ExpeditionController.LAST_LEG and ctrl.has_full_circle():
		return data.ui.text(&"camp_continue_leg", {"leg": ctrl.state.leg + 1})
	return data.ui.text(&"camp_continue")


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
	lines.append(t.text(&"camp_vigil_after" if ctrl.phase == ExpeditionController.Phase.IN_BATTLE and ctrl.battle.state.encounter_type == &"boss" else _ambush_key()))
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


## The sitting saint: brighter when chosen, and the halo of their state
## (Art Bible §4.3, D-432): disk; covered from desolation 75 on; eclipse in
## the Dark Night; disk with rays and the clearing on the ground in
## Consolation.
func _refresh_seat(saint_id: StringName) -> void:
	var seat: Dictionary = _seats.get(saint_id, {})
	if seat.is_empty():
		return
	(seat["pose"] as CanvasItem).modulate = Color.WHITE if saint_id == selected else COLOR_UNSELECTED
	var status: SaintStatus = ctrl.saints[saint_id]
	var kind: StringName = &"disk"
	if status.spirit_state == Desolation.DARK_NIGHT:
		kind = &"eclipse"
	elif status.spirit_state != Desolation.CONSOLATION and status.desolation >= _halo_settings.fade_start:
		kind = &"covered"
	seat["halo_kind"] = kind
	(seat["halo"] as TextureRect).texture = _texture(HALO_PATH % kind)
	var consolation: bool = status.spirit_state == Desolation.CONSOLATION
	(seat["rays"] as CanvasItem).visible = consolation
	(seat["clearing"] as CanvasItem).visible = consolation


func _process(delta: float) -> void:
	if _scenery == null:
		return
	_clock += delta
	# The scene breathes: the far and near layers drift against each other.
	var sway: float = roundf(sin(_clock * TAU / SWAY_SECONDS) * SWAY_PIXELS)
	_scenery.set_shift(sway)
	_front.set_shift(sway)
	if _fire != null:
		var frame: int = int(_clock * FIRE_FPS) % FIRE_FRAMES
		(_fire.texture as AtlasTexture).region = Rect2(frame * FIRE_FRAME, 0, FIRE_FRAME, FIRE_FRAME)
	if _fire_glow != null:
		_fire_glow.modulate.a = 0.55 + 0.08 * sin(_clock * 11.0) + 0.05 * sin(_clock * 23.0)
	for id: StringName in _seats:
		var seat: Dictionary = _seats[id]
		var breath: float = (sin((_clock + float(seat["phase"])) * TAU / BREATH_SECONDS) + 1.0) * 0.5
		(seat["pose"] as Control).scale = Vector2(1.0, 1.0 + BREATH_STRETCH * breath)
		# The same flicker as the glow of the fire, so they move together.
		var flicker: float = clampf(0.5 + 0.3 * sin(_clock * 11.0) + 0.2 * sin(_clock * 23.0 + float(seat["phase"])), 0.0, 1.0)
		(seat["light"] as ShaderMaterial).set_shader_parameter("rim_color", Color(FIRELIGHT, lerpf(FIRELIGHT_MIN, FIRELIGHT_MAX, flicker)))
		var rays: CanvasItem = _seats[id]["rays"]
		if rays.visible:
			(rays as Control).rotation += delta * _halo_settings.rays_spin_speed


func _center_stage() -> void:
	if _stage != null:
		_stage.position = ((_screen_size() - STAGE_SIZE) * 0.5).floor()


## Never centre on a zero size (the T17 phone bug, lessons.md).
func _screen_size() -> Vector2:
	if size.x > 0.0 and size.y > 0.0:
		return size
	return get_viewport_rect().size if is_inside_tree() else STAGE_SIZE


func _texture(path: String) -> Texture2D:
	return load(path) as Texture2D if ResourceLoader.exists(path) else null


func _layer(part: String) -> String:
	var circle: String = String(ctrl.state.circle)
	return ENV_PATH % [circle, circle, _scene(), part]


func _scene() -> StringName:
	return &"vigil" if is_vigil() else &"camp"


func _fire_base() -> Vector2:
	return FIRE_BASE[_scene()]


func _build() -> void:
	theme = PixelStyle.theme()
	clip_contents = true
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_halo_settings = load("res://scenes/battle/halo_settings_pixel.tres") as HaloSettings
	var background := ColorRect.new()
	background.color = PixelStyle.COLOR_PITCH
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)
	_stage = Control.new()
	_stage.size = STAGE_SIZE
	_stage.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_stage)
	_build_field()
	_build_panel()
	_build_result()
	if not ctrl.state.party.is_empty():
		selected = ctrl.state.party[0]


func _build_field() -> void:
	var field := Control.new()
	field.size = FIELD_SIZE
	field.clip_contents = true
	field.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(field)
	_scenery = ParallaxScenery.new()
	_scenery.size = FIELD_SIZE
	_scenery.drop = LAYER_DROP[_scene()]
	_scenery.setup([{"path": _layer("back"), "parallax": PARALLAX_BACK}, {"path": _layer("mid"), "parallax": 1.0}])
	field.add_child(_scenery)
	_fire_glow = TextureRect.new()
	_fire_glow.texture = SpellEffect.glow_texture()
	_fire_glow.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_fire_glow.size = Vector2(220, 160)
	_fire_glow.position = _fire_base() - Vector2(110, 110)
	_fire_glow.modulate = Color(1.0, 0.55, 0.15, 0.55)
	_fire_glow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var glow_mat := CanvasItemMaterial.new()
	glow_mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	_fire_glow.material = glow_mat
	field.add_child(_fire_glow)
	for i: int in ctrl.state.party.size():
		_build_seat(field, ctrl.state.party[i], SEATS[mini(i, SEATS.size() - 1)])
	var sheet: Texture2D = _texture(FIRE_PATH)
	if sheet != null:
		var atlas := AtlasTexture.new()
		atlas.atlas = sheet
		atlas.region = Rect2(0, 0, FIRE_FRAME, FIRE_FRAME)
		_fire = TextureRect.new()
		_fire.texture = atlas
		_fire.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		_fire.size = Vector2(FIRE_FRAME, FIRE_FRAME) * FIRE_SCALE
		_fire.position = (_fire_base() - Vector2(FIRE_FRAME * FIRE_SCALE * 0.5, (FIRE_FRAME - FIRE_FOOT_GAP) * FIRE_SCALE)).round()
		_fire.mouse_filter = Control.MOUSE_FILTER_IGNORE
		field.add_child(_fire)
	field.add_child(_embers())
	_front = ParallaxScenery.new()
	_front.size = FIELD_SIZE
	_front.drop = LAYER_DROP[_scene()]
	_front.setup([{"path": _layer("front"), "parallax": PARALLAX_FRONT}])
	field.add_child(_front)
	var bar := ColorRect.new()
	bar.color = Color(0, 0, 0, 0.55)
	bar.size = Vector2(FIELD_SIZE.x, 18)
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	field.add_child(bar)
	var title := _label(data.ui.text(&"camp_vigil_title" if is_vigil() else &"node_camp"))
	PixelStyle.title(title)
	title.position = Vector2(8, 1)
	field.add_child(title)
	_light = _label("")
	_light.position = Vector2(140, 3)
	field.add_child(_light)
	_alms = _label("")
	_alms.position = Vector2(300, 3)
	field.add_child(_alms)
	_bread = _label("")
	_bread.position = Vector2(860, 3)
	field.add_child(_bread)


## A few embers rising from the fire (the fire is drawn; these move).
func _embers() -> CPUParticles2D:
	var embers := CPUParticles2D.new()
	embers.position = _fire_base() - Vector2(0, 30)
	embers.amount = 10
	embers.lifetime = 1.6
	embers.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	embers.emission_rect_extents = Vector2(10, 3)
	embers.direction = Vector2(0, -1)
	embers.spread = 18.0
	embers.gravity = Vector2(0, -12)
	embers.initial_velocity_min = 16.0
	embers.initial_velocity_max = 30.0
	embers.scale_amount_min = 1.0
	embers.scale_amount_max = 1.0
	embers.color = PixelStyle.COLOR_AMBER
	var fade := Gradient.new()
	fade.set_color(0, Color(1, 1, 1, 1))
	fade.set_color(1, Color(1, 1, 1, 0))
	embers.color_ramp = fade
	return embers


func _build_seat(field: Control, saint_id: StringName, seat: Dictionary) -> void:
	var tex: Texture2D = _texture(POSE_PATH % [saint_id, saint_id])
	var pose_size: Vector2 = tex.get_size() if tex != null else Vector2(80, 120)
	var mirror: bool = seat["mirror"]
	var feet: Vector2 = seat["feet"]
	var top_left := Vector2(roundf(feet.x - pose_size.x * 0.5), feet.y - pose_size.y)
	var clearing := TextureRect.new()
	clearing.texture = _texture(HALO_PATH % "clearing")
	clearing.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if clearing.texture != null:
		clearing.position = Vector2(roundf(feet.x - clearing.texture.get_width() * 0.5), feet.y - clearing.texture.get_height() + 4)
	field.add_child(clearing)
	var pose := TextureRect.new()
	pose.texture = tex
	pose.flip_h = mirror
	pose.position = top_left
	pose.size = pose_size
	pose.mouse_filter = Control.MOUSE_FILTER_IGNORE
	# Breathing from the ground up; the fire lights the side facing it.
	pose.pivot_offset = Vector2(pose_size.x * 0.5, pose_size.y)
	var light := ShaderMaterial.new()
	light.shader = load(FIGURE_SHADER_PATH)
	var fire_on_right: bool = _fire_base().x > feet.x
	# rim_side is where the light falls, in the texture: a mirrored pose is
	# flipped, so its side swaps.
	light.set_shader_parameter("rim_side", (1.0 if fire_on_right else -1.0) * (-1.0 if mirror else 1.0))
	light.set_shader_parameter("rim_color", Color(FIRELIGHT, FIRELIGHT_MIN))
	pose.material = light
	field.add_child(pose)
	var point: Vector2 = HALO_POINTS.get(saint_id, Vector2(pose_size.x * 0.5, 6.0))
	if mirror:
		point.x = pose_size.x - point.x
	var center: Vector2 = top_left + point
	var rays := TextureRect.new()
	rays.texture = _halo_settings.rays
	rays.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if rays.texture != null:
		rays.size = rays.texture.get_size()
		rays.pivot_offset = rays.size * 0.5
		rays.position = (center - rays.size * 0.5).round()
	field.add_child(rays)
	var halo := TextureRect.new()
	halo.mouse_filter = Control.MOUSE_FILTER_IGNORE
	halo.texture = _texture(HALO_PATH % "disk")
	if halo.texture != null:
		halo.position = (center - halo.texture.get_size() * 0.5).round()
	field.add_child(halo)
	# Halo behind the head: the pose is drawn again on top of it.
	field.move_child(halo, pose.get_index())
	field.move_child(rays, halo.get_index())
	var button := Button.new()
	button.flat = true
	button.focus_mode = Control.FOCUS_NONE
	button.position = top_left
	button.size = pose_size
	button.add_theme_stylebox_override("normal", StyleBoxEmpty.new())
	button.add_theme_stylebox_override("hover", StyleBoxEmpty.new())
	button.add_theme_stylebox_override("pressed", StyleBoxEmpty.new())
	button.pressed.connect(select_saint.bind(saint_id))
	field.add_child(button)
	_seats[saint_id] = {"pose": pose, "halo": halo, "rays": rays, "clearing": clearing, "button": button, "halo_kind": &"disk", "light": light, "phase": float(_seats.size()) * 1.3}


func _build_panel() -> void:
	_stage.add_child(PixelStyle.stone_panel(Rect2(0, PANEL_TOP, STAGE_SIZE.x, STAGE_SIZE.y - PANEL_TOP)))
	for saint_id: StringName in ctrl.state.party:
		_build_card(saint_id)
	_info = _label("")
	_info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_info.position = Vector2(540, PANEL_TOP + 12)
	_info.size = Vector2(410, 90)
	_stage.add_child(_info)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 4)
	row.position = Vector2(536, STAGE_SIZE.y - FIXED_SIZE.y - 10)
	_stage.add_child(row)
	var rest: String = data.ui.text(&"camp_vigil_rest") if is_vigil() else data.ui.text(&"camp_rest", {"cost": data.ui.text(&"camp_rest_cost")})
	for entry: Array in [[FIXED_REST, rest, press_rest], [FIXED_CONTINUE, _continue_text(), press_continue], [FIXED_RETREAT, data.ui.text(&"camp_retreat"), press_retreat]]:
		var button := _button(str(entry[1]), FIXED_SIZE)
		button.pressed.connect(entry[2] as Callable)
		button.visible = entry[0] == FIXED_REST or not is_vigil()
		row.add_child(button)
		_fixed[entry[0]] = button


## The chapel below: one card per saint, only the chosen one shown.
func _build_card(saint_id: StringName) -> void:
	var root := Control.new()
	root.position = Vector2(0, PANEL_TOP)
	root.size = Vector2(540, STAGE_SIZE.y - PANEL_TOP)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(root)
	var arch := TextureRect.new()
	arch.texture = PixelStyle.piece("ui_portrait_arch")
	arch.position = ARCH_POS
	arch.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(arch)
	# The same portrait as in the battle, always in the arch (D-442).
	var portrait := TextureRect.new()
	portrait.texture = BattleScreen.saint_portrait(saint_id)
	portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	portrait.size = BattleScreen.PORTRAIT_WINDOW.size
	portrait.position = ARCH_POS + BattleScreen.PORTRAIT_WINDOW.position
	portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(portrait)
	var name_label := _label(_saint_name(saint_id))
	PixelStyle.title(name_label)
	name_label.position = Vector2(NAME_X, 44)
	root.add_child(name_label)
	var stats := _label("")
	stats.position = Vector2(NAME_X, 62)
	root.add_child(stats)
	var choice := _label("")
	choice.position = Vector2(NAME_X, 112)
	choice.add_theme_color_override("font_color", COLOR_CHOSEN)
	root.add_child(choice)
	var grid := GridContainer.new()
	grid.columns = 2
	grid.position = Vector2(GRID_X, ARCH_POS.y + 85.0 - (ACTIVITY_SIZE.y * 2.0 + 4.0) * 0.5)
	grid.add_theme_constant_override("h_separation", 4)
	grid.add_theme_constant_override("v_separation", 4)
	root.add_child(grid)
	var buttons: Dictionary = {}
	for activity: StringName in ACTIVITIES:
		if activity == ExpeditionController.ACTIVITY_OWN and _skill(saint_id) == null:
			continue
		if is_vigil() and activity != ExpeditionController.ACTIVITY_VIGIL and activity != ExpeditionController.ACTIVITY_SHARE:
			continue
		var button := _button(_activity_name(saint_id, activity), ACTIVITY_SIZE)
		button.pressed.connect(choose_activity.bind(saint_id, activity))
		grid.add_child(button)
		buttons[activity] = button
	var targets := HBoxContainer.new()
	targets.position = Vector2(GRID_X, ARCH_POS.y + 85.0 + ACTIVITY_SIZE.y + 10.0)
	targets.add_theme_constant_override("separation", 4)
	targets.visible = false
	root.add_child(targets)
	for other: StringName in ctrl.state.party:
		if other == saint_id:
			continue
		var target_button := _button(_saint_name(other), TARGET_SIZE)
		target_button.set_meta(&"saint", other)
		target_button.pressed.connect(choose_target.bind(saint_id, other))
		targets.add_child(target_button)
	_cards[saint_id] = {"root": root, "stats": stats, "choice": choice, "activities": buttons, "targets": targets, "portrait": portrait}


func _build_result() -> void:
	_result = Control.new()
	_result.size = STAGE_SIZE
	_result.visible = false
	_stage.add_child(_result)
	var dim := ColorRect.new()
	dim.color = COLOR_DIM
	dim.size = STAGE_SIZE
	_result.add_child(dim)
	_result_text = _label("")
	_result_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_result_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_result_text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_result_text.position = Vector2(130, 100)
	_result_text.size = Vector2(700, 280)
	_result.add_child(_result_text)
	var button := _button(data.ui.text(&"event_next"), FIXED_SIZE)
	button.position = Vector2((STAGE_SIZE.x - FIXED_SIZE.x) * 0.5, 410)
	button.pressed.connect(press_result_continue)
	_result.add_child(button)


func _label(text: String) -> Label:
	var label := Label.new()
	label.text = text
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return label


func _button(text: String, button_size: Vector2) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = button_size
	button.size = button_size
	button.focus_mode = Control.FOCUS_NONE
	button.clip_text = true
	return button
