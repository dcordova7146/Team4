extends Gun

## Show the melee weapon swing visually.
func _ready():
	pass

func _spawn_bullets() -> void:
	_add_bullet()
	sprite_2d.rotation += PI
	sprite_2d.position.y *= -1
