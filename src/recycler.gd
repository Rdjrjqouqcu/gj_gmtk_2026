@icon ("res://addons/at-icons/node2d/factory.svg")
extends Node2D
class_name Recycler

func has_input_space() -> bool:
	return true
func get_input() -> Marker2D:
	return $input

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$temp.color = Color(randf_range(0.5, 1.0), randf_range(0.5, 1.0), randf_range(0.5, 1.0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
