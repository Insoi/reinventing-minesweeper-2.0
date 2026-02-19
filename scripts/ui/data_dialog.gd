class_name DataDialog extends Window

@onready var vb_container: VBoxContainer = get_node("ScrollContainer/MarginContainer/VBoxContainer")

var entry_scene: PackedScene = preload("res://scenes/leaderboard_entry.tscn")

func _ready() -> void:
	close_requested.connect(
	func() -> void:
		visible = false
		Audio.play_sfx(Config.click_sfx)
	)

func toggle_dialog() -> void:
	Audio.play_sfx(Config.click_sfx)
	
	if not visible:
		_load_leaderboard()
		popup_centered()
		return
	
	visible = false


func _load_leaderboard() -> void:
	for child: PanelContainer in vb_container.get_children():
		if child.name == "Info": continue
		child.queue_free()
	
	SaveLoad._load()
	var board_scores: Dictionary = SaveLoad.board_scores
	print(board_scores)
	
	if board_scores != {}:
		for index: String in board_scores:
			var index_data: Dictionary = board_scores[index]
			var entry: LeaderboardEntry = entry_scene.instantiate()
			vb_container.add_child(entry)
			entry.setup(index_data)
			
			print(index_data)
		
		print("Dictionary has data: ", board_scores)
	else:
		print("Dictionary has no data: ", board_scores)
