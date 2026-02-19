class_name GameResults extends AcceptDialog

@onready var username: LineEdit = get_node("VBoxContainer/username")
@onready var results: Label = get_node("VBoxContainer/results")
@onready var board: Board = get_tree().current_scene.get_node("board")
@onready var time_counter: SegmentCounter = get_tree().current_scene.get_node("Interface/time_label/counter")

func _ready() -> void:
	confirmed.connect(_on_confirmed)

func show_dialog() -> void:
	if not _check_if_highscore(): return
	reset_size()
	popup_centered()

func _check_if_highscore() -> bool:
	var key: String = board.get_board_key(Config.BOARD_WIDTH, Config.BOARD_HEIGHT, Config.bombs_percentage)
	var boards: Dictionary = SaveLoad.board_scores
	var new_time: int = time_counter.value
	
	if not boards.has(key): return true
	if new_time < boards[key]["Time Score"]: return true
	return false

func _on_confirmed() -> void:
	var key: String = board.get_board_key(Config.BOARD_WIDTH, Config.BOARD_HEIGHT, Config.bombs_percentage)
	var boards: Dictionary = SaveLoad.board_scores
	var new_time: int = time_counter.value
	Audio.play_sfx(Config.click_sfx)
	
	print("------------- SAVING NEW KEY: ", key, " --------------")
	
	if boards.has(key):
		if new_time < boards[key]["Time Score"]:
			boards[key]["Time Score"] = new_time
			boards[key].Username = username.text
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


