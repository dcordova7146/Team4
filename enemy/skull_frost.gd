extends Skull

const PLAYER_DISTANCE_THRESHOLD: int = 85  # Threshold distance for player detection
const MAX_HEALTH: int = 100  # Maximum health points

var will_shoot: bool = false  # Flag to indicate if the skull will shoot
var is_shoot_preparing: bool = false  # Flag to track shoot preparation
var frost_projectile: Resource = preload("res://projectile/frost_projectile.tscn")  # Preloaded frost projectile
var frozen: bool = false
@onready var shoot_timer: Timer = $ShootTimer
@onready var ice_sprite: Sprite2D = $Ice
@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	health = MAX_HEALTH  # Set initial health to maximum
	speed = 20  # Movement speed
	super._ready()  # Call base class _ready function

func _physics_process(_delta: float) -> void:
	if player and awake:
		var direction: Vector2 = global_position.direction_to(player.global_position)
		var distance_to_player: float = global_position.distance_to(player.global_position)

		# Check if player is within shooting range
		will_shoot = distance_to_player <= PLAYER_DISTANCE_THRESHOLD

		if will_shoot and not is_shoot_preparing:
			is_shoot_preparing = true
			velocity = Vector2.ZERO
			print("Preparing to shoot")
			shoot_timer.start()  # Start shooting timer
			ice_sprite.visible = true  # Make ice shell visible
			collision.disabled = true  # Disable collision
		elif not will_shoot:
			velocity = direction * speed
			move_and_slide()
			ice_sprite.visible = false  # Hide ice shell
			collision.disabled = false  # Enable collision
	else:
		pass

func _on_shoot_timeout() -> void:
	print("Shooting Frost")
	will_shoot = false
	is_shoot_preparing = false

	if ice_sprite.visible:
		var healed_amount: int = 25
		health += healed_amount
		health = min(health, MAX_HEALTH)  # Ensure health doesn't exceed maximum
		print("Healing: ", health)
		update_health_bar()  # Update health bar visual

func update_health_bar() -> void:
	if health_bar:
		health_bar.value = health  # Update health bar value
