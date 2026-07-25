extends AnimatableBody2D

@export var bottom: Marker2D
@export var top: Marker2D


@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var going_up: bool = true
@export var start_half: bool = false
@export var active_level: int = 1

var current_time: float
var tween: Tween = null

func _get_move_time() -> float:
	return UpgradeManager.get_mover_speed()

func _handle_move_time_change(prev: float, curr: float) -> void:
	if tween == null:
		return
	var remaining: float = current_time - tween.get_total_elapsed_time()
	current_time = remaining * curr / prev
	#Log.info("%f %f %f %f" % [remaining, prev, curr, scaled])
	tween.kill()
	var dest: Marker2D = top if going_up else bottom
	tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", dest.global_position, current_time)
	tween.tween_callback(_change_direction)

func _change_direction() -> void:
	going_up = not going_up
	if tween != null:
		tween.kill()
		tween = null
	var dest: Vector2
	if going_up:
		dest = top.global_position
		if active_level <= UpgradeManager.get_mover_count():
			collision_shape_2d.set_deferred("disabled", false)
	else:
		dest = bottom.global_position
		collision_shape_2d.set_deferred("disabled", true)
	tween = get_tree().create_tween()
	current_time = _get_move_time()
	tween.tween_property(self, "global_position", dest , current_time)
	tween.tween_callback(_change_direction)

func _handle_count_change(_prev: float, _next: float) -> void:
	if active_level <= UpgradeManager.get_mover_count():
		visible = true
		if going_up:
			collision_shape_2d.set_deferred("disabled", false)

func _ready() -> void:
	UpgradeManager.mover_speed_changed.connect(_handle_move_time_change)
	UpgradeManager.mover_count_changed.connect(_handle_count_change)
	if active_level > UpgradeManager.get_mover_count():
		visible = false
		collision_shape_2d.set_deferred("disabled", true)
	tween = get_tree().create_tween()
	var dest: Marker2D = top if going_up else bottom
	current_time = _get_move_time() * (0.5 if start_half else 1.0)
	tween.tween_property(self, "global_position", dest.global_position, current_time)
	tween.tween_callback(_change_direction)
