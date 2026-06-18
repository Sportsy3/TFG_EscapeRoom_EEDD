extends Control

const ELEMENTOS = ["A", "B", "C", "D", "E"]
const OBJETIVO = ["A", "B", "C", "D", "E"]
const MAX_ELEMENTOS = 5

var rendija1: Array = ["C"]  # empieza con el 3er elemento
var rendija2: Array = []
var seleccion_actual: String = ""
var bloqueado: bool = false
var bloqueo_total: bool = false

@onready var slots_r1 = $HBoxContainer/VBoxContainer/SlotRendija1
@onready var slots_r2 = $HBoxContainer/VBoxContainer/SlotRendija2
@onready var botones_elementos = $HBoxContainer/VBoxContainer/BotonesElementos
@onready var label_resultado = $HBoxContainer/VBoxContainer/LabelResultado

func _ready():
	# Conectar botones de elementos
	for btn in botones_elementos.get_children():
		btn.pressed.connect(_on_elemento_pressed.bind(btn.text))
	$HBoxContainer/VBoxContainer/BtnIntroducir.pressed.connect(_on_introducir_pressed)
	$HBoxContainer/VBoxContainer/BtnIntercambiar.pressed.connect(_on_intercambiar_pressed)
	$HBoxContainer/BotonReinicio.pressed.connect(_on_reinicio_pressed)
	actualizar_ui()

func _on_elemento_pressed(elemento: String):
	seleccion_actual = elemento
	label_resultado.text = "Seleccionado: " + elemento

func _on_introducir_pressed():
	if bloqueo_total:
		label_resultado.text = "Espera a que acabe el intercambio."
		return
	if bloqueado:
		label_resultado.text = "Reinicia el sistema."
		return
	if seleccion_actual == "":
		label_resultado.text = "Selecciona un elemento primero."
		return
	if rendija2.size() >= MAX_ELEMENTOS:
		label_resultado.text = "La Rendija 2 está llena."
		return
	rendija2.append(seleccion_actual)
	actualizar_ui()

func _on_intercambiar_pressed():
	if bloqueo_total:
		label_resultado.text = "Espera a que acabe el intercambio."
		return
	if bloqueado:
		label_resultado.text = "Reinicia el sistema."
		return
	if rendija2.size() < 4:
		label_resultado.text = "La Rendija 2 necesita 4 elementos."
		return
	await realizar_intercambio()
	comprobar_victoria()

func realizar_intercambio():
	bloqueo_total = true
	# Las transferencias son secuenciales, FIFO (pop del frente, push al final)
	await transferir(rendija2, rendija1, 3)  # Paso 1: R2 → R1 (3 elementos)
	await transferir(rendija1, rendija2, 1)  # Paso 2: R1 → R2 (1 elemento)
	await transferir(rendija2, rendija1, 2)  # Paso 3: R2 → R1 (2 elementos)
	await transferir(rendija1, rendija2, 2)  # Paso 4: R1 → R2 (2 elementos)
	await transferir(rendija2, rendija1, 2)  # Paso 5: R2 → R1 (2 elementos)
	bloqueo_total = false

func transferir(origen: Array, destino: Array, cantidad: int):
	for i in range(cantidad):
		if origen.is_empty():
			break
		destino.append(origen.pop_front())
		await get_tree().create_timer(1.0).timeout
		actualizar_ui()
	

func comprobar_victoria():
	if rendija1 == OBJETIVO:
		label_resultado.text = "¡Puzle resuelto!"
	else:
		bloqueado = true
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

func _on_reinicio_pressed():
	if bloqueo_total:
		label_resultado.text = "Espera a que acabe el intercambio."
		return
	reiniciar_puzle()

func reiniciar_puzle():
	rendija1.clear()
	rendija2.clear()
	slots_r1 = $HBoxContainer/VBoxContainer/SlotRendija1
	slots_r2 = $HBoxContainer/VBoxContainer/SlotRendija2
	rendija1 = ["C"]  # empieza con el 3er elemento
	seleccion_actual = ""
	actualizar_ui()
	bloqueado = false
