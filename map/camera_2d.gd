# Diego Cordova, Karwai Kang
extends Camera2D


## Listen for room enter events.
func _ready() -> void:
	Events.room_entered.connect(_on_room_entered)


## Set position to position of given room.
func _on_room_entered(room: Node2D) -> void:
	global_position = room.global_position
