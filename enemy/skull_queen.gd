extends Skull
## Maximum health points.
const MAX_HEALTH: int = 600
## Speed during phase 2.
var PHASE_2_SPEED: float = 1.25
## Speed during phase 3.
var PHASE_3_SPEED: float = 1.25 * 1.25
## Approximate area of destination.
const DESTINATION_THRESHOLD: float = 10.0
## Distinct phases. Determines speed and number of skulls spawned.
enum Phase {
	_1,
	_2,
	_3
}
## Current phase.
var phase: Phase = Phase._1
## Flag for wake-up. Lets player move before saving location and starting movement.
var begin_movement: bool = false
## Flag for timer being called.
var wake_timer_called: bool = false
## If reached x-coordinate destination.
var reached_destination_x: bool = false
## If reached y-coordinate destination.
var reached_destination_y: bool = false
## If reached final destination.
var reached_final_destination: bool = false
## Location of player to move to.
var target_location: Vector2 = Vector2()
## Names of skulls that can be randomly spawned.
var skull_types: Array[String] = [
		"skull_small", "skull_medium", "skull_bomb", "skull_frost"
]
## Times how long it sleeps between movements.
@onready var move_timer: Timer = $MoveTimer
## Times how long it sleeps when entering the room.
@onready var wake_timer: Timer = $WakeTimer
## Collision polygon.
## Disabled when sleeping, preventing any damage from being taken.
@onready var collision_polygon: CollisionPolygon2D = $CollisionPolygon2D
## Sprites for each phase and sleep status.
@onready var phase_1: Sprite2D = $Phase1
@onready var phase_1_sleep: Sprite2D = $Phase1Sleep
@onready var phase_2: Sprite2D = $Phase2
@onready var phase_2_sleep: Sprite2D = $Phase2Sleep
@onready var phase_3: Sprite2D = $Phase3
@onready var phase_3_sleep: Sprite2D = $Phase3Sleep


func _ready() -> void:
	# Set initial health to maximum.
	health = MAX_HEALTH
	# Set movement speed.
	speed = 1
	# Call base class _ready function.
	super._ready()
	update_health_bar()
	collision_polygon.disabled = true


func _physics_process(_delta: float) -> void:
	if not player or not awake:
		return
	if not wake_timer_called:
		wake_timer.start()
		wake_timer_called = true 
	if begin_movement:
		var direction: Vector2 = (target_location - global_position).sign()
		if not reached_destination_x:
			# Move to target x-coordinate.
			move_local_x(speed * direction.x)
			# Check if the Queen reached the target X coordinate
			if abs(target_location.x - global_position.x) < DESTINATION_THRESHOLD:
				reached_destination_x = true
		elif not reached_destination_y:
			# Move to target y-coordinate.
			move_local_y(speed * direction.y)
			# Check if the Queen reached the target Y coordinate
			if abs(target_location.y - global_position.y) < DESTINATION_THRESHOLD:
				reached_destination_y = true
		elif not reached_final_destination:
			reached_final_destination = true
			move_timer.start()
			change_sprites()
			collision_polygon.disabled = true
			health_bar.visible = false
			spawn_random_skull()
	else:
		pass


## Wake up, start moving, and allow player to damage it.
func wake() -> void:
	collision_polygon.disabled = false
	health_bar.visible = true
	change_sprites()
	# Starting moving to player's position.
	reached_destination_x = false
	reached_destination_y = false
	reached_final_destination = false
	target_location = player.global_position
	begin_movement = true


## Toggle sprite from sleep to not asleep variation.
func change_sprites() -> void:
	if phase == Phase._1:
		phase_1_sleep.visible = phase_1.visible
		phase_1.visible = not phase_1.visible
	elif phase == Phase._2:
		phase_2_sleep.visible = phase_2.visible
		phase_2.visible = not phase_2.visible
	else:
		phase_3_sleep.visible = phase_3.visible
		phase_3.visible = not phase_3.visible


## Update health bar value.
func update_health_bar() -> void:
	if health_bar:
		health_bar.value = health


## Spawn a number of skulls.
func spawn_random_skull() -> void:
	var number_of_skulls: int = 0
	if phase == Phase._1: 
		number_of_skulls = 1
	elif phase == Phase._2:
		number_of_skulls = 2
	else:
		number_of_skulls = 3
	
	for i: int in range(number_of_skulls):
		# Deciding and Loading Random Skull
		var random_skull_type: String = skull_types[randi() % skull_types.size()]
		var random_skull_path: String = "res://enemy/" + random_skull_type + ".tscn"
		var random_skull_resource: PackedScene = load(random_skull_path)
		
		var offset: int = 25
		var room: Room = get_parent()
		var enemy_instance: Skull = random_skull_resource.instantiate()
		if enemy_instance and room:
			var random_offset: Vector2 = Vector2(
					randf_range(-offset, offset),
					randf_range(-offset, offset)
			)
			var spawn_position: Vector2 = position + random_offset
			enemy_instance.position = spawn_position
			enemy_instance.awake = true
			room.add_enemy(enemy_instance)
		else:
			push_error(
					"Failed to instantiate enemy from path: ",
					random_skull_path
			)


## Update phase when is damage taken.
func take_damage(damage_total: float) -> void:
	super.take_damage(damage_total)
	if health > MAX_HEALTH * 2/3:
		pass
	elif health > MAX_HEALTH * 1/3:
		phase = Phase._2
		speed = PHASE_2_SPEED
		phase_1.visible = false
		phase_2.visible = true
	else:
		phase = Phase._3
		speed = PHASE_3_SPEED
		phase_2.visible = false
		phase_3.visible = true


## Drop more loot than normal enemies.
func die() -> void:
	var offset: int = 12
	# Emit events with randomly adjusted positions
	for i: int in range(12):
		Events.enemy_died.emit(
				global_position + Vector2(
						randf_range(-offset, offset),
						randf_range(-offset, offset)
				)
		)
	Events.enemy_defeated.emit(self)
	queue_free()
	if spawn_count > 0:
		spawn_enemy(enemy_to_spawn, spawn_count)


func _on_move_timer_timeout() -> void:
	wake()


func _on_wake_timer_timeout() -> void:
	wake()
