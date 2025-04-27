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
@onready var hitbox: Area3D = $Head/Hitbox

@onready var audio_footstep: AudioStreamPlayer3D = $Footsteps/AudioFootstep

var game_over: bool
var input_dir: Vector3
var item_in_hand: MyHoldableItem
var item_in_reach: bool
var footsteps_dist: float


func _ready() -> void:
	game_over = false

	input_dir = Vector3.ZERO
	item_in_hand = null
	item_in_reach = false
	footsteps_dist = 0.0

	audio_footstep.stream = AudioManager.sound_effects[AudioManager.SOUND_EFFECT.FOOTSTEP]


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


func _process(_delta: float) -> void:
	if game_over:
		return

	raycast_check()
	footsteps_sounds()


func _physics_process(delta: float) -> void:
	if game_over:
		return

	get_input()

	var target_velocity: Vector3 = input_dir * move_speed

	if input_dir.length() > 0:
		velocity = velocity.move_toward(target_velocity, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector3.ZERO, friction * delta)

	velocity.y = -10.0

	var prev_position: Vector3 = global_position
	move_and_slide()

	var distance: float = prev_position.distance_to(global_position)
	if is_zero_approx(distance) or is_zero_approx(input_dir.length()):
		footsteps_dist = 0.0
	else:
		footsteps_dist += distance


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
				if item_in_hand is MyShootingItem:
					(item_in_hand as MyShootingItem).stop_shooting()
				item_in_hand = ((collider as Area3D).owner as MyShelf).swap_item(hand, item_in_hand)


func footsteps_sounds() -> void:
	if footsteps_dist > 3.0:
		footsteps_dist -= 3.0
		audio_footstep.pitch_scale = randf_range(0.9, 1.1)
		audio_footstep.play()


func raycast_check() -> void:
	if ray_cast_3d.is_colliding():
		var collider: Object = ray_cast_3d.get_collider()
		if collider is Area3D:
			if (collider as Area3D).get_collision_layer_value(Constants.COLLISION_LAYERS.ITEMS):
				if not item_in_reach:
					item_in_reach = true
					EventBus.item_in_reach.emit(true)
	else:
		if item_in_reach:
			item_in_reach = false
			EventBus.item_in_reach.emit(false)


func _on_hitbox_area_entered(area: Area3D) -> void:
	if area.get_collision_layer_value(Constants.COLLISION_LAYERS.ENEMIES):
		EventBus.enemy_in_reach.emit(true)
	if area.get_collision_layer_value(Constants.COLLISION_LAYERS.FLOWER):
		EventBus.flower_in_reach.emit(true)


func _on_hitbox_area_exited(area: Area3D) -> void:
	if area.get_collision_layer_value(Constants.COLLISION_LAYERS.ENEMIES):
		EventBus.enemy_in_reach.emit(false)
	if area.get_collision_layer_value(Constants.COLLISION_LAYERS.FLOWER):
		EventBus.flower_in_reach.emit(false)
