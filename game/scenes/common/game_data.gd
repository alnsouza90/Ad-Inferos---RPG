class_name GameData
extends RefCounted
## The generated Resources of res://data, loaded once for the screens: battle
## catalog, saints, encounters and interface texts. Presentation-side (it reads
## files), so core never sees it.

## The M0 party in formation order (GDD §3, D-308): George in the vanguard,
## Benedict in the centre, Therese in the rear.
const M0_FORMATION: Array[StringName] = [&"saint_george", &"saint_benedict", &"saint_therese"]

var catalog: BattleCatalog
var saints: Dictionary = {}
var encounters: Dictionary = {}
var ui: UiTextDef


static func create(p_catalog: BattleCatalog, p_saints: Dictionary, p_encounters: Dictionary, p_ui: UiTextDef) -> GameData:
	var d := GameData.new()
	d.catalog = p_catalog
	d.saints = p_saints
	d.encounters = p_encounters
	d.ui = p_ui
	return d


static func load_all() -> GameData:
	var constants: ConstantsDef = load("res://data/constants.tres")
	var catalog := BattleCatalog.create(constants, _folder("conditions"), _folder("abilities"), _folder("provisions"), _folder("enemies"))
	return create(catalog, _folder("saints"), _folder("encounters"), load("res://data/ui_text.tres") as UiTextDef)


func m0_party() -> Array[SaintDef]:
	var party: Array[SaintDef] = []
	for id: StringName in M0_FORMATION:
		party.append(saints[id])
	return party


## A fresh battle of `encounter_id` with the M0 party.
func battle(encounter_id: StringName, seed: int, provisions: Array[StringName] = []) -> BattleState:
	var enc: EncounterDef = encounters[encounter_id]
	var foes: Array[EnemyDef] = []
	for enemy_id: StringName in enc.slots:
		foes.append(catalog.enemies[enemy_id])
	return BattleState.create(catalog, m0_party(), foes, provisions, enc.type, seed)


func saint_def(id: StringName) -> SaintDef:
	return saints.get(id)


func display_name(c: Combatant) -> String:
	if c.is_saint():
		var s: SaintDef = saints.get(c.def_id)
		return s.name_pt if s != null else String(c.id)
	var e: EnemyDef = catalog.enemies.get(c.def_id)
	return e.name_pt if e != null else String(c.id)


static func _folder(folder: String) -> Dictionary:
	var result: Dictionary = {}
	var path: String = "res://data/".path_join(folder)
	var dir := DirAccess.open(path)
	if dir == null:
		return result
	for file: String in dir.get_files():
		# Exported builds list converted resources as *.tres.remap.
		var file_name: String = file.trim_suffix(".remap")
		if file_name.ends_with(".tres"):
			var res: Resource = load(path.path_join(file_name))
			result[StringName(res.get("id"))] = res
	return result
