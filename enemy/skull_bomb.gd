#James C, Karwei K
extends Skull

# Distance at which the bomb skull explodes upon reaching the player.
var explosion_distance: float = 30
@onready var explosion_sprite: Sprite2D = $Explosion
@onready var fuse_timer: Timer = $FuseTimer
@onready var fuse_animation: AnimationPlayer = $FuseAnimation
@onready var collision: CollisionShape2D = $CollisionShape2D


func _physics_process(_delta: float) -> void:
	# Move towards the player if not exploded
	if (player and awake) and not explosion_sprite.visible: ## RE-ADD AWAKE CONDITION AFTER TESTING
		var direction: Vector2 = global_position.direction_to(player.global_position)
		velocity = direction.normalized() * speed
		move_and_slide()
		check_explode()


func check_explode() -> void:
	# Check if within explosion range
	var distance_to_player: float = global_position.distance_to(player.global_position)
	if distance_to_player < explosion_distance:
		# Start the fuse timer if not exploded
		start_fuse()


func start_fuse() -> void:
	is_invincible = true
	explosion_sprite.visible = true
	fuse_timer.start()
	fuse_animation.play("charge explosion")


func _on_fuse_timeout() -> void:
	explode()


func explode() -> void:
	if not explosion_sprite.visible:
		return
	var distance_to_player: float = global_position.distance_to(player.global_position)
	if distance_to_player < explosion_distance:
		player._lose_life()
	super.die()


func die() -> void:
	start_fuse()
