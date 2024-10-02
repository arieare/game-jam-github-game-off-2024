extends Node

@export var target_resolution = Vector2i(1600,900)

func _ready():
	DisplayServer.window_set_size(target_resolution) ## Set Window Size
