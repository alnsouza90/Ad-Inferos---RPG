class_name EventYaml
extends RefCounted
## Reads the small YAML subset used by the event files of
## docs/narrative/events (narrative-system §3, ADR-0012): block maps and
## lists by indentation (two spaces), "- " list items, one-line flow maps
## "{ a: 1, b: x }" and flow lists "[a, b]", quoted or plain scalars,
## numbers, true/false/null and "#" comments. Anything else is an error, so
## a typo never becomes silent data.

var errors: Array[String] = []
var file_name: String = ""

var _lines: Array = []
var _pos: int = 0


## Returns the parsed root map, or {} with `errors` filled.
func parse(text: String, p_file_name: String = "") -> Dictionary:
	file_name = p_file_name
	errors.clear()
	_lines.clear()
	_pos = 0
	var number: int = 0
	for raw: String in text.split("\n"):
		number += 1
		var line: String = _strip_comment(raw.replace("\r", "").replace("\t", "  ")).rstrip(" ")
		if line.strip_edges().is_empty():
			continue
		var indent: int = line.length() - line.lstrip(" ").length()
		_lines.append({"indent": indent, "text": line.strip_edges(), "line": number})
	if _lines.is_empty():
		return {}
	var root: Variant = _block(int(_lines[0]["indent"]))
	if _pos < _lines.size():
		_error(int(_lines[_pos]["line"]), "indentação inesperada")
	if not root is Dictionary:
		_error(1, "o arquivo deve começar com chaves (id: ...)")
		return {}
	return root


func _block(indent: int) -> Variant:
	if String(_lines[_pos]["text"]).begins_with("- ") or _lines[_pos]["text"] == "-":
		return _list(indent)
	return _map(indent)


func _map(indent: int) -> Dictionary:
	var result: Dictionary = {}
	while _pos < _lines.size() and int(_lines[_pos]["indent"]) == indent:
		var entry: Dictionary = _lines[_pos]
		var text: String = entry["text"]
		if text.begins_with("- "):
			break
		_pos += 1
		_map_entry(result, text, indent, int(entry["line"]))
	return result


func _map_entry(result: Dictionary, text: String, indent: int, line: int) -> void:
	var colon: int = _key_colon(text)
	if colon < 0:
		_error(line, "esperava 'chave: valor' em '%s'" % text)
		return
	var key: String = text.substr(0, colon).strip_edges()
	var rest: String = text.substr(colon + 1).strip_edges()
	if result.has(key):
		_error(line, "chave '%s' repetida" % key)
	if rest.is_empty():
		if _pos < _lines.size() and int(_lines[_pos]["indent"]) > indent:
			result[key] = _block(int(_lines[_pos]["indent"]))
		else:
			result[key] = null
	else:
		result[key] = _scalar_or_flow(rest, line)


func _list(indent: int) -> Array:
	var result: Array = []
	while _pos < _lines.size() and int(_lines[_pos]["indent"]) == indent:
		var entry: Dictionary = _lines[_pos]
		var text: String = entry["text"]
		if not text.begins_with("-"):
			break
		_pos += 1
		var item: String = text.substr(1).strip_edges()
		var line: int = entry["line"]
		if item.is_empty():
			if _pos < _lines.size() and int(_lines[_pos]["indent"]) > indent:
				result.append(_block(int(_lines[_pos]["indent"])))
			else:
				result.append(null)
		elif item.begins_with("{") or item.begins_with("[") or item.begins_with("\"") or _key_colon(item) < 0:
			result.append(_scalar_or_flow(item, line))
		else:
			# "- key: value" opens a map whose other keys sit 2 spaces further in.
			var map: Dictionary = {}
			_map_entry(map, item, indent + 2, line)
			if _pos < _lines.size() and int(_lines[_pos]["indent"]) == indent + 2:
				var more: Dictionary = _map(indent + 2)
				for k: Variant in more:
					if map.has(k):
						_error(line, "chave '%s' repetida" % k)
					map[k] = more[k]
			result.append(map)
	return result


func _scalar_or_flow(text: String, line: int) -> Variant:
	if text.begins_with("{"):
		if not text.ends_with("}"):
			_error(line, "mapa sem '}' em '%s'" % text)
			return {}
		var map: Dictionary = {}
		for part: String in _split_top(text.substr(1, text.length() - 2)):
			if part.strip_edges().is_empty():
				continue
			var colon: int = _key_colon(part)
			if colon < 0:
				_error(line, "esperava 'chave: valor' em '%s'" % part)
				continue
			map[part.substr(0, colon).strip_edges()] = _scalar_or_flow(part.substr(colon + 1).strip_edges(), line)
		return map
	if text.begins_with("["):
		if not text.ends_with("]"):
			_error(line, "lista sem ']' em '%s'" % text)
			return []
		var list: Array = []
		for part: String in _split_top(text.substr(1, text.length() - 2)):
			if not part.strip_edges().is_empty():
				list.append(_scalar_or_flow(part.strip_edges(), line))
		return list
	return _scalar(text, line)


func _scalar(text: String, line: int) -> Variant:
	if text.begins_with("\""):
		if text.length() < 2 or not text.ends_with("\""):
			_error(line, "texto entre aspas sem fechar: %s" % text)
			return ""
		return text.substr(1, text.length() - 2).replace("\\\"", "\"").replace("\\n", "\n")
	if text == "true":
		return true
	if text == "false":
		return false
	if text == "null" or text == "~":
		return null
	if text.is_valid_int():
		return text.to_int()
	if text.is_valid_float():
		return text.to_float()
	return text


## Index of the ":" that ends a key (outside quotes and brackets), else -1.
## A colon must be followed by a space or end the text, as in YAML.
static func _key_colon(text: String) -> int:
	var depth: int = 0
	var quoted: bool = false
	for i: int in text.length():
		var ch: String = text[i]
		if ch == "\"" and (i == 0 or text[i - 1] != "\\"):
			quoted = not quoted
		elif quoted:
			continue
		elif ch == "{" or ch == "[":
			depth += 1
		elif ch == "}" or ch == "]":
			depth -= 1
		elif ch == ":" and depth == 0 and (i == text.length() - 1 or text[i + 1] == " "):
			return i
	return -1


## Splits on commas that are outside quotes and nested brackets.
static func _split_top(text: String) -> Array[String]:
	var parts: Array[String] = []
	var depth: int = 0
	var quoted: bool = false
	var start: int = 0
	for i: int in text.length():
		var ch: String = text[i]
		if ch == "\"" and (i == 0 or text[i - 1] != "\\"):
			quoted = not quoted
		elif quoted:
			continue
		elif ch == "{" or ch == "[":
			depth += 1
		elif ch == "}" or ch == "]":
			depth -= 1
		elif ch == "," and depth == 0:
			parts.append(text.substr(start, i - start))
			start = i + 1
	parts.append(text.substr(start))
	return parts


static func _strip_comment(line: String) -> String:
	var quoted: bool = false
	for i: int in line.length():
		var ch: String = line[i]
		if ch == "\"" and (i == 0 or line[i - 1] != "\\"):
			quoted = not quoted
		elif ch == "#" and not quoted and (i == 0 or line[i - 1] == " "):
			return line.substr(0, i)
	return line


func _error(line: int, message: String) -> void:
	errors.append("%s linha %d [bad_yaml]: %s" % [file_name, line, message])
