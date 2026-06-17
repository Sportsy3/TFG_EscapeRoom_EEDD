extends Node3D

var arrayPosiciones1: Array
var arrayPosiciones2: Array
var ocupacion1: Array = [0,0,0,0,3]
var ocupacion2: Array = [0,0,0,0,0]
var carga_seleccionada: int = -1
var puzzle_completado: bool = false

@onready var pos_1_1: Marker3D = $Pos1_1
@onready var pos_1_2: Marker3D = $Pos1_2
@onready var pos_1_3: Marker3D = $Pos1_3
@onready var pos_1_4: Marker3D = $Pos1_4
@onready var pos_1_5: Marker3D = $Pos1_5
@onready var pos_2_1: Marker3D = $Pos2_1
@onready var pos_2_2: Marker3D = $Pos2_2
@onready var pos_2_3: Marker3D = $Pos2_3
@onready var pos_2_4: Marker3D = $Pos2_4
@onready var pos_2_5: Marker3D = $Pos2_5

@export var nodos_cargas: Array[Node3D] = []

func _ready() -> void:
	_inicializar_puzzle()

func _inicializar_puzzle() -> void:
	arrayPosiciones1.append(pos_1_1.position)
	arrayPosiciones1.append(pos_1_2.position)
	arrayPosiciones1.append(pos_1_3.position)
	arrayPosiciones1.append(pos_1_4.position)
	arrayPosiciones1.append(pos_1_5.position)
	arrayPosiciones2.append(pos_2_1.position)
	arrayPosiciones2.append(pos_2_2.position)
	arrayPosiciones2.append(pos_2_3.position)
	arrayPosiciones2.append(pos_2_4.position)
	arrayPosiciones2.append(pos_2_5.position)
	ocupacion1 = [0,0,0,0,3]
	ocupacion2 = [0,0,0,0,0]
