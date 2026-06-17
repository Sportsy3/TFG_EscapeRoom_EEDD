extends Node3D

#func _ready():
	#var jugador = $Player  # ajusta el nombre
	#var script_interaccion = jugador.get_node("Head")  # el que tiene el script de interacción
	#var hanoi_puzzle = $hanoi_puzzle  # ajusta la ruta
	#script_interaccion.hanoi = hanoi_puzzle
@onready var panelillo_1: StaticBody3D = $Panelillo1
@onready var panelillo_2: StaticBody3D = $Panelillo2

func _ready():
	# Conexión de la señal de cada objeto al interactuar con este
	goat_interaction.object_activated.connect(_on_object_activated)


func _on_object_activated(object_name, point):
	# Programación de lo que hace cada objeto al interactuar, object_name es el nombre que
	# tiene el objeto con el que se haya interactuado dentro de la propiedad Unique Name
	# en base al object_name que reciba la función pasarán las cosas que se pongan en los ifs
	if object_name == "test_item":
		print("Probando item: " + object_name)
	if object_name == "test_item2":
		print("Probando item: " + object_name)
	if object_name == "panelillo_1":
		print("Probando item: " + object_name)
		panelillo_1.girar_panelillo()
	if object_name == "panelillo_2":
		print("Probando item: " + object_name)
		panelillo_2.girar_panelillo()
