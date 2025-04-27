extends MyState

const dist: float = 1.0
const attack_freq: float = 1.0

var wasp: MyEnemyWasp
var cooldown: float


func enter(_from_state: MyState) -> void:
	wasp = npc as MyEnemyWasp
	wasp.audio_fly.pitch_scale = 0.8
	cooldown = attack_freq


func exit(_to_state: MyState) -> void:
	wasp.audio_fly.pitch_scale = 1.0


func update(_delta: float) -> void:
	if not wasp.is_alive:
		return state_machine.switch_state($"../WaspDie" as MyState)

	var wp: Vector2 = Vector2(wasp.position.x, wasp.position.z)
	var pp: Vector2 = Vector2(wasp.player_ref.position.x, wasp.player_ref.position.z)
	var dir: Vector2 = (wp - pp).normalized() * (1.0 + cos(wasp.get_instance_id()) * 0.2)
	var pos: Vector3 = Vector3(
		wasp.destination.x + dir.x,
		1.8 + sin(wasp.get_instance_id()) * 0.5,
		wasp.destination.z + dir.y
	)

	wasp.destination = wasp.player_ref.position
	wasp.position = wasp.position.move_toward(pos, _delta * 3.0)

	if wasp.position.distance_to(pos) < 0.1:
		cooldown -= _delta
		if cooldown < 0.0:
			cooldown = attack_freq
			EventBus.player_hit.emit(1)

	if wasp.agression < 1.0:
		return state_machine.switch_state($"../WaspHover" as MyState)
