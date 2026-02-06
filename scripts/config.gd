extends Node

const board_height : int = 10
const board_width : int = 10
const cell_size : int = 16
const starting_pos : Vector2i = Vector2i(5,5) # * cell_size

@warning_ignore("integer_division")
const bombs : int = (board_height * board_width / 100) * 25 # as in 20% of the total cells on the board

const numbers = [14, 13, 12, 11, 10, 9, 8, 7]
const unexplored_cell = 0
const blank_cell = 15
const bomb_cell = 5
const flagged_cell = 1
