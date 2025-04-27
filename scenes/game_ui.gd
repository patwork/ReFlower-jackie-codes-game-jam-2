class_name MyGameUI
extends CanvasLayer

@onready var label_health: Label = $MarginContainer/LabelHealth
@onready var label_water: Label = $MarginContainer/LabelWater
@onready var label_hp: Label = $MarginContainer/LabelHP

@onready var game_win: Label = $MarginContainer/GameWin
@onready var game_lose: Label = $MarginContainer/GameLose

@onready var crosshair: TextureRect = $MarginContainer/Crosshair
@onready var water_can_icon: TextureRect = $MarginContainer/WaterCanIcon
@onready var hand_icon: TextureRect = $MarginContainer/HandIcon

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	crosshair.modulate = Color("#ffffff80")
	water_can_icon.visible = false
	hand_icon.visible = false

	EventBus.flower_health_update.connect(self.on_flower_health_update)
	EventBus.flower_water_update.connect(self.on_flower_water_update)
	EventBus.player_hp_update.connect(self.on_player_hp_update)

	EventBus.enemy_in_reach.connect(self.on_enemy_in_reach)
	EventBus.flower_in_reach.connect(self.on_flower_in_reach)
	EventBus.item_in_reach.connect(self.on_item_in_reach)

	EventBus.player_hit.connect(self.on_player_hit)


func on_flower_health_update(health: float, color: Color) -> void:
	label_health.text = "GROWTH %d%%" % roundi(health)
	label_health.modulate = color


func on_flower_water_update(water: float, color: Color) -> void:
	label_water.text = "WATER %d%%" % roundi(water)
	label_water.modulate = color


func on_player_hp_update(hp: int) -> void:
	# FIXME label_hp.text = "♥".repeat(hp)
	if hp > 0:
		label_hp.text = "HEALTH".substr(0, hp)
	else:
		label_hp.text = "- RIP -"


func on_enemy_in_reach(state: bool) -> void:
	if state:
		crosshair.modulate = Color("#ff000080")
	else:
		crosshair.modulate = Color("#ffffff80")


func on_flower_in_reach(state: bool) -> void:
	water_can_icon.visible = state


func on_item_in_reach(state: bool) -> void:
	hand_icon.visible = state


func on_player_hit(_strength: int) -> void:
	animation_player.play("blood_flash")


func show_win_screen() -> void:
	crosshair.visible = false
	water_can_icon.visible = false
	hand_icon.visible = false
	game_win.visible = true


func show_loose_screen() -> void:
	crosshair.visible = false
	water_can_icon.visible = false
	hand_icon.visible = false
	game_lose.visible = true
