class_name Village
extends RefCounted
## What the player does in the village's buildings before going down
## (village-economy §2, §3, §7 and §13; T48): buy provisions at the Pantry,
## pay a bed at the Infirmary, leave a saint resting in the Garden, put a
## relic on a saint, and choose the company at the Gate, which opens the Map
## of Hell. Each action answers a reason (OK when done); a refused one
## changes nothing.

const OK: StringName = &""
const CLOSED: StringName = &"facility_closed"
const NOT_ENOUGH_ALMS: StringName = &"not_enough_alms"
const PACK_FULL: StringName = &"pack_full"
const UNKNOWN_PROVISION: StringName = &"unknown_provision"
const NOT_IN_STOCK: StringName = &"not_in_stock"
const NO_BED_FREE: StringName = &"no_bed_free"
const NOT_INJURED: StringName = &"not_injured"
const ALREADY_THERE: StringName = &"already_there"
const NO_PLACE_FREE: StringName = &"no_place_free"
const NO_RELIC_SPACE: StringName = &"no_relic_space"
const LOADOUT: StringName = &"loadout"
const PANTRY: StringName = &"pantry"
const INFIRMARY: StringName = &"infirmary"
const GATE: StringName = &"gate"


## The pack's slots by the Pantry's level (D-474).
static func pack_capacity(c: CampaignState, catalog: ExpeditionCatalog) -> int:
	return FieldProvisions.capacity(int(c.facilities.get(PANTRY, 1)), catalog.constants)


static func price(catalog: ExpeditionCatalog, provision_id: StringName) -> int:
	var key := StringName("price_%s" % provision_id)
	return catalog.economy.get_int(key) if catalog.economy.has_key(key) else -1


## Buys one unit for the pack (§7 prices; V09, V10).
static func buy(c: CampaignState, catalog: ExpeditionCatalog, provision_id: StringName) -> StringName:
	if not c.facilities.has(PANTRY):
		return CLOSED
	var cost: int = price(catalog, provision_id)
	if cost < 0 or catalog.battle_catalog.provision(provision_id) == null:
		return UNKNOWN_PROVISION
	if c.pantry_stock.size() >= pack_capacity(c, catalog):
		return PACK_FULL
	if c.alms < cost:
		return NOT_ENOUGH_ALMS
	c.alms -= cost
	c.pantry_stock.append(provision_id)
	return OK


## Gives back one unit bought this week, for what it cost.
static func give_back(c: CampaignState, catalog: ExpeditionCatalog, provision_id: StringName) -> StringName:
	if not c.pantry_stock.has(provision_id):
		return NOT_IN_STOCK
	c.pantry_stock.erase(provision_id)
	c.alms += price(catalog, provision_id)
	return OK


## Beds of the Infirmary at its level (§3).
static func beds(c: CampaignState, catalog: ExpeditionCatalog) -> int:
	if not c.facilities.has(INFIRMARY):
		return 0
	return catalog.constants.get_int(StringName("infirmary_beds_l%d" % int(c.facilities[INFIRMARY])))


## Pays a bed for this week to an injured saint ([infirmary_bed_cost]; V11).
static func pay_bed(c: CampaignState, catalog: ExpeditionCatalog, saint_id: StringName) -> StringName:
	if not c.facilities.has(INFIRMARY):
		return CLOSED
	var s: CampaignSaint = c.saints.get(saint_id)
	if s == null:
		return Campaign.NOT_UNLOCKED
	if s.status.injury == SaintStatus.INJURY_NONE:
		return NOT_INJURED
	if c.infirmary_beds.has(saint_id):
		return ALREADY_THERE
	if c.infirmary_beds.size() >= beds(c, catalog):
		return NO_BED_FREE
	var cost: int = catalog.economy.get_int(&"infirmary_bed_cost")
	if c.alms < cost:
		return NOT_ENOUGH_ALMS
	c.alms -= cost
	c.infirmary_beds.append(saint_id)
	return OK


## Places of the Garden at its level (§3).
static func garden_places(c: CampaignState, catalog: ExpeditionCatalog) -> int:
	if not c.facilities.has(Campaign.GARDEN):
		return 0
	return catalog.constants.get_int(StringName("garden_slots_l%d" % int(c.facilities[Campaign.GARDEN])))


## Leaves a saint resting in the Garden this week, or takes it back out
## (§4: it does not go down; D-469).
static func toggle_garden(c: CampaignState, catalog: ExpeditionCatalog, saint_id: StringName) -> StringName:
	if not c.facilities.has(Campaign.GARDEN):
		return CLOSED
	if not c.saints.has(saint_id):
		return Campaign.NOT_UNLOCKED
	if c.garden_saints.has(saint_id):
		c.garden_saints.erase(saint_id)
		return OK
	if c.garden_saints.size() >= garden_places(c, catalog):
		return NO_PLACE_FREE
	c.garden_saints.append(saint_id)
	return OK


## Relic spaces of a saint by its level (GDD §3, D-477).
static func relic_spaces(s: CampaignSaint, catalog: ExpeditionCatalog) -> int:
	if s.level >= catalog.constants.get_int(&"relic_second_slot_level"):
		return catalog.constants.get_int(&"relic_slots_max")
	return catalog.constants.get_int(&"relic_slots_start")


## Puts a relic of the village on a saint (at the Gate, §13).
static func equip_relic(c: CampaignState, catalog: ExpeditionCatalog, saint_id: StringName, relic_id: StringName) -> StringName:
	var s: CampaignSaint = c.saints.get(saint_id)
	if s == null:
		return Campaign.NOT_UNLOCKED
	if not c.relic_stock.has(relic_id):
		return NOT_IN_STOCK
	if s.status.relics.size() >= relic_spaces(s, catalog):
		return NO_RELIC_SPACE
	c.relic_stock.erase(relic_id)
	s.status.relics.append(relic_id)
	_settle_relics(s, catalog)
	return OK


## Takes a relic off a saint, back to the village.
static func unequip_relic(c: CampaignState, catalog: ExpeditionCatalog, saint_id: StringName, relic_id: StringName) -> StringName:
	var s: CampaignSaint = c.saints.get(saint_id)
	if s == null or not s.status.relics.has(relic_id):
		return NOT_IN_STOCK
	s.status.relics.erase(relic_id)
	c.relic_stock.append(relic_id)
	_settle_relics(s, catalog)
	return OK


## The saint's Vigor and Faith with the relics it carries, recomputed from
## its level and its relics (data-schemas §4: stat_add on Faith, stat_mult
## on Vigor). In the village everyone is at full health (D-481).
static func _settle_relics(s: CampaignSaint, catalog: ExpeditionCatalog) -> void:
	var def: SaintDef = catalog.saint(s.id)
	var base_max: int = def.max_hp + def.hp_per_level * (s.level - 1)
	s.status.max_hp = base_max
	s.status.faith_bonus = 0
	for id: StringName in s.status.relics:
		var relic: RelicDef = catalog.relic(id)
		if relic == null:
			continue
		var stat: String = str(relic.params.get("stat", ""))
		var value: float = float(relic.params.get("value", 0.0))
		if relic.modifier == &"stat_add" and stat == "faith":
			s.status.faith_bonus += int(value)
		elif relic.modifier == &"stat_mult" and stat == "max_hp":
			s.status.max_hp = maxi(s.status.max_hp, Damage.round_half_up(base_max * value))
	s.status.hp = s.status.max_hp


## Suggestions the player only confirms or adjusts (§2): a saint with a
## major injury to a bed, one with desolation at [faith_check_threshold]
## (100) or more
## to the Garden, and the company from who can go, in formation order.
static func suggestions(c: CampaignState, catalog: ExpeditionCatalog) -> Dictionary:
	var bed: Array[StringName] = []
	var garden: Array[StringName] = []
	var party: Array[StringName] = []
	for id: StringName in c.unlocked_saints:
		var s: CampaignSaint = c.saints[id]
		if s.status.injury == SaintStatus.INJURY_MAJOR:
			bed.append(id)
		elif s.status.desolation >= catalog.constants.get_int(&"faith_check_threshold"):
			garden.append(id)
		elif party.size() < catalog.constants.get_int(&"party_size"):
			party.append(id)
	return {"bed": bed, "garden": garden, "party": party}


## At the Gate: the company in its order (positions 1 to 3) leaves for
## `circle`, from its gate (camp 0) or a consecrated camp, carrying the pack
## bought. Returns the expedition, or null with the reason in `why`.
static func depart(c: CampaignState, catalog: ExpeditionCatalog, party: Array[StringName], circle: StringName, map_seed: int, encounter_circle: int, camp: int = 0, why: Array[StringName] = []) -> ExpeditionController:
	var refusal: StringName = Campaign.party_refusal(c, catalog, party)
	if refusal == OK:
		for id: StringName in party:
			var s: CampaignSaint = c.saints[id]
			if AbilityLoadout.refusal(catalog.saint(id), s.equipped, catalog.battle_catalog.abilities, catalog.constants) != AbilityLoadout.OK:
				refusal = LOADOUT
	if refusal != OK:
		why.append(refusal)
		return null
	var ctrl: ExpeditionController
	if camp > 0:
		ctrl = ExpeditionController.start_resumed(catalog, circle, map_seed, party, c.pantry_stock, encounter_circle, camp, c.flags)
	else:
		ctrl = ExpeditionController.start_new(catalog, circle, map_seed, party, c.pantry_stock, encounter_circle)
	if ctrl == null:
		why.append(CLOSED)
		return null
	ctrl.state.gate_level = int(c.facilities.get(PANTRY, 1))
	Campaign.board(c, catalog, ctrl)
	c.pantry_stock.clear()
	return ctrl
