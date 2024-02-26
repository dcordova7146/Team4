extends Node2D

var connections = 0
var connectedRooms = {
	Vector2(1,0): null,
	Vector2(-1,0): null,
	Vector2(0,1): null,
	Vector2(0,-1): null,
}

func _on_play_area_body_entered(body):
	Events.room_entered.emit(self)
	

