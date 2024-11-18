extends Node3D

var iterator := 0
var point

var secret_string_array=["T","H","A","N","K","S"]
var pointer = 0

func spawn_point(score, location):
	if iterator > util.root.data_instance.instance_pool.point_label_array.size()-1:
		iterator = 0
	point = util.root.data_instance.instance_pool.point_label_array[iterator]
	iterator += 1
	point.hide()
	point.global_position = location
	point.text = "+" + str(score)
	
	## Add secret string here
	if pointer <= secret_string_array.size()-1:
		point.text = secret_string_array[pointer]
		pointer += 1
	
	point.show()
	point.tween_spawn()
	util.root.data_instance.score_added.emit(score)
	util.root.data_instance.audio.sfx_dictionary.point_spawned.sfx.play()

func hide_point():
	if point:
		point.hide()
