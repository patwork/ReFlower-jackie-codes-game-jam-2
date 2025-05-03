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

	update_enemy_list()

	var flower_health: float = flower_ref.flower_health
	spawn_worms(flower_health)
	spawn_beetles(flower_health)
	spawn_wasps(flower_health)


func spawn_worms(flower_health: float) -> void:
	var max_worms: int

	if flower_health < 40:
		max_worms = 2
	elif flower_health < 80:
		max_worms = 3
	else:
		max_worms = 4

	if _worms.size() < max_worms:
		var worm: MyEnemyWorm = scene_worm.instantiate() as MyEnemyWorm
		add_child(worm)
		worm.position = (Vector3.FORWARD * 7.5).rotated(Vector3.UP, randf() * PI * 2.0)


func spawn_beetles(flower_health: float) -> void:
	# FIXME beetles
	pass


func spawn_wasps(flower_health: float) -> void:
	var max_wasps: int

	if flower_health < 25:
		max_wasps = 2
	elif flower_health < 50:
		max_wasps = 3
	elif flower_health < 75:
		max_wasps = 4
	else:
		max_wasps = 5

	if _wasps.size() < max_wasps:
		var wasp: MyEnemyWasp = scene_wasp.instantiate() as MyEnemyWasp
		add_child(wasp)
		wasp.position = Vector3(
			randf_range(-8.0, 8.0),
			randf_range(2.0, 6.0),
			randf_range(-8.0, 8.0)
		)


func on_game_win() -> void:
	update_enemy_list()

	if not _worms.is_empty():
		for worm: MyEnemyWorm in _worms:
			worm.destruct()

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
			if enemy is MyEnemyWorm:
				_worms.append(enemy)
			if enemy is MyEnemyWasp:
				_wasps.append(enemy)
