extends TileMapLayer

const board_height : int = 25
const board_width : int = 25
const cell_size : int = 16
const bombs : int = (board_height * board_width / 100) * 20 # as in 20% of the total cells on the board

const unexplored_cell = Vector2i(0,0)
const blank_cell = Vector2i(0,15)
const bomb_cell = Vector2i(0,5)

var cell_array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_window().size = Vector2(board_width * cell_size, board_height * cell_size)
	generate_board()
	pass # Replace with function body.

func generate_board() -> void:
	cell_array.clear()
	
	#build new 2D array
	for y in board_height:
		var row = []
		for x in board_width:
			row.append(0)
		cell_array.append(row)
	
	#set each cell to be unexplored
	for y in board_height:
		for x in board_width:
			cell_array[x][y] = unexplored_cell
			set_cell(Vector2(x,y), 0, unexplored_cell)
	#test
	#place down x amt bombs randomly
	for i in bombs:
		var random_pos = Vector2(randi_range(0, board_height-1), randi_range(0, board_width-1))
		var found_cell = cell_array[random_pos.x][random_pos.y]
		
		while found_cell == bomb_cell:
			random_pos = Vector2(randi_range(0, board_height-1), randi_range(0, board_width-1))
			found_cell = cell_array[random_pos.x][random_pos.y]
		
		cell_array[random_pos.x][random_pos.y] = bomb_cell
	
	#assign each cell with a number / empty
	for y in board_height:
		for x in board_width:
			if cell_array[x][y] == bomb_cell:
				continue
			
			var bombs: int = 0
			var nearby_cells: Array[Vector2] = get_nearby_cells(cell_array[x][y])
			print(nearby_cells)
			
			for nearby_cell in nearby_cells:
				print(nearby_cell)
			
			#draw all cells as unexplored in the start, basically just skip if it's a bomb_cell
			#TODO: Get nearby bombs +1int by going through each nearby cell and use that int var for the number
			#TODO: If there's no bombs then just make it a blank cell
			
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
		
		if check_pos.x >= 0 and check_pos.x < board_width and check_pos.y >= 0 and check_pos.y < board_height:
			nearby_cells.append(check_pos)
	
	return nearby_cells

func _input(event):
	if event is InputEventMouseButton:
		var mouse_pos = get_global_mouse_position()
		
		if event.pressed and event.button_index == MouseButton.MOUSE_BUTTON_LEFT: # open tile cell up / detect nearby cells with array
			var tile_pos = (mouse_pos / 16).floor()
			var tile_data = cell_array[tile_pos.x][tile_pos.y]
			print(1, tile_data)
			
			cell_array[tile_pos.x][tile_pos.y] = blank_cell
			set_cell(Vector2(tile_pos.x, tile_pos.y), 0, blank_cell)
			print(2, tile_data)
			
		
		if event.pressed and event.button_index == MouseButton.MOUSE_BUTTON_RIGHT: # add a flag / remove flag
			print("RIGHT:", event, get_global_mouse_position())
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
