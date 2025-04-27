extends MyState

var wasp: MyEnemyWasp

var _falling: bool

func enter(_from_state: MyState) -> void:
	wasp = npc as MyEnemyWasp

	wasp.audio_fly.stop()
	wasp.audio_die.play()

	wasp.animation_player.stop()
	wasp.rotation.x = deg_to_rad(135)

	wasp.destination = Vector3(wasp.position.x, 0.0, wasp.position.z)
	_falling = true


func update(_delta: float) -> void:
	if _falling:
		wasp.position = wasp.position.move_toward(wasp.destination, _delta * 4.0)

	if  wasp.position.distance_to(wasp.destination) < 0.2:
		_falling = false
		get_tree().create_timer(2.0).timeout.connect(wasp.destruct)
