extends TileMapLayer

signal generated(cell_array : Array)

var flags = config.BOMBS
var cell_array = []
var player_array = []

func _ready() -> void:
	var x_size = (config.STARTING_POS.x * 2 + config.BOARD_WIDTH) * config.CELL_SIZE
	var y_size = (config.STARTING_POS.y * 2 + config.BOARD_HEIGHT) * config.CELL_SIZE
	print(config.BOMBS)
	
	get_window().size = Vector2(x_size, y_size) * 2 # 2 since pixels are double
	generate_board()

@warning_ignore("unused_parameter")
func game_over(cleared_board: bool) -> void:
	pass
	#TODO: show ui for playing again and stats. Leave stats empty if game_over was initiated by dying
	#TODO: store the current time locally if initiated by winning
	#TODO: button to generate a new board / play again

func generate_board() -> void:
	cell_array.clear()
	
	#build new 2D array
	for x in config.BOARD_WIDTH:
		var row = []
		for y in config.BOARD_HEIGHT:
			row.append(0)
		cell_array.append(row)
	
	print(cell_array)
	
	#set each cell to be unexplored
	for y in config.BOARD_HEIGHT:
		for x in config.BOARD_WIDTH:
			cell_array[x][y] = config.UNEXPLORED_CELL
			set_cell(Vector2(x + config.STARTING_POS.x, y + config.STARTING_POS.y), 0, Vector2i(0, config.UNEXPLORED_CELL))
	
	player_array = cell_array.duplicate(true)
	
	# place down x amt bombs randomly
	for i in config.BOMBS:
		var random_pos = Vector2i(randi_range(0, config.BOARD_HEIGHT-1), randi_range(0, config.BOARD_WIDTH-1))
		var found_cell = cell_array[random_pos.y][random_pos.x]
		
		while found_cell == config.BOMB_CELL:
			random_pos = Vector2i(randi_range(0, config.BOARD_HEIGHT-1), randi_range(0, config.BOARD_WIDTH-1))
			found_cell = cell_array[random_pos.y][random_pos.x]
		
		cell_array[random_pos.y][random_pos.x] = config.BOMB_CELL
	
	# assign each cell with a number / empty
	for y in config.BOARD_HEIGHT:
		for x in config.BOARD_WIDTH:
			if cell_array[x][y] == config.BOMB_CELL: continue
			
			var bombs_found : int = 0
			var nearby_cells = get_nearby_cells(Vector2i(x,y))
			
			for nearby_cell in nearby_cells:
				if nearby_cell == config.BOMB_CELL:
					bombs_found += 1
			
			if bombs_found > 0:
				cell_array[x][y] = config.NUMBERS[bombs_found-1]
			else:
				cell_array[x][y] = config.BLANK_CELL
			
	generated.emit(cell_array)
	

func get_nearby_cells(tile_cell: Vector2) -> Array:
	var nearby_cells = []
	
	#getting all directions surrounding the cells including corners
	var directions = [
		Vector2(-1,-1), Vector2(0,-1), Vector2(1,-1), #top left, top, top right
		Vector2(-1,0), Vector2(1,0), #left and right
		Vector2(-1,1), Vector2(0,1), Vector2(1,1) #bottom left, bottom and bottom right
	]
	
	#check all directions and append to array if direction is in the board bounds
	for direction in directions:
		var check_pos = tile_cell + direction
		
		if check_pos.x >= 0 and check_pos.x < config.BOARD_WIDTH and check_pos.y >= 0 and check_pos.y < config.BOARD_HEIGHT:
			nearby_cells.append(cell_array[check_pos.x][check_pos.y])
	
	return nearby_cells

func _input(event):
	if event is InputEventMouseButton:
		var mouse_pos = get_global_mouse_position()
		
		if event.pressed:
			var tile_pos = Vector2i((mouse_pos / config.CELL_SIZE).floor())
			var tile_array_pos = Vector2i((mouse_pos / config.CELL_SIZE).floor()) - config.STARTING_POS
			print(tile_pos, tile_array_pos)
			
			if tile_array_pos.x < 0 or tile_array_pos.y < 0 or tile_array_pos.x >= config.BOARD_WIDTH or tile_array_pos.y >= config.BOARD_HEIGHT: 
				print("not inside board bounds")
				return
			
			var tile_data = cell_array[tile_array_pos.x][tile_array_pos.y]
			var tile_data_player = player_array[tile_array_pos.x][tile_array_pos.y]
			
			if event.button_index == MouseButton.MOUSE_BUTTON_LEFT: # open tile cell up / detect nearby cells with array
				print("REVEALED: ", tile_data)
				
				set_cell(Vector2(tile_pos.x, tile_pos.y), 0, Vector2i((tile_pos.x + (tile_pos.y % 2)) % 2, tile_data))
				player_array[tile_array_pos.x][tile_array_pos.y] = tile_data
				
			if event.button_index == MouseButton.MOUSE_BUTTON_RIGHT: # place down flag / remove flag
				print("FLAGGED CELL: ", tile_data)
				
				if tile_data_player == config.FLAGGED_CELL:
					flags += 1
					
					player_array[tile_array_pos.x][tile_array_pos.y] = config.UNEXPLORED_CELL
					set_cell(Vector2(tile_pos.x, tile_pos.y), 0, Vector2((tile_pos.x + (tile_pos.y % 2)) % 2, config.UNEXPLORED_CELL))
					
					return
					
				flags -= 1
				
				if tile_data_player == 0:
					player_array[tile_array_pos.x][tile_array_pos.y] = config.FLAGGED_CELL
					set_cell(Vector2(tile_pos.x, tile_pos.y), 0, Vector2i((tile_pos.x + (tile_pos.y % 2)) % 2, config.FLAGGED_CELL))

func _on_timer_timeout():
	print("wait")
