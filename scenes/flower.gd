class_name MyFlower
extends StaticBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

const ANIM_GROW = &"ArmatureAction"

var _animation_length: float


func _ready() -> void:
	_animation_length = animation_player.get_animation(ANIM_GROW).length
	seek_animation(0.0)


func seek_animation(percent: float) -> void:
	animation_player.play(ANIM_GROW)
	animation_player.seek((_animation_length / 100.0) * percent, true, true)
	animation_player.pause()
