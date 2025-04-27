extends MyState

const dist: float = 4.0

var wasp: MyEnemyWasp


func enter(_from_state: MyState) -> void:
	wasp = npc as MyEnemyWasp

	var pos: Vector3 = wasp.position
	while pos.distance_squared_to(wasp.position) < 1.0:
		pos.x = clampf(wasp.position.x + randf_range(-dist, dist), -8.0, 8.0)
		pos.y = clampf(wasp.position.y + randf_range(-dist, dist), 2.0, 6.0)
		pos.z = clampf(wasp.position.z + randf_range(-dist, dist), -8.0, 8.0)
	wasp.destination = pos


func update(_delta: float) -> void:
	if not wasp.is_alive:
		return state_machine.switch_state($"../WaspDie" as MyState)

	wasp.position = wasp.position.move_toward(wasp.destination, _delta * 3.0)

	if  wasp.position.distance_to(wasp.destination) < 0.1:
		return state_machine.switch_state($"../WaspHover" as MyState)

	if wasp.agression > 5.0:
		return state_machine.switch_state($"../WaspAttack" as MyState)
