extends NodeControlPlus

@export var start_btn: Button

func _ready() -> void:
	start_btn.grab_focus()

func _input(event: InputEvent) -> void:
	if !event.is_echo() and start_btn.button_pressed:
		global.scene_manager._on_change_scene( root.node_list["game"], root.game_node["the_tiny_tale"])	
		global.scene_manager._on_change_scene( root.node_list["ui"], null)
