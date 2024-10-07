extends NodeControlPlus

@onready var btn_game_scn = preload("res://ui/main/game_selection_menu/btn_game_list.tscn")
@export var button_container: HFlowContainer
@export var game_title_label: Label

@onready var game_dictionary = {
	"tiny_tale": root.ui_node["the_tiny_tale_main_menu"],
	"carchemy_survival": root.ui_node["carchemy_survival_main_menu"]
}

var game_button_dictionary = {}

func _ready() -> void:
	for key in game_dictionary:
		var btn = btn_game_scn.instantiate()
		btn.name = key
		game_button_dictionary[btn] = game_dictionary[key]
		button_container.add_child(btn)

func _input(event: InputEvent) -> void:
	for key in game_button_dictionary:
		if !event.is_echo() and key.button_pressed:
			global.scene_manager._on_change_scene( root.node_list["ui"], game_button_dictionary[key])
	for key in game_button_dictionary:
		if !event.is_echo() and key.is_hovered():
			game_title_label.text = str(key.name)
