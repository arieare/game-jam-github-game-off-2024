extends Node

## Skeleton
@export var data_container: Node
var data_instance: Node
@export var game_container: Node
@export var ui_container: Node
@export var root_menu: PackedScene
@export var root_game_select_menu: PackedScene


@onready var icon = load("res://app/app-icon.png")
@onready var data:PackedScene = load("res://collection/rogue_knight/game/core/game_data.tscn")
@export var game_node: Dictionary[String, PackedScene]
@onready var game = {"game_node":game_node}

@export var ui_node: Dictionary[String, PackedScene]
@onready var ui = {"ui_node":ui_node}

@onready var game_instance: Dictionary = {
	"rogue_knight": {
		"name": "Rogue Knight",
		"icon": icon,
		"data": data,
		"game": game,
		"ui": ui
		},				
}
func _ready() -> void:
	print(ui)
	util.emit_signal("root_ready", self)
	ui_container.add_child(root_menu.instantiate())
