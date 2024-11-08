extends Control

var loading_status: int
var progress: Array[float]
var target_scene = ""

@onready var progress_bar: ProgressBar = $progress

func _ready() -> void:
	ResourceLoader.load_threaded_request(target_scene)

func _process(_delta: float) -> void:
	loading_status = ResourceLoader.load_threaded_get_status(target_scene, progress)
	
	match loading_status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			progress_bar.value = progress[0] * 100 # Change the ProgressBar value
		ResourceLoader.THREAD_LOAD_LOADED:
			# When done loading, change to the target scene:
			get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(target_scene))
		ResourceLoader.THREAD_LOAD_FAILED:
			# Well some error happend:
			print("Error. Could not load Resource")		
