extends Node
class_name module_day_weather

'''
process the gametime, return the day time, and manipulate the sun according to the day time.
'''

@export_range(0,59) var second: int = 0
@export_range(0,59) var minute: int = 0
@export_range(0,24) var hour: int = 0 : set = _set_starting_hour
@export_range(0,59) var day: int = 0

@export var tick_per_second:int = 60.0
@export var wind_strength: float = 0.0
enum wind_dir {WIND_NORTH, WIND_SOUTH, WIND_WEST, WIND_EAST}

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


#extends Node3D


#@export var wind_strength: float = 0.2
@export var wind_direction: StringName = &"central"

enum time_of_day{DAWN, MORNING, NOON, DUSK, EVENING}
@export var time_now: time_of_day

@export var weather_array: PackedStringArray

@export var env_node: Node
@export var lighting_node: Node
@export var cloud_node: Decal
@export var rain_node: Node
@export var thunder_flash_node: Node

var day_time: float = 0.0

func _ready() -> void:
	time_now = time_of_day.DUSK
	weather_array.clear()
	weather_array.append("cloudy")
	weather_array.append("rainy")
	weather_array.append("thunderous")
	
	wind_strength = 0.5
	wind_direction = &"north"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	day_time += delta
	
	if weather_array.has("cloudy"):
		cloud_node.set_cloud_overcast(0.75)
		cloud_node.crawl_cloud(delta, wind_direction, wind_strength)
	elif !weather_array.has("cloudy"):
		cloud_node.set_cloud_overcast(0)
	if weather_array.has("rainy"):
		cloud_node.set_cloud_overcast(0.9)
		rain_node.set_rain_intensity(rain_node.drizzle.STORM, wind_direction, wind_strength)
		cloud_node.crawl_cloud(delta, wind_direction, wind_strength)
		env_node.set_bg_energy(0.5)
	elif !weather_array.has("rainy"):
		cloud_node.set_cloud_overcast(0)
		rain_node.set_rain_intensity(rain_node.drizzle.DRY, wind_direction, wind_strength)
		env_node.set_bg_energy(1.0)
	if weather_array.has("thunderous"):
		thunder_flash_node.add_trauma(0.2)
