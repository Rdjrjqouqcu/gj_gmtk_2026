extends PanelContainer

const ResourceType = Resources.Types
const ResourceBundle = Resources.Bundle

@export var upgrade: UpgradeManager.Upgrades

const COLOR_NOT_SELECTED = Color.WHITE
const COLOR_CAN_AFFORD = Color.GREEN
const COLOR_CANNOT_AFFORD = Color.RED
@onready var val_salvage: Label = $VBoxContainer/cost/HBoxContainer/ValSalvage
@onready var val_metal: Label = $VBoxContainer/cost/HBoxContainer/ValMetal
@onready var val_plastic: Label = $VBoxContainer/cost/HBoxContainer2/ValPlastic
@onready var val_circuit: Label = $VBoxContainer/cost/HBoxContainer2/ValCircuit

func _update_cost_nodes(cost: ResourceBundle) -> void:
	if cost.salvage == 0:
		val_salvage.text = "0"
		val_salvage.modulate = COLOR_NOT_SELECTED
	else:
		val_salvage.text = str(cost.salvage)
		var can_afford = Resources.has(cost.salvage, ResourceType.SALVAGE)
		val_salvage.modulate = COLOR_CAN_AFFORD if can_afford else COLOR_CANNOT_AFFORD
	if cost.metal == 0:
		val_metal.text = "0"
		val_metal.modulate = COLOR_NOT_SELECTED
	else:
		val_metal.text = str(cost.metal)
		var can_afford = Resources.has(cost.metal, ResourceType.METAL)
		val_metal.modulate = COLOR_CAN_AFFORD if can_afford else COLOR_CANNOT_AFFORD
	if cost.plastic == 0:
		val_plastic.text = "0"
		val_plastic.modulate = COLOR_NOT_SELECTED
	else:
		val_plastic.text = str(cost.plastic)
		var can_afford = Resources.has(cost.plastic, ResourceType.PLASTIC)
		val_plastic.modulate = COLOR_CAN_AFFORD if can_afford else COLOR_CANNOT_AFFORD
	if cost.circuit == 0:
		val_circuit.text = "0"
		val_circuit.modulate = COLOR_NOT_SELECTED
	else:
		val_circuit.text = str(cost.circuit)
		var can_afford = Resources.has(cost.circuit, ResourceType.CIRCUIT)
		val_circuit.modulate = COLOR_CAN_AFFORD if can_afford else COLOR_CANNOT_AFFORD


func _update_display() -> void:
	$VBoxContainer/name.text = title
	var cost: ResourceBundle = get_cost.call()
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
		_update_cost_nodes(cost)

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
			var cost: ResourceBundle = get_cost.call()
			if cost == null:
				return # upgrades maxed
			# TODO enable cost checks
			#if Resources.has_bundle(cost):
			Resources.spend_bundle(cost)
			increase.call()
			_update_display()
			
