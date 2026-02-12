extends MenuButton

var presets = {
	"Easy (10x10)": {id = 0, width = 10, height = 10, bombs_per = 10}, # Bombs = 10% of the board
	"Medium (16x14)": {id = 1, width = 16, height = 14, bombs_per = 15},
	"Hard (24x24)": {id = 2, width = 28, height = 20, bombs_per = 20},
}

var custom_dialog_scene = preload("res://scenes/custom_size_dialog.tscn")
var custom_dialog = null

func _ready() -> void:
	var popup = get_popup()
	popup.add_theme_font_override("font", Config.Qaroxe)
	popup.add_theme_font_size_override("font_size", 8)
	
	for index in presets:
		var data = presets[index]
		popup.add_item(index, data.id)
	
	popup.add_item("Custom...", 3)
	popup.connect("index_pressed", self._on_item_pressed)
	
	custom_dialog = custom_dialog_scene.instantiate()
	custom_dialog.size_confirmed.connect(_on_custom_size_confirmed)
	add_child(custom_dialog)

func _create_new_board(width, height, bombs_per):
	Config.BOARD_WIDTH = width
	Config.BOARD_HEIGHT = height
	Config.bombs_percentage = bombs_per
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_item_pressed(id : int) -> void:
	for index in presets:
		var data = presets[index]
		if data.id == id:
			_create_new_board(data.width, data.height, data.bombs_per)
			return
			
	if id == 3:
		custom_dialog.show_dialog()

func _on_custom_size_confirmed(width : int, height : int, bombs_per : int):
	print("new custom board set size : ", width, " / ", height)
	_create_new_board(width, height, bombs_per)
