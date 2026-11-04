class_name WalkTexts
extends RefCounted
## Portuguese strings of the walk (corridor and mini-map). Every word comes
## from UiTextDef or from the definitions' name_pt.

var ui: UiTextDef
var data: GameData


func _init(p_data: GameData) -> void:
	data = p_data
	ui = p_data.ui


func t(key: StringName, args: Dictionary = {}) -> String:
	return ui.text(key, args)


## Node type in text (never only an icon, screens §4): "Combate".
func type_name(n: MapNode) -> String:
	return t(n.type)


## "Caverna", "Porta", "Escada" or "Seguir em frente".
func path_name(kind: StringName) -> String:
	return t(StringName("walk_path_%s" % kind))


## What is known of a node (expedition §2.2): enemies of a battle when the
## content is visible, "Conteúdo oculto" when it is not.
func content(ctrl: ExpeditionController, n: MapNode) -> String:
	if not ctrl.content_visible(n):
		return t(&"walk_content_hidden")
	if n.is_battle_like() and n.encounter_id != &"":
		var enc: EncounterDef = data.encounters.get(n.encounter_id)
		if enc != null:
			return t(&"walk_content_enemies", {"pool": t(StringName("pool_%s" % enc.pool)), "enemies": ", ".join(enemy_names(enc))})
	return ""


func enemy_names(enc: EncounterDef) -> Array[String]:
	var names: Array[String] = []
	for enemy_id: StringName in enc.slots:
		var def: EnemyDef = data.catalog.enemies.get(enemy_id)
		names.append(def.name_pt if def != null else String(enemy_id))
	return names


## Mini-map box: the type, plus the encounter group when known.
func minimap_node(ctrl: ExpeditionController, n: MapNode) -> String:
	var line: String = type_name(n)
	if n.is_battle_like() and n.encounter_id != &"" and ctrl.content_visible(n):
		var enc: EncounterDef = data.encounters.get(n.encounter_id)
		if enc != null:
			line += "\n" + t(StringName("pool_%s" % enc.pool))
	return line


func light(ctrl: ExpeditionController) -> String:
	return t(&"walk_light", {"value": ctrl.state.light})


func alms(ctrl: ExpeditionController) -> String:
	return t(&"walk_alms", {"banked": ctrl.state.alms_banked, "unbanked": ctrl.state.alms_unbanked})


func provision_name(id: StringName) -> String:
	var def: ProvisionDef = data.catalog.provision(id)
	return def.name_pt if def != null else String(id)


func saint_name(id: StringName) -> String:
	var def: SaintDef = data.saints.get(id)
	return def.name_pt if def != null else String(id)


func reason(code: StringName) -> String:
	return t(StringName("walk_reason_%s" % code))
