class_name MyEnemyWasp
extends MyEnemy

@onready var animation_player: AnimationPlayer = $wasp/AnimationPlayer
@onready var audio_fly: AudioStreamPlayer3D = $Audio/AudioFly
@onready var audio_die: AudioStreamPlayer3D = $Audio/AudioDie
@onready var aware_timer: Timer = $AwareTimer

var agression: float


func _ready() -> void:
	super()

	agression = 0.0

	audio_fly.stream = AudioManager.sound_effects[AudioManager.SOUND_EFFECT.WASP_FLY]
	audio_die.stream = AudioManager.sound_effects[AudioManager.SOUND_EFFECT.WASP_DIE]

	audio_fly.play()
	animation_player.play("ArmatureAction")


func _process(_delta: float) -> void:
	var look: Vector3 = Vector3(destination.x, position.y, destination.z)
	if not position.is_equal_approx(look):
		look_at(look)


func hurt() -> void:
	super()
	agression = min(agression + 5.0, 20.0)


func _on_aware_timer_timeout() -> void:
	var bodies: Array[Node3D] = awareness.get_overlapping_bodies()
	if not bodies.is_empty():
		for body: Node3D in bodies:
			if body.is_in_group("player"):
				agression = min(agression + 2.5, 20.0)
	agression = max(agression - 0.5, 0.0)
