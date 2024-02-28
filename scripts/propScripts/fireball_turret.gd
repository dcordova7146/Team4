extends Area2D

func _physics_process(delta): 
	var enemies_in_range = get_overlapping_bodies() # List of all bodies in collision area
	# If enemies are in range, select first and look at them
	if enemies_in_range.size() > 0:
		var target_enemy = enemies_in_range[0] # select target
		look_at(target_enemy.global_position) # face target

func shoot(): # function for shooting logic
	const FIREBALL = preload("res://scenes/propScenes/fireball.tscn") # Preload the Bullet scene
	var new_fireball = FIREBALL.instantiate() # instatiate new fireball when func is called
	new_fireball.global_position = %TurretHole.global_position # make fireball appear next to gun
	new_fireball.global_rotation = %TurretHole.global_rotation # make fireball rotation match the gun
	%TurretHole.add_child(new_fireball) # add new fireball as child of Gun(Bullet Hole)

func _on_timer_timeout(): # function that reads timer signal every 0.5s
	shoot() # call shoot func on timer signal
