class_name BuildingScreen
extends Control
## The inside of a village building (T49, D-500, D-501, D-503), laid out as
## the buildings of Darkest Dungeon: Alan's interior, the guardian large at
## the left with his line, the iron board in the middle with the places of
## the building (the company, the pantry and the pack, the beds, the places
## of the Garden, the abilities), and the saints stacked at the right. The
## player taps a place and a saint, in either order. Every action goes
## through the campaign's rules (Village, Campaign); the screen only shows
## the answer.

## The player leaves the building, back to the village.
signal back_pressed
## The Gate: the company chosen leaves (in its order).
signal departed(party: Array[StringName])

const STAGE_SIZE := Vector2(960, 540)
const INTERIOR_PATH: String = "res://assets/pixel/environments/village/interiors/village_interior_%s.png"
const PORTRAIT_PATH: String = "res://assets/pixel/characters/guardians/guardian_%s.png"
const ICON_PATH: String = "res://assets/pixel/icons/icon_item_%s.png"
## Guardian per building (prompts-guardioes-vila.md).
const GUARDIANS: Dictionary = {
	&"gate": &"christopher", &"pantry": &"elizabeth", &"infirmary": &"cosmas_damian",
	&"garden": &"francis", &"retreat_house": &"ignatius",
}
## What the Pantry sells, in the order of the shelf.
const PROVISIONS: Array[StringName] = [&"bread", &"candle", &"holy_water", &"bandages", &"incense"]
## Props on the walls of an interior (D-516): the Christ Child's painting
## on the Gate's right tower, above the packs, by the torch. Iconography
## only (art-direction): it never speaks, acts or gives a bonus.
const PROP_PATH: String = "res://assets/pixel/environments/village/props/%s.png"
const PROPS: Dictionary = {
	&"gate": [{"file": "gate_painting", "at": Vector2(586, 30)}],
}
## The building's name and crest: a tap closes or opens the panels (D-517).
const TOGGLE_RECT := Rect2(8, 18, 276, 64)
## The guardian, large at the left, from the waist up (D-499).
const PORTRAIT_SCALE: float = 1.5
const HALO_PATH: String = "res://assets/pixel/vfx/guardian_halo.png"
## Alan's halo (D-506), drawn at 130 pixels: shown at its own size.
const HALO_SCALE: float = 1.0
## The centre of each guardian's head, in pixels of his portrait (two for
## Cosmas and Damian).
const HALO_HEADS: Dictionary = {
	&"gate": [Vector2(98, 26)],
	&"pantry": [Vector2(88, 38)],
	&"infirmary": [Vector2(72, 34), Vector2(140, 48)],
	&"garden": [Vector2(92, 34)],
	&"retreat_house": [Vector2(80, 26)],
}
## How much of the guardian's lower edge the ledge hides.
const PORTRAIT_CUT: float = 84.0
## The interior a little darker, so the board and the cards read first.
const INTERIOR_SHADE := Color(0.62, 0.6, 0.62)
const HEADER_WIDTH: float = 276.0
const BOARD_RECT := Rect2(292, 22, 428, 456)
const ROSTER_POS := Vector2(730, 22)
const BOTTOM_Y: float = 484.0
const BACK_RECT := Rect2(790, 494, 160, 36)
const DEPART_RECT := Rect2(410, 484, 192, 56)
const ALMS_POS := Vector2(296, 496)
const BAND_HEIGHT: float = 16.0
const TITLE_SIZE: int = PixelStyle.TITLE_SIZE * 2
const TEXT_SIZE: int = PixelStyle.TEXT_SIZE * 2
const LINE_TIGHTEN: int = -4
## The places of the board.
const TILE := Vector2(60, 56)
const BIG_TILE := Vector2(96, 90)
## The bed and the bench are drawn at 64 × 64.
const PLACE_PIECE: float = 64.0
const CREST_SIZE := Vector2(64, 64)
const CREST_PATH: String = "res://assets/pixel/icons/crest_%s.png"
const CELL_GAP: float = 12.0
const ARCH_GAP: float = 18.0
const LANCET_SCALE: float = 0.62
const LANCET_SIZE := Vector2(64, 153)
## A saint who cannot go down: its head darker, still known.
const BLOCKED_TINT := Color(0.45, 0.42, 0.45)
## The reserve of the Gate: room for every saint of the game, and more.
const RESERVE_COLUMNS: int = 6
const RESERVE_ROWS: int = 2
const RESERVE_CELL := Vector2(65, 74)
const RESERVE_TILE := Vector2(52, 52)

var data: GameData
var catalog: ExpeditionCatalog
var campaign: CampaignState
var building: StringName = &""
## The Gate: the company by position (1 to 3); an empty place is &"".
var party: Array[StringName] = []
## The place tapped first, waiting for a saint (-1 when none).
var selected_slot: int = -1
## The saint tapped first, waiting for a place (&"" when none).
var selected_saint: StringName = &""
## The Retreat House: the saint and the ability shown.
var chosen_saint: StringName = &""
var chosen_ability: StringName = &""
var last_refusal: StringName = &""

var _stage: Control
var _board: Control
var _roster: SaintRoster
var _alms: Label
var _status: Label
var _arrivals: Array[StringName] = []
## The interior and its props, under the interface.
var _scenery: Array[CanvasItem] = []
var _toggle: Button
var _board_plate: NinePatchRect
var _card: SaintCard
## False while the panels are closed (D-517).
var interface_shown: bool = true
## The saint whose card is open (&"" when none).
var card_saint: StringName = &""


func setup(p_data: GameData, p_catalog: ExpeditionCatalog, p_campaign: CampaignState, p_building: StringName) -> void:
	data = p_data
	catalog = p_catalog
	campaign = p_campaign
	building = p_building
	if building == &"gate":
		party.resize(catalog.constants.get_int(&"party_size"))
		party.fill(&"")
		var suggested: Array = Village.suggestions(campaign, catalog)["party"]
		for i: int in suggested.size():
			party[i] = suggested[i]
		_arrivals = Campaign.announce_arrivals(campaign)


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_build()
	_center_stage()


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_center_stage()


# --- taps ----------------------------------------------------------------------

## A saint tapped in the stack or in the reserve.
func tap_saint(saint_id: StringName) -> StringName:
	match building:
		&"gate":
			if selected_slot >= 0:
				return _place_in_party(selected_slot, saint_id)
			var free: int = party.find(&"")
			if free >= 0 and not party.has(saint_id):
				return _place_in_party(free, saint_id)
			return _select_saint(saint_id)
		&"infirmary", &"garden":
			if selected_slot >= 0:
				return _care(saint_id)
			return _select_saint(saint_id)
		&"retreat_house":
			choose_saint(saint_id)
	return &""


## A place of the board tapped: a position of the company, a bed, a place of
## the Garden.
func tap_slot(index: int) -> StringName:
	match building:
		&"gate":
			if selected_saint != &"":
				return _place_in_party(index, selected_saint)
			if selected_slot == index and party[index] != &"":
				party[index] = &""
				selected_slot = -1
				return _answer(&"")
		&"infirmary":
			if index >= campaign.infirmary_beds.size() and selected_saint != &"":
				return _care(selected_saint)
		&"garden":
			if index < campaign.garden_saints.size():
				return toggle_garden(campaign.garden_saints[index])
			if selected_saint != &"":
				return _care(selected_saint)
	selected_slot = -1 if selected_slot == index else index
	return _answer(&"")


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
	chosen_ability = &""
	_answer(&"")


func choose_ability(ability_id: StringName) -> void:
	chosen_ability = ability_id
	_answer(&"")


func upgrade(ability_id: StringName) -> StringName:
	return _answer(Campaign.apply_upgrade(campaign, catalog, chosen_saint, ability_id))


## The Gate: puts a saint in the first empty position, or takes it out.
func toggle_party(saint_id: StringName) -> void:
	var at: int = party.find(saint_id)
	if at >= 0:
		party[at] = &""
		_answer(&"")
	elif party.has(&""):
		_place_in_party(party.find(&""), saint_id)


## The company in its order, without the empty positions.
func party_ids() -> Array[StringName]:
	var ids: Array[StringName] = []
	for id: StringName in party:
		if id != &"":
			ids.append(id)
	return ids


func depart() -> StringName:
	var chosen: Array[StringName] = party_ids()
	var why: StringName = Campaign.party_refusal(campaign, catalog, chosen)
	if why == Campaign.OK:
		departed.emit(chosen)
	return _answer(why)


func press_back() -> void:
	back_pressed.emit()


## The line at the foot of the board: a refusal, a news, or what to do.
func warning_shown() -> String:
	return _status.text


func _place_in_party(index: int, saint_id: StringName) -> StringName:
	var why: StringName = Campaign.saint_refusal(campaign, saint_id)
	if why != Campaign.OK:
		return _answer(why)
	var was: int = party.find(saint_id)
	if was >= 0:
		party[was] = party[index]
	party[index] = saint_id
	selected_slot = -1
	selected_saint = &""
	return _answer(&"")


func _care(saint_id: StringName) -> StringName:
	selected_slot = -1
	selected_saint = &""
	if building == &"infirmary":
		return pay_bed(saint_id)
	return toggle_garden(saint_id)


func _select_saint(saint_id: StringName) -> StringName:
	selected_saint = &"" if selected_saint == saint_id else saint_id
	return _answer(&"")


func _answer(why: StringName) -> StringName:
	last_refusal = why
	_refresh()
	if _status != null and why != &"":
		_status.text = data.ui.text(StringName("reason_%s" % why))
		_status.add_theme_color_override("font_color", PixelStyle.COLOR_BLOOD)
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
		_scenery.append(interior)
	# Props hung on the interior's wall (D-516: the Christ Child's painting
	# at the Gate, D-501).
	for prop: Dictionary in PROPS.get(building, []):
		var hung := _picture(PROP_PATH % prop["file"], prop["at"], 1.0)
		if hung != null:
			_scenery.append(hung)
	_build_guardian()
	_build_header()
	_board_plate = PixelStyle.iron_plate(BOARD_RECT)
	_stage.add_child(_board_plate)
	_board = Control.new()
	_board.position = BOARD_RECT.position
	_board.size = BOARD_RECT.size
	_board.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(_board)
	_roster = SaintRoster.new()
	_roster.setup(data, catalog, campaign)
	_roster.position = ROSTER_POS
	_roster.saint_tapped.connect(func(id: StringName) -> void: tap_saint(id))
	_roster.head_tapped.connect(toggle_card)
	_stage.add_child(_roster)
	_build_bottom()
	_build_toggle()
	_refresh()
	_shade_scenery()


## Tapping the building's name closes its panels (the board and the stack
## of saints) to see the interior; tapping again opens them (D-517). The
## guardian, his words and the bottom bar stay.
func toggle_interface() -> void:
	interface_shown = not interface_shown
	for item: CanvasItem in [_board_plate, _board, _roster]:
		item.visible = interface_shown
	_shade_scenery()


## A saint's small portrait tapped: its card opens; tapped again (or the
## card closed), it closes (D-517). Abilities changed on the card go to the
## campaign.
func toggle_card(saint_id: StringName) -> void:
	var was: StringName = card_saint
	close_card()
	if was == saint_id:
		return
	var s: CampaignSaint = campaign.saints[saint_id]
	_card = SaintCard.new()
	_card.setup(data, saint_id, s.equipped, s.status.relics, s.level)
	_card.closed.connect(close_card)
	_card.loadout_changed.connect(func(list: Array[StringName]) -> void: s.equipped = list.duplicate())
	add_child(_card)
	card_saint = saint_id


func close_card() -> void:
	if _card != null and is_instance_valid(_card):
		_card.queue_free()
	_card = null
	card_saint = &""


## The interior a little darker under the interface, in full light without it.
func _shade_scenery() -> void:
	for item: CanvasItem in _scenery:
		item.modulate = INTERIOR_SHADE if interface_shown else Color.WHITE


## The building's name and crest, tappable: they close and open the panels.
func _build_toggle() -> void:
	_toggle = Button.new()
	_toggle.flat = true
	_toggle.focus_mode = Control.FOCUS_NONE
	_toggle.position = TOGGLE_RECT.position
	_toggle.size = TOGGLE_RECT.size
	for state: String in ["normal", "hover", "pressed", "focus"]:
		_toggle.add_theme_stylebox_override(state, StyleBoxEmpty.new())
	_toggle.pressed.connect(toggle_interface)
	_stage.add_child(_toggle)


## The guardian on his stage (D-504): cut at the ledge of the bottom bar, as
## behind a counter, never spilling past the stage.
func _build_guardian() -> void:
	var stage := Control.new()
	stage.size = Vector2(BOARD_RECT.position.x - 4, BOTTOM_Y)
	stage.clip_contents = true
	stage.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(stage)
	var path: String = PORTRAIT_PATH % GUARDIANS.get(building, &"")
	if not ResourceLoader.exists(path):
		return
	var texture: Texture2D = load(path) as Texture2D
	var size_shown: Vector2 = texture.get_size() * PORTRAIT_SCALE
	var x: float = floorf((stage.size.x - size_shown.x) * 0.5)
	var corner := Vector2(x, BOTTOM_Y - size_shown.y + PORTRAIT_CUT)
	# The halo behind each head (D-505; Alan's drawing, D-506).
	var halo: Texture2D = load(HALO_PATH) as Texture2D
	for head: Vector2 in HALO_HEADS.get(building, []):
		var side: float = halo.get_size().x * HALO_SCALE
		var center: Vector2 = corner + head * PORTRAIT_SCALE
		stage.add_child(SaintMini.picture(halo, Rect2((center - Vector2(side, side) * 0.5).round(), Vector2(side, side))))
	stage.add_child(SaintMini.picture(texture, Rect2(corner, size_shown)))


func _build_header() -> void:
	var band := TextureRect.new()
	band.texture = PixelStyle.piece("ui_top_band")
	band.stretch_mode = TextureRect.STRETCH_TILE
	band.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	band.size = Vector2(STAGE_SIZE.x, BAND_HEIGHT)
	band.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(band)
	# The crest of the building beside its name, as in Darkest Dungeon.
	var crest_path: String = CREST_PATH % building
	var title_x: float = 14.0
	if ResourceLoader.exists(crest_path):
		_stage.add_child(SaintMini.picture(load(crest_path) as Texture2D, Rect2(Vector2(8, 18), CREST_SIZE)))
		title_x = 8.0 + CREST_SIZE.x + 6.0
	var title := _label(data.ui.text(StringName("building_%s" % building)), TITLE_SIZE, PixelStyle.COLOR_BONE)
	# The big title, smaller when the name is long (Casa de Exercícios).
	var room: float = HEADER_WIDTH + 14.0 - title_x
	var big: int = PixelStyle.BIG_TITLE_SIZE * 2
	if PixelStyle.title_font().get_string_size(title.text, HORIZONTAL_ALIGNMENT_LEFT, -1, big).x > room:
		big = PixelStyle.TITLE_SIZE * 3
	if PixelStyle.title_font().get_string_size(title.text, HORIZONTAL_ALIGNMENT_LEFT, -1, big).x > room:
		big = PixelStyle.BIG_TITLE_SIZE
	PixelStyle.title(title, PixelStyle.COLOR_BONE, big)
	title.position = Vector2(title_x, 18 + floorf((CREST_SIZE.y - title.get_minimum_size().y) * 0.5))
	_stage.add_child(title)
	var column := VBoxContainer.new()
	column.position = Vector2(14, 18 + CREST_SIZE.y + 2)
	column.size = Vector2(HEADER_WIDTH, 0)
	column.add_theme_constant_override("separation", 0)
	column.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(column)
	var guardian := _label(data.ui.text(StringName("guardian_%s" % building)), TITLE_SIZE, PixelStyle.COLOR_AMBER)
	PixelStyle.title(guardian, PixelStyle.COLOR_AMBER, TITLE_SIZE)
	column.add_child(guardian)
	column.add_child(_wrapped("“%s”" % data.ui.text(StringName("guardian_line_%s" % building)), HEADER_WIDTH, PixelStyle.COLOR_GREY))


func _build_bottom() -> void:
	var bar := ColorRect.new()
	bar.color = Color(PixelStyle.COLOR_PITCH, 0.88)
	bar.position = Vector2(0, BOTTOM_Y)
	bar.size = Vector2(STAGE_SIZE.x, STAGE_SIZE.y - BOTTOM_Y)
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(bar)
	var ledge := TextureRect.new()
	ledge.texture = PixelStyle.piece("ui_top_band")
	ledge.stretch_mode = TextureRect.STRETCH_TILE
	ledge.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	ledge.position = Vector2(0, BOTTOM_Y - BAND_HEIGHT * 0.5)
	ledge.size = Vector2(STAGE_SIZE.x, BAND_HEIGHT)
	ledge.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(ledge)
	var coin := _picture(ICON_PATH % "alms", ALMS_POS, 1.0)
	if coin != null:
		coin.position.y = BOTTOM_Y + 10
	_alms = _label("", TITLE_SIZE, PixelStyle.COLOR_GOLD)
	PixelStyle.title(_alms, PixelStyle.COLOR_GOLD, TITLE_SIZE)
	_alms.position = ALMS_POS + Vector2(38, 0)
	_stage.add_child(_alms)
	if building == &"gate":
		_stage.add_child(_depart_banner())
	_stage.add_child(_button(data.ui.text(&"building_back"), press_back, BACK_RECT))


## "Partir" on the blood-red banner (PixelLab, D-504).
func _depart_banner() -> Control:
	var banner := TextureButton.new()
	banner.texture_normal = PixelStyle.piece("ui_depart_banner")
	banner.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	banner.position = DEPART_RECT.position
	banner.focus_mode = Control.FOCUS_NONE
	banner.pressed.connect(func() -> void: depart())
	var word := _label(data.ui.text(&"gate_depart"), TITLE_SIZE, PixelStyle.COLOR_BONE)
	PixelStyle.title(word, PixelStyle.COLOR_BONE, PixelStyle.BIG_TITLE_SIZE)
	word.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	word.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	word.position = Vector2(0, 8)
	word.size = DEPART_RECT.size - Vector2(0, 8)
	banner.add_child(word)
	return banner


func _refresh() -> void:
	if _board == null:
		return
	for child: Node in _board.get_children():
		_board.remove_child(child)
		child.queue_free()
	_alms.text = str(campaign.alms)
	_roster.selected = selected_saint if building != &"retreat_house" else chosen_saint
	_roster.in_party = party_ids()
	_roster.refresh()
	var column := VBoxContainer.new()
	column.position = Vector2(18, 12)
	column.size = Vector2(BOARD_RECT.size.x - 36, 0)
	column.add_theme_constant_override("separation", 6)
	column.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_board.add_child(column)
	match building:
		&"gate":
			_board_gate(column)
		&"pantry":
			_board_pantry(column)
		&"infirmary":
			_board_care(column, &"infirmary_title", campaign.infirmary_beds, "infirmary_beds_l%d", &"infirmary")
		&"garden":
			_board_care(column, &"garden_title", campaign.garden_saints, "garden_slots_l%d", Campaign.GARDEN)
		&"retreat_house":
			_board_retreat(column)
	_status = _wrapped(_hint(), BOARD_RECT.size.x - 36, PixelStyle.COLOR_GREY)
	column.add_child(_status)


## What to do now, or the news of the Gate.
func _hint() -> String:
	if building == &"gate" and not _arrivals.is_empty():
		var names: Array[String] = []
		for id: StringName in _arrivals:
			names.append(catalog.saint(id).name_pt)
		return data.ui.text(&"gate_arrival", {"name": ", ".join(names)})
	return data.ui.text(StringName("guardian_help_%s" % building))


# --- the Gate -------------------------------------------------------------------

func _board_gate(column: VBoxContainer) -> void:
	column.add_child(_section(data.ui.text(&"gate_party")))
	var arches := Control.new()
	var arch_size: Vector2 = PixelStyle.piece("ui_portrait_arch").get_size()
	arches.custom_minimum_size = Vector2(0, arch_size.y)
	arches.mouse_filter = Control.MOUSE_FILTER_IGNORE
	column.add_child(arches)
	var width: float = party.size() * arch_size.x + (party.size() - 1) * ARCH_GAP
	var x: float = floorf((column.size.x - width) * 0.5)
	for i: int in party.size():
		arches.add_child(_party_arch(i, Vector2(x, 0), arch_size))
		x += arch_size.x + ARCH_GAP
	column.add_child(_section(data.ui.text(&"gate_reserve")))
	var reserve := GridContainer.new()
	reserve.columns = RESERVE_COLUMNS
	reserve.add_theme_constant_override("h_separation", 0)
	reserve.add_theme_constant_override("v_separation", 2)
	reserve.mouse_filter = Control.MOUSE_FILTER_IGNORE
	column.add_child(reserve)
	var shown: int = 0
	for id: StringName in campaign.unlocked_saints:
		if not party.has(id):
			reserve.add_child(_reserve_cell(id))
			shown += 1
	# The saints still to come are only empty places, with no names, to keep
	# the surprise (D11, D-519); room to spare for all of them.
	var cells: int = maxi(RESERVE_COLUMNS * RESERVE_ROWS, catalog.saints.size() - party_ids().size())
	for i: int in cells - shown:
		var cell := _cell(RESERVE_CELL)
		cell.add_child(SaintMini.tile(Rect2(_reserve_tile_pos(), RESERVE_TILE), null, Callable()))
		reserve.add_child(cell)


func _party_arch(index: int, pos: Vector2, arch_size: Vector2) -> Control:
	var id: StringName = party[index]
	var place := Button.new()
	place.flat = true
	place.focus_mode = Control.FOCUS_NONE
	place.position = pos
	place.size = arch_size
	place.pressed.connect(func() -> void: tap_slot(index))
	var arch := TextureRect.new()
	arch.texture = PixelStyle.piece("ui_portrait_arch")
	arch.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	arch.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if selected_slot == index:
		arch.modulate = Color(1.6, 1.0, 0.45)
	place.add_child(arch)
	if id != &"":
		place.add_child(SaintMini.picture(SaintCard.face(id), BattleScreen.PORTRAIT_WINDOW))
	var number := _label(str(index + 1), TITLE_SIZE, PixelStyle.COLOR_AMBER)
	PixelStyle.title(number, PixelStyle.COLOR_AMBER, TITLE_SIZE)
	number.position = Vector2(arch_size.x * 0.5 - 6, 30)
	place.add_child(number)
	return place


func _reserve_cell(id: StringName) -> Control:
	var cell := _cell(RESERVE_CELL)
	var blocked: bool = Campaign.saint_refusal(campaign, id) != Campaign.OK
	var tile := SaintMini.tile(Rect2(_reserve_tile_pos(), RESERVE_TILE), SaintMini.head(id), func() -> void: tap_saint(id), selected_saint == id)
	if blocked:
		tile.get_child(1).modulate = BLOCKED_TINT
	cell.add_child(tile)
	# In another building (Garden, bed) or badly hurt: padlock, and a tap
	# says why (D8, D-520).
	if blocked:
		cell.add_child(SaintMini.padlock(Rect2(_reserve_tile_pos(), RESERVE_TILE).get_center()))
	cell.add_child(_centered(_short_name(id), RESERVE_TILE.y, RESERVE_CELL.x - 12, PixelStyle.COLOR_BLOOD if blocked else PixelStyle.COLOR_BONE))
	return cell


func _reserve_tile_pos() -> Vector2:
	return Vector2(floorf((RESERVE_CELL.x - RESERVE_TILE.x) * 0.5), 0)


# --- the Pantry -----------------------------------------------------------------

func _board_pantry(column: VBoxContainer) -> void:
	column.add_child(_section(data.ui.text(&"pantry_stock_title")))
	var shelf := HBoxContainer.new()
	shelf.add_theme_constant_override("separation", int(CELL_GAP))
	shelf.mouse_filter = Control.MOUSE_FILTER_IGNORE
	column.add_child(shelf)
	for id: StringName in PROVISIONS:
		var cell := _cell(Vector2(TILE.x + 8, TILE.y + 22))
		cell.add_child(SaintMini.tile(Rect2(Vector2(4, 0), TILE), _icon(id), func() -> void: buy(id)))
		var price := _label(str(Village.price(catalog, id)), TEXT_SIZE, PixelStyle.COLOR_GOLD)
		price.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		price.position = Vector2(0, TILE.y)
		price.size = Vector2(cell.custom_minimum_size.x, 20)
		cell.add_child(price)
		cell.tooltip_text = catalog.battle_catalog.provision(id).name_pt
		shelf.add_child(cell)
	var capacity: int = Village.pack_capacity(campaign, catalog)
	column.add_child(_section(data.ui.text(&"pantry_pack", {"count": campaign.pantry_stock.size(), "of": capacity})))
	var pack := GridContainer.new()
	pack.columns = 6
	pack.add_theme_constant_override("h_separation", 6)
	pack.add_theme_constant_override("v_separation", 6)
	pack.mouse_filter = Control.MOUSE_FILTER_IGNORE
	column.add_child(pack)
	var most: int = _most_places("pantry_slots_l%d")
	for i: int in most:
		var cell := _cell(TILE)
		if i < campaign.pantry_stock.size():
			var id: StringName = campaign.pantry_stock[i]
			cell.add_child(SaintMini.tile(Rect2(Vector2.ZERO, TILE), _icon(id), func() -> void: give_back(id)))
		else:
			cell.add_child(SaintMini.tile(Rect2(Vector2.ZERO, TILE), null, Callable()))
			if i >= capacity:
				cell.add_child(SaintMini.padlock(TILE * 0.5))
		pack.add_child(cell)


# --- the Infirmary and the Garden --------------------------------------------------

func _board_care(column: VBoxContainer, title_key: StringName, taken: Array[StringName], places_key: String, facility: StringName) -> void:
	column.add_child(_section(data.ui.text(title_key)))
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", int(CELL_GAP))
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	column.add_child(row)
	var open: int = catalog.constants.get_int(StringName(places_key % int(campaign.facilities[facility])))
	for i: int in _most_places(places_key):
		var cell := _cell(BIG_TILE + Vector2(30, 46))
		var tile_rect := Rect2(Vector2(15, 0), BIG_TILE)
		var id: StringName = taken[i] if i < taken.size() else &""
		var caption: String = ""
		var sub: String = ""
		if i >= open:
			cell.add_child(SaintMini.tile(tile_rect, _place_picture(facility), Callable(), false, true))
			cell.add_child(SaintMini.padlock(tile_rect.get_center()))
			caption = data.ui.text(&"place_locked", {"level": _level_opening(places_key, i)})
		elif id != &"":
			cell.add_child(SaintMini.tile(tile_rect, SaintMini.head(id), func() -> void: tap_slot(i)))
			caption = _short_name(id)
			sub = _care_note(id)
		else:
			cell.add_child(SaintMini.tile(tile_rect, null, func() -> void: tap_slot(i), selected_slot == i))
			cell.add_child(SaintMini.picture(_place_picture(facility), _place_rect(tile_rect)))
			caption = data.ui.text(StringName("%s_free" % facility))
			if facility == &"infirmary":
				sub = data.ui.text(&"infirmary_cost", {"cost": catalog.economy.get_int(&"infirmary_bed_cost")})
		cell.add_child(_centered(caption, BIG_TILE.y + 2, cell.custom_minimum_size.x, PixelStyle.COLOR_BONE))
		cell.add_child(_centered(sub, BIG_TILE.y + 22, cell.custom_minimum_size.x, PixelStyle.COLOR_GOLD))
		row.add_child(cell)


## The empty place of the building: the bed or the bench (PixelLab, D-504).
func _place_picture(facility: StringName) -> Texture2D:
	return PixelStyle.piece("ui_bed" if facility == &"infirmary" else "ui_bench")


## The bed or the bench at its own size, in the middle of the tile.
func _place_rect(tile_rect: Rect2) -> Rect2:
	var piece_size := Vector2(PLACE_PIECE, PLACE_PIECE)
	return Rect2((tile_rect.get_center() - piece_size * 0.5).floor(), piece_size)


func _care_note(id: StringName) -> String:
	var s: CampaignSaint = campaign.saints[id]
	if building == &"infirmary":
		return data.ui.text(&"infirmary_weeks", {"weeks": s.injury_weeks_left})
	return data.ui.text(&"garden_desolation", {"value": s.status.desolation})


# --- the Retreat House -------------------------------------------------------------

func _board_retreat(column: VBoxContainer) -> void:
	if chosen_saint == &"":
		column.add_child(_section(data.ui.text(&"retreat_title")))
		return
	var s: CampaignSaint = campaign.saints[chosen_saint]
	column.add_child(_section(catalog.saint(chosen_saint).name_pt))
	column.add_child(_label(data.ui.text(&"retreat_upgrades", {"level": s.level, "left": Campaign.upgrades_left(s, catalog)}), TEXT_SIZE, PixelStyle.COLOR_AMBER))
	var glasses := HBoxContainer.new()
	glasses.add_theme_constant_override("separation", 6)
	glasses.mouse_filter = Control.MOUSE_FILTER_IGNORE
	column.add_child(glasses)
	for ability_id: StringName in catalog.saint(chosen_saint).abilities:
		glasses.add_child(_lancet(ability_id, s))
	if chosen_ability == &"":
		return
	var def: AbilityDef = catalog.battle_catalog.abilities[chosen_ability]
	var better: AbilityDef = AbilityUpgrade.upgraded(def, catalog.constants)
	var done: bool = s.status.upgrades.has(chosen_ability)
	column.add_child(_label(def.name_pt + ("+" if done else ""), TITLE_SIZE, PixelStyle.COLOR_BONE))
	column.add_child(_wrapped(data.ui.text(&"retreat_now", {"rule": AbilityRule.line(def, data.ui, catalog.battle_catalog)}), BOARD_RECT.size.x - 36, PixelStyle.COLOR_GREY))
	column.add_child(_wrapped(data.ui.text(&"retreat_after", {"rule": AbilityRule.line(better, data.ui, catalog.battle_catalog)}), BOARD_RECT.size.x - 36, PixelStyle.COLOR_HEAL))
	if not done:
		var improve := _button(data.ui.text(&"retreat_improve"), func() -> void: upgrade(chosen_ability), Rect2(0, 0, 160, 34))
		improve.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		column.add_child(improve)


func _lancet(ability_id: StringName, s: CampaignSaint) -> Control:
	var def: AbilityDef = catalog.battle_catalog.abilities[ability_id]
	var glass := TextureButton.new()
	var state: String = "chosen" if ability_id == chosen_ability else "on"
	glass.texture_normal = AbilityIcon.lancet(AbilityIcon.of(def), state)
	glass.ignore_texture_size = true
	glass.stretch_mode = TextureButton.STRETCH_SCALE
	glass.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	glass.custom_minimum_size = (LANCET_SIZE * LANCET_SCALE).floor()
	glass.pressed.connect(func() -> void: choose_ability(ability_id))
	if s.status.upgrades.has(ability_id):
		var plus := _label("+", TITLE_SIZE, PixelStyle.COLOR_GOLD)
		PixelStyle.title(plus, PixelStyle.COLOR_GOLD, TITLE_SIZE)
		plus.position = Vector2(glass.custom_minimum_size.x - 14, -4)
		glass.add_child(plus)
	return glass


# --- small parts -----------------------------------------------------------------

func _section(text: String) -> Label:
	var label := _label(text, TITLE_SIZE, PixelStyle.COLOR_AMBER)
	PixelStyle.title(label, PixelStyle.COLOR_AMBER, TITLE_SIZE)
	return label


## The most places a building can have, at its last level (`key` % level).
func _most_places(key: String) -> int:
	var level: int = 1
	while catalog.constants.has_key(StringName(key % (level + 1))):
		level += 1
	return catalog.constants.get_int(StringName(key % level))


## The level at which the place `index` opens.
func _level_opening(key: String, index: int) -> int:
	var level: int = 1
	while catalog.constants.has_key(StringName(key % level)) and catalog.constants.get_int(StringName(key % level)) <= index:
		level += 1
	return level


func _short_name(id: StringName) -> String:
	return data.ui.text(StringName("saint_short_%s" % id))


func _icon(provision_id: StringName) -> Texture2D:
	var path: String = ICON_PATH % provision_id
	return load(path) as Texture2D if ResourceLoader.exists(path) else null


func _cell(cell_size: Vector2) -> Control:
	var cell := Control.new()
	cell.custom_minimum_size = cell_size
	cell.mouse_filter = Control.MOUSE_FILTER_PASS
	return cell


func _centered(text: String, y: float, width: float, color: Color) -> Label:
	var label := _label(text, TEXT_SIZE, color)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.position = Vector2(-6, y)
	label.size = Vector2(width + 12, 20)
	return label


func _button(text: String, on_press: Callable, rect: Rect2) -> Button:
	var button := Button.new()
	button.text = text
	button.add_theme_font_size_override("font_size", TEXT_SIZE)
	button.position = rect.position
	button.size = rect.size
	button.custom_minimum_size = rect.size
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
