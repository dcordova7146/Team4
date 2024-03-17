extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Room.connectRooms($Room2, Vector2(0,-1))
	$Room.connectRooms($Room3, Vector2(1,0))
	$Room2.connectRooms($Room, Vector2(0,1))
	$Room3.connectRooms($Room, Vector2(-1,0))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
