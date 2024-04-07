extends Skull

var player_distance_threshold = 100
var will_shoot = false
var frost_projectile = preload("res://projectile/frost_projectile.tscn")

func _ready() -> void:
	health = 50
	speed = 25

func _physics_process(_delta: float) -> void:
	if player: ## RE-ADD AWAKE CONDITION AFTER TESTING
		var direction: Vector2 = global_position.direction_to(player.global_position)
		var distance_to_player = global_position.distance_to(player.global_position)

		if distance_to_player <= player_distance_threshold and not will_shoot:
			# Stop moving immediately
			velocity = Vector2.ZERO
			print("Timer Start, Will Shoot")
			$Shoot.start()
			will_shoot = true
		elif distance_to_player > player_distance_threshold and will_shoot:
			# Player moved outside threshold before shooting, reset will_shoot
			will_shoot = false

		if not will_shoot:
			# Move towards the player if not preparing to shoot
			velocity = direction * speed
			move_and_slide()
	else:
		pass

func _on_shoot_timeout():
	print("Timer Ended, Shoot Frost")
	## SHOOT LOGIC GOES HERE
	will_shoot = false
