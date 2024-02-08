extends CharacterBody2D


@export var speed = 300.0



func _physics_process(delta): 
	#basic movement 
	var direction = Input.get_vector("left","right","up","down")
	velocity = direction * speed
	move_and_slide()
