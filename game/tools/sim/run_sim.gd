extends SceneTree
## Balance simulator without a screen (CLAUDE.md §5, testing.md §5):
##   godot --headless --path game -s res://tools/sim/run_sim.gd -- --encounters=m0 --runs=1000
## Options: --encounters=<id prefix> --runs=N --seed=N --policies=random,greedy,heuristic
## Writes res://tools/out/sim_<date>.csv and prints the summary.


func _init() -> void:
	var args: Dictionary = {"encounters": "m0", "runs": "1000", "seed": "1", "policies": "random,greedy,heuristic"}
	for arg: String in OS.get_cmdline_user_args():
		if arg.begins_with("--") and "=" in arg:
			var pair: PackedStringArray = arg.substr(2).split("=", true, 1)
			args[pair[0]] = pair[1]
	var data: SimData = SimData.load_all()
	var encounter_ids: Array[String] = data.encounter_ids(String(args["encounters"]))
	if encounter_ids.is_empty():
		printerr("Nenhum encontro começa com '%s'." % args["encounters"])
		quit(1)
		return
	var policies: Array[StringName] = []
	for p: String in String(args["policies"]).split(","):
		policies.append(StringName(p.strip_edges()))
	var started: int = Time.get_ticks_msec()
	var sim := BattleSimulator.new(data)
	sim.run(encounter_ids, int(args["runs"]), policies, int(args["seed"]))
	var report := SimReport.build(sim)
	var out_dir: String = "res://tools/out"
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(out_dir))
	# Keeps Godot from importing the CSV reports as translations.
	var ignore := FileAccess.open(out_dir.path_join(".gdignore"), FileAccess.WRITE)
	ignore.close()
	var stamp: String = Time.get_datetime_string_from_system().replace(":", "").replace("T", "_")
	var path: String = out_dir.path_join("sim_%s.csv" % stamp)
	var file := FileAccess.open(path, FileAccess.WRITE)
	file.store_string(report.to_csv())
	file.close()
	print(report.summary())
	print("\n%d combates em %.1f s · relatório: %s" % [sim.battles.size(), (Time.get_ticks_msec() - started) / 1000.0, ProjectSettings.globalize_path(path)])
	quit(0)
