extends Node2D
class_name Bin

@onready var trash_spawn: Marker2D = $TrashSpawn
const SPAWN_MARKER_OFFSET: int = 32

@onready var scrap_nodes: Node2D = $ScrapNodes
@onready var scrap_count: Label = $ScrapCount
const SCRAP_COUNT_MAX: int = 200

@onready var spawn_timer_label: Label = $SpawnTimer

func update_scrap_count() -> void:
	if scrap_nodes == null or scrap_count == null:
		return
	scrap_count.text = str(scrap_nodes.get_child_count()) + "/" + str(SCRAP_COUNT_MAX)
func _on_scrap_nodes_child_entered_tree(node: Node) -> void:
	node.tree_exited.connect(update_scrap_count)
	update_scrap_count()

func _spawn_scrap(count: int) -> void:
	if SCRAP_COUNT_MAX < count + scrap_nodes.get_child_count():
		Log.info("GAME OVER, TOO MUCH SCRAP")
	count = min(count, SCRAP_COUNT_MAX - scrap_nodes.get_child_count())
	for i in range(count):
		var scrap: Scrap
		match randi_range(0,4):
			0, 1:
				scrap = Scrap.create_metallic()
			2, 3:
				scrap = Scrap.create_plastic()
			4:
				scrap = Scrap.create_circuit()
		scrap.global_position = trash_spawn.global_position
		scrap.global_position += Vector2(
				randi_range(-SPAWN_MARKER_OFFSET, SPAWN_MARKER_OFFSET),
				randi_range(-SPAWN_MARKER_OFFSET, SPAWN_MARKER_OFFSET))
		scrap_nodes.add_child(scrap)


func _on_debug_spawn() -> void:
	spawn_timer = -spawn_timer

func _ready() -> void:
	update_scrap_count()

const SPAWN_TIMER_MAX: float = 10.0
var spawn_timer: float = 0.25:
	set(v):
		spawn_timer = v
		spawn_timer_label.text = "%05.2f" % v

const DEBUG_SPAWN_COUNT: int = 25
func _on_spawn_timer() -> void:
	_spawn_scrap(DEBUG_SPAWN_COUNT)
	spawn_timer = SPAWN_TIMER_MAX

func _process(delta: float) -> void:
	if spawn_timer > 0:
		spawn_timer -= delta
		if spawn_timer <= 0:
			_on_spawn_timer()
