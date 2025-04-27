class_name MyEnemyWasp
extends MyEnemy

@onready var animation_player: AnimationPlayer = $wasp/AnimationPlayer
@onready var audio_fly: AudioStreamPlayer3D = $Audio/AudioFly
@onready var audio_die: AudioStreamPlayer3D = $Audio/AudioDie


func _ready() -> void:
	enemy_type = ENEMY_TYPE.WASP
	color_variation = Constants.COLOR_VARIATIONS.YELLOW
	is_alive = true
	health = 100
	velocity = Vector3.ZERO
	destination = Vector3.ZERO

	animation_player.play("ArmatureAction")

	audio_fly.stream = AudioManager.sound_effects[AudioManager.SOUND_EFFECT.WASP_FLY]
	audio_die.stream = AudioManager.sound_effects[AudioManager.SOUND_EFFECT.WASP_DIE]

	audio_fly.play()


func _process(_delta: float) -> void:
	var look: Vector3 = Vector3(destination.x, position.y, destination.z)
	if not position.is_equal_approx(look):
		look_at(look)
