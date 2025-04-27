class_name MyWateringCan
extends MyShootingItem


func _ready() -> void:
	audio_stream_player_3d.stream = AudioManager.sound_effects[AudioManager.SOUND_EFFECT.WATER_CAN]
