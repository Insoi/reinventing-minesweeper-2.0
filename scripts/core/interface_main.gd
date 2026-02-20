extends Node2D

@onready var board: Board = get_tree().current_scene.get_node("board")
@onready var leaderboard: InteractiveButton = get_node("leaderboard_button")

var data_dialog_scene: PackedScene = preload("res://scenes/data_dialog.tscn")
var custom_results_scene: PackedScene = preload("res://scenes/game_results.tscn")
var game_results: GameResults = null
var leaderboard_dialog: DataDialog = null

func _ready() -> void:
	_setup_dialogs()
	board.game_won.connect(game_results.show_dialog)
	leaderboard.on_click.connect(leaderboard_dialog.toggle_dialog)

func _setup_dialogs() -> void:
	game_results = custom_results_scene.instantiate()
	leaderboard_dialog = data_dialog_scene.instantiate()
	
	add_child(game_results)
	add_child(leaderboard_dialog)

func _on_board_generated(cell_array: Array) -> void:
	var x_center: float = (Config.STARTING_POS.x + Config.BOARD_WIDTH / 2.0) * Config.CELL_SIZE
	position = Vector2(x_center, (Config.STARTING_POS.y - 0.8) * Config.CELL_SIZE)
	
	var board_pixel_width: int = Config.BOARD_WIDTH * Config.CELL_SIZE
	var available_width: float = get_viewport_rect().size.x - (0.8 * Config.CELL_SIZE * 2)
	
	var target_scale: float = (board_pixel_width * Config.INTERFACE_MARGIN) / available_width
	scale = Vector2(target_scale, target_scale)

