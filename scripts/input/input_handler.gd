extends Node
#class_name InputHandler # // later on useful

signal left_click(tile_array_pos : Vector2i, tile_pos : Vector2i)
signal right_click(tile_array_pos : Vector2i, tile_pos : Vector2i)
signal debug_reveal_toggle

func _input(event : InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		var mouse_pos = get_viewport().get_mouse_position()
		
		var tile_pos = Vector2i((mouse_pos / Config.CELL_SIZE).floor())
		var tile_array_pos = Vector2i((mouse_pos / Config.CELL_SIZE).floor()) - Config.STARTING_POS
		
		if tile_array_pos.x < 0 or tile_array_pos.y < 0 or tile_array_pos.x >= Config.BOARD_WIDTH or tile_array_pos.y >= Config.BOARD_HEIGHT: 
			print("not inside board bounds")
			return
		
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT: # open tile cell up / detect nearby cells with array
			left_click.emit(tile_array_pos, tile_pos)
			
		if event.button_index == MouseButton.MOUSE_BUTTON_RIGHT: # place down flag / remove flag
			right_click.emit(tile_array_pos, tile_pos)
	
	if event.is_action_pressed("reveal_board_toggle") and Config.DEBUG_BOARD:
		debug_reveal_toggle.emit()
