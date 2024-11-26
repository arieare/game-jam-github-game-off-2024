extends Node3D

signal square_hovered

var cast
var prev_hovered_board = null
var current_hovered_board = null

@export var chess_piece: Node3D
@export var board_node: Node3D
@export var legal_move_overlay_spawner: Node3D

func _ready() -> void:
	self.connect("square_hovered", _on_square_hovered)

func _process(delta: float) -> void:
	if util.root.data_instance.current_game_state == util.root.data_instance.GAME_STATE.PLAYING:
		for member in get_tree().get_nodes_in_group("board"):
			_on_square_un_hovered(member)
		cast = util.mouse.cast(get_viewport().get_camera_3d(), get_viewport())
		if cast and cast.collider.is_in_group("board") and !cast.collider.is_in_group("patch"):
			prev_hovered_board = current_hovered_board
			current_hovered_board = cast.collider
			emit_signal("square_hovered", cast.collider)
		else:
			prev_hovered_board = current_hovered_board
			current_hovered_board = null
		if cast:	
			self.global_position = cast.position.snappedf(0.5)
			
		#keyboard input
		#if Input.is_action_just_released("right"):
			#for member in get_tree().get_nodes_in_group("board"):
				#_on_square_un_hovered(member)
			#
			#prev_hovered_board = chess_piece.current_square
			#current_hovered_board = board_node.board_array[int(chess_piece.current_square_index.x)][int(chess_piece.current_square_index.y + 1)]
			#emit_signal("square_hovered", current_hovered_board)		

	#current_square = board_node.board_array[int(starting_pos.x)][int(starting_pos.y)]
	#current_square_index = board_node.board_index[current_square.name]						
						

	elif util.root.data_instance.current_game_state == util.root.data_instance.GAME_STATE.PLANNING:
		for member in get_tree().get_nodes_in_group("board"):
			_on_square_un_hovered(member)
		cast = util.mouse.cast(get_viewport().get_camera_3d(), get_viewport())
		if cast and cast.collider.is_in_group("board"):
			prev_hovered_board = current_hovered_board
			current_hovered_board = cast.collider
			emit_signal("square_hovered", cast.collider)
			#self.global_position = cast.position.snappedf(0.5)
		else:
			prev_hovered_board = current_hovered_board
			#if cast and !cast.collider.is_in_group("patch"):
			#current_hovered_board = null
		
		if cast:
			self.global_position = cast.position.snappedf(0.5)
	else:
		_on_square_un_hovered(cast.collider)

func _input(event: InputEvent) -> void:
	match util.root.data_instance.current_game_state:
		util.root.data_instance.GAME_STATE.PLAYING:
			if !event.is_echo() and event.is_action_pressed("confirm") and self.current_hovered_board:
				
				if chess_piece.set_next_tile(self.current_hovered_board):
					### show glow
					legal_move_overlay_spawner.spawn_target_move_hint(self.current_hovered_board)
					util.root.data_instance.audio.sfx_dictionary.tile_select_confirm.sfx.play()

				else:
					util.root.data_instance.game_data.current_cam.shake_node.shake(0.035)
					util.root.data_instance.audio.sfx_dictionary.tile_select_deny.sfx.play()

			
			if !event.is_echo() and event.is_action_pressed("cancel"):
				util.root.data_instance.game_data.current_cam.shake_node.shake(0.035)
				util.root.data_instance.audio.sfx_dictionary.tile_select_deny.sfx.play()

				chess_piece.remove_move()
		util.root.data_instance.GAME_STATE.PLANNING:
			if !event.is_echo() and event.is_action_pressed("confirm") and self.current_hovered_board:
				var clicked_tile_vector = board_node.board_index[self.current_hovered_board.name]
				if util.root.data_instance.game_data.patch_data.has(str(clicked_tile_vector)):
					util.root.data_instance.remove_patch_from_board.emit(util.root.data_instance.game_data.patch_data[str(clicked_tile_vector)], clicked_tile_vector)
					current_hovered_board = null
					#print(util.root.data_instance.game_data.patch_data)
	

func _on_square_hovered(square):	
	var hover_tween: Tween
	hover_tween = create_tween().set_trans(Tween.TRANS_BOUNCE)
	hover_tween.tween_property(square,"scale", Vector3(1.2,1,1.2),0.05)
	hover_tween.tween_property(square,"position:y",0.1,0.02)
	hover_tween.tween_property(square,"rotation_degrees:z", randf_range(-45.0, 45.0),0.2)
	hover_tween.tween_property(square,"rotation_degrees:x", randf_range(-45.0, 45.0),0.1)
	if prev_hovered_board != current_hovered_board:
		util.root.data_instance.audio.sfx_dictionary.tile_hover.sfx.play()

func _on_square_un_hovered(square):
	var hover_tween: Tween
	hover_tween = create_tween().set_trans(Tween.TRANS_CIRC)
	hover_tween.tween_property(square,"scale", Vector3(1,1,1),0.05)
	hover_tween.tween_property(square,"position:y",0,0.03)
	hover_tween.tween_property(square,"rotation_degrees:z", 0.0,0.02)
	hover_tween.tween_property(square,"rotation_degrees:x", 0.0,0.02)	
