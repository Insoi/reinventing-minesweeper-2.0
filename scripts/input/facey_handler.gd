extends TileMapLayer

@onready var board: Board = get_tree().current_scene.get_node("board")

func _ready() -> void:
	board.game_lost.connect(_on_game_over)
	board.game_won.connect(_on_game_won)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event
		
		if mouse_event.button_index == MOUSE_BUTTON_LEFT:
			var mouse_pos: Vector2 = get_local_mouse_position()
			var tile_pos: Vector2i = local_to_map(mouse_pos)
			
			if event.is_released() and not board.board_revealed:
				set_cell(CellVectors.facey_pos, 0, CellVectors.facey_smile)
			
			if tile_pos == Vector2i(0,0):
				if event.is_pressed():
					on_click()
			else:
				if event.is_pressed() and not board.board_revealed:
					set_cell(CellVectors.facey_pos, 0, CellVectors.facey_surprised)


func on_click() -> void:
	set_cell(CellVectors.facey_pos, 0, CellVectors.facey_pressed)
	Audio.play_sfx(Config.click_sfx)
	
	board.generate_board()

func _on_game_over() -> void:
	set_cell(CellVectors.facey_pos, 0, CellVectors.facey_sad)

func _on_game_won() -> void:
	set_cell(CellVectors.facey_pos, 0, CellVectors.facey_sunglasses)

