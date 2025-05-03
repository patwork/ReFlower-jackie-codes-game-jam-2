extends MyState

var worm: MyEnemyWorm


func enter(_from_state: MyState) -> void:
	worm = npc as MyEnemyWorm

	worm.audio_walk.stop()
	worm.audio_die.play()

	worm.animation_player.stop()
	worm.rotation.z = deg_to_rad(180.0)
	worm.position.y = 0.3

	worm.destination = worm.position

	get_tree().create_timer(2.0).timeout.connect(worm.destruct)
