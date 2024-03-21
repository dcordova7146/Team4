#Diego Cordova
extends Camera2D


## Listen for room enter events.
#camera waits for signal from the event handler then uses an anonymous function
func _ready() -> void:
	Events.room_entered.connect(_on_room_entered)

func _on_room_entered(room: Node2D) -> void:
	position = room.position
