extends Node

# GENERAL / BOARD
const CELL_SIZE: int = 16
var BOARD_HEIGHT: int = 10
var BOARD_WIDTH: int = 10
var bombs_percentage: int = 10
var BOMBS: int:
	get:
		@warning_ignore("narrowing_conversion")
		return (float(BOARD_HEIGHT * BOARD_WIDTH) / 100.0) * bombs_percentage # as in 20% of the total cells on the board

# SETTINGS
var shaders_toggled: bool = true

# BACKGROUND
const TOP_MARGIN: int = 3 # how much the top dark background layer should go down
const BOTTOM_MARGIN: int = 4 # how many cells should be removed on the y axis for background generation / window
const STARTING_POS: Vector2i = Vector2i(4,7) # starting_pos * cell_size and starting_pos starts at 0

@warning_ignore("narrowing_conversion")
const INTERFACE_MARGIN: float = 1.9

# DEBUGGING
const DEBUG_TILES: bool = false
const DEBUG_BOARD: bool = true

# FONTS
var Qaroxe: FontFile = preload("res://assets/textures/modern/Qaroxe.ttf")

# SOUNDS / MUSIC
var bomb_sfx: AudioStream = preload("res://assets/audio/boom.mp3")
var click_sfx: AudioStream = preload("res://assets/audio/click.mp3")
var discover_cell_sfx: AudioStream = preload("res://assets/audio/discover_cell.mp3")
var place_sfx: AudioStream = preload("res://assets/audio/place.mp3")