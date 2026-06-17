extends Control
@onready var button: Button = $Button
@onready var button_2: Button = $Button2

func _ready():
	button.pressed.connect(_on_button_pressed)

func _on_button_pressed() -> void:
	print("Ai carallo")
	button.text = "arawampa"

func _on_button_2_pressed() -> void:
	print("Puta")
