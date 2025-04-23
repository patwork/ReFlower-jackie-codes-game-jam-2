class_name MyPlayer
extends CharacterBody3D

@export var mouse_sensitivity: float = 0.2
@export var move_speed: float = 8.0
@export var acceleration: float = 40.0
@export var friction: float = 20.0

@onready var head: Node3D = $Head
@onready var hand: Marker3D = $Head/Hand
@onready var camera: Camera3D = $Head/Camera3D
@onready var ray_cast_3d: RayCast3D = $Head/RayCast3D

var input_dir: Vector3
var item_in_hand: MyHoldableItem


func _ready() -> void:
	input_dir = Vector3.ZERO
	item_in_hand = null


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var event_mouse: InputEventMouseMotion = event as InputEventMouseMotion
		rotate_y(deg_to_rad(-event_mouse.relative.x * mouse_sensitivity))
		head.rotate_x(deg_to_rad(-event_mouse.relative.y * mouse_sensitivity))
		head.rotation.x = clampf(head.rotation.x, deg_to_rad(-90.0), deg_to_rad(90.0))
	elif event.is_action_released("shoot"):
		shoot()
	elif event.is_action_released("interact"):
		interact()


func _physics_process(delta: float) -> void:
	get_input()

	var target_velocity: Vector3 = input_dir * move_speed

	if input_dir.length() > 0:
		velocity = velocity.move_toward(target_velocity, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector3.ZERO, friction * delta)

	move_and_slide()


func get_input() -> void:
	input_dir = Vector3.ZERO

	var forward: Vector3 = -transform.basis.z
	var right: Vector3 = transform.basis.x

	if Input.is_action_pressed("move_forward"):
		input_dir += forward
	if Input.is_action_pressed("move_back"):
		input_dir -= forward
	if Input.is_action_pressed("move_left"):
		input_dir -= right
	if Input.is_action_pressed("move_right"):
		input_dir += right

	input_dir = input_dir.normalized()


func shoot() -> void:
	if item_in_hand and item_in_hand is MyShootingItem:
		(item_in_hand as MyShootingItem).start_shooting()


func interact() -> void:
	if ray_cast_3d.is_colliding():
		var collider: Object = ray_cast_3d.get_collider()
		if collider is Area3D:
			if (collider as Area3D).owner is MyShelf:
				item_in_hand = ((collider as Area3D).owner as MyShelf).swap_item(hand, item_in_hand)
