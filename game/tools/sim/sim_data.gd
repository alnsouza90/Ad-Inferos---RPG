class_name SimData
extends RefCounted
## Loads the generated Resources in res://data (the same data the game uses)
## into a BattleCatalog plus the saint and encounter definitions.

var catalog: BattleCatalog
var saints: Dictionary = {}
var encounters: Dictionary = {}


static func create(p_catalog: BattleCatalog, p_saints: Dictionary, p_encounters: Dictionary) -> SimData:
	var d := SimData.new()
	d.catalog = p_catalog
	d.saints = p_saints
	d.encounters = p_encounters
	return d


static func load_all() -> SimData:
	var d := SimData.new()
	var constants: ConstantsDef = load("res://data/constants.tres")
	d.catalog = BattleCatalog.create(constants, _folder("conditions"), _folder("abilities"), _folder("provisions"), _folder("enemies"))
	d.saints = _folder("saints")
	d.encounters = _folder("encounters")
	return d


func encounter_ids(prefix: String) -> Array[String]:
	var ids: Array[String] = []
	for id: StringName in encounters:
		if String(id).begins_with(prefix):
			ids.append(String(id))
	ids.sort()
	return ids


## The M0 party in formation order (GDD §3: George in the vanguard,
## Benedict in the centre, Therese in the rear).
const M0_FORMATION: Array[StringName] = [&"saint_george", &"saint_benedict", &"saint_therese"]


func m0_party() -> Array[SaintDef]:
	var party: Array[SaintDef] = []
	for id: StringName in M0_FORMATION:
		party.append(saints[id])
	return party


func battle(encounter_id: String, seed: int) -> BattleState:
	var enc: EncounterDef = encounters[StringName(encounter_id)]
	var foes: Array[EnemyDef] = []
	for enemy_id: StringName in enc.slots:
		foes.append(catalog.enemies[enemy_id])
	return BattleState.create(catalog, m0_party(), foes, [] as Array[StringName], enc.type, seed)


static func _folder(folder: String) -> Dictionary:
	var result: Dictionary = {}
	var path: String = "res://data/".path_join(folder)
	var dir := DirAccess.open(path)
	if dir == null:
		return result
	for file: String in dir.get_files():
		var file_name: String = file.trim_suffix(".remap")
		if file_name.ends_with(".tres"):
			var res: Resource = load(path.path_join(file_name))
			result[StringName(res.get("id"))] = res
	return result
