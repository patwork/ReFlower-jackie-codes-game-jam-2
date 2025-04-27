class_name MyPlayer
extends CharacterBody3D

@export var initial_health: int = 6

@export var mouse_sensitivity: float = 0.2
@export var move_speed: float = 8.0
@export var acceleration: float = 40.0
@export var friction: float = 20.0

@onready var head: Node3D = $Head
@onready var hand: Marker3D = $Head/Hand
@onready var camera: Camera3D = $Head/Camera3D
@onready var ray_cast_3d: RayCast3D = $Head/RayCast3D
@onready var hitbox: Area3D = $Head/Hitbox
@onready var shooting_tick: Timer = $ShootingTick

@onready var audio_footstep: AudioStreamPlayer3D = $Footsteps/AudioFootstep
@onready var audio_hit: AudioStreamPlayer3D = $AudioHit
@onready var audio_pain_1: AudioStreamPlayer3D = $Pain/AudioPain1

var game_over: bool
var health: int
var input_dir: Vector3
var item_in_hand: MyHoldableItem
var item_in_reach: bool
var flower_in_reach: bool
var enemies_in_reach: Array[MyEnemy]
var footsteps_dist: float


func _ready() -> void:
	game_over = false
	health = initial_health

	input_dir = Vector3.ZERO
	item_in_hand = null
	item_in_reach = false
	flower_in_reach = false
	enemies_in_reach.clear()
	footsteps_dist = 0.0

	EventBus.enemy_died.connect(self.on_enemy_died)
	EventBus.player_hit.connect(self.on_player_hit)

	audio_footstep.stream = AudioManager.sound_effects[AudioManager.SOUND_EFFECT.FOOTSTEP]
	audio_hit.stream = AudioManager.sound_effects[AudioManager.SOUND_EFFECT.HIT]

	audio_pain_1.stream = AudioManager.sound_effects[AudioManager.SOUND_EFFECT.PAIN1]

	call_deferred("on_change_health")


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
	if game_over:
		return

	if item_in_hand and item_in_hand is MyShootingItem:
		(item_in_hand as MyShootingItem).start_shooting()


func interact() -> void:
	if game_over:
		return

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


func on_enemy_died(enemy: MyEnemy) -> void:
	if enemy in enemies_in_reach:
		enemies_in_reach.erase(enemy)


func on_player_hit(strength: int) -> void:
	if game_over:
		return

	health = maxi(health - strength, 0)
	if health == 0:
		EventBus.game_lose.emit()

	if not audio_pain_1.playing:
		audio_pain_1.pitch_scale = randf_range(0.9, 1.1)
		audio_pain_1.play()

	on_change_health()


func on_change_health() -> void:
	EventBus.player_hp_update.emit(health)


func _on_shooting_tick_timeout() -> void:
	if not item_in_hand:
		return
	if not item_in_hand is MyShootingItem:
		return
	if not (item_in_hand as MyShootingItem).is_shooting():
		return

	var success: bool = false
	var variation: Constants.ENTITIES_VARIATIONS = (item_in_hand as MyShootingItem).color_variation

	if variation == Constants.ENTITIES_VARIATIONS.WATER and flower_in_reach:
		success = true
		EventBus.flower_watered.emit()

	if not enemies_in_reach.is_empty():
		for enemy: MyEnemy in enemies_in_reach:
			if is_instance_valid(enemy):
				if enemy.color_variation == variation:
					success = true
					enemy.hurt()
			else:
				push_warning("enemy was not removed from enemies_in_reach")

	if success:
		audio_hit.play()


func _on_hitbox_area_entered(area: Area3D) -> void:
	if area.get_collision_layer_value(Constants.COLLISION_LAYERS.ENEMIES):
		if area.owner is MyEnemy:
			if area.owner not in enemies_in_reach:
				enemies_in_reach.append(area.owner as MyEnemy)
		EventBus.enemy_in_reach.emit(true)
	if area.get_collision_layer_value(Constants.COLLISION_LAYERS.FLOWER):
		flower_in_reach = true
		EventBus.flower_in_reach.emit(true)


func _on_hitbox_area_exited(area: Area3D) -> void:
	if area.get_collision_layer_value(Constants.COLLISION_LAYERS.ENEMIES):
		if area.owner is MyEnemy:
			if area.owner in enemies_in_reach:
				enemies_in_reach.erase(area.owner as MyEnemy)
		EventBus.enemy_in_reach.emit(false)
	if area.get_collision_layer_value(Constants.COLLISION_LAYERS.FLOWER):
		flower_in_reach = false
		EventBus.flower_in_reach.emit(false)
