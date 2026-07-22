extends Node2D
class_name Bin

@onready var trash_spawn: Marker2D = $TrashSpawn
const SPAWN_MARKER_OFFSET: int = 32

@onready var scrap_nodes: Node2D = $ScrapNodes
@onready var label: Label = $Label

func update_scrap_count() -> void:
	if scrap_nodes == null or label == null:
		return
	label.text = str(scrap_nodes.get_child_count()) + " lbs"
func _on_scrap_nodes_child_entered_tree(node: Node) -> void:
	node.tree_exited.connect(update_scrap_count)
	update_scrap_count()

const DEBUG_SPAWN_COUNT: int = 10
func _on_debug_spawn() -> void:
	for i in range(DEBUG_SPAWN_COUNT):
		var scrap: Scrap
		match randi_range(0,2):
			0:
				scrap = Scrap.create_metallic()
			1:
				scrap = Scrap.create_plastic()
			2:
				scrap = Scrap.create_circuit()
		scrap.global_position = trash_spawn.global_position
		scrap.global_position += Vector2(
				randi_range(-SPAWN_MARKER_OFFSET, SPAWN_MARKER_OFFSET),
				randi_range(-SPAWN_MARKER_OFFSET, SPAWN_MARKER_OFFSET))
		scrap_nodes.add_child(scrap)

func _ready() -> void:
	update_scrap_count()

func _process(_delta: float) -> void:
	pass
