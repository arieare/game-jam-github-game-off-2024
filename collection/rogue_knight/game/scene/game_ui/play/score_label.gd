extends PanelContainer

@export var label: RichTextLabel

@export var label_text := ""

func _ready() -> void:
	
	label.text = label_text
	util.root.data_instance.stylesheet.badge_styler(self, "black", "medium")
	util.root.data_instance.connect("score_added", _on_score_added)
	self.pivot_offset = self.size/2

#func _ready() -> void:
	#util.root.data_instance.connect("score_added", _on_score_added)

func _process(delta: float) -> void:
	if util.root.data_instance.current_game_state == util.root.data_instance.GAME_STATE.PLAYING:
		label.text = str(util.root.data_instance.game_data.score)
	util.root.data_instance.stylesheet.badge_styler(self, "black", "medium")

func _on_score_added(score):
	var current_pos := self.position
	var score_tween: Tween
	score_tween = create_tween().set_trans(Tween.TRANS_ELASTIC)
	score_tween.tween_property(self,"scale", Vector2(1.15,1.15),0.05)
	score_tween.tween_property(self,"scale", Vector2(1,1),0.04)
