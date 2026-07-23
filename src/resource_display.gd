extends Control

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

func _ready() -> void:
	Resources.amounts_updated.connect(_update)
	_update()


func _process(_delta: float) -> void:
	pass
