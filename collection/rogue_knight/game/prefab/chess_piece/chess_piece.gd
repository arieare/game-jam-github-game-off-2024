extends Node3D

@export var point_spawner: Node3D
@export var legal_move_overlay_spawner: Node3D
@export var board_node: Node3D

@onready var knight_movement = preload("res://collection/rogue_knight/game/prefab/chess_piece/move_set_knight.gd").new()
@onready var rook_movement = preload("res://collection/rogue_knight/game/prefab/chess_piece/move_set_rook.gd").new()
@onready var bishop_movement = preload("res://collection/rogue_knight/game/prefab/chess_piece/move_set_bishop.gd").new()
@onready var queen_movement = preload("res://collection/rogue_knight/game/prefab/chess_piece/move_set_queen.gd").new()
@onready var movement_strategy: class_chess_move_set = knight_movement

@export var mesh_knight: MeshInstance3D
@export var mesh_rook: MeshInstance3D
@export var mesh_queen: MeshInstance3D

var prev_square: Vector3
var current_square: Variant
var current_square_index: Vector2
var target_square: Variant
var target_square_index: Vector2
var max_move_step := 3

@export var vfx_landing: GPUParticles3D

@export var aim: Node3D
@export var chess_piece_head: Node3D
@export var chess_piece_body: Node3D
@export var cam: Camera3D

func _ready() -> void:
	self.scale = Vector3.ZERO
	point_spawner.hide_point()
	movement_strategy.chess_piece = self #dependency injection
	mesh_rook.hide()
	mesh_knight.show()
	mesh_queen.hide()
	util.root.data_instance.game_data.chess_piece = self #dependency injection
	self.hide()
	util.root.data_instance.connect("board_ready", _on_board_ready)
	util.root.data_instance.connect("game_state_change", _on_game_state_change)
	legal_move_overlay_spawner.clear_legal_move_hint()

func _process(delta: float) -> void:
	animate_breathe_idle(delta, 0.05)
	if util.root.data_instance.current_game_state == util.root.data_instance.GAME_STATE.PLAYING:
		if !is_moving and aim.global_position.distance_to(self.global_position) <= 0.2:
			
			
			#chess_piece_body.look_at(aim.global_position)
			chess_piece_head.rotation_degrees.y = 0
			chess_piece_body.rotation_degrees.y = 0
			
			chess_piece_head.rotation_degrees.x = 0
			chess_piece_head.rotation_degrees.z = 0		
			chess_piece_body.rotation_degrees.x = 0
			chess_piece_body.rotation_degrees.z = 0		
			self.position.y = current_square.position.y			
		elif !is_moving and aim.global_position.distance_to(self.global_position) > 0.2 :
			util.look_at_target.look_at_target(aim, chess_piece_head, 0.25)
			util.look_at_target.look_at_target(aim, chess_piece_body, 0.04)
			chess_piece_body.rotation_degrees.x = 0
			chess_piece_body.rotation_degrees.z = 0
			self.position.y = current_square.position.y

		else:
			
			chess_piece_head.rotation_degrees.y = 0
			chess_piece_body.rotation_degrees.y = 0
			
			chess_piece_head.rotation_degrees.x = 0
			chess_piece_head.rotation_degrees.z = 0		
			chess_piece_body.rotation_degrees.x = 0
			chess_piece_body.rotation_degrees.z = 0		
			self.position.y = current_square.position.y		

		#move_tween.tween_property(self,"scale", Vector3(1,1,1),0.03)

func _on_board_ready():
	legal_move_overlay_spawner.clear_legal_move_hint()
	self.show()
	tween_appear()
		
	var starting_pos:= Vector2(0,0)
	if util.root.data_instance.level_data.has(util.root.data_instance.game_data.current_level) and util.root.data_instance.level_data[util.root.data_instance.game_data.current_level].starting_position != null:
		starting_pos = util.root.data_instance.level_data[util.root.data_instance.game_data.current_level].starting_position


	self.position = board_node.board_array[int(starting_pos.x)][int(starting_pos.y)].position
	current_square = board_node.board_array[int(starting_pos.x)][int(starting_pos.y)]
	current_square_index = board_node.board_index[current_square.name]
	

func _on_game_state_change(value):
	#elif util.root.data_instance.current_game_state == util.root.data_instance.GAME_STATE.BOARD_CRUMBLE:			
	
	match value:
		util.root.data_instance.GAME_STATE.PLANNING:
			legal_move_overlay_spawner.clear_legal_move_hint()
		util.root.data_instance.GAME_STATE.BOARD_CRUMBLE:
			legal_move_overlay_spawner.clear_legal_move_hint()
			cam.shake_node.shake(0.04)
			var move_tween: Tween
			if move_tween:
				move_tween.kill()
			move_tween = create_tween().set_trans(Tween.TRANS_EXPO)
			move_tween.set_parallel(false)
			move_tween.tween_property(self,"position:y", self.position.y + 0.1,0.3)
			move_tween.tween_property(self,"scale:y", 8,0.3)
			move_tween.set_parallel(true)
			move_tween.tween_property(self,"position:y", self.position.y - 2,1)
			move_tween.tween_property(self,"scale", Vector3(0,0,0),1)
			await move_tween.finished
			await get_tree().create_timer(1.2).timeout
			
			util.root.data_instance.current_game_state = util.root.data_instance.GAME_STATE.LOSING

		util.root.data_instance.GAME_STATE.PLAYING:	
	#if value == util.root.data_instance.GAME_STATE.PLAYING:
		#self.show()
		#
		#var starting_pos:= Vector2(0,0)
		#if util.root.data_instance.level_data.has(util.root.data_instance.game_data.current_level) and util.root.data_instance.level_data[util.root.data_instance.game_data.current_level].starting_position != null:
			#starting_pos = util.root.data_instance.level_data[util.root.data_instance.game_data.current_level].starting_position
#
#
		#self.position = board_node.board_array[int(starting_pos.x)][int(starting_pos.y)].position
		#current_square = board_node.board_array[int(starting_pos.x)][int(starting_pos.y)]
		#current_square_index = board_node.board_index[current_square.name]
		

			#print(movement_strategy.min_moves(movement_strategy.move_set,current_square_index,util.root.data_instance.game_data.target_position,util.root.data_instance.game_data.board_data.blocked_index))

			util.root.data_instance.game_data.max_move = movement_strategy.min_moves(movement_strategy.move_set,current_square_index,util.root.data_instance.game_data.target_position,util.root.data_instance.game_data.board_data.blocked_index)["moves"] + 3
			## Patch Checking Region
			
			var legal_move = movement_strategy.min_moves(movement_strategy.move_set,current_square_index,util.root.data_instance.game_data.target_position,util.root.data_instance.game_data.board_data.blocked_index)["path"]
			var is_log_pose_available = false
			for coord in util.root.data_instance.game_data.patch_data:
				if util.root.data_instance.game_data.patch_data[coord] == "log_pose":
					is_log_pose_available = true
				else:
					is_log_pose_available = false
			if !is_log_pose_available:		
				legal_move_overlay_spawner.spawn_legal_move_hint(current_square_index, movement_strategy.get_legal_move(current_square_index))	
			else:	
				legal_move_overlay_spawner.spawn_legal_move_hint(current_square_index, legal_move)	
		

var point_granted:=3
func tween_appear():
	
	
	var move_tween: Tween
	if move_tween:
		move_tween.kill()
	move_tween = create_tween().set_trans(Tween.TRANS_CIRC)
	move_tween.set_parallel(true)
	move_tween.tween_property(self,"scale", Vector3(1,1.5,1),0.25)
	move_tween.tween_property(self,"position:y",position.y+0.5,0.45)
	move_tween.tween_property(self,"rotation_degrees:y",180,0.35)
	move_tween.set_parallel(false)
	move_tween.tween_interval(0.3)
	move_tween.set_parallel(true)
	move_tween.tween_property(self,"scale", Vector3(1.3,0.8,1.3),0.15)
	move_tween.tween_property(self,"position:y",0,0.15)
	move_tween.tween_property(chess_piece_head,"position:y",position.y-0.05,0.1)
	move_tween.set_parallel(false)
	move_tween.tween_property(self,"scale", Vector3(1,1.1,1),0.15)
	move_tween.tween_property(chess_piece_head,"position:y",0,0.2)
	move_tween.tween_interval(0.05)
	move_tween.tween_property(self,"scale", Vector3(1,1,1),0.25)

func tween_move(new_pos, next_tile):
	if util.root.data_instance.current_game_state == util.root.data_instance.GAME_STATE.PLAYING:
		prev_square = self.global_position
		#vfx_landing.restart()
		self.look_at(new_pos)
		self.rotation_degrees.x = 0
		self.rotation_degrees.z = 0		
		
		vfx_landing.position = prev_square
		#vfx_landing.emitting = true
		var move_tween: Tween
		if move_tween:
			move_tween.kill()
		move_tween = create_tween().set_trans(Tween.TRANS_CIRC)
		move_tween.tween_property(self,"scale", Vector3(1.2,1,1.2),0.03)
		move_tween.tween_property(self,"position:y",position.y+0.2,0.05)
		move_tween.tween_property(self,"position",new_pos,0.075)
		move_tween.tween_property(self,"scale", Vector3(1,1,1),0.03)
		
		if util.root.data_instance.game_data.board_data.blocked_index.has(next_tile):
			util.root.data_instance.current_game_state = util.root.data_instance.GAME_STATE.BOARD_CRUMBLE
		#elif board_node.board_array[int(next_tile.x)][int(next_tile.y)].is_in_group("goal"):
			#legal_move_overlay_spawner.clear_legal_move_hint()
			#util.root.data_instance.vfx.vfx_goal_tile.emitting = false
			#util.root.data_instance.current_game_state = util.root.data_instance.GAME_STATE.WINNING		
		
		await move_tween.finished
		
		util.root.data_instance.audio.sfx_dictionary.step_on_board.sfx.play()
		cam.shake_node.shake(0.025)
		point_spawner.spawn_point(point_granted, prev_square)
		

func add_move(move:Vector2):
	if util.root.data_instance.game_data.move_step.size() < 2:
		util.root.data_instance.game_data.move_step.append(move)
	else:
		util.root.data_instance.game_data.move_step[1] = move

func remove_move():
	util.root.data_instance.game_data.move_step.resize(0)
	max_move_step = 3
	target_square_index = current_square_index
	legal_move_overlay_spawner.spawn_legal_move_hint(target_square_index, movement_strategy.get_legal_move(target_square_index))


func set_next_tile(selected_tile) -> bool:
	var move_array_size = util.root.data_instance.game_data.move_step.size()
	if move_array_size == 0:
		target_square_index = current_square_index
	
	if movement_strategy.get_legal_move(target_square_index).has(board_node.board_index[selected_tile.name]): #check if valid tile click
		target_square = selected_tile
		target_square_index = board_node.board_index[target_square.name]
		max_move_step -= current_square_index.distance_to(target_square_index)
		add_move(target_square_index)
		legal_move_overlay_spawner.spawn_legal_move_hint(target_square_index, movement_strategy.get_legal_move(target_square_index))
		return true
	else:
		return false

var is_moving: bool = false
func parse_movement():
	is_moving = true
	util.root.data_instance.move_started.emit()
	var move_set = util.root.data_instance.game_data.move_step
	if move_set:
		for move in movement_strategy.get_steps_between():
			var move_towards = util.root.data_instance.game_data.chess_piece.board_node.board_array[int(move.x)][int(move.y)].position
			util.root.data_instance.game_data.chess_piece.tween_move(move_towards, Vector2(int(move.x),int(move.y)))
			util.root.data_instance.game_data.chess_piece.current_square = util.root.data_instance.game_data.chess_piece.board_node.board_array[int(move.x)][int(move.y)]
			util.root.data_instance.game_data.chess_piece.current_square_index = move
			await get_tree().create_timer(0.25).timeout
	
	util.root.data_instance.game_data.chess_piece.remove_move()
	util.root.data_instance.move_performed.emit(1)
	
	if util.root.data_instance.game_data.max_move < 1:
		legal_move_overlay_spawner.clear_legal_move_hint()
		util.root.data_instance.current_game_state = util.root.data_instance.GAME_STATE.LOSING
	elif util.root.data_instance.game_data.chess_piece.current_square.is_in_group("goal"):
		legal_move_overlay_spawner.clear_legal_move_hint()
		util.root.data_instance.vfx.vfx_goal_tile.emitting = false
		util.root.data_instance.current_game_state = util.root.data_instance.GAME_STATE.WINNING				
	is_moving = false
	
	
	match util.root.data_instance.current_game_state:
		pass
		#util.root.data_instance.GAME_STATE.BOARD_CRUMBLE:
			#var board_spawn_speed:= 0.05
			#for move in movement_strategy.get_steps_between():
				##board_array[i][j].show()
				#var hover_tween: Tween = create_tween().set_trans(Tween.TRANS_CIRC)
				##hover_tween.tween_property(board_array[i][j],"scale", Vector3(1.2,1,1.2),0.05)
				#hover_tween.tween_property(util.root.data_instance.game_data.chess_piece.board_node.board_array[int(move.x)][int(move.y)],"position:y",50,2.0)	
	#point_spawner.hide_point()
	
	## Check for patch buff
	var buff
	if util.root.data_instance.game_data.patch_data.has(str(util.root.data_instance.game_data.chess_piece.current_square_index)):
		buff = util.root.data_instance.game_data.patch_data[str(util.root.data_instance.game_data.chess_piece.current_square_index)]
		if buff == "rook":
			point_granted = 5
			movement_strategy = rook_movement
			legal_move_overlay_spawner.spawn_legal_move_hint(current_square_index, movement_strategy.get_legal_move(current_square_index))	
			#mesh_rook.show()
			#mesh_knight.hide()
			#mesh_queen.hide()
		elif buff == "queen":
			point_granted = 9
			movement_strategy = queen_movement
			legal_move_overlay_spawner.spawn_legal_move_hint(current_square_index, movement_strategy.get_legal_move(current_square_index))	
			#mesh_rook.hide()
			#mesh_knight.hide()	
			#mesh_queen.show()	
		elif buff == "bishop":
			point_granted = 3
			movement_strategy = bishop_movement
			legal_move_overlay_spawner.spawn_legal_move_hint(current_square_index, movement_strategy.get_legal_move(current_square_index))	
			#mesh_rook.hide()
			#mesh_knight.show()	
			#mesh_queen.hide()					
	#else:
		#buff = null
		#point_granted = 3
		#movement_strategy = knight_movement
		#legal_move_overlay_spawner.spawn_legal_move_hint(current_square_index, movement_strategy.get_legal_move(current_square_index))	
		#mesh_rook.hide()
		#mesh_queen.hide()
		#mesh_knight.show()		


func animate_breathe_idle(delta, scale):
	var frequence = 0.05 # sin speed 2.5
	var amplitude = 2.0 # value range=
	if util.bob_sine.calculate(delta, frequence, amplitude) < - amplitude + 0.1: #left

		var tween_head = create_tween().set_trans(Tween.TRANS_SINE)
		tween_head.tween_property(chess_piece_head,"position:y",chess_piece_head.position.y - scale,0.5)		
	if util.bob_sine.calculate(delta, frequence, amplitude) > amplitude - 0.1: #right	
		var tween_head = create_tween().set_trans(Tween.TRANS_SINE)
		tween_head.tween_property(chess_piece_head,"position:y",chess_piece_head.position.y + scale,0.5)	
