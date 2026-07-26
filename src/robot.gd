extends AnimatableBody2D

@export var left: Marker2D
@export var right: Marker2D

@onready var sprite: Sprite2D = $sprite
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D


@export var going_right: bool = true:
	set(v):
		going_right = v
		if sprite:
			sprite.flip_h = not v
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
	#Log.info("%f %f %f %f" % [remaining, prev, curr, current_time])
	tween.kill()
	var dest: Marker2D = right if going_right else left
	tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", dest.global_position, current_time)
	tween.tween_callback(_change_direction)

func _change_direction() -> void:
	going_right = not going_right
	if tween != null:
		tween.kill()
		tween = null
	var dest: Marker2D
	if going_right:
		dest = right
		if active_level <= UpgradeManager.get_mover_count():
			collision_polygon_2d.set_deferred("disabled", false)
	else:
		dest = left
		collision_polygon_2d.set_deferred("disabled", true)
	tween = get_tree().create_tween()
	current_time = _get_move_time()
	tween.tween_property(self, "global_position", dest.global_position, current_time)
	tween.tween_callback(_change_direction)

func _handle_count_change(_prev: float, _next: float) -> void:
	if active_level <= UpgradeManager.get_mover_count():
		visible = true
		if going_right:
			collision_polygon_2d.set_deferred("disabled", false)

func _ready() -> void:
	UpgradeManager.mover_speed_changed.connect(_handle_move_time_change)
	UpgradeManager.mover_count_changed.connect(_handle_count_change)
	if active_level > UpgradeManager.get_mover_count():
		visible = false
		collision_polygon_2d.set_deferred("disabled", true)
	going_right = going_right # ensure sprite flip is correct
	tween = get_tree().create_tween()
	var dest: Marker2D = right if going_right else left
	current_time = _get_move_time() * (0.5 if start_half else 1.0)
	tween.tween_property(self, "global_position", dest.global_position, current_time)
	tween.tween_callback(_change_direction)
