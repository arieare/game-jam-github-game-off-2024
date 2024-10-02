extends ControlPlus

@export var start_btn: Button
@export var credit_btn: Button
@export var quit_btn: Button

func _ready() -> void:
	start_btn.grab_focus()

func _input(event: InputEvent) -> void:
	if !event.is_echo() and start_btn.button_pressed:
		root.common["event_bus"].emit_signal("game_state", root.GAME_STATE.RUNNING)
		root.common["event_bus"].emit_signal("change_scene", root.root_node["ui"], self, root.ui_node.debug_ui)
	if !event.is_echo() and credit_btn.button_pressed:
		print("show credit")
	if !event.is_echo() and quit_btn.button_pressed:
		get_tree().quit()
