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
@onready var pantalla_apagada: ColorRect = $PantallaApagada
@onready var pantalla_texto: AudioStreamPlayer = $PantallaTexto

var ruta_correcta: Array = [2,0,1,3,5]
var peso_correcto: int = 17
var ruta_actual: Array = []
var nodo_actual: int
var nodo_destino: int
var matriz_pesos: Array = [[0, 4, 2, 0, 0, 0],
	[4, 0, 1, 5, 0, 0],
	[2, 1, 0, 8, 10, 0],
	[0, 5, 8, 0, 2, 6],
	[0, 0, 10, 2, 0, 3],
	[0, 0, 0, 6, 3, 0]]
var posicion_nodos: Array
var peso_total: int = 0
var buttons: Array

signal ruta_configurada

func _ready() -> void:
	button_0.pressed.connect(_on_button0_pressed)
	button_1.pressed.connect(_on_button1_pressed)
	button_2.pressed.connect(_on_button2_pressed)
	button_3.pressed.connect(_on_button3_pressed)
	button_4.pressed.connect(_on_button4_pressed)
	button_5.pressed.connect(_on_button5_pressed)
	boton_comprobar_solucion.pressed.connect(_on_buttonsolution_pressed)
	boton_reiniciar.pressed.connect(_on_buttonreiniciar_pressed)
	pantalla_apagada.visible = true
	buttons.append(button_0)
	buttons.append(button_1)
	buttons.append(button_2)
	buttons.append(button_3)
	buttons.append(button_4)
	buttons.append(button_5)
	
	await get_tree().process_frame
	
	var inverse_transform = get_global_transform().affine_inverse()
	
	for b in buttons:
		posicion_nodos.append(inverse_transform * (b.global_position + b.size / 2))
	
	queue_redraw()

func introducir_nodo(nodo: int):
	ruta_actual.append(nodo)
	queue_redraw()
	#print(ruta_actual.size())
	if ruta_actual.size() == 1:
		ruta_label.text = buttons[ruta_actual[0]].text
	else:
		ruta_label.text = ruta_label.text + " - " + buttons[ruta_actual[ruta_actual.size()-1]].text
	peso_label.text = "Gasto de combustible: " + str(peso_total) + "/17"
	feedback_label.text = "Nodo " + str(nodo) + " añadido a la ruta."
	nodo_actual = nodo

func _on_button0_pressed():
	pantalla_texto.play(0)
	nodo_destino = 0
	establecer_ruta()

func _on_button1_pressed():
	pantalla_texto.play(0)
	nodo_destino = 1
	establecer_ruta()

func _on_button2_pressed():
	pantalla_texto.play(0)
	nodo_destino = 2
	establecer_ruta()

func _on_button3_pressed():
	pantalla_texto.play(0)
	nodo_destino = 3
	establecer_ruta()

func _on_button4_pressed():
	pantalla_texto.play(0)
	nodo_destino = 4
	establecer_ruta()

func _on_button5_pressed():
	pantalla_texto.play(0)
	nodo_destino = 5
	establecer_ruta()

func _on_buttonsolution_pressed():
	pantalla_texto.play(0)
	if peso_total < peso_correcto:
		feedback_label.text = "Ruta incorrecta,
		sobra combustible."
	if peso_total > peso_correcto:
		feedback_label.text = "Ruta incorrecta,
		se gasta demasiado combustible."
	if peso_total == peso_correcto:
		if ruta_actual == ruta_correcta:
			feedback_label.text = "Ruta configurada.
			Todo listo para retomar el viaje."
			emit_signal("ruta_configurada")
		else:
			feedback_label.text = "Ruta Incorrecta."

func _on_buttonreiniciar_pressed():
	pantalla_texto.play(0)
	peso_total = 0
	feedback_label.text = ""
	peso_label.text = "Gasto de combustible: " + str(peso_total) + "/17"
	ruta_label.text = ""
	ruta_actual.clear()
	queue_redraw()

func establecer_ruta():
	pantalla_texto.play(0)
	if ruta_actual.is_empty():
		introducir_nodo(nodo_destino)
	else:
		if matriz_pesos[nodo_actual][nodo_destino] != 0:
			peso_total += matriz_pesos[nodo_actual][nodo_destino]
			introducir_nodo(nodo_destino)
		else:
			feedback_label.text = "Nodos no conectados."

func encender():
	pantalla_apagada.queue_free()
	queue_redraw()

func _draw():
	draw_rect(Rect2(Vector2.ZERO, size), Color.BLACK)
	var num_nodos = matriz_pesos.size()
	
	if posicion_nodos.size() < num_nodos:
		return
	#print("posicion_nodos: ", posicion_nodos)
	#print("rect size del Control: ", size)
	
	
	# Dibujar aristas
	for i in range(num_nodos):
		for j in range(i + 1, num_nodos):
			var peso = matriz_pesos[i][j]
			if peso > 0:
				#print(peso)
				var pos_inicial = posicion_nodos[i]
				var pos_final = posicion_nodos[j]
				#print("Dibujando línea de ", pos_inicial, " a ", pos_final)
				var es_camino = false
				for k in range(ruta_actual.size() - 1):
					if (ruta_actual[k] == i and ruta_actual[k + 1] == j) or \
					   (ruta_actual[k] == j and ruta_actual[k + 1] == i):
						es_camino = true
						break
				if es_camino:
					draw_line(pos_inicial, pos_final, Color.GREEN, 5)
				else:
					draw_line(pos_inicial, pos_final, Color.GRAY, 5)
				
				# Dibujar pesos
				var pos_media = (pos_inicial + pos_final) / 2
				draw_circle(pos_media, 15, Color.WHITE)
				draw_string(ThemeDB.fallback_font, pos_media - Vector2(8, -5), str(peso), HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color.BLACK)
