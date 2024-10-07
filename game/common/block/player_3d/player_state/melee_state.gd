# melee class_state
extends class_state

@export var right_arm_target_slash_start : Marker3D
var right_arm_target_slash_mid
@export var right_arm_target_slash_end : Marker3D
@export var left_arm_target_slash_left : Marker3D

func enter_state() -> void:
	super()
	right_arm_target_slash_mid = right_arm_target_slash_start.position.lerp(right_arm_target_slash_end.position, 0.5)
	 
func process_physics(delta: float) -> class_state:
	if actor.player_input.want_to_attack():
		animate_slash_attack()
		actor.slash_vfx.emitting = true
		#root.cam.cam_shake.shake(0.075)

	if actor.player_input.want_to_switch_weapon():
		return state_machine_parent.state_list["range"]
	return null

func animate_slash_attack():
	var tween = create_tween().set_trans(Tween.TRANS_BOUNCE)
	var tween_left = create_tween().set_trans(Tween.TRANS_BOUNCE)	
	tween.tween_property(actor.body_right_arm,"position",right_arm_target_slash_start.position,0.02)
	tween.tween_property(actor.body_right_arm,"position",right_arm_target_slash_mid,0.05)
	tween.tween_property(actor.body_right_arm,"position",right_arm_target_slash_end.position,0.05)
	
	tween.tween_property(actor.body_right_arm,"position",actor.target_default_right_arm.position,0.2)
	tween_left.tween_property(actor.body_left_arm,"position",left_arm_target_slash_left.position,0.1)
	tween_left.tween_property(actor.body_left_arm,"position",actor.target_default_left_arm.position,0.3)	
