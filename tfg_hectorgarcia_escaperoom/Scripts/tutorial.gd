extends Control

@onready var button: Button = $VBoxContainer/Button

func _ready() -> void:
	button.pressed.connect(_comenzar)

func _comenzar():
	get_tree().change_scene_to_file("res://Scenes/sala.tscn")
	SocketIoClient.start_playing()
