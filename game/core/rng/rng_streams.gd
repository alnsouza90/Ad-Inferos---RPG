class_name RngStreams
extends RefCounted
## The named random streams of a campaign, all derived from one campaign seed
## (architecture §4). Each system draws only from its own stream, so adding a
## draw in one system never changes the results of another.

const BATTLE: StringName = &"battle"
const MAP: StringName = &"map"
const REWARDS: StringName = &"rewards"
const EVENTS: StringName = &"events"
const FAITH: StringName = &"faith"
const NAMES: Array[StringName] = [BATTLE, MAP, REWARDS, EVENTS, FAITH]

var base_seed: int:
	get:
		return _seed

var _seed: int
var _streams: Dictionary = {}


func _init(p_seed: int, counters: Dictionary = {}) -> void:
	_seed = p_seed
	for stream_name: StringName in NAMES:
		var count: int = int(counters.get(String(stream_name), 0))
		_streams[stream_name] = RngStream.new(p_seed, stream_name, count)


func get_stream(stream_name: StringName) -> RngStream:
	assert(_streams.has(stream_name), "Unknown RNG stream: %s" % stream_name)
	return _streams[stream_name]


func battle() -> RngStream:
	return get_stream(BATTLE)


func map() -> RngStream:
	return get_stream(MAP)


func rewards() -> RngStream:
	return get_stream(REWARDS)


func events() -> RngStream:
	return get_stream(EVENTS)


func faith() -> RngStream:
	return get_stream(FAITH)


## Counters only; the seed is saved separately in the campaign (save-load §3).
func get_counters() -> Dictionary:
	var result: Dictionary = {}
	for stream_name: StringName in NAMES:
		result[String(stream_name)] = (_streams[stream_name] as RngStream).counter
	return result


func to_dict() -> Dictionary:
	return {"seed": _seed, "counters": get_counters()}


static func from_dict(data: Dictionary) -> RngStreams:
	return RngStreams.new(int(data["seed"]), data.get("counters", {}) as Dictionary)
