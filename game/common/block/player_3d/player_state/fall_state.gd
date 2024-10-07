# Fall class_state
extends class_state

@export var FALL_SPEED: float = 2000.0
@export var arm_target_fall_right : Marker3D
@export var arm_target_fall_left : Marker3D
@export var arm_target_fall_mid_right : Marker3D
@export var arm_target_fall_mid_left : Marker3D
@export var arm_target_default_right : Marker3D
@export var arm_target_default_left : Marker3D

var is_animating: bool = false

func process_physics(delta: float) -> class_state:
	var tween_arm_right = create_tween().set_trans(Tween.TRANS_BOUNCE)
	var tween_arm_left = create_tween().set_trans(Tween.TRANS_BOUNCE)
	actor.apply_central_force(Vector3.DOWN * FALL_SPEED * actor.mass * delta)
	
	if !is_animating:
		tween_arm_right.tween_property(actor.body_right_arm,"position",arm_target_fall_mid_right.position,0.02)
		tween_arm_right.tween_property(actor.body_right_arm,"position",arm_target_fall_right.position,0.02)
		tween_arm_left.tween_property(actor.body_left_arm,"position",arm_target_fall_mid_left.position,0.02)
		tween_arm_left.tween_property(actor.body_left_arm,"position",arm_target_fall_left.position,0.02)
		is_animating = true
	
	if actor.player_input.get_direction() != Vector3.ZERO and actor.position_state_machine.current_state.name == "on_ground":
		return state_machine_parent.state_list["walk"]		
	if actor.position_state_machine.current_state.name == "on_ground":
		return state_machine_parent.state_list["idle"]		
	return null

func exit_state() -> void:
	
	is_animating = false
	#root.cam.cam_shake.shake(0.075)
	
	var tween_arm_right = create_tween().set_trans(Tween.TRANS_BOUNCE)
	var tween_arm_left = create_tween().set_trans(Tween.TRANS_BOUNCE)
	tween_arm_right.tween_property(actor.body_right_arm,"position",arm_target_default_right.position,0.05)
	tween_arm_left.tween_property(actor.body_left_arm,"position",arm_target_default_left.position,0.05)
	
	var tween = create_tween().set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(actor.skin,"scale:y",0.75,0.05)
	tween.tween_property(actor.skin,"scale:z",1.3,0.01)
	tween.tween_property(actor.skin,"scale:x",1.3,0.01)
	await tween.finished
	var tween_recover = create_tween().set_trans(Tween.TRANS_BOUNCE)
	tween_recover.tween_property(actor.skin,"scale:y",1.0,0.05)
	tween_recover.tween_property(actor.skin,"scale:z",1,0.05)
	tween_recover.tween_property(actor.skin,"scale:x",1,0.05)
	super()
