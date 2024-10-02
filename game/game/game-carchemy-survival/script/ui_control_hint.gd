extends Control

var wasd_asset = preload("res://asset/accessibility_key_wasd.png")
var arrow_asset = preload("res://asset/accessibility_key_arrow.png")


var switch_counter: int = 0

func _process(_delta: float) -> void:
	
	
	if switch_counter == 0:
		self.get_child(0).texture = wasd_asset
		await get_tree().create_timer(0.5).timeout
		switch_counter = 1
	else:
		self.get_child(0).texture = arrow_asset
		await get_tree().create_timer(0.5).timeout
		switch_counter = 0
	
	
	if Input.is_action_just_pressed("move_down") or Input.is_action_just_pressed("move_up") or Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right"):
		await get_tree().create_timer(2.0).timeout
		self.get_child(0).modulate.a = 0
