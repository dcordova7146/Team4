#Diego Cordova
class_name Dungeon
extends Node2D

signal game_restarted
signal game_exited_to_menu

const LIFE: PackedScene = preload("res://drop/life.tscn")
const HEALTH_CHANGE: PackedScene = preload("res://ui/health_change.tscn")

@onready var spawn: Node2D = $Spawn
@onready var lives: Lives = $HUD/Lives


func _ready() -> void:
	Events.health_changed.connect(_on_health_changed)
	visualize(GenerateDungeon.generate(randi_range(-1000,1000)))
	Events.enemy_died.connect(_on_enemy_died)

#visualize function is used to turn the data structure that is the dungeon into a real in game scene of rooms
func visualize(dungeon: Dictionary) -> void:
	for i: int in range(0, spawn.get_child_count()):
		spawn.get_child(i).queue_free()
		
	for key: Vector2 in dungeon.keys():
		var room: Node2D = dungeon[key]
		spawn.add_child(room)

#temp function to see effectiveness of random generation
func _on_button_pressed() -> void:
	randomize()
	$Player.position =Vector2(0,0) #whenever generate a room reset player to start room
	visualize(GenerateDungeon.generate(randi_range(-1000,1000)))

#Karwei
## Pass signal to main, then delete self.
func _on_pause_menu_game_restarted() -> void:
	game_restarted.emit()
	queue_free()


## Pass signal to main, then delete self.
func _on_pause_menu_game_exited_to_menu() -> void:
	game_exited_to_menu.emit()
	queue_free()


## Spawn life pickup at position of where enemy died.
func _on_enemy_died(pos: Vector2) -> void:
	var life: Node2D = LIFE.instantiate()
	life.position = pos
	add_child(life)


func _on_health_changed(pos: Vector2, amount: int) -> void:
	var health_change: HealthChange = HEALTH_CHANGE.instantiate()
	health_change.position = pos
	health_change.display(amount)
	add_child(health_change)


