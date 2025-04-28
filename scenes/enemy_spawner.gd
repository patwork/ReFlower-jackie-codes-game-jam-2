class_name MyEnemySpawner
extends Node3D

@export var scene_worm: PackedScene
@export var scene_beetle: PackedScene
@export var scene_wasp: PackedScene

var game_over: bool

var flower_ref: MyFlower

var _worms: Array[MyEnemy]
var _beetles: Array[MyEnemy]
var _wasps: Array[MyEnemyWasp]


func _ready() -> void:
	game_over = false

	flower_ref = get_tree().get_nodes_in_group("flower").pop_front()
	assert(flower_ref)

	EventBus.game_win.connect(self.on_game_win)


func _on_timer_timeout() -> void:
	if game_over:
		return

	var flower_health: float = flower_ref.flower_health

	update_enemy_list()

	var max_wasps: int

	# FIXME worms
	# FIXME beetles

	if flower_health < 25:
		max_wasps = 2
	elif flower_health < 50:
		max_wasps = 3
	elif flower_health < 75:
		max_wasps = 4
	else:
		max_wasps = 5

	if _wasps.size() < max_wasps:
		spawn_wasp()


func spawn_worm() -> void:
	pass # FIXME


func spawn_beetle() -> void:
	pass # FIXME


func spawn_wasp() -> void:
	var wasp: MyEnemyWasp = scene_wasp.instantiate() as MyEnemyWasp
	add_child(wasp)
	wasp.position = Vector3(
		randf_range(-8.0, 8.0),
		randf_range(2.0, 6.0),
		randf_range(-8.0, 8.0)
	)


func on_game_win() -> void:
	update_enemy_list()

	# FIXME worms
	# FIXME beetles
	if not _wasps.is_empty():
		for wasp: MyEnemyWasp in _wasps:
			wasp.destruct()


func update_enemy_list() -> void:
	_worms.clear()
	_beetles.clear()
	_wasps.clear()

	if get_child_count() > 0:
		for enemy: Node in get_children():
			# FIXME worms
			# FIXME beetles
			if enemy is MyEnemyWasp:
				_wasps.append(enemy)

	# FIXME print(_worms, _beetles, _wasps)
