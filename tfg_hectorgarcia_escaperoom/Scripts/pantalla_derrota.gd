extends Control

@onready var button: Button = $HBoxContainer/VBoxContainer/Button

func _ready() -> void:
	button.pressed.connect(_volver_al_menu)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _volver_al_menu():
	get_tree().change_scene_to_file("res://UI/menu_inicial.tscn")
