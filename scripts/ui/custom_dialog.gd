class_name CustomDialog extends ConfirmationDialog

signal size_confirmed(width: int, height: int, bombs_per: int)

@onready var width_spinbox: SpinBox = get_node("VBoxContainer/width_spinbox")
@onready var height_spinbox: SpinBox = get_node("VBoxContainer/height_spinbox")
@onready var bombs_spinbox:SpinBox = get_node("VBoxContainer/bombs_spinbox")

func _ready() -> void:
	var window_size: Vector2 = get_viewport().get_visible_rect().size
	max_size = window_size * 0.9
	
	confirmed.connect(_on_confirmed)

func show_dialog() -> void:
	width_spinbox.value = Config.BOARD_WIDTH
	height_spinbox.value = Config.BOARD_HEIGHT
	bombs_spinbox.value = Config.bombs_percentage
	
	reset_size()
	popup_centered_ratio(0.75)

func _on_confirmed() -> void:
	Audio.play_sfx(Config.click_sfx)
	
	size_confirmed.emit(
		int(width_spinbox.value),
		int(height_spinbox.value),
		int(bombs_spinbox.value)
		)
