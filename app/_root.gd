extends Node

## Skeleton
@export var data_container: Node
var data_instance: Node
@export var game_container: Node
@export var ui_container: Node
@export var root_menu: PackedScene
@export var root_game_select_menu: PackedScene
@onready var game_instance_path: Dictionary = {
	#"the_tiny_tale": {
		#"name": "The Tiny Tale",
		#"icon":  "res://collection/the_tiny_tale/content/icon.png",
		#"data": "res://collection/the_tiny_tale/game/core/game_data.tscn",
		#"game": "res://collection/the_tiny_tale/game/core/game_the_tiny_tale.tres",
		#"ui": "res://collection/the_tiny_tale/game/core/ui_the_tiny_tale.tres"
		#},
	#"carchemy_survival": {
		#"name": "Carchemy Survival",
		#"icon":  "res://collection/carchemy_survival/content/icon.png",
		#"data": "res://collection/carchemy_survival/game/core/game_data.tscn",
		#"game": "res://collection/carchemy_survival/game/core/game_carchemy_survival.tres",
		#"ui": "res://collection/carchemy_survival/game/core/ui_carchemy_survival.tres",
		#},
	#"very_leafy_place": {
		#"name": "Very Leafy Place",
		#"icon":  "res://collection/carchemy_survival/content/icon.png",
		#"data": "res://collection/very_leafy_place/game/core/game_data.tscn",
		#"game": "res://collection/very_leafy_place/game/core/game_very_leafy_place.tres",
		#"ui": "res://collection/very_leafy_place/game/core/ui_very_leafy_place.tres",
		#},
	#"the_dismantler": {
		#"name": "The Dismantler",
		#"icon":  "res://collection/carchemy_survival/content/icon.png",
		#"data": "res://collection/the_dismantler/game/core/game_data.tscn",
		#"game": "res://collection/the_dismantler/game/core/game_nodes.tres",
		#"ui": "res://collection/the_dismantler/game/core/ui_nodes.tres",
		#},	
	"rogue_knight": {
		"name": "Rogue Knight",
		"icon":  "res://collection/rogue_knight/content/icon.png",
		"data": "res://collection/rogue_knight/game/core/game_data.tscn",
		"game": "res://collection/rogue_knight/game/core/game_rogue_knight.tres",
		"ui": "res://collection/rogue_knight/game/core/ui_rogue_knight.tres",
		},				
}
@onready var game_instance: Dictionary = {
	
	}
@onready var loaded_items: Dictionary = {
	
	}

var array_thread: Array
var array_progress: Array
var variable_thread := {}
func _ready() -> void:
	util.emit_signal("root_ready", self)
	ui_container.add_child(root_menu.instantiate())
	
	var x = 0
	for instance in game_instance_path:
		for data in game_instance_path[instance]:
			if data != "name":
				ResourceLoader.load_threaded_request(game_instance_path[instance][data])
				array_thread.append("loading_status_" + str(x))
				array_progress.append([0.0])
				variable_thread[array_thread[x]] = ResourceLoader.load_threaded_get_status(game_instance_path[instance][data], array_progress[x])	
				#loaded_items[data] = ResourceLoader.load_threaded_get(game_instance_path[instance][data])
				#game_instance[instance] = loaded_items					
				x += 1


var progress: Array[float]
var loading_status: int
var is_loading: bool = true
func _process(delta: float) -> void:
	##pass
	for key in variable_thread:
		for i in array_thread.size()-1:
			for instance in game_instance_path:
				for data in game_instance_path[instance]:
					is_loading = true
					if data != "name":
						variable_thread[array_thread[i]] = ResourceLoader.load_threaded_get_status(game_instance_path[instance][data], array_progress[i])
						match variable_thread[array_thread[i]]:
							ResourceLoader.THREAD_LOAD_IN_PROGRESS:
								#print(variable_thread[array_thread[i]] * 100)
								pass
							ResourceLoader.THREAD_LOAD_LOADED:
								loaded_items[data] = ResourceLoader.load_threaded_get(game_instance_path[instance][data])
								game_instance[instance] = loaded_items
								#print(game_instance)
								#util.emit_signal("data_ready")
								is_loading = false
								
			if is_loading == false:
				util.emit_signal("data_ready")
