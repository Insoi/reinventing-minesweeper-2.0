@tool
@icon("res://tools/SegmentCounter/Icon.png")
class_name SegmentCounter
extends HBoxContainer

const DIGIT_NODE_PREFIX := "_SEGMENT_DISPLAY_"

var _value: int = 0
var _digits: int = 1

@export var texture: Texture2D:
	set(value):
		texture = value
		update()

@export_range(0, 100, 1, "or_greater") var value: int:
	get:
		return _value
	set(new_value):
		if new_value >= 0 and str(new_value).length() <= _digits:
			_value = new_value
		update()

# digits int value property for how how many digits should be shown as in 001 -> 01 or 2 -> 0002
@export_range(1, 100, 1, "or_greater") var digits: int:
	get:
		return _digits
	set(new_value):
		if new_value > 0:
			_digits = new_value
		var min_val = -(2**63) if allow_negative else 0
		var max_val = int(pow(10, _digits)) - 1
		_value = clampi(_value, min_val, max_val)
		update()

@export var spacing: int = 0:
	set(value):
		spacing = value
		add_theme_constant_override("separation", spacing)

@export var allow_negative: bool = false

func _ready() -> void:
	update()

func update() -> void:
	if texture == null:
		push_warning("Texture is not set !!!!")
		return
	
	for child in get_children():
		if child.name.begins_with(DIGIT_NODE_PREFIX):
			child.queue_free()
		
	var value_str := str(_value).pad_zeros(_digits)
	for digit_char in value_str:
		var digit_offset := digit_char.unicode_at(0) - '0'.unicode_at(0)
		
		var digit_rect := TextureRect.new()
		digit_rect.name = DIGIT_NODE_PREFIX + str(randi())
		
		var atlas := AtlasTexture.new()
		atlas.atlas = texture
		atlas.region = Rect2(0 + digit_offset * 9, 0, 9, 10)
		
		digit_rect.texture = atlas
		add_child(digit_rect)
