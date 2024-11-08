@tool
extends PanelContainer

@export var label: RichTextLabel

@export var label_text := ""

func _ready() -> void:
	label.text = label_text
