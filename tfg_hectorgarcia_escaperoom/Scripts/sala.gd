extends Node3D

@export var panel_modulo: Control
@export var modulo_de_construccion: Node3D
@export var pieza_ordenador: StaticBody3D
@export var torres_hanoi: Node3D
@export var caja: StaticBody3D
@export var animation_player: AnimationPlayer
@export var pantalla_colas: Control


func _ready() -> void:
	goat_inventory.item_used.connect(_on_item_used)
	goat_interaction.object_activated.connect(_on_object_activated)
	pieza_ordenador._disable_collisions()

func _on_item_used(item_name,used_on_name):
	if item_name == "pieza_ordenador" and used_on_name == "ranura_ordenador":
		print("Ordenador arreglado")
	if item_name == "tarjeta_modulo" and used_on_name == "panel_modulo":
		panel_modulo.abrir_modulo()
		modulo_de_construccion.open()
	if item_name == "disco_instrucciones" and used_on_name == "ranura_instrucciones":
		animation_player.play("meter_disco")
		await get_tree().create_timer(1.0).timeout
		if pantalla_colas==null:
			print("null")
		pantalla_colas.actualizar_instrucciones()

func _on_object_activated(object_name, point):
	if object_name == "caja":
		caja.abrir_caja()

func fabricar_pieza():
	modulo_de_construccion.close()
	#print("módulo cerrado")
	await get_tree().create_timer(1.0).timeout
	torres_hanoi.visible = false
	#print("torres invisibles")
	pieza_ordenador.visible = true
	pieza_ordenador._enable_collisions()
	#print("pieza visible")
	await get_tree().create_timer(2.0).timeout
	modulo_de_construccion.open()
	#print("modulo abierto")
