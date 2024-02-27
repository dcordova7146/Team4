extends CharacterBody2D

var health = 5
# Ensure that the player node is ready before accessing it
@onready var player = get_node("/root/TestDungeon/Player")

func _physics_process(delta):
	# Check if the player node is not null
	if player:
		print("Player node found:", player)
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * 100
		move_and_slide()
	else:
		print("Player node not found!")


func take_damage():
	health -= 1
	
	if health == 0:
		queue_free()
