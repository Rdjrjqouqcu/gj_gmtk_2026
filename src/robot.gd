extends AnimatableBody2D
class_name Robot

@export var recyclers: Array[Recycler]
@export var entrance: Marker2D
@export var right: Marker2D
@export var left: Marker2D

@onready var sprite: Sprite2D = $sprite

enum States {
	ENTERING,
	COLLECTING_RIGHT,
	COLLECTING_LEFT,
	EXITING,
	IDLE,
	UNLOADING,
}
var state: States = States.ENTERING

func _ready() -> void:
	sync_to_physics = false
	sprite.flip_h = true

func _get_available_recycler() -> Variant:
	var filtered: Array[Recycler] = recyclers.filter(func(x: Recycler): return x.has_input_space())
	return filtered.pick_random() if not filtered.is_empty() else null

const MOVE_SPEED: float = 100.0
const MOVE_EPSILON: int = 4
const FLOOR_EPSILON: float = 1
var _unloading_target: Marker2D = null

## returns true if arrived at destination
func _move_towards(global_pos: Vector2, delta: float, add_gravity: bool) -> bool:
	var vel = (global_pos - global_position).normalized() * MOVE_SPEED * delta
	if add_gravity and abs((global_pos - global_position).y) > FLOOR_EPSILON:
		#Log.info(vel, abs((global_pos - global_position).y))
		vel.y = (global_pos - global_position).y
	move_and_collide(vel, false, 0.08, true)
	if (global_pos - global_position).length() < MOVE_EPSILON:
		return true
	return false

func _process(delta: float) -> void:
	if state == States.ENTERING:
		if _move_towards(entrance.global_position, delta, false):
			sprite.flip_h = true
			state = States.COLLECTING_RIGHT
	elif state == States.COLLECTING_RIGHT:
		if _move_towards(right.global_position, delta, true):
			sprite.flip_h = true
			state = States.COLLECTING_LEFT
	elif state == States.COLLECTING_LEFT:
		if _move_towards(left.global_position, delta, true):
			sprite.flip_h = false
			state = States.COLLECTING_RIGHT
	elif state == States.EXITING:
		if _move_towards(entrance.global_position, delta, true):
			var t = _get_available_recycler()
			if t == null:
				state = States.IDLE
			else:
				_unloading_target = (t as Recycler).get_input()
				state = States.UNLOADING
	elif state == States.IDLE:
		var t = _get_available_recycler()
		if t != null:
			_unloading_target = (t as Recycler).get_input()
			state = States.UNLOADING
	elif state == States.UNLOADING:
		if _move_towards(_unloading_target.global_position, delta, false):
			# TODO unload scrap
			state = States.ENTERING
	else:
		Log.error("Robot state machine broken:", state)
