extends Node

@onready var btn_game_scn = preload("res://ui/main/game_selection_menu/btn_game_list.tscn")
@export var button_container: HFlowContainer
@export var game_title_label: Label


var game_button_dictionary: Dictionary = {}
var game_title_dictionary: Dictionary = {}

func _ready() -> void:
	for key in util.root.game_instance.game_catalogue:
		var btn:TextureButton = btn_game_scn.instantiate()
		var title: String
		var icon_path
		btn.name = key
		for attribute in util.root.game_instance.game_catalogue[key]:
			if attribute == "icon":
				icon_path = util.root.game_instance.game_catalogue[key][attribute]
				if icon_path != null:
					btn.texture_normal = util.root.game_instance.game_catalogue[key][attribute]
				button_container.add_child(btn)
			elif attribute == "name":
				game_button_dictionary[key] = btn
				game_title_dictionary[key] = util.root.game_instance.game_catalogue[key][attribute]
		btn.grab_focus()

func _input(event: InputEvent) -> void:
	for key in game_button_dictionary:
		if !event.is_echo() and game_button_dictionary[key].button_pressed:
			util.scene_manager.change( util.root.ui_container, util.root.game_instance.ui[key].ui_node.main_menu)
	for key in game_button_dictionary:
		if !event.is_echo() and game_button_dictionary[key].is_hovered() or game_button_dictionary[key].has_focus():
			game_title_label.text = game_title_dictionary[key]
			game_button_dictionary[key].grab_focus()
			
