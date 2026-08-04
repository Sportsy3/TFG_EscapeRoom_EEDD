extends Control

@onready var button_jugar: Button = $HBoxContainer/VBoxContainer/VBoxContainer/ButtonJugar
@onready var button_salir: Button = $HBoxContainer/VBoxContainer/VBoxContainer/ButtonSalir

func _ready() -> void:
	button_jugar.pressed.connect(_on_button_jugar_pressed)
	button_salir.pressed.connect(_on_button_salir_pressed)

func _on_button_jugar_pressed():
	get_tree().change_scene_to_file("res://UI/intro.tscn")

func _on_button_salir_pressed():
	get_tree().quit()
