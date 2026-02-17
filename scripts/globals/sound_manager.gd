extends Node

var sfx_player: AudioStreamPlayer

func _ready() -> void:
	sfx_player = AudioStreamPlayer.new()
	add_child(sfx_player)

func play_sfx(audio: AudioStream) -> void:
	sfx_player.stream = audio
	sfx_player.play()
