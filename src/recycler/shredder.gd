@icon ("res://addons/at-icons/node2d/factory.svg")
extends Recycler
class_name Shredder

@onready var anim_sprite: AnimatedSprite2D = $anim
@onready var anim_player: AnimationPlayer = $item/anim
@onready var toast_spawn: Marker2D = $ToastSpawn
@onready var input_queue: InputQueue = $InputQueue

var _is_processing: bool = false
var _cur_animation_duration: float
var _cur_resource_type: Resources.Types
func _play_second_half_animation() -> void:
	anim_player.play("RESET")
	anim_sprite.play("shredder", 1.0)


func _ready() -> void:
	anim_sprite.animation_finished.connect(_finish_processing)


func _finish_processing() -> void:
	var count: int = 2 if _cur_resource_type == Resources.Types.PLASTIC else 1
	Resources.add(count, Resources.Types.PLASTIC)
	ResourceToast.create(count, Resources.Types.PLASTIC, toast_spawn.global_position)
	_is_processing = false
	if input_queue.has_next_scrap():
		_start_processing()

func try_start() -> void:
	if _is_processing:
		return
	_start_processing()

func _start_processing() -> void:
	_is_processing = true
	_cur_resource_type = input_queue.consume_scrap()
	_cur_animation_duration = UpgradeManager.get_shredder_speed()
	var time: float = 2.0 / _cur_animation_duration
	anim_player.play("shredder", -1, time)

func _on_input_body_entered(body: Node2D) -> void:
	if body is Scrap:
		if input_queue.try_add(body):
			body.collect()
