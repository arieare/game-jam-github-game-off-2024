extends Button

@export var btn_label: RichTextLabel

func _ready():
	util.root.data_instance.stylesheet.button_styler(self, btn_label, "purple_secondary", "small", false, true)
