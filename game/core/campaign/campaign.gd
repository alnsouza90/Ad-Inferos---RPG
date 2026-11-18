class_name Campaign
extends RefCounted
## The rules of the campaign between expeditions (village-economy §1, §8,
## §10 and §13; T46). Every function takes the state and the catalog and
## changes only the state; refusals change nothing.

const OK: StringName = &""
const RETREAT_USED: StringName = &"retreat_used"
const NOT_UNLOCKED: StringName = &"saint_not_unlocked"
const RESTING: StringName = &"saint_resting"
const WRONG_PARTY: StringName = &"wrong_party"
## A major injury keeps the saint home until healed (D-481).
const INJURED: StringName = &"saint_injured"
## Buildings open in the M2, at level 1 (village-economy §13, D-474, D-475).
const M2_FACILITIES: Array[StringName] = [&"pantry", &"infirmary", &"gate", &"retreat_house", &"garden"]
const UNLOCK_START: String = "start"
const UNLOCK_CIRCLE: String = "circle:"
const GARDEN: StringName = &"garden"


## A new campaign at week 1 with the saints of the start (§10).
static func start(catalog: ExpeditionCatalog, p_seed: int) -> CampaignState:
	var c := CampaignState.new()
	c.seed = p_seed
	c.virtues = Virtues.start(catalog.constants)
	for f: StringName in M2_FACILITIES:
		c.facilities[f] = 1
	# In the order of saints.csv (the formation of GameData.M0_FORMATION).
	for id: StringName in catalog.saints:
		if (catalog.saints[id] as SaintDef).unlock == UNLOCK_START:
			_unlock(c, catalog, id, false)
	return c


## The campaign of a save from before version 6 (save-load §3.3): it kept
## only the expedition, so the campaign is born from it: week 1, the starting
## saints as the save holds them, the virtues and flags (with the consecrated
## camps), and Antão if Circle 2 was completed. Nothing of the old save is
## lost; the week turns when its expedition ends.
static func adopt(catalog: ExpeditionCatalog, p_seed: int, virtues: Dictionary, p_flags: Array, saints: Dictionary) -> CampaignState:
	var c := start(catalog, p_seed)
	if not virtues.is_empty():
		c.virtues = Virtues.from_dict(virtues)
	for f: Variant in p_flags:
		c.flags.append(StringName(str(f)))
	for id: Variant in saints:
		var key := StringName(str(id))
		if c.saints.has(key) and saints[id] is Dictionary:
			var status := SaintStatus.from_dict(saints[id])
			status.hp_penalty = 0.0
			status.faith_penalty = 0.0
			(c.saints[key] as CampaignSaint).status = status
			if status.injury != SaintStatus.INJURY_NONE:
				_start_injury(catalog, c.saints[key])
	_unlock_by_circles(c, catalog)
	return c


## Retreat: a week without an expedition, at most one between two (V01).
static func retreat(c: CampaignState, catalog: ExpeditionCatalog) -> StringName:
	if c.retreat_used:
		return RETREAT_USED
	advance_week(c, catalog)
	c.retreat_used = true
	return OK


## Why `party` cannot leave (OK when it can): three different saints of the
## company, none resting in the Garden this week.
static func party_refusal(c: CampaignState, catalog: ExpeditionCatalog, party: Array[StringName]) -> StringName:
	var seen: Array[StringName] = []
	for id: StringName in party:
		if seen.has(id):
			return WRONG_PARTY
		seen.append(id)
		if not c.unlocked_saints.has(id):
			return NOT_UNLOCKED
		if c.garden_saints.has(id):
			return RESTING
		if (c.saints[id] as CampaignSaint).status.injury == SaintStatus.INJURY_MAJOR:
			return INJURED
	if party.size() != catalog.constants.get_int(&"party_size"):
		return WRONG_PARTY
	return OK


## The saints as they leave for an expedition: what they carry, with the
## penalty of the minor injury each one still has (§8, D-481: −10% of
## Vigor and of Faith, no draw). The injury itself stays in the campaign,
## so whatever injury comes back is new.
static func departing(c: CampaignState, catalog: ExpeditionCatalog, party: Array[StringName]) -> Dictionary:
	var out: Dictionary = {}
	for id: StringName in party:
		var s: CampaignSaint = c.saints[id]
		var status: SaintStatus = s.status.duplicate_status()
		status.injury = SaintStatus.INJURY_NONE
		status.hp_penalty = 0.0
		status.faith_penalty = 0.0
		var penalty: float = injury_penalty(catalog, s.status.injury)
		status.hp_penalty = penalty
		status.faith_penalty = penalty
		out[id] = status
	return out


## The fraction an injury takes off Vigor and Faith (§8).
static func injury_penalty(catalog: ExpeditionCatalog, injury: StringName) -> float:
	match injury:
		SaintStatus.INJURY_MAJOR:
			return catalog.economy.get_float(&"injury_major_penalty")
		SaintStatus.INJURY_MINOR:
			return catalog.economy.get_float(&"injury_minor_penalty")
	return 0.0


## Hands an expedition just created for `party` the campaign's saints,
## virtues and flags (before its first command).
static func board(c: CampaignState, catalog: ExpeditionCatalog, ctrl: ExpeditionController) -> void:
	ctrl.carry_in(departing(c, catalog, ctrl.state.party), c.virtues, c.flags)


## Back from an expedition, however it ended (§1): the saints come home as
## they are, new injuries start counting, the Alms come to the company, the
## found relics to the village, the flags and virtues to the campaign, a
## circle completed for the first time unlocks its saint (§10). Then the week
## turns.
static func finish_expedition(c: CampaignState, catalog: ExpeditionCatalog, ctrl: ExpeditionController) -> void:
	for id: StringName in ctrl.saints:
		if not c.saints.has(id):
			continue
		var s: CampaignSaint = c.saints[id]
		var back: SaintStatus = (ctrl.saints[id] as SaintStatus).duplicate_status()
		back.hp_penalty = 0.0
		back.faith_penalty = 0.0
		var before: StringName = s.status.injury
		var taken: StringName = back.injury
		back.injury = combined_injury(before, taken)
		s.status = back
		if taken != SaintStatus.INJURY_NONE:
			_start_injury(catalog, s)
	c.alms += ctrl.state.alms_banked + ctrl.state.alms_unbanked
	for r: StringName in ctrl.state.relic_pack:
		c.relic_stock.append(r)
	c.flags = ctrl.flags.duplicate()
	c.virtues = Virtues.from_dict(ctrl.virtues.to_dict())
	_unlock_by_circles(c, catalog)
	advance_week(c, catalog)
	c.retreat_used = false


## The turn of the week (§1, without what stays for the M3): the Garden
## eases the desolation of who rested there, injuries heal (a paid bed heals
## a major one in a week), everyone is back to full health, and the week's
## designations end.
static func advance_week(c: CampaignState, catalog: ExpeditionCatalog) -> void:
	for id: StringName in c.garden_saints:
		_ease_desolation(c, catalog, id, catalog.constants.get_int(&"garden_desolation_per_week"))
	for id: StringName in c.saints:
		var s: CampaignSaint = c.saints[id]
		if s.status.injury != SaintStatus.INJURY_NONE:
			s.injury_weeks_left -= 1
			if c.infirmary_beds.has(id) and s.status.injury == SaintStatus.INJURY_MAJOR:
				s.injury_weeks_left = mini(s.injury_weeks_left, catalog.economy.get_int(&"injury_major_weeks_bed") - 1)
			if s.injury_weeks_left <= 0:
				s.status.injury = SaintStatus.INJURY_NONE
				s.injury_weeks_left = 0
		s.status.hp = s.status.max_hp
	c.week += 1
	c.garden_saints.clear()
	c.infirmary_beds.clear()


## The injury a saint has after taking `taken` while carrying `before`
## (D-481): a second minor one, before the first healed, becomes major; a
## major one stays major (and starts counting again).
static func combined_injury(before: StringName, taken: StringName) -> StringName:
	if taken == SaintStatus.INJURY_NONE:
		return before
	if taken == SaintStatus.INJURY_MAJOR or before != SaintStatus.INJURY_NONE:
		return SaintStatus.INJURY_MAJOR
	return SaintStatus.INJURY_MINOR


## The arrivals São Cristóvão announced are no longer pending (D-458).
static func announce_arrivals(c: CampaignState) -> Array[StringName]:
	var announced: Array[StringName] = c.pending_arrivals.duplicate()
	c.pending_arrivals.clear()
	return announced


static func _start_injury(catalog: ExpeditionCatalog, s: CampaignSaint) -> void:
	match s.status.injury:
		SaintStatus.INJURY_MAJOR:
			s.injury_weeks_left = catalog.economy.get_int(&"injury_major_weeks")
		SaintStatus.INJURY_MINOR:
			s.injury_weeks_left = catalog.economy.get_int(&"injury_minor_weeks")
		_:
			s.injury_weeks_left = 0


## Desolation eased in the village goes through the same rules as in the
## field (thresholds, the end of the Dark Night), on a combatant of the saint.
static func _ease_desolation(c: CampaignState, catalog: ExpeditionCatalog, id: StringName, amount: int) -> void:
	var s: CampaignSaint = c.saints.get(id)
	if s == null:
		return
	var body := Combatant.from_saint(catalog.saint(id))
	s.status.apply_to(body)
	var ctx := DesolationContext.new()
	ctx.constants = catalog.constants
	ctx.rng = RngStream.new(c.seed, RngStreams.CAMPAIGN, c.rng_counter)
	Desolation.change(body, -amount, &"garden", ctx)
	c.rng_counter = ctx.rng.counter
	s.status.desolation = body.desolation
	s.status.spirit_state = body.spirit_state
	s.status.purified = body.purified


## A circle completed for the first time brings its saint (§10: Antão with
## Circle 2), announced at the Gate.
static func _unlock_by_circles(c: CampaignState, catalog: ExpeditionCatalog) -> void:
	for id: StringName in catalog.saints:
		var unlock: String = (catalog.saints[id] as SaintDef).unlock
		if not unlock.begins_with(UNLOCK_CIRCLE) or c.unlocked_saints.has(id):
			continue
		var circle: int = int(unlock.trim_prefix(UNLOCK_CIRCLE))
		if c.flags.has(StringName("circle_%02d_completed" % circle)):
			_unlock(c, catalog, id, true)


static func _unlock(c: CampaignState, catalog: ExpeditionCatalog, id: StringName, announced: bool) -> void:
	c.unlocked_saints.append(id)
	c.saints[id] = CampaignSaint.from_def(catalog.saint(id))
	if announced:
		c.pending_arrivals.append(id)
