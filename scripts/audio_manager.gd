class_name MyAudioManager
extends Node

enum SOUND_EFFECT {
	CLICK,
	FOOTSTEP,
	WATER_CAN,
	SPRAY,
	WASP_FLY,
	WASP_DIE,
	HIT,
	PAIN1,
	PAIN2,
	PAIN3,
	WORM_WALK,
	WORM_DIE,
	WORM_EAT
}

@export var sound_effects: Dictionary[SOUND_EFFECT, AudioStreamMP3]
