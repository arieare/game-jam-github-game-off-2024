extends Node2D

@onready var root_node = get_tree().get_root().get_child(0)
@onready var game_over_remark_label_node = $SubViewportContainer/SubViewport/CanvasLayer/ui_title/remarks
@onready var game_over_score_label_node = $SubViewportContainer/SubViewport/CanvasLayer/ui_title/VBoxContainer/elapsed_time
var remark_array_suck : PackedStringArray = ["lol", "meh", "seriously?", "not impressed", "is that it?", "yawn", "pathetic", "try harder"]
var remark_array_ok : PackedStringArray = ["not bad", "eh,", "decent", "okay", "could be worse", "barely acceptable", "I've seen worse", "mediocre"]
var remark_array_good : PackedStringArray = ["are you god?", "w.t.f", "impressive", "well done", "bravo", "about time", "finally", "you got lucky", "don't get cocky"]

func _ready() -> void:
	var final_score = snapped(root_node.game_score, 0.001)
	if final_score < 20.0:
		game_over_remark_label_node.text = remark_array_suck[randi_range(0,remark_array_suck.size()-1)]
	elif final_score <= 50.0:
		game_over_remark_label_node.text = remark_array_ok[randi_range(0,remark_array_ok.size()-1)]
	elif final_score > 50.0:
		game_over_remark_label_node.text = remark_array_good[randi_range(0,remark_array_good.size()-1)]
	
	game_over_score_label_node.text = str(snapped(root_node.game_score, 0.001)) + " seconds"
