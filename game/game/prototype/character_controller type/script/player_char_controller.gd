extends CharMovementBase

#var cam_offset
#func _ready():
	#super()
	#cam_offset = world.top_down_cam.global_position - character_parent.global_position
	#
#func _physics_process(delta):
	#super(delta)
	#world.top_down_cam.global_position = character_parent.global_position + cam_offset

func get_jump_input():
	if Input.is_action_just_pressed("jump"):
		return true

func get_dir():
	return Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")		

func get_run_input():
	if Input.is_action_pressed("run"):
		return true
