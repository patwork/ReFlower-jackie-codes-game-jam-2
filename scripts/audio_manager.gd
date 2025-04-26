class_name MyAudioManager
extends Node

enum SOUND_EFFECT {
	CLICK,
	FOOTSTEP,
	WATER_CAN,
	SPRAY,
	WASP_FLY,
	WASP_DIE
}

@export var sound_effects: Dictionary[SOUND_EFFECT, AudioStreamMP3]
