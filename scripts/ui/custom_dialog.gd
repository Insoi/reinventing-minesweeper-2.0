class_name CustomDialog extends ConfirmationDialog

signal size_confirmed(width: int, height: int, bombs_per: int)

@onready var width_spinbox: SpinBox = get_node("VBoxContainer/width_spinbox")
@onready var height_spinbox: SpinBox = get_node("VBoxContainer/height_spinbox")
@onready var bombs_spinbox:SpinBox = get_node("VBoxContainer/bombs_spinbox")

func _ready() -> void:
	var window_size: Vector2 = get_viewport().get_visible_rect().size
	max_size = window_size * 0.9  # 80% of window size
	
	confirmed.connect(_on_confirmed)

func show_dialog() -> void:
	width_spinbox.value = Config.BOARD_WIDTH
	height_spinbox.value = Config.BOARD_HEIGHT
	bombs_spinbox.value = Config.bombs_percentage
	
	# Debug: see what size it actually wants to be
	var box_container: VBoxContainer = $VBoxContainer
	await get_tree().process_frame
	print("Dialog wants to be size: ", size)
	print("VBoxContainer size: ", box_container.size)
	
	reset_size()
	popup_centered_ratio(0.8)

func _on_confirmed() -> void:
	size_confirmed.emit(
		int(width_spinbox.value),
		int(height_spinbox.value),
		int(bombs_spinbox.value)
		)
