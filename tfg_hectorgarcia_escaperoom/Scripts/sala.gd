extends Node3D

@export var modo_debug: bool = false
@export var objetos_debugging: Node
@export var panel_modulo: Control
@export var pantalla_info_arboles: Control
@export var pantalla_colas: Control
@export var pantalla_grafos: Control
@export var panel_puerta: Control
@export var pieza_ordenador: StaticBody3D
@export var compartimento_pieza: StaticBody3D
@export var caja: StaticBody3D
@export var torres_hanoi: Node3D
@export var modelo_pieza_compartimento: Node3D
@export var modulo_de_construccion: Node3D
@export var puerta: Node3D
@export var pantalla_arboles: MeshInstance3D
@export var animation_player: AnimationPlayer

var compartimento_abierto: bool = false
var ordenador_arreglado: bool = false
var material_arboles = preload("res://Images/ImageMaterials/material_arboles.tres")

func _ready() -> void:
	goat_inventory.item_used.connect(_on_item_used)
	goat_interaction.object_activated.connect(_on_object_activated)
	pieza_ordenador._disable_collisions()
	if modo_debug == false:
		desactivar_modo_debug()

func _on_item_used(item_name,used_on_name):
	if item_name == "pieza_ordenador" and used_on_name == "compartimento_pieza":
		if compartimento_abierto == false:
			return
		ordenador_arreglado = true
		animation_player.play_backwards("AbrirCompartimento")
		compartimento_abierto = false
		modelo_pieza_compartimento.visible = true
		goat_inventory.remove_item("pieza_ordenador")
		await pantalla_info_arboles.mostrar_texto()
		pantalla_arboles.set_surface_override_material(0,material_arboles)
		pantalla_grafos.encender()
		
	if item_name == "tarjeta_modulo" and used_on_name == "panel_modulo":
		panel_modulo.abrir_modulo()
		modulo_de_construccion.open()
		
	if item_name == "disco_instrucciones" and used_on_name == "ranura_instrucciones":
		animation_player.play("meter_disco")
		await get_tree().create_timer(1.0).timeout
		if pantalla_colas==null:
			print("null")
		pantalla_colas.actualizar_instrucciones()
		goat_inventory.remove_item("disco_instrucciones")

func _on_object_activated(object_name, point):
	if object_name == "caja":
		caja.abrir_caja()
	if object_name == "compartimento_pieza":
		if ordenador_arreglado:
			return
		if compartimento_abierto == false:
			animation_player.play("AbrirCompartimento")
			compartimento_abierto = true
		else:
			animation_player.play_backwards("AbrirCompartimento")
			compartimento_abierto = false

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
	torres_hanoi.queue_free()
	#print("modulo abierto")

func abrir_puerta():
	#print("abriendo puerta")
	puerta.abrir()

func desactivar_modo_debug():
	var objetos = objetos_debugging.get_children()
	for i in objetos:
		i.queue_free()
