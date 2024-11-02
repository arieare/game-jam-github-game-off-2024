class_name util_save_load

var save_path = "user://game.save"

func save(path, dict):
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_var(dict)
	file.close()

func load_data(path) -> Dictionary:
	var load_dictionary: Dictionary = {}
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		load_dictionary = file.get_var()
		file.close()
	return load_dictionary
