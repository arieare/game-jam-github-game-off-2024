extends ui_btn_change_scene

@export var btn_label:RichTextLabel
@export var money: RichTextLabel

func _ready():
	game_node = util.root.game_instance.rogue_knight.game.game_node.scene_0
	ui_node = util.root.game_instance.rogue_knight.ui.ui_node.game_ui
	self.grab_focus()
	util.root.data_instance.stylesheet.button_styler(self, btn_label, "black", "big", false, true)	
	#data_node = null

func scene_update():
	util.root.data_instance.game_data.current_level += 1
	super()
	#game_node = null
	util.root.data_instance.money_amount_change.emit(money.final_money)
	money.final_money = 0

	self.text = "[shake rate=20.0 level=8 connected=1]$" + str(0) +"[/shake]"
	self.disabled = true
	self.hide()
	#await get_tree().create_timer(0.5).timeout
	util.root.data_instance.current_game_state = util.root.data_instance.GAME_STATE.PLANNING
