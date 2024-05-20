## James C, Karwei K
extends Skull

## Threshold distance for player detection.
const PLAYER_DISTANCE_THRESHOLD: int = 85
## Maximum health points.
const MAX_HEALTH: int = 100
## Amount to heal by.
var healed_amount: int = 25
## Flag to indicate if the skull will shoot.
var will_shoot: bool = false
## Flag to track shoot preparation.
var is_shoot_preparing: bool = false
## Frost projectile scene.
var frost_projectile: Resource = preload("res://projectile/frost_projectile.tscn")
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
		var direction_to_player: Vector2 = global_position.direction_to(player.global_position)
		var distance_to_player: float = global_position.distance_to(player.global_position)

		# Check if player is within shooting range.
		will_shoot = distance_to_player <= PLAYER_DISTANCE_THRESHOLD

		if will_shoot and not is_shoot_preparing:
			is_shoot_preparing = true
			velocity = Vector2.ZERO
			# Start shooting timer.
			shoot_timer.start()
			# Make ice shell visible.
			ice_sprite.visible = true
			# Disable collision.
			collision.disabled = true
		elif not will_shoot:
			velocity = direction_to_player * speed
			move_and_slide()
			# Hide ice shell.
			ice_sprite.visible = false
			# Enable collision.
			collision.disabled = false
	else:
		pass


func _on_shoot_timeout() -> void:
	will_shoot = false
	is_shoot_preparing = false
	if ice_sprite.visible:
		health += healed_amount
		# Ensure health doesn't exceed maximum
		health = min(health, MAX_HEALTH)
		# Update health bar visual.
		update_health_bar()


func update_health_bar() -> void:
	if health_bar:
		health_bar.value = health  # Update health bar value
