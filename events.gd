#Diego, Karwei
extends Node
#singleton script
## Keeps track of game state and logic.
signal player_died
signal room_entered(room: Room)
signal active_weapon_changed(new_weapon: Gun)
signal waveCleared
signal health_changed(position: Vector2, amount: int)
signal lives_changed(current_lives: int, max_lives: int)
signal enemy_died(position: Vector2)
signal enemy_defeated(enemy: Node)
signal takeable_group_changed
signal teleporter_entered(teleporter: Node2D)
signal blood_count_changed(new_count: int)
signal choiceBegun(body: Node2D)
## Artifact effect signals.
signal speed_multiplier(multiplier: float)
signal damage_multiplier(multiplier: float)
signal dangerous_healing()
signal pierce_modifier()
signal reload_speed_multiplier()
signal hydration()
signal range_multiplier()
signal cool_reload()
signal bullet_size_multiplier()
## Run stats.
signal level_changed(new_value: int)
signal enemy_kill_count_changed(new_value: int)
signal room_clear_count_changed(new_value: int)

var level: int = 0:
	set(new_value):
		level = new_value
		level_changed.emit(new_value)
var enemy_kill_count: int = 0:
	set(new_value):
		enemy_kill_count = new_value
		enemy_kill_count_changed.emit(new_value)
var room_clear_count: int = 0:
	set(new_value):
		room_clear_count = new_value
		room_clear_count_changed.emit(new_value)


func print(debug:String)->void:
	print(debug)
