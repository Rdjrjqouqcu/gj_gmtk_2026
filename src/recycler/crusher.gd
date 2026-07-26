extends Recycler
class_name Crusher

@onready var anim_sprite: AnimatedSprite2D = $anim_sprite
@onready var anim_player: AnimationPlayer = $item/anim
@onready var toast_spawn: Marker2D = $ToastSpawn
@onready var input_queue: InputQueue = $InputQueue

var _is_processing: bool = false
var _cur_animation_duration: float
var _cur_resource_type: Resources.Types
func _play_second_half_animation() -> void:
	var time: float = 2.0 / _cur_animation_duration
	anim_player.play("RESET")
	anim_sprite.play("crusher", time)


func _ready() -> void:
	anim_sprite.animation_finished.connect(_finish_processing)


func _finish_processing() -> void:
	if not _is_processing: return
	var count: int = 1
	if _cur_resource_type == Resources.Types.METAL:
		count += UpgradeManager.get_bonus_amount()
	Resources.add(count, Resources.Types.METAL)
	ResourceToast.create(count, Resources.Types.METAL, toast_spawn.global_position)
	Resources.processed_scrap()
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
	_cur_animation_duration = UpgradeManager.get_crusher_speed()
	var time: float = 2.0 / _cur_animation_duration
	anim_player.play("crusher", -1, time)

func _on_input_body_entered(body: Node2D) -> void:
	if body is Scrap:
		if input_queue.try_add(body):
			body.collect()
