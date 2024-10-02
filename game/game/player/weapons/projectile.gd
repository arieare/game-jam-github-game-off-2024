extends Node3D
@export var projectile : Node3D

var speed = 10 #NOTE Default speed
var damage = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var forward_direction = -self.global_transform.basis.z.normalized()
	self.global_translate(forward_direction * speed * delta)
	
	#TODO auto kill bullet after x seconds
	await get_tree().create_timer(3.0).timeout
	self.queue_free()
	pass
