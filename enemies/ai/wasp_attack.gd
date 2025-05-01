extends MyState

const dist: float = 1.0
const attack_freq: float = 1.0
const update_freq: float = 0.5

var wasp: MyEnemyWasp
var cooldown_atk: float
var cooldown_pos: float


func enter(_from_state: MyState) -> void:
	wasp = npc as MyEnemyWasp
	wasp.audio_fly.pitch_scale = 0.8
	wasp.navigation_agent_3d.velocity_computed.connect(self.on_velocity_computed)
	cooldown_atk = attack_freq


func exit(_to_state: MyState) -> void:
	wasp.navigation_agent_3d.velocity_computed.disconnect(self.on_velocity_computed)
	wasp.audio_fly.pitch_scale = 1.0


func update(_delta: float) -> void:
	if not wasp.is_alive:
		return state_machine.switch_state($"../WaspDie" as MyState)

	var dist_player = wasp.agent_distance_to(wasp.player_ref.position)

	if dist_player > 1.0:
		cooldown_pos -= _delta
		if cooldown_pos < 0.0:
			cooldown_pos = update_freq
			wasp.destination = wasp.player_ref.position
			wasp.navigation_agent_3d.set_target_position(wasp.destination)
	else:
		cooldown_atk -= _delta
		if cooldown_atk < 0.0:
			cooldown_atk = attack_freq
			EventBus.player_hit.emit(1)

	if wasp.agression < 1.0:
		return state_machine.switch_state($"../WaspHover" as MyState)


func physics_update(_delta: float) -> void:
	wasp.update_navigation_agent(_delta, 3.0)


func on_velocity_computed(safe_velocity: Vector3) -> void:
	wasp.apply_velocity(safe_velocity)
