@icon ("res://addons/at-icons/node2d/box.svg")
extends RigidBody2D
class_name Scrap

@export var type: Resources.Types

const SCRAP_CIRCUIT = preload("uid://dkkqtggj0clpc")
const SCRAP_METALLIC = preload("uid://dg1tdle16rjjf")
const SCRAP_PLASTIC = preload("uid://bh4ukx6h102xu")
static func create_plastic() -> Scrap:
	var s: Scrap = SCRAP_PLASTIC.instantiate()
	s.type = Resources.Types.PLASTIC
	return s
static func create_metallic() -> Scrap:
	var s: Scrap = SCRAP_METALLIC.instantiate()
	s.type = Resources.Types.METAL
	return s
static func create_circuit() -> Scrap:
	var s: Scrap = SCRAP_CIRCUIT.instantiate()
	s.type = Resources.Types.CIRCUIT
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
