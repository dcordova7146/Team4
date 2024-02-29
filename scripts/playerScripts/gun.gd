extends Area2D

# Preload the Bullet scene
const BULLET: PackedScene = preload("res://scenes/playerScenes/bullet.tscn")

func _physics_process(_delta: float) -> void:
	# List of all bodies in collision area.
	var enemies_in_range: Array[Node2D] = get_overlapping_bodies()
	# If enemies are in range, select first and look at them.
	if enemies_in_range.size() > 0:
		# select target
		var target_enemy: Node2D = enemies_in_range[0]
		# face target
		look_at(target_enemy.global_position)


## Shooting logic.
func shoot() -> void:
	# instatiate new bullet when func is called
	var new_bullet: Node2D = BULLET.instantiate()
	var bullet_hole: Node2D = %BulletHole
	# make bullet appear next to gun
	new_bullet.global_position = bullet_hole.global_position
	# make bullet rotation match the gun
	new_bullet.global_rotation = bullet_hole.global_rotation
	# add new bullet as child of Gun(Bullet Hole)
	bullet_hole.add_child(new_bullet)


## Executes every 0.5s.
func _on_timer_timeout() -> void:
	# call shoot func on timer signal
	shoot()
