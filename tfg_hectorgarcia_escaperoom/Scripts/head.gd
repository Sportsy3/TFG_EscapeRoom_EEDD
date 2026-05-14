extends Node3D


@onready var cam = $"."
@onready var ch3d = $".."
@onready var raycast = $Camera3D/RayCast3D
@onready var hand = $Hand
#@onready var hanoi = get_tree().get_first_node_in_group("hanoi_puzzle")
@export var hanoi: Node3D
var v = Vector3()
var sens = 0.12


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	await get_tree().process_frame  # espera un frame a que todo esté en el árbol
	hanoi = get_tree().get_first_node_in_group("hanoi_puzzle")

func _process(delta):
	cam.rotation_degrees.x = v.x
	ch3d.rotation_degrees.y = v.y

func _interact_with_screen(screen_body: CollisionObject3D) -> void:
	var result = raycast.get_collision_point()
	var mesh: MeshInstance3D = screen_body.get_parent().get_node("MeshInstance3D")
	var subviewport: SubViewport = screen_body.get_parent().get_node("SubViewport")

	var local_pos = mesh.to_local(result)
	var uv = Vector2((local_pos.x + 0.5),(-local_pos.y + 0.5))
	uv = uv.clamp(Vector2.ZERO, Vector2.ONE)
	
	var vp_size = Vector2(subviewport.size)
	var click_pos = uv * vp_size
	
	# 1. Primero enviar movimiento de ratón para que el botón entre en hover
	var motion = InputEventMouseMotion.new()
	motion.position = click_pos
	motion.global_position = click_pos
	subviewport.push_input(motion)
	
	await get_tree().process_frame

	# 2. Press
	var press = InputEventMouseButton.new()
	press.position = click_pos
	press.global_position = click_pos
	press.button_index = MOUSE_BUTTON_LEFT
	press.pressed = true
	subviewport.push_input(press)
	
	await get_tree().process_frame
	
	# 3. Release (necesario para que Button emita la señal "pressed")
	var release = InputEventMouseButton.new()
	release.position = click_pos
	release.global_position = click_pos
	release.button_index = MOUSE_BUTTON_LEFT
	release.pressed = false
	subviewport.push_input(release)

#var object = raycast.get_collider()
	#if raycast.is_colliding():
		#var parent = object.get_parent()  # ← subimos al Disco_* o Torre_*
		#print("padre: ", parent.name, " | en grupo discos: ", parent.is_in_group("discos"), " | en grupo torres: ", parent.is_in_group("torres"))
				# ── Interacción con disco de Hanoi ──
		#if parent.is_in_group("disco"):
			#print("apuntando a disco, is_action_just_pressed: ", Input.is_action_just_pressed("interact"))
			#if Input.is_action_just_pressed("interact"):
				#var disco_id = object.get_meta("disco_id")
				#print("llamando interactuar_con_disco con id: ", disco_id)
				#hanoi.interactuar_con_disco(disco_id)
#
		# ── Interacción con torre de Hanoi ──
		#elif parent.is_in_group("torre"):
			#if Input.is_action_just_pressed("interact"):
				#var idx = 0
				#if object.name == "Torre_B": idx = 1
				#elif object.name == "Torre_C": idx = 2
				#hanoi.interactuar_con_torre(idx)
		#if object.is_in_group("pickable"):
			#if Input.is_action_just_pressed("interact"):
				#object.global_position = hand.global_position
				#object.global_rotation = hand.global_rotation
				#object.collision_layer = 2
				#object.linear_velocity = Vector3(0.1, 3, 0.1)

func _input(event):
	if event is InputEventMouseMotion:
		v.y -= (event.relative.x * sens)
		v.x -= (event.relative.y * sens)
		v.x = clamp(v.x, -80, 90)
	
	if event.is_action_pressed("interact"):
		var object = raycast.get_collider()
		if not raycast.is_colliding():
			return
		var parent = object.get_parent()
		
		if parent.is_in_group("discos"):
			var disco_id = parent.get_meta("disco_id")
			print("interact disco id: ", disco_id)
			hanoi.interactuar_con_disco(disco_id)
		
		elif parent.is_in_group("torres"):
			var idx = 0
			if parent.name == "Torre_B": idx = 1
			elif parent.name == "Torre_C": idx = 2
			print("interact torre idx: ", idx)
			hanoi.interactuar_con_torre(idx)
		
		elif object.is_in_group("pickable"):
			object.global_position = hand.global_position
			object.global_rotation = hand.global_rotation
			object.collision_layer = 2
			object.linear_velocity = Vector3(0.1, 3, 0.1)
		
		elif object.is_in_group("pantalla"):
			_interact_with_screen(object)
		
		elif object.is_in_group("Panelillo"):
			object.girar_panelillo()

#func _input(event):
	#if event is InputEventMouseMotion:
		#v.y -= (event.relative.x * sens)
		#v.x -= (event.relative.y * sens)
		#v.x = clamp(v.x,-80,90)
