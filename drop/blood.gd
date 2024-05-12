extends Area2D
## A blood drop. Only collides with the player.


## Add blood count and delete self.
func _on_body_entered(body: Node2D) -> void:
	var player: Player = body as Player
	if player:
		player.blood_count += 1
		queue_free()
