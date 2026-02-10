extends Node2D

@warning_ignore("unused_parameter")
func _on_board_generated(cell_array: Array) -> void:
	var x_center = (Config.STARTING_POS.x + Config.BOARD_WIDTH / 2.0) * Config.CELL_SIZE
	position = Vector2(x_center, (Config.STARTING_POS.y - 0.8) * Config.CELL_SIZE)
	
	var board_pixel_width = Config.BOARD_WIDTH * Config.CELL_SIZE
	var available_width = get_viewport_rect().size.x - (0.8 * Config.CELL_SIZE * 2)
	
	var target_scale = (board_pixel_width * Config.INTERFACE_MARGIN) / available_width
	scale = Vector2(target_scale, target_scale)
