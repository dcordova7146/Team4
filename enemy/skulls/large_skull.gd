extends Skull

# Override to spawn MediumSkull
func spawn_smaller_skulls() -> void:
	spawn_enemy("res://enemy/skulls/medium_skull.tscn", 2)

# Override health and speed for Large skull
func _ready():
	health = 100
	speed = 25
