extends GutTest
## Data tests (testing.md §1): the real docs/balance CSVs must import cleanly
## and the generated game/data files must match them.


func test_real_csvs_import_without_errors() -> void:
	var importer := BalanceImporter.new()
	var ok: bool = importer.import_tables(BalanceExporter.read_tables(BalanceExporter.default_source_dir()))
	assert_true(ok, "Erros: %s" % [importer.errors])


func test_m0_party_and_encounters_exist() -> void:
	var importer := BalanceImporter.new()
	importer.import_tables(BalanceExporter.read_tables(BalanceExporter.default_source_dir()))
	var m0_saints: Array = importer.saints.values().filter(func(s: SaintDef) -> bool: return s.m0)
	assert_eq(m0_saints.size(), 3, "M0 usa Jorge, Bento e Teresinha")
	var arena: Array = importer.encounters.values().filter(func(e: EncounterDef) -> bool: return e.circle == EncounterDef.ARENA_CIRCLE)
	assert_eq(arena.size(), 4, "4 encontros m0_*")


func test_generated_data_matches_csvs() -> void:
	var exporter := BalanceExporter.new()
	var ok: bool = exporter.run(BalanceExporter.default_source_dir(), true)
	assert_true(ok, "game/data desatualizado; rode tools/data/import_balance.gd. %s" % [exporter.errors])
