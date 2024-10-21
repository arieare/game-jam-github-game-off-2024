extends Node

#@export var btn_game_scn: PackedScene
@export var button_container: HFlowContainer
@export var game_title_label: Label


var game_button_dictionary: Dictionary = {}
var game_title_dictionary: Dictionary = {}

func _ready() -> void:
	for key in util.root.game_instance:
		#var btn:TextureButton = btn_game_scn.instantiate()
		var btn:TextureButton = instance_game_menu_button()
		var title: String
		var icon_path
		btn.name = key
		for attribute in util.root.game_instance[key]:
			if attribute == "icon":
				icon_path = util.root.game_instance[key][attribute]
				if icon_path != null:
					btn.texture_normal = util.root.game_instance[key][attribute]
				button_container.add_child(btn)
			elif attribute == "name":
				game_button_dictionary[key] = btn
				game_title_dictionary[key] = util.root.game_instance[key][attribute]
		btn.grab_focus()
		game_title_label.text = game_title_dictionary[key]

func _input(event: InputEvent) -> void:
	for key in game_button_dictionary:
		if !event.is_echo() and game_button_dictionary[key].button_pressed:
			util.scene_manager.change( util.root.ui_container, util.root.game_instance[key].ui.ui_node.main_menu)
			#print(util.root.game_instance.data[key])
			util.scene_manager.change( util.root.data_container, util.root.game_instance[key].data)
	for key in game_button_dictionary:
		if !event.is_echo() and game_button_dictionary[key].is_hovered() or game_button_dictionary[key].has_focus():
			game_title_label.text = game_title_dictionary[key]
			game_button_dictionary[key].grab_focus()
			

func instance_game_menu_button() -> TextureButton:
	var game_menu_btn = TextureButton.new()
	game_menu_btn.ignore_texture_size = true
	game_menu_btn.stretch_mode = TextureButton.STRETCH_SCALE
	game_menu_btn.custom_minimum_size.x = 300.0
	game_menu_btn.custom_minimum_size.y = 300.0
	game_menu_btn.texture_focused = preload("res://content/texture/dither_tex.png")
	return game_menu_btn
	
