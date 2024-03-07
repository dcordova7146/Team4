#Diego Cordova
extends CharacterBody2D

# Move speed multiplier.
#export allows it to be modifiable outside code and in the editor
@export var speed: int = 250


# Move the player according to cardinal direction input.
#grabs direction vector based on an input map of established keys associated with direction
func _physics_process(_delta: float) -> void:
	var direction: Vector2 = Input.get_vector(
			"move_left","move_right","move_up","move_down"
	)
	velocity = direction * speed
	move_and_slide() 
