# Range State
extends State

@export var right_arm_target_slash_start : Marker3D
var right_arm_target_slash_mid
@export var right_arm_target_slash_end : Marker3D
@export var left_arm_target_slash_left : Marker3D


var is_can_shoot: bool = true
@export var projectile : PackedScene
var quiver_size: float = 20
var current_projectile
@export var PROJECTILE_SPEED: float = 20.0

func enter_state() -> void:
	super()
	right_arm_target_slash_mid = right_arm_target_slash_start.position.lerp(right_arm_target_slash_end.position, 0.5)

func process_physics(delta: float) -> State:
	if actor.player_input.want_to_attack() and is_can_shoot:
		print("range")
		animate_slash_attack()
		actor.slash_vfx.emitting = true
		actor.root.cam.cam_feature["cam_shake"].shake(0.075)
		shoot()
	
	if actor.player_input.want_to_switch_weapon():
		return state_machine_parent.state_dictionary["melee"]
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

func shoot():
	if is_can_shoot:
		#for projectile in projectileSpawns:
		var new_projectile = projectile.instantiate()
		current_projectile = new_projectile
		new_projectile.global_transform = actor.body_head.global_transform # should be nock
		
		#actor.root.cam.cam_filter.pixel_subviewport.add_child(new_projectile)
		actor.root.root_node["game"].add_child(new_projectile)

		new_projectile.speed = PROJECTILE_SPEED
		#fxSlash.emitting = true
		#print("dor!")
		is_can_shoot = false
		await get_tree().create_timer(0.3).timeout
		#projectilesInQuiver -= 1
		##TODO emit signal to display projectile count
		##TODO play effect or recoil
		is_can_shoot = true
		#return true
	#elif not projectilesInQuiver:
		#pass
		##TODO reload
	#return false
