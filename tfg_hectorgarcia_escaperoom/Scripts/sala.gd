extends Node3D

@export var panel_modulo: Control
@export var modulo_de_construccion: Node3D

func _ready() -> void:
	goat_inventory.item_used.connect(_on_item_used)

func _on_item_used(item_name,used_on_name):
	if item_name == "pieza_ordenador" and used_on_name == "ranura_ordenador":
		print("Ordenador arreglado")
	if item_name == "tarjeta_modulo" and used_on_name == "panel_modulo":
		panel_modulo.abrir_modulo()
		modulo_de_construccion.open()
