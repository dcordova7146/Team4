extends Gun


## Create a bullet or a cone of bullets with the position and rotation of this gun.
func _create_bullets() -> void:
	for i: int in range(4):  # Adjust the number of bullets in the cone as needed
		var spread_angle: float = i * 0.1 # Adjust the spread angle for tighter spread
		var new_bullet: Node2D = _create_bullet()
		new_bullet.global_position = bullet_hole.global_position
		new_bullet.global_rotation = bullet_hole.global_rotation + spread_angle
		bullet_hole.add_child(new_bullet)

		# Create another bullet that spreads in the opposite direction (upwards)
		var opposite_spread_angle: float = -spread_angle
		var opposite_bullet: Node2D = _create_bullet()
		opposite_bullet.global_position = bullet_hole.global_position
		opposite_bullet.global_rotation = bullet_hole.global_rotation + opposite_spread_angle
		bullet_hole.add_child(opposite_bullet)
