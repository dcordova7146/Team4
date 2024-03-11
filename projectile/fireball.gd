## Contributors: James

extends Area2D

var travelled_distance = 0  # Variable to track distance traveled by the bullet.

func _physics_process(delta):
	const SPEED = 50  # Constant for the maximum speed of the bullet.
	const RANGE = 1000  # Constant for the maximum range of the bullet.
	
	# Calculate direction vector based on bullet's rotation.
	var direction = Vector2.RIGHT.rotated(rotation)
	# Move bullet along calculated direction with a certain speed, adjusted by delta for frame-rate independence.
	position += direction * SPEED * delta
	travelled_distance += SPEED * delta  # Update distance traveled by bullet.
	
	# If bullet traveled beyond max range, queue  for deletion.
	if travelled_distance > RANGE:    
		queue_free()


func _on_body_entered(body): # Called when bullet enters another body.
	queue_free()  # Queue the bullet for deletion.
	# Check if the entered body has a method named "take_damage".
	if body.has_method("take_damage"):
		# If the entered body has a "take_damage" method, call it.
		body.take_damage()
