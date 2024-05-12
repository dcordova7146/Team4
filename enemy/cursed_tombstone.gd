extends Skull

var has_spawned: bool = false
@onready var spawn_timer: Timer = $SpawnTimer

func _physics_process(_delta: float) -> void:
	if player and awake: 
		if not has_spawned:
			print("Timer Start, Preparing Skull")
			spawn_timer.start()
			has_spawned = true
	else:
		pass

# Function to spawn a single random skull
func spawn_random_skull() -> void:
	# Deciding and Loading Random Skull
	var skull_types: Array[String] = ["skull_small", "skull_medium", "skull_large", "skull_bomb", "skull_frost"]
	var random_skull_type: String = skull_types[randi() % skull_types.size()]
	var random_skull_path: String = "res://enemy/" + random_skull_type + ".tscn"
	var random_skull_resource: PackedScene = load(random_skull_path)
	# Spawning the Skull
	var offset: int = 25
	var room: Room = get_parent()
	var enemy_instance: Skull = random_skull_resource.instantiate()
	if enemy_instance and room:
		var random_offset = Vector2(randf_range(-offset, offset), randf_range(-offset, offset))
		var spawn_position: Vector2 = position + random_offset
		enemy_instance.position = spawn_position
		enemy_instance.awake = true
		room.add_enemy(enemy_instance)
	else:
		print("Failed to instantiate enemy from path: ", random_skull_path)

func _on_spawn_timer_timeout() -> void:
	print("Timer Ended, Spawned Skull")
	spawn_random_skull()
	has_spawned = false

# Overide
func die() -> void:
	for i: int in 3: # Spawn 3 Skulls Upon Death
		spawn_random_skull()
	# Parent Class die()
	super.die()
