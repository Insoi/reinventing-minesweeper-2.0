extends Node2D

@onready var background_top: TileMapLayer = get_node("background_top")
@onready var background_bottom: TileMapLayer = get_node("background_bottom")
@onready var board_borders: TileMapLayer = get_node("board_borders")

func _on_board_generated(cell_array: Array) -> void:
	print("GENERATED BORDERS : ", cell_array)
	
	generate_board_borders()
	generate_background()

func generate_board_borders() -> void:
	# top border (right corner, top cells, left corner)
	for x: int in Config.BOARD_WIDTH + 2:
		var cell_coordinates: Vector2i = CellVectors.BOARD_TOP_CELL
		var cell_pos: Vector2 = Vector2(x + (Config.STARTING_POS.x - 1), Config.STARTING_POS.y - 1)
		
		if x == 0: # top left corner
			cell_coordinates = CellVectors.BOARD_L_TOP_CORNER_CELL
		elif x == Config.BOARD_WIDTH + 1: # top right corner
			cell_coordinates = CellVectors.BOARD_R_TOP_CORNER_CELL
		
		board_borders.set_cell(cell_pos, 2, cell_coordinates)
	
	# bottom border (right corner, bottom cells, left corner)
	for x: int in Config.BOARD_WIDTH + 2:
		var cell_coordinates : Vector2i = CellVectors.BOARD_BOTTOM_CELL
		var cell_pos : Vector2 = Vector2(
			x + (Config.STARTING_POS.x - 1),
			Config.STARTING_POS.y + Config.BOARD_HEIGHT)
		
		if x == 0: # bottom left corner
			cell_coordinates = CellVectors.BOARD_L_BOTTOM_CORNER_CELL
		elif x == 1: # bottom start cell (right next to the left bottom corner)
			cell_coordinates = CellVectors.BOARD_BOTTOM_START_CELL
		
		board_borders.set_cell(cell_pos, 2, cell_coordinates)
	
	# left and right borders
	for y: int in Config.BOARD_HEIGHT:
		var left_cell_pos: Vector2 = Vector2(Config.STARTING_POS.x - 1, y + Config.STARTING_POS.y)
		board_borders.set_cell(left_cell_pos, 2, CellVectors.BOARD_L_CELL)
		
		var right_cell_pos: Vector2 = Vector2(Config.STARTING_POS.x + Config.BOARD_WIDTH, y + Config.STARTING_POS.y)
		board_borders.set_cell(right_cell_pos, 2, CellVectors.BOARD_R_CELL)
		
		board_borders.set_cell(
			Vector2(Config.STARTING_POS.x + Config.BOARD_WIDTH, Config.STARTING_POS.y + Config.BOARD_HEIGHT),
			2,
			CellVectors.BOARD_R_BOTTOM_CORNER_CELL
		)

func generate_background() -> void:
	var board_width: int = Config.BOARD_WIDTH + (Config.STARTING_POS.x * 2)
	var board_height: int = Config.BOARD_HEIGHT - Config.BOTTOM_MARGIN + (Config.STARTING_POS.y * 2)
	
	for x: int in board_width:
		for y: int in board_height:
			var cell_coordinates: Vector2i = CellVectors.DEBUG_CELL if Config.DEBUG_TILES else CellVectors.BACKGROUND_CELL_LIGHT
			
			# Outermost edge (darkest background)
			if x <= 0 or x == board_width - 1 or y <= Config.TOP_MARGIN - 1 or y == board_height - 1:
				cell_coordinates = CellVectors.BACKGROUND_CELL_DARK
			
			# Second layer (transition cells)
			elif x == 1 or x == board_width - 2 or y == Config.TOP_MARGIN or y == board_height - 2:
				# Corner transitions
				if x == 1 and y == Config.TOP_MARGIN: # top left corner
					cell_coordinates = CellVectors.CURVED_TRANSITION_CELL_LT
				elif x == board_width - 2 and y == Config.TOP_MARGIN: # top right corner
					cell_coordinates = CellVectors.CURVED_TRANSITION_CELL_RT
				elif x == board_width - 2 and y == board_height - 2: # bottom right corner
					cell_coordinates = CellVectors.CURVED_TRANSITION_CELL_RB
				elif x == 1 and y == board_height - 2: # bottom left corner
					cell_coordinates = CellVectors.CURVED_TRANSITION_CELL_LB
				
				# Straight edge transitions
				elif y == Config.TOP_MARGIN: # top edge
					cell_coordinates = CellVectors.STRAIGHT_TRANSITION_CELL_TOP
				elif y == board_height - 2: # bottom edge
					cell_coordinates = CellVectors.STRAIGHT_TRANSITION_CELL_BOTTOM
				elif x == 1: # left edge
					cell_coordinates = CellVectors.STRAIGHT_TRANSITION_CELL_LEFT
				elif x == board_width - 2: # right edge
					cell_coordinates = CellVectors.STRAIGHT_TRANSITION_CELL_RIGHT
			
			background_bottom.set_cell(Vector2(x, y), 2, (CellVectors.DEBUG_CELL if Config.DEBUG_TILES else CellVectors.BACKGROUND_CELL_LIGHT))
			background_top.set_cell(Vector2(x, y), 2, cell_coordinates)
