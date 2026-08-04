extends Control

@onready var button: Button = $Button

func _ready() -> void:
	button.pressed.connect(_volver_al_menu)

func _volver_al_menu():
	get_tree().change_scene_to_file("res://UI/menu_inicial.tscn")
