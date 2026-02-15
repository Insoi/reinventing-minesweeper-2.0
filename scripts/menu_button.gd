extends MenuButton

var custom_id: int = 4
var presets: Dictionary[StringName, Dictionary] = {
	&"Easy (10x10)": {"id": 0, "check": false, "width": 10, "height": 10, "bombs_per": 10},
	&"Medium (16x14)": {"id": 1, "check": false, "width": 16, "height": 14, "bombs_per": 15},
	&"Hard (24x24)": {"id": 2, "check": false, "width": 28, "height": 20, "bombs_per": 20},
	&"CRT Shader": {"id": 3, "check": true}
}

var custom_dialog_scene: PackedScene = preload("res://scenes/custom_size_dialog.tscn")
var custom_dialog: ConfirmationDialog = null

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
	popup.connect("index_pressed", self._on_item_pressed)
	
	custom_dialog = custom_dialog_scene.instantiate()
	@warning_ignore("unsafe_property_access")
	var signal_ref: Signal = custom_dialog.size_confirmed
	signal_ref.connect(_on_custom_size_confirmed)
	add_child(custom_dialog)

func _create_new_board(width: int, height: int, bombs_per: int) -> void:
	Config.BOARD_WIDTH = width
	Config.BOARD_HEIGHT = height
	Config.bombs_percentage = bombs_per
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_item_pressed(id: int) -> void:
	for index: StringName in presets:
		var data: Dictionary = presets[index]
		var data_id: int = data["id"]
		var check_val: bool = data["check"]
		
		if data_id == id and not check_val:
			var width: int = data["width"]
			var height: int = data["height"]
			var bombs_per: int = data["bombs_per"]
			_create_new_board(width, height, bombs_per)
			
			return
			
		elif data_id == id and check_val:
			var canvas_layer: CanvasLayer = get_node("../../CanvasLayer")
			canvas_layer.visible = not canvas_layer.visible
			return
			
	if id == custom_id:
		@warning_ignore("unsafe_method_access")
		custom_dialog.show_dialog()

func _on_custom_size_confirmed(width: int, height: int, bombs_per: int) -> void:
	print("new custom board set size : ", width, " / ", height)
	_create_new_board(width, height, bombs_per)
