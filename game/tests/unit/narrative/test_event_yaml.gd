extends GutTest
## T23: the YAML subset of the event files (ADR-0012).


func _parse(text: String) -> Dictionary:
	var r := EventYaml.new()
	var d: Dictionary = r.parse(text, "t.yaml")
	assert_eq(r.errors, [] as Array[String])
	return d


func test_maps_lists_and_flow_maps() -> void:
	var d := _parse("id: x\ncircle: 2\noptions:\n  - id: a\n    safe: true\n    outcomes:\n      - { type: light, amount: -5 }\n  - id: b\n")
	assert_eq(d["id"], "x")
	assert_eq(d["circle"], 2)
	assert_eq((d["options"] as Array).size(), 2)
	var a: Dictionary = d["options"][0]
	assert_eq(a["safe"], true)
	assert_eq_deep(a["outcomes"][0], {"type": "light", "amount": -5})
	assert_eq(d["options"][1]["id"], "b")


func test_quoted_text_keeps_colons_commas_and_hashes() -> void:
	var d := _parse("text_pt: \"Ouvi: vento, chuva # e mais\"  # comentário\n")
	assert_eq(d["text_pt"], "Ouvi: vento, chuva # e mais")


func test_nested_flow_values_and_numbers() -> void:
	var d := _parse("chance:\n  base: 0.5\n  modifiers:\n    - { if: provision, id: holy_water, add: 0.2, consume: true }\nlist: [a, 2, \"c, d\"]\n")
	assert_almost_eq(float(d["chance"]["base"]), 0.5, 0.0001)
	assert_eq(d["chance"]["modifiers"][0]["consume"], true)
	assert_eq_deep(d["list"], ["a", 2, "c, d"])


func test_bad_indentation_is_an_error() -> void:
	var r := EventYaml.new()
	r.parse("id: x\n    stray: 1\n", "t.yaml")
	assert_false(r.errors.is_empty())
	assert_true(r.errors[0].contains("[bad_yaml]"))


func test_the_draft_temptation_file_parses() -> void:
	var path: String = BalanceExporter.default_source_dir().path_join("../narrative/events/circle_02/c02_temptation_wind_shelter.yaml").simplify_path()
	var d := _parse(FileAccess.get_file_as_string(path))
	assert_eq(d["id"], "c02_temptation_wind_shelter")
	assert_eq((d["options"] as Array).size(), 3)
