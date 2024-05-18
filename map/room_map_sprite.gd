extends Node2D
## The sprite of a room on the map.

## Emoji for each room type. Used as icons on map.
const LABEL_EMOJI: Dictionary = {
	Room.RoomType.BATTLE: "⚔",
	Room.RoomType.SHOP: "💰",
	Room.RoomType.REST: "⛺",
	Room.RoomType.BOSS: "👿",
	Room.RoomType.START: "🏁",
}
## Size of door.
const DOOR_SIZE: float = 50.0
## Color of background.
const BG_COLOR: Color = Color.DARK_BLUE
## Color of wall.
const WALL_COLOR: Color = Color.WHITE
## Width of wall.
const WALL_WIDTH: float = 20.0
## Position of the left of the top door.
const DOOR_TL: Vector2 = Vector2(Room.SIZE.x / 2 - DOOR_SIZE / 2, 0)
## Position of left of the bottom door.
const DOOR_BL: Vector2 = Vector2(Room.SIZE.x / 2 - DOOR_SIZE / 2, Room.SIZE.y)
## Position of the top of the left door.
const DOOR_LT: Vector2 = Vector2(0, Room.SIZE.y / 2 - DOOR_SIZE / 2)
## Position of the top of the right door.
const DOOR_RT: Vector2 = Vector2(Room.SIZE.x, Room.SIZE.y / 2 - DOOR_SIZE / 2)

@onready var room: Room = get_parent()
@onready var type_label: Label = $TypeLabel

func _ready() -> void:
	type_label.text = LABEL_EMOJI[room.room_type]
	type_label.position.x = Room.SIZE.x / 2 - 64.0

func _draw() -> void:
	# Draw background.
	draw_rect(Rect2(position, Room.SIZE), BG_COLOR, true)
	# Draw wall around entire room (i.e. no doors).
	draw_rect(Rect2(position, Room.SIZE), WALL_COLOR, false, WALL_WIDTH)
	# "Punch" holes in wall according to connections.
	if room.connected_rooms[Vector2(0,-1)] != null:
		_draw_door(DOOR_TL, DOOR_TL + Vector2(DOOR_SIZE, 0))
	if room.connected_rooms[Vector2(0,1)] != null:
		_draw_door(DOOR_BL, DOOR_BL + Vector2(DOOR_SIZE, 0))
	if room.connected_rooms[Vector2(1,0)] != null:
		_draw_door(DOOR_RT, DOOR_RT + Vector2(0, DOOR_SIZE))
	if room.connected_rooms[Vector2(-1,0)] != null:
		_draw_door(DOOR_LT, DOOR_LT + Vector2(0, DOOR_SIZE))


## Draw a line to remove part of the wall.
func _draw_door(start: Vector2, end: Vector2) -> void:
	draw_line(start, end, BG_COLOR, WALL_WIDTH)
