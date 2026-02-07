extends Node

const BOARD_HEIGHT : int = 15
const BOARD_WIDTH : int = 20
const CELL_SIZE : int = 16
const STARTING_POS : Vector2i = Vector2i(4,5) # starting_pos * cell_size and starting_pos starts at 0

@warning_ignore("narrowing_conversion")
const BOMBS : int = (float(BOARD_HEIGHT * BOARD_WIDTH) / 100.0) * 15 # as in 20% of the total cells on the board

const DEBUG : bool = false
