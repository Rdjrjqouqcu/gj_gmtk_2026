@icon ("res://addons/at-icons/node2d/box.svg")
extends RigidBody2D
class_name Scrap

@export var bin: Bin

const SCRAP_ELECTRONIC = preload("uid://dkkqtggj0clpc")
const SCRAP_METALLIC = preload("uid://dg1tdle16rjjf")
const SCRAP_PLASTIC = preload("uid://bh4ukx6h102xu")
static func create_plastic(b: Bin) -> Scrap:
	var s = SCRAP_PLASTIC.instantiate()
	s.bin = b
	return s
static func create_metallic(b: Bin) -> Scrap:
	var s = SCRAP_METALLIC.instantiate()
	s.bin = b
	return s
static func create_electronic(b: Bin) -> Scrap:
	var s = SCRAP_ELECTRONIC.instantiate()
	s.bin = b
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
			get_tree().call_group("scraps", "set_sleeping", false)
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			print("right click")

func _ready() -> void:
	self.modulate.a = INACTIVE_MODULATION


func _process(_delta: float) -> void:
	pass
