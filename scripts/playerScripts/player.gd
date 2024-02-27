extends CharacterBody2D


func _physics_process(delta): 
	# Face direction based on key input
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	# Speed of movement 
	velocity = direction * 250
	move_and_slide() 
