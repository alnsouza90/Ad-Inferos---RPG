class_name VillageFlow
extends Control
## The cycle of the campaign (T49, D-208, D-514): the village, a building
## tapped, the Gate's "Partir" with the company chosen, the Map of Hell, the
## expedition from the gate of the circle or a consecrated camp, and back to
## the village when it ends (the week turns). Only one screen at a time;
## every rule is the campaign's (Village, Campaign, HellMap).

var data: GameData
var catalog: ExpeditionCatalog
var campaign: CampaignState
## True in the game: the campaign goes through GameState, which saves it.
## Tests turn it off so they never touch the player's save slot.
var use_game_state: bool = true
## Battle animation speed handed to the expedition (BattleScreen.SPEEDS).
var speed_index: int = 0
## The screen shown now.
var screen: Control
## The company chosen at the Gate, in its order.
var party: Array[StringName] = []
## The last refusal of a departure (Village.depart), for the tests.
var last_refusal: StringName = &""


func setup(p_data: GameData, p_catalog: ExpeditionCatalog, p_campaign: CampaignState) -> void:
	data = p_data
	catalog = p_catalog
	campaign = p_campaign


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	if screen == null:
		show_village()


func show_village() -> void:
	var village := VillageScreen.new()
	village.setup(data, campaign, catalog.economy)
	village.building_chosen.connect(open_building)
	village.week_pass_requested.connect(pass_week)
	_show(village)


## "Passar a semana" (D9): the week turns, the village is saved and redrawn.
func pass_week() -> void:
	Campaign.pass_week(campaign, catalog)
	var state: Node = _game_state()
	if state != null:
		state.call("save_now")
	show_village()


func open_building(building: StringName) -> void:
	var inside := BuildingScreen.new()
	inside.setup(data, catalog, campaign, building)
	inside.back_pressed.connect(show_village)
	inside.departed.connect(open_map)
	_show(inside)


## The Gate's "Partir": the company is kept and the map opens.
func open_map(p_party: Array[StringName]) -> void:
	party = p_party.duplicate()
	var map := HellMapScreen.new()
	map.setup(data, catalog, campaign)
	map.back_pressed.connect(open_building.bind(&"gate"))
	map.start_chosen.connect(start_expedition)
	_show(map)


## "Partir daqui": the expedition to `place` from its gate (0) or a camp.
func start_expedition(place: StringName, camp: int) -> void:
	var why: Array[StringName] = []
	var map_seed: int = ExpeditionController.map_seed_for(campaign.seed, place, campaign.week)
	var ctrl: ExpeditionController = Village.depart(campaign, catalog, party, place, map_seed, HellMap.circle_of(place), camp, why)
	if ctrl == null:
		last_refusal = why[0] if not why.is_empty() else &""
		return
	last_refusal = &""
	var state: Node = _game_state()
	if state != null:
		state.call("start_expedition", catalog, ctrl, campaign.seed)
	open_leg(ctrl)


## The expedition on screen (also for a save loaded mid-expedition).
func open_leg(ctrl: ExpeditionController) -> void:
	var leg := LegScreen.new()
	leg.use_game_state = use_game_state
	leg.speed_index = speed_index
	leg.end_text_key = &"building_back"
	leg.setup(data, catalog, ctrl)
	leg.title_requested.connect(finish_expedition.bind(ctrl))
	_show(leg)


## The summary's "Voltar à vila": the campaign takes what the expedition
## brought and the week turns (Campaign.finish_expedition), then the village.
func finish_expedition(ctrl: ExpeditionController) -> void:
	var levels: Dictionary = {}
	for id: StringName in campaign.saints:
		levels[id] = (campaign.saints[id] as CampaignSaint).level
	var state: Node = _game_state()
	if state != null:
		state.call("finish_expedition")
	else:
		Campaign.finish_expedition(campaign, catalog, ctrl)
	show_village()
	# Who went up a level is told on arrival (V11, D-520).
	var news: Array[String] = []
	for id: StringName in levels:
		var s: CampaignSaint = campaign.saints[id]
		if s.level > int(levels[id]):
			news.append(data.ui.text(&"village_level_up", {"name": catalog.saint(id).name_pt, "level": s.level}))
	if not news.is_empty():
		(screen as VillageScreen).show_news(data.ui.text(&"village_news_title"), "\n".join(news))


func _show(next: Control) -> void:
	if screen != null and is_instance_valid(screen):
		screen.queue_free()
	screen = next
	add_child(next)


## GameState, by path, only when in use (as LegScreen).
func _game_state() -> Node:
	if not use_game_state or not is_inside_tree():
		return null
	return get_node_or_null("/root/GameState")
