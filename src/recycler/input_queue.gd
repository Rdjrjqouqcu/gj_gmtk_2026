extends Node2D
class_name InputQueue

@export var priority_type: Resources.Types

@onready var recycler: Recycler = get_parent() as Recycler
@onready var generic_bar: ProgressBar = $generic
@onready var priority_bar: ProgressBar = $priority

var priority_queued: int = 0
var general_queued: Array[Resources.Types] = []

func _update_display() -> void:
	generic_bar.value = general_queued.size()
	priority_bar.value = priority_queued
func _on_update_max(_a:float, _b: float) -> void:
	generic_bar.max_value = _general_max()
	priority_bar.max_value = _priority_max()

func _priority_max() -> int:
	return int(UpgradeManager.get_priority_size())
func _general_max() -> int:
	return int(UpgradeManager.get_generic_size())

func has_next_scrap() -> bool:
	return priority_queued > 0 or not general_queued.is_empty()
func consume_scrap() -> Resources.Types:
	assert(has_next_scrap(), "resource queue popped empty")
	if priority_queued > 0:
		priority_queued -= 1
		_update_display()
		return priority_type
	var tmp = general_queued.pop_front()
	_update_display()
	return tmp
## attempts to add scrap and start processing, returns true if collected
func try_add(s: Scrap) -> bool:
	if s.type == priority_type:
		if priority_queued < _priority_max():
			priority_queued += 1
			_update_display()
			recycler.try_start()
			return true
		if general_queued.size() < _general_max():
			general_queued.push_front(s.type)
			_update_display()
			recycler.try_start()
			return true
		return false
	if general_queued.size() < _general_max():
		general_queued.push_back(s.type)
		_update_display()
		recycler.try_start()
		return true
	return false


func _ready() -> void:
	UpgradeManager.priority_size_changed.connect(_on_update_max)
	UpgradeManager.generic_size_changed.connect(_on_update_max)
	_on_update_max(0, 0)
