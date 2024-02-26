extends Node

var room = preload("res://scenes/room.tscn")
@export var minRooms = 9
@export var maxRooms = 15
@export var genChance = 25

func generate(dungeonSeed):
	seed(dungeonSeed)
	var dungeon = {}
	var size = floor(randf_range(minRooms,maxRooms))
	
	dungeon[Vector2(0,0)] = room.instantiate()
	size -=1
	
	while(size >0):
		for i in dungeon.keys():
			if(randf_range(0,100) < genChance and size>0):
				var direction = randf_range(0,4)
				if(direction < 1): 
					var newRoomPos = i + Vector2(33,0)
					if(!dungeon.has(newRoomPos)): 
						dungeon[newRoomPos] = room.instantiate()
						size -=1
					if(dungeon.get(i).connectedRooms.get(Vector2(1,0)) == null):
						connectRooms(dungeon.get(i), dungeon.get(newRoomPos), Vector2(1,0))
				elif(direction < 2): 
					var newRoomPos = i + Vector2(-33,0)
					if(!dungeon.has(newRoomPos)): 
						dungeon[newRoomPos] = room.instantiate()
						size -=1
					if(dungeon.get(i).connectedRooms.get(Vector2(-1,0)) == null):
						connectRooms(dungeon.get(i), dungeon.get(newRoomPos), Vector2(-1,0))
				elif(direction < 3): 
					var newRoomPos = i + Vector2(0,20)
					if(!dungeon.has(newRoomPos)): 
						dungeon[newRoomPos] = room.instantiate()
						size -=1
					if(dungeon.get(i).connectedRooms.get(Vector2(0,1)) == null):
						connectRooms(dungeon.get(i), dungeon.get(newRoomPos), Vector2(0,1))
				elif(direction < 4):
					var newRoomPos = i + Vector2(0,-20)
					if(!dungeon.has(newRoomPos)): 
						dungeon[newRoomPos] = room.instantiate()
						size -=1
					if(dungeon.get(i).connectedRooms.get(Vector2(0,-1)) == null):
						connectRooms(dungeon.get(i), dungeon.get(newRoomPos), Vector2(0,-1))
	while(!check(dungeon)):
		for i in dungeon.keys():
			dungeon.get(i).queue_free()
		dungeon = generate(dungeonSeed * randf_range(-1,1))
	return dungeon
	
func connectRooms(room1, room2, direction):
	room1.connectedRooms[direction] = room2
	room2.connectedRooms[-direction] = room1
	room1.connections += 1
	room2.connections += 1
	
func check(dungeon):
	var branchRooms = 0
	for i in dungeon.keys():
		if(dungeon.get(i).connections >= 3):
			branchRooms += 1
	return branchRooms >=3 
						
	
