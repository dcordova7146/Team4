## Contributors: James

extends CharacterBody2D

## Move speed multiplier.
@export var speed: int = 250


## Move the player according to cardinal direction input.
func _physics_process(_delta: float) -> void:
	var direction: Vector2 = Input.get_vector(
			"move_left","move_right","move_up","move_down"
	)
	velocity = direction * speed
	move_and_slide() 
