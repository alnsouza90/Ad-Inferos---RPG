class_name EventDef
extends Resource
## A narrative event (narrative-system §3), imported from
## docs/narrative/events/<circle>/<id>.yaml (ADR-0012). Options, pages,
## requirements, chances and outcomes stay as plain dictionaries in the
## format of the spec; the importer validates them and fills the defaults
## (every option has safe, requires, chance, outcomes, on_success, on_failure).

@export var id: StringName = &""
@export var type: StringName = &""
@export var circle: int = 0
@export var title_pt: String = ""
@export var origin: StringName = &""
## [{speaker, text_pt}]
@export var pages: Array = []
@export var options: Array = []
@export var requirements: Array = []


func option(option_id: StringName) -> Dictionary:
	for o: Dictionary in options:
		if StringName(str(o.get("id", ""))) == option_id:
			return o
	return {}
