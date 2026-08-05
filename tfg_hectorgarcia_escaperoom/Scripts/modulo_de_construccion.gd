extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var modulo_abierto: bool = false

#func _ready() -> void:
	#connect("_abrir_modulo",open)

func open():
	if modulo_abierto == false:
		animation_player.play("open")
		modulo_abierto = true

func close():
	modulo_abierto = false
	animation_player.play_backwards("open")

#func _on_connect_abrir_modulo() -> void:
	#open()
