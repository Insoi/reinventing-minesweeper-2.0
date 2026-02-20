class_name DifficultyButton extends InteractiveButton

var custom_id: int = 4
var presets: Dictionary[StringName, Dictionary] = {
	&"Easy (10x10)": {"id": 0, "check": false, "width": 10, "height": 10, "bombs_per": 10},
	&"Medium (16x14)": {"id": 1, "check": false, "width": 16, "height": 14, "bombs_per": 15},
	&"Hard (28x20)": {"id": 2, "check": false, "width": 28, "height": 20, "bombs_per": 20},
	&"Toggle Shaders": {"id": 3, "check": true}
}

var custom_dialog_scene: PackedScene = preload("res://scenes/custom_size_dialog.tscn")
var custom_dialog: CustomDialog = null
var popup_menu: PopupMenu

func _ready() -> void:
	super._ready()
	
	popup_menu = PopupMenu.new()
	popup_menu.add_theme_font_override("font", Config.Qaroxe)
	popup_menu.add_theme_font_size_override("font_size", 8)
	add_child(popup_menu)
	
	for index: StringName in presets:
		var data: Dictionary = presets[index]
		var id_val: int = data["id"]
		var check_val: bool = data["check"]
		
		if check_val:
			popup_menu.add_check_item(index, id_val)
			continue
		
		popup_menu.add_item(index, id_val)
	
	popup_menu.add_item("Custom...", custom_id)
	popup_menu.index_pressed.connect(_on_item_pressed)
	
	custom_dialog = custom_dialog_scene.instantiate()
	custom_dialog.size_confirmed.connect(_on_custom_size_confirmed)
	add_child(custom_dialog)
	
	on_click.connect(_show_popup)

func _show_popup() -> void:
	var tile_local_pos: Vector2 = map_to_local(tile_pos)
	var tile_size: Vector2 = Vector2(tile_set.tile_size)
	
	var screen_pos: Vector2 = get_viewport().get_canvas_transform() * to_global(tile_local_pos)
	screen_pos.y += tile_size.y / 2.0 
	
	popup_menu.popup(Rect2i(screen_pos, Vector2i.ZERO))

func _create_new_board(width: int, height: int, bombs_per: int) -> void:
	Config.BOARD_WIDTH = width
	Config.BOARD_HEIGHT = height
	Config.bombs_percentage = bombs_per
	
	var board: Board = get_tree().current_scene.get_node("board")
	board.generate_board()

func _on_item_pressed(id: int) -> void:
	Audio.play_sfx(Config.click_sfx)
	
	for index: StringName in presets:
		var data: Dictionary = presets[index]
		var data_id: int = data["id"]
		var item_index: int = popup_menu.get_item_index(id)
		
		if data_id == id and not popup_menu.is_item_checkable(item_index):
			_create_new_board(data["width"], data["height"], data["bombs_per"])
			return
		
		elif data_id == id and popup_menu.is_item_checkable(item_index):
			var is_checked: bool = popup_menu.is_item_checked(item_index)
			popup_menu.set_item_checked(item_index, not is_checked)
			
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