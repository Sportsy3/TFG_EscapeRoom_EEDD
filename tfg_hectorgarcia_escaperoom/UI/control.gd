extends Control
@onready var button: Button = $Button

func _ready():
	button.pressed.connect(_on_button_pressed)

func _on_button_pressed() -> void:
	print("Ai carallo")
	button.text = "arawampa"
