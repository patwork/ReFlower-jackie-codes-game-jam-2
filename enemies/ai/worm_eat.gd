extends MyState

const eating_freq: float = 1.0

var worm: MyEnemyWorm
var cooldown_eating: float


func enter(_from_state: MyState) -> void:
	worm = npc as MyEnemyWorm
	cooldown_eating = eating_freq


func update(_delta: float) -> void:
	if not worm.is_alive:
		return state_machine.switch_state($"../WormDie" as MyState)

	cooldown_eating -= _delta
	if cooldown_eating < 0.0:
		cooldown_eating = eating_freq
		worm.audio_eat.play()
		EventBus.flower_hit.emit(0.5)

	if worm.agent_distance_to(worm.destination) >= 0.4:
		push_warning([self, "worm pushed out"])
