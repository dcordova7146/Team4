class_name Skull
extends CharacterBody2D

@export var health: int = 5
@export var speed: int = 50
## The sibling node player.
@onready var player: Node2D = get_node("../Player")


func _physics_process(_delta: float) -> void:
	# If Player exists, face and move toward player
	if player:
		var direction: Vector2 = (
				global_position.direction_to(player.global_position)
		)
		velocity = direction * speed
		move_and_slide()
	else:
		print("Player node not found!")


# Damage detection function, decrement by 1
func take_damage() -> void: 
	health -= 1
	# When health 0, destroy node (kills the mob)
	if health == 0: 
		queue_free()
