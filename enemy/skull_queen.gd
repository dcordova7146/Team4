extends Skull

const MAX_HEALTH: int = 250  # Maximum health points
const DESTINATION_THRESHOLD = 5 # Approximate area of destination

var begin_movement: bool = false # Flag for Queen wake-up, lets player move before saving location and starting movement.
var wake_timer_called: bool = false # Flag for timer being called
var reached_destination_x: bool = false  # Flag to indicate if Queen reached destination Xcord.
var reached_destination_y: bool = false  # Flag to indicate if Queen reached destination Ycord.
var reached_final_destination: bool = false # Flad to indicate if Queen reached final destination.
var target_location: Vector2 = Vector2() # Record player location that Queen will move to.

@onready var move_timer: Timer = $MoveTimer
@onready var find_timer: Timer = $FindTimer
@onready var collision: CollisionPolygon2D = $CollisionPolygon2D

func _ready() -> void:
	health = MAX_HEALTH  # Set initial health to maximum
	speed = 0.25  # Movement speed
	super._ready()  # Call base class _ready function
	update_health_bar()
	$CollisionPolygon2D.disabled = true

func _physics_process(_delta: float) -> void:
	if player and awake and !wake_timer_called:
		print("\nWake Timer Started!")
		$WakeTimer.start()
		wake_timer_called = true 
	
	if player and awake and begin_movement: ## RE-ADD AWAKE BOOl
		if !reached_destination_x:
			# Move towards the target X coordinate
			if target_location.x < global_position.x:
				move_local_x(-speed)
			else:
				move_local_x(speed)
			# Check if the Queen reached the target X coordinate
			if abs(target_location.x - global_position.x) < DESTINATION_THRESHOLD:
				reached_destination_x = true
				print("Queen reached target X coordinate")
		
		elif !reached_destination_y and reached_destination_x:
			# Move towards the target Y coordinate
			if target_location.y < global_position.y:
				move_local_y(-speed)
			else:
				move_local_y(speed)
			# Check if the Queen reached the target Y coordinate
			if abs(target_location.y - global_position.y) < DESTINATION_THRESHOLD:
				reached_destination_y = true
				print("Queen reached target Y coordinate")
		elif reached_destination_x and reached_destination_y and !reached_final_destination:
			print("Queen has arrived at the target location")
			reached_final_destination = true
			print("Movement Cycle Ends, Move Timer Begins")
			$MoveTimer.start()
			$SkullQueenBite1.visible = false
			$SkullQueenSleep.visible = true
			$CollisionPolygon2D.disabled = true
			$HealthBar.visible = false
	else:
		pass

func spawn_tombstone():
	var separation_distance: int = 20
	var spawn_position: Vector2 = position
	var room = get_parent()
	var enemy_instance = preload("res://enemy/cursed_tombstone.tscn").instantiate()
	if enemy_instance and room:
		enemy_instance.position = spawn_position
		spawn_position += Vector2(separation_distance, 10)
		enemy_instance.awake = true
		room.enemies.append(enemy_instance)
		room.call_deferred("add_child", enemy_instance)
	else:
		print("Failed to instantiate enemy from scene: Cursed Tombstone", )

func update_health_bar() -> void:
	if health_bar:
		health_bar.value = health  # Update health bar value

func die() -> void: # Emit 3 Hearts, b/c Queen is a Boss
	var offset: int = 10
	# Emit events with randomly adjusted positions
	for i in range(3):
		Events.enemy_died.emit(global_position + Vector2(randf_range(-offset, offset), randf_range(-offset, offset)))
	Events.enemy_defeated.emit(self)
	queue_free()
	if spawn_count > 0:
		spawn_enemy(enemy_to_spawn, spawn_count)

func _on_move_timer_timeout():
	# Reset movement flags and record new target location
	print("\nMove Timer Ends")
	reached_destination_x = false
	reached_destination_y = false
	reached_final_destination = false
	print("New Target Location Saved")
	target_location = player.global_position
	# Modify sprites and collisions
	$SkullQueenSleep.visible = false
	$SkullQueenBite1.visible = true
	$CollisionPolygon2D.disabled = false
	$HealthBar.visible = true

func _on_wake_timer_timeout():
	print("\nWake Timer Ends")
	# Change to Awake Sprite
	$SkullQueenSleep.visible = false
	$SkullQueenBite1.visible = true
	$CollisionPolygon2D.disabled = false
	$HealthBar.visible = true
	# Save Player Location
	target_location = player.global_position
	# Begin Movement Cycle, (set Flag to True)
	begin_movement = true
	print("Target Location Saved, Movement Cycle Begins") 

