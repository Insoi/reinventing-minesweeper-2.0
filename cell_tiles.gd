extends TileMapLayer

const board_height : int = 25
const board_width : int = 25
const cell_size : int = 16

const unexplored_cell = Vector2i(0,0)
const blank_cell = Vector2i(0,15)

var cell_array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_window().size = Vector2(board_width * cell_size, board_height * cell_size)
	generate_board()
	pass # Replace with function body.
#test
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
	
	print(cell_array)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
