extends Node

## Skeleton
@export var data_container: Node
var data_instance: Node
@export var game_container: Node
@export var ui_container: Node

@onready var game_instance: Dictionary = {
"data": {
	"carchemy_survival":preload("res://game/collection/game_carchemy_survival/core/data_carchemy_survival.tres"),
	"the_tiny_tale":preload("res://collection/the_tiny_tale/game/core/game.tscn")
	},
"game_catalogue": {
	"the_tiny_tale":{
		"name": "The Tiny Tale",
		"icon": ResourceLoader.load("res://collection/the_tiny_tale/content/icon.png")},
	"carchemy_survival":{
		"name": "Carchemy Survival",
		"icon": ResourceLoader.load("res://content/collection/game_carchemy_survival/icon.png")},
	"very_leafy_place":{
		"name": "Very Leafy Place",
		"icon": ResourceLoader.load("res://content/collection/game_the_tiny_tale/icon.png")}},
"game": {
	"the_tiny_tale": preload("res://collection/the_tiny_tale/game/core/game_the_tiny_tale.tres"),
	"carchemy_survival":preload("res://game/collection/game_carchemy_survival/core/game_carchemy_survival.tres"),
	"very_leafy_place": preload("res://game/collection/game_very_leafy_place/game_very_leafy_place.tres")
	},

"ui": {
	"_root": preload("res://app/ui_root.tres"),
	"the_tiny_tale": preload("res://collection/the_tiny_tale/game/core/ui_the_tiny_tale.tres"),
	"carchemy_survival":preload("res://ui/collection/game_carchemy_survival/ui_carchemy_survival.tres"),
	"very_leafy_place": preload("res://ui/collection/game_very_leafy_place/ui_very_leafy_place.tres")
	}
}

func _ready() -> void:
	util.emit_signal("root_ready", self)
	ui_container.add_child(game_instance.ui._root.ui_node.main_menu.instantiate())
