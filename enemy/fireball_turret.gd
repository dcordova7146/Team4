## Contributors: James

extends Area2D

@onready var turret_hole: Marker2D = %TurretHole

func _physics_process(_delta: float) -> void: 
	var enemies_in_range: Array[Node2D] = get_overlapping_bodies() # List of all bodies in collision area
	# If enemies are in range, select first and look at them
	if enemies_in_range.size() > 0:
		var target_enemy: Node2D = enemies_in_range[0] # select target
		look_at(target_enemy.global_position) # face target

func shoot() -> void: # function for shooting logic
	const FIREBALL: PackedScene = preload("res://projectile/fireball.tscn") # Preload the Bullet scene
	var new_fireball: Node2D = FIREBALL.instantiate() # instatiate new fireball when func is called
	new_fireball.global_position = turret_hole.global_position # make fireball appear next to gun
	new_fireball.global_rotation = turret_hole.global_rotation # make fireball rotation match the gun
	turret_hole.add_child(new_fireball) # add new fireball as child of Gun(Bullet Hole)

func _on_timer_timeout() -> void: # function that reads timer signal every 0.5s
	shoot() # call shoot func on timer signal
