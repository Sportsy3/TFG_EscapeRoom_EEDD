extends Node3D

@onready var pistas: Node = $Pistas
var array_pistas: Array
var puede_imprimir: bool = true
var pistas_impresas: Array
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	array_pistas = pistas.get_children()
	for pista in array_pistas:
		pistas_impresas.append(false)
		pista._disable_collisions()
		pista.visible = false

func imprimir_pista():
	if puede_imprimir == false:
		return
	
	#comprobar el progreso del jugador
	if GameManager.progreso == GameManager.puzles.LISTAS:
		if pistas_impresas[0] == false:
			array_pistas[0].visible = true
			array_pistas[0]._enable_collisions()
			animation_player.play("imprimir_pista")
			
	if GameManager.progreso == GameManager.puzles.COLAS:
		if pistas_impresas[1] == false:
			array_pistas[1].visible = true
			array_pistas[1]._enable_collisions()
			animation_player.play("imprimir_pista")
			
	if GameManager.progreso == GameManager.puzles.TORRES:
		if pistas_impresas[2] == false:
			array_pistas[2].visible = true
			array_pistas[2]._enable_collisions()
			animation_player.play("imprimir_pista")
			
	if GameManager.progreso == GameManager.puzles.ARBOLES:
		if pistas_impresas[3] == false:
			array_pistas[3].visible = true
			array_pistas[3]._enable_collisions()
			animation_player.play("imprimir_pista")
			
