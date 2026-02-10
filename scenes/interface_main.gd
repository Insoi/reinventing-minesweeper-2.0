extends Node2D

@warning_ignore("unused_parameter")
func _on_board_generated(cell_array: Array) -> void:
	position = Vector2i(Config.BOARD_WIDTH)
