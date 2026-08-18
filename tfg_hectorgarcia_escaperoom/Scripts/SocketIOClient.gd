extends Node

#class_name SocketIOClient

#signal connected
#signal disconnected(msg: String)
#signal error_occurred(err: String)
#signal initial_info_received(data: Dictionary)
#signal team_progress_received(data: Dictionary)
#signal team_started(data: Dictionary)
#signal player_joined(data: Dictionary)
#signal player_left(data: Dictionary)
#signal hint_response_received(data: Dictionary)
#signal puzzle_response_received(data: Dictionary)
#signal game_started
#signal game_stopped
signal authenticated
signal authentication_failed

@onready var _window = JavaScriptBridge.get_interface("window")
var _socket = null


@export var server_url = "wss://escapp.es" # Esto dejalo así tal cual
@export var escape_room_id = "757" # Cambia por tu id
@export var student_email = ""
@export var student_password = ""

# Los callbacks deben estar siempre en memoria para que el GarbageCollector de JavaScript no los elimine
var _connect_callback = null
var _disconnect_callback = null
var _error_callback = null
var _initial_info_callback = null
var _team_progress_callback = null
var _team_started_callback = null
var _join_callback = null
var _leave_callback = null
var _hint_response_callback = null
var _puzzle_response_callback = null
var _start_callback = null
var _stop_callback = null

func _ready():
	if _window.io != null:
		_create_callbacks()
		#connect_to_server()


func _create_callbacks():
	# Conecta los callbacks de JavaScript con las funciones de Godot. Los nombres entre paréntesis son las funciones de Godot.
	_connect_callback = JavaScriptBridge.create_callback(_on_socket_connect)
	_disconnect_callback = JavaScriptBridge.create_callback(_on_socket_disconnect)
	_error_callback = JavaScriptBridge.create_callback(_on_socket_error)
	_initial_info_callback = JavaScriptBridge.create_callback(_on_initial_info)
	_team_progress_callback = JavaScriptBridge.create_callback(_on_team_progress)
	_team_started_callback = JavaScriptBridge.create_callback(_on_team_started)
	_join_callback = JavaScriptBridge.create_callback(_on_player_join)
	_leave_callback = JavaScriptBridge.create_callback(_on_player_leave)
	_hint_response_callback = JavaScriptBridge.create_callback(_on_hint_response)
	_puzzle_response_callback = JavaScriptBridge.create_callback(_on_puzzle_response)
	_start_callback = JavaScriptBridge.create_callback(_on_game_start)
	_stop_callback = JavaScriptBridge.create_callback(_on_game_stop)

func connect_to_server():
	print("Connecting to server...")
	
	# Ver la documentación de escapp. los parámetros son:
	#io("wss://escapp.es", {withCredentials: false, transports: ['websocket', 'polling'], query: {
	#"escapeRoom": X,
	#"email": "X@X.X",
	#"password": "X"
	#}})
	
	#Que se corresponde a:
	var options = JavaScriptBridge.create_object("Object")
	options.withCredentials = false
	options.transports = ["websocket", "polling"]
	options.reconection = false
	
	var query = JavaScriptBridge.create_object("Object")
	query.escapeRoom = escape_room_id
	query.email = student_email
	query.password = student_password
	options.query = query
	
	_socket = _window.io("wss://escapp.es", options)

	if not _socket:
		push_error("Failed to create socket connection")
		return
	
	print("Socket created, setting up listeners...")
	
	_socket.on("connect", _connect_callback)
	
	_socket.on("disconnect", _disconnect_callback)
	_socket.on("error", _error_callback)
	_socket.on("ERROR", _error_callback)
	_socket.on("connect_error", _error_callback)
	_socket.on("INITIAL_INFO", _initial_info_callback)
	_socket.on("TEAM_PROGRESS", _team_progress_callback)
	_socket.on("TEAM_STARTED", _team_started_callback)
	_socket.on("JOIN", _join_callback)
	_socket.on("LEAVE", _leave_callback)
	_socket.on("HINT_RESPONSE", _hint_response_callback)
	_socket.on("PUZZLE_RESPONSE", _puzzle_response_callback)
	_socket.on("START", _start_callback)
	_socket.on("STOP", _stop_callback)

# Los callbacks pueden, o no, tener argumentos, pero si tienen, los datos siempre vienen en args[0]
func _on_socket_connect(_args):
	print("Connected to server")

func _on_socket_disconnect(args):
	var msg = args[0]
	print("Disconnected from server: ", msg)

func _on_socket_error(args):
	var err = args[0]
	print("Error: ", err)

func _on_initial_info(args):
	var data = _js_object_to_dict(args[0])
	print("INITIAL_INFO: ", data)
	
	if data.get("authentication") == true:
		emit_signal("authenticated")
	else:
		disconnect_socket()
		emit_signal("authentication_failed")
	#if data.get("authentication") == true and data.get("participation") == "NOT_STARTED":
		#_socket.emit("START_PLAYING")
	#
	#if data.get("participation") == "PARTICIPANT":
		# Game is already in progress
		#Do X to continue

func _on_team_progress(args):
	var data = _js_object_to_dict(args[0])
	print("TEAM_PROGRESS: ", data)

func _on_team_started(args):
	var data = _js_object_to_dict(args[0])
	print("TEAM_STARTED: ", data)

func _on_player_join(args):
	var data = _js_object_to_dict(args[0])
	print("JOIN: ", data)

func _on_player_leave(args):
	var data = _js_object_to_dict(args[0])
	print("LEAVE: ", data)

func _on_hint_response(args):
	var data = _js_object_to_dict(args[0])
	print("HINT_RESPONSE: ", data)

func _on_puzzle_response(args):
	var data = _js_object_to_dict(args[0])
	print("PUZZLE_RESPONSE: ", data)
	if data.get("correctAnswer") == true:
		print("Puzzle resuelto correctamente!")
	else:
		print("Respuesta incorrecta")

func _on_game_start(_args):
	print("START received")

func _on_game_stop(_args):
	print("STOP received")


func solve_puzzle(puzzle_order: int, solution: String):
	print("solve_puzzle llamado con orden: ", puzzle_order, " solución: ", solution)
	if not _socket:
		push_error("Socket not connected")
		return
	var data = JavaScriptBridge.create_object("Object")
	data.puzzleOrder = puzzle_order
	data.sol = solution
	
	_socket.emit("SOLVE_PUZZLE", data)

func request_hint(status: String, score: int, category: String):
	if not _socket:
		push_error("Socket not connected")
		return
	
	var data = JavaScriptBridge.create_object("Object")
	data.status = status
	data.score = score
	data.category = category
	
	_socket.emit("REQUEST_HINT", data)

func start_playing():
	if not _socket:
		push_error("Socket not connected")
		return
	
	_socket.emit("START_PLAYING")

func disconnect_socket():
	if _socket:
		_socket.disconnect()
		_socket = null

func is_connected_to_server() -> bool:
	return _socket != null


func _js_object_to_dict(js_obj):
	if js_obj == null:
		return {}

	if typeof(js_obj) in [TYPE_DICTIONARY, TYPE_STRING, TYPE_INT, TYPE_FLOAT, TYPE_BOOL]:
		return js_obj
	
	var result = {}
	var keys = JavaScriptBridge.get_interface("Object").keys(js_obj)
	
	for i in range(keys.length):
		var key = keys[i]
		var value = js_obj[key]
		
		if typeof(value) == TYPE_OBJECT:
			result[key] = _js_object_to_dict(value)
		else:
			result[key] = value

	return result


func _exit_tree():
	disconnect_socket()
	
	_connect_callback = null
	_disconnect_callback = null
	_error_callback = null
	_initial_info_callback = null
	_team_progress_callback = null
	_team_started_callback = null
	_join_callback = null
	_leave_callback = null
	_hint_response_callback = null
	_puzzle_response_callback = null
	_start_callback = null
	_stop_callback = null
