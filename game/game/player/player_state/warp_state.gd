# Warp State
extends State

func enter_state() -> void:
	actor.warp_start_vfx.restart()
	actor.warp_start_vfx.global_position = actor.global_position
	actor.warp_start_vfx.emitting = true
	warp()
	super()	


func process_frame(delta: float) -> State:
	if actor.player_input.want_to_finish_warp():
		return state_machine_parent.state_dictionary["fall"]
	return null

func warp():
	## screenshake
	actor.root.cam.cam_feature["cam_shake"].shake(0.05)
	var warp_toward = actor.skill_state_machine.current_state.current_projectile.global_position
	var tween = create_tween().set_trans(Tween.TRANS_BOUNCE)
	var forward_direction = -actor.body_head.global_transform.basis.z.normalized()
	tween.tween_property(actor,"global_position",warp_toward + Vector3(0,1.2,0),0.01)
	await tween.finished
	actor.skill_state_machine.current_state.current_projectile.queue_free()
	actor.apply_central_impulse(forward_direction * Vector3(15,15,15))
	OS.delay_msec(110)
