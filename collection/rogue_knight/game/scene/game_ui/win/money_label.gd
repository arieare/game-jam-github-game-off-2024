extends RichTextLabel

@export var score: PanelContainer
@export var move: PanelContainer

@export var btn_claim: Button

var final_number :int = 0

func _ready() -> void:
	util.root.data_instance.connect("game_state_change", _on_winning)
	btn_claim.hide()
	btn_claim.disabled = true

var temp_money: int = 0
var final_money: int = 0
func _on_winning(state):
	if state == util.root.data_instance.GAME_STATE.WINNING:
		
		if util.root.data_instance.game_data.score > util.root.data_instance.game_data.high_score:
			util.root.data_instance.game_data.high_score = util.root.data_instance.game_data.score
		
		var move_number = util.root.data_instance.game_data.initial_move - util.root.data_instance.game_data.max_move
		if move_number < util.root.data_instance.game_data.shortest_move and move_number > 1 :
			util.root.data_instance.game_data.shortest_move = move_number
		
		score.label.text = str(util.root.data_instance.game_data.score)
		move.label.text = str(util.root.data_instance.game_data.max_move)
		await get_tree().create_timer(0.75).timeout
		temp_money = util.root.data_instance.game_data.score	
		for i in temp_money + 1:
			await get_tree().create_timer(0.03).timeout
			util.root.data_instance.audio.sfx_dictionary.coin_2.sfx.play()	
			self.text = "[wave amp=120.0 freq=6.0 connected=1]¢" + str(i) +"[/wave]"
			score.label.text = str(temp_money - i)

		await get_tree().create_timer(0.5).timeout
		
		for i in util.root.data_instance.game_data.max_move + 1:
			await get_tree().create_timer(0.1).timeout
			util.root.data_instance.audio.sfx_dictionary.coin_1.sfx.play()		
			self.text = "[wave amp=120.0 freq=6.0 connected=1]¢" + str(temp_money + i * 2) +"[/wave]"
			move.label.text = str(util.root.data_instance.game_data.max_move - i)

		await get_tree().create_timer(0.2).timeout
		final_money = temp_money + util.root.data_instance.game_data.max_move * 2
		util.root.data_instance.game_data.max_move = 0
		util.root.data_instance.game_data.score = 0
		util.root.data_instance.vfx.vfx_win_confetti.restart()
		util.root.data_instance.vfx.vfx_win_confetti.emitting = true
	
		
		util.root.data_instance.audio.sfx_dictionary.coin_3.sfx.play()
		btn_claim.show()
		btn_claim.disabled = false
