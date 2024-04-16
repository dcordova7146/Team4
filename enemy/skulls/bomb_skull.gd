extends Skull

# Distance at which the bomb skull explodes upon reaching the player.
var explosion_distance: float = 30

func _ready() -> void:
	# Initialize health and speed
	health = 50
	speed = 20
	print("BombSkull is ready!")

func _physics_process(delta: float) -> void:
	# Move towards the player if not exploded
	if (player and awake) and not $Explosion.visible: ## RE-ADD AWAKE CONDITION AFTER TESTING
		var direction: Vector2 = global_position.direction_to(player.global_position)
		velocity = direction.normalized() * speed
		move_and_slide()
		check_explode()

func check_explode() -> void:
	# Check if within explosion range
	var distance_to_player = global_position.distance_to(player.global_position)
	if distance_to_player < explosion_distance:
		print("BombSkull is within explosion range!")
		# Start the fuse timer if not exploded
		$Explosion.visible = true
		$Fuse.start()
		$fuse.play("charge explosion")

func _on_fuse_timeout() -> void:
	# Handle fuse timeout
	print("BombSkull is exploding")
	explode()

func explode() -> void:
	if $Explosion.visible:
		print("BombSkull has exploded!")
		var distance_to_player = global_position.distance_to(player.global_position)
		if distance_to_player < explosion_distance:
			print("Player is taking damage!")
			player.lose_life()
		super.die()

func die() -> void:
	# Handle the death of BombSkull
	$Explosion.visible = true  # Make the explosion sprite visible
	$Fuse.start()  # Start the fuse timer
	print("BombSkull has died!")
	# Call the parent die function if additional functionality is required.

