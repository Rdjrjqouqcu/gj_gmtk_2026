extends PanelContainer

const ResourceType = Resources.Types
const ResourceBundle = Resources.Bundle

@export var upgrade: UpgradeManager.Upgrades

const COLOR_CAN_AFFORD = Color.GREEN
const COLOR_CANNOT_AFFORD = Color.RED

func _add_cost_nodes(cost: int, type: ResourceType) -> void:
	var can_afford_salvage: bool = Resources.has(cost, type)
	var l: Label = Label.new()
	l.text = str(cost)
	l.modulate = COLOR_CAN_AFFORD if can_afford_salvage else COLOR_CANNOT_AFFORD
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var t: TextureRect = TextureRect.new()
	t.texture = Resources.icon_textures[type]
	t.custom_minimum_size = Vector2(32, 32)
	t.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	t.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	$VBoxContainer/cost.add_child(l)
	$VBoxContainer/cost.add_child(t)

func _update_display() -> void:
	$VBoxContainer/name.text = title
	var cost: Resources.Bundle = get_cost.call()
	var current = get_current.call()
	if cost == null:
		$VBoxContainer/cost.visible = false
		$VBoxContainer/maxed.visible = true
		$VBoxContainer/effect.text = str(current) + unit
	else:
		$VBoxContainer/cost.visible = true
		$VBoxContainer/maxed.visible = false
		var next = get_next.call()
		$VBoxContainer/effect.text = str(current) + unit + " -> " + str(next) + unit
		for c in $VBoxContainer/cost.get_children():
			c.queue_free()
		if cost.salvage != 0:
			_add_cost_nodes(cost.salvage, ResourceType.SALVAGE)
		if cost.metal != 0:
			_add_cost_nodes(cost.metal, ResourceType.METAL)
		if cost.plastic != 0:
			_add_cost_nodes(cost.plastic, ResourceType.PLASTIC)
		if cost.circuit != 0:
			_add_cost_nodes(cost.circuit, ResourceType.CIRCUIT)

var title: String
var unit: String
var get_current: Callable
var get_next: Callable
var get_cost: Callable
var increase: Callable

func _on_resources_amounts_updated() -> void:
	_update_display()

func _ready() -> void:
	var ref = UpgradeManager.get_upgrade(upgrade)
	title = ref[UpgradeManager.TITLE]
	unit = ref[UpgradeManager.UNIT]
	get_current = ref[UpgradeManager.GET_CURRENT]
	get_next = ref[UpgradeManager.GET_NEXT]
	get_cost = ref[UpgradeManager.GET_COST]
	increase = ref[UpgradeManager.INCREASE]
	Resources.amounts_updated.connect(_on_resources_amounts_updated)
	_update_display()


func _process(_delta: float) -> void:
	pass


func _on_mouse_entered() -> void:
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	pass # Replace with function body.


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		print(event)
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("lclick")
			increase.call()
			_update_display()
			
