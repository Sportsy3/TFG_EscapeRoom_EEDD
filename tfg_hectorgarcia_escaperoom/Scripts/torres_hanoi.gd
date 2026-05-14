extends Node3D
 
# ─────────────────────────────────────────
#  SEÑALES
# ─────────────────────────────────────────
 
# Emitida cuando el jugador completa el puzzle.
signal puzzle_resuelto
 
# Emitida cuando se produce un movimiento inválido.
# Útil para reproducir un sonido de error o mostrar feedback.
signal movimiento_invalido(razon: String)
 
# Emitida tras cada movimiento válido.
# Devuelve el disco movido, la torre origen y la torre destino.
signal disco_movido(disco_id: int, de_torre: int, a_torre: int)
 
# ─────────────────────────────────────────
#  CONFIGURACIÓN
# ─────────────────────────────────────────
 
@export var num_discos: int = 3
 
# Altura base de la posición Y de los discos sobre la peana de cada torre.
@export var altura_base_disco: float = 0.1
 
# Separación vertical entre discos apilados.
@export var separacion_entre_discos: float = 0.15
 
# Referencias a los nodos 3D de cada torre (asígnalas en el Inspector).
@export var torre_a: Node3D
@export var torre_b: Node3D
@export var torre_c: Node3D
 
# Referencias a los nodos 3D de los discos, ordenados de mayor (0) a menor (n-1).
# Asígnalos en el Inspector en el mismo orden.
@export var nodos_disco: Array[Node3D] = []
 
# ─────────────────────────────────────────
#  ESTADO INTERNO
# ─────────────────────────────────────────
 
# Las tres torres representadas como pilas de IDs de disco.
# Disco ID 0 = el más grande, ID (num_discos-1) = el más pequeño.
# torres[0] = Torre A, torres[1] = Torre B, torres[2] = Torre C
var torres: Array = [[], [], []]
 
# Disco actualmente seleccionado por el jugador (-1 si ninguno).
var disco_seleccionado: int = -1
 
# Torre desde la que se cogió el disco seleccionado.
var torre_origen: int = -1
 
# Número de movimientos realizados (opcional, para estadísticas o retos).
var num_movimientos: int = 0
 
# Indica si el puzzle ya fue resuelto (evita procesar más input).
var puzzle_completado: bool = false
 
# ─────────────────────────────────────────
#  INICIALIZACIÓN
# ─────────────────────────────────────────
 
func _ready() -> void:
	add_to_group("hanoi_puzzle")  # ← añade esta línea
	_inicializar_puzzle()
 
# Reinicia el puzzle al estado inicial: todos los discos en Torre A.
func _inicializar_puzzle() -> void:
	puzzle_completado = false
	num_movimientos = 0
	disco_seleccionado = -1
	torre_origen = -1
 
	# Vaciar las tres torres
	torres[0].clear()
	torres[1].clear()
	torres[2].clear()
 
	# Colocar todos los discos en Torre A, del más grande al más pequeño
	for i in range(num_discos):
		torres[0].append(i)  # disco 0 es el más grande (fondo), disco n-1 el más pequeño (cima)
 
	# Sincronizar posición visual de los nodos 3D
	_actualizar_posiciones_visuales()
 
# ─────────────────────────────────────────
#  API PÚBLICA — llama estas funciones desde tu sistema de interacción
# ─────────────────────────────────────────
 
# Llamar cuando el jugador hace clic / interactúa con UNA TORRE.
# idx_torre: 0 = A, 1 = B, 2 = C
#
# Lógica de dos pasos:
#   1er clic en torre → selecciona el disco de la cima (si la torre no está vacía).
#   2º clic en torre  → intenta depositar el disco seleccionado allí.
func interactuar_con_torre(idx_torre: int) -> void:
	if puzzle_completado:
		return
 
	if disco_seleccionado == -1:
		# ── PASO 1: Intentar coger el disco de la cima ──
		_intentar_seleccionar(idx_torre)
	else:
		# ── PASO 2: Intentar depositar el disco ──
		if idx_torre == torre_origen:
			# El jugador volvió a hacer clic en la misma torre → deseleccionar
			_deseleccionar_disco()
		else:
			_intentar_mover(idx_torre)
 
# Llamar cuando el jugador hace clic / interactúa DIRECTAMENTE con un disco.
# disco_id: índice del disco (0 = más grande, num_discos-1 = más pequeño).

# Solo se puede coger el disco si está en la cima de su torre.
func interactuar_con_disco(disco_id: int) -> void:
	if puzzle_completado:
		return
 
	# Buscar en qué torre está este disco y si es la cima
	for i in range(3):
		if torres[i].size() > 0 and torres[i].back() == disco_id:
			if disco_seleccionado == disco_id:
				# Ya estaba seleccionado → deseleccionar
				_deseleccionar_disco()
			else:
				if disco_seleccionado != -1:
					# Había otro seleccionado → deseleccionarlo primero
					_deseleccionar_disco()
				_seleccionar_disco(disco_id, i)
			return
 
	# El disco no está en la cima de ninguna torre
	movimiento_invalido.emit("Ese disco está tapado por otro. Mueve primero el de encima.")
 
# Reinicia el puzzle desde cero. Llámala desde un botón de "Reintentar".
func reiniciar() -> void:
	_inicializar_puzzle()
 
# Devuelve el número de movimientos mínimos necesarios: 2^n - 1.
func movimientos_minimos() -> int:
	return int(pow(2, num_discos)) - 1
 
# ─────────────────────────────────────────
#  LÓGICA INTERNA
# ─────────────────────────────────────────
 
func _intentar_seleccionar(idx_torre: int) -> void:
	if torres[idx_torre].is_empty():
		movimiento_invalido.emit("Esta torre está vacía.")
		return
	var disco_id: int = torres[idx_torre].back()
	_seleccionar_disco(disco_id, idx_torre)
 
func _seleccionar_disco(disco_id: int, idx_torre: int) -> void:
	disco_seleccionado = disco_id
	torre_origen = idx_torre
	# Feedback visual: elevar ligeramente el disco
	if nodos_disco.size() > disco_id:
		var nodo: Node3D = nodos_disco[disco_id]
		nodo.position.y += 0.3  # elevación de "coger"
	print("[Hanoi] Disco %d seleccionado desde Torre %s" % [disco_id, _nombre_torre(idx_torre)])
 
func _deseleccionar_disco() -> void:
	# Devolver el disco a su posición en la torre origen
	if nodos_disco.size() > disco_seleccionado:
		_posicionar_disco_en_torre(disco_seleccionado, torre_origen, torres[torre_origen].size() - 1)
	print("[Hanoi] Disco %d devuelto a Torre %s" % [disco_seleccionado, _nombre_torre(torre_origen)])
	disco_seleccionado = -1
	torre_origen = -1
 
func _intentar_mover(idx_destino: int) -> void:
	# Regla: solo se puede poner un disco encima de uno MÁS GRANDE o en torre vacía.
	if not torres[idx_destino].is_empty():
		var cima_destino: int = torres[idx_destino].back()
		if disco_seleccionado < cima_destino:
			# disco_seleccionado tiene ID menor → es más pequeño → ¡inválido!
			# (Recordatorio: ID 0 = más grande, ID n-1 = más pequeño)
			# Un disco pequeño (ID alto) SÍ puede ir sobre uno grande (ID bajo)
			# Un disco grande (ID bajo) NO puede ir sobre uno pequeño (ID alto)
			movimiento_invalido.emit("No puedes poner un disco grande sobre uno pequeño.")
			_deseleccionar_disco()
			return
 
	# ── Movimiento válido ──
	var origen: int = torre_origen
	torres[origen].pop_back()
	torres[idx_destino].append(disco_seleccionado)
	num_movimientos += 1
 
	# Actualizar posición visual del disco movido
	var slot: int = torres[idx_destino].size() - 1
	_posicionar_disco_en_torre(disco_seleccionado, idx_destino, slot)
 
	print("[Hanoi] Disco %d: Torre %s → Torre %s (movimiento #%d)" % [
		disco_seleccionado,
		_nombre_torre(origen),
		_nombre_torre(idx_destino),
		num_movimientos
	])
 
	disco_movido.emit(disco_seleccionado, origen, idx_destino)
	disco_seleccionado = -1
	torre_origen = -1
 
	_comprobar_victoria()
 
func _comprobar_victoria() -> void:
	# Victoria: todos los discos están en Torre B o Torre C (no en la A)
	# Condición estricta: todos en Torre C (índice 2), apilados correctamente.
	if torres[2].size() == num_discos:
		puzzle_completado = true
		print("[Hanoi] ¡Puzzle resuelto en %d movimientos! (mínimo: %d)" % [
			num_movimientos, movimientos_minimos()
		])
		puzzle_resuelto.emit()
 
# ─────────────────────────────────────────
#  POSICIONAMIENTO VISUAL
# ─────────────────────────────────────────
 
# Coloca TODOS los discos en sus posiciones correctas según el estado actual.
func _actualizar_posiciones_visuales() -> void:
	if nodos_disco.is_empty():
		return
	for idx_torre in range(3):
		for slot in range(torres[idx_torre].size()):
			var disco_id: int = torres[idx_torre][slot]
			_posicionar_disco_en_torre(disco_id, idx_torre, slot)
 
# Mueve el nodo 3D de un disco a la posición correcta en la torre dada.
# slot: posición en la pila (0 = fondo, size-1 = cima).
func _posicionar_disco_en_torre(disco_id: int, idx_torre: int, slot: int) -> void:
	if nodos_disco.size() <= disco_id:
		return
	var nodo: Node3D = nodos_disco[disco_id]
	var torre_nodo: Node3D = _get_torre_nodo(idx_torre)
	if torre_nodo == null:
		return
 
	# La posición X/Z del disco = posición X/Z de la torre
	var pos_torre: Vector3 = torre_nodo.global_position
	var nueva_pos: Vector3 = Vector3(
		pos_torre.x,
		pos_torre.y + altura_base_disco + slot * separacion_entre_discos,
		pos_torre.z
	)
	# Si quieres animación suave, usa un Tween:
	var tween: Tween = create_tween()
	tween.tween_property(nodo, "global_position", nueva_pos, 0.25)\
		 .set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
 
# ─────────────────────────────────────────
#  UTILIDADES
# ─────────────────────────────────────────
 
func _get_torre_nodo(idx: int) -> Node3D:
	match idx:
		0: return torre_a
		1: return torre_b
		2: return torre_c
	return null
 
func _nombre_torre(idx: int) -> String:
	match idx:
		0: return "A"
		1: return "B"
		2: return "C"
	return "?"
