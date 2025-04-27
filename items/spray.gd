class_name MySpray
extends MyShootingItem


func _ready() -> void:
	audio_stream_player_3d.stream = AudioManager.sound_effects[AudioManager.SOUND_EFFECT.SPRAY]
	audio_stream_player_3d.volume_db = -30.0
