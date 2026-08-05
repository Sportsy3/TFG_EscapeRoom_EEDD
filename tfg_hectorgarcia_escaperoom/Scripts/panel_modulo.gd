extends Control

@onready var label: Label = $Label
@onready var color_rect_2: ColorRect = $ColorRect2
var modulo_abierto: bool = false
signal _abrir_modulo

func abrir_modulo():
	if modulo_abierto == false:
		label.text = "Acceso concedido"
		color_rect_2.color = Color(0,1,0)
		emit_signal("_abrir_modulo")
		modulo_abierto = true
