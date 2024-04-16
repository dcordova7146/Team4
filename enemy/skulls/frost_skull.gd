extends Skull

const PLAYER_DISTANCE_THRESHOLD = 85  # Threshold distance for player detection
const MAX_HEALTH = 100  # Maximum health points

var will_shoot = false  # Flag to indicate if the skull will shoot
var is_shoot_preparing = false  # Flag to track shoot preparation
var frost_projectile = preload("res://projectile/frost_projectile.tscn")  # Preloaded frost projectile
var frozen: bool = false

func _ready() -> void:
	health = MAX_HEALTH  # Set initial health to maximum
	speed = 20  # Movement speed
	super._ready()  # Call base class _ready function

func _physics_process(_delta: float) -> void:
	if player and awake:
		var direction: Vector2 = global_position.direction_to(player.global_position)
		var distance_to_player = global_position.distance_to(player.global_position)

		# Check if player is within shooting range
		will_shoot = distance_to_player <= PLAYER_DISTANCE_THRESHOLD

		if will_shoot and not is_shoot_preparing:
			is_shoot_preparing = true
			velocity = Vector2.ZERO
			print("Preparing to shoot")
			$Shoot.start()  # Start shooting timer
			$Ice.visible = true  # Make ice shell visible
			$CollisionPolygon2D.disabled = true  # Disable collision
		elif not will_shoot:
			velocity = direction * speed
			move_and_slide()
			$Ice.visible = false  # Hide ice shell
			$CollisionPolygon2D.disabled = false  # Enable collision
	else:
		pass

func _on_shoot_timeout():
	print("Shooting Frost")
	will_shoot = false
	is_shoot_preparing = false

	if $Ice.visible:
		var healed_amount = 25
		health += healed_amount
		health = min(health, MAX_HEALTH)  # Ensure health doesn't exceed maximum
		print("Healing: ", health)
		update_health_bar()  # Update health bar visual

func update_health_bar():
	if health_bar:
		health_bar.value = health  # Update health bar value
