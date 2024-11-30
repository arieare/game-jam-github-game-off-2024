extends Node

## Board Instances
@export var white_tile: PackedScene
var white_tile_array = []
@export var black_tile: PackedScene
var black_tile_array = []
@export var glass_black_tile: PackedScene
var glass_black_tile_array = []
@export var glass_white_tile: PackedScene
var glass_white_tile_array = []
@export var goal_tile: PackedScene
var goal_tile_array = []
@export var block_tile: PackedScene
var block_tile_array = []
@export var overlay_tile: PackedScene
var overlay_tile_array = []
@export var overlay_goal_tile: PackedScene
var overlay_goal_tile_instance

var overlay_tile_node := Node.new()
var overlay_goal_tile_node := Node.new()

var chess_tile_node := Node.new()
var white_tile_node := Node.new()
var black_tile_node := Node.new()
var glass_black_tile_node := Node.new()
var glass_white_tile_node := Node.new()
var goal_tile_node := Node.new()
var block_tile_node := Node.new()

var board_tile_node := Node.new()
var temp_board_tile_node := Node.new()

## Point Label Instances
@export var point_label: PackedScene
var point_label_node := Node.new()
var point_label_instance
var point_label_array = []

## Patches
@export var patch_tile: PackedScene
var patch_tile_node := Node.new()
var patch_tile_instance
var patch_tile_array = []

## Props
@export var prop_sword: PackedScene
var prop_sword_intance
var prop_node := Node.new()


func _ready():
	self.get_parent().instance_pool = self #dependency injection
	overlay_tile_node.name = "overlay_tile_node"
	self.add_child(overlay_tile_node)	
	chess_tile_node.name = "chess_tile_node"
	self.add_child(chess_tile_node)	
	
	white_tile_node.name = "white_tile_node"
	chess_tile_node.add_child(white_tile_node)	
	black_tile_node.name = "black_tile_node"
	chess_tile_node.add_child(black_tile_node)
	glass_black_tile_node.name = "glass_black_tile_node"
	chess_tile_node.add_child(glass_black_tile_node)
	glass_white_tile_node.name = "glass_white_tile_node"
	chess_tile_node.add_child(glass_white_tile_node)	
	overlay_goal_tile_node.name = "overlay_goal_tile_node"
	chess_tile_node.add_child(overlay_goal_tile_node)	
	goal_tile_node.name = "goal_tile_node"
	chess_tile_node.add_child(goal_tile_node)	
	block_tile_node.name = "block_tile_node"
	chess_tile_node.add_child(block_tile_node)	
	
	board_tile_node.name = "board_tile_node"
	chess_tile_node.add_child(board_tile_node)	
	
	temp_board_tile_node.name = "temp_board_tile_node"
	chess_tile_node.add_child(temp_board_tile_node)	
	
	prop_node.name = "prop_node"
	self.add_child(prop_node)
	
	
	for i in 64:
		white_tile_array.append(white_tile.instantiate())
		white_tile_array[i].hide()
		white_tile_node.add_child(white_tile_array[i])
		white_tile_array[i].position = Vector3(99,99,99)
		
		black_tile_array.append(black_tile.instantiate())
		black_tile_array[i].hide()
		black_tile_node.add_child(black_tile_array[i])
		black_tile_array[i].position = Vector3(99,99,99)
		
		block_tile_array.append(block_tile.instantiate())
		block_tile_array[i].hide()
		block_tile_node.add_child(block_tile_array[i])
		block_tile_array[i].position = Vector3(99,99,99)
		
		goal_tile_array.append(goal_tile.instantiate())
		goal_tile_array[i].hide()
		goal_tile_node.add_child(goal_tile_array[i])
		goal_tile_array[i].position = Vector3(99,99,99)
		
		glass_black_tile_array.append(glass_black_tile.instantiate())
		glass_black_tile_array[i].hide()
		glass_black_tile_node.add_child(glass_black_tile_array[i])
		glass_black_tile_array[i].position = Vector3(99,99,99)	
		
		glass_white_tile_array.append(glass_white_tile.instantiate())
		glass_white_tile_array[i].hide()
		glass_white_tile_node.add_child(glass_white_tile_array[i])
		glass_white_tile_array[i].position = Vector3(99,99,99)	
		
		#overlay_tile_array.append(overlay_tile.instantiate())
		#overlay_tile_array[i].hide()
		#overlay_tile_node.add_child(overlay_tile_array[i])
		#overlay_tile_array[i].position = Vector3(999,999,999)
	
	overlay_goal_tile_instance = overlay_goal_tile.instantiate()
	overlay_goal_tile_instance.hide()
	overlay_goal_tile_node.add_child(overlay_goal_tile_instance)
	
	point_label_node.name = "point_label_node"
	self.add_child(point_label_node)	
	for i in 6:
		point_label_instance = point_label.instantiate()
		point_label_array.append(point_label_instance)
		point_label_node.add_child(point_label_array[i])	
	
	prop_sword_intance = prop_sword.instantiate()
	prop_sword_intance.hide()
	prop_node.add_child(prop_sword_intance)
