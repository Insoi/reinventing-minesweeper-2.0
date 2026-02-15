extends Node

# board game cell tiles
const NUMBERS: Array[int] = [14, 13, 12, 11, 10, 9, 8, 7]
const UNEXPLORED_CELL: int = 0
const BLANK_CELL: int = 15
const BOMB_CELL: int = 5
const FLAGGED_CELL: int = 1

# flat background cells & debug
const BACKGROUND_CELL_LIGHT: Vector2i = Vector2i(2,7)
const BACKGROUND_CELL_DARK: Vector2i = Vector2i(1,7)
const DEBUG_CELL: Vector2i = Vector2i(0,7)

# transition straight cells
const STRAIGHT_TRANSITION_CELL_LEFT: Vector2i = Vector2i(0,1)
const STRAIGHT_TRANSITION_CELL_RIGHT: Vector2i = Vector2i(2,6)
const STRAIGHT_TRANSITION_CELL_TOP: Vector2i = Vector2i(1,0) 
const STRAIGHT_TRANSITION_CELL_BOTTOM: Vector2i = Vector2i(1,6)

# transition corner cells
const CURVED_TRANSITION_CELL_LT: Vector2i = Vector2i(0,0) # left top
const CURVED_TRANSITION_CELL_RT: Vector2i = Vector2i(2,0) # right top
const CURVED_TRANSITION_CELL_RB: Vector2i = Vector2i(2,1) # right bottom
const CURVED_TRANSITION_CELL_LB: Vector2i = Vector2i(1,1) # left bottom

# Board border cells
const BOARD_L_TOP_CORNER_CELL: Vector2i = Vector2i(0,2)
const BOARD_TOP_CELL: Vector2i = Vector2i(1,2)
const BOARD_R_TOP_CORNER_CELL: Vector2i = Vector2i(2,2)
const BOARD_R_CELL: Vector2i = Vector2i(2,3)
const BOARD_R_BOTTOM_CORNER_CELL: Vector2i = Vector2i(2,4)
const BOARD_BOTTOM_START_CELL: Vector2i = Vector2i(1,4)
const BOARD_BOTTOM_CELL: Vector2i = Vector2i(1,5)
const BOARD_L_BOTTOM_CORNER_CELL: Vector2i = Vector2i(0,4)
const BOARD_L_CELL: Vector2i = Vector2i(0,3)
