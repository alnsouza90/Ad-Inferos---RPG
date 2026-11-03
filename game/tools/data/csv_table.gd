class_name CsvTable
extends RefCounted
## Minimal RFC 4180 CSV reader for docs/balance (data-schemas §1).
## Works on text so tests can feed tables without touching files.
## Rows whose first cell starts with "#" and fully empty rows are skipped.

var file_name: String = ""
var header: PackedStringArray = PackedStringArray()
## Each row maps column name -> cell text (stripped).
var rows: Array[Dictionary] = []
## Source line number (1-based) of each row, same index as `rows`.
var line_numbers: Array[int] = []
var errors: Array[String] = []


static func parse(text: String, p_file_name: String) -> CsvTable:
	var table := CsvTable.new()
	table.file_name = p_file_name
	var records: Array = _split_records(text.trim_prefix("﻿"))
	var first := true
	for record: Dictionary in records:
		var cells: PackedStringArray = record["cells"]
		var line: int = record["line"]
		if _is_blank(cells):
			continue
		if first:
			first = false
			for cell: String in cells:
				table.header.append(cell.strip_edges())
			continue
		if cells[0].strip_edges().begins_with("#"):
			continue
		if cells.size() > table.header.size():
			table.errors.append("%s linha %d: %d colunas, o cabeçalho tem %d" % [p_file_name, line, cells.size(), table.header.size()])
			continue
		var row: Dictionary = {}
		for i: int in table.header.size():
			row[table.header[i]] = cells[i].strip_edges() if i < cells.size() else ""
		table.rows.append(row)
		table.line_numbers.append(line)
	if first:
		table.errors.append("%s: arquivo vazio" % p_file_name)
	return table


func has_column(column: String) -> bool:
	return header.has(column)


static func _is_blank(cells: PackedStringArray) -> bool:
	for cell: String in cells:
		if not cell.strip_edges().is_empty():
			return false
	return true


## Splits text into records of cells, honouring quoted fields with commas,
## doubled quotes and line breaks.
static func _split_records(text: String) -> Array:
	var records: Array = []
	var cells := PackedStringArray()
	var cell := ""
	var in_quotes := false
	var line := 1
	var record_line := 1
	var i := 0
	var length: int = text.length()
	while i < length:
		var c: String = text[i]
		if in_quotes:
			if c == "\"":
				if i + 1 < length and text[i + 1] == "\"":
					cell += "\""
					i += 1
				else:
					in_quotes = false
			else:
				if c == "\n":
					line += 1
				cell += c
		elif c == "\"":
			in_quotes = true
		elif c == ",":
			cells.append(cell)
			cell = ""
		elif c == "\n" or c == "\r":
			if c == "\r" and i + 1 < length and text[i + 1] == "\n":
				i += 1
			cells.append(cell)
			records.append({"cells": cells, "line": record_line})
			cells = PackedStringArray()
			cell = ""
			line += 1
			record_line = line
		else:
			cell += c
		i += 1
	if not cell.is_empty() or not cells.is_empty():
		cells.append(cell)
		records.append({"cells": cells, "line": record_line})
	return records
