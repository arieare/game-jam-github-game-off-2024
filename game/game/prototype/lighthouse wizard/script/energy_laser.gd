extends Node3D

var sender

var bounces := 3

var rot := 0.0

const MAX_LENGTH := 2000 # max length 

@onready var line = $line
var max_cast_to # vector that updates based on rotation

var lasers := []

@export var beam : RayCast3D

func _ready():
	
	sender = get_parent()
	
	#lasers.append(beam)
	#for i in range(bounces):
		#var raycast = beam.duplicate()
		#raycast.enabled = false
		#sender.add_child(raycast)
		##raycast.add(sender)
		##add_child(raycast)
		#lasers.append(raycast)
	#
	##max_cast_to = Vector3(MAX_LENGTH, 0, 0).rotated(rot)
	#max_cast_to = Vector3(MAX_LENGTH, 0, 0)
	##beam.add_exception(sender)
	#beam.cast_to = max_cast_to
	#$line.set_as_toplevel(true)
	

func _process(_delta):
	
	#$End.emitting = true
	#rot = get_local_mouse_position().angle()
	
	line.clear_points()
	line.add_point(global_position)
	
	max_cast_to = Vector2(MAX_LENGTH, 0).rotated(15.0)
	
	var idx = -1
	for raycast in lasers:
		
		idx += 1
		var raycastcollision = raycast.get_collision_point()
		
		raycast.cast_to = max_cast_to
		if raycast.is_colliding():
			line.add_point(raycastcollision)
			
			max_cast_to = max_cast_to.bounce(raycast.get_collision_normal())
			if idx < lasers.size()-1:
				lasers[idx+1].enabled = true
				lasers[idx+1].global_position = raycastcollision+(1*max_cast_to.normalized())
			if idx == lasers.size()-1:
				pass
				#$End.global_position = raycastcollision
		else:
			line.add_point(global_position + max_cast_to)
			#$End.emitting = false
			break
			
		
