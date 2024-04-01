## Contributors: James, Karwai
extends Gun


## Shoot a burst of 3 bullets with spacing.
func _create_bullets() -> void:
	# Define spacing between bullets in the burst.
	var spacing: float = 7.5
	
	for i: int in range(3):
		var new_bullet: Node2D = _create_bullet()
		# Adjust the bullet's position based on its index in the burst.
		new_bullet.global_position = bullet_hole.global_position + Vector2(spacing * i, 0)
		new_bullet.global_rotation = bullet_hole.global_rotation
		bullet_hole.add_child(new_bullet)
