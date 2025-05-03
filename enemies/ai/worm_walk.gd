extends MyState

var worm: MyEnemyWorm


func enter(_from_state: MyState) -> void:
	worm = npc as MyEnemyWorm

	worm.navigation_agent_3d.velocity_computed.connect(self.on_velocity_computed)

	worm.destination = worm.position.normalized() * 0.05
	worm.navigation_agent_3d.set_target_position(worm.destination)

	worm.audio_walk.play()


func exit(_to_state: MyState) -> void:
	worm.navigation_agent_3d.velocity_computed.disconnect(self.on_velocity_computed)
	worm.audio_walk.stop()


func update(_delta: float) -> void:
	if not worm.is_alive:
		return state_machine.switch_state($"../WormDie" as MyState)

	if worm.agent_distance_to(worm.destination) < 0.4:
		return state_machine.switch_state($"../WormEat" as MyState)


func physics_update(_delta: float) -> void:
	worm.update_navigation_agent(_delta, 0.3)


func on_velocity_computed(safe_velocity: Vector3) -> void:
	worm.apply_velocity(safe_velocity)
