class_name SaintRoster
extends Control
## The saints stacked at the right of every village building (T49, D-503),
## as the roster of Darkest Dungeon: the head, the name, the level, the
## Health and the Desolation, and where the saint is now (in the company, in
## a bed, resting in the Garden, wounded). Tapping a card tells the building.

signal saint_tapped(saint_id: StringName)
## The small portrait tapped: the saint's card (D-517).
signal head_tapped(saint_id: StringName)

const CARD_SIZE := Vector2(216, 56)
const CARD_GAP: float = 4.0
const HEAD_RECT := Rect2(4, 4, 48, 48)
const BAR_SIZE := Vector2(64, 4)
const TEXT_SIZE: int = PixelStyle.TEXT_SIZE * 2

var data: GameData
var catalog: ExpeditionCatalog
var campaign: CampaignState
## The card glowing amber.
var selected: StringName = &""
## Saints of the Gate's company (shown "Na companhia").
var in_party: Array[StringName] = []

var _cards: VBoxContainer


func setup(p_data: GameData, p_catalog: ExpeditionCatalog, p_campaign: CampaignState) -> void:
	data = p_data
	catalog = p_catalog
	campaign = p_campaign


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	var title := Label.new()
	title.text = data.ui.text(&"roster_title")
	PixelStyle.title(title, PixelStyle.COLOR_BONE, PixelStyle.TITLE_SIZE * 2)
	title.position = Vector2(4, 0)
	add_child(title)
	_cards = VBoxContainer.new()
	_cards.position = Vector2(0, 30)
	_cards.add_theme_constant_override("separation", int(CARD_GAP))
	_cards.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_cards)
	refresh()


func refresh() -> void:
	if _cards == null:
		return
	for child: Node in _cards.get_children():
		_cards.remove_child(child)
		child.queue_free()
	for id: StringName in campaign.unlocked_saints:
		_cards.add_child(_card(id))


## The place of the saint, shown under the name ("" when free).
func place_of(saint_id: StringName) -> String:
	var s: CampaignSaint = campaign.saints[saint_id]
	if campaign.infirmary_beds.has(saint_id):
		return data.ui.text(&"roster_in_bed")
	if campaign.garden_saints.has(saint_id):
		return data.ui.text(&"roster_resting")
	if s.status.injury == SaintStatus.INJURY_MAJOR:
		return data.ui.text(&"injury_major")
	if s.status.injury == SaintStatus.INJURY_MINOR:
		return data.ui.text(&"injury_minor")
	if in_party.has(saint_id):
		return data.ui.text(&"roster_in_party")
	return ""


func _card(id: StringName) -> Button:
	var s: CampaignSaint = campaign.saints[id]
	var card := Button.new()
	card.flat = true
	card.focus_mode = Control.FOCUS_NONE
	card.custom_minimum_size = CARD_SIZE
	card.pressed.connect(func() -> void: saint_tapped.emit(id))
	var back := PixelStyle.plate(Rect2(Vector2.ZERO, CARD_SIZE), PixelStyle.COLOR_IRON,
		PixelStyle.COLOR_AMBER if id == selected else PixelStyle.COLOR_LEAD)
	back.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.add_child(back)
	card.add_child(SaintMini.tile(HEAD_RECT, SaintMini.head(id), func() -> void: head_tapped.emit(id), id == selected))
	var x: float = HEAD_RECT.end.x + 6.0
	card.add_child(_text(catalog.saint(id).name_pt, Vector2(x, 0), PixelStyle.COLOR_BONE))
	var place: String = place_of(id)
	var level: String = data.ui.text(&"roster_level", {"level": s.level})
	card.add_child(_text(level, Vector2(x, 17), PixelStyle.COLOR_GREY))
	# An improvement to choose at the Retreat House (V10, V11): a mark in gold.
	if Campaign.upgrades_left(s, catalog) > 0:
		card.add_child(_text(data.ui.text(&"roster_upgrade"), Vector2(CARD_SIZE.x - 64, 0), PixelStyle.COLOR_GOLD))
	if not place.is_empty():
		var hurt: bool = s.status.injury != SaintStatus.INJURY_NONE and not campaign.infirmary_beds.has(id)
		card.add_child(_text(place, Vector2(x + 40, 17), PixelStyle.COLOR_BLOOD if hurt else PixelStyle.COLOR_AMBER))
	var hp_share: float = 1.0 if s.status.max_hp <= 0 else float(s.status.hp) / float(s.status.max_hp)
	card.add_child(_bar(Vector2(x, 40), hp_share, PixelStyle.COLOR_BLOOD))
	var desolation_max: float = float(catalog.constants.get_int(&"desolation_max"))
	card.add_child(_bar(Vector2(x + BAR_SIZE.x + 8, 40), float(s.status.desolation) / desolation_max, PixelStyle.COLOR_VIOLET))
	return card


func _bar(pos: Vector2, share: float, color: Color) -> Control:
	var frame := ColorRect.new()
	frame.color = PixelStyle.COLOR_PITCH
	frame.position = pos - Vector2(1, 1)
	frame.size = BAR_SIZE + Vector2(2, 2)
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var fill := ColorRect.new()
	fill.color = color
	fill.position = Vector2(1, 1)
	fill.size = Vector2(roundf(BAR_SIZE.x * clampf(share, 0.0, 1.0)), BAR_SIZE.y)
	fill.mouse_filter = Control.MOUSE_FILTER_IGNORE
	frame.add_child(fill)
	return frame


func _text(text: String, pos: Vector2, color: Color) -> Label:
	var label := Label.new()
	label.text = text
	label.position = pos
	label.add_theme_font_size_override("font_size", TEXT_SIZE)
	label.add_theme_color_override("font_color", color)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return label
