extends Node

var sfx_player: AudioStreamPlayer

func _ready() -> void:
	sfx_player = AudioStreamPlayer.new()
	add_child(sfx_player)

func play_bomb() -> void:
	sfx_player.stream = Config.bomb_sfx
	sfx_player.play()
