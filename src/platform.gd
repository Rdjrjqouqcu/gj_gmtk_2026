extends AnimatableBody2D

@export var bottom: Marker2D
@export var top: Marker2D


@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var going_up: bool = true

func _get_move_time() -> float:
	return UpgradeManager.get_platform_speed()

func _handle_move_time_change(prev: float, curr: float) -> void:
	if tween == null:
		return
	var remaining: float = prev - tween.get_total_elapsed_time()
	var scaled: float = remaining * curr / prev
	#Log.info("%f %f %f %f" % [remaining, prev, curr, scaled])
	tween.kill()
	var dest: Vector2 = top.global_position if going_up else bottom.global_position
	tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", dest , scaled)
	tween.tween_callback(_change_direction)

var tween: Tween = null

func _change_direction() -> void:
	going_up = not going_up
	if tween != null:
		tween.kill()
		tween = null
	var dest: Vector2
	if going_up:
		dest = top.global_position
		collision_shape_2d.set_deferred("disabled", false)
	else:
		dest = bottom.global_position
		collision_shape_2d.set_deferred("disabled", true)
	tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", dest , _get_move_time())
	tween.tween_callback(_change_direction)

func _ready() -> void:
	UpgradeManager.platform_speed_changed.connect(_handle_move_time_change)
	tween = get_tree().create_tween()
	var dest: Marker2D = top if going_up else bottom
	tween.tween_property(self, "global_position", dest.global_position, _get_move_time())
	tween.tween_callback(_change_direction)
