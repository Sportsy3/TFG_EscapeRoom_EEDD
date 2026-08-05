extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	connect("_abrir_caja",open)
	if is_connected("_abrir_caja",open):
		print("conectado")

func open():
	animation_player.play("open")


func _on_connect_abrir_caja() -> void:
	open()
