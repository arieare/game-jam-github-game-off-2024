extends Button

var game_node
var ui_node
var data_node

var root_instance

func _ready():
	#call_deferred("print",util.root.game_instance)
	#print(util.root.game_instance)
	#await root.ready
	self.disabled = true
	util.connect("root_ready", _on_root_ready)
	util.connect("data_ready", _on_data_ready)

func _input(event: InputEvent) -> void:
	if !event.is_echo() and self.button_pressed:
		game_node = null
		#ui_node = util.root.game_instance["rogue_knight"].ui.ui_node.main_menu
		#data_node = util.root.game_instance["rogue_knight"].data		
		#print("hello")
		##util.scene_manager.change( util.root.ui_container, util.root.game_instance[key].ui.ui_node.main_menu)
		##print(util.root.game_instance.data[key])
		#util.scene_manager.change( util.root.data_container, util.root.game_instance["rogue_knight"].data)
		#util.root.data_instance = util.root.data_container.get_child(0)
		scene_update()


	
func scene_update():
	util.scene_manager.change( util.root.game_container, game_node)	
	util.scene_manager.change( util.root.ui_container, ui_node)
	var data = util.root.game_instance["rogue_knight"].data.instantiate()
	util.root.data_container.add_child(data)
	util.root.data_instance = util.root.data_container.get_child(0)
	#util.scene_manager.change( util.root.data_container, data_node)
	#pass

func _on_root_ready(root):
	root_instance = root
	game_node = null
	ui_node = root_instance.game_instance["rogue_knight"].ui.ui_node.main_menu
	self.disabled = false

func _on_data_ready():
	data_node = root_instance.game_instance["rogue_knight"].data
	print(data_node)
	
#util.scene_manager.change( util.root.game_container, util.root.game_instance.game.very_leafy_place.node)	
