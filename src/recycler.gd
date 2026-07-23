@icon ("res://addons/at-icons/node2d/factory.svg")
extends Node2D
class_name Recycler

func has_input_space() -> bool:
	return true
func get_input() -> Marker2D:
	return $input


func _ready() -> void:
	$temp.color = Color.from_hsv(randf(), 1.0, 1.0)


func _process(_delta: float) -> void:
	pass
