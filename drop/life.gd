extends Area2D
## A life heart. Only collides with the player.


## Cause the player collided with to gain a life.
func _on_body_entered(body: Node2D) -> void:
	var player: Player = body as Player
	if player:
		player._gain_life()
		queue_free()
