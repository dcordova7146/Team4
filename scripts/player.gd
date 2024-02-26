extends CharacterBody2D


@export var speed = 200.0



func _physics_process(delta): 
	#basic movement 
	var direction = Input.get_vector("left","right","up","down")
	direction.normalized() #keeps vector at 1 to make sure diagonal movement isnt faster
	velocity = direction * speed
	move_and_slide()
