extends ui_btn_quit

@export var btn_label: RichTextLabel

func _process(delta: float) -> void:
	util.root.data_instance.stylesheet.button_styler(self, btn_label, "purple_secondary", "big", false, false)
