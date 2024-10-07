extends NodePlus
class_name module_mouse_ray_cast

var mouse: Vector2
#@onready var viewport: Viewport = root.get_viewport()
var ray_query = PhysicsRayQueryParameters3D.new()
var ray_length = 100.0

#func init_viewport(node):

func cast(cam:Camera3D, viewport:Viewport):
	#viewport = node.get_tree().get_root().get_viewport()
	mouse = viewport.get_mouse_position()
	ray_query.from = cam.project_ray_origin(mouse)
	ray_query.to = ray_query.from + cam.project_ray_normal(mouse) * ray_length
	ray_query.collide_with_areas = false
	return cam.get_world_3d().direct_space_state.intersect_ray(ray_query)
	
