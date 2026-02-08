extends Node

const BOARD_HEIGHT : int = 15
const BOARD_WIDTH : int = 100
const CELL_SIZE : int = 16

const TOP_MARGIN : int = 4 # how much the top dark background layer should go down
const BOTTOM_MARGIN : int = 5 # how many cells should be removed on the y axis for background generation / window
const STARTING_POS : Vector2i = Vector2i(4,9) # starting_pos * cell_size and starting_pos starts at 0

@warning_ignore("narrowing_conversion")
const BOMBS : int = (float(BOARD_HEIGHT * BOARD_WIDTH) / 100.0) * 25 # as in 20% of the total cells on the board

# debugging constants
const DEBUG_TILES : bool = false
const DEBUG_BOARD : bool = false
