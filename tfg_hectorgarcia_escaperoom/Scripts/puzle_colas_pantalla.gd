extends Control

const ELEMENTOS = ["A", "B", "C", "D", "E"]
const OBJETIVO = ["A", "B", "C", "D", "E"]
const MAX_ELEMENTOS = 5

var rendija1: Array = ["C"]  # empieza con el 3er elemento
var rendija2: Array = []
var seleccion_actual: String = ""

@onready var slots_r1 = $VBoxContainer/SlotRendija1
@onready var slots_r2 = $VBoxContainer/SlotRendija2
@onready var botones_elementos = $VBoxContainer/BotonesElementos
@onready var label_resultado = $VBoxContainer/LabelResultado

func _ready():
	# Conectar botones de elementos
	for btn in botones_elementos.get_children():
		btn.pressed.connect(_on_elemento_pressed.bind(btn.text))
	$VBoxContainer/BtnIntroducir.pressed.connect(_on_introducir_pressed)
	$VBoxContainer/BtnIntercambiar.pressed.connect(_on_intercambiar_pressed)
	actualizar_ui()

func _on_elemento_pressed(elemento: String):
	seleccion_actual = elemento
	label_resultado.text = "Seleccionado: " + elemento

func _on_introducir_pressed():
	if seleccion_actual == "":
		label_resultado.text = "Selecciona un elemento primero."
		return
	if rendija2.size() >= MAX_ELEMENTOS:
		label_resultado.text = "La Rendija 2 está llena."
		return
		rendija2.append(seleccion_actual)
	actualizar_ui()

func _on_intercambiar_pressed():
	print("tu puta madre")
	if rendija2.is_empty():
		label_resultado.text = "La Rendija 2 está vacía."
		return
	realizar_intercambio()
	actualizar_ui()
	comprobar_victoria()

func realizar_intercambio():
	# Las transferencias son secuenciales, FIFO (pop del frente, push al final)
	transferir(rendija2, rendija1, 3)  # Paso 1: R2 → R1 (3 elementos)
	transferir(rendija1, rendija2, 1)  # Paso 2: R1 → R2 (1 elemento)
	transferir(rendija2, rendija1, 2)  # Paso 3: R2 → R1 (2 elementos)
	transferir(rendija1, rendija2, 2)  # Paso 4: R1 → R2 (2 elementos)
	transferir(rendija2, rendija1, 2)  # Paso 5: R2 → R1 (2 elementos)

func transferir(origen: Array, destino: Array, cantidad: int):
	for i in range(cantidad):
		if origen.is_empty():
			break
		destino.append(origen.pop_front())

func comprobar_victoria():
	if rendija1 == OBJETIVO:
		label_resultado.text = "¡Puzle resuelto!"
	else:
		label_resultado.text = "Incorrecto. Sigue intentándolo."

func actualizar_ui():
	_actualizar_slots(slots_r1, rendija1)
	_actualizar_slots(slots_r2, rendija2)

func _actualizar_slots(contenedor: HBoxContainer, datos: Array):
	# Limpiar casillas existentes
	for hijo in contenedor.get_children():
		hijo.queue_free()
	# Crear una casilla por elemento
	for i in range(MAX_ELEMENTOS):
		var panel = Panel.new()
		panel.custom_minimum_size = Vector2(60, 60)
		var label = Label.new()
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.text = datos[i] if i < datos.size() else ""
		panel.add_child(label)
		contenedor.add_child(panel)
