extends Node2D

func _on_board_generated(cell_array: Array) -> void:
	var x_center: float = (Config.STARTING_POS.x + Config.BOARD_WIDTH / 2.0) * Config.CELL_SIZE
	position = Vector2(x_center, (Config.STARTING_POS.y - 0.8) * Config.CELL_SIZE)
	
	var board_pixel_width: int = Config.BOARD_WIDTH * Config.CELL_SIZE
	var available_width: float = get_viewport_rect().size.x - (0.8 * Config.CELL_SIZE * 2)
	
	var target_scale: float = (board_pixel_width * Config.INTERFACE_MARGIN) / available_width
	scale = Vector2(target_scale, target_scale)


func _on_board_flag_change(count: int) -> void:
	if count < 0: return
	var counter: SegmentCounter = get_node("flag_label/counter")
	counter.value = count
	
	Audio.play_sfx(Config.place_sfx)
