extends Control

@export var start_btn: Button

func _ready() -> void:
	start_btn.grab_focus()

func _input(event: InputEvent) -> void:
	if !event.is_echo() and start_btn.button_pressed:
		util.scene_manager.change( util.root.game_container, util.root.game_instance.game.carchemy_survival.game_node.game)	
