extends Skull

# Override to spawn SmallSkull
func spawn_smaller_skulls() -> void:
	spawn_enemy("res://enemy/skulls/small_skull.tscn", 2)
