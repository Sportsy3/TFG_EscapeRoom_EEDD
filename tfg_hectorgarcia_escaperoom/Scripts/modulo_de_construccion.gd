extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	get_tree().get_first_node_in_group("signals_test").connect("object_triggered",open)

func open():
	animation_player.play("open")
