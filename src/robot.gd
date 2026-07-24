extends AnimatableBody2D

@export var left: Marker2D
@export var right: Marker2D

@onready var sprite: Sprite2D = $sprite

func _get_move_time() -> float:
	return UpgradeManager.get_robot_speed()

func _handle_move_time_change(prev: float, curr: float) -> void:
	if tween == null:
		return
	var remaining: float = prev - tween.get_total_elapsed_time()
	var scaled: float = remaining * curr / prev
	#Log.info("%f %f %f %f" % [remaining, prev, curr, scaled])
	tween.kill()
	var dest: Vector2 = right.global_position if going_right else left.global_position
	tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", dest , scaled)
	tween.tween_callback(_change_direction)

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
	tween.tween_property(self, "global_position", dest , _get_move_time())
	tween.tween_callback(_change_direction)

func _ready() -> void:
	UpgradeManager.robot_speed_changed.connect(_handle_move_time_change)
	tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", right.global_position, _get_move_time())
	tween.tween_callback(_change_direction)


func _process(_delta: float) -> void:
	pass
