extends Control

var tiempo_total_segundos = 1800
@onready var timer: Timer = $Timer
@onready var label: Label = $HBoxContainer/VBoxContainer/ColorRect/Label

func _ready() -> void:
	timer.start()

func _process(_delta: float) -> void:
	tiempo_total_segundos = timer.time_left
	var m = int(tiempo_total_segundos/60.0)
	var s = tiempo_total_segundos - m*60
	label.text = '%02d:%02d' % [m,s]

func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://UI/pantalla_derrota.tscn")
