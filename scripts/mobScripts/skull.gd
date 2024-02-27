extends CharacterBody2D # Inherits from CharacterBody2D

var health = 5 # Initialize with 5 
@onready var player = get_node("/root/TestDungeon/Player") # Store Reference to Player Node

func _physics_process(delta): 
	if player: # If Player exists, face and move toward player
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * 100
		move_and_slide()
	else: # Test statement
		print("Player node not found!")

func take_damage(): # Damage detection function, decrement by 1
	health -= 1
	
	if health == 0: # When health 0, destroy node (kills the mob)
		queue_free()
