#Diego Cordova, Karwei K
class_name Dungeon
extends Node2D

signal game_restarted(dungeon_seed: int)
signal game_exited_to_menu
const LIFE: PackedScene = preload("res://drop/life.tscn")
const HEALTH_CHANGE: PackedScene = preload("res://ui/health_change.tscn")
## Items with a chance to be dropped upon death of enemies.
@export var drop_table: Array[ChanceRow] = []
## The seed of the current dungeon.
var dungeon_seed: int = 0:
	set(new_seed):
		# Only reseed if seed different.
		if new_seed != dungeon_seed:
			dungeon_seed =  new_seed
			hud.seed_label.text = "Seed: %s" % dungeon_seed
			seed(dungeon_seed)
@onready var spawn: Node2D = $Spawn
@onready var player: Node2D = $Player
@onready var minimap: SubViewport = $MinimapViewport
@onready var minimap_camera: Camera2D = $MinimapViewport/MinimapCamera
@onready var hud: HUD = $HUD
@onready var hud_minimap: TextureRect = $HUD/Minimap/TextureRect
@onready var hub_world: Node2D = $Spawn/HubWorld
@onready var main_camera: Camera2D = $Player/MainCamera


func _ready() -> void:
	# Connect minimap viewport to HUD.
	minimap.world_2d = get_viewport().world_2d
	hud_minimap.texture = minimap.get_texture()
	# Listen to events.
	Events.health_changed.connect(_on_health_changed)
	Events.enemy_died.connect(_on_enemy_died)
	Events.teleporter_entered.connect(_on_teleporter_entered)


## Create a dungeon.
func create_dungeon() -> void:
	# Delete all nodes under spawn.
	for i: int in range(0, spawn.get_child_count()):
		spawn.get_child(i).queue_free()
	# Generate dungeon.
	var dungeon: Node2D = GenerateDungeon.generate()
	# Move dungeon to player's position.
	dungeon.global_position = player.global_position
	spawn.call_deferred("add_child", dungeon)


## temp function to see effectiveness of random generation.
func _on_button_pressed() -> void:
	player.position = Vector2(0, 0)
	dungeon_seed = randi_range(-1000,1000)
	create_dungeon()


## Give seed to main, then delete self.
func _on_pause_menu_game_restarted(use_random: bool) -> void:
	# Use same seed unless random seed is specified.
	var new_seed: int = (
			randi_range(0, 1_000_000) 
			if use_random 
			else dungeon_seed
	)
	game_restarted.emit(new_seed, self)


## Pass signal to main, then delete self.
func _on_pause_menu_game_exited_to_menu() -> void:
	game_exited_to_menu.emit()
	queue_free()


var offset: int = 5

## Randomly create drops at given position, with the given rolls.
func _on_enemy_died(death_position: Vector2, rolls: int = 1) -> void:
	Events.enemy_kill_count += 1
	for i: int in rolls:
		for chance_row: ChanceRow in drop_table:
			if randf() < chance_row.chance:
				var instance: Node2D = chance_row.scene.instantiate()
				var offset_position: Vector2 = Vector2(
					randi_range(-offset, offset),
					randi_range(-offset, offset)
				)
				instance.position = death_position + offset_position
				call_deferred("add_child", instance)


func _on_health_changed(pos: Vector2, amount: int) -> void:
	var health_change: HealthChange = HEALTH_CHANGE.instantiate()
	health_change.global_position = pos
	health_change.display(amount)
	add_child(health_change)


## Create dungeon if teleporter entered leads to dungeon.
func _on_teleporter_entered(teleporter: Node2D) -> void:
	if teleporter.name == "DungeonTeleporter":
		Events.level += 1
		# Move camera back to root.
		if player.is_ancestor_of(main_camera):
			player.remove_child(main_camera)
			add_child(main_camera)
		# Create dungeon.
		create_dungeon()
