extends SceneTree
## Command-line entry point (CLAUDE.md §5):
##   godot --headless --path game -s res://tools/data/import_balance.gd
##   godot --headless --path game -s res://tools/data/import_balance.gd -- --check
## --check only verifies that game/data matches docs/balance (used by CI).


func _init() -> void:
	var check_only: bool = OS.get_cmdline_user_args().has("--check")
	var exporter := BalanceExporter.new()
	var ok: bool = exporter.run(BalanceExporter.default_source_dir(), check_only)
	for message: String in exporter.errors:
		printerr(message)
	if ok:
		if check_only:
			print("Dados em dia com docs/balance (%d arquivos)." % exporter.unchanged)
		else:
			print("Importação concluída: %d gravados, %d sem mudança, %d removidos." % [exporter.written.size(), exporter.unchanged, exporter.removed.size()])
	else:
		printerr("Importação recusada: %d erro(s). Nada foi gravado." % exporter.errors.size() if not check_only else "Verificação falhou: %d erro(s)." % exporter.errors.size())
	quit(0 if ok else 1)
