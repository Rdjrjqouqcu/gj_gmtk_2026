extends AnimatableBody2D

@export var left: Marker2D
@export var right: Marker2D
const MOVE_TIME: float = 4.0

@onready var sprite: Sprite2D = $sprite

var tween: Tween = null
var going_right: bool = true:
	set(v):
		going_right = v
		sprite.flip_h = not v

func _change_direction() -> void:
	going_right = not going_right
	if tween != null:
		tween.kill()
		tween = null
	var dest: Vector2 = right.global_position if going_right else left.global_position
	tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", dest , MOVE_TIME)
	tween.tween_callback(_change_direction)

func _ready() -> void:
	tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", right.global_position, MOVE_TIME)
	tween.tween_callback(_change_direction)


func _process(_delta: float) -> void:
	pass
