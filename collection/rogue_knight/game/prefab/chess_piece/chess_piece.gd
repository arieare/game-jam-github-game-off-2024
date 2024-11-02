extends Node3D

@export var point_spawner: Node3D
@export var legal_move_overlay_spawner: Node3D
@export var board_node: Node3D

@onready var knight_movement = load("res://collection/rogue_knight/game/prefab/chess_piece/move_set_knight.gd").new()
@onready var rook_movement = load("res://collection/rogue_knight/game/prefab/chess_piece/move_set_rook.gd").new()
@onready var bishop_movement = load("res://collection/rogue_knight/game/prefab/chess_piece/move_set_bishop.gd").new()
@onready var queen_movement = load("res://collection/rogue_knight/game/prefab/chess_piece/move_set_queen.gd").new()
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

@export var sfx_step: AudioStream
var audio_player_step: AudioStreamPlayer
@export var vfx_landing: GPUParticles3D

func _ready() -> void:
	mesh_rook.hide()
	mesh_knight.show()
	mesh_queen.hide()
	movement_strategy.chess_piece = self #dependency injection
	util.root.data_instance.game_data.chess_piece = self #dependency injection
	self.hide()
	util.root.data_instance.connect("board_ready", _on_board_ready)
	init_audio()

func init_audio():
	audio_player_step = AudioStreamPlayer.new()
	audio_player_step.max_polyphony = 128
	audio_player_step.pitch_scale = 0.8
	var random_audio = AudioStreamRandomizer.new()
	audio_player_step.stream = random_audio

	random_audio.add_stream(0, sfx_step, 1.0)
	random_audio.playback_mode = AudioStreamRandomizer.PLAYBACK_SEQUENTIAL
	random_audio.random_pitch = 1.25
	self.add_child(audio_player_step)	

var point_granted:=3
func tween_move(new_pos):
	prev_square = self.global_position
	vfx_landing.restart()
	self.look_at(new_pos)	
	
	var move_tween: Tween
	if move_tween:
		move_tween.kill()
	move_tween = create_tween().set_trans(Tween.TRANS_CIRC)
	move_tween.tween_property(self,"scale", Vector3(1.2,1,1.2),0.03)
	move_tween.tween_property(self,"position:y",position.y+0.2,0.05)
	move_tween.tween_property(self,"position",new_pos,0.1)
	vfx_landing.position = prev_square
	vfx_landing.emitting = true
	move_tween.tween_property(self,"scale", Vector3(1,1,1),0.03)
	await move_tween.finished
	
	audio_player_step.play()
	#point_spawner.spawn_point(util.root.data_instance.game_data.max_move, prev_square)
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

func _on_board_ready():
	self.show()
	self.position = board_node.board_array[1][2].position
	current_square = board_node.board_array[1][2]
	current_square_index = board_node.board_index[current_square.name]
	legal_move_overlay_spawner.spawn_legal_move_hint(current_square_index, movement_strategy.get_legal_move(current_square_index))	

func set_next_tile(selected_tile) -> bool:
	var move_array_size = util.root.data_instance.game_data.move_step.size()
	if move_array_size == 0:
		target_square_index = current_square_index
	
	if movement_strategy.get_legal_move(target_square_index).has(board_node.board_index[selected_tile.name]): #check if valid tile click
		self.look_at(selected_tile.position)
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
	var move_set = util.root.data_instance.game_data.move_step
	if move_set:
		for move in movement_strategy.get_steps_between():
			var move_towards = util.root.data_instance.game_data.chess_piece.board_node.board_array[int(move.x)][int(move.y)].position
			util.root.data_instance.game_data.chess_piece.tween_move(move_towards)
			util.root.data_instance.game_data.chess_piece.current_square = util.root.data_instance.game_data.chess_piece.board_node.board_array[int(move.x)][int(move.y)]
			util.root.data_instance.game_data.chess_piece.current_square_index = move
			await get_tree().create_timer(0.3).timeout
	util.root.data_instance.game_data.chess_piece.remove_move()
	util.root.data_instance.move_performed.emit(1)
	
	if util.root.data_instance.game_data.max_move < 1:
		util.root.data_instance.current_game_state = util.root.data_instance.GAME_STATE.LOSING
		#print(util.root.data_instance.game_data.max_move)
	if util.root.data_instance.game_data.chess_piece.current_square.is_in_group("goal"):
		util.root.data_instance.current_game_state = util.root.data_instance.GAME_STATE.WINNING
	is_moving = false
	
	## Check for patch buff
	var buff
	if util.root.data_instance.game_data.patch_data.has(str(util.root.data_instance.game_data.chess_piece.current_square_index)):
		buff = util.root.data_instance.game_data.patch_data[str(util.root.data_instance.game_data.chess_piece.current_square_index)]
		if buff == "rook":
			point_granted = 5
			movement_strategy = rook_movement
			legal_move_overlay_spawner.spawn_legal_move_hint(current_square_index, movement_strategy.get_legal_move(current_square_index))	
			mesh_rook.show()
			mesh_knight.hide()
			mesh_queen.hide()
		elif buff == "queen":
			point_granted = 9
			movement_strategy = queen_movement
			legal_move_overlay_spawner.spawn_legal_move_hint(current_square_index, movement_strategy.get_legal_move(current_square_index))	
			mesh_rook.hide()
			mesh_knight.hide()	
			mesh_queen.show()		
	else:
		buff = null
		point_granted = 3
		movement_strategy = knight_movement
		legal_move_overlay_spawner.spawn_legal_move_hint(current_square_index, movement_strategy.get_legal_move(current_square_index))	
		mesh_rook.hide()
		mesh_queen.hide()
		mesh_knight.show()		
