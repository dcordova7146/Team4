## Contributors: Diego, Karwai

extends Camera2D


## Listen for room enter events.
func _ready():
	Events.room_entered.connect(_on_room_entered)


## Move camera to room entered.
func _on_room_entered(room: Node2D) -> void:
	position = room.position
