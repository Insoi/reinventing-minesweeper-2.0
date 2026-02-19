extends Sprite2D

@onready var board: Board = get_tree().current_scene.get_node("board")
@onready var input_handler: InputHandler = get_tree().current_scene.get_node("InputHandler")
@onready var counter: SegmentCounter = get_node("counter")
@onready var timer: Timer = get_node("Timer")

var new_board: bool = true

func _ready() -> void:
	board.generated.connect(
		func(cell_array: Array) -> void:
		new_board = true
		counter.value = 0
	)
	
	input_handler.left_click.connect(_start_timer)
	timer.timeout.connect(_on_tick)
	board.game_won.connect(_on_game_over)
	board.game_lost.connect(_on_game_over)

func _start_timer(tile_array_pos: Vector2i, tile_pos: Vector2i) -> void:
	if not new_board:
		return
	
	new_board = false
	counter.value = 0
	
	if board.game_active:
		timer.start()

func _on_tick() -> void:
	if not board.game_active: return
	print("tick: ", counter.value)
	counter.value += 1

func _on_game_over() -> void:
	print("stopped timer")
	timer.stop()