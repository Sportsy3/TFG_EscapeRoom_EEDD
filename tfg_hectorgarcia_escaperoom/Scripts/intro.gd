extends Control

@onready var button_comenzar: Button = $VBoxContainer/HBoxContainer/ButtonComenzar
@onready var button_tutorial: Button = $VBoxContainer/HBoxContainer/ButtonTutorial

func _ready() -> void:
	button_comenzar.pressed.connect(_comenzar)
	button_tutorial.pressed.connect(_tutorial)

func _comenzar():
	get_tree().change_scene_to_file("res://Scenes/sala.tscn")
	SocketIoClient.start_playing()

func _tutorial():
	get_tree().change_scene_to_file("res://UI/tutorial.tscn")
