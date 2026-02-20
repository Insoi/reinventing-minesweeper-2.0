extends InteractiveButton

@onready var board: Board = get_tree().current_scene.get_node("board")
@onready var input_handler: InputHandler = get_tree().current_scene.get_node("InputHandler")
@onready var counter: SegmentCounter = get_node("counter")

func _ready() -> void:
	board.generated.connect(
		func(cell_array: Array) -> void:
		counter.value = board.flags
	)
	
	input_handler.right_click.connect(_flag_cell)

func _flag_cell(tile_array_pos: Vector2i, flag_tile_pos: Vector2i) -> void:
	var tile_data_player: int = board.player_array[tile_array_pos.x][tile_array_pos.y]
	
	if tile_data_player == CellVectors.FLAGGED_CELL: # flagged a cell
		board.flags += 1
		
		board.player_array[tile_array_pos.x][tile_array_pos.y] = CellVectors.UNEXPLORED_CELL
		board.set_cell(Vector2(flag_tile_pos.x, flag_tile_pos.y), 0,
		Vector2((flag_tile_pos.x + (flag_tile_pos.y % 2)) % 2, CellVectors.UNEXPLORED_CELL))
		
	elif tile_data_player == 0: # unflagged a cell
		board.flags -= 1
	
		board.player_array[tile_array_pos.x][tile_array_pos.y] = CellVectors.FLAGGED_CELL
		board.set_cell(Vector2(flag_tile_pos.x, flag_tile_pos.y), 0,
		Vector2i((flag_tile_pos.x + (flag_tile_pos.y % 2)) % 2, CellVectors.FLAGGED_CELL))
	else:
		return
	
	counter.value = board.flags
	Audio.play_sfx(Config.place_sfx)
