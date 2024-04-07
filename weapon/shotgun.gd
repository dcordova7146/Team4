## Contributors: James, Karwai
extends Gun
## A gun that fires a cone of bullets.

## The number of bullets shot.
@export var bullet_count: int = 5
## The angle in degrees between each bullet.
@export var spread_angle: float = 10.0


func _spawn_bullets() -> void:
	var start_angle: float = (
			muzzle.global_rotation - 
			bullet_count * deg_to_rad(spread_angle) / 2
	)
	for i: int in range(bullet_count):
		_add_bullet(
				muzzle.global_position,
				start_angle + deg_to_rad(spread_angle) * i
		)
