extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var modulo_abierto: bool = false

func open():
	if modulo_abierto == false:
		animation_player.play("open")
		modulo_abierto = true
