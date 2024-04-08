extends Skull

# Constants
var player_distance_threshold = 85

# Variables
var will_shoot = false
var frost_projectile = preload("res://projectile/frost_projectile.tscn")

func _ready() -> void:
	# Initialize properties
	health = 50
	speed = 25

func _physics_process(_delta: float) -> void:
	if player and awake:
		# Calculate direction and distance to player
		var direction: Vector2 = global_position.direction_to(player.global_position)
		var distance_to_player = global_position.distance_to(player.global_position)

		if distance_to_player <= player_distance_threshold:
			# Player is within shooting range
			will_shoot = true
		elif will_shoot:
			# Player moved out of range, reset shooting flag
			will_shoot = false

		if will_shoot:
			# Prepare to shoot
			velocity = Vector2.ZERO
			print("Preparing to shoot")
			$Shoot.start()  # Start shooting timer
			$Ice.visible = true  # Make Ice Shell visible
			$CollisionPolygon2D.disabled = true  # Disable collision
		else:
			# Move towards the player
			velocity = direction * speed
			move_and_slide()
			$Ice.visible = false  # Hide Ice Shell
			$CollisionPolygon2D.disabled = false  # Enable collision
	else:
		pass

func _on_shoot_timeout():
	print("Shooting Frost")
	# Shoot logic goes here
	will_shoot = false  # Reset shooting flag
