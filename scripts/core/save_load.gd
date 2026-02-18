extends Node

const save_location: String = "user://data.json"

var board_scores: Dictionary[String, Dictionary] = {} # Username / Board data

func _ready() -> void:
	_load()

func _save() -> void:
	var file: FileAccess = FileAccess.open_encrypted_with_pass(save_location, FileAccess.WRITE, "928435hf4")
	file.store_var(board_scores.duplicate())
	file.close()
	
func _load() -> void:
	if FileAccess.file_exists(save_location):
		var file: FileAccess = FileAccess.open_encrypted_with_pass(save_location, FileAccess.READ, "928435hf4")
		var data: Dictionary = file.get_var()
		file.close()
		
		print("------------- LOADING DATA --------------")
		
		var save_data: Dictionary = data.duplicate()	
		for index: Variant in save_data:
			var index_data: Dictionary = save_data[index]
			board_scores[index] = index_data
			print(index_data)
		
		print("------------- DATA LOADED --------------")