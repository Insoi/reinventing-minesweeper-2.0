extends Node2D

const BACKGROUND_CELL = Vector2i(1,7)
const STRAIGHT_TRANSITION_CELL = Vector2i(0,1)
const CURVED_TRANSITION_CELL = Vector2i(0,0)

const BOARD_L_TOP_CORNER_CELL = Vector2i(0,2)
const BOARD_TOP_CELL = Vector2i(1,2)
const BOARD_R_TOP_CORNER_CELL = Vector2i(2,2)
const BOARD_R_CELL = Vector2i(2,3)
const BOARD_R_BOTTOM_CORNER_CELL = Vector2i(2,4)
const BOARD_BOTTOM_START_CELL = Vector2i(1,4)
const BOARD_BOTTOM_CELL = Vector2i(1,5)
const BOARD_L_BOTTOM_CORNER_CELL = Vector2i(0,4)
const BOARD_L_CELL = Vector2i(0,3)

@onready var background_top = get_node("background_top")
@onready var background_bottom = get_node("background_bottom")

func _on_board_generated(cell_array: Array) -> void:
	# top border (right corner, top cells, left corner)
	for x in config.BOARD_WIDTH + 2:
		var cell_coordinates : Vector2i = BOARD_TOP_CELL
		var cell_pos : Vector2 = Vector2(x + (config.STARTING_POS.x - 1), config.STARTING_POS.y - 1)
		
		if x == 0: # top left corner
			cell_coordinates = BOARD_L_TOP_CORNER_CELL
		elif x == config.BOARD_WIDTH + 1: # top right corner
			cell_coordinates = BOARD_R_TOP_CORNER_CELL
		
		background_top.set_cell(cell_pos, 2, cell_coordinates)
	
	# bottom border (right corner, bottom cells, left corner)
	for x in config.BOARD_WIDTH + 2:
		var cell_coordinates : Vector2i = BOARD_BOTTOM_CELL
		var cell_pos : Vector2 = Vector2(
			x + (config.STARTING_POS.x - 1),
			config.STARTING_POS.y + config.BOARD_HEIGHT)
		
		if x == 0: # bottom left corner
			cell_coordinates = BOARD_L_BOTTOM_CORNER_CELL
		elif x == 1: # bottom start cell (right next to the left bottom corner)
			cell_coordinates = BOARD_BOTTOM_START_CELL
		
		background_top.set_cell(cell_pos, 2, cell_coordinates)
	
	for y in config.BOARD_HEIGHT:
		var left_cell_pos = Vector2(config.STARTING_POS.x - 1, y + config.STARTING_POS.y)
		background_top.set_cell(left_cell_pos, 2, BOARD_L_CELL)
		
		var right_cell_pos = Vector2(config.STARTING_POS.x + config.BOARD_WIDTH, y + config.STARTING_POS.y)
		background_top.set_cell(right_cell_pos, 2, BOARD_R_CELL)
		
		background_top.set_cell(
			Vector2(config.STARTING_POS.x + config.BOARD_WIDTH, config.STARTING_POS.y + config.BOARD_HEIGHT),
			2,
			BOARD_R_BOTTOM_CORNER_CELL
		)
	
	print("GENERATED BORDERS : ", cell_array)
