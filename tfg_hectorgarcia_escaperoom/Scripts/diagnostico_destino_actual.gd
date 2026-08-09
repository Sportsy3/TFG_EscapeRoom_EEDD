extends Control

@onready var color_rect_3: ColorRect = $ColorRect3

func _ready() -> void:
	color_rect_3.visible = true

func encender():
	color_rect_3.visible = false
