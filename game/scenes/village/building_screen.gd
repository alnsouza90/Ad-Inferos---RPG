class_name BuildingScreen
extends Control
## The inside of a village building (T49, D-500, D-501): Alan's interior,
## the guardian's portrait at the left, his line and the building's help in
## a plate, and the iron panel with what the building does. Every action
## goes through the campaign's rules (Village, Campaign); the screen only
## shows the answer.

## The player leaves the building, back to the village.
signal back_pressed
## The Gate: the company chosen leaves (in its order).
signal departed(party: Array[StringName])

const STAGE_SIZE := Vector2(960, 540)
const INTERIOR_PATH: String = "res://assets/pixel/environments/village/interiors/village_interior_%s.png"
const PORTRAIT_PATH: String = "res://assets/pixel/characters/guardians/guardian_%s.png"
## Guardian per building (prompts-guardioes-vila.md).
const GUARDIANS: Dictionary = {
	&"gate": &"christopher", &"pantry": &"elizabeth", &"infirmary": &"cosmas_damian",
	&"garden": &"francis", &"retreat_house": &"ignatius",
}
## The guardian, large at the left, from the waist up (D-499).
const PORTRAIT_SCALE: float = 1.5
const PORTRAIT_POS := Vector2(8, 156)
const SPEECH_RECT := Rect2(300, 24, 648, 114)
## The panel grows with its rows, so the interior shows below it.
const PANEL_RECT := Rect2(300, 146, 648, 330)
const PANEL_MIN_HEIGHT: float = 80.0
const BACK_RECT := Rect2(788, 490, 160, 34)
const ALMS_POS := Vector2(310, 494)
const BAND_HEIGHT: float = 16.0
const TITLE_SIZE: int = PixelStyle.TITLE_SIZE * 2
const TEXT_SIZE: int = PixelStyle.TEXT_SIZE * 2
const ROW_HEIGHT: float = 30.0
const ROW_BUTTON := Vector2(170, 28)
const LINE_TIGHTEN: int = -4

var data: GameData
var catalog: ExpeditionCatalog
var campaign: CampaignState
var building: StringName = &""
## The Gate: the company being chosen, in its order.
var party: Array[StringName] = []
## The Retreat House: the saint whose abilities are shown.
var chosen_saint: StringName = &""
var last_refusal: StringName = &""

var _stage: Control
var _rows: VBoxContainer
var _panel: NinePatchRect
var _alms: Label
var _warning: Label


func setup(p_data: GameData, p_catalog: ExpeditionCatalog, p_campaign: CampaignState, p_building: StringName) -> void:
	data = p_data
	catalog = p_catalog
	campaign = p_campaign
	building = p_building
	if building == &"gate":
		party = Village.suggestions(campaign, catalog)["party"]
		for id: StringName in Campaign.announce_arrivals(campaign):
			_arrivals.append(id)


var _arrivals: Array[StringName] = []


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_build()
	_center_stage()


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_center_stage()


# --- actions ----------------------------------------------------------------------

func buy(provision_id: StringName) -> StringName:
	return _answer(Village.buy(campaign, catalog, provision_id))


func give_back(provision_id: StringName) -> StringName:
	return _answer(Village.give_back(campaign, catalog, provision_id))


func pay_bed(saint_id: StringName) -> StringName:
	return _answer(Village.pay_bed(campaign, catalog, saint_id))


func toggle_garden(saint_id: StringName) -> StringName:
	return _answer(Village.toggle_garden(campaign, catalog, saint_id))


func choose_saint(saint_id: StringName) -> void:
	chosen_saint = saint_id
	_refresh()


func upgrade(ability_id: StringName) -> StringName:
	return _answer(Campaign.apply_upgrade(campaign, catalog, chosen_saint, ability_id))


## The Gate: puts a saint in the company (at the end) or takes it out.
func toggle_party(saint_id: StringName) -> void:
	if party.has(saint_id):
		party.erase(saint_id)
	elif party.size() < catalog.constants.get_int(&"party_size"):
		party.append(saint_id)
	_refresh()


func depart() -> StringName:
	var why: StringName = Campaign.party_refusal(campaign, catalog, party)
	if why == Campaign.OK:
		departed.emit(party.duplicate())
	return _answer(why)


func press_back() -> void:
	back_pressed.emit()


func rows_shown() -> Array[String]:
	var texts: Array[String] = []
	for row: Node in _rows.get_children():
		for child: Node in row.get_children():
			if child is Label:
				texts.append((child as Label).text)
	return texts


func warning_shown() -> String:
	return _warning.text


func _answer(why: StringName) -> StringName:
	last_refusal = why
	_warning.text = "" if why == &"" else data.ui.text(StringName("reason_%s" % why))
	_refresh()
	return why


# --- building --------------------------------------------------------------------

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
	_stage.clip_contents = true
	_stage.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_stage)
	var interior := _picture(INTERIOR_PATH % building, Vector2.ZERO, 1.0)
	if interior != null:
		interior.size = STAGE_SIZE
	var portrait := _picture(PORTRAIT_PATH % GUARDIANS.get(building, &""), PORTRAIT_POS, PORTRAIT_SCALE)
	if portrait != null:
		# Standing on the bottom edge.
		portrait.position.y = STAGE_SIZE.y - portrait.size.y
	_build_band()
	_build_speech()
	_panel = PixelStyle.iron_plate(PANEL_RECT)
	_stage.add_child(_panel)
	var scroll := VBoxContainer.new()
	scroll.position = PANEL_RECT.position + Vector2(16, 14)
	scroll.size = Vector2(PANEL_RECT.size.x - 32, 0)
	scroll.add_theme_constant_override("separation", 4)
	_stage.add_child(scroll)
	_rows = VBoxContainer.new()
	_rows.add_theme_constant_override("separation", 2)
	scroll.add_child(_rows)
	_warning = _wrapped("", PANEL_RECT.size.x - 32, PixelStyle.COLOR_BLOOD)
	scroll.add_child(_warning)
	_alms = _label("", TEXT_SIZE, PixelStyle.COLOR_BONE)
	_alms.position = ALMS_POS
	_stage.add_child(_alms)
	var back := Button.new()
	back.text = data.ui.text(&"building_back")
	back.add_theme_font_size_override("font_size", TEXT_SIZE)
	back.position = BACK_RECT.position
	back.size = BACK_RECT.size
	back.pressed.connect(press_back)
	_stage.add_child(back)
	_refresh()


func _build_band() -> void:
	var band := TextureRect.new()
	band.texture = PixelStyle.piece("ui_top_band")
	band.stretch_mode = TextureRect.STRETCH_TILE
	band.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	band.size = Vector2(STAGE_SIZE.x, BAND_HEIGHT)
	band.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(band)
	var title := _label(data.ui.text(StringName("building_%s" % building)), TITLE_SIZE, PixelStyle.COLOR_BONE)
	PixelStyle.title(title, PixelStyle.COLOR_BONE, TITLE_SIZE)
	title.position = Vector2(14, 18)
	_stage.add_child(title)


func _build_speech() -> void:
	_stage.add_child(PixelStyle.iron_plate(SPEECH_RECT))
	var column := VBoxContainer.new()
	column.position = SPEECH_RECT.position + Vector2(16, 8)
	column.size = Vector2(SPEECH_RECT.size.x - 32, 0)
	column.add_theme_constant_override("separation", 0)
	column.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(column)
	var name_label := _label(data.ui.text(StringName("guardian_%s" % building)), TITLE_SIZE, PixelStyle.COLOR_AMBER)
	PixelStyle.title(name_label, PixelStyle.COLOR_AMBER, TITLE_SIZE)
	column.add_child(name_label)
	column.add_child(_wrapped(data.ui.text(StringName("guardian_line_%s" % building)), SPEECH_RECT.size.x - 32, PixelStyle.COLOR_BONE))
	column.add_child(_wrapped(data.ui.text(StringName("guardian_help_%s" % building)), SPEECH_RECT.size.x - 32, PixelStyle.COLOR_GREY))


func _refresh() -> void:
	if _rows == null:
		return
	for child: Node in _rows.get_children():
		_rows.remove_child(child)
		child.queue_free()
	_alms.text = data.ui.text(&"village_alms", {"alms": campaign.alms})
	match building:
		&"pantry":
			_rows_pantry()
		&"infirmary":
			_rows_infirmary()
		&"garden":
			_rows_garden()
		&"retreat_house":
			_rows_retreat_house()
		&"gate":
			_rows_gate()
	var lines: int = _rows.get_child_count() + (1 if not _warning.text.is_empty() else 0)
	_panel.size.y = clampf(lines * (ROW_HEIGHT + 2.0) + 30.0, PANEL_MIN_HEIGHT, PANEL_RECT.size.y)


func _rows_pantry() -> void:
	_row(data.ui.text(&"pantry_pack", {"count": campaign.pantry_stock.size(), "of": Village.pack_capacity(campaign, catalog)}), "", Callable())
	for id: StringName in [&"bread", &"candle", &"holy_water", &"bandages", &"incense"]:
		var def: ProvisionDef = catalog.battle_catalog.provision(id)
		var owned: int = campaign.pantry_stock.count(id)
		var text: String = "%s  ×%d" % [def.name_pt, owned]
		var row := _row(text, data.ui.text(&"pantry_buy", {"name": "+", "price": Village.price(catalog, id)}), buy.bind(id))
		if owned > 0:
			var back := _button(data.ui.text(&"pantry_give_back"), give_back.bind(id))
			row.add_child(back)


func _rows_infirmary() -> void:
	var any: bool = false
	for id: StringName in campaign.unlocked_saints:
		var s: CampaignSaint = campaign.saints[id]
		if s.status.injury == SaintStatus.INJURY_NONE:
			continue
		any = true
		var injury: String = data.ui.text(&"injury_major" if s.status.injury == SaintStatus.INJURY_MAJOR else &"injury_minor")
		var text: String = "%s · %s" % [catalog.saint(id).name_pt, injury]
		if campaign.infirmary_beds.has(id):
			_row(text, data.ui.text(&"infirmary_in_bed"), Callable())
		else:
			_row(text, data.ui.text(&"infirmary_bed", {"cost": catalog.economy.get_int(&"infirmary_bed_cost")}), pay_bed.bind(id))
	if not any:
		_row(data.ui.text(&"infirmary_none"), "", Callable())


func _rows_garden() -> void:
	for id: StringName in campaign.unlocked_saints:
		var s: CampaignSaint = campaign.saints[id]
		var text: String = "%s · %s" % [catalog.saint(id).name_pt, data.ui.text(&"garden_desolation", {"value": s.status.desolation})]
		var resting: bool = campaign.garden_saints.has(id)
		_row(text, data.ui.text(&"garden_resting" if resting else &"garden_rest"), toggle_garden.bind(id))


func _rows_retreat_house() -> void:
	for id: StringName in campaign.unlocked_saints:
		var s: CampaignSaint = campaign.saints[id]
		var text: String = "%s · %s" % [catalog.saint(id).name_pt, data.ui.text(&"retreat_upgrades", {"level": s.level, "left": Campaign.upgrades_left(s, catalog)})]
		_row(text, "›", choose_saint.bind(id))
	if chosen_saint == &"":
		return
	var chosen: CampaignSaint = campaign.saints[chosen_saint]
	for ability_id: StringName in catalog.saint(chosen_saint).abilities:
		var ability: AbilityDef = catalog.battle_catalog.abilities[ability_id]
		if chosen.status.upgrades.has(ability_id):
			_row("   " + data.ui.text(&"retreat_upgraded", {"name": ability.name_pt}), "", Callable())
		else:
			_row("   " + ability.name_pt, "+", upgrade.bind(ability_id))


func _rows_gate() -> void:
	for id: StringName in _arrivals:
		_row(data.ui.text(&"gate_arrival", {"name": catalog.saint(id).name_pt}), "", Callable())
	_row(data.ui.text(&"gate_party"), data.ui.text(&"gate_depart"), depart)
	for i: int in party.size():
		_row("   " + data.ui.text(&"gate_slot", {"slot": i + 1, "name": catalog.saint(party[i]).name_pt}), "−", toggle_party.bind(party[i]))
	for id: StringName in campaign.unlocked_saints:
		if party.has(id):
			continue
		var s: CampaignSaint = campaign.saints[id]
		var note: String = ""
		if s.status.injury == SaintStatus.INJURY_MAJOR:
			note = " · " + data.ui.text(&"injury_major")
		elif campaign.garden_saints.has(id):
			note = " · " + data.ui.text(&"garden_resting")
		_row(catalog.saint(id).name_pt + note, "+", toggle_party.bind(id))


# --- small parts -----------------------------------------------------------------

func _row(text: String, action: String, on_press: Callable) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.custom_minimum_size.y = ROW_HEIGHT
	row.add_theme_constant_override("separation", 8)
	var label := _label(text, TEXT_SIZE, PixelStyle.COLOR_BONE)
	label.custom_minimum_size.x = PANEL_RECT.size.x - 32 - ROW_BUTTON.x - 8
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	row.add_child(label)
	if not action.is_empty() and on_press.is_valid():
		row.add_child(_button(action, on_press))
	elif not action.is_empty():
		row.add_child(_label(action, TEXT_SIZE, PixelStyle.COLOR_GREY))
	_rows.add_child(row)
	return row


func _button(text: String, on_press: Callable) -> Button:
	var button := Button.new()
	button.text = text
	button.add_theme_font_size_override("font_size", TEXT_SIZE)
	button.custom_minimum_size = Vector2(ROW_BUTTON.x * 0.5 if text.length() <= 2 else ROW_BUTTON.x * 0.5, ROW_BUTTON.y)
	button.pressed.connect(func() -> void: on_press.call())
	return button


func _picture(path: String, pos: Vector2, scale: float) -> TextureRect:
	if not ResourceLoader.exists(path):
		return null
	var texture: Texture2D = load(path) as Texture2D
	var picture := TextureRect.new()
	picture.texture = texture
	picture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	picture.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	picture.position = pos
	picture.size = texture.get_size() * scale
	picture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(picture)
	return picture


func _wrapped(text: String, width: float, color: Color) -> Label:
	var label := _label(text, TEXT_SIZE, color)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.custom_minimum_size.x = width
	label.add_theme_constant_override("line_spacing", LINE_TIGHTEN)
	return label


func _label(text: String, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
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
