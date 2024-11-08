extends Node3D

@export var white_square: PackedScene
@export var black_square: PackedScene
@export var goal_square: PackedScene
@export var block_square: PackedScene
var board_array : Dictionary = {}
var board_index : Dictionary = {}

@export var sfx_tile_spawn: AudioStream
var audio_player: AudioStreamPlayer

var pos_x: int
var pos_y: int

@onready var goal_tile = goal_square.instantiate()

func generate_board(board_size:int):
	## Reset Variables
	util.root.data_instance.game_data.patch_data.clear()
	util.root.data_instance.game_data.score = 0
	util.root.data_instance.game_data.board_data.board_array.clear()
	
	if util.root.data_instance.level_data.has(util.root.data_instance.game_data.current_level) and util.root.data_instance.level_data[util.root.data_instance.game_data.current_level].blocked_index != []:
		util.root.data_instance.game_data.board_data.blocked_index = util.root.data_instance.level_data[util.root.data_instance.game_data.current_level].blocked_index
	
	var current_square
	for i in board_size:
		var board_array_col : Dictionary = {}
		for j in board_size:
			if (i + j) % 2 == 0:
				current_square = white_square.instantiate()
			else:
				current_square = black_square.instantiate()
			
			current_square.position = Vector3(j * 0.5,0,i* 0.5)
			current_square.name = "square_" + str(i) + "_" + str(j)
			current_square.hide()
			self.add_child(current_square)
			
			board_array_col[j] = current_square
			board_array[i] = board_array_col
			util.root.data_instance.game_data.board_data.board_array[i] = board_array_col
			
			board_index[current_square.name] = Vector2(i,j)
	
	## Add goal tile
	#if util.root.data_instance.level_data.has(util.root.data_instance.game_data.current_level):
		#util.root.data_instance.game_data.board_data.size = util.root.data_instance.level_data[util.root.data_instance.game_data.current_level].board_size

	
	if util.root.data_instance.level_data.has(util.root.data_instance.game_data.current_level) and util.root.data_instance.level_data[util.root.data_instance.game_data.current_level].target_position != null:
		pos_x = int(util.root.data_instance.level_data[util.root.data_instance.game_data.current_level].target_position.x)
		pos_y = int(util.root.data_instance.level_data[util.root.data_instance.game_data.current_level].target_position.y)
	
	else:
		pos_x = randi_range(0, board_size-1)
		pos_y = randi_range(0, board_size-1)
	
	util.root.data_instance.game_data.target_position = Vector2(pos_x,pos_y) 
	var goal_position = board_array[pos_x][pos_y].position
	board_array[pos_x][pos_y].free()
	goal_tile.name = "square_" + str(pos_x) + "_" + str(pos_y)
	board_array[pos_x][pos_y] = goal_tile
	board_array[pos_x][pos_y].position = goal_position
	goal_tile.hide()
	self.add_child(goal_tile)
	
	## Add block tile
	print(util.root.data_instance.game_data.board_data.blocked_index)
	for blocked_pos in util.root.data_instance.game_data.board_data.blocked_index:
		var blocked_tile = block_square.instantiate()
		if blocked_pos:
			var block_position = board_array[int(blocked_pos.x)][int(blocked_pos.y)].position
			board_array[int(blocked_pos.x)][int(blocked_pos.y)].free()
			blocked_tile.name = "square_" + str(blocked_pos.x) + "_" + str(blocked_pos.y)
			board_array[int(blocked_pos.x)][int(blocked_pos.y)] = blocked_tile
			board_array[int(blocked_pos.x)][int(blocked_pos.y)].position = block_position
			blocked_tile.hide()
			self.add_child(blocked_tile)
	
	var board_spawn_speed:= 0.05
	for i in board_size:
		for j in board_size:
			board_array[i][j].show()
			var hover_tween: Tween = create_tween().set_trans(Tween.TRANS_BOUNCE)
			hover_tween.tween_property(board_array[i][j],"scale", Vector3(1.2,1,1.2),0.05)
			hover_tween.tween_property(board_array[i][j],"position:y",0.1,0.02)
			hover_tween.tween_property(board_array[i][j],"rotation_degrees:z", randf_range(-45.0, 45.0),0.2)
			hover_tween.tween_property(board_array[i][j],"rotation_degrees:x", randf_range(-45.0, 45.0),0.1)	
			hover_tween.tween_interval(0.2)
			hover_tween.tween_property(board_array[i][j],"scale", Vector3(1,1,1),0.05)
			hover_tween.tween_property(board_array[i][j],"position:y",0,0.03)
			hover_tween.tween_property(board_array[i][j],"rotation_degrees:z", 0.0,0.02)
			hover_tween.tween_property(board_array[i][j],"rotation_degrees:x", 0.0,0.02)
			audio_player.play()
			await get_tree().create_timer(board_spawn_speed - (i/2)).timeout
	
	util.root.data_instance.board_ready.emit()

			
func _ready() -> void:
	audio_player = AudioStreamPlayer.new()
	audio_player.max_polyphony = 128
	var random_audio = AudioStreamRandomizer.new()
	audio_player.stream = random_audio

	random_audio.add_stream(0, sfx_tile_spawn, 1.0)
	random_audio.playback_mode = AudioStreamRandomizer.PLAYBACK_SEQUENTIAL
	random_audio.random_pitch = 1.1
	
	self.add_child(audio_player)	
	

	
	if util.root.data_instance.level_data.has(util.root.data_instance.game_data.current_level):
		util.root.data_instance.game_data.board_data.size = util.root.data_instance.level_data[util.root.data_instance.game_data.current_level].board_size

	generate_board(util.root.data_instance.game_data.board_data.size)		
	
	
