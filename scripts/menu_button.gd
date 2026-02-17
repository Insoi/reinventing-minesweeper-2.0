extends MenuButton

var custom_id: int = 4
var presets: Dictionary[StringName, Dictionary] = {
	&"Easy (10x10)": {"id": 0, "check": false, "width": 10, "height": 10, "bombs_per": 10},
	&"Medium (16x14)": {"id": 1, "check": false, "width": 16, "height": 14, "bombs_per": 15},
	&"Hard (28x20)": {"id": 2, "check": false, "width": 28, "height": 20, "bombs_per": 20},
	&"Toggle Shaders": {"id": 3, "check": true}
}

var custom_dialog_scene: PackedScene = preload("res://scenes/custom_size_dialog.tscn")
var custom_dialog: CustomDialog = null

func _ready() -> void:
	var popup: PopupMenu = get_popup()
	popup.add_theme_font_override("font", Config.Qaroxe)
	popup.add_theme_font_size_override("font_size", 8)
	
	for index: StringName in presets:
		var data: Dictionary = presets[index]
		var id_val: int = data["id"]
		var check_val: bool = data["check"]
		
		if check_val:
			popup.add_check_item(index, id_val)
			continue
		
		popup.add_item(index, id_val)
	
	popup.add_item("Custom...", custom_id)
	popup.index_pressed.connect(self._on_item_pressed)
	popup.about_to_popup.connect(
	func() -> void: Audio.play_sfx(Config.click_sfx)
	)
	
	custom_dialog = custom_dialog_scene.instantiate()
	
	var signal_ref: Signal = custom_dialog.size_confirmed
	signal_ref.connect(_on_custom_size_confirmed)
	add_child(custom_dialog)

func _create_new_board(width: int, height: int, bombs_per: int) -> void:
	Config.BOARD_WIDTH = width
	Config.BOARD_HEIGHT = height
	Config.bombs_percentage = bombs_per
	
	var board: Board = get_tree().current_scene.get_node("board")
	board.generate_board()

func _on_item_pressed(id: int) -> void:
	var popup: PopupMenu = get_popup()
	Audio.play_sfx(Config.click_sfx)
	
	for index: StringName in presets:
		var data: Dictionary = presets[index]
		var data_id: int = data["id"]
		var item_index: int = popup.get_item_index(id)
		
		if data_id == id and not popup.is_item_checkable(item_index):
			var width: int = data["width"]
			var height: int = data["height"]
			var bombs_per: int = data["bombs_per"]
			_create_new_board(width, height, bombs_per)
			
			return
			
		elif data_id == id and popup.is_item_checkable(item_index):
			var is_checked: bool = popup.is_item_checked(item_index)
			popup.set_item_checked(item_index, not is_checked)
		
			var canvas_layer: CanvasLayer = get_node("../../CanvasLayer")
			var visibility: bool = not canvas_layer.visible
			canvas_layer.visible = visibility
			Config.shaders_toggled = visibility
			
			return
			
	if id == custom_id:
		custom_dialog.show_dialog()

func _on_custom_size_confirmed(width: int, height: int, bombs_per: int) -> void:
	print("new custom board set size : ", width, " / ", height)
	_create_new_board(width, height, bombs_per)
