extends Control

@onready var texto: Label = $Texto

var velocidad_tecleo: float = 50
var tiempo_tecleo: float

func _ready() -> void:
	texto.visible_characters = 0

func mostrar_texto():
	texto.visible_characters = 0
	tiempo_tecleo = 0
	while texto.visible_characters < texto.get_total_character_count():
		tiempo_tecleo += get_process_delta_time()
		texto.visible_characters = int(velocidad_tecleo * tiempo_tecleo)
		await get_tree().process_frame
