class_name Bone
extends Area2D
## Enemy projectile. Hurts player on contact.

## Velocity.
var velocity: float = 50
## Sprite to get rotated.
@onready var sprite: Sprite2D = $Sprite2D


func _process(delta: float) -> void:
	# Rotate sprite.
	sprite.rotation += delta * 2


func _physics_process(delta: float) -> void:
	position += delta * velocity * Vector2.RIGHT.rotated(rotation)


## Cause the player collided with to lose a life, then delete self.
func _on_body_entered(body: Node2D) -> void:
	var player: Player = body as Player
	if player:
		player._lose_life()
	queue_free()
