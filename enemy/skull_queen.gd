extends Skull

const MAX_HEALTH: int = 600  # Maximum health points
const DESTINATION_THRESHOLD = 5 # Approximate area of destination

var phase2: bool = false # Flag for Queen 2nd Phase
var phase3: bool = false # Flag for Queen 3rd Phase
var begin_movement: bool = false # Flag for Queen wake-up, lets player move before saving location and starting movement.
var wake_timer_called: bool = false # Flag for timer being called
var reached_destination_x: bool = false  # Flag to indicate if Queen reached destination Xcord.
var reached_destination_y: bool = false  # Flag to indicate if Queen reached destination Ycord.
var reached_final_destination: bool = false # Flag to indicate if Queen reached final destination.
var target_location: Vector2 = Vector2() # Record player location that Queen will move to.

@onready var move_timer: Timer = $MoveTimer
@onready var find_timer: Timer = $FindTimer
@onready var collision: CollisionPolygon2D = $CollisionPolygon2D

func _ready() -> void:
	health = MAX_HEALTH  # Set initial health to maximum
	speed = 1  # Movement speed
	super._ready()  # Call base class _ready function
	update_health_bar()
	$CollisionPolygon2D.disabled = true

func _physics_process(_delta: float) -> void:
	if player and awake and !wake_timer_called:
		print("\nWake Timer Started!")
		$WakeTimer.start()
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
			$MoveTimer.start()
			change_sprites()
			$CollisionPolygon2D.disabled = true
			$HealthBar.visible = false
	else:
		pass

func change_phases():
	if health <= MAX_HEALTH * 2/3 and !phase2: 
		phase2 = true
		$SkullQueenP1.visible = false
		$SkullQueenP2.visible = true
		speed = speed * 1.5
	if health <= MAX_HEALTH * 1/3 and phase2 and !phase3:
		phase3 = true
		$SkullQueenP2.visible = false
		$SkullQueenP3.visible = true
		speed = speed * 1.5

func change_sprites():
	if health > MAX_HEALTH * 2/3: # Phase 1 Sprite Changes
		if $SkullQueenP1.visible:
			$SkullQueenP1Sleep.visible = true
			$SkullQueenP1.visible = false
		elif $SkullQueenP1Sleep.visible:
			$SkullQueenP1.visible = true
			$SkullQueenP1Sleep.visible = false
	elif health <= MAX_HEALTH * 2/3 and health > MAX_HEALTH * 1/3: # Phase 2 Sprite Changes
		if $SkullQueenP2.visible:
			$SkullQueenP2Sleep.visible = true
			$SkullQueenP2.visible = false
		elif $SkullQueenP2Sleep.visible:
			$SkullQueenP2.visible = true
			$SkullQueenP2Sleep.visible = false
	elif health <= MAX_HEALTH * 1/3: # Phase 3 Sprite Changes
		if $SkullQueenP3.visible:
			$SkullQueenP3Sleep.visible = true
			$SkullQueenP3.visible = false
		elif $SkullQueenP3Sleep.visible:
			$SkullQueenP3.visible = true
			$SkullQueenP3Sleep.visible = false

func update_health_bar() -> void:
	if health_bar:
		health_bar.value = health  # Update health bar value

func die() -> void: # Emit 3 Hearts, b/c Queen is a Boss
	var offset: int = 12
	# Emit events with randomly adjusted positions
	for i in range(12):
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
	change_sprites()
	$CollisionPolygon2D.disabled = false
	$HealthBar.visible = true

func _on_wake_timer_timeout():
	print("\nWake Timer Ends")
	# Change to Awake Sprite
	$CollisionPolygon2D.disabled = false
	$HealthBar.visible = true
	# Save Player Location
	target_location = player.global_position
	# Begin Movement Cycle, (set Flag to True)
	begin_movement = true
	print("Target Location Saved, Movement Cycle Begins")
	change_sprites() 

