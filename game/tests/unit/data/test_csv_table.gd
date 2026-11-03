extends GutTest
## CSV reader used by the balance importer (data-schemas §1).


func test_parses_header_and_rows() -> void:
	var t := CsvTable.parse("a,b\n1,2\n3,4\n", "x.csv")
	assert_eq(Array(t.header), ["a", "b"])
	assert_eq(t.rows.size(), 2)
	assert_eq(t.rows[1]["b"], "4")
	assert_eq(t.line_numbers, [2, 3] as Array[int])


func test_quoted_fields_with_commas_and_quotes() -> void:
	var t := CsvTable.parse("a,b\n\"x, y\",\"\"\"O terço\"\": arma\"\n", "x.csv")
	assert_eq(t.rows[0]["a"], "x, y")
	assert_eq(t.rows[0]["b"], "\"O terço\": arma")


func test_skips_comments_and_blank_lines() -> void:
	var t := CsvTable.parse("a,b\n# comentário,\n\n1,2\n,\n", "x.csv")
	assert_eq(t.rows.size(), 1)
	assert_eq(t.line_numbers[0], 4)


func test_crlf_and_bom() -> void:
	var t := CsvTable.parse("﻿a,b\r\n1,2\r\n", "x.csv")
	assert_eq(Array(t.header), ["a", "b"])
	assert_eq(t.rows[0]["b"], "2")


func test_missing_trailing_cells_become_empty() -> void:
	var t := CsvTable.parse("a,b,c\n1\n", "x.csv")
	assert_eq(t.rows[0]["c"], "")


func test_too_many_cells_is_an_error() -> void:
	var t := CsvTable.parse("a\n1,2\n", "x.csv")
	assert_eq(t.errors.size(), 1)


func test_utf8_text_is_kept() -> void:
	var t := CsvTable.parse("a\n−10 de desolação\n", "x.csv")
	assert_eq(t.rows[0]["a"], "−10 de desolação")
