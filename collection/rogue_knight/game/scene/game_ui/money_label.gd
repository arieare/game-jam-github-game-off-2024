extends RichTextLabel

@export var score: Label
@export var move: Label
@export var sfx_coin: AudioStream
@export var sfx_coin_2: AudioStream
@export var sfx_coin_3: AudioStream
var audio_player: AudioStreamPlayer
@export var multiplier_vfx: GPUParticles2D

func _ready() -> void:
	init_audio()
	util.root.data_instance.connect("game_state_change", _on_winning)

func _on_winning(state):
	if state == util.root.data_instance.GAME_STATE.WINNING:
		var i :int =  util.root.data_instance.game_data.money
		util.root.data_instance.game_data.money += util.root.data_instance.game_data.score
		await get_tree().create_timer(1.0).timeout
		
		var final_score :int = util.root.data_instance.game_data.money
		while (i <= final_score):
			await get_tree().create_timer(0.1 / (i+1)).timeout
			self.text = "[wave amp=150.0 freq=6.0 connected=1]$" + str(i) +"[/wave]"
			score.text = str(final_score - i)
			i += 1
			audio_player.stream = sfx_coin
			audio_player.play()
		
		util.root.data_instance.game_data.money += (util.root.data_instance.game_data.score * util.root.data_instance.game_data.max_move)
		await get_tree().create_timer(0.5).timeout
		var j :int = 0
		var final_move :int = util.root.data_instance.game_data.max_move
		while (j <= final_move):		
			await get_tree().create_timer(0.2 / (j+1)).timeout
			move.text = str(final_move - j)
			j += 1
		

		var k :int =  final_score
		var final_number :int = util.root.data_instance.game_data.money
		while (k <= final_number):
			if k < final_number / 1.25:
				await get_tree().create_timer(0.00001).timeout
			self.text = "[wave amp=150.0 freq=6.0 connected=1]$" + str(k) +"[/wave]"
			k += 1
			audio_player.stream = sfx_coin_2
			audio_player.play()
			#var current_pos := self.global_position
			#var score_tween: Tween
			#score_tween = create_tween().set_trans(Tween.TRANS_CIRC)
			#score_tween.tween_property(self,"scale", Vector2(1.1,1.1),0.05)
			#var new_pos := Vector2(current_pos.x-self.size.x/2, current_pos.y-self.size.y/2)
			#self.global_position = new_pos
			#score_tween.tween_interval(0.03)
			#score_tween.tween_property(self,"scale", Vector2(1,1),0.05)
			#self.global_position = current_pos

			#score_tween.tween_property(self,"position",current_pos,0.02)
		
		await get_tree().create_timer(0.05).timeout
		util.root.data_instance.game_data.max_move = 0
		util.root.data_instance.game_data.score = 0
		multiplier_vfx.restart()
		multiplier_vfx.emitting
		audio_player.stream = sfx_coin_3
		audio_player.play()


func init_audio():
	audio_player = AudioStreamPlayer.new()
	audio_player.max_polyphony = 128
	audio_player.pitch_scale = 2.0
	audio_player.volume_db = 4.0
	
	self.add_child(audio_player)	
