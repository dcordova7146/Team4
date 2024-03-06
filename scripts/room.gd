## Contributors: Diego, Karwai

class_name Room
extends Node2D

const SIZE: Vector2 = Vector2(258 * 1.2, 115 * 1.2)

var connections: int = 0
var connectedRooms: Dictionary = {
	Vector2(1,0): null,
	Vector2(-1,0): null,
	Vector2(0,1): null,
	Vector2(0,-1): null,
}


## Emit room entered signal if body entered is the player.
func _on_play_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		Events.room_entered.emit(self)
