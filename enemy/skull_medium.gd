extends Skull


## Shoot a bone in direction of player.
func _on_shoot_timer_timeout() -> void:
	if awake:
		var direction: Vector2 = global_position.direction_to(player.global_position)
		shoot_bone(direction.angle())
