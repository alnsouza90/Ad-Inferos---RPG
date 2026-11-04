extends Node
## Global application signals only (architecture §7): screens, saving, pause.
## Rules never use it.

signal save_completed(ok: bool)
signal screen_requested(kind: StringName)
