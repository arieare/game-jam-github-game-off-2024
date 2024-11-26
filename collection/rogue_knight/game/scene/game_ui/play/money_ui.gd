extends Label

@export var money_value_updater: PanelContainer
@onready var money_value_updater_label =  money_value_updater.get_child(0)

func _ready() -> void:
	self.text = "¢" + str(util.root.data_instance.game_data.money)
	util.root.data_instance.connect("money_amount_change", _on_money_amount_change)
	util.root.data_instance.connect("redeem_add_money", _on_redeem_add_money)
	money_value_updater.hide()
	money_value_updater.top_level
	util.root.data_instance.stylesheet.badge_styler(money_value_updater, "white", "medium")

func _process(delta: float) -> void:
	#if util.root.data_instance.current_game_state == util.root.data_instance.GAME_STATE.PLAYING:
	self.add_theme_color_override("font_shadow_color", "#000000DD")
	self.add_theme_color_override("font_color", Color.GOLD)
	self.add_theme_color_override("font_outline_color", Color.DARK_GOLDENROD)
	#self.add_theme_constant_override("outline_size", 12)

func _on_money_amount_change(value):
	self.text = "¢" + str(util.root.data_instance.game_data.money)
	tween_move_updater(value)

var move_tween: Tween
func tween_move_updater(value:int):
	if move_tween:
		money_value_updater.position.x = 0
		move_tween.kill()
	money_value_updater.show()	
	if value < 0:
		money_value_updater_label.text = str(value)
		util.root.data_instance.stylesheet.badge_styler(money_value_updater, "white", "medium")
	else:
		money_value_updater_label.text = "+" + str(value)
		util.root.data_instance.stylesheet.badge_styler(money_value_updater, "white", "medium")
	move_tween = create_tween().set_trans(Tween.TRANS_BOUNCE)
	move_tween.tween_property(money_value_updater,"position:x", self.size.x + 15,0.15)
	util.root.data_instance.audio.sfx_dictionary.caching.sfx.play()
	move_tween.tween_interval(0.2)
	await move_tween.finished
	money_value_updater.position.x = 0
	money_value_updater.hide()

func _on_redeem_add_money():
	util.root.data_instance.game_data.money += 100
	self.text = "¢" + str(util.root.data_instance.game_data.money)
	tween_move_updater(100)	
