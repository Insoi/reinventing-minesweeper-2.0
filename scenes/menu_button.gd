extends MenuButton

var presets = {
	"Small (8x8)": {id = 0, width = 8, height = 8},
	"Medium (16x16)": {id = 1, width = 16, height = 16},
	"Hard (24x24)": {id = 2, width = 24, height = 24},
}

func _ready() -> void:
	var popup = get_popup()
	
	for index in presets:
		var data = presets[index]
		popup.add_item(index, data.id)
	
	popup.add_item("Custom...", 10)
	
	popup.connect("index_pressed", self._on_item_pressed)


func _on_item_pressed(id : int) -> void:
	
	for index in presets:
		var data = presets[index]
		if data.id == id:
			Config.BOARD_WIDTH = data.width
			Config.BOARD_HEIGHT = data.height
			Board.generate_board()
			return
	
	if id == 10:
		_show_custom_dialog()

func _show_custom_dialog():
	pass
