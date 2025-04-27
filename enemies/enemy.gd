class_name MyEnemy
extends Node3D

@export var color_variation: Constants.ENTITIES_VARIATIONS
@export var enemy_type: Constants.ENEMY_TYPE
@export var initial_health: int

@onready var awareness: Area3D = $Awareness
@onready var ai: MyStateMachine = $AI

var is_alive: bool
var health: int
var velocity: Vector3
var destination: Vector3

var player_ref: MyPlayer


func _ready() -> void:
	is_alive = true
	health = initial_health
	velocity = Vector3.ZERO
	destination = Vector3.ZERO

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
	call_deferred("queue_free")
