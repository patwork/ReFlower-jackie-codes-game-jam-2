class_name MyGame
extends Node3D

@onready var flower: MyFlower = $Flower
@onready var enemy_spawner: MyEnemySpawner = $EnemySpawner
@onready var player: MyPlayer = $Player
@onready var game_ui: MyGameUI = $GameUI

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var _debug_mouse_mode: int


func _ready() -> void:
	_debug_mouse_mode = Input.MOUSE_MODE_CAPTURED
	Input.set_mouse_mode(_debug_mouse_mode)
	audio_stream_player.play()

	EventBus.game_win.connect(self.on_game_win)
	EventBus.game_lose.connect(self.on_game_lose)

	EventBus.game_start.emit()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().call_deferred("quit")
	elif event.is_action_released("ui_select"):
		if _debug_mouse_mode == Input.MOUSE_MODE_CAPTURED:
			_debug_mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			_debug_mouse_mode = Input.MOUSE_MODE_CAPTURED
		Input.set_mouse_mode(_debug_mouse_mode)


func on_game_win() -> void:
	flower.game_over = true
	enemy_spawner.game_over = true
	player.game_over = true
	game_ui.show_win_screen()


func on_game_lose() -> void:
	flower.game_over = true
	enemy_spawner.game_over = true
	player.game_over = true
	game_ui.show_loose_screen()
