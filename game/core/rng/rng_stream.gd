class_name RngStream
extends RefCounted
## Deterministic random stream: (seed, stream name, counter) fully defines it.
##
## Every draw consumes exactly one counter step, so saving {seed, stream, counter}
## and restoring it continues the exact same sequence (ADR-0005, architecture §4).
## Only 32-bit arithmetic split into 16-bit halves is used, so no int64 overflow
## happens and results are identical on every platform.

const MASK_32: int = 0xFFFFFFFF
const TWO_POW_32: float = 4294967296.0

var base_seed: int:
	get:
		return _seed
var stream: StringName:
	get:
		return _stream
var counter: int:
	get:
		return _counter

var _seed: int
var _stream: StringName
var _counter: int = 0
var _stream_key: int


func _init(p_seed: int, p_stream: StringName, p_counter: int = 0) -> void:
	assert(p_counter >= 0, "RngStream counter cannot be negative")
	_seed = p_seed
	_stream = p_stream
	_counter = p_counter
	var seed_lo: int = p_seed & MASK_32
	var seed_hi: int = (p_seed >> 32) & MASK_32
	_stream_key = hash32(hash32(seed_lo ^ fnv1a32(String(p_stream))) ^ hash32(seed_hi ^ 0x9E3779B9))


## Next unsigned 32-bit value (0 .. 2^32 - 1).
func next_u32() -> int:
	var value: int = hash32(_stream_key ^ hash32(_counter & MASK_32) ^ hash32((_counter >> 32) & MASK_32 ^ 0x85EBCA6B))
	_counter += 1
	return value


## Float in [0, 1).
func next_float() -> float:
	return float(next_u32()) / TWO_POW_32


## Integer in [low, high], inclusive. Consumes exactly one draw.
func next_int_range(low: int, high: int) -> int:
	assert(high >= low, "next_int_range: high must be >= low")
	var span: int = high - low + 1
	return low + mini(int(next_float() * span), span - 1)


## True with probability p (0..1). Consumes exactly one draw.
func chance(p: float) -> bool:
	return next_float() < p


## Picks one index in [0, size). Consumes exactly one draw.
func pick_index(size: int) -> int:
	assert(size > 0, "pick_index: size must be positive")
	return next_int_range(0, size - 1)


func to_dict() -> Dictionary:
	return {"seed": _seed, "stream": String(_stream), "counter": _counter}


static func from_dict(data: Dictionary) -> RngStream:
	return RngStream.new(int(data["seed"]), StringName(str(data["stream"])), int(data["counter"]))


## Multiplies two 32-bit values modulo 2^32 without leaving the int64 range.
static func mul32(a: int, b: int) -> int:
	var b_lo: int = b & 0xFFFF
	var b_hi: int = (b >> 16) & 0xFFFF
	var low_part: int = a * b_lo
	var high_part: int = ((a * b_hi) & 0xFFFF) << 16
	return (low_part + high_part) & MASK_32


## "lowbias32" integer hash (C. Wellons), 32 bits in, 32 bits out.
static func hash32(x: int) -> int:
	x &= MASK_32
	x ^= x >> 16
	x = mul32(x, 0x7FEB352D)
	x ^= x >> 15
	x = mul32(x, 0x846CA68B)
	x ^= x >> 16
	return x


## FNV-1a over UTF-8 bytes; stable across engine versions (unlike String.hash()).
static func fnv1a32(text: String) -> int:
	var h: int = 0x811C9DC5
	for byte: int in text.to_utf8_buffer():
		h ^= byte
		h = mul32(h, 0x01000193)
	return h
