class_name BalanceImporter
extends RefCounted
## Turns the docs/balance CSV texts into definition Resources and validates
## them (data-schemas §2 and §3). Pure: it never reads or writes files, so the
## whole validation is testable with in-memory tables.
##
## Every error is "<file> linha <n> [<code>]: <mensagem>". The code is stable
## (tests match on it); the message is for the project owner, in Portuguese.

const TABLE_COLUMNS: Dictionary = {
	"constants": ["key", "value", "description"],
	"economy": ["key", "value", "description"],
	"conditions": ["id", "kind", "polarity", "max_stacks", "stacking", "decay", "tick", "consume_on", "resisted_by_will", "hook", "icon", "display_priority", "name_pt", "desc_pt"],
	"traits": ["id", "owner", "name_pt", "trigger", "hook", "params", "desc_pt"],
	"camp_skills": ["id", "owner", "name_pt", "effect", "params", "desc_pt"],
	"effects": ["owner_id", "order", "type", "amount", "damage_type", "condition_id", "stacks", "polarity", "move_kind", "n", "summon_id", "max_alive", "target_override", "params"],
	"abilities": ["id", "owner", "name_pt", "kind", "cost", "use_slots", "targeting", "target_slots", "allow_self", "once_per_battle", "origin", "upgrade", "desc_pt"],
	"enemy_actions": ["id", "priority", "use_slots", "target_slots", "targeting", "target_rule", "conditions", "cooldown", "intent_icon"],
	"enemies": ["id", "name_pt", "family", "circles", "nature", "role", "size", "max_hp", "armor", "immune", "leaves_remains", "remains_rounds", "actions", "art_id"],
	"encounters": ["id", "circle", "pool", "slot_1", "slot_2", "slot_3", "slot_4", "type"],
	"provisions": ["id", "name_pt", "price", "usable_in_battle", "targeting", "effect_ids"],
	"map_templates": ["id", "leg", "layer", "index", "role", "type", "links"],
	"starting_kits": ["id", "provision_id", "amount"],
	"ui_text": ["id", "text_pt"],
	"saints": ["id", "name_pt", "roles", "preferred_slots", "max_hp", "armor", "faith", "will", "hp_per_level", "faith_per_level", "abilities", "default_equipped", "miracle", "trait", "camp_skill", "affinities", "unlock", "m0"],
}

const ROLES: Array[String] = ["protector", "healer", "fighter", "exorcist", "intercessor"]
const AFFINITIES: Array[String] = ["carmel", "franciscans", "monastics", "soldiers"]
const ABILITY_KINDS: Array[String] = ["basic", "fervor", "miracle"]
const ABILITY_TARGETING: Array[String] = ["self", "ally", "ally_fallen", "all_allies", "enemy", "enemy_group", "all_enemies", "chosen_enemy_slots"]
const ABILITY_ALLY_TARGETING: Array[String] = ["ally", "ally_fallen"]
const ABILITY_ENEMY_TARGETING: Array[String] = ["enemy", "enemy_group", "chosen_enemy_slots"]
const ORIGINS: Array[String] = ["scripture", "catechism", "tradition", "hagiography", "legend", "apocrypha", "dante", "demonology", "game_fiction"]
const EFFECT_TYPES: Array[String] = ["damage", "heal", "revive", "apply_condition", "remove_condition", "strip_positive_tokens", "move", "gain_fervor", "desolation", "summon", "self_damage", "light", "reveal_or_cancel_ambush"]
const DAMAGE_TYPES: Array[String] = ["strike", "exorcism", "untyped"]
const POLARITIES: Array[String] = ["positive", "negative"]
const MOVE_KINDS: Array[String] = ["push", "pull", "swap"]
const TARGET_OVERRIDES: Array[String] = ["self", "all_allies", "all_enemies"]
const EFFECT_PARAMS: Array[String] = ["elite", "boss", "hp_fraction", "heal_if_alive", "dark_night_amount", "per_milestone", "exclude_self", "with", "const"]
const TRAIT_TRIGGERS: Array[String] = ["on_battle_start", "on_round_start", "on_ability_used", "on_damage_dealt", "on_damaged", "on_ally_fallen", "on_fallen", "passive"]
const CAMP_EFFECTS: Array[String] = ["ambush_mult", "desolation_party", "heal_party_pct", "heal_ally_pct", "ally_desolation", "refund_bread", "alms_bonus", "next_battle_condition", "remove_minor_injury", "reveal_next_layer", "suffrage_bonus"]
const CONDITION_KINDS: Array[String] = ["token", "duration", "permanent"]
const STACKING: Array[String] = ["add", "refresh", "none"]
const DECAY: Array[String] = ["none", "minus_one_after_tick", "expire_round_end"]
const TICKS: Array[String] = ["none", "owner_turn_start", "round_end"]
const CONSUME_ON: Array[String] = ["none", "on_hit_received", "on_damaging_action", "on_action_attempt"]
const FAMILIES: Array[String] = ["a", "b", "c", "elite", "boss"]
const NATURES: Array[String] = ["corporeal", "spiritual"]
const ENEMY_ROLES: Array[String] = ["brute", "guard", "ranged", "corruptor", "manipulator", "summoner"]
const ACTION_TARGETING: Array[String] = ["single", "all_party", "self", "ally_enemy", "all_enemies"]
const TARGET_RULES: Array[String] = ["front_most", "back_most", "lowest_hp", "lowest_hp_pct", "highest_desolation", "random"]
const ACTION_CONDITIONS_WITH_PARAM: Array[String] = ["self_hp_below", "ally_hp_below", "allies_alive_below", "round_at_least", "every_n_rounds", "party_has_condition"]
const ACTION_CONDITIONS_NO_PARAM: Array[String] = ["always", "free_enemy_slot"]
const INTENT_ICONS: Array[String] = ["attack", "corrupt", "displace", "defend", "summon", "special"]
const POOLS: Array[String] = ["easy", "hard", "elite", "boss", "ambush"]
const ENCOUNTER_TYPES: Array[String] = ["common", "elite", "boss"]
const EVENT_TYPES: Array[String] = ["temptation", "soul_meeting", "flashback", "council", "intercession_mission", "story"]
const EVENT_OUTCOMES: Array[String] = ["virtue", "desolation", "light", "alms", "provisions", "relic", "injury", "suffrages", "set_flag", "start_battle", "unlock"]
const EVENT_REQUIREMENTS: Array[String] = ["virtue_at_least", "saint_in_party", "provision", "alms_at_least", "flag_set"]
const CHANCE_MODIFIERS: Array[String] = ["saint_in_party", "provision", "relic"]
const VIRTUES: Array[String] = ["virtue_faith", "virtue_hope", "virtue_charity"]
const MAP_ROLES: Array[String] = ["battle", "temptation", "variable", "soul"]
const MAP_NODE_TYPES: Array[String] = ["node_battle", "node_elite", "node_temptation", "node_soul", "node_relic"]
const PROVISION_TARGETING: Array[String] = ["none", "self", "ally", "all_allies"]
const SAINT_SLOTS: Array[int] = [1, 2, 3]
const ABILITIES_PER_SAINT: int = 6
const BASICS_PER_SAINT: int = 4
const FERVOR_PER_SAINT: int = 2
const EQUIPPED_PER_SAINT: int = 4
const MAX_BASIC_COST: int = 1
const FERVOR_COST: int = 2
const MIN_MIRACLE_COST: int = 3
const MAX_MIRACLE_COST: int = 4
const MAX_ENEMY_SLOTS: int = 4

var errors: Array[String] = []
var constants: ConstantsDef
## Alms, prices and multipliers from economy.csv (same format as constants).
var economy: ConstantsDef
var conditions: Dictionary = {}
var traits: Dictionary = {}
var camp_skills: Dictionary = {}
var abilities: Dictionary = {}
var enemy_actions: Dictionary = {}
var enemies: Dictionary = {}
var encounters: Dictionary = {}
var provisions: Dictionary = {}
var map_templates: Dictionary = {}
var starting_kits: Dictionary = {}
var events: Dictionary = {}
var saints: Dictionary = {}
var ui_text: UiTextDef

## owner_id -> Array[EffectDef] sorted by order
var _effects_by_owner: Dictionary = {}
var _provision_effect_owners: Dictionary = {}
var _tables: Dictionary = {}
var _id_pattern := RegEx.create_from_string("^[a-z0-9_]+$")


## `texts` maps table name (e.g. "saints") to CSV text. Returns true when there
## are no errors. On error the definition dictionaries must not be used.
func import_tables(texts: Dictionary) -> bool:
	errors.clear()
	for table_name: String in TABLE_COLUMNS:
		if not texts.has(table_name):
			_err("missing_table", table_name + ".csv", 0, "arquivo ausente")
			continue
		var table: CsvTable = CsvTable.parse(texts[table_name], table_name + ".csv")
		errors.append_array(table.errors)
		for column: String in TABLE_COLUMNS[table_name]:
			if not table.has_column(column):
				_err("missing_column", table.file_name, 1, "coluna '%s' ausente" % column)
		_tables[table_name] = table
	if not errors.is_empty():
		return false
	_build_constants()
	_build_conditions()
	_build_traits()
	_build_camp_skills()
	_build_effects()
	_build_abilities()
	_build_enemy_actions()
	_build_enemies()
	_build_encounters()
	_build_provisions()
	_build_map_templates()
	_build_starting_kits()
	_build_saints()
	_build_ui_text()
	_build_events(texts.get("_events", {}))
	_validate_effect_owners()
	return errors.is_empty()


# --- tables ---------------------------------------------------------------

func _build_constants() -> void:
	constants = _key_values(_tables["constants"])
	economy = _key_values(_tables["economy"])


func _key_values(t: CsvTable) -> ConstantsDef:
	var kv := ConstantsDef.new()
	for i: int in t.rows.size():
		var row: Dictionary = t.rows[i]
		var line: int = t.line_numbers[i]
		var key: String = row["key"]
		if not _check_id(t, line, key, kv.values):
			continue
		var raw: String = row["value"]
		if "|" in raw:
			var list: Array = []
			for part: String in raw.split("|"):
				if not part.is_valid_float():
					_err("bad_number", t.file_name, line, "valor '%s' não é número" % raw)
				list.append(part.to_float())
			kv.values[key] = list
		elif raw.is_valid_float():
			kv.values[key] = raw.to_float()
		else:
			_err("bad_number", t.file_name, line, "valor '%s' não é número" % raw)
		kv.descriptions[key] = row["description"]
	return kv


func _build_conditions() -> void:
	var t: CsvTable = _tables["conditions"]
	for i: int in t.rows.size():
		var row: Dictionary = t.rows[i]
		var line: int = t.line_numbers[i]
		if not _check_id(t, line, row["id"], conditions):
			continue
		var d := ConditionDef.new()
		d.id = StringName(row["id"])
		d.kind = _enum(t, line, "kind", row, CONDITION_KINDS)
		d.polarity = _enum(t, line, "polarity", row, POLARITIES)
		d.max_stacks = _int(t, line, "max_stacks", row, 1, 99)
		d.stacking = _enum(t, line, "stacking", row, STACKING)
		d.decay = _enum(t, line, "decay", row, DECAY)
		d.tick = _enum(t, line, "tick", row, TICKS)
		d.consume_on = _enum(t, line, "consume_on", row, CONSUME_ON)
		d.resisted_by_will = _bool_word(t, line, "resisted_by_will", row)
		d.hook = StringName(row["hook"])
		d.icon = row["icon"]
		d.display_priority = _int(t, line, "display_priority", row, 1, 9)
		d.name_pt = row["name_pt"]
		d.desc_pt = row["desc_pt"]
		_require_text(t, line, "name_pt", row)
		conditions[row["id"]] = d


func _build_traits() -> void:
	var t: CsvTable = _tables["traits"]
	for i: int in t.rows.size():
		var row: Dictionary = t.rows[i]
		var line: int = t.line_numbers[i]
		if not _check_id(t, line, row["id"], traits):
			continue
		var d := TraitDef.new()
		d.id = StringName(row["id"])
		d.owner = StringName(row["owner"])
		d.name_pt = row["name_pt"]
		d.desc_pt = row["desc_pt"]
		d.trigger = _enum(t, line, "trigger", row, TRAIT_TRIGGERS)
		d.hook = StringName(row["hook"])
		_require_text(t, line, "hook", row)
		d.params = _kv(t, line, "params", row)
		traits[row["id"]] = d


func _build_camp_skills() -> void:
	var t: CsvTable = _tables["camp_skills"]
	for i: int in t.rows.size():
		var row: Dictionary = t.rows[i]
		var line: int = t.line_numbers[i]
		if not _check_id(t, line, row["id"], camp_skills):
			continue
		var d := CampSkillDef.new()
		d.id = StringName(row["id"])
		d.owner = StringName(row["owner"])
		d.name_pt = row["name_pt"]
		d.desc_pt = row["desc_pt"]
		d.effect = _enum(t, line, "effect", row, CAMP_EFFECTS)
		d.params = _kv(t, line, "params", row)
		camp_skills[row["id"]] = d


func _build_effects() -> void:
	var t: CsvTable = _tables["effects"]
	var orders_seen: Dictionary = {}
	for i: int in t.rows.size():
		var row: Dictionary = t.rows[i]
		var line: int = t.line_numbers[i]
		var owner_id: String = row["owner_id"]
		if owner_id.is_empty():
			_err("missing_value", t.file_name, line, "owner_id vazio")
			continue
		var d := EffectDef.new()
		d.order = _int(t, line, "order", row, 1, 99)
		var order_key: String = "%s#%d" % [owner_id, d.order]
		if orders_seen.has(order_key):
			_err("duplicate_order", t.file_name, line, "'%s' repete a ordem %d" % [owner_id, d.order])
		orders_seen[order_key] = true
		d.type = _enum(t, line, "type", row, EFFECT_TYPES)
		d.amount = _float_opt(t, line, "amount", row)
		d.damage_type = _enum(t, line, "damage_type", row, DAMAGE_TYPES, true)
		d.condition_id = StringName(row["condition_id"])
		d.stacks = _int_opt(t, line, "stacks", row, 0, 99)
		d.polarity = _enum(t, line, "polarity", row, POLARITIES, true)
		d.move_kind = _enum(t, line, "move_kind", row, MOVE_KINDS, true)
		d.n = _int_opt(t, line, "n", row, 0, MAX_ENEMY_SLOTS)
		d.summon_id = StringName(row["summon_id"])
		d.max_alive = _int_opt(t, line, "max_alive", row, 0, MAX_ENEMY_SLOTS)
		d.target_override = _enum(t, line, "target_override", row, TARGET_OVERRIDES, true)
		d.params = _kv(t, line, "params", row)
		for key: String in d.params:
			if not EFFECT_PARAMS.has(key):
				_err("unknown_param", t.file_name, line, "parâmetro '%s' desconhecido" % key)
		_validate_effect_fields(t, line, row, d)
		if not _effects_by_owner.has(owner_id):
			_effects_by_owner[owner_id] = []
		(_effects_by_owner[owner_id] as Array).append(d)
	for owner_id: String in _effects_by_owner:
		(_effects_by_owner[owner_id] as Array).sort_custom(func(a: EffectDef, b: EffectDef) -> bool: return a.order < b.order)


func _validate_effect_fields(t: CsvTable, line: int, row: Dictionary, d: EffectDef) -> void:
	var has_amount: bool = not String(row["amount"]).is_empty()
	match String(d.type):
		"damage":
			if not has_amount or d.amount <= 0.0:
				_err("missing_value", t.file_name, line, "damage precisa de amount > 0")
			if d.damage_type == &"":
				_err("missing_value", t.file_name, line, "damage precisa de damage_type")
		"heal", "gain_fervor", "light":
			if not has_amount or d.amount <= 0.0:
				_err("missing_value", t.file_name, line, "%s precisa de amount > 0" % d.type)
		"desolation":
			if not has_amount or d.amount == 0.0:
				_err("missing_value", t.file_name, line, "desolation precisa de amount diferente de 0")
		"apply_condition":
			if not conditions.has(String(d.condition_id)):
				_err("unknown_id", t.file_name, line, "condição '%s' não existe em conditions.csv" % d.condition_id)
			if d.stacks < 1:
				_err("missing_value", t.file_name, line, "apply_condition precisa de stacks >= 1")
		"remove_condition":
			if d.condition_id == &"" and d.polarity == &"":
				_err("missing_value", t.file_name, line, "remove_condition precisa de condition_id ou polarity")
			if d.condition_id != &"" and not conditions.has(String(d.condition_id)):
				_err("unknown_id", t.file_name, line, "condição '%s' não existe em conditions.csv" % d.condition_id)
			if d.stacks < 1:
				_err("missing_value", t.file_name, line, "remove_condition precisa de stacks >= 1")
		"move":
			if d.move_kind == &"" or d.n < 1:
				_err("missing_value", t.file_name, line, "move precisa de move_kind e n >= 1")
		"summon":
			if d.summon_id == &"" or d.max_alive < 1:
				_err("missing_value", t.file_name, line, "summon precisa de summon_id e max_alive >= 1")
		"revive":
			var fraction: float = float(d.params.get("hp_fraction", 0.0))
			if fraction <= 0.0 or fraction > 1.0:
				_err("out_of_range", t.file_name, line, "revive precisa de hp_fraction entre 0 e 1")
		"self_damage":
			if not has_amount and not d.params.has("hp_fraction"):
				_err("missing_value", t.file_name, line, "self_damage precisa de amount ou hp_fraction")
	if d.params.has("const"):
		var key: String = str(d.params["const"])
		if not constants.has_key(StringName(key)):
			_err("unknown_id", t.file_name, line, "constante '%s' não existe em constants.csv" % key)
		else:
			# The constant holds the size; the CSV amount keeps the sign
			# (Holy Water: -15 with holy_water_desolation = 15 lowers desolation).
			var size: float = absf(constants.get_float(StringName(key)))
			d.amount = -size if d.amount < 0.0 else size


func _build_abilities() -> void:
	var t: CsvTable = _tables["abilities"]
	for i: int in t.rows.size():
		var row: Dictionary = t.rows[i]
		var line: int = t.line_numbers[i]
		if not _check_id(t, line, row["id"], abilities):
			continue
		var d := AbilityDef.new()
		d.id = StringName(row["id"])
		d.owner = StringName(row["owner"])
		d.name_pt = row["name_pt"]
		_require_text(t, line, "name_pt", row)
		d.kind = _enum(t, line, "kind", row, ABILITY_KINDS)
		d.cost = _int(t, line, "cost", row, 0, 9)
		_validate_cost(t, line, d)
		d.use_slots = _int_list(t, line, "use_slots", row, 1, SAINT_SLOTS.size(), true)
		var targeting: String = row["targeting"]
		var match_n := RegEx.create_from_string("^chosen_enemy_slots\\((\\d+)\\)$").search(targeting)
		if match_n != null:
			d.targeting = &"chosen_enemy_slots"
			d.target_count = match_n.get_string(1).to_int()
			if d.target_count < 1 or d.target_count > MAX_ENEMY_SLOTS:
				_err("out_of_range", t.file_name, line, "chosen_enemy_slots(n) com n fora de 1..%d" % MAX_ENEMY_SLOTS)
		else:
			d.targeting = _enum(t, line, "targeting", row, ABILITY_TARGETING)
		var needs_slots: bool = ABILITY_ALLY_TARGETING.has(String(d.targeting)) or ABILITY_ENEMY_TARGETING.has(String(d.targeting))
		var max_slot: int = MAX_ENEMY_SLOTS if ABILITY_ENEMY_TARGETING.has(String(d.targeting)) else SAINT_SLOTS.size()
		d.target_slots = _int_list(t, line, "target_slots", row, 1, max_slot, needs_slots)
		d.allow_self = _flag(t, line, "allow_self", row)
		d.once_per_battle = _flag(t, line, "once_per_battle", row)
		d.origin = _enum(t, line, "origin", row, ORIGINS)
		d.upgrade = row["upgrade"]
		d.desc_pt = row["desc_pt"]
		d.effects.assign(_effects_by_owner.get(row["id"], []))
		if d.effects.is_empty():
			_err("missing_effects", t.file_name, line, "habilidade '%s' sem efeitos em effects.csv" % d.id)
		abilities[row["id"]] = d


func _validate_cost(t: CsvTable, line: int, d: AbilityDef) -> void:
	match String(d.kind):
		"basic":
			if d.cost > MAX_BASIC_COST:
				_err("bad_cost", t.file_name, line, "básica '%s' custa %d; o máximo é %d" % [d.id, d.cost, MAX_BASIC_COST])
		"fervor":
			if d.cost != FERVOR_COST:
				_err("bad_cost", t.file_name, line, "habilidade de Fervor '%s' custa %d; deve custar %d" % [d.id, d.cost, FERVOR_COST])
		"miracle":
			if d.cost < MIN_MIRACLE_COST or d.cost > MAX_MIRACLE_COST:
				_err("bad_cost", t.file_name, line, "milagre '%s' custa %d; deve custar de %d a %d" % [d.id, d.cost, MIN_MIRACLE_COST, MAX_MIRACLE_COST])


func _build_enemy_actions() -> void:
	var t: CsvTable = _tables["enemy_actions"]
	for i: int in t.rows.size():
		var row: Dictionary = t.rows[i]
		var line: int = t.line_numbers[i]
		if not _check_id(t, line, row["id"], enemy_actions):
			continue
		var d := EnemyActionDef.new()
		d.id = StringName(row["id"])
		d.priority = _int(t, line, "priority", row, 1, 99)
		d.use_slots = _int_list(t, line, "use_slots", row, 1, MAX_ENEMY_SLOTS, true)
		d.targeting = _enum(t, line, "targeting", row, ACTION_TARGETING)
		d.target_slots = _int_list(t, line, "target_slots", row, 1, SAINT_SLOTS.size(), d.targeting == &"single")
		d.target_rule = _enum(t, line, "target_rule", row, TARGET_RULES)
		d.conditions.assign(_action_conditions(t, line, row))
		d.cooldown = _int(t, line, "cooldown", row, 0, 99)
		d.intent_icon = _enum(t, line, "intent_icon", row, INTENT_ICONS)
		d.effects.assign(_effects_by_owner.get(row["id"], []))
		if d.effects.is_empty():
			_err("missing_effects", t.file_name, line, "ação '%s' sem efeitos em effects.csv" % d.id)
		enemy_actions[row["id"]] = d


func _action_conditions(t: CsvTable, line: int, row: Dictionary) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	var raw: String = row["conditions"]
	if raw.is_empty():
		_err("missing_value", t.file_name, line, "conditions vazio (use 'always')")
		return result
	for part: String in raw.split("|"):
		var pieces: PackedStringArray = part.split(":", true, 1)
		var cond_name: String = pieces[0].strip_edges()
		var param: Variant = null
		if ACTION_CONDITIONS_WITH_PARAM.has(cond_name):
			if pieces.size() < 2 or pieces[1].strip_edges().is_empty():
				_err("missing_value", t.file_name, line, "condição '%s' precisa de parâmetro" % cond_name)
			else:
				var p: String = pieces[1].strip_edges()
				if cond_name == "party_has_condition":
					if not conditions.has(p):
						_err("unknown_id", t.file_name, line, "condição '%s' não existe em conditions.csv" % p)
					param = p
				elif p.is_valid_int():
					param = p.to_int()
				else:
					_err("bad_number", t.file_name, line, "parâmetro de '%s' não é inteiro" % cond_name)
		elif ACTION_CONDITIONS_NO_PARAM.has(cond_name):
			if pieces.size() > 1:
				_err("unexpected_value", t.file_name, line, "condição '%s' não aceita parâmetro" % cond_name)
		else:
			_err("bad_enum", t.file_name, line, "condição de uso '%s' desconhecida" % cond_name)
			continue
		result.append({"name": cond_name, "param": param})
	return result


func _build_enemies() -> void:
	var t: CsvTable = _tables["enemies"]
	for i: int in t.rows.size():
		var row: Dictionary = t.rows[i]
		var line: int = t.line_numbers[i]
		if not _check_id(t, line, row["id"], enemies):
			continue
		var d := EnemyDef.new()
		d.id = StringName(row["id"])
		d.name_pt = row["name_pt"]
		_require_text(t, line, "name_pt", row)
		d.family = _enum(t, line, "family", row, FAMILIES)
		d.circles = _int_list(t, line, "circles", row, 0, 9, true)
		d.nature = _enum(t, line, "nature", row, NATURES)
		d.role = _enum(t, line, "role", row, ENEMY_ROLES)
		d.size = _int(t, line, "size", row, 1, 3)
		d.max_hp = _int(t, line, "max_hp", row, 1, 9999)
		d.armor = _int(t, line, "armor", row, 0, 3)
		for cond_id: String in _id_list(row["immune"]):
			if not conditions.has(cond_id):
				_err("unknown_id", t.file_name, line, "imunidade '%s' não existe em conditions.csv" % cond_id)
			d.immune.append(StringName(cond_id))
		d.leaves_remains = _flag(t, line, "leaves_remains", row)
		d.remains_rounds = _int_opt(t, line, "remains_rounds", row, 0, 99)
		if d.leaves_remains and d.remains_rounds < 1:
			_err("missing_value", t.file_name, line, "leaves_remains exige remains_rounds >= 1")
		var actions: Array[EnemyActionDef] = []
		for action_id: String in _id_list(row["actions"]):
			if not enemy_actions.has(action_id):
				_err("unknown_id", t.file_name, line, "ação '%s' não existe em enemy_actions.csv" % action_id)
			else:
				actions.append(enemy_actions[action_id])
		if actions.is_empty():
			_err("missing_value", t.file_name, line, "inimigo '%s' sem ações" % d.id)
		actions.sort_custom(func(a: EnemyActionDef, b: EnemyActionDef) -> bool: return a.priority < b.priority)
		d.actions = actions
		d.art_id = row["art_id"]
		enemies[row["id"]] = d
	# Summons can only be validated once every enemy exists.
	for owner_id: String in _effects_by_owner:
		for e: EffectDef in _effects_by_owner[owner_id]:
			if e.type == &"summon" and e.summon_id != &"" and not enemies.has(String(e.summon_id)):
				_err("unknown_id", "effects.csv", 0, "'%s' invoca '%s', que não existe em enemies.csv" % [owner_id, e.summon_id])


func _build_encounters() -> void:
	var t: CsvTable = _tables["encounters"]
	for i: int in t.rows.size():
		var row: Dictionary = t.rows[i]
		var line: int = t.line_numbers[i]
		if not _check_id(t, line, row["id"], encounters):
			continue
		var d := EncounterDef.new()
		d.id = StringName(row["id"])
		if row["circle"] == "m0":
			d.circle = EncounterDef.ARENA_CIRCLE
		else:
			d.circle = _int(t, line, "circle", row, 0, 9)
		d.pool = _enum(t, line, "pool", row, POOLS)
		d.type = _enum(t, line, "type", row, ENCOUNTER_TYPES)
		var gap := false
		var total_size := 0
		for slot: int in range(1, MAX_ENEMY_SLOTS + 1):
			var enemy_id: String = row["slot_%d" % slot]
			if enemy_id.is_empty():
				gap = true
				continue
			if gap:
				_err("slot_gap", t.file_name, line, "posição %d preenchida depois de uma vazia" % slot)
			if not enemies.has(enemy_id):
				_err("unknown_id", t.file_name, line, "inimigo '%s' não existe em enemies.csv" % enemy_id)
			else:
				total_size += (enemies[enemy_id] as EnemyDef).size
			d.slots.append(StringName(enemy_id))
		if d.slots.is_empty():
			_err("missing_value", t.file_name, line, "encontro '%s' sem inimigos" % d.id)
		if total_size > MAX_ENEMY_SLOTS:
			_err("out_of_range", t.file_name, line, "inimigos ocupam %d posições; o máximo é %d" % [total_size, MAX_ENEMY_SLOTS])
		encounters[row["id"]] = d


func _build_provisions() -> void:
	var t: CsvTable = _tables["provisions"]
	for i: int in t.rows.size():
		var row: Dictionary = t.rows[i]
		var line: int = t.line_numbers[i]
		if not _check_id(t, line, row["id"], provisions):
			continue
		var d := ProvisionDef.new()
		d.id = StringName(row["id"])
		d.name_pt = row["name_pt"]
		_require_text(t, line, "name_pt", row)
		d.price = _int(t, line, "price", row, 0, 99999)
		d.usable_in_battle = _flag(t, line, "usable_in_battle", row)
		d.targeting = _enum(t, line, "targeting", row, PROVISION_TARGETING)
		var effects: Array[EffectDef] = []
		for effect_owner: String in _id_list(row["effect_ids"]):
			_provision_effect_owners[effect_owner] = true
			if not _effects_by_owner.has(effect_owner):
				_err("unknown_id", t.file_name, line, "efeito '%s' não existe em effects.csv" % effect_owner)
			else:
				for e: EffectDef in _effects_by_owner[effect_owner]:
					effects.append(e)
		if effects.is_empty():
			_err("missing_effects", t.file_name, line, "provisão '%s' sem efeitos" % d.id)
		d.effects = effects
		provisions[row["id"]] = d


## Reserve legs (expedition §2.1): one row per node, grouped by `id`. Layers
## and indexes start at 1 and 0 with no gaps; `links` are indexes in the next
## layer. The finished template must pass the same path rules as a
## generated leg.
func _build_map_templates() -> void:
	var t: CsvTable = _tables["map_templates"]
	var rows_by_id: Dictionary = {}
	var first_line: Dictionary = {}
	for i: int in t.rows.size():
		var row: Dictionary = t.rows[i]
		var line: int = t.line_numbers[i]
		var id: String = row["id"]
		if id.is_empty() or _id_pattern.search(id) == null:
			_err("bad_id", t.file_name, line, "ID '%s' fora do padrão snake_case" % id)
			continue
		if not rows_by_id.has(id):
			rows_by_id[id] = []
			first_line[id] = line
		(rows_by_id[id] as Array).append([line, row])
	for id: String in rows_by_id:
		var d := MapTemplateDef.new()
		d.id = StringName(id)
		var cells: Dictionary = {}
		var leg: int = 0
		for entry: Array in rows_by_id[id]:
			var line: int = entry[0]
			var row: Dictionary = entry[1]
			var row_leg: int = _int(t, line, "leg", row, 1, MapGenerator.LEG_RULES.size())
			if leg == 0:
				leg = row_leg
			elif row_leg != leg:
				_err("out_of_range", t.file_name, line, "trecho %d diferente do resto do modelo '%s'" % [row_leg, id])
			var layer: int = _int(t, line, "layer", row, 1, 9)
			var index: int = _int(t, line, "index", row, 0, MapGenerator.MAX_NODES - 1)
			var key: String = "%d_%d" % [layer, index]
			if cells.has(key):
				_err("duplicate_id", t.file_name, line, "nó repetido: camada %d, posição %d" % [layer, index])
				continue
			cells[key] = {
				"role": _enum(t, line, "role", row, MAP_ROLES),
				"type": _enum(t, line, "type", row, MAP_NODE_TYPES),
				"links": _int_list(t, line, "links", row, 0, MapGenerator.MAX_NODES - 1, false),
				"line": line,
			}
		d.leg = maxi(leg, 1)
		var layer_number: int = 1
		while cells.has("%d_0" % layer_number):
			var layer_list: Array = []
			var node_index: int = 0
			while cells.has("%d_%d" % [layer_number, node_index]):
				var cell: Dictionary = cells["%d_%d" % [layer_number, node_index]]
				layer_list.append({"role": cell["role"], "type": cell["type"], "links": Array(cell["links"])})
				cells.erase("%d_%d" % [layer_number, node_index])
				node_index += 1
			d.layers.append(layer_list)
			layer_number += 1
		for key: String in cells:
			_err("slot_gap", t.file_name, int(cells[key]["line"]), "nó fora da sequência de camadas e posições (%s)" % key)
		if not MapGenerator.is_valid(LegMap.from_template(d)):
			_err("invalid_template", t.file_name, int(first_line[id]), "o modelo '%s' não cumpre as regras de caminho do trecho %d" % [id, d.leg])
		map_templates[id] = d


## Starting provisions (D-123): one row per provision, grouped by kit id, in
## row order. A kit never holds more than the gate level 1 pack.
func _build_starting_kits() -> void:
	var t: CsvTable = _tables["starting_kits"]
	for i: int in t.rows.size():
		var row: Dictionary = t.rows[i]
		var line: int = t.line_numbers[i]
		var id: String = row["id"]
		if id.is_empty() or _id_pattern.search(id) == null:
			_err("bad_id", t.file_name, line, "ID '%s' fora do padrão snake_case" % id)
			continue
		if not starting_kits.has(id):
			var kit := StartingKitDef.new()
			kit.id = StringName(id)
			starting_kits[id] = kit
		var provision_id: String = row["provision_id"]
		if not provisions.has(provision_id):
			_err("unknown_id", t.file_name, line, "provisão '%s' não existe em provisions.csv" % provision_id)
			continue
		var amount: int = _int(t, line, "amount", row, 1, 99)
		var d: StartingKitDef = starting_kits[id]
		for n: int in amount:
			d.provisions.append(StringName(provision_id))
		if constants.has_key(&"gate_slots_l1") and d.provisions.size() > constants.get_int(&"gate_slots_l1"):
			_err("out_of_range", t.file_name, line, "o kit '%s' passa de %d provisões (espaços do Portão nível 1)" % [id, constants.get_int(&"gate_slots_l1")])


func _build_saints() -> void:
	var t: CsvTable = _tables["saints"]
	for i: int in t.rows.size():
		var row: Dictionary = t.rows[i]
		var line: int = t.line_numbers[i]
		if not _check_id(t, line, row["id"], saints):
			continue
		var d := SaintDef.new()
		d.id = StringName(row["id"])
		d.name_pt = row["name_pt"]
		_require_text(t, line, "name_pt", row)
		for role: String in _enum_list(t, line, "roles", row, ROLES, true):
			d.roles.append(StringName(role))
		d.preferred_slots = _int_list(t, line, "preferred_slots", row, 1, SAINT_SLOTS.size(), true)
		d.max_hp = _int(t, line, "max_hp", row, 1, 999)
		d.armor = _int(t, line, "armor", row, 0, 3)
		d.faith = _int(t, line, "faith", row, 0, 10)
		d.will = _int(t, line, "will", row, 0, 3)
		d.hp_per_level = _int(t, line, "hp_per_level", row, 0, 99)
		d.faith_per_level = _int(t, line, "faith_per_level", row, 0, 10)
		for ability_id: String in _id_list(row["abilities"]):
			d.abilities.append(StringName(ability_id))
		for ability_id: String in _id_list(row["default_equipped"]):
			d.default_equipped.append(StringName(ability_id))
		d.miracle = StringName(row["miracle"])
		var trait_id: String = row["trait"]
		if not traits.has(trait_id):
			_err("unknown_id", t.file_name, line, "traço '%s' não existe em traits.csv" % trait_id)
		else:
			d.trait_def = traits[trait_id]
			if d.trait_def.owner != d.id:
				_err("wrong_owner", t.file_name, line, "traço '%s' pertence a '%s'" % [trait_id, d.trait_def.owner])
		var camp_id: String = row["camp_skill"]
		if not camp_skills.has(camp_id):
			_err("unknown_id", t.file_name, line, "atividade de Pouso '%s' não existe em camp_skills.csv" % camp_id)
		else:
			d.camp_skill = camp_skills[camp_id]
			if d.camp_skill.owner != d.id:
				_err("wrong_owner", t.file_name, line, "atividade '%s' pertence a '%s'" % [camp_id, d.camp_skill.owner])
		for affinity: String in _enum_list(t, line, "affinities", row, AFFINITIES, false):
			d.affinities.append(StringName(affinity))
		d.unlock = row["unlock"]
		if not RegEx.create_from_string("^(start|carmel|(week|circle|milestone):\\d+)$").search(d.unlock):
			_err("bad_enum", t.file_name, line, "unlock '%s' inválido" % d.unlock)
		d.m0 = _flag(t, line, "m0", row)
		_validate_saint_kit(t, line, d)
		saints[row["id"]] = d
	_validate_orphan_abilities()


func _validate_saint_kit(t: CsvTable, line: int, d: SaintDef) -> void:
	var file: String = t.file_name
	var kit: Array[AbilityDef] = []
	for ability_id: StringName in d.abilities:
		var a: AbilityDef = abilities.get(String(ability_id))
		if a == null:
			_err("unknown_id", file, line, "habilidade '%s' não existe em abilities.csv" % ability_id)
			continue
		if a.owner != d.id:
			_err("wrong_owner", file, line, "habilidade '%s' pertence a '%s'" % [ability_id, a.owner])
		kit.append(a)
	if d.abilities.size() != ABILITIES_PER_SAINT:
		_err("kit_size", file, line, "'%s' tem %d habilidades; devem ser %d" % [d.id, d.abilities.size(), ABILITIES_PER_SAINT])
	var basics: int = kit.filter(func(a: AbilityDef) -> bool: return a.kind == &"basic").size()
	var fervors: int = kit.filter(func(a: AbilityDef) -> bool: return a.kind == &"fervor").size()
	if basics != BASICS_PER_SAINT or fervors != FERVOR_PER_SAINT:
		_err("kit_size", file, line, "'%s' tem %d básicas e %d de Fervor; devem ser %d e %d" % [d.id, basics, fervors, BASICS_PER_SAINT, FERVOR_PER_SAINT])
	var any_slot_basic := false
	var damaging_basic := false
	for a: AbilityDef in kit:
		if a.kind != &"basic":
			continue
		if a.cost == 0 and SAINT_SLOTS.all(func(s: int) -> bool: return a.use_slots.has(s)):
			any_slot_basic = true
		if a.effects.any(func(e: EffectDef) -> bool: return e.type == &"damage"):
			damaging_basic = true
	if not any_slot_basic:
		_err("missing_any_slot_basic", file, line, "'%s' não tem básica de custo 0 utilizável de qualquer posição (combat.md §2.5)" % d.id)
	if not damaging_basic:
		_err("missing_damage_basic", file, line, "'%s' não tem básica que cause dano (GDD P5)" % d.id)
	if d.default_equipped.size() != EQUIPPED_PER_SAINT:
		_err("kit_size", file, line, "'%s' equipa %d habilidades; devem ser %d" % [d.id, d.default_equipped.size(), EQUIPPED_PER_SAINT])
	var has_free := false
	for ability_id: StringName in d.default_equipped:
		if not d.abilities.has(ability_id):
			_err("not_in_kit", file, line, "default_equipped '%s' não está em abilities do santo" % ability_id)
			continue
		var a: AbilityDef = abilities.get(String(ability_id))
		if a != null and a.cost == 0:
			has_free = true
	if not has_free:
		_err("missing_free_equipped", file, line, "'%s' não equipa nenhuma habilidade de custo 0 (Noite Escura)" % d.id)
	var miracle: AbilityDef = abilities.get(String(d.miracle))
	if miracle == null:
		_err("unknown_id", file, line, "milagre '%s' não existe em abilities.csv" % d.miracle)
	else:
		if miracle.kind != &"miracle":
			_err("not_miracle", file, line, "'%s' não é do tipo miracle" % d.miracle)
		if miracle.owner != d.id:
			_err("wrong_owner", file, line, "milagre '%s' pertence a '%s'" % [d.miracle, miracle.owner])


func _validate_orphan_abilities() -> void:
	var t: CsvTable = _tables["abilities"]
	for i: int in t.rows.size():
		var ability_id: String = t.rows[i]["id"]
		var a: AbilityDef = abilities.get(ability_id)
		if a == null:
			continue
		var s: SaintDef = saints.get(String(a.owner))
		if s == null:
			_err("unknown_id", t.file_name, t.line_numbers[i], "dono '%s' não existe em saints.csv" % a.owner)
		elif not s.abilities.has(a.id) and s.miracle != a.id:
			_err("orphan", t.file_name, t.line_numbers[i], "'%s' não está no kit de '%s'" % [a.id, a.owner])


func _validate_effect_owners() -> void:
	for owner_id: String in _effects_by_owner:
		if abilities.has(owner_id) or enemy_actions.has(owner_id) or _provision_effect_owners.has(owner_id):
			continue
		_err("unknown_id", "effects.csv", 0, "owner_id '%s' não é habilidade, ação inimiga nem provisão" % owner_id)


func _build_ui_text() -> void:
	ui_text = UiTextDef.new()
	var t: CsvTable = _tables["ui_text"]
	for i: int in t.rows.size():
		var row: Dictionary = t.rows[i]
		var line: int = t.line_numbers[i]
		if not _check_id(t, line, row["id"], ui_text.texts):
			continue
		_require_text(t, line, "text_pt", row)
		ui_text.texts[String(row["id"])] = String(row["text_pt"])


# --- narrative events (T23, narrative-system §3, ADR-0012) -----------------

## `files` maps a file name (for messages) to YAML text.
func _build_events(files: Dictionary) -> void:
	var names: Array = files.keys()
	names.sort()
	for file: Variant in names:
		var reader := EventYaml.new()
		var raw: Dictionary = reader.parse(files[file], str(file))
		errors.append_array(reader.errors)
		if not reader.errors.is_empty():
			continue
		var d: EventDef = _event_from(raw, str(file))
		if d == null:
			continue
		if events.has(String(d.id)):
			_err("duplicate_id", str(file), 0, "evento '%s' repetido" % d.id)
			continue
		events[String(d.id)] = d


func _event_from(raw: Dictionary, file: String) -> EventDef:
	var d := EventDef.new()
	var id: String = str(raw.get("id", ""))
	if id.is_empty() or _id_pattern.search(id) == null:
		_err("bad_id", file, 0, "ID '%s' fora do padrão snake_case" % id)
		return null
	d.id = StringName(id)
	d.type = StringName(_event_enum(raw, "type", EVENT_TYPES, file))
	d.origin = StringName(_event_enum(raw, "origin", ORIGINS, file))
	d.circle = int(raw.get("circle", 0))
	d.title_pt = str(raw.get("title_pt", ""))
	if d.title_pt.is_empty():
		_err("missing_value", file, 0, "title_pt vazio")
	for page: Variant in _as_list(raw.get("pages")):
		if not page is Dictionary or str((page as Dictionary).get("text_pt", "")).is_empty():
			_err("missing_value", file, 0, "página sem text_pt")
			continue
		d.pages.append({"speaker": str(page.get("speaker", "narrator")), "text_pt": str(page["text_pt"])})
	d.requirements = _event_requirements(raw.get("requirements"), file)
	var seen: Dictionary = {}
	var has_safe := false
	for raw_option: Variant in _as_list(raw.get("options")):
		if not raw_option is Dictionary:
			_err("bad_yaml", file, 0, "opção precisa ser um mapa")
			continue
		var o: Dictionary = _event_option(raw_option, file)
		if seen.has(o["id"]):
			_err("duplicate_id", file, 0, "opção '%s' repetida" % o["id"])
		seen[o["id"]] = true
		has_safe = has_safe or bool(o["safe"])
		d.options.append(o)
	if d.options.is_empty():
		_err("missing_value", file, 0, "evento sem opções")
	if d.type == &"temptation" and not has_safe:
		_err("no_safe_option", file, 0, "toda Tentação precisa de uma opção segura (safe: true)")
	return d


func _event_option(raw: Dictionary, file: String) -> Dictionary:
	var id: String = str(raw.get("id", ""))
	if id.is_empty() or _id_pattern.search(id) == null:
		_err("bad_id", file, 0, "opção com ID '%s' fora do padrão" % id)
	if str(raw.get("text_pt", "")).is_empty():
		_err("missing_value", file, 0, "opção '%s' sem text_pt" % id)
	var o: Dictionary = {
		"id": id, "text_pt": str(raw.get("text_pt", "")), "safe": raw.get("safe", false) == true,
		"requires": _event_requirements(raw.get("requires"), file),
		"chance": {}, "outcomes": _event_outcomes(raw.get("outcomes"), file),
		"on_success": _event_outcomes(raw.get("on_success"), file),
		"on_failure": _event_outcomes(raw.get("on_failure"), file),
	}
	var chance: Variant = raw.get("chance")
	if chance is Dictionary:
		var base: Variant = (chance as Dictionary).get("base")
		if not (base is float or base is int) or float(base) < 0.0 or float(base) > 1.0:
			_err("out_of_range", file, 0, "opção '%s': chance.base deve ir de 0 a 1" % id)
		var modifiers: Array = []
		for m: Variant in _as_list((chance as Dictionary).get("modifiers")):
			if not m is Dictionary or not CHANCE_MODIFIERS.has(str(m.get("if", ""))) or not (m.get("add") is float or m.get("add") is int):
				_err("bad_enum", file, 0, "opção '%s': modificador inválido %s" % [id, m])
				continue
			_check_event_reference(str(m["if"]), str(m.get("id", "")), file)
			modifiers.append({"if": str(m["if"]), "id": str(m.get("id", "")), "add": float(m["add"]), "consume": m.get("consume", false) == true})
		if modifiers.is_empty():
			_err("chance_without_modifier", file, 0, "opção '%s': toda chance precisa poder ser melhorada por um santo, provisão ou relíquia" % id)
		o["chance"] = {"base": float(base) if (base is float or base is int) else 0.0, "modifiers": modifiers}
	elif chance != null:
		_err("bad_yaml", file, 0, "opção '%s': chance precisa ser um mapa" % id)
	return o


func _event_requirements(raw: Variant, file: String) -> Array:
	var result: Array = []
	for r: Variant in _as_list(raw):
		if not r is Dictionary or not EVENT_REQUIREMENTS.has(str(r.get("type", ""))):
			_err("bad_enum", file, 0, "requisito inválido %s" % [r])
			continue
		var kind: String = str(r["type"])
		_check_event_reference(kind, str(r.get("id", "")), file)
		result.append({"type": kind, "id": str(r.get("id", "")), "value": float(r.get("value", 0))})
	return result


func _event_outcomes(raw: Variant, file: String) -> Array:
	var result: Array = []
	for r: Variant in _as_list(raw):
		if not r is Dictionary or not EVENT_OUTCOMES.has(str(r.get("type", ""))):
			_err("bad_enum", file, 0, "resultado inválido %s" % [r])
			continue
		var kind: String = str(r["type"])
		var out: Dictionary = {"type": kind, "id": str(r.get("id", "")), "target": str(r.get("target", "")), "amount": float(r.get("amount", 0))}
		if kind == "virtue" or kind == "provisions" or kind == "start_battle":
			_check_event_reference(kind, out["id"], file)
		if kind == "desolation" and out["target"] != "party" and not saints.has(out["target"]):
			_err("unknown_id", file, 0, "desolação com alvo '%s' (use party ou um santo)" % out["target"])
		result.append(out)
	return result


func _check_event_reference(kind: String, id: String, file: String) -> void:
	var known := true
	match kind:
		"saint_in_party":
			known = saints.has(id)
		"provision", "provisions":
			known = provisions.has(id)
		"virtue", "virtue_at_least":
			known = VIRTUES.has(id)
		"start_battle":
			known = encounters.has(id)
	if not known:
		_err("unknown_id", file, 0, "'%s' não existe (%s)" % [id, kind])


func _event_enum(raw: Dictionary, key: String, allowed: Array[String], file: String) -> String:
	var value: String = str(raw.get(key, ""))
	if not allowed.has(value):
		_err("bad_enum", file, 0, "%s '%s' inválido; aceitos: %s" % [key, value, ", ".join(allowed)])
	return value


static func _as_list(value: Variant) -> Array:
	return value if value is Array else []


# --- parsing helpers ------------------------------------------------------

func _err(code: String, file: String, line: int, message: String) -> void:
	if line > 0:
		errors.append("%s linha %d [%s]: %s" % [file, line, code, message])
	else:
		errors.append("%s [%s]: %s" % [file, code, message])


func _check_id(t: CsvTable, line: int, id: String, seen: Dictionary) -> bool:
	if id.is_empty():
		_err("missing_value", t.file_name, line, "ID vazio")
		return false
	if _id_pattern.search(id) == null:
		_err("bad_id", t.file_name, line, "ID '%s' fora do padrão snake_case" % id)
	if seen.has(id):
		_err("duplicate_id", t.file_name, line, "ID '%s' repetido" % id)
		return false
	return true


func _require_text(t: CsvTable, line: int, column: String, row: Dictionary) -> void:
	if String(row[column]).is_empty():
		_err("missing_value", t.file_name, line, "%s vazio" % column)


func _int(t: CsvTable, line: int, column: String, row: Dictionary, low: int, high: int) -> int:
	var raw: String = row[column]
	if not raw.is_valid_int():
		_err("bad_number", t.file_name, line, "%s '%s' não é inteiro" % [column, raw])
		return low
	var value: int = raw.to_int()
	if value < low or value > high:
		_err("out_of_range", t.file_name, line, "%s = %d fora de %d..%d" % [column, value, low, high])
	return value


func _int_opt(t: CsvTable, line: int, column: String, row: Dictionary, low: int, high: int) -> int:
	if String(row[column]).is_empty():
		return 0
	return _int(t, line, column, row, low, high)


func _float_opt(t: CsvTable, line: int, column: String, row: Dictionary) -> float:
	var raw: String = row[column]
	if raw.is_empty():
		return 0.0
	if not raw.is_valid_float():
		_err("bad_number", t.file_name, line, "%s '%s' não é número" % [column, raw])
		return 0.0
	return raw.to_float()


func _int_list(t: CsvTable, line: int, column: String, row: Dictionary, low: int, high: int, required: bool) -> Array[int]:
	var result: Array[int] = []
	var raw: String = row[column]
	if raw.is_empty():
		if required:
			_err("missing_value", t.file_name, line, "%s vazio" % column)
		return result
	for part: String in raw.split("|"):
		if not part.is_valid_int():
			_err("bad_number", t.file_name, line, "%s contém '%s', que não é inteiro" % [column, part])
			continue
		var value: int = part.to_int()
		if value < low or value > high:
			_err("out_of_range", t.file_name, line, "%s contém %d, fora de %d..%d" % [column, value, low, high])
		if result.has(value):
			_err("duplicate_value", t.file_name, line, "%s repete %d" % [column, value])
		result.append(value)
	return result


func _id_list(raw: String) -> Array[String]:
	var result: Array[String] = []
	if raw.is_empty():
		return result
	for part: String in raw.split("|"):
		result.append(part.strip_edges())
	return result


func _enum(t: CsvTable, line: int, column: String, row: Dictionary, allowed: Array[String], allow_empty: bool = false) -> StringName:
	var raw: String = row[column]
	if raw.is_empty():
		if not allow_empty:
			_err("missing_value", t.file_name, line, "%s vazio" % column)
		return &""
	if not allowed.has(raw):
		_err("bad_enum", t.file_name, line, "%s '%s' inválido; aceitos: %s" % [column, raw, ", ".join(allowed)])
	return StringName(raw)


func _enum_list(t: CsvTable, line: int, column: String, row: Dictionary, allowed: Array[String], required: bool) -> Array[String]:
	var values: Array[String] = _id_list(row[column])
	if values.is_empty() and required:
		_err("missing_value", t.file_name, line, "%s vazio" % column)
	for v: String in values:
		if not allowed.has(v):
			_err("bad_enum", t.file_name, line, "%s '%s' inválido; aceitos: %s" % [column, v, ", ".join(allowed)])
	return values


func _flag(t: CsvTable, line: int, column: String, row: Dictionary) -> bool:
	var raw: String = row[column]
	if raw == "y":
		return true
	if not raw.is_empty():
		_err("bad_flag", t.file_name, line, "%s deve ser 'y' ou vazio, não '%s'" % [column, raw])
	return false


func _bool_word(t: CsvTable, line: int, column: String, row: Dictionary) -> bool:
	var raw: String = row[column]
	if raw == "true":
		return true
	if raw != "false":
		_err("bad_flag", t.file_name, line, "%s deve ser 'true' ou 'false', não '%s'" % [column, raw])
	return false


## "a=1;b=x" -> {"a": 1.0, "b": "x"}. Numbers become float; everything else stays text.
func _kv(t: CsvTable, line: int, column: String, row: Dictionary) -> Dictionary:
	var result: Dictionary = {}
	var raw: String = row[column]
	if raw.is_empty():
		return result
	for pair: String in raw.split(";"):
		var pieces: PackedStringArray = pair.split("=", true, 1)
		if pieces.size() != 2 or pieces[0].strip_edges().is_empty():
			_err("bad_params", t.file_name, line, "%s: '%s' não está no formato chave=valor" % [column, pair])
			continue
		var key: String = pieces[0].strip_edges()
		var value: String = pieces[1].strip_edges()
		result[key] = value.to_float() if value.is_valid_float() else value
	return result
