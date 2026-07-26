extends Node2D
class_name Bin

@onready var trash_spawn: Marker2D = $trap/TrashSpawn
const SPAWN_MARKER_OFFSET: int = 32

@onready var scrap_nodes: Node2D = $ScrapNodes
@onready var scrap_count: Label = $ScrapCount
@onready var resource_bar: ProgressBar = $ResourceBar
const RESOURCE_BAR_COLORS: Array[Color] = [
	Color.GREEN, Color.LAWN_GREEN, Color.YELLOW, Color.ORANGE, Color.SALMON, Color.RED
]
const RESOURCE_BAR_CUTOFFS: Array[int] = [
	0, 50, 100, 150, 175, 190
]

const SCRAP_COUNT_MAX: int = 200

@onready var spawn_timer_label: Label = $trap/SpawnTimer

func update_scrap_count() -> void:
	if scrap_nodes == null or scrap_count == null:
		return
	var count = scrap_nodes.get_child_count()
	for i in range(RESOURCE_BAR_COLORS.size()):
		if RESOURCE_BAR_CUTOFFS[i] < count:
			resource_bar.modulate = RESOURCE_BAR_COLORS[i]
	resource_bar.value = count
	scrap_count.text = str(count) + "/" + str(SCRAP_COUNT_MAX)
func _on_scrap_nodes_child_entered_tree(node: Node) -> void:
	node.tree_exited.connect(update_scrap_count)
	update_scrap_count()

@onready var game_over: PanelContainer = $"../CanvasLayer/GameOver"
@onready var credits: Control = $"../CanvasLayer/credits"
var _game_over_input_lock: bool = true
func _on_game_over() -> void:
	get_tree().paused = true
	game_over.visible = true
	credits.visible = false
	await get_tree().create_timer(2.5).timeout
	_game_over_input_lock = false
const MAIN = preload("uid://baopmn5l2lmu")
func _on_restart_pressed() -> void:
	if _game_over_input_lock: return
	UpgradeManager.restart()
	Resources.restart()
	ResourceToast.restart()
	get_tree().paused = false
	get_tree().change_scene_to_packed(MAIN)
func _on_credits_opened() -> void:
	if _game_over_input_lock: return
	game_over.visible = false
	credits.visible = true
func _on_quit_pressed() -> void:
	if _game_over_input_lock: return
	get_tree().quit()
func _on_credits_closed() -> void:
	if _game_over_input_lock: return
	game_over.visible = true
	credits.visible = false


const SPAWN_TIME: float = 5.0
const SPAWN_INCREASE: int = 5
const SPAWNS_BEFORE_INCREASE: int = 5
const SPAWN_START: int = 5
var _current_spawn_count: int = SPAWN_START
var _remaining_spawn_increase: int = 5

func _spawn_scrap(count: int) -> void:
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
	if scrap_nodes.get_child_count() > SCRAP_COUNT_MAX:
		_on_game_over()

func _ready() -> void:
	update_scrap_count()
	game_over.visible = false
	credits.visible = false

var spawn_timer: float = 1.0:
	set(v):
		spawn_timer = v
		spawn_timer_label.text = "%03.1f" % v

const DEBUG_SPAWN_COUNT: int = 25
func _on_spawn_timer() -> void:
	_spawn_scrap(_current_spawn_count)
	_remaining_spawn_increase -= 1
	if _remaining_spawn_increase <= 0:
		_current_spawn_count += SPAWN_INCREASE
		_remaining_spawn_increase = SPAWNS_BEFORE_INCREASE
	spawn_timer = SPAWN_TIME

func _process(delta: float) -> void:
	if spawn_timer > 0:
		spawn_timer -= delta
		if spawn_timer <= 0:
			_on_spawn_timer()


func _on_debug_spawn() -> void:
	_spawn_scrap(min(DEBUG_SPAWN_COUNT, SCRAP_COUNT_MAX - scrap_nodes.get_child_count()))

func _on_debug_resc_pressed() -> void:
	Resources.add_bundle(Resources.Bundle.new(100, 100, 100, 100))
