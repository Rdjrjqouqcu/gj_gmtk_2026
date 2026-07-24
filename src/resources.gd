extends Node

enum Types {
	SALVAGE,
	METAL,
	PLASTIC,
	CIRCUIT,
}

const CIRCUIT_TEXTURE = preload("uid://r5luvcvw0qje")
const METAL_TEXTURE = preload("uid://dh778d2tucsb7")
const PLASTIC_TEXTURE = preload("uid://dnf5j6jbi73j1")
const SALVAGE_TEXTURE = preload("uid://dfuuwxlbshqge")
var icon_textures: Dictionary[Types, Texture2D] = {
	Types.SALVAGE: SALVAGE_TEXTURE,
	Types.METAL: METAL_TEXTURE,
	Types.PLASTIC: PLASTIC_TEXTURE,
	Types.CIRCUIT: CIRCUIT_TEXTURE,
}

class Bundle extends RefCounted:
	var salvage: int = 0
	var metal: int = 0
	var plastic: int = 0
	var circuit: int = 0
	static func new_from_type(amt: int, t: Types) -> Bundle:
		match t:
			Types.SALVAGE:
				return Bundle.new(amt, 0, 0, 0)
			Types.METAL:
				return Bundle.new(0, amt, 0, 0)
			Types.PLASTIC:
				return Bundle.new(0, 0, amt, 0)
			Types.CIRCUIT:
				return Bundle.new(0, 0, 0, amt)
		return Bundle.new(0, 0, 0, 0)
	func _init(s: int, m: int, p: int, c: int):
		salvage = s
		metal = m
		plastic = p
		circuit = c
	func count_has() -> int:
		var c: int = 0
		if salvage > 0: c += 1
		if metal > 0: c += 1
		if plastic > 0: c += 1
		if circuit > 0: c += 1
		return c

var salvage_count: int = 0
var salvage_max: int = 100

var metal_count: int = 0
var metal_max: int = 100

var plastic_count: int = 0
var plastic_max: int = 100

var circuit_count: int = 0
var circuit_max: int = 100

signal amounts_updated
signal amounts_spent(b: Bundle)

func has(c: int, t: Types) -> bool:
	match t:
		Types.SALVAGE:
			return c <= salvage_count
		Types.METAL:
			return c <= metal_count
		Types.PLASTIC:
			return c <= plastic_count
		Types.CIRCUIT:
			return c <= circuit_count
		_:
			Log.error("invalid resource type")
			return false

func has_bundle(b: Bundle) -> bool:
	if salvage_count < b.salvage: return false
	if metal_count < b.metal: return false
	if plastic_count < b.plastic: return false
	if circuit_count < b.circuit: return false
	return true

func add(c: int, t: Types) -> void:
	match t:
		Types.SALVAGE:
			salvage_count = salvage_count + c
		Types.METAL:
			metal_count = metal_count + c
		Types.PLASTIC:
			plastic_count = plastic_count + c
		Types.CIRCUIT:
			circuit_count = circuit_count + c
		_:
			Log.error("invalid resource type")
			return
	amounts_updated.emit()

func add_bundle(b: Bundle) -> void:
	#salvage_count = min(salvage_max, salvage_count + b.salvage)
	#metal_count = min(metal_max, metal_count + b.metal)
	#plastic_count = min(plastic_max, plastic_count + b.plastic)
	#circuit_count = min(circuit_max, circuit_count + b.circuit)
	salvage_count = salvage_count + b.salvage
	metal_count = metal_count + b.metal
	plastic_count = plastic_count + b.plastic
	circuit_count = circuit_count + b.circuit
	amounts_updated.emit()
	

func spend_bundle(b: Bundle) -> void:
	salvage_count -= b.salvage
	metal_count -= b.metal
	plastic_count -= b.plastic
	circuit_count -= b.circuit
	amounts_updated.emit()
	amounts_spent.emit(b)
