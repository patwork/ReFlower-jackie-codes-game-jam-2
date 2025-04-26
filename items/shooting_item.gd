class_name MyShootingItem
extends MyHoldableItem

@onready var cpu_particles_3d: CPUParticles3D = $CPUParticles3D
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D


func start_shooting() -> bool:
	if cpu_particles_3d.emitting:
		return false

	cpu_particles_3d.restart()
	cpu_particles_3d.emitting = true

	if audio_stream_player_3d.stream:
		audio_stream_player_3d.stop()
		audio_stream_player_3d.pitch_scale = randf_range(0.9, 1.1)
		audio_stream_player_3d.play()

	return true


func stop_shooting() -> void:
	cpu_particles_3d.emitting = false
	audio_stream_player_3d.stop()
