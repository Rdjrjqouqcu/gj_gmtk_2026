@icon ("res://addons/at-icons/node2d/box.svg")
extends RigidBody2D
class_name Scrap

@export var type: Resources.Types

static var _atlas: CompressedTexture2D = preload("uid://ovjmope3aupn")
## each entry is [collision_array, atlas_region]
static func _variation(x: float, y: float, w: float, h: float) -> Array:
	var w2: float = w / 2.0
	var h2: float = h / 2.0
	return [
		PackedVector2Array([
			Vector2(-w2, -h2), Vector2(-w2, h2), Vector2(w2, h2), Vector2(w2, -h2),
		]),
		Rect2(x, y, w, h),
	]

static var _circuit_variations: Array = [
	_variation(49, 17, 14, 14),
	_variation(53, 33, 7, 14),
	_variation(49, 52, 14, 8),
	_variation(49, 66, 14, 12),
	_variation(50, 81, 12, 13),
]
const SCRAP_CIRCUIT = preload("uid://dkkqtggj0clpc")
static func create_circuit() -> Scrap:
	var s: Scrap = SCRAP_CIRCUIT.instantiate()
	s.type = Resources.Types.CIRCUIT
	var variation: Array = _circuit_variations.pick_random()
	var collision: CollisionPolygon2D = s.get_node("collision")
	collision.polygon = variation[0]
	var sprite: Sprite2D = s.get_node("sprite")
	sprite.texture = AtlasTexture.new()
	(sprite.texture as AtlasTexture).atlas = _atlas
	(sprite.texture as AtlasTexture).region = variation[1]
	return s

static var _metallic_variations: Array = [
	_variation(6, 5, 4, 8),
	_variation(6, 21, 4, 8),
	_variation(6, 37, 4, 8),
	_variation(3, 54, 10, 7),
	_variation(3, 70, 10, 7),
]
const SCRAP_METALLIC = preload("uid://dg1tdle16rjjf")
static func create_metallic() -> Scrap:
	var s: Scrap = SCRAP_METALLIC.instantiate()
	s.type = Resources.Types.METAL
	var variation: Array = _metallic_variations.pick_random()
	var collision: CollisionPolygon2D = s.get_node("collision")
	collision.polygon = variation[0]
	var sprite: Sprite2D = s.get_node("sprite")
	sprite.texture = AtlasTexture.new()
	(sprite.texture as AtlasTexture).atlas = _atlas
	(sprite.texture as AtlasTexture).region = variation[1]
	return s
	

static var _plastic_variations: Array = [
	_variation(22, 3, 4, 11),
	_variation(22, 19, 4, 11),
	_variation(20, 33, 8, 13),
	_variation(38, 3, 4, 11),
	_variation(38, 19, 4, 11),
	_variation(36, 33, 8, 13),
	_variation(35, 66, 11, 11),
]
const SCRAP_PLASTIC = preload("uid://bh4ukx6h102xu")
static func create_plastic() -> Scrap:
	var s: Scrap = SCRAP_PLASTIC.instantiate()
	s.type = Resources.Types.PLASTIC
	var variation: Array = _plastic_variations.pick_random()
	var collision: CollisionPolygon2D = s.get_node("collision")
	collision.polygon = variation[0]
	var sprite: Sprite2D = s.get_node("sprite")
	sprite.texture = AtlasTexture.new()
	(sprite.texture as AtlasTexture).atlas = _atlas
	(sprite.texture as AtlasTexture).region = variation[1]
	return s

const INACTIVE_MODULATION: float = 0.75
const ACTIVE_MODULATION: float = 1.0
func _on_mouse_entered() -> void:
	self.modulate.a = ACTIVE_MODULATION
func _on_mouse_exited() -> void:
	self.modulate.a = INACTIVE_MODULATION
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			self.queue_free()
			Resources.add_bundle(Resources.Bundle.new_from_type(1, type))
			get_tree().call_group("scraps", "set_sleeping", false)
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			print("right click")

func _ready() -> void:
	self.modulate.a = INACTIVE_MODULATION


func _process(_delta: float) -> void:
	pass
