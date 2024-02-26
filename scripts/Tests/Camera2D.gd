extends Camera2D



func _ready():
	Events.room_entered.connect(func(room):position = room.position)
