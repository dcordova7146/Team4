extends Node2D

@onready var muzzle = $pivot/Sprite2D/muzzle

func _physics_process(delta):
	look_at(get_global_mouse_position())
	

