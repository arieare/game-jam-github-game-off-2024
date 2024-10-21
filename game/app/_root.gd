extends Node

## Skeleton
@export var data_container: Node
var data_instance: Node
@export var game_container: Node
@export var ui_container: Node
@export var root_menu: PackedScene
@export var root_game_select_menu: PackedScene

#@onready var game_instance: Dictionary = {
#"data": {
	#"carchemy_survival":preload("res://collection/carchemy_survival/game/core/game_data.tscn"),
	#"the_tiny_tale":preload("res://collection/the_tiny_tale/game/core/game_data.tscn")
	#},
#"game_catalogue": {
	#"the_tiny_tale":{
		#"name": "The Tiny Tale",
		#"icon": ResourceLoader.load("res://collection/the_tiny_tale/content/icon.png")},
	#"carchemy_survival":{
		#"name": "Carchemy Survival",
		#"icon": ResourceLoader.load("res://collection/carchemy_survival/content/icon.png")},
	#"very_leafy_place":{
		#"name": "Very Leafy Place",
		#"icon": ResourceLoader.load("res://collection/the_tiny_tale/content/icon.png")}},
#"game": {
	#"the_tiny_tale": preload("res://collection/the_tiny_tale/game/core/game_the_tiny_tale.tres"),
	#"carchemy_survival":preload("res://collection/carchemy_survival/game/core/game_carchemy_survival.tres"),
	##"very_leafy_place": preload("res://game/collection/game_very_leafy_place/game_very_leafy_place.tres")
	#},
#
#"ui": {
	#"_root": preload("res://app/ui_root.tres"),
	#"the_tiny_tale": preload("res://collection/the_tiny_tale/game/core/ui_the_tiny_tale.tres"),
	#"carchemy_survival":preload("res://collection/carchemy_survival/game/core/ui_carchemy_survival.tres"),
	##"very_leafy_place": preload("res://ui/collection/game_very_leafy_place/ui_very_leafy_place.tres")
	#}
#}

@onready var game_instance: Dictionary = {
	"game_1": {
		"name": "Game 1",
		"icon":  ResourceLoader.load("res://collection/the_tiny_tale/content/icon.png"),
		"data": preload("res://collection/carchemy_survival/game/core/game_data.tscn"),
		"game": preload("res://collection/carchemy_survival/game/core/game_data.tscn"),
		"ui": preload("res://collection/the_tiny_tale/game/core/ui_the_tiny_tale.tres")
		},
	"the_tiny_tale": {
		"name": "The Tiny Tale",
		"icon":  ResourceLoader.load("res://collection/the_tiny_tale/content/icon.png"),
		"data": preload("res://collection/the_tiny_tale/game/core/game_data.tscn"),
		"game": preload("res://collection/the_tiny_tale/game/core/game_the_tiny_tale.tres"),
		"ui": preload("res://collection/the_tiny_tale/game/core/ui_the_tiny_tale.tres")
		},
}
func _ready() -> void:
	util.emit_signal("root_ready", self)
	ui_container.add_child(root_menu.instantiate())
