class_name MyEnemy
extends Node3D

enum ENEMY_TYPE {
	WORM,
	BEETLE,
	WASP
}

@export var model: Node3D

@onready var ai: MyStateMachine = $AI

var enemy_type: ENEMY_TYPE
var color_variation: Constants.COLOR_VARIATIONS
var is_alive: bool
var health: int

var velocity: Vector3
var destination: Vector3
