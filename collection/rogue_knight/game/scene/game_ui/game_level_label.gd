#extends Label
extends PanelContainer

@export var game_level_name:Label

@export var label: RichTextLabel

@export var label_text := ""

func _ready() -> void:
	
	label.text = "Stage " + str(util.root.data_instance.game_data.current_level)
	util.root.data_instance.stylesheet.badge_styler(self, "black", "small")

	if util.root.data_instance.level_data.has(util.root.data_instance.game_data.current_level):
		game_level_name.text = util.root.data_instance.level_data[util.root.data_instance.game_data.current_level].title
