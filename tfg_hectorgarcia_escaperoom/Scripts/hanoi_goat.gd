extends Node3D

# Estado del juego: cada torre es una pila (array), el índice 0 es la base
var torres = {
	"torre_1": [3, 2, 1],  # disco 3 abajo, disco 1 arriba (el más pequeño)
	"torre_2": [],
	"torre_3": []
}

var disco_seleccionado = null  # número de disco actualmente en mano

# Posiciones físicas de cada torre (ajusta a tu escena)
@onready var posiciones_torre = {
	"torre_1": $Torre1.global_position,
	"torre_2": $Torre2.global_position,
	"torre_3": $Torre3.global_position
}

@onready var discos = {
	1: $Disco1,
	2: $Disco2,
	3: $Disco3
}

const ALTURA_DISCO = 0.2  # grosor de cada disco, para apilar visualmente

func _ready():
	goat_interaction.object_activated.connect(_on_object_activated)
	_actualizar_posiciones()

func _on_object_activated(object_name, point):
	if object_name.begins_with("disco_"):
		var numero = int(object_name.split("_")[1])
		_seleccionar_disco(numero)
	elif object_name.begins_with("torre_"):
		_mover_a_torre(object_name)

func _seleccionar_disco(numero):
	# Solo se puede coger el disco superior de su torre
	for torre_nombre in torres:
		var pila = torres[torre_nombre]
		if not pila.is_empty() and pila[-1] == numero:
			if disco_seleccionado == numero:
				# Click otra vez = deseleccionar
				disco_seleccionado = null
				discos[numero].global_position.y -= 0.3  # bajarlo visualmente
			else:
				if disco_seleccionado != null:
					discos[disco_seleccionado].position.y -= 0.3
				disco_seleccionado = numero
				discos[numero].position.y += 0.3  # "levantarlo" visualmente
			return
	# Si no es el disco superior, no se puede coger (opcional: sonido de error)

func _mover_a_torre(torre_destino):
	if disco_seleccionado == null:
		return
	var pila_destino = torres[torre_destino]
	# Regla de Hanoi: solo se puede colocar si el destino está vacío o el disco superior del destino es más grande
	if pila_destino.is_empty() or pila_destino[-1] > disco_seleccionado:
		# Quitar el disco de su torre actual
		for torre_nombre in torres:
			var pila = torres[torre_nombre]
			if not pila.is_empty() and pila[-1] == disco_seleccionado:
				pila.pop_back()
				break

		# Añadirlo a la nueva torre
		pila_destino.append(disco_seleccionado)
		discos[disco_seleccionado].position.y -= 0.3  # bajarlo de "en mano"
		disco_seleccionado = null

		_actualizar_posiciones()
		_comprobar_victoria()
	else:
		# Movimiento inválido (opcional: feedback visual/sonoro)
		pass

func _actualizar_posiciones():
	for torre_nombre in torres:
		var pila = torres[torre_nombre]
		var pos_base = posiciones_torre[torre_nombre]
		for i in range(pila.size()):
			var numero_disco = pila[i]
			var nueva_pos = pos_base
			nueva_pos.y = pos_base.y + (i* ALTURA_DISCO)
			discos[numero_disco].global_position = nueva_pos

func _comprobar_victoria():
	if torres["torre_3"] == [3, 2, 1]:
		print("¡Puzzle resuelto!")
		get_parent().get_parent().fabricar_pieza()
