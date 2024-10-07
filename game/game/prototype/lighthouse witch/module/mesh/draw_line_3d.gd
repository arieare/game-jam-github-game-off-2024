extends Node3D


@export var line_radius = 0.1
@export var line_resoultion = 4
@onready var line_mesh : CSGPolygon3D = $CSGPolygon3D
@onready var line_path : Path3D = $Path3D


func _ready():
	pass
#	line_path.curve.add_point(Vector3.ZERO)
#	line_path.curve.add_point(Vector3.ZERO)	

func _process(delta):
	var circle = PackedVector2Array()
	for degree in line_resoultion:
		var x = line_radius * sin(PI * 2 * degree / line_resoultion)
		var y = line_radius * cos(PI * 2 * degree / line_resoultion)
		var coords = Vector2(x,y)
		circle.append(coords)
	line_mesh.polygon = circle

#func draw_line(start_vec:Vector3, end_vec:Vector3):
#	line_path.curve.set_point_position(0,start_vec)
#	line_path.curve.set_point_position(1,end_vec)
	
func add_line_point(new_end_vec:Vector3):
	line_path.curve.add_point(new_end_vec)

func set_line_point(index, new_end_vec:Vector3):
	line_path.curve.set_point_position(index, new_end_vec)

func remove_line():
	line_path.curve.clear_points()
