#Diego, Karwei
extends Node
#singleton script
#which will keep track of game state and logic

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


# artifact effect signals
signal speed_multiplier(multiplier: float)
signal damage_multiplier(multiplier: float)
signal dangerous_healing()
signal pierce_modifier()
signal reload_speed_multiplier()
signal hydration()
signal range_multiplier()
signal cool_reload()
signal bullet_size_multiplier()


func print(debug:String)->void:
	print(debug)
