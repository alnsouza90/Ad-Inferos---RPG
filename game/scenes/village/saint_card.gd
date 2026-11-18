class_name SaintCard
extends Control
## The saint's card (D-464, T50): the same panel for the new saint, for the
## saint's portrait in the village and for the choice of the company. The
## portrait in the arch, the name, the feast, the life in a few lines and the
## sheet of play (attributes, trait, abilities, miracle). Where each fact
## comes from stays in the Martyrology, never here (D-465).
##
## Pure presentation: every text comes from the data (`ui_text.csv`,
## `saints.csv`, `abilities.csv`, `traits.csv`).

## Emitted when the player closes the card.
signal closed

const STAGE_SIZE := Vector2(960, 540)
const PLATE_RECT := Rect2(8, 8, 944, 524)
## The arch of the portrait three times its size, as tall as the card.
const ARCH_SCALE: float = 3.0
const ARCH_POS := Vector2(28, 16)
## The column of the texts, right of the arch.
const COLUMN_X: float = 362.0
const COLUMN_WIDTH: float = 568.0
## The name a size above the headings (Jacquard 12 at three times).
const NAME_SIZE: int = PixelStyle.TITLE_SIZE * 3
const BODY_SIZE: int = PixelStyle.TEXT_SIZE * 2
const SMALL_SIZE: int = PixelStyle.TEXT_SIZE * 2
const BUTTON_SIZE := Vector2(130, 30)
## Wrapped lines sit closer than the font's own spacing, so the longest
## sheet (Anthony's) fits the card.
const LINE_TIGHTEN: int = -4
const PAGE_KEYS: Array[String] = ["saint_card_page_life", "saint_card_page_abilities"]
const TAB_SIZE := Vector2(150, 28)
## Where the pages start, under the name, the feast and the tabs.
const PAGE_TOP: float = 108.0
## Space between two abilities on their page.
const ABILITY_GAP: int = 3
## The part of each portrait that fills the window of the arch, so that every
## face shows the same size (D-467: Therese is smaller in her picture). Each
## region keeps the window's proportion (60:96). A saint without one shows
## the whole picture, covered.
const FACE_REGIONS: Dictionary = {
	&"saint_george": Rect2(20, 0, 160, 256),
	&"saint_benedict": Rect2(18, 0, 160, 256),
	&"saint_therese": Rect2(34, 14, 130, 208),
	&"saint_anthony_abbot": Rect2(14, 0, 160, 256),
}

var data: GameData
var saint: SaintDef

var _stage: Control
var _portrait: TextureRect
var _name: Label
var _feast: Label
var _bio: Label
var _stats: Label
var _trait: RichTextLabel
var _abilities: Array[RichTextLabel] = []
var _miracle: RichTextLabel
var _tabs: Array[Button] = []
var _pages: Array[VBoxContainer] = []
var page_index: int = 0


func setup(p_data: GameData, saint_id: StringName) -> void:
	data = p_data
	saint = data.saints[saint_id]


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_build()
	_center_stage()


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_center_stage()


func press_close() -> void:
	closed.emit()


func name_shown() -> String:
	return _name.text


func feast_shown() -> String:
	return _feast.text


func bio_shown() -> String:
	return _bio.text


func stats_shown() -> String:
	return _stats.text


func trait_shown() -> String:
	return _trait.get_parsed_text()


func abilities_shown() -> Array[String]:
	var shown: Array[String] = []
	for line: RichTextLabel in _abilities:
		shown.append(line.get_parsed_text())
	return shown


func miracle_shown() -> String:
	return _miracle.get_parsed_text()


## The bottom of the lowest page, in the card's coordinates.
func column_bottom() -> float:
	var bottom: float = 0.0
	for page: VBoxContainer in _pages:
		var last: Control = page.get_child(page.get_child_count() - 1)
		bottom = maxf(bottom, last.get_global_rect().end.y - _stage.global_position.y)
	return bottom


func portrait_texture() -> Texture2D:
	return _portrait.texture


## The texts of the card, from the data; a missing text shows its key, so the
## data test finds it.
func _text(key: String, args: Dictionary = {}) -> String:
	return data.ui.text(StringName(key), args)


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
	_build_column()
	var close := Button.new()
	close.text = _text("saint_card_close")
	close.add_theme_font_size_override("font_size", BODY_SIZE)
	close.size = BUTTON_SIZE
	# Top right, beside the name: the sheet runs to the foot of the card.
	close.position = Vector2(PLATE_RECT.end.x - BUTTON_SIZE.x - 18, PLATE_RECT.position.y + 14)
	close.pressed.connect(press_close)
	_stage.add_child(close)


func _build_portrait() -> void:
	var arch_texture: Texture2D = PixelStyle.piece("ui_portrait_arch")
	var arch := TextureRect.new()
	arch.texture = arch_texture
	arch.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	arch.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	arch.position = ARCH_POS
	arch.size = arch_texture.get_size() * ARCH_SCALE
	arch.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(arch)
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


func _build_column() -> void:
	var head := VBoxContainer.new()
	head.position = Vector2(COLUMN_X, 14)
	head.size = Vector2(COLUMN_WIDTH, 0)
	head.add_theme_constant_override("separation", 0)
	head.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(head)
	_name = _label(saint.name_pt, NAME_SIZE)
	PixelStyle.title(_name, PixelStyle.COLOR_BONE, NAME_SIZE)
	head.add_child(_name)
	var feast_key: String = "saint_feast_%s" % saint.id
	_feast = _label(_text("saint_card_feast", {"date": _text(feast_key)}) if data.ui.has_text(StringName(feast_key)) else "", BODY_SIZE)
	_feast.add_theme_color_override("font_color", PixelStyle.COLOR_GOLD)
	head.add_child(_feast)
	# Two pages in the same panel (D-475): the rule line of each ability
	# leaves no room for the life on the same page.
	var tabs := HBoxContainer.new()
	tabs.add_theme_constant_override("separation", 8)
	head.add_child(tabs)
	for i: int in PAGE_KEYS.size():
		var tab := Button.new()
		tab.text = _text(PAGE_KEYS[i])
		tab.toggle_mode = true
		tab.add_theme_font_size_override("font_size", BODY_SIZE)
		# The chosen page in bone, never gold (gold is for grace, D-293).
		tab.add_theme_color_override("font_pressed_color", PixelStyle.COLOR_BONE)
		tab.add_theme_color_override("font_hover_pressed_color", PixelStyle.COLOR_BONE)
		tab.add_theme_color_override("font_color", PixelStyle.COLOR_GREY)
		tab.custom_minimum_size = TAB_SIZE
		tab.pressed.connect(show_page.bind(i))
		tabs.add_child(tab)
		_tabs.append(tab)
	_pages.append(_page_life())
	_pages.append(_page_abilities())
	show_page(0)


func _new_page() -> VBoxContainer:
	var page := VBoxContainer.new()
	page.position = Vector2(COLUMN_X, PAGE_TOP)
	page.size = Vector2(COLUMN_WIDTH, 0)
	page.add_theme_constant_override("separation", 0)
	page.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(page)
	return page


func _page_life() -> VBoxContainer:
	var page := _new_page()
	page.add_child(_heading("saint_card_life"))
	_bio = _label(_text("saint_bio_%s" % saint.id), BODY_SIZE)
	_bio.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_bio.add_theme_constant_override("line_spacing", LINE_TIGHTEN)
	_bio.custom_minimum_size.x = COLUMN_WIDTH
	page.add_child(_bio)
	page.add_child(_heading("saint_card_sheet"))
	_stats = _label("   ".join([
		_text("stat_max_hp", {"value": saint.max_hp}),
		_text("stat_armor", {"value": saint.armor}),
		_text("stat_faith", {"value": saint.faith}),
		_text("stat_will", {"value": saint.will}),
	]), BODY_SIZE)
	page.add_child(_stats)
	_trait = _entry(_text("saint_card_trait") + ": " + saint.trait_def.name_pt, saint.trait_def.desc_pt)
	page.add_child(_trait)
	return page


## Each ability: its name and cost, the rule line from the data (D-475), and
## the line of the story in grey.
func _page_abilities() -> VBoxContainer:
	var page := _new_page()
	page.add_theme_constant_override("separation", ABILITY_GAP)
	for ability_id: StringName in saint.abilities:
		var line := _ability_entry(data.catalog.abilities[ability_id], "")
		_abilities.append(line)
		page.add_child(line)
	_miracle = _ability_entry(data.catalog.abilities[saint.miracle], _text("saint_card_miracle") + ": ", PixelStyle.COLOR_GOLD)
	page.add_child(_miracle)
	return page


func _ability_entry(ability: AbilityDef, prefix: String, color: Color = PixelStyle.COLOR_AMBER) -> RichTextLabel:
	var line := _rich()
	line.text = "[color=#%s]%s[/color]  %s\n[color=#%s]%s[/color]" % [
		color.to_html(false), _escape(prefix + _ability_name(ability)),
		_escape(AbilityRule.line(ability, data.ui, data.catalog)),
		PixelStyle.COLOR_GREY.to_html(false), _escape(ability.desc_pt),
	]
	return line


## Shows page `index` (0: the life and the sheet; 1: the abilities).
func show_page(index: int) -> void:
	for i: int in _pages.size():
		_pages[i].visible = i == index
		_tabs[i].button_pressed = i == index
	page_index = index


func _ability_name(ability: AbilityDef) -> String:
	if ability.cost <= 0:
		return ability.name_pt
	return "%s (%s)" % [ability.name_pt, _text("cost_badge", {"cost": ability.cost})]


func _heading(key: String) -> Label:
	var heading := _label(_text(key), PixelStyle.TITLE_SIZE * 2)
	PixelStyle.title(heading, PixelStyle.COLOR_AMBER, PixelStyle.TITLE_SIZE * 2)
	return heading


## One line of the sheet: the name in colour, then what it does.
func _entry(title_text: String, desc: String, color: Color = PixelStyle.COLOR_AMBER) -> RichTextLabel:
	var line := _rich()
	line.text = "[color=#%s]%s[/color]  %s" % [color.to_html(false), _escape(title_text), _escape(desc)]
	return line


func _rich() -> RichTextLabel:
	var line := RichTextLabel.new()
	line.bbcode_enabled = true
	line.fit_content = true
	line.scroll_active = false
	line.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	line.custom_minimum_size.x = COLUMN_WIDTH
	line.add_theme_font_size_override("normal_font_size", SMALL_SIZE)
	line.add_theme_constant_override("line_separation", LINE_TIGHTEN)
	line.add_theme_color_override("default_color", PixelStyle.COLOR_BONE)
	line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return line


static func _escape(text: String) -> String:
	return text.replace("[", "[lb]")


func _label(text: String, font_size: int) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", font_size)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return label


func _center_stage() -> void:
	if _stage != null:
		_stage.position = ((_screen_size() - STAGE_SIZE) * 0.5).floor()


## Never centre on a zero size (the T17 phone bug, lessons.md).
func _screen_size() -> Vector2:
	if size.x > 0.0 and size.y > 0.0:
		return size
	return get_viewport_rect().size if is_inside_tree() else STAGE_SIZE
