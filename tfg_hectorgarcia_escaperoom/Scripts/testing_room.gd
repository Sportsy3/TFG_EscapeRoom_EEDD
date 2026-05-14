extends Node3D

func _ready():
	var jugador = $Player  # ajusta el nombre
	var script_interaccion = jugador.get_node("Head")  # el que tiene el script de interacción
	var hanoi_puzzle = $hanoi_puzzle  # ajusta la ruta
	script_interaccion.hanoi = hanoi_puzzle
