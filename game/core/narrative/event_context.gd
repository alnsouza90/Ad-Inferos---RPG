class_name EventContext
extends RefCounted
## What an event's requirements and chances look at (narrative-system §3.1):
## built by whoever runs the event (the expedition), so the narrative rules
## do not depend on the expedition classes.

var party: Array[StringName] = []
var provisions: Array[StringName] = []
var relics: Array[StringName] = []
var alms: int = 0
var virtues: Virtues
var flags: Array[StringName] = []
