@tool
extends Node3D


@export var line_radius = 0.1
@export var line_resoultion = 180
@onready var line_path : Path3D = $Path
@onready var line_mesh : CSGPolygon3D = $CSGPolygon
@onready var line_glow : OmniLight3D = $OmniLight3D

var is_show_line : bool = false

func _process(delta):
	if is_show_line:
		line_mesh.visible = true
		var circle = PackedVector2Array()
		for degree in line_resoultion:
			var x = line_radius * sin(PI * 2 * degree / line_resoultion)
			var y = line_radius * cos(PI * 2 * degree / line_resoultion)
			var coords = Vector2(x,y)
			circle.append(coords)
		$CSGPolygon.polygon = circle
	else:
		line_mesh.visible = false

func set_line(start:Vector3, end:Vector3, delta):
	line_path.curve.set_point_position(0, start)
	line_path.curve.set_point_out(0, Vector3.ZERO)
	line_path.curve.set_point_position(1, Vector3(1,1,1))
	line_path.curve.set_point_in(0, Vector3.ZERO)
	
	line_glow.position = lerp(line_glow.position, start, 0.5 * delta * 10)

func switch_show_line(is_show:bool):
	if is_show:
		is_show_line = true
	else:
		is_show_line = false
