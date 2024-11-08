extends Node3D

signal square_hovered

var cast
var prev_hovered_board = null
var current_hovered_board = null

@export var chess_piece: Node3D
@export var board_node: Node3D
@export var legal_move_overlay_spawner: Node3D
@export var cam: Camera3D

@export var sfx_board_hover: AudioStream
@export var sfx_deny: AudioStream
@export var sfx_deny_2: AudioStream
@export var sfx_confirm: AudioStream
@export var sfx_confirm_2: AudioStream
var audio_player_hover: AudioStreamPlayer
var audio_player_deny: AudioStreamPlayer
var audio_player_confirm: AudioStreamPlayer

func _ready() -> void:
	init_audio()
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

	elif util.root.data_instance.current_game_state == util.root.data_instance.GAME_STATE.PLANNING:
		for member in get_tree().get_nodes_in_group("board"):
			_on_square_un_hovered(member)
		cast = util.mouse.cast(get_viewport().get_camera_3d(), get_viewport())
		if cast and cast.collider.is_in_group("board"):
			#print(cast.collider)
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
	if util.root.data_instance.current_game_state == util.root.data_instance.GAME_STATE.PLAYING:
		if !event.is_echo() and event.is_action_pressed("confirm") and self.current_hovered_board:
			if chess_piece.set_next_tile(self.current_hovered_board):
				legal_move_overlay_spawner.spawn_target_move_hint(self.current_hovered_board)
				audio_player_confirm.play()
			else:
				cam.shake_node.shake(0.05)
				audio_player_deny.play()
		
		if !event.is_echo() and event.is_action_pressed("cancel"):	
			audio_player_deny.play()
			chess_piece.remove_move()

func _on_square_hovered(square):
	
	var hover_tween: Tween
	hover_tween = create_tween().set_trans(Tween.TRANS_BOUNCE)
	hover_tween.tween_property(square,"scale", Vector3(1.2,1,1.2),0.05)
	hover_tween.tween_property(square,"position:y",0.1,0.02)
	hover_tween.tween_property(square,"rotation_degrees:z", randf_range(-45.0, 45.0),0.2)
	hover_tween.tween_property(square,"rotation_degrees:x", randf_range(-45.0, 45.0),0.1)
	if prev_hovered_board != current_hovered_board:
		audio_player_hover.play()

func _on_square_un_hovered(square):
	var hover_tween: Tween
	hover_tween = create_tween().set_trans(Tween.TRANS_CIRC)
	hover_tween.tween_property(square,"scale", Vector3(1,1,1),0.05)
	hover_tween.tween_property(square,"position:y",0,0.03)
	hover_tween.tween_property(square,"rotation_degrees:z", 0.0,0.02)
	hover_tween.tween_property(square,"rotation_degrees:x", 0.0,0.02)

func init_audio():
	audio_player_hover = AudioStreamPlayer.new()
	audio_player_hover.max_polyphony = 128
	var random_audio_hover = AudioStreamRandomizer.new()
	audio_player_hover.stream = random_audio_hover

	random_audio_hover.add_stream(0, sfx_board_hover, 1.0)
	random_audio_hover.playback_mode = AudioStreamRandomizer.PLAYBACK_SEQUENTIAL
	random_audio_hover.random_pitch = 1.1
	
	self.add_child(audio_player_hover)

	audio_player_deny = AudioStreamPlayer.new()
	audio_player_deny.max_polyphony = 128
	audio_player_deny.pitch_scale = 1.1
	audio_player_deny.volume_db = -18.0 
	var random_audio_deny = AudioStreamRandomizer.new()
	audio_player_deny.stream = random_audio_deny

	random_audio_deny.add_stream(0, sfx_deny, 1.0)
	random_audio_deny.add_stream(1, sfx_deny_2, 1.0)
	random_audio_deny.playback_mode = AudioStreamRandomizer.PLAYBACK_SEQUENTIAL
	random_audio_deny.random_pitch = 1.25
	self.add_child(audio_player_deny)

	audio_player_confirm = AudioStreamPlayer.new()
	audio_player_confirm.max_polyphony = 128
	audio_player_confirm.pitch_scale = 1.1
	#audio_player_confirm.volume_db = -15.0
	var random_audio_confirm = AudioStreamRandomizer.new()
	audio_player_confirm.stream = random_audio_confirm

	random_audio_confirm.add_stream(0, sfx_confirm_2, 1.0)
	random_audio_confirm.add_stream(1, sfx_confirm, 1.0)
	random_audio_confirm.playback_mode = AudioStreamRandomizer.PLAYBACK_SEQUENTIAL
	random_audio_confirm.random_pitch = 1.25
	self.add_child(audio_player_confirm)		
