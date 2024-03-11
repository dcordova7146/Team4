#Diego Cordova
extends Node
#singleton script
#which will keep track of game state and logic

signal player_died
signal room_entered(room: Room)
signal health_changed(lives: int, max_lives: int)
signal enemy_died(position: Vector2)
