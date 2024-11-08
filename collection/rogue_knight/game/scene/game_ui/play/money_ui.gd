extends Label

@export var money_value_updater: RichTextLabel
var audio_player_caching: AudioStreamPlayer
func _ready() -> void:
	init_audio()
	self.text = "$" + str(util.root.data_instance.game_data.money)
	util.root.data_instance.connect("money_amount_change", _on_money_amount_change)
	money_value_updater.hide()
	money_value_updater.top_level

func _process(delta: float) -> void:
	#if util.root.data_instance.current_game_state == util.root.data_instance.GAME_STATE.PLAYING:
	self.add_theme_color_override("font_shadow_color", Color.DARK_SLATE_BLUE)
	self.add_theme_color_override("font_color", Color.LIGHT_GOLDENROD)
	if util.root.data_instance.current_game_state == util.root.data_instance.GAME_STATE.WINNING:
		self.add_theme_color_override("font_shadow_color", Color.DARK_GREEN)
		self.add_theme_color_override("font_color", Color.WHITE)
	elif util.root.data_instance.current_game_state == util.root.data_instance.GAME_STATE.LOSING:
		self.add_theme_color_override("font_shadow_color", Color.DARK_RED)
		self.add_theme_color_override("font_color", Color.WHITE)

func _on_money_amount_change(value):
	self.text = "$" + str(util.root.data_instance.game_data.money)
	tween_move_updater(value)

var move_tween: Tween
func tween_move_updater(value:int):
	if move_tween:
		money_value_updater.position.x = 0
		move_tween.kill()
	money_value_updater.show()	
	if value < 0:
		money_value_updater.text = "[bgcolor=CRIMSON]" + str(value) + "[/bgcolor]"
	else:
		money_value_updater.text = "[bgcolor=LIME]+" + str(value) + "[/bgcolor]"		
	move_tween = create_tween().set_trans(Tween.TRANS_BOUNCE)
	move_tween.tween_property(money_value_updater,"position:x", self.size.x + 15,0.15)
	audio_player_caching.play()
	move_tween.tween_interval(0.2)
	await move_tween.finished
	money_value_updater.position.x = 0
	money_value_updater.hide()


@export var sfx_caching: AudioStream
func init_audio():
	audio_player_caching = AudioStreamPlayer.new()
	audio_player_caching.max_polyphony = 128
	var random_audio_hover = AudioStreamRandomizer.new()
	audio_player_caching.stream = random_audio_hover

	random_audio_hover.add_stream(0, sfx_caching, 1.0)
	random_audio_hover.playback_mode = AudioStreamRandomizer.PLAYBACK_SEQUENTIAL
	random_audio_hover.random_pitch = 1.1
	
	self.add_child(audio_player_caching)
