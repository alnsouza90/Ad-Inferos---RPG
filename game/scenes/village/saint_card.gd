class_name SaintCard
extends Control
## The saint's sheet (D-464, model B approved in D-477): the same panel for
## the new saint, for the saint's portrait in the village and for the choice
## of the company at the Gate. The portrait in the arch; the name, the
## epithet and the roles; two pages: "A vida" (feast and life) and "Ficha"
## (the stained glass of the abilities, the rose of the miracle, position and
## target, attributes, the camp activity and the relics). Touching a stained
## glass shows it; touching it again takes it into battle or leaves it in the
## village (D-477). Where each fact comes from stays in the Martyrology
## (D-465).
##
## Pure presentation: every text comes from the data, and the rule of the
## loadout from core (`AbilityLoadout`).

## Emitted when the player closes the card with a valid loadout.
signal closed
## Emitted when the abilities taken into battle change.
signal loadout_changed(equipped: Array[StringName])

const STAGE_SIZE := Vector2(960, 540)
const PLATE_RECT := Rect2(8, 8, 944, 524)
## The arch of the portrait three times its size, as tall as the card.
const ARCH_SCALE: float = 3.0
const ARCH_POS := Vector2(28, 16)
## The column of the texts, right of the arch.
const COLUMN_X: float = 362.0
const COLUMN_WIDTH: float = 568.0
const NAME_SIZE: int = PixelStyle.TITLE_SIZE * 3
const BODY_SIZE: int = PixelStyle.TEXT_SIZE * 2
const HEADING_SIZE: int = PixelStyle.TITLE_SIZE * 2
const BUTTON_SIZE := Vector2(120, 28)
const TAB_SIZE := Vector2(120, 28)
const TABS_POS := Vector2(COLUMN_X, 104)
## Wrapped lines sit closer than the font's own spacing.
const LINE_TIGHTEN: int = -4
const PAGE_LIFE: int = 0
const PAGE_SHEET: int = 1
const PAGE_KEYS: Array[String] = ["saint_card_page_life", "saint_card_page_sheet"]
const PAGE_TOP: float = 142.0
## The count of abilities taken and the hint, right of the tabs.
const COUNT_POS := Vector2(620, 56)
const COUNT_WIDTH: float = 316.0
## The stained glass of the abilities, a little smaller than in battle.
const LANCET_SCALE: float = 0.8
const LANCET_GAP: float = 6.0
const LANCET_SIZE := Vector2(64, 153)
## The detail of the chosen ability, under the stained glass.
const DETAIL_POS := Vector2(COLUMN_X, 272)
const DETAIL_WIDTH: float = 400.0
## Position (the company's three places) and target (the enemy's four).
const DOTS_POS := Vector2(790, 302)
const DOTS_GAP: float = 46.0
const DOT_STEP: float = 30.0
const DOT_SCALE: float = 0.8
const DOT_OFF := Color(0.35, 0.33, 0.38)
const COMPANY_SLOTS: int = 3
const ENEMY_SLOTS: int = 4
## The three iron boxes at the foot: attributes, camp, relic.
const BOXES_TOP: float = 384.0
const BOXES_HEIGHT: float = 140.0
const BOX_STATS := Rect2(352, BOXES_TOP, 186, BOXES_HEIGHT)
const BOX_CAMP := Rect2(546, BOXES_TOP, 196, BOXES_HEIGHT)
const BOX_RELIC := Rect2(750, BOXES_TOP, 192, BOXES_HEIGHT)
## The tile frames of the relic slots, smaller so two fit in the box.
const RELIC_FRAME_SCALE: float = 0.75
const RELIC_FRAME_SIZE := Vector2(59, 53) * RELIC_FRAME_SCALE
## The light inside a lit oculus.
const DOT_LIGHT := Rect2(8, 8, 11, 11)
const RELIC_ICON_PATH: String = "res://assets/pixel/icons/icon_%s.png"
## Where a 32x32 relic icon sits inside the tile frame.
const RELIC_ICON_INSET := Vector2(10, 8)
const RELIC_ICON_SCALE: float = 0.75
## The stamp of the saint, faint behind the name (D-449).
const STAMP_PATH: String = "res://assets/pixel/vfx/stamp_%s.png"
const STAMP_POS := Vector2(590, 4)
const STAMP_TINT := Color(0.85, 0.75, 0.5, 0.10)
const ENEMY_TARGETINGS: Array[StringName] = [&"enemy", &"enemy_group", &"all_enemies"]
## The part of each portrait that fills the window of the arch, so that every
## face shows the same size (D-467: Therese is smaller in her picture). Each
## region keeps the window's proportion (60:96).
const FACE_REGIONS: Dictionary = {
	&"saint_george": Rect2(20, 0, 160, 256),
	&"saint_benedict": Rect2(18, 0, 160, 256),
	&"saint_therese": Rect2(34, 14, 130, 208),
	&"saint_anthony_abbot": Rect2(14, 0, 160, 256),
}

var data: GameData
var saint: SaintDef
## The abilities taken into battle, in the order of the saint's list.
var equipped: Array[StringName] = []
## The relics the saint carries (RelicDef), and its level for the second slot.
var relics: Array = []
var level: int = 1
## False where the loadout cannot change (during an expedition).
var editable: bool = true
var page_index: int = PAGE_LIFE
## The ability shown in the detail (an id of the list, or the miracle).
var selected: StringName = &""

var _stage: Control
var _portrait: TextureRect
var _name: Label
var _epithet: Label
var _feast: Label
var _bio: Label
var _tabs: Array[Button] = []
var _pages: Array[Control] = []
var _lancets: Dictionary = {}
var _count: Label
var _trait_name: Label
var _trait_desc: Label
var _warning: Label
var _detail_name: Label
var _detail_rule: Label
var _detail_story: Label
var _position_dots: Array[TextureRect] = []
var _target_dots: Array[TextureRect] = []
var _stats: Array[Label] = []
var _camp_name: Label
var _relic_names: Array[Label] = []


func setup(p_data: GameData, saint_id: StringName, p_equipped: Array[StringName] = [], p_relics: Array = [], p_level: int = 1) -> void:
	data = p_data
	saint = data.saints[saint_id]
	equipped = p_equipped.duplicate() if not p_equipped.is_empty() else saint.default_equipped.duplicate()
	relics = p_relics
	level = p_level
	selected = equipped[0] if not equipped.is_empty() else saint.abilities[0]


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_build()
	_center_stage()


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_center_stage()


## Closes the card, unless the abilities chosen cannot go into battle.
func press_close() -> void:
	var why: StringName = loadout_refusal()
	if why != AbilityLoadout.OK:
		_warn(why)
		return
	closed.emit()


## First touch shows the stained glass; a second touch takes it into battle
## or leaves it in the village (D-477).
func tap_ability(ability_id: StringName) -> void:
	if selected != ability_id:
		selected = ability_id
		_warning.text = ""
		_refresh()
		return
	if not editable or ability_id == saint.miracle:
		return
	var why: StringName = AbilityLoadout.add_refusal(saint, equipped, ability_id, data.catalog.constants)
	if not equipped.has(ability_id) and why != AbilityLoadout.OK:
		_warn(why)
		return
	equipped = AbilityLoadout.toggle(saint, equipped, ability_id, data.catalog.constants)
	_warning.text = ""
	_refresh()
	loadout_changed.emit(equipped)


func loadout_refusal() -> StringName:
	return AbilityLoadout.refusal(saint, equipped, data.catalog.abilities, data.catalog.constants)


## Shows page `index` (PAGE_LIFE or PAGE_SHEET).
func show_page(index: int) -> void:
	page_index = index
	for i: int in _pages.size():
		_pages[i].visible = i == index
		_tabs[i].button_pressed = i == index


func name_shown() -> String:
	return _name.text


func epithet_shown() -> String:
	return _epithet.text


func feast_shown() -> String:
	return _feast.text


func bio_shown() -> String:
	return _bio.text


func stats_shown() -> String:
	return "\n".join(_stats.map(func(l: Label) -> String: return l.text))


func detail_shown() -> String:
	return "%s\n%s\n%s" % [_detail_name.text, _detail_rule.text, _detail_story.text]


func trait_shown() -> String:
	return "%s %s" % [_trait_name.text, _trait_desc.text]


func camp_shown() -> String:
	return _camp_name.text


func relics_shown() -> Array[String]:
	var shown: Array[String] = []
	for l: Label in _relic_names:
		shown.append(l.text)
	return shown


func warning_shown() -> String:
	return _warning.text


## The state each stained glass shows: "chosen", "on" (taken) or "off".
func lancet_state(ability_id: StringName) -> String:
	if ability_id == selected:
		return "chosen"
	return "on" if equipped.has(ability_id) else "off"


func lit_positions() -> Array[int]:
	return _lit(_position_dots)


func lit_targets() -> Array[int]:
	return _lit(_target_dots)


func portrait_texture() -> Texture2D:
	return _portrait.texture


## The bottom of the life text, in the card's coordinates.
func column_bottom() -> float:
	return _bio.get_global_rect().end.y - _stage.global_position.y


func _text(key: String, args: Dictionary = {}) -> String:
	return data.ui.text(StringName(key), args)


func _warn(why: StringName) -> void:
	_warning.text = _text("reason_%s" % why, {"count": data.catalog.constants.get_int(&"equipped_abilities")})


func _build() -> void:
	theme = PixelStyle.theme()
	clip_contents = true
	var background := ColorRect.new()
	background.color = PixelStyle.COLOR_PITCH
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)
	_stage = Control.new()
	_stage.size = STAGE_SIZE
	_stage.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_stage)
	_stage.add_child(PixelStyle.iron_plate(PLATE_RECT))
	_build_portrait()
	_build_head()
	_pages.append(_page_life())
	_pages.append(_page_sheet())
	var close := _button(_text("saint_card_close"), BUTTON_SIZE)
	close.position = Vector2(PLATE_RECT.end.x - BUTTON_SIZE.x - 18, PLATE_RECT.position.y + 10)
	close.pressed.connect(press_close)
	_stage.add_child(close)
	show_page(PAGE_LIFE)
	_refresh()


func _build_portrait() -> void:
	_stage.add_child(_picture(PixelStyle.piece("ui_portrait_arch"), ARCH_POS, ARCH_SCALE))
	# The same portrait as everywhere (D-442), in the window of the arch.
	_portrait = TextureRect.new()
	_portrait.texture = _face(saint.id)
	_portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	_portrait.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_portrait.position = ARCH_POS + BattleScreen.PORTRAIT_WINDOW.position * ARCH_SCALE
	_portrait.size = BattleScreen.PORTRAIT_WINDOW.size * ARCH_SCALE
	_portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(_portrait)


## The portrait cut around the face (FACE_REGIONS), or the whole picture.
static func _face(saint_id: StringName) -> Texture2D:
	var whole: Texture2D = BattleScreen.saint_portrait(saint_id)
	if whole == null or not FACE_REGIONS.has(saint_id):
		return whole
	var cut := AtlasTexture.new()
	cut.atlas = whole
	cut.region = FACE_REGIONS[saint_id]
	return cut


func _build_head() -> void:
	var stamp_path: String = STAMP_PATH % saint.id
	if ResourceLoader.exists(stamp_path):
		var stamp := _picture(load(stamp_path) as Texture2D, STAMP_POS, 1.0)
		stamp.modulate = STAMP_TINT
		_stage.add_child(stamp)
	_name = _label(saint.name_pt, NAME_SIZE)
	PixelStyle.title(_name, PixelStyle.COLOR_BONE, NAME_SIZE)
	_name.position = Vector2(COLUMN_X, 12)
	_stage.add_child(_name)
	_epithet = _label(_optional("saint_epithet_%s" % saint.id), BODY_SIZE)
	_epithet.add_theme_color_override("font_color", PixelStyle.COLOR_AMBER)
	_epithet.position = Vector2(COLUMN_X, 56)
	_stage.add_child(_epithet)
	var roles := _label(_optional("saint_roles_%s" % saint.id), BODY_SIZE)
	roles.add_theme_color_override("font_color", PixelStyle.COLOR_GREY)
	roles.position = Vector2(COLUMN_X, 76)
	_stage.add_child(roles)
	for i: int in PAGE_KEYS.size():
		var tab := _button(_text(PAGE_KEYS[i]), TAB_SIZE)
		tab.toggle_mode = true
		# The chosen page in bone, never gold (gold is for grace, D-293).
		tab.add_theme_color_override("font_pressed_color", PixelStyle.COLOR_BONE)
		tab.add_theme_color_override("font_hover_pressed_color", PixelStyle.COLOR_BONE)
		tab.add_theme_color_override("font_color", PixelStyle.COLOR_GREY)
		tab.position = TABS_POS + Vector2(i * (TAB_SIZE.x + 8), 0)
		tab.pressed.connect(show_page.bind(i))
		_stage.add_child(tab)
		_tabs.append(tab)


func _optional(key: String) -> String:
	return _text(key) if data.ui.has_text(StringName(key)) else ""


func _new_page() -> Control:
	var page := Control.new()
	page.size = STAGE_SIZE
	page.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(page)
	return page


func _page_life() -> Control:
	var page := _new_page()
	var column := _box_at(Vector2(COLUMN_X, PAGE_TOP), COLUMN_WIDTH, page)
	var feast_key: String = "saint_feast_%s" % saint.id
	_feast = _label(_text("saint_card_feast", {"date": _text(feast_key)}) if data.ui.has_text(StringName(feast_key)) else "", BODY_SIZE)
	_feast.add_theme_color_override("font_color", PixelStyle.COLOR_GOLD)
	column.add_child(_feast)
	_bio = _wrapped(_text("saint_bio_%s" % saint.id), COLUMN_WIDTH, PixelStyle.COLOR_BONE)
	column.add_child(_bio)
	return page


func _page_sheet() -> Control:
	var page := _new_page()
	var x: float = COLUMN_X
	for ability_id: StringName in saint.abilities:
		var glass := TextureButton.new()
		glass.ignore_texture_size = true
		glass.stretch_mode = TextureButton.STRETCH_SCALE
		glass.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		glass.size = LANCET_SIZE * LANCET_SCALE
		glass.position = Vector2(x, PAGE_TOP)
		glass.pressed.connect(tap_ability.bind(ability_id))
		page.add_child(glass)
		_lancets[ability_id] = glass
		x += LANCET_SIZE.x * LANCET_SCALE + LANCET_GAP
	var rose := TextureButton.new()
	# A saint without its own rose yet keeps the plain one, as in battle.
	var rose_art: Texture2D = AbilityIcon.rose(saint.id, "on")
	rose.texture_normal = rose_art if rose_art != null else PixelStyle.piece("ui_rose_on")
	rose.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	rose.position = Vector2(x + 2, PAGE_TOP + 22)
	rose.pressed.connect(tap_ability.bind(saint.miracle))
	page.add_child(rose)
	var side_x: float = x + 92
	# The trait beside the rose: it is part of the saint's play (D-464).
	var side_width: float = PLATE_RECT.end.x - side_x - 12
	var side := _box_at(Vector2(side_x, PAGE_TOP - 8), side_width, page)
	_trait_name = _wrapped(_text("saint_card_trait") + ": " + saint.trait_def.name_pt, side_width, PixelStyle.COLOR_AMBER)
	side.add_child(_trait_name)
	_trait_desc = _wrapped(saint.trait_def.desc_pt, side_width, PixelStyle.COLOR_BONE)
	side.add_child(_trait_desc)
	# How many go into battle, and how to change it, right of the tabs.
	var count_box := _box_at(COUNT_POS, COUNT_WIDTH, page)
	_count = _label("", BODY_SIZE)
	_count.add_theme_color_override("font_color", PixelStyle.COLOR_BONE)
	_count.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	count_box.add_child(_count)
	var hint := _wrapped(_text("saint_card_tap_hint"), COUNT_WIDTH, PixelStyle.COLOR_GREY)
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	count_box.add_child(hint)
	var detail := _box_at(DETAIL_POS, DETAIL_WIDTH, page)
	_detail_name = _label("", BODY_SIZE)
	_detail_rule = _wrapped("", DETAIL_WIDTH, PixelStyle.COLOR_BONE)
	_detail_story = _wrapped("", DETAIL_WIDTH, PixelStyle.COLOR_GREY)
	_warning = _wrapped("", DETAIL_WIDTH, PixelStyle.COLOR_BLOOD)
	for part: Control in [_detail_name, _detail_rule, _detail_story, _warning]:
		detail.add_child(part)
	_position_dots = _dots(page, DOTS_POS, COMPANY_SLOTS, "saint_card_position")
	_target_dots = _dots(page, DOTS_POS + Vector2(0, DOTS_GAP), ENEMY_SLOTS, "saint_card_target")
	_build_boxes(page)
	return page


func _build_boxes(page: Control) -> void:
	_box(page, BOX_STATS, "saint_card_stats")
	var stats := _box_at(BOX_STATS.position + Vector2(20, 34), BOX_STATS.size.x - 40, page)
	for line: String in [
		_text("stat_max_hp", {"value": saint.max_hp}),
		_text("stat_armor", {"value": saint.armor}),
		_text("stat_faith", {"value": saint.faith}),
		_text("stat_will", {"value": saint.will}),
	]:
		var l := _label(line, BODY_SIZE)
		stats.add_child(l)
		_stats.append(l)
	_box(page, BOX_CAMP, "saint_card_camp")
	var camp := _box_at(BOX_CAMP.position + Vector2(14, 34), BOX_CAMP.size.x - 28, page)
	_camp_name = _label(saint.camp_skill.name_pt, BODY_SIZE)
	_camp_name.add_theme_color_override("font_color", PixelStyle.COLOR_AMBER)
	camp.add_child(_camp_name)
	camp.add_child(_wrapped(saint.camp_skill.desc_pt, BOX_CAMP.size.x - 28, PixelStyle.COLOR_BONE))
	_box(page, BOX_RELIC, "saint_card_relic")
	_build_relic_slots(page)


## One slot per relic space; the second stays closed until its level (D-477).
func _build_relic_slots(page: Control) -> void:
	var constants: ConstantsDef = data.catalog.constants
	var open_slots: int = constants.get_int(&"relic_slots_start")
	if level >= constants.get_int(&"relic_second_slot_level"):
		open_slots = constants.get_int(&"relic_slots_max")
	var text_width: float = BOX_RELIC.size.x - RELIC_FRAME_SIZE.x - 30
	for i: int in constants.get_int(&"relic_slots_max"):
		var y: float = BOX_RELIC.position.y + 36 + i * (RELIC_FRAME_SIZE.y + 6)
		var frame := _picture(PixelStyle.piece("ui_tile_frame"), Vector2(BOX_RELIC.position.x + 14, y), RELIC_FRAME_SCALE)
		page.add_child(frame)
		var text: String = _text("saint_card_relic_none")
		var color: Color = PixelStyle.COLOR_GREY
		if i >= open_slots:
			frame.modulate = DOT_OFF
			text = _text("saint_card_relic_locked", {"level": constants.get_int(&"relic_second_slot_level")})
		elif i < relics.size():
			var relic: RelicDef = relics[i]
			text = relic.name_pt
			color = PixelStyle.COLOR_BONE
			var icon_path: String = RELIC_ICON_PATH % relic.id
			if ResourceLoader.exists(icon_path):
				page.add_child(_picture(load(icon_path) as Texture2D, frame.position + RELIC_ICON_INSET, RELIC_ICON_SCALE))
		var holder := _box_at(Vector2(frame.position.x + RELIC_FRAME_SIZE.x + 8, y + 6), text_width, page)
		var name_label := _wrapped(text, text_width, color)
		holder.add_child(name_label)
		_relic_names.append(name_label)


func _refresh() -> void:
	for ability_id: StringName in _lancets:
		var glass: TextureButton = _lancets[ability_id]
		var def: AbilityDef = data.catalog.abilities[ability_id]
		glass.texture_normal = AbilityIcon.lancet(AbilityIcon.of(def), lancet_state(ability_id))
	_count.text = _text("saint_card_in_battle", {"count": equipped.size(), "total": data.catalog.constants.get_int(&"equipped_abilities")})
	var ability: AbilityDef = data.catalog.abilities[selected]
	var is_miracle: bool = selected == saint.miracle
	var title: String = ability.name_pt
	if is_miracle:
		title = _text("saint_card_miracle") + ": " + title
	if ability.cost > 0:
		title += "  (%s)" % _text("cost_badge", {"cost": ability.cost})
	_detail_name.text = title
	_detail_name.add_theme_color_override("font_color", PixelStyle.COLOR_GOLD if is_miracle else PixelStyle.COLOR_AMBER)
	_detail_rule.text = AbilityRule.line(ability, data.ui, data.catalog)
	_detail_story.text = ability.desc_pt
	_light(_position_dots, ability.use_slots, PixelStyle.COLOR_BONE)
	var targets: Array[int] = []
	if ability.targeting == &"all_enemies":
		for i: int in ENEMY_SLOTS:
			targets.append(i + 1)
	elif ENEMY_TARGETINGS.has(ability.targeting):
		targets = ability.target_slots
	_light(_target_dots, targets, PixelStyle.COLOR_BLOOD)


func _dots(page: Control, pos: Vector2, count: int, title_key: String) -> Array[TextureRect]:
	var title := _label(_text(title_key), BODY_SIZE)
	title.add_theme_color_override("font_color", PixelStyle.COLOR_GREY)
	title.position = pos + Vector2(0, -22)
	page.add_child(title)
	var dots: Array[TextureRect] = []
	for i: int in count:
		var dot := _picture(PixelStyle.piece("ui_oculus"), pos + Vector2(i * DOT_STEP, 0), DOT_SCALE)
		page.add_child(dot)
		# The oculus is dark glass; a lit one shows a light in its middle.
		var light := ColorRect.new()
		light.position = DOT_LIGHT.position
		light.size = DOT_LIGHT.size
		light.mouse_filter = Control.MOUSE_FILTER_IGNORE
		dot.add_child(light)
		dots.append(dot)
	return dots


## Lights the oculi of `slots` (1-based) in `color`.
func _light(dots: Array[TextureRect], slots: Array[int], color: Color) -> void:
	for i: int in dots.size():
		var on: bool = slots.has(i + 1)
		var light: ColorRect = dots[i].get_child(0)
		light.color = color
		light.visible = on
		dots[i].modulate = Color.WHITE if on else DOT_OFF
		dots[i].set_meta(&"lit", on)


func _lit(dots: Array[TextureRect]) -> Array[int]:
	var lit: Array[int] = []
	for i: int in dots.size():
		if bool(dots[i].get_meta(&"lit", false)):
			lit.append(i + 1)
	return lit


func _box(page: Control, rect: Rect2, title_key: String) -> void:
	page.add_child(PixelStyle.iron_plate(rect))
	var title := _label(_text(title_key), HEADING_SIZE)
	PixelStyle.title(title, PixelStyle.COLOR_AMBER, HEADING_SIZE)
	title.position = rect.position + Vector2(0, 2)
	title.size.x = rect.size.x
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	page.add_child(title)


## A column at `pos` for texts (a Label wraps only inside a container).
func _box_at(pos: Vector2, width: float, parent: Control) -> VBoxContainer:
	var box := VBoxContainer.new()
	box.position = pos
	box.size = Vector2(width, 0)
	box.add_theme_constant_override("separation", 0)
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(box)
	return box


func _wrapped(text: String, width: float, color: Color) -> Label:
	var label := _label(text, BODY_SIZE)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.custom_minimum_size.x = width
	label.add_theme_constant_override("line_spacing", LINE_TIGHTEN)
	label.add_theme_color_override("font_color", color)
	return label


func _picture(texture: Texture2D, pos: Vector2, scale: float) -> TextureRect:
	var picture := TextureRect.new()
	picture.texture = texture
	picture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	picture.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	picture.position = pos
	picture.size = texture.get_size() * scale
	picture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return picture


func _label(text: String, font_size: int) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", font_size)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return label


func _button(text: String, button_size: Vector2) -> Button:
	var button := Button.new()
	button.text = text
	button.add_theme_font_size_override("font_size", BODY_SIZE)
	button.custom_minimum_size = button_size
	button.size = button_size
	return button


func _center_stage() -> void:
	if _stage != null:
		_stage.position = ((_screen_size() - STAGE_SIZE) * 0.5).floor()


## Never centre on a zero size (the T17 phone bug, lessons.md).
func _screen_size() -> Vector2:
	if size.x > 0.0 and size.y > 0.0:
		return size
	return get_viewport_rect().size if is_inside_tree() else STAGE_SIZE
