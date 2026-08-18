extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var abrir_puerta: AudioStreamPlayer = $AbrirPuerta

func abrir():
	animation_player.play("abrir_puerta")
	abrir_puerta.play(0)
