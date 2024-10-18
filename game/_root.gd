extends Node

## Skeleton
@export var data_container: Node
@export var game_container: Node
@export var ui_container: Node

@onready var game_instance: Dictionary = {
"data": {
	"name": "data",
	"node": ResourceLoader.load("res://game/collection/game_carchemy_survival/game.tscn")},
"game_catalogue": {
	"the_tiny_tale":{
		"name": "The Tiny Tale",
		"icon": ResourceLoader.load("res://content/collection/game_the_tiny_tale/icon.png")},
	"carchemy_survival":{
		"name": "Carchemy Survival",
		"icon": ResourceLoader.load("res://content/collection/game_carchemy_survival/icon.png")},
	"very_leafy_place":{
		"name": "Very Leafy Place",
		"icon": ResourceLoader.load("res://content/collection/game_the_tiny_tale/icon.png")}},
"game": {
	"the_tiny_tale": preload("res://game/collection/game_the_tiny_tale/game_the_tiny_tale.tres"),
	"carchemy_survival":preload("res://game/collection/game_carchemy_survival/game_carchemy_survival.tres"),
	"very_leafy_place": preload("res://game/collection/game_very_leafy_place/game_very_leafy_place.tres")
	},

"ui": {
	"_root": preload("res://ui/main/ui_root.tres"),
	"the_tiny_tale": preload("res://ui/collection/game_the_tiny_tale/ui_the_tiny_tale.tres"),
	"carchemy_survival":preload("res://ui/collection/game_carchemy_survival/ui_carchemy_survival.tres"),
	"very_leafy_place": preload("res://ui/collection/game_very_leafy_place/ui_very_leafy_place.tres")
	}
}

func _ready() -> void:
	util.emit_signal("root_ready", self)
	ui_container.add_child(game_instance.ui._root.ui_node.main_menu.instantiate())
