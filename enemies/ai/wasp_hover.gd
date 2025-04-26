extends MyState


func enter(_from_state: MyState) -> void:
	await get_tree().create_timer(randf_range(0.2, 0.4)).timeout
	state_machine.switch_state($"../WaspWander" as MyState)
