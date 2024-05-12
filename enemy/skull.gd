## Contributors: James, Karwai

class_name Skull
extends CharacterBody2D

signal defeated(enemy: Skull)

@export var health: float = 50
@export var speed: float = 50
## The enemy to spawn on death.
@export var enemy_to_spawn: PackedScene
## The amount of enemies to spawn on death.
@export var spawn_count: int = 0
@onready var health_bar: ProgressBar = $HealthBar
## The sibling node player.
@onready var player: Player = get_node("/root/Main/Dungeon/Player")
var awake: bool = false
@onready var on_hit_animation: AnimationPlayer = $OnHitAnimation

## Set max value of the health bar to the initial health.
func _ready() -> void:
	health_bar.max_value = health


func _physics_process(_delta: float) -> void:
	# If Player exists, face and move toward player
	if player and awake:
		var direction: Vector2 = (
				global_position.direction_to(player.global_position)
		)
		velocity = direction * speed
		move_and_slide()
	else:
		pass
		#print("Player node not found!")


# Damage detection function, decrement by the specified damage_total
func take_damage(damage_total: float) -> void:
	health -= damage_total
	Events.health_changed.emit(global_position, -damage_total)
	# When health is 0 or less, destroy node (kills the mob)
	if health <= 0:
		die()
	# Update health bar to reflect health and display.
	health_bar.value = health
	health_bar.visible = true
	on_hit_animation.play("on_hit")

## Drop a life and then delete self.
func die() -> void:
	Events.enemy_died.emit(global_position)
	defeated.emit(self)
	queue_free()
	if spawn_count > 0:
		spawn_enemy(enemy_to_spawn, spawn_count)

	
#func spawn_enemy(enemy_scene_path: PackedScene, count: int) -> void:
	#var separation_distance: int = 20
	#var spawn_position: Vector2 = position
#
	#for i: int in range(count):
		#var room: Room = get_parent()
		#var enemy_instance: Skull = enemy_scene_path.instantiate()
		#if enemy_instance and room:
			#enemy_instance.position = spawn_position
			#spawn_position += Vector2(separation_distance, 10)
			#enemy_instance.awake = true
			#room.add_enemy(enemy_instance)
		#else:
			#print("Failed to instantiate enemy from scene:", enemy_scene_path)

func spawn_enemy(enemy_scene_path: PackedScene, count: int) -> void:
	var offset: int = 20

	for i in range(count):
		var room: Room = get_parent()  # Call get_parent() inside the loop
		var enemy_instance: Skull = enemy_scene_path.instantiate()
		if enemy_instance and room:
			var random_offset = Vector2(randf_range(-offset, offset), randf_range(-offset, offset))
			var spawn_position: Vector2 = position + random_offset
			enemy_instance.position = spawn_position
			enemy_instance.awake = true
			room.add_enemy(enemy_instance)
		else:
			print("Failed to instantiate enemy from scene:", enemy_scene_path)


