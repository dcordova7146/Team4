extends Skull

const MAX_HEALTH: int = 600  # Maximum health points
const DESTINATION_THRESHOLD: float = 10.0 # Approximate area of destination

var is_phase_2: bool = false # Flag for Queen 2nd Phase
var is_phase_3: bool = false # Flag for Queen 3rd Phase
var begin_movement: bool = false # Flag for Queen wake-up, lets player move before saving location and starting movement.
var wake_timer_called: bool = false # Flag for timer being called
var reached_destination_x: bool = false  # Flag to indicate if Queen reached destination Xcord.
var reached_destination_y: bool = false  # Flag to indicate if Queen reached destination Ycord.
var reached_final_destination: bool = false # Flag to indicate if Queen reached final destination.
var target_location: Vector2 = Vector2() # Record player location that Queen will move to.

@onready var move_timer: Timer = $MoveTimer
@onready var wake_timer: Timer = $WakeTimer
@onready var collision_polygon: CollisionPolygon2D = $CollisionPolygon2D
@onready var phase_1: Sprite2D = $Phase1
@onready var phase_1_sleep: Sprite2D = $Phase1Sleep
@onready var phase_2: Sprite2D = $Phase2
@onready var phase_2_sleep: Sprite2D = $Phase2Sleep
@onready var phase_3: Sprite2D = $Phase3
@onready var phase_3_sleep: Sprite2D = $Phase3Sleep

func _ready() -> void:
	health = MAX_HEALTH  # Set initial health to maximum
	speed = 1 # Movement speed
	super._ready()  # Call base class _ready function
	update_health_bar()
	collision_polygon.disabled = true

func _physics_process(_delta: float) -> void:
	if player and awake and !wake_timer_called:
		print("\nWake Timer Started!")
		wake_timer.start()
		wake_timer_called = true 
	if player and awake and begin_movement: ## RE-ADD AWAKE BOOl
		change_phases()
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
			move_timer.start()
			change_sprites()
			collision_polygon.disabled = true
			health_bar.visible = false
			spawn_random_skull()
	else:
		pass

func change_phases() -> void:
	if health <= MAX_HEALTH * 2/3 and !is_phase_2: 
		is_phase_2 = true
		phase_1.visible = false
		phase_2.visible = true
		speed = speed * 1.25
	if health <= MAX_HEALTH * 1/3 and is_phase_2 and !is_phase_3:
		is_phase_3 = true
		phase_2.visible = false
		phase_3.visible = true
		speed = speed * 1.25

func change_sprites() -> void:
	if health > MAX_HEALTH * 2/3: # Phase 1 Sprite Changes
		if phase_1.visible:
			phase_1_sleep.visible = true
			phase_1.visible = false
		elif phase_1_sleep.visible:
			phase_1.visible = true
			phase_1_sleep.visible = false
	elif health <= MAX_HEALTH * 2/3 and health > MAX_HEALTH * 1/3: # Phase 2 Sprite Changes
		if phase_2.visible:
			phase_2_sleep.visible = true
			phase_2.visible = false
		elif phase_2_sleep.visible:
			phase_2.visible = true
			phase_2_sleep.visible = false
	elif health <= MAX_HEALTH * 1/3: # Phase 3 Sprite Changes
		if phase_3.visible:
			phase_3_sleep.visible = true
			phase_3.visible = false
		elif phase_3_sleep.visible:
			phase_3.visible = true
			phase_3_sleep.visible = false

func update_health_bar() -> void:
	if health_bar:
		health_bar.value = health  # Update health bar value

# Function to spawn a single random skull
func spawn_random_skull() -> void:
	var skull_types: Array[String] = ["skull_small", "skull_medium", "skull_bomb", "skull_frost"]
	var number_of_skulls: int = 0
	if !is_phase_2 and !is_phase_3: 
		number_of_skulls = 1
	elif is_phase_2 and !is_phase_3:
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
			print("Failed to instantiate enemy from path: ", random_skull_path)


func die() -> void: # Emit 3 Hearts, b/c Queen is a Boss
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
	# Reset movement flags and record new target location
	print("\nMove Timer Ends")
	reached_destination_x = false
	reached_destination_y = false
	reached_final_destination = false
	print("New Target Location Saved")
	target_location = player.global_position
	# Modify sprites and collisions
	change_sprites()
	collision_polygon.disabled = false
	health_bar.visible = true

func _on_wake_timer_timeout() -> void:
	print("\nWake Timer Ends")
	# Change to Awake Sprite
	collision_polygon.disabled = false
	health_bar.visible = true
	# Save Player Location
	target_location = player.global_position
	# Begin Movement Cycle, (set Flag to True)
	begin_movement = true
	print("Target Location Saved, Movement Cycle Begins")
	change_sprites() 

