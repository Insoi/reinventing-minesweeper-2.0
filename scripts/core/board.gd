extends TileMapLayer
class_name board

signal generated(cell_array : Array)
signal flag_change(count : int)
#signal cell_revealed(position: Vector2i, cell_value: int)
#signal game_won
#signal game_lost

@export var flags : int = Config.BOMBS:
	set(value):
		flags = value
		flag_change.emit(value)

var cell_array = []
var player_array = []

var board_revealed = false

func _ready() -> void:
	var x_size = (Config.STARTING_POS.x * 2 + Config.BOARD_WIDTH) * Config.CELL_SIZE
	var y_size = (Config.STARTING_POS.y * 2 + (Config.BOARD_HEIGHT - Config.BOTTOM_MARGIN)) * Config.CELL_SIZE
	print(Config.BOMBS)
	
	get_window().size = Vector2(x_size, y_size) * 2 # 2 since pixels are double
	generate_board()

func game_over(lost : bool) -> void:
	generate_board()
	
	if not lost:
		print("GAME OVER: (! REASON: CLEARED BOARD) / ", lost)
	else:
		print("GAME OVER: (! REASON: LOST) / ", lost)
	
	#TODO: Show whole board, can easily do with _toggle_reveal_board()
	#TODO: show ui for playing again and stats. Leave stats empty if game_over was initiated by dying
	#TODO: store the current time locally if initiated by winning
	#TODO: button to generate a new board / play again - DO NOT let this ui overlay on the board itself

func generate_board() -> void:
	cell_array.clear()
	board_revealed = false
	flags = Config.BOMBS
	
	#build new 2D array
	for x in Config.BOARD_WIDTH:
		var row = []
		for y in Config.BOARD_HEIGHT:
			row.append(0)
		cell_array.append(row)
	
	print(cell_array)
	
	#set each cell to be unexplored
	for y in Config.BOARD_HEIGHT:
		for x in Config.BOARD_WIDTH:
			cell_array[x][y] = CellVectors.UNEXPLORED_CELL
			set_cell(Vector2(x + Config.STARTING_POS.x, y + Config.STARTING_POS.y), 0, Vector2i(0, CellVectors.UNEXPLORED_CELL))
	
	player_array = cell_array.duplicate(true)
	
	# place down x amt bombs randomly
	for i in Config.BOMBS:
		var random_pos = Vector2i(randi_range(0, Config.BOARD_HEIGHT-1), randi_range(0, Config.BOARD_WIDTH-1))
		var found_cell = cell_array[random_pos.y][random_pos.x]
		
		while found_cell == CellVectors.BOMB_CELL:
			random_pos = Vector2i(randi_range(0, Config.BOARD_HEIGHT-1), randi_range(0, Config.BOARD_WIDTH-1))
			found_cell = cell_array[random_pos.y][random_pos.x]
		
		cell_array[random_pos.y][random_pos.x] = CellVectors.BOMB_CELL
	
	# assign each cell with a number / empty
	for y in Config.BOARD_HEIGHT:
		for x in Config.BOARD_WIDTH:
			if cell_array[x][y] == CellVectors.BOMB_CELL: continue
			
			var bombs_found : int = 0
			var nearby_cells = get_nearby_cells(Vector2i(x,y))
			
			for nearby_cell in nearby_cells:
				if nearby_cell == CellVectors.BOMB_CELL:
					bombs_found += 1
			
			if bombs_found > 0:
				cell_array[x][y] = CellVectors.NUMBERS[bombs_found-1]
			else:
				cell_array[x][y] = CellVectors.BLANK_CELL
	
	print(cell_array)
	generated.emit(cell_array)

func get_nearby_cells(tile_cell : Vector2i, return_pos : bool = false) -> Array:
	var nearby_cells = []
	
	# getting all directions surrounding the cells including corners
	var directions = [
		Vector2i(-1,-1), Vector2i(0,-1), Vector2i(1,-1), # top left, top, top right
		Vector2i(-1,0), Vector2i(1,0), # left and right
		Vector2i(-1,1), Vector2i(0,1), Vector2i(1,1) #bottom left, bottom and bottom right
	] 
	
	# check all directions and append to array if direction is in the board bounds
	for direction in directions:
		var check_pos = tile_cell + direction
		
		if check_pos.x >= 0 and check_pos.x < Config.BOARD_WIDTH and check_pos.y >= 0 and check_pos.y < Config.BOARD_HEIGHT:
			if return_pos:
				nearby_cells.append(check_pos)
			else:
				nearby_cells.append(cell_array[check_pos.x][check_pos.y])
	
	return nearby_cells

func _toggle_reveal_board() -> void:
	board_revealed = !board_revealed
	
	if board_revealed: # revealing cells by using the cell_array data, which has the board generation
		for y in Config.BOARD_HEIGHT:
			for x in Config.BOARD_WIDTH:
				var tile_pos = Vector2i(x + Config.STARTING_POS.x, y + Config.STARTING_POS.y)
				var cell_data = cell_array[x][y]
				set_cell(Vector2(tile_pos.x, tile_pos.y), 0,
				Vector2i((tile_pos.x + (tile_pos.y % 2)) % 2, cell_data))
	else: # restoring cells by using the player_array aka what the player sees
		for y in Config.BOARD_HEIGHT:
			for x in Config.BOARD_WIDTH:
				var tile_pos = Vector2i(x + Config.STARTING_POS.x, y + Config.STARTING_POS.y)
				var player_cell_data = player_array[x][y]
				set_cell(Vector2(tile_pos.x, tile_pos.y), 0,
				Vector2i((tile_pos.x + (tile_pos.y % 2)) % 2, player_cell_data))

func _reveal_cell(tile_array_pos : Vector2i, tile_pos : Vector2i) -> void:
	var tile_data = cell_array[tile_array_pos.x][tile_array_pos.y]
	var tile_data_player = player_array[tile_array_pos.x][tile_array_pos.y]
	
	if tile_data_player != CellVectors.UNEXPLORED_CELL: return
	if tile_data == CellVectors.BOMB_CELL:
		#TODO: create a flashing effect of the bomb exploding / alternating between explosion and bomb tile cell
		set_cell(Vector2(tile_pos.x, tile_pos.y), 0,
		Vector2i((tile_pos.x + (tile_pos.y % 2)) % 2, tile_data))
		player_array[tile_array_pos.x][tile_array_pos.y] = tile_data
		
		game_over(true)
		return
		
	print("REVEALED: ", tile_data)
		
	if tile_data == CellVectors.BLANK_CELL:
		var cells_to_reveal : Array = _flood_fill(tile_array_pos)
		
		for cell_pos in cells_to_reveal:
			var reveal_tile_pos = cell_pos + Config.STARTING_POS
			var cell_data = cell_array[cell_pos.x][cell_pos.y]
			
			set_cell(Vector2(reveal_tile_pos.x, reveal_tile_pos.y), 0,
			Vector2i((reveal_tile_pos.x + (reveal_tile_pos.y % 2)) % 2, cell_data))
			player_array[cell_pos.x][cell_pos.y] = cell_data
		return
	
	set_cell(Vector2(tile_pos.x, tile_pos.y), 0,
	Vector2i((tile_pos.x + (tile_pos.y % 2)) % 2, tile_data))
	player_array[tile_array_pos.x][tile_array_pos.y] = tile_data
	
	_check_win_condition()

func _flag_cell(tile_array_pos : Vector2i, tile_pos : Vector2i) -> void:
	var tile_data_player = player_array[tile_array_pos.x][tile_array_pos.y]
	
	if tile_data_player == CellVectors.FLAGGED_CELL:
		flags += 1
		
		player_array[tile_array_pos.x][tile_array_pos.y] = CellVectors.UNEXPLORED_CELL
		set_cell(Vector2(tile_pos.x, tile_pos.y), 0,
		Vector2((tile_pos.x + (tile_pos.y % 2)) % 2, CellVectors.UNEXPLORED_CELL))
		
		return
		
	flags -= 1
	
	if tile_data_player == 0:
		player_array[tile_array_pos.x][tile_array_pos.y] = CellVectors.FLAGGED_CELL
		set_cell(Vector2(tile_pos.x, tile_pos.y), 0,
		Vector2i((tile_pos.x + (tile_pos.y % 2)) % 2, CellVectors.FLAGGED_CELL))

func _flood_fill(tile_pos : Vector2i) -> Array:
	var checked = []
	var queue = [tile_pos]
	var cells_to_reveal = []
	
	while queue.size() > 0:
		var current = queue.pop_front()
		if current in checked: continue
		
		checked.append(current)
		
		# skip if the cell is out of bounds
		if current.x < 0 and current.x >= Config.BOARD_WIDTH and current.y < 0 and current.y >= Config.BOARD_HEIGHT: continue
		if player_array[current.x][current.y] != CellVectors.UNEXPLORED_CELL: continue # skip if already revealed in player_array
		
		var cell_value = cell_array[current.x][current.y]
		if cell_value == CellVectors.BOMB_CELL: continue # skip if it's a bomb cell
		cells_to_reveal.append(current)
		
		if cell_value == CellVectors.BLANK_CELL:
			var nearby_positions = get_nearby_cells(current, true)
			
			for nearby_pos in nearby_positions:
				if nearby_pos not in checked:
					queue.append(nearby_pos)
	
	return cells_to_reveal

func _check_win_condition() -> void:
	var total_cells = Config.BOARD_WIDTH * Config.BOARD_HEIGHT
	var cells_to_reveal = total_cells - Config.BOMBS
	var revealed_count = 0
	
	for y in Config.BOARD_HEIGHT:
		for x in Config.BOARD_WIDTH:
			if player_array[x][y] != CellVectors.UNEXPLORED_CELL and player_array[x][y] != CellVectors.FLAGGED_CELL:
				revealed_count += 1
	
	if revealed_count == cells_to_reveal:
		game_over(false)
