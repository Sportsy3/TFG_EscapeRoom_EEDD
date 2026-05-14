extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var panel_girado = false
@export var num_panel: int

func girar_panelillo():
	if panel_girado == false:
		animation_player.play("GirarPanel")
		panel_girado = true
		GameManager.combinacion_actual_paneles.append(num_panel)
		for i in GameManager.combinacion_actual_paneles:
			print(GameManager.combinacion_actual_paneles[i])

func resetear_panelillo():
	if panel_girado == true:
		animation_player.play_backwards("GirarPanel")
		panel_girado = false
