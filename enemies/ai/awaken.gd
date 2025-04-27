extends MyState

@export var next_state: MyState


func enter(_from_state: MyState) -> void:
	await get_tree().create_timer(randf_range(0.1, 0.9)).timeout
	return state_machine.switch_state(next_state)
