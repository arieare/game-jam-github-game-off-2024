extends StaticBody2D


@onready var collission = $collision
@onready var shape = $collision/shape

func _ready():
	shape.polygon = collission.polygon
	RenderingServer.set_default_clear_color(Color.html("#d1d1d1"))
