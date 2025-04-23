class_name MyShootingItem
extends MyHoldableItem

@onready var cpu_particles_3d: CPUParticles3D = $CPUParticles3D

func start_shooting() -> bool:
	if cpu_particles_3d.emitting:
		return false

	cpu_particles_3d.emitting = true
	return true
