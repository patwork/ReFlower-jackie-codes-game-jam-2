class_name MyFlower
extends StaticBody3D

# water < 25 - flower dying
# water < 50 - flower stable
# water < 100 - flower growing
# water < 125 - flower stable
# water > 125 - flower dying

@export var grow_speed: float = 0.5
@export var dry_speed: float = 1.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var update_tick: Timer = $UpdateTick

const ANIM_GROW : StringName = &"ArmatureAction"

var game_over: bool
var flower_health: float
var flower_water: float

var _animation_length: float


func _ready() -> void:
	game_over = false

	flower_health = 0.0
	flower_water = 75.0

	EventBus.flower_watered.connect(self.on_flower_watered)

	_animation_length = animation_player.get_animation(ANIM_GROW).length
	seek_animation(0.0)

	_on_update_tick_timeout.call_deferred()


func seek_animation(percent: float) -> void:
	animation_player.play(ANIM_GROW)
	animation_player.seek((_animation_length / 100.0) * percent, true, true)
	animation_player.pause()


func flower_grown() -> void:
	EventBus.game_win.emit()


func flower_died() -> void:
	EventBus.game_lose.emit()


func on_flower_watered() -> void:
	flower_water = clampf(flower_water + 1.0, 0.0, 200.0)
	EventBus.flower_water_update.emit(flower_water, Color.BLUE)


func _on_update_tick_timeout() -> void:
	if game_over:
		return

	var delta: float = update_tick.wait_time
	var color: Color = Color.WHITE

	flower_water = clampf(flower_water - dry_speed * delta, 0.0, 200.0)

	if flower_water < 25.0 or flower_water > 125.0:
		flower_health -= grow_speed * delta
		color = Color.CORAL
		if flower_health < 0.0:
			flower_died.call_deferred()
	elif flower_water > 50.0 and flower_water < 100.0:
		flower_health += grow_speed * delta
		color = Color.LIGHT_GREEN
		if flower_health > 100.0:
			flower_grown.call_deferred()

	flower_health = clampf(flower_health, 0.0, 100.0)

	EventBus.flower_health_update.emit(flower_health, color)
	EventBus.flower_water_update.emit(flower_water, color)

	seek_animation(flower_health)
