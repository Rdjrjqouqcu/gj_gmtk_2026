extends CenterContainer

const MAIN = preload("uid://baopmn5l2lmu")

@onready var menu: VBoxContainer = $menu
@onready var credits: PanelContainer = $credits

func _ready() -> void:
	menu.visible = true
	credits.visible = false

func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(MAIN)

func _on_credits_pressed() -> void:
	menu.visible = false
	credits.visible = true

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_close_pressed() -> void:
	menu.visible = true
	credits.visible = false
