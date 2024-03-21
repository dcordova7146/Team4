extends Skull

# Override to spawn SmallSkull
func spawn_smaller_skulls() -> void:
	spawn_enemy("res://enemy/skulls/small_skull.tscn", 2)

func _ready() -> void:
	health = 50
	speed = 37.5
