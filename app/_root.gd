extends Node

## Skeleton
@export var data_container: Node
var data_instance: Node
@export var game_container: Node
@export var ui_container: Node
@export var root_menu: PackedScene
@export var root_game_select_menu: PackedScene


@onready var game_instance: Dictionary = {
	"rogue_knight": {
		"name": "Rogue Knight",
		"icon":  ResourceLoader.load("res://app/app-icon.png"),
		"data": preload("res://collection/rogue_knight/game/core/game_data.tscn"),
		"game": preload("res://collection/rogue_knight/game/core/game_rogue_knight.tres"),
		"ui": preload("res://collection/rogue_knight/game/core/ui_rogue_knight.tres")
		},				
}
func _ready() -> void:
	util.emit_signal("root_ready", self)
	ui_container.add_child(root_menu.instantiate())
