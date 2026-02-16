class_name CustomSizeSettings extends ConfirmationDialog

signal size_confirmed(width: int, height: int, bombs_per: int)

@onready var width_spinbox: SpinBox = get_node("VBoxContainer/width_spinbox")
@onready var height_spinbox: SpinBox = get_node("VBoxContainer/height_spinbox")
@onready var bombs_spinbox:SpinBox = get_node("VBoxContainer/bombs_spinbox")

func _ready() -> void:
	@warning_ignore("return_value_discarded")
	confirmed.connect(_on_confirmed)

func show_dialog() -> void:
	width_spinbox.value = Config.BOARD_WIDTH
	height_spinbox.value = Config.BOARD_HEIGHT
	bombs_spinbox.value = Config.bombs_percentage
	popup_centered()

func _on_confirmed() -> void:
	size_confirmed.emit(
		int(width_spinbox.value),
		int(height_spinbox.value),
		int(bombs_spinbox.value)
		)
