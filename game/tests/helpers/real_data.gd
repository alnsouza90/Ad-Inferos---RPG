class_name RealData
extends RefCounted
## Builds battles from the real docs/balance CSVs (through the importer) for
## integration tests that need real kits and enemies (testing.md §1).

static var _importer: BalanceImporter


static func importer() -> BalanceImporter:
	if _importer == null:
		_importer = BalanceImporter.new()
		var ok: bool = _importer.import_tables(BalanceExporter.read_tables(BalanceExporter.default_source_dir()))
		assert(ok, "CSV import failed: %s" % [_importer.errors])
	return _importer


static func catalog() -> BattleCatalog:
	var imp := importer()
	return BattleCatalog.create(imp.constants, _keys(imp.conditions), _keys(imp.abilities), _keys(imp.provisions), _keys(imp.enemies))


static func m0_party() -> Array[SaintDef]:
	var imp := importer()
	return [imp.saints["saint_george"], imp.saints["saint_benedict"], imp.saints["saint_therese"]] as Array[SaintDef]


static func m0_encounter_ids() -> Array[String]:
	var ids: Array[String] = []
	for id: String in importer().encounters:
		if (importer().encounters[id] as EncounterDef).circle == EncounterDef.ARENA_CIRCLE:
			ids.append(id)
	ids.sort()
	return ids


static func battle(encounter_id: String, seed: int, provisions: Array[StringName] = []) -> BattleState:
	var enc: EncounterDef = importer().encounters[encounter_id]
	var foes: Array[EnemyDef] = []
	for enemy_id: StringName in enc.slots:
		foes.append(importer().enemies[String(enemy_id)])
	return BattleState.create(catalog(), m0_party(), foes, provisions, enc.type, seed)


## The screens' data bundle (GameData) built from the CSVs, not game/data.
static func game_data() -> GameData:
	var imp := importer()
	return GameData.create(catalog(), _keys(imp.saints), _keys(imp.encounters), imp.ui_text)


static func _keys(d: Dictionary) -> Dictionary:
	var result: Dictionary = {}
	for key: String in d:
		result[StringName(key)] = d[key]
	return result
