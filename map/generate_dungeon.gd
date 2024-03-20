#Diego Cordova + Optimization Done by Karwei
extends Node

var room: PackedScene = preload("res://map/room.tscn")
@export var min_rooms: int = 9
@export var max_rooms: int = 15
@export var generation_chance: int = 25
@export var size: int = 0 
var encounter_Rooms_Available = 0
var shop_Rooms_Available = 0
var rest_Rooms_Available = 0

var room_Queue = []
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
	size = randi_range(min_rooms, max_rooms)
	# Add first room.
	var startRoom = room.instantiate()
	startRoom.set_Rtype(1)
	dungeon[Vector2(0, 0)] = startRoom
	setQueue()
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
					var roomsType = room_Queue.pop_back()
					newRoom.set_Rtype(roomsType)
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
	
	#create a queue of room types to then assign to the rooms
func setQueue()->void:
	#there can only be 1 start room and 1 boss room so they are removed from
	var available_Rooms = size -2
	encounter_Rooms_Available = int(available_Rooms * .75)
	rest_Rooms_Available = int(available_Rooms * .1)
	shop_Rooms_Available = int(available_Rooms * .15)
	
	while(encounter_Rooms_Available + rest_Rooms_Available + shop_Rooms_Available <= available_Rooms):
		var coinflip = randi_range(0,3)
		if coinflip < 2:
			encounter_Rooms_Available+= 1
		elif coinflip == 2:
			rest_Rooms_Available += 1
		elif coinflip == 3:
			shop_Rooms_Available += 1
	
	#numbers represent the enum that represents the room types (2 = battle, 4 = rest, 3 = shop, 5 = boss)
	for i in range(encounter_Rooms_Available):
		room_Queue.append(2)
	for i in range(rest_Rooms_Available):
		room_Queue.append(4)
	for i in range(shop_Rooms_Available):
		room_Queue.append(3)
	
	room_Queue.shuffle()
	room_Queue.insert(0,5) #by appending the boss room we assure it is the last room placed
	
#Diego
#wip check to allow a room to have a minimum amount of branching paths to add uniqueness
#func check(dungeon: Dictionary) -> bool:
	#var branchRooms: int = 0
	#for key: Vector2 in dungeon.keys():
		#var current_room: Room = dungeon.get(key)
		#if(current_room.connections >= 3):
			#branchRooms += 1
	#return branchRooms >=3 
