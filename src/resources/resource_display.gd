extends Control

const ResourceType = Resources.Types
const ResourceBundle = Resources.Bundle

@onready var val_salvage: Label = $PanelContainer/HBoxContainer/VBoxContainer/ValSalvage
@onready var val_metal: Label = $PanelContainer/HBoxContainer/VBoxContainer2/ValMetal
@onready var val_plastic: Label = $PanelContainer/HBoxContainer/VBoxContainer3/ValPlastic
@onready var val_circuit: Label = $PanelContainer/HBoxContainer/VBoxContainer4/ValCircuit

func _format_line(c: int, m: int) -> String:
	return "{0}".format([c, m])

func _update() -> void:
	val_salvage.text = _format_line(Resources.salvage_count, Resources.salvage_max)
	val_metal.text = _format_line(Resources.metal_count, Resources.metal_max)
	val_plastic.text = _format_line(Resources.plastic_count, Resources.plastic_max)
	val_circuit.text = _format_line(Resources.circuit_count, Resources.circuit_max)

func _on_bundle_spent(b: ResourceBundle) -> void:
	if b.salvage > 0:
		ResourceToast.create(-b.salvage, ResourceType.SALVAGE, $PanelContainer/HBoxContainer/VBoxContainer/TextureRect.global_position)
	if b.metal > 0:
		ResourceToast.create(-b.metal, ResourceType.METAL, $PanelContainer/HBoxContainer/VBoxContainer2/TextureRect.global_position)
	if b.plastic > 0:
		ResourceToast.create(-b.plastic, ResourceType.PLASTIC, $PanelContainer/HBoxContainer/VBoxContainer3/TextureRect.global_position)
	if b.circuit > 0:
		ResourceToast.create(-b.circuit, ResourceType.CIRCUIT, $PanelContainer/HBoxContainer/VBoxContainer4/TextureRect.global_position)

func _ready() -> void:
	Resources.amounts_updated.connect(_update)
	Resources.amounts_spent.connect(_on_bundle_spent)
	_update()


func _process(_delta: float) -> void:
	pass
