extends TileMapLayer

var flags = config.bombs
var cell_array = []
var player_array = []

func _ready() -> void:
	var x_size = (config.starting_pos.x * 2 + config.board_width) * config.cell_size
	var y_size = (config.starting_pos.y * 2 + config.board_height) * config.cell_size
	
	get_window().size = Vector2(x_size, y_size) * 2 # 2 since pixels are double
	generate_board()

func game_over(cleared_board: bool) -> void:
	pass
	#TODO: show ui for playing again and stats. Leave stats empty if game_over was initiated by dying
	#TODO: store the current time locally if initiated by winning
	#TODO: button to generate a new board / play again

func generate_board() -> void:
	cell_array.clear()
	
	#build new 2D array
	for y in config.board_height:
		var row = []
		for x in config.board_width:
			row.append(0)
		cell_array.append(row)
	
	#set each cell to be unexplored
	for y in config.board_height:
		for x in config.board_width:
			cell_array[x][y] = config.unexplored_cell
			set_cell(Vector2(x + config.starting_pos.x, y + config.starting_pos.y), 0, Vector2i(0, config.unexplored_cell))
	
	player_array = cell_array.duplicate(true)
	
	# place down x amt bombs randomly
	for i in config.bombs:
		var random_pos = Vector2(randi_range(0, config.board_height-1), randi_range(0, config.board_width-1))
		var found_cell = cell_array[random_pos.x][random_pos.y]
		
		while found_cell == config.bomb_cell:
			random_pos = Vector2(randi_range(0, config.board_height-1), randi_range(0, config.board_width-1))
			found_cell = cell_array[random_pos.x][random_pos.y]
		
		cell_array[random_pos.x][random_pos.y] = config.bomb_cell
	
	# assign each cell with a number / empty
	for y in config.board_height:
		for x in config.board_width:
			if cell_array[x][y] == config.bomb_cell: continue
			
			var bombs_found : int = 0
			var nearby_cells = get_nearby_cells(Vector2i(x,y))
			
			for nearby_cell in nearby_cells:
				if nearby_cell == config.bomb_cell:
					bombs_found += 1
			
			if bombs_found > 0:
				cell_array[x][y] = config.numbers[bombs_found-1]
			else:
				cell_array[x][y] = config.blank_cell
			
	print(cell_array)

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
		
		if check_pos.x >= 0 and check_pos.x < config.board_width and check_pos.y >= 0 and check_pos.y < config.board_height:
			nearby_cells.append(cell_array[check_pos.x][check_pos.y])
	
	print(nearby_cells)
	return nearby_cells

func _input(event):
	if event is InputEventMouseButton:
		var mouse_pos = get_global_mouse_position()
		
		if event.pressed:
			var tile_pos = Vector2i((mouse_pos / config.cell_size).floor())
			var tile_array_pos = Vector2i((mouse_pos / config.cell_size).floor()) - config.starting_pos
			print(tile_pos, tile_array_pos)
			
			if tile_array_pos.x < 0 or tile_array_pos.y < 0 or tile_array_pos.x >= config.board_width or tile_array_pos.y >= config.board_height: 
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
				
				if tile_data_player == config.flagged_cell:
					flags += 1
					
					player_array[tile_array_pos.x][tile_array_pos.y] = config.unexplored_cell
					set_cell(Vector2(tile_pos.x, tile_pos.y), 0, Vector2((tile_pos.x + (tile_pos.y % 2)) % 2, config.unexplored_cell))
					
					return
					
				flags -= 1
				
				if tile_data_player == 0:
					player_array[tile_array_pos.x][tile_array_pos.y] = config.flagged_cell
					set_cell(Vector2(tile_pos.x, tile_pos.y), 0, Vector2i((tile_pos.x + (tile_pos.y % 2)) % 2, config.flagged_cell))

func _on_timer_timeout():
	print("wait")
