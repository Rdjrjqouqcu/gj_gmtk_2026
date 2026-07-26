extends Recycler
class_name Salvager

@onready var input_left: ProgressBar = $InputLeft
@onready var input_right: ProgressBar = $InputRight
@onready var anim: AnimationPlayer = $item/anim
@onready var item: Sprite2D = $item
@onready var toast_spawn: Marker2D = $ToastSpawn

var _is_processing: bool = false
var _processing_count: int = 0

const QUEUE_SIZE: int = 20

func can_fit_resource(_t: Resources.Types) -> bool:
	return queued.size() < 2 * QUEUE_SIZE

var queued: Array[Texture2D] = []
func _set_input_display() -> void:
	input_left.value = max(queued.size() - QUEUE_SIZE, 0)
	input_right.value = min(queued.size(), QUEUE_SIZE)
func _add_queue(t: Texture2D):
	queued.append(t)
	_set_input_display()
	if not _is_processing:
		_start_processing()
func _pop_queue() -> Texture2D:
	var t = queued.pop_front()
	_set_input_display()
	return t
func _on_input_body_entered(body: Node2D) -> void:
	if body is Scrap:
		if can_fit_resource(body.type):
			_add_queue(body.get_texture())
			body.collect()

func _finish_processing(_name: String) -> void:
	Resources.add(_processing_count, Resources.Types.SALVAGE)
	ResourceToast.create(_processing_count, Resources.Types.SALVAGE, toast_spawn.global_position)
	_is_processing = false
	if queued.size() > 0:
		_start_processing()

func try_start() -> void:
	pass # not used for salvager

func _start_processing() -> void:
	_is_processing = true
	var time: float = 1.0 / UpgradeManager.get_salvager_speed()
	_processing_count = int(UpgradeManager.get_salvager_size())
	item.texture = _pop_queue()
	for i in range(1, _processing_count):
		_pop_queue()
	anim.play("salvager", -1, time)

func _ready() -> void:
	input_left.max_value = QUEUE_SIZE
	input_right.max_value = QUEUE_SIZE
	anim.animation_finished.connect(_finish_processing)
