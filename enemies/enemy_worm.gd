class_name MyEnemyWorm
extends MyEnemy

@onready var animation_player: AnimationPlayer = $worm/AnimationPlayer
@onready var audio_walk: AudioStreamPlayer3D = $Audio/AudioWalk
@onready var audio_die: AudioStreamPlayer3D = $Audio/AudioDie
@onready var audio_eat: AudioStreamPlayer3D = $Audio/AudioEat


func _ready() -> void:
	super()

	audio_walk.stream = AudioManager.sound_effects[AudioManager.SOUND_EFFECT.WORM_WALK]
	audio_die.stream = AudioManager.sound_effects[AudioManager.SOUND_EFFECT.WORM_DIE]
	audio_eat.stream = AudioManager.sound_effects[AudioManager.SOUND_EFFECT.WORM_EAT]

	animation_player.play("ArmatureAction")


func _process(_delta: float) -> void:
	var look: Vector3 = Vector3(destination.x, position.y, destination.z)
	if not position.is_equal_approx(look):
		look_at(look)
