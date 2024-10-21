extends Line2D

var point

func ready():
	pass

func _physics_process(_delta):
	global_position = Vector2(0,0)
	global_rotation = 0
	point = get_parent().global_position
	add_point(point)
	pass
	if points.size() > 4:
		remove_point(0)
