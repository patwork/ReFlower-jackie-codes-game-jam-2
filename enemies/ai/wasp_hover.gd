extends MyState


func enter(_from_state: MyState) -> void:
	await get_tree().create_timer(randf_range(0.2, 0.4)).timeout
	return state_machine.switch_state($"../WaspWander" as MyState)


func update(_delta: float) -> void:
	if not (npc as MyEnemyWasp).is_alive:
		return state_machine.switch_state($"../WaspDie" as MyState)
