# Diego Cordova, Karwai Kang
extends Node

var room: PackedScene = preload("res://map/room.tscn")
@export var min_rooms: int = 9
@export var max_rooms: int = 15
@export var generation_chance: float = 0.25
@export var room_count: int = 0
@export var room_battle_ratio: float = 0.75
@export var room_shop_ratio: float = 0.15
@export var room_rest_ratio: float = 0.1
var room_queue: Array[Room.RoomType] = []
const direction_vector: Dictionary = {
	1: Vector2.UP,
	2: Vector2.RIGHT,
	3: Vector2.DOWN,
	4: Vector2.LEFT,
}

## The basic walker that starts at a base room
## and randomly chooses a direction to walk in
## and add a room if one does not already exist
## and then calling the connect room function
## to have a record of what is connected with what.
func generate() -> Node2D:
	var dungeon: Dictionary = {}
	var root: Node2D = Node2D.new()
	var rooms_added: int = 0
	# Choose random total room count.
	room_count = randi_range(min_rooms, max_rooms)
	# Add first room.
	var startRoom: Room = room.instantiate()
	startRoom.room_type = Room.RoomType.START
	dungeon[Vector2(0, 0)] = startRoom
	# There can only be 1 start room and 1 boss room so they are removed.
	var room_count_left: int = room_count - 2
	set_queue(room_count_left)
	# Keep adding rooms until total room count is reached.
	while rooms_added < room_count:
		# For each position with a room.
		for old_position: Vector2 in dungeon.keys():
			# Stop if rooms count reached.
			if rooms_added == room_count:
				break
			# Stop if chance failed.
			if randf() > generation_chance:
				continue
			# Choose random side to add room.
			var direction: Vector2 = direction_vector.get(randi_range(1, 4))
			var new_position: Vector2 = old_position + direction * Room.SIZE
			# Only add if position has no room already.
			if not dungeon.has(new_position):
				var new_room: Room = room.instantiate()
				var room_type: Room.RoomType = room_queue.pop_back()
				new_room.room_type = room_type
				dungeon[new_position] = new_room
				new_room.position = new_position
				rooms_added += 1
			# Connect the rooms.
			var old_room: Room = dungeon.get(old_position)
			var existing_room: Room = dungeon.get(new_position)
			if old_room.connected_rooms.get(direction) == null:
				old_room.connect_rooms(existing_room, direction)
	#wip check for dungeon to not have the possibility of a straight line 
	#while(!check(dungeon)):
		#for key: Vector2 in dungeon.keys():
			#(dungeon.get(key) as Node).queue_free()
		#dungeon = generate(dungeon_seed * randf_range(-1,1))
	for current_position: Vector2 in dungeon.keys():
		var current_room: Room = dungeon[current_position]
		root.add_child(current_room)
	return root


## Create a queue of room types to then assign to the rooms.
func set_queue(count: int) -> void:
	var room_battle_count: int = int(count * room_battle_ratio)
	var room_rest_count: int = int(count * room_rest_ratio)
	var room_shop_count: int = int(count * room_shop_ratio)
	
	while(room_battle_count + room_rest_count + room_shop_count <= count):
		var coinflip: int = randi_range(0, 3)
		if coinflip < 2:
			room_battle_count += 1
		elif coinflip == 2:
			room_rest_count += 1
		elif coinflip == 3:
			room_shop_count += 1
	
	for i: int in range(room_battle_count):
		room_queue.append(Room.RoomType.BATTLE)
	for i: int in range(room_rest_count):
		room_queue.append(Room.RoomType.REST)
	for i: int in range(room_shop_count):
		room_queue.append(Room.RoomType.SHOP)
	
	room_queue.shuffle()
	# By appending the boss room, we assure it is the last room placed.
	room_queue.insert(0, Room.RoomType.BOSS)
	
#Diego
#wip check to allow a room to have a minimum amount of branching paths to add uniqueness
#func check(dungeon: Dictionary) -> bool:
	#var branchRooms: int = 0
	#for key: Vector2 in dungeon.keys():
		#var current_room: Room = dungeon.get(key)
		#if(current_room.connections >= 3):
			#branchRooms += 1
	#return branchRooms >=3 
