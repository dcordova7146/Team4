## Contributors: James, Karwai
class_name Skull
extends CharacterBody2D

## Signal self on death as well as the amount of rolls for drops.
signal defeated(enemy: Skull, rolls: int)
## Decreases upon contact with player-fired bullets.
@export var health: float = 50
## Multiplier of velocity.
@export var speed: float = 50
## Enemy to spawn on death.
@export var enemy_to_spawn: PackedScene
## Amount of enemies to spawn on death.
@export var spawn_count: int = 0
## General range in which to spawn enemies around death position.
@export var spawn_offset: int = 20
## Scene of bone (enemy bullet).
@export var bone_scene: PackedScene
## Sprite node to modulate upon waking.
@onready var sprite: Sprite2D = $Sprite2D
## Collision shape to disable so other enemies may walk through.
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
## Displays the current health.
@onready var health_bar: ProgressBar = $HealthBar
## Player node to get position to go towards.
@onready var player: Player = get_node("/root/Main/Dungeon/Player")
## Animation player to run upon taking damage.
@onready var on_hit_animation: AnimationPlayer = $OnHitAnimation
## Whether it moves and collides (i.e. takes damage).
var awake: bool = false:
	set = set_awake
## Whether it takes damage.
var is_invincible: bool = false:
	set(new_state):
		is_invincible = new_state
		health_bar.visible = not is_invincible


## Set max value of the health bar to the initial health.
func _ready() -> void:
	health_bar.max_value = health
	health_bar.value = health
	await get_tree().create_timer(1).timeout
	awake = true


## If Player exists, move toward player.
func _physics_process(_delta: float) -> void:
	if awake and player:
		var direction: Vector2 = (
				global_position.direction_to(player.global_position)
		)
		velocity = direction * speed
		move_and_slide()


func set_awake(new_state: bool) -> void:
	awake = new_state
	if collision_shape:
		collision_shape.disabled = not awake
	if health_bar:
		health_bar.visible = awake
	if awake and sprite:
			sprite.modulate = Color.WHITE
	elif sprite:
			sprite.modulate = Color.GRAY


## Decrement health by given amount.
func take_damage(damage_total: float) -> void:
	if is_invincible or not awake:
		return
	health -= damage_total
	Events.health_changed.emit(global_position, -damage_total)
	# When health is 0 or less, destroy node (kills the mob)
	if health <= 0:
		die()
	# Update health bar to reflect health and display.
	health_bar.value = health
	health_bar.visible = true
	# Flash white.
	on_hit_animation.play("on_hit")


## Spawn enemies if applicable and then delete self.
func die() -> void:
	if spawn_count > 0:
		spawn_enemy(enemy_to_spawn, spawn_count)
	Events.enemy_died.emit(global_position)
	defeated.emit(self)
	queue_free()


## Instantiate a given number of a given scene and add to the same room.
func spawn_enemy(enemy_scene_path: PackedScene, count: int) -> void:
	for i: int in range(count):
		var room: Room = get_parent()
		var enemy_instance: Skull = enemy_scene_path.instantiate()
		if not enemy_instance or not room:
			push_error(
					"Failed to instantiate enemy from scene: ",
					 enemy_scene_path
			)
		var random_offset: Vector2 = Vector2(
				randf_range(-spawn_offset, spawn_offset),
				randf_range(-spawn_offset, spawn_offset)
		)
		var spawn_position: Vector2 = position + random_offset
		enemy_instance.position = spawn_position
		room.add_enemy(enemy_instance)


## Spawn a bone with a given rotation at this position.
func shoot_bone(rotation_: float) -> void:
	var bone: Bone = bone_scene.instantiate()
	bone.rotation = rotation_
	bone.position = position
	get_parent().add_child(bone)
