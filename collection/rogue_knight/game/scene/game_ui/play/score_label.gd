extends Label

@export var score_label: Label

func _ready() -> void:
	util.root.data_instance.connect("score_added", _on_score_added)

func _process(delta: float) -> void:
	if util.root.data_instance.current_game_state == util.root.data_instance.GAME_STATE.PLAYING:
		self.text = str(util.root.data_instance.game_data.score)
	if util.root.data_instance.current_game_state == util.root.data_instance.GAME_STATE.WINNING:
		self.add_theme_color_override("font_shadow_color", Color.DARK_GREEN)
		
		self.add_theme_color_override("font_color", Color.WHITE)
	elif util.root.data_instance.current_game_state == util.root.data_instance.GAME_STATE.LOSING:
		self.add_theme_color_override("font_shadow_color", Color.DARK_RED)
		
		self.add_theme_color_override("font_color", Color.WHITE)

func _on_score_added(score):
	var current_pos := self.position
	var score_tween: Tween
	score_tween = create_tween().set_trans(Tween.TRANS_ELASTIC)
	score_tween.tween_property(self,"scale", Vector2(1.3,1.3),0.05)
	var new_pos := Vector2(current_pos.x-self.size.x/2, current_pos.y-self.size.y/2)
	score_tween.tween_property(self,"position",new_pos,0.02)

	score_tween.tween_property(self,"scale", Vector2(1,1),0.02)

	score_tween.tween_property(self,"position",current_pos,0.02)
