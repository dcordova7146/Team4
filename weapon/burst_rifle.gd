## Contributors: James, Karwai
extends Gun
## A gun that fires a burst of bullets.

## The number of bullets shot.
@export var bullet_count: int = 3
## The duration in seconds waited between each bullet firing.
@export var spacing: float = 0.04

func _spawn_bullets() -> void:
	for i: int in range(bullet_count):
		await get_tree().create_timer(spacing).timeout
		_add_bullet()
