## Contributors: James, Karwai

extends Area2D

## Speed of the bullet.
@export var speed: float = 250
## Maximum range of the bullet.
@export var max_range: float = 1000
## Distance traveled by the bullet.
var travelled_distance: float = 0

func _physics_process(delta: float) -> void:
	# Calculate direction vector based on bullet's rotation.
	var direction: Vector2 = Vector2.RIGHT.rotated(rotation)
	# Move bullet along calculated direction with a certain speed,
	# adjusted by delta for frame-rate independence.
	position += direction * speed * delta
	# Update distance traveled by bullet.
	travelled_distance += speed * delta
	
	# If bullet traveled beyond max range, queue  for deletion.
	if travelled_distance > max_range:    
		queue_free()


# Called when bullet enters another body.
func _on_body_entered(body: Node2D) -> void:
	# Queue the bullet for deletion.
	queue_free()
	# If body is skull, have it take damage.
	var skull: Skull = body as Skull
	if skull != null:
		skull.take_damage()
