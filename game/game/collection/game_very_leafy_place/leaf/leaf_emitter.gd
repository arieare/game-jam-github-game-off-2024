extends Node2D

var leaf_scene = preload("res://content/collection/game_very_leafy_place/leaf.tscn")

var leaf_size: int = 10
var leaf_counter: int = leaf_size

var parent

func _ready() -> void:
	parent = self.get_parent()
	for i in leaf_size:
		var leaf = leaf_scene.instantiate()
		leaf.position = Vector2(randi_range(10,1590), randi_range(0,0))
		self.add_child(leaf)

func _process(delta: float) -> void:
	if leaf_counter <= 1000:
		#await get_tree().create_timer(1).timeout
		for i in leaf_size:
			var leaf = leaf_scene.instantiate()
			#if i % 2 == 0:
				#leaf.position = Vector2(randf_range(10,600), 0)
			#else:
				#leaf.position = Vector2(randf_range(900,1590), 0)
			leaf.position = Vector2(randf_range(10,1590), 0)
			self.add_child(leaf)		
		leaf_counter += leaf_size
