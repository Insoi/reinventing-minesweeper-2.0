class_name LeaderboardEntry extends PanelContainer

@onready var info: Label = get_node("HBoxContainer/VBoxContainer2/info")
@onready var score: Label = get_node("HBoxContainer/VBoxContainer/score")
@onready var username: Label = get_node("HBoxContainer/VBoxContainer/user")
@onready var bombs: Label = get_node("HBoxContainer/VBoxContainer2/bombs")

func _ready() -> void:
	var style: StyleBoxFlat = get_theme_stylebox("panel")
	style.set_corner_radius_all(6)

func setup(index_data: Dictionary) -> void:
	var bombs_per: int = index_data["Bomb Percentage"]
	var time: int = index_data["Time Score"]
	
	# whenever I do this in properties, it genuinely just doesn't work the same as in GDScript.
	username.size_flags_horizontal = Control.SIZE_FILL
	info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	score.size_flags_horizontal = Control.SIZE_FILL
	
	username.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	score.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	
	username.text = "@%s" % index_data.Username
	info.text = "SIZE: %dx%d" % [index_data.Width, index_data.Height]
	bombs.text = "%d%% BOMBS" % bombs_per
	score.text = "TIME: %ds" % time
