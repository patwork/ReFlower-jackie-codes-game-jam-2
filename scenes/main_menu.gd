class_name MyMainMenu
extends Control


func goto_game() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_button_pressed() -> void:
	goto_game.call_deferred()
