extends Node3D

@export var white_square: PackedScene
@export var black_square: PackedScene
@export var goal_square: PackedScene
var board_array : Dictionary = {}
var board_index : Dictionary = {}

@export var sfx_tile_spawn: AudioStream
var audio_player: AudioStreamPlayer

func generate_board(board_size:int):
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
			
			board_index[current_square.name] = Vector2(i,j)
	
	## Add goal tile
	#board_array[1][2].position
	var pos_x = randi_range(0, board_size-1)
	var pos_y = randi_range(0, board_size-1)
	var goal_position = board_array[pos_x][pos_y].position
	var goal_tile = goal_square.instantiate()
	board_array[pos_x][pos_y].free()
	goal_tile.name = "square_" + str(pos_x) + "_" + str(pos_y)
	board_array[pos_x][pos_y] = goal_tile
	board_array[pos_x][pos_y].position = goal_position
	goal_tile.hide()
	self.add_child(goal_tile)
	
	
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
			await get_tree().create_timer(0.0075).timeout
	
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
	generate_board(util.root.data_instance.game_data.board_data.size)
	
	
