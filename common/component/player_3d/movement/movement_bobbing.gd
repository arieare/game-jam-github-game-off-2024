extends Node3D

var parent: RigidBody3D

#IK target
@export var left_target:MeshInstance3D
@export var right_target:MeshInstance3D
@export var feet_ray:RayCast3D

#Bobbing movement
var step_magnitude:float = 14 # the bigger, the smaller step it is #12
var walk_frequence:float = step_magnitude * 1.5
var walk_amplitude:float = PI * walk_frequence
var walk_decay:float = 0.5
var walk_time:float = 0.0
var walk_amount:float = 0.0

var hip_width: float = 0.2
var step_height:Vector3 = Vector3(0,0.25,0)
var step_forward_distance:Vector3 = Vector3(0,0,-0.5)

func assert_parent(parent_node: RigidBody3D):
	parent = parent_node

func walk_bobbing(delta):
	#skeleton_ik_left.start()
	#skeleton_ik_right.start()
	
	walk_amount = 2.0
	walk_time += delta
	walk_amount *= walk_decay
	
	var walk_cycle = sin(walk_time*walk_frequence)*walk_amplitude*walk_amount
	
	var current_target_foot = right_target
	
	var bobbing_point: Vector3
	
	var push_down_force = walk_cycle / 16

	if walk_cycle < -walk_frequence:
		bobbing_point = Vector3(hip_width, 0, 0)
		current_target_foot = left_target
		pass
		#if !sfx_step.playing:
			#sfx_step.play()
	if walk_cycle > walk_frequence:
		bobbing_point = Vector3(-hip_width, 0, 0)
		current_target_foot = right_target		
		pass
		#if !sfx_step_right.playing:
			#sfx_step_right.play()	
		
	#parent.apply_force(Vector3.UP * push_down_force * parent.mass, bobbing_point)
	#parent.body.position = Vector3(0,push_down_force * bobbing_point.y,0)
	
	
	var ik_position_from_hip: Vector3 = to_global(bobbing_point + step_forward_distance)
	
	var new_ik_position = to_local(feet_ray.get_collision_point()) + ik_position_from_hip
	
	var half_ik_position = current_target_foot.global_position.lerp(new_ik_position, 0.5) + step_height
	
	
	var tween = create_tween().set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(current_target_foot,"global_position",half_ik_position,0.025)
	await tween
	tween.tween_property(current_target_foot,"global_position",new_ik_position,0.025)


	
