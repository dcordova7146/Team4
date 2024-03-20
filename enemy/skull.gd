## Contributors: James, Karwai

class_name Skull
extends CharacterBody2D

@export var health: int = 50
@export var speed: int = 50
@onready var health_bar: ProgressBar = $HealthBar
## The sibling node player.
@onready var player: Node2D = get_node("../Player")


## Set max value of the health bar to the initial health.
func _ready() -> void:
	health_bar.max_value = health


func _physics_process(_delta: float) -> void:
	# If Player exists, face and move toward player
	if player:
		var direction: Vector2 = (
				global_position.direction_to(player.global_position)
		)
		velocity = direction * speed
		move_and_slide()
	else:
		print("Player node not found!")


# Damage detection function, decrement by the specified damage_total
func take_damage(damage_total: int) -> void:
	health -= damage_total
	Events.health_changed.emit(position, -damage_total)
	# When health is 0 or less, destroy node (kills the mob)
	if health <= 0:
		die()
	# Update health bar to reflect health and display.
	health_bar.value = health
	health_bar.visible = true


## Drop a life and then delete self.
func die() -> void:
	Events.enemy_died.emit(global_position)
	queue_free()
	# Call the overridden function to spawn smaller skulls
	spawn_smaller_skulls()

# Virtual function to be overridden in child classes
func spawn_smaller_skulls() -> void:
	pass
	
func spawn_enemy(enemy_scene_path: String, count: int) -> void:
	var enemy_scene = load(enemy_scene_path) as PackedScene
	var separation_distance = 20
	var spawn_position = global_position

	for i in range(count):
		var enemy_instance = enemy_scene.instantiate()
		if enemy_instance:
			enemy_instance.position = spawn_position
			get_parent().add_child(enemy_instance)
			spawn_position += Vector2(separation_distance, 0)
		else:
			print("Failed to instantiate enemy from scene:", enemy_scene_path)



