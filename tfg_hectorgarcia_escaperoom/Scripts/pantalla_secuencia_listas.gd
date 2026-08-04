extends Control

@onready var secuencia_label: Label = $SecuenciaLabel

func actualizar_secuencia(secuencia: Array):
	var secuencia_string: String = ""
	for i in secuencia.size():
		if i == secuencia.size() - 1:
			secuencia_string += str(secuencia[i])
		else:
			secuencia_string += str(secuencia[i]) + "-"
	secuencia_label.text = secuencia_string
