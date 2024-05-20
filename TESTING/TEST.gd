##Diego C
extends Node2D

## Test scene used to test various features 
##should be ignored
# Called when the node enters the scene tree for the first time.
func _ready():
	$Room.connectRooms($Room2, Vector2(0,-1))
	$Room.connectRooms($Room3, Vector2(1,0))
	$Room2.connectRooms($Room, Vector2(0,1))
	$Room3.connectRooms($Room, Vector2(-1,0))
	
	$Room.set_Rtype(2)
	$Room2.set_Rtype(1)
	$Room3.set_Rtype(3)
	Events.emit_signal("dungeon_complete")
	$Skull.awake = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_button_pressed():
	$Room.populateEnemySpawner()
