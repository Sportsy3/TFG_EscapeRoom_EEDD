extends Control

@onready var button_0: Button = $Button0
@onready var button_1: Button = $Button1
@onready var button_2: Button = $Button2
@onready var button_3: Button = $Button3
@onready var button_4: Button = $Button4
@onready var button_5: Button = $Button5
@onready var boton_comprobar_solucion: Button = $BotonComprobarSolucion
@onready var boton_reiniciar: Button = $BotonReiniciar
@onready var feedback_label: Label = $FeedbackLabel
@onready var peso_label: Label = $PesoLabel
@onready var ruta_label: Label = $RutaLabel

var ruta_correcta: Array = [2,0,1,3,5]
var peso_correcto: int = 17
var ruta_actual: Array
var nodo_actual: int
var nodo_destino: int
var matriz_pesos: Array = [[0, 4, 2, 0, 0, 0],
	[4, 0, 1, 5, 0, 0],
	[2, 1, 0, 8, 10, 0],
	[0, 5, 8, 0, 2, 6],
	[0, 0, 10, 2, 0, 3],
	[0, 0, 0, 6, 3, 0]]
var peso_total: int = 0

func _ready() -> void:
	button_0.pressed.connect(_on_button0_pressed)
	button_1.pressed.connect(_on_button1_pressed)
	button_2.pressed.connect(_on_button2_pressed)
	button_3.pressed.connect(_on_button3_pressed)
	button_4.pressed.connect(_on_button4_pressed)
	button_5.pressed.connect(_on_button5_pressed)
	boton_comprobar_solucion.pressed.connect(_on_buttonsolution_pressed)
	boton_reiniciar.pressed.connect(_on_buttonreiniciar_pressed)

func introducir_nodo(nodo: int):
	ruta_actual.append(nodo)
	for i in ruta_actual.size():
		if i == 0:
			ruta_label.text = str(ruta_actual[i])
		else:
			ruta_label.text = ruta_label.text + " - " + str(ruta_actual[i])
	peso_label.text = "Gasto de combustible: " + str(peso_total) + "/17"
	feedback_label.text = "Nodo " + str(nodo) + " añadido a la ruta."
	nodo_actual = nodo

func _on_button0_pressed():
	nodo_destino = 0
	establecer_ruta()

func _on_button1_pressed():
	nodo_destino = 1
	establecer_ruta()

func _on_button2_pressed():
	nodo_destino = 2
	establecer_ruta()

func _on_button3_pressed():
	nodo_destino = 3
	establecer_ruta()

func _on_button4_pressed():
	nodo_destino = 4
	establecer_ruta()

func _on_button5_pressed():
	nodo_destino = 5
	establecer_ruta()

func _on_buttonsolution_pressed():
	if peso_total < peso_correcto:
		feedback_label.text = "Ruta incorrecta, sobra combustible."
	if peso_total > peso_correcto:
		feedback_label.text = "Ruta incorrecta, se gasta demasiado combustible."
	if peso_total == peso_correcto:
		if ruta_actual == ruta_correcta:
			feedback_label.text = "Ruta configurada. Todo listo para retomar el viaje."

func _on_buttonreiniciar_pressed():
	peso_total = 0
	feedback_label.text = ""
	peso_label.text = "Gasto de combustible: " + str(peso_total) + "/17"
	ruta_label.text = ""
	ruta_actual.clear()

func establecer_ruta():
	if ruta_actual.is_empty():
		introducir_nodo(nodo_destino)
	else:
		if matriz_pesos[nodo_actual][nodo_destino] != 0:
			peso_total += matriz_pesos[nodo_actual][nodo_destino]
			introducir_nodo(nodo_destino)
		else:
			feedback_label.text = "Nodos no conectados."
