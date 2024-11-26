
extends PanelContainer

@export var label: RichTextLabel

@export var label_text := ""

func _ready() -> void:
	label.text = label_text
	util.root.data_instance.stylesheet.badge_styler(self, "white", "small")

func _process(delta: float) -> void:
	util.root.data_instance.stylesheet.badge_styler(self, "white", "small")
