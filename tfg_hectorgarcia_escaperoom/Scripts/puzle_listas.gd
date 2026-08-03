extends Node3D

var panelillos: Array = []
@export var panelillo_1: StaticBody3D
@export var panelillo_2: StaticBody3D
@export var panelillo_3: StaticBody3D
@export var panelillo_4: StaticBody3D
@export var panelillo_5: StaticBody3D
@export var panelillo_6: StaticBody3D
@export var panelillo_7: StaticBody3D
@export var panelillo_8: StaticBody3D
@export var panelillo_9: StaticBody3D
@export var pantalla_secuencia: Control

var secuencia_actual: Array = []

func _ready() -> void:
	goat_interaction.object_activated.connect(_on_object_activated)
	panelillos.append(panelillo_1)
	panelillos.append(panelillo_2)
	panelillos.append(panelillo_3)
	panelillos.append(panelillo_4)
	panelillos.append(panelillo_5)
	panelillos.append(panelillo_6)
	panelillos.append(panelillo_7)
	panelillos.append(panelillo_8)
	panelillos.append(panelillo_9)

func _on_object_activated(object_name,point):
	if object_name == "boton_reiniciar":
		reiniciar_puzle()
	if "panelillo_" in object_name:
		#print("object name: " + object_name)
		for i in panelillos.size():
			#print("i: " + str(i))
			if object_name == "panelillo_" + str(i+1):
				if panelillos[i].panel_girado:
					return
				secuencia_actual.append(panelillos[i].num_panel)
				print(str(secuencia_actual))
				panelillos[i].girar_panelillo()
				pantalla_secuencia.actualizar_secuencia(secuencia_actual)
				#print("panelillo unique name: "+panelillos[i].unique_name)

func reiniciar_puzle():
	secuencia_actual.clear()
	pantalla_secuencia.actualizar_secuencia(secuencia_actual)
	for panel in panelillos:
		panel.resetear_panelillo()
