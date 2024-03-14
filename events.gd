#Diego Cordova
extends Node
#singleton script
#which will keep track of game state and logic

signal player_died
signal room_entered(room: Room)
signal health_changed(pos: Vector2, amount: int)
signal lives_changed(current_lives: int, max_lives: int)
signal enemy_died(pos: Vector2)
