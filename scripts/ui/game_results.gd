class_name GameResults extends AcceptDialog

@onready var username: LineEdit = get_node("VBoxContainer/username")
@onready var results: Label = get_node("VBoxContainer/results")

func _ready() -> void:
	#var window_size: Vector2 = get_viewport().get_visible_rect().size
	#max_size = window_size * 0.9
	
	confirmed.connect(_on_confirmed)

func show_dialog() -> void:
	if not _check_if_highscore(): return
	reset_size()
	popup_centered()

func get_board_key(width: int, height: int, mines: int) -> String:
	return "%d_%d_%d" % [width, height, mines]


func _check_if_highscore() -> bool:
	return true

func _on_confirmed() -> void:
	var key: String = get_board_key(Config.BOARD_WIDTH, Config.BOARD_HEIGHT, Config.bombs_percentage)
	var boards: Dictionary = SaveLoad.board_scores
	var new_time: int = 0 #TODO: PLACEHOLDER time, get actual time differently
	Audio.play_sfx(Config.click_sfx)
	
	print("------------- SAVING NEW KEY: ", key, " --------------")
	
	if boards.has(key):
		print("Board already has KEY")
		if new_time < boards[key]["Time Score"]:
			print("Board key: ", key)
			print("Board has new highscore: ", new_time)
			print("PREVIOUS SCORE: ", boards[key]["Time Score"])
			boards[key]["Time Score"] = new_time
	else:
		boards[key] = {
			"Username": username.text,
			"Time Score": new_time,
			"Width": Config.BOARD_WIDTH,
			"Height": Config.BOARD_HEIGHT,
			"Bomb Percentage": Config.bombs_percentage,
		}
	
	SaveLoad._save()
	username.text = "" # clearing username input
	
	print(boards[key])
	print("------------- KEY SAVED: ", key, " --------------")


