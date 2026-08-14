extends Control

@onready var line_edit: LineEdit = $HBoxContainer/VBoxContainer/LineEdit
@onready var line_edit_2: LineEdit = $HBoxContainer/VBoxContainer/LineEdit2
@onready var button: Button = $HBoxContainer/VBoxContainer/Button
@onready var label: Label = $HBoxContainer/VBoxContainer/Label

var email: String
var password: String

func _ready() -> void:
	button.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	email = line_edit.text
	password = line_edit_2.text
	
	if email == "" or password == "":
		label.text = "Introduce email y contraseña de Escapp"
		return
	
	SocketIoClient.student_email = email
	SocketIoClient.student_password = password
	SocketIoClient.authenticated.connect(_on_authenticated)
	SocketIoClient.authentication_failed.connect(_on_authentication_failed)
	SocketIoClient.connect_to_server()

func _on_authenticated():
	get_tree().change_scene_to_file("res://UI/menu_inicial.tscn")

func _on_authentication_failed():
	label.text = "Email o contraseña incorrectos"
