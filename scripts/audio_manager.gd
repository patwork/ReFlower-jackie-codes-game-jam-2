class_name MyAudioManager
extends Node

enum SOUND_EFFECT {
	CLICK,
}

@export var sound_effects: Dictionary[SOUND_EFFECT, AudioStreamMP3]
