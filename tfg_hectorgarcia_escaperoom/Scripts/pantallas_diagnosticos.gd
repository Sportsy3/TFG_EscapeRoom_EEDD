extends Node3D

@onready var ubi_actual_pantalla: Control = $UbicacionActual/SubViewport/Content
@onready var ubi_final_pantalla: Control = $UbicacionFinal/SubViewport/Content

func encender():
	ubi_actual_pantalla.encender()
	ubi_final_pantalla.encender()
