class_name MyEnemy
extends Node3D

@export var color_variation: Constants.ENTITIES_VARIATIONS
@export var enemy_type: Constants.ENEMY_TYPE
@export var initial_health: int

@onready var awareness: Area3D = $Awareness
@onready var ai: MyStateMachine = $AI
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

var is_alive: bool
var health: int
var velocity: Vector3
var destination: Vector3
var movement_delta: float

var navmap_id: RID
var navmap_cell_size: float

var player_ref: MyPlayer


func _ready() -> void:
	is_alive = true
	health = initial_health
	velocity = Vector3.ZERO
	destination = Vector3.ZERO
	movement_delta = 0.0

	navmap_id = navigation_agent_3d.get_navigation_map()
	navmap_cell_size = NavigationServer3D.map_get_cell_size(navmap_id)

	player_ref = get_tree().get_nodes_in_group("player").pop_front()
	assert(player_ref)


func hurt() -> void:
	if not is_alive:
		return

	health -= 1
	if health == 0:
		is_alive = false
		EventBus.enemy_died.emit(self)
	else:
		EventBus.enemy_hit.emit(self)


func destruct() -> void:
	queue_free.call_deferred()


func agent_distance_to(dest: Vector3) -> float:
	var nav_position: Vector3 = Vector3(
		position.x,
		position.y + navigation_agent_3d.path_height_offset - (navmap_cell_size * 2.0),
		position.z
	)
	return nav_position.distance_to(dest)


func update_navigation_agent(delta: float, speed: float) -> void:
	if NavigationServer3D.map_get_iteration_id(navmap_id) == 0:
		return
	if navigation_agent_3d.is_navigation_finished():
		return

	movement_delta = delta * speed
	var dest: Vector3 = navigation_agent_3d.get_next_path_position()
	var vel: Vector3 = position.direction_to(dest) * movement_delta
	if navigation_agent_3d.avoidance_enabled:
		navigation_agent_3d.set_velocity(vel)
	else:
		apply_velocity(vel)


func apply_velocity(safe_velocity: Vector3) -> void:
	position = position.move_toward(position + safe_velocity, movement_delta)
