class_name InteractiveButton extends TileMapLayer

signal on_click

var tile_pos: Vector2i
var is_pressed: bool = false

func _ready() -> void:
	tile_pos = local_to_map(Vector2.ZERO)
	set_cell(tile_pos, 0, Vector2i(0, 1))

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event
		
		if mouse_event.button_index == MOUSE_BUTTON_LEFT:
			var mouse_tile_pos: Vector2i = local_to_map(get_local_mouse_position())
			
			if mouse_event.is_pressed() and mouse_tile_pos == tile_pos:
				is_pressed = true
				set_cell(tile_pos, 0, Vector2i(0, 0))
				Audio.play_sfx(Config.click_sfx)
				
			if mouse_event.is_released() and is_pressed:
				is_pressed = false
				set_cell(tile_pos, 0, Vector2i(0, 1))
				on_click.emit()