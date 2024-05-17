## Contributors: James, Karwai
class_name Bullet
extends Area2D

## Damage dealt to the enemy contacted.
@export var damage: float = 10.0
## Speed of the bullet.
@export var speed: float = 250
## Distance that can be travelled until it despawns.
@export var max_range: float = 1000
## Number of enemies a bullet can hit before despawning.
@export var pierce: int = 1
## Whether bullets pierce a finite number of enemies.
@export var is_pierce_finite: bool = true
## Distance traveled by the bullet.
var travelled_distance: float = 0.0
## Enemies hit.
var enemies_hit: Array[Skull] = []

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
	# If body is skull, have it take damage.
	var skull: Skull = body as Skull
	if skull:
		# Do nothing if enemy was already hit.
		# TODO: Change to only do nothing if enemy was hit recently.
		if enemies_hit.has(skull):
			return
		# Do nothing if enemy is invincible.
		if skull.is_invincible:
			return
		skull.take_damage(damage)
		enemies_hit.append(skull)
		if is_pierce_finite:
			pierce -= 1
			# Delete when it can no longer pierce.
			if pierce == 0:
				queue_free()
	else:
		# e.g. if body is wall
		queue_free()
