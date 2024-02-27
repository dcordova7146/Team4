extends Area2D

func _physics_process(delta): 
	var enemies_in_range = get_overlapping_bodies() # List of all bodies in collision area
	# If enemies are in range, select first and look at them
	if enemies_in_range.size() > 0:
		var target_enemy = enemies_in_range[0] # select target
		look_at(target_enemy.global_position) # face target

func shoot(): # function for shooting logic
	const BULLET = preload("res://scenes/playerScenes/bullet.tscn") # Preload the Bullet scene
	var new_bullet = BULLET.instantiate() # instatiate new bullet when func is called
	new_bullet.global_position = %BulletHole.global_position # make bullet appear next to gun
	new_bullet.global_rotation = %BulletHole.global_rotation # make bullet rotation match the gun
	%BulletHole.add_child(new_bullet) # add new bullet as child of Gun(Bullet Hole)

func _on_timer_timeout(): # function that reads timer signal every 0.5s
	shoot() # call shoot func on timer signal
