extends Node

# GENERAL / BOARD
const BOARD_HEIGHT : int = 10
const BOARD_WIDTH : int = 10
const CELL_SIZE : int = 16
@warning_ignore("narrowing_conversion")
const BOMBS : int = (float(BOARD_HEIGHT * BOARD_WIDTH) / 100.0) * 1 # as in 20% of the total cells on the board

# BACKGROUND
const TOP_MARGIN : int = 3 # how much the top dark background layer should go down
const BOTTOM_MARGIN : int = 4 # how many cells should be removed on the y axis for background generation / window
const STARTING_POS : Vector2i = Vector2i(4,7) # starting_pos * cell_size and starting_pos starts at 0

@warning_ignore("narrowing_conversion")
const INTERFACE_MARGIN : float = 1.9

# DEBUGGING
const DEBUG_TILES : bool = false
const DEBUG_BOARD : bool = true
