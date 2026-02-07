extends Node

const BOARD_HEIGHT : int = 5
const BOARD_WIDTH : int = 15
const CELL_SIZE : int = 16
const STARTING_POS : Vector2i = Vector2i(2,2) # starting_pos * cell_size and starting_pos starts at 0

@warning_ignore("narrowing_conversion")
const BOMBS : int = (float(BOARD_HEIGHT * BOARD_WIDTH) / 100.0) * 50 # as in 20% of the total cells on the board

const NUMBERS = [14, 13, 12, 11, 10, 9, 8, 7]
const UNEXPLORED_CELL = 0
const BLANK_CELL = 15
const BOMB_CELL = 5
const FLAGGED_CELL = 1
