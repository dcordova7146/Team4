## karwei K
extends Node2D
## The sprite of a room on the map.

## Emoji for each room type. Used as icons on map.
## The battle room is left blank so as to be considered the default room.
const LABEL_EMOJI: Dictionary = {
	Room.RoomType.BATTLE: "",
	Room.RoomType.SHOP: "💰",
	Room.RoomType.REST: "⛺",
	Room.RoomType.BOSS: "👿",
	Room.RoomType.START: "🏁",
}
## Size of door.
const DOOR_SIZE: float = 50.0
## Color of background.
const BG_COLOR: Color = Color(0.7, 0.38, 0)
## Color of background of rooms player is inside.
const BG_ACTIVE_COLOR: Color = Color(1, 0.55, 0)
## Color of wall.
const WALL_COLOR: Color = Color.WHITE
## Width of wall.
const WALL_WIDTH: float = 20.0
## Rectangle of the room.
const RECT: Rect2 = Rect2(
		Room.SIZE * -0.375,
		Room.SIZE * 0.75
)
## Parent room node. Needed to access connected room data.
@onready var room: Room = get_parent()
## Label for the emoji corresponding to the room type.
@onready var type_label: Label = $TypeLabel
## Whether the player is inside the room of this label.
var player_inside: bool = false
## Whether the player ever visited the room of this label.
var player_visited: bool = false

## Set the text of the label according to the room type.
func _ready() -> void:
	type_label.text = LABEL_EMOJI[room.room_type]
	Events.room_entered.connect(_on_room_entered)


## Draw the room sprite.
func _draw() -> void:
	# Draw corridors between rooms to indicate doorways to them.
	for direction: Vector2 in room.connected_rooms.keys():
		if room.connected_rooms[direction]:
			draw_line(
					direction * Room.SIZE * 0.375,
					direction * Room.SIZE * 0.625,
					BG_COLOR, WALL_WIDTH
			)
	## Draw a white outline if player is inside.
	if player_inside:
		draw_rect(RECT, WALL_COLOR, false, WALL_WIDTH)
	## Draw a ligher background if player visited before.
	if player_visited:
		draw_rect(RECT, BG_ACTIVE_COLOR, true)
	else:
		draw_rect(RECT, BG_COLOR, true)


## Determine whether the player was inside or visited the room before,
## then redraw.
func _on_room_entered(room_entered: Room) -> void:
	if player_inside != (room_entered == room):
		player_inside = room_entered == room
		if player_inside:
			player_visited = true
		queue_redraw()
