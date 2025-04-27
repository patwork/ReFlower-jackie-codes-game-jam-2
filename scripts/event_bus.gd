class_name MyEventBus
extends Node

@warning_ignore("unused_signal")
signal game_start

@warning_ignore("unused_signal")
signal game_win

@warning_ignore("unused_signal")
signal game_lose

@warning_ignore("unused_signal")
signal flower_in_reach(state: bool)

@warning_ignore("unused_signal")
signal item_in_reach(state: bool)

@warning_ignore("unused_signal")
signal enemy_in_reach(state: bool)

@warning_ignore("unused_signal")
signal flower_health_update(health: float, color: Color)

@warning_ignore("unused_signal")
signal flower_water_update(water: float, color: Color)

@warning_ignore("unused_signal")
signal player_hp_update(hp: float)

@warning_ignore("unused_signal")
signal flower_watered()

@warning_ignore("unused_signal")
signal enemy_hit(enemy: MyEnemy)

@warning_ignore("unused_signal")
signal enemy_died(enemy: MyEnemy)

@warning_ignore("unused_signal")
signal player_hit(strength: int)
