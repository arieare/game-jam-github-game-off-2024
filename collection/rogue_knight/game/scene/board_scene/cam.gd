extends Camera3D

@export var board_node: Node3D
@export var shake_node: component_cam_shake

func _ready() -> void:
	await board_node.ready
	util.root.data_instance.game_data.current_cam = self #dependency injection
	var pos = util.root.data_instance.game_data.board_data.size/2 * 0.5
	self.position.x = pos
	self.position.z = pos + 11.5

func _process(delta: float) -> void:
	shake_node.apply_shake(self, delta)
	var mouse_pos_2d_x = remap(get_viewport().get_mouse_position().x,0,1600,-2.0,2.0)
	var mouse_pos_2d_y = remap(get_viewport().get_mouse_position().y,0,900,20.0,16.00)
	var mouse_pos_2d_rot_y = remap(get_viewport().get_mouse_position().y,0,900,-60.0,-55.0)
	self.rotation_degrees.y = -mouse_pos_2d_x
	self.rotation_degrees.x = mouse_pos_2d_rot_y
	self.position.y = mouse_pos_2d_y
