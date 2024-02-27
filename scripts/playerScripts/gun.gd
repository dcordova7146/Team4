extends Area2D

func _physics_process(delta):
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		var target_enemy = enemies_in_range[0]
		look_at(target_enemy.global_position)

func shoot():
	const BULLET = preload("res://scenes/playerScenes/bullet.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = %BulletHole.global_position
	new_bullet.global_rotation = %BulletHole.global_rotation
	%BulletHole.add_child(new_bullet)

func _on_timer_timeout():
	shoot()
