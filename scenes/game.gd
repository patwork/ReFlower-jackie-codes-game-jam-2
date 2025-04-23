class_name MyGame
extends Node3D

var _debug_mouse_mode: int


func _ready() -> void:
	_debug_mouse_mode = Input.MOUSE_MODE_CAPTURED
	Input.set_mouse_mode(_debug_mouse_mode)


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
