#Diego Cordova
extends Camera2D


## Listen for room enter events.
#camera waits for signal from the event handler then uses an anonymous function
func _ready():
	Events.room_entered.connect(func(room): position = room.position)
