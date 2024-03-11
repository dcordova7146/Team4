#Diego Cordova + Optimization Done by Karwei
extends Node

var room: PackedScene = preload("res://map/room.tscn")
@export var min_rooms: int = 9
@export var max_rooms: int = 15
@export var generation_chance: int = 25

#Karwei addition to ease readability 
const direction_vector: Dictionary = {
	1: Vector2(1, 0),
	2: Vector2(-1, 0),
	3: Vector2(0, 1),
	4: Vector2(0, -1),
}
#Diego Function optimized by karwei
#The basic walker that starts at a base room and randomly chooses a direction to walk in and add a room if one does not already exist and then calling the connect room function to have a record of what is connected with what
func generate(dungeon_seed: int) -> Dictionary:
	seed(dungeon_seed)
	var dungeon: Dictionary = {}
	var roomsAdded: int = 0
	# Choose random total room count.
	var size: int = randi_range(min_rooms, max_rooms)
	# Add first room.
	dungeon[Vector2(0, 0)] = room.instantiate()
	# Keep adding rooms until total room count is reached.
	while(roomsAdded < size):
		# For every existing room, try adding an adjacent room.
		for key: Vector2 in dungeon.keys():
			# Add if total count not reached, 25% of the time.
			if(randf_range(0, 100) < generation_chance and roomsAdded < size):
				# Chose random side to add room.
				var direction: Vector2 = direction_vector.get(randi_range(1,4))
				var adjacent_room_pos: Vector2 = key + direction * Room.SIZE
				if(!dungeon.has(adjacent_room_pos)):
					var newRoom: Node2D = room.instantiate()
					dungeon[adjacent_room_pos] = newRoom
					newRoom.position = adjacent_room_pos
					roomsAdded += 1
				var current_room: Room = dungeon.get(key)
				var adjacent_room: Room = dungeon.get(adjacent_room_pos)
				if(current_room.connectedRooms.get(direction) == null):
					current_room.connectRooms(adjacent_room, direction)
	#wip check for dungeon to not have the possibility of a straight line 
	#while(!check(dungeon)):
		#for key: Vector2 in dungeon.keys():
			#(dungeon.get(key) as Node).queue_free()
		#dungeon = generate(dungeon_seed * randf_range(-1,1))
	return dungeon
	
	#changed the connect Rooms function to exist within the room itself to allow me to test this function outside the dungeon generation
#func connectRooms(room1: Room, room2: Room, direction: Vector2) -> void:
	#room1.connectedRooms[direction] = room2
	#room2.connectedRooms[-direction] = room1
	#room1.connections += 1
	#room2.connections += 1
	#
#Diego
#wip check to allow a room to have a minimum amount of branching paths to add uniqueness
#func check(dungeon: Dictionary) -> bool:
	#var branchRooms: int = 0
	#for key: Vector2 in dungeon.keys():
		#var current_room: Room = dungeon.get(key)
		#if(current_room.connections >= 3):
			#branchRooms += 1
	#return branchRooms >=3 
