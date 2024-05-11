extends Skull

var has_spawned: bool = false
@onready var spawn_timer: Timer = $SpawnTimer


func _physics_process(_delta: float) -> void:
	if player and awake: ## RE-ADD AWAKE CONDITION AFTER TESTING
		if not has_spawned:
			print("Timer Start, Preparing Skull")
			spawn_timer.start()
			has_spawned = true
	else:
		pass

# Function to spawn a single random skull
func spawn_random_skull() -> void:
	var skull_types: Array[String] = ["small_skull", "medium_skull", "large_skull", "bomb_skull", "frost_skull"]
	var random_skull_type: String = skull_types[randi() % skull_types.size()]
	var random_skull_path: String = "res://enemy/skulls/" + random_skull_type + ".tscn"
	
	# Load the skull scene
	var resource: PackedScene = load(random_skull_path)
	var skull_instance: Node2D = resource.instantiate()
	# Add the skull to the scene
	get_parent().add_child(skull_instance)
	
	# Calculate random position near tombstone
	var spawn_distance: int = 30  # Adjust this value as needed
	var random_offset: Vector2 = Vector2(
			randf_range(-spawn_distance, spawn_distance),
			randf_range(-spawn_distance, spawn_distance)
	)
	# Set the position relative to the tombstone's position
	skull_instance.position = global_position + random_offset

func _on_spawn_timer_timeout() -> void:
	print("Timer Ended, Spawned Skull")
	spawn_random_skull()
	has_spawned = false

# Overide
func die() -> void:
	for i: int in 3: # Spawn 3 Skulls Upon Death
		spawn_random_skull()
	# Parent Class die()
	queue_free()
