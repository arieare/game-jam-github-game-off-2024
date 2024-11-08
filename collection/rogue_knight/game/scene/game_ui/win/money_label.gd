extends RichTextLabel

@export var score: Label
@export var move: Label
@export var sfx_coin: AudioStream
@export var sfx_coin_2: AudioStream
@export var sfx_coin_3: AudioStream
var audio_player: AudioStreamPlayer
@export var multiplier_vfx: GPUParticles2D

@export var btn_claim: Button

var final_number :int = 0

func _ready() -> void:
	init_audio()
	util.root.data_instance.connect("game_state_change", _on_winning)
	btn_claim.hide()
	btn_claim.disabled = true

var temp_money: int = 0
var final_money: int = 0
func _on_winning(state):
	if state == util.root.data_instance.GAME_STATE.WINNING:
		score.text = str(util.root.data_instance.game_data.score)
		move.text = str(util.root.data_instance.game_data.max_move)
		await get_tree().create_timer(0.75).timeout
		temp_money = util.root.data_instance.game_data.score	
		for i in temp_money + 1:
			await get_tree().create_timer(0.03).timeout
			audio_player.stream = sfx_coin
			audio_player.play()				
			self.text = "[wave amp=120.0 freq=6.0 connected=1]$" + str(i) +"[/wave]"
			score.text = str(temp_money - i)

		await get_tree().create_timer(0.5).timeout
		
		for i in util.root.data_instance.game_data.max_move + 1:
			await get_tree().create_timer(0.1).timeout
			audio_player.stream = sfx_coin
			audio_player.play()				
			self.text = "[wave amp=120.0 freq=6.0 connected=1]$" + str(temp_money + i) +"[/wave]"
			move.text = str(util.root.data_instance.game_data.max_move - i)

		await get_tree().create_timer(0.2).timeout
		final_money = temp_money + util.root.data_instance.game_data.max_move
		util.root.data_instance.game_data.max_move = 0
		util.root.data_instance.game_data.score = 0
		multiplier_vfx.restart()
		multiplier_vfx.emitting
		audio_player.stream = sfx_coin_3
		audio_player.play()
		btn_claim.show()
		btn_claim.disabled = false


func init_audio():
	audio_player = AudioStreamPlayer.new()
	audio_player.max_polyphony = 128
	audio_player.pitch_scale = 2.0
	audio_player.volume_db = 4.0
	
	self.add_child(audio_player)	
