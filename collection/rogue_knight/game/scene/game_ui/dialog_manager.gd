extends Control

@export var chat_box: PackedScene

var dialog_line: Array = []
var current_line_index = 0

var text_box
var text_box_position: Vector2

var is_dialog_active:=false
var can_advance_line:=false

func start_dialog(pos:Vector2, line: Array):
	if is_dialog_active:
		return
	dialog_line = line
	text_box_position = pos
	_show_chat_box()
	
	is_dialog_active = true

func _show_chat_box():
	text_box = chat_box.instantiate()
	text_box.connect("finish_displaying_chat", _on_finish_displaying_chat)
	self.add_child(text_box)
	text_box.global_position = text_box_position
	text_box.display_text(dialog_line[current_line_index])
	can_advance_line = false

func _on_finish_displaying_chat():
	can_advance_line = true
	
func _unhandled_input(event: InputEvent) -> void:
	if(
		event.is_action_pressed("chat") and 
		is_dialog_active and
		can_advance_line
	):
		text_box.queue_free()
		current_line_index += 1
		if current_line_index >= dialog_line.size():
			is_dialog_active = false
			current_line_index = 0
			util.root.data_instance.dialog_done.emit()
			return
		
		_show_chat_box()
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and is_dialog_active and can_advance_line:	
			text_box.queue_free()
			current_line_index += 1
			if current_line_index >= dialog_line.size():
				is_dialog_active = false
				current_line_index = 0
				util.root.data_instance.dialog_done.emit()
				return
			
			_show_chat_box()			


func _ready() -> void:
	util.root.data_instance.connect("board_ready", _on_board_ready)
	util.root.data_instance.connect("game_state_change", _on_game_state_change)
	util.root.data_instance.connect("dialog_done", _on_dialog_done)

func _on_board_ready():
	if util.root.data_instance.level_data.has(util.root.data_instance.game_data.current_level):
		if util.root.data_instance.level_data[util.root.data_instance.game_data.current_level].has("dialog"):
			await get_tree().create_timer(0.5).timeout
			start_dialog(Vector2(50,780), util.root.data_instance.level_data[util.root.data_instance.game_data.current_level].dialog)

func _on_game_state_change(state):
	match state:
		util.root.data_instance.GAME_STATE.FINALE:
			start_dialog(Vector2(50,780), util.root.data_instance.finale_dialog)
		util.root.data_instance.GAME_STATE.FINALE_SECRET_CORRECT:		
			start_dialog(Vector2(50,780), util.root.data_instance.finale_dialog_right)
		util.root.data_instance.GAME_STATE.FINALE_SECRET_WRONG:				
			start_dialog(Vector2(50,780), util.root.data_instance.finale_dialog_wrong)

func _on_dialog_done():
	if util.root.data_instance.current_game_state == util.root.data_instance.GAME_STATE.FINALE:
		util.root.data_instance.current_game_state = util.root.data_instance.GAME_STATE.FINALE_2	
	if util.root.data_instance.current_game_state == util.root.data_instance.GAME_STATE.FINALE_SECRET_CORRECT:
		util.root.data_instance.current_game_state = util.root.data_instance.GAME_STATE.TRUE_ENDING
	if util.root.data_instance.current_game_state == util.root.data_instance.GAME_STATE.FINALE_SECRET_WRONG:		
		util.root.data_instance.current_game_state = util.root.data_instance.GAME_STATE.LOSING
