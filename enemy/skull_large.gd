extends Skull
## A large skull with more health, but slower.
## Shoots multiple bullets around it.

## Amount of bones to shoot.
@export var bone_count: int


## Shoot bones all around.
func _on_shoot_timer_timeout() -> void:
	if not awake:
		return
	var angle_offset: float = 2 * PI / bone_count
	var direction: Vector2 = global_position.direction_to(player.global_position)
	for i: int in bone_count:
		shoot_bone(direction.angle() + angle_offset * i)
