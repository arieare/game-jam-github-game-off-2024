extends Node
class_name day_time_module

'''
process the gametime, return the day time, and manipulate the sun according to the day time.
'''

@export_range(0,59) var second: int = 0
@export_range(0,59) var minute: int = 0
@export_range(0,24) var hour: int = 0 : set = _set_starting_hour
@export_range(0,59) var day: int = 0

@export var tick_per_second:int = 60.0

var delta_time: float = 0.0
var hour_float:float = 0.0

func _set_starting_hour(starting_hour: int) -> void:
	hour = starting_hour
	hour_float = hour

func run_game_time(delta_sec: float) -> void:
	delta_time += (delta_sec * tick_per_second)
	if delta_time < 1: return
	var delta_int_sec: int = delta_time
	delta_time -= delta_int_sec
	
	second += delta_int_sec
	minute += second/60 
	hour += minute/60
	day += hour/24
	
	hour_float += (delta_sec * tick_per_second/60)/60
	
	second = second % 60
	minute = minute % 60
	hour = hour % 24

func day_night_cycle(light):
	var map_time = remap(hour_float,0.0,24.0,0.0,1.0)
	light.rotation_degrees.x = (map_time * 360.0) + 90.0

func get_current_game_time() -> Dictionary:
	var game_time_dictionary ={
		"second" = second,
		"minute" = minute,
		"hour" = hour,
		"day" = day
	}
	return game_time_dictionary
