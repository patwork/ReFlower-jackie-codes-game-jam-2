class_name MyGame
extends Node3D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var _debug_mouse_mode: int


func _ready() -> void:
	_debug_mouse_mode = Input.MOUSE_MODE_CAPTURED
	Input.set_mouse_mode(_debug_mouse_mode)
	# FIXME audio_stream_player.play()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().quit()
	elif event.is_action_released("ui_select"):
		if _debug_mouse_mode == Input.MOUSE_MODE_CAPTURED:
			_debug_mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			_debug_mouse_mode = Input.MOUSE_MODE_CAPTURED
		Input.set_mouse_mode(_debug_mouse_mode)
