extends Node2D
## The sprite of a room on the map.

@onready var room: Room = get_parent()

const DOOR_SIZE: float = 50.0
const BG_COLOR: Color = Color.DARK_BLUE
const WALL_COLOR: Color = Color.WHITE
const WALL_WIDTH: float = 20.0

const DOOR_TL: Vector2 = Vector2(Room.SIZE.x / 2 - DOOR_SIZE / 2, 0)
const DOOR_BL: Vector2 = Vector2(Room.SIZE.x / 2 - DOOR_SIZE / 2, Room.SIZE.y)
const DOOR_LT: Vector2 = Vector2(0, Room.SIZE.y / 2 - DOOR_SIZE / 2)
const DOOR_RT: Vector2 = Vector2(Room.SIZE.x, Room.SIZE.y / 2 - DOOR_SIZE / 2)


func _draw() -> void:
	# Draw background.
	draw_rect(Rect2(position, Room.SIZE), BG_COLOR, true, 1.0)
	# Draw wall around entire room (i.e. no doors).
	draw_rect(Rect2(position, Room.SIZE), WALL_COLOR, false, WALL_WIDTH)
	# "Punch" holes in wall according to connections.
	if room.connectedRooms[Vector2(0,-1)] != null:
		_draw_door(DOOR_TL, DOOR_TL + Vector2(DOOR_SIZE, 0))
	if room.connectedRooms[Vector2(0,1)] != null:
		_draw_door(DOOR_BL, DOOR_BL + Vector2(DOOR_SIZE, 0))
	if room.connectedRooms[Vector2(1,0)] != null:
		_draw_door(DOOR_RT, DOOR_RT + Vector2(0, DOOR_SIZE))
	if room.connectedRooms[Vector2(-1,0)] != null:
		_draw_door(DOOR_LT, DOOR_LT + Vector2(0, DOOR_SIZE))


## Draw a line to remove part of the wall.
func _draw_door(start: Vector2, end: Vector2) -> void:
	draw_line(start, end, BG_COLOR, WALL_WIDTH)
