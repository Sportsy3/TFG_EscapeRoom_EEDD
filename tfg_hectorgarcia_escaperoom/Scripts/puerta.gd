extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func abrir():
	animation_player.play("abrir_puerta")
