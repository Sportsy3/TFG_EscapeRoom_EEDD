extends Control

@onready var button_1: Button = $Button1
@onready var button_2: Button = $Button2
@onready var button_3: Button = $Button3
@onready var button_4: Button = $Button4
@onready var button_5: Button = $Button5
@onready var button_6: Button = $Button6
@onready var button_7: Button = $Button7
@onready var button_8: Button = $Button8
@onready var button_9: Button = $Button9
@onready var input_label: Label = $InputLabel
@onready var pista_label: Label = $PistaLabel

@export var pista_label_text: String
var combinacion_actual: Array
@export var combinacion_correcta: Array

func _ready() -> void:
	pista_label.text = pista_label_text
	button_1.pressed.connect(_on_button1_pressed)
	button_2.pressed.connect(_on_button2_pressed)
	button_3.pressed.connect(_on_button3_pressed)
	button_4.pressed.connect(_on_button4_pressed)
	button_5.pressed.connect(_on_button5_pressed)
	button_6.pressed.connect(_on_button6_pressed)
	button_7.pressed.connect(_on_button7_pressed)
	button_8.pressed.connect(_on_button8_pressed)
	button_9.pressed.connect(_on_button9_pressed)

func introducir_combinacion(num: int):
	input_label.text += str(num)
	combinacion_actual.append(num)
	if combinacion_actual.size() == combinacion_correcta.size():
		comprobar_combinacion()

func _on_button1_pressed():
	introducir_combinacion(1)

func _on_button2_pressed():
	introducir_combinacion(2)

func _on_button3_pressed():
	introducir_combinacion(3)

func _on_button4_pressed():
	introducir_combinacion(4)

func _on_button5_pressed():
	introducir_combinacion(5)

func _on_button6_pressed():
	introducir_combinacion(6)

func _on_button7_pressed():
	introducir_combinacion(7)

func _on_button8_pressed():
	introducir_combinacion(8)

func _on_button9_pressed():
	introducir_combinacion(9)

func comprobar_combinacion():
	if combinacion_actual == combinacion_correcta:
		get_parent().get_parent().get_parent().get_parent().abrir_puerta()
	else:
		reiniciar_combinacion()

func reiniciar_combinacion():
	combinacion_actual.clear()
	input_label.text = ""
