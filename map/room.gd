#Diego Cordova 
class_name Room
extends Node2D

const SIZE: Vector2 = Vector2(258 * 1.2, 115 * 1.2) #edit by karwei to optimize room gen
var connections: int = 0
@export var enemycount = 3
@onready var playArea = $"Play Area"
var enemies = []
var warning = preload("res://tempAssets/Warning.png")
var enemy = preload("res://enemy/skull.tscn")
#enum direction{ 
	#up = Vector2(0,-1), 
	#down = Vector2(0,1),
	#left = Vector2(-1,0),
	#right = Vector2(1,0)
#}
@export var connectedRooms: Dictionary = {
	Vector2(1,0): null, 
	Vector2(-1,0): null, 
	Vector2(0,1): null, 
	Vector2(0,-1): null 
}
enum roomType{
	BATTLE = 2,
	SHOP = 3,
	REST = 4,
	BOSS =5,
	START = 1,
	ROOM = 0
}
@export var rType = roomType.ROOM

#ready is called when an object is added to the scene tree	
func _ready():
	Events.dungeon_complete.connect(on_Dungeon_Complete)
	Events.enemy_defeated.connect(on_kill)
	
#Emit room entered signal if body entered is the player.
#function is used to talk to the camera to lock it to a room instead of free roam camera
func on_Dungeon_Complete()->void:
	#print("called?")
	updateRoom()
	setupRoom()
	

func _on_play_area_body_entered(body: Node2D) -> void:
	#print("Room entered")
	Events.room_entered.emit(self) 
	match rType:
		roomType.BATTLE:
			print("This is a battle room")
			wakeEnemies()
			lockRoom()
		roomType.SHOP:
			print("This is a shop room")	
		roomType.REST:
			print("This is a rest room")
		roomType.BOSS:
			print("This is a boss room")
		roomType.START:
			print("This is the start room")
		roomType.ROOM:
			pass
		_:
			print("Unknown state")
	#activate spawners

func _on_play_area_body_exited(body):
	updateRoom()
	

#function is used to update the connected rooms dictionary based on room generation
#in order to make traversal more interesting not all adjacent rooms are connected 
func connectRooms(room2: Room, direction: Vector2) -> void:
	#print("Success")
	connectedRooms[direction] = room2
	room2.connectedRooms[-direction] = Room
	connections += 1
	room2.connections += 1
	print(connectedRooms)
	updateRoom()

#Test function to test above connectRooms function
#func _on_north_area_entered(area):
	#if area.is_in_group("RoomScanners") and connectedRooms[Vector2(1,0)] != null:
		#print("room is connected")
		
#Just visualizes the room door openings with how they are connected, calling seperate functions that activate collisions and adds sprites representing doors
func updateRoom()-> void:
	if connectedRooms[Vector2(0,-1)] != null:
		openTop()
	if connectedRooms[Vector2(0,1)] != null:
		openBot()
	if connectedRooms[Vector2(1,0)] != null:
		openRight()
	if connectedRooms[Vector2(-1,0)] != null:
		openLeft()
	else:
		pass
			
func openTop()-> void:
	#add a door
	#disable no door collision
	if($Walls/TopNoDoor):
		$TopDoor.visible = true
		$Walls/TopNoDoor.set_disabled(true)
		$"TopBarrier".removeBarrier()
		
func openBot()-> void:
	if($Walls/BottomNoDoor):
		$Walls/BottomNoDoor.set_disabled(true)
		$BotDoor.visible = true
		$"BotBarrier".removeBarrier()
	
func openRight()-> void:
	if($Walls/RightNoDoor):
		$Walls/RightNoDoor.set_disabled(true)
		$RightDoor.visible = true
		$"RightBarrier".removeBarrier()
		
func openLeft()-> void:
	if($Walls/LeftNoDoor):
		$Walls/LeftNoDoor.set_disabled(true)
		$LeftDoor.visible = true
		$"LeftBarrier".removeBarrier()
		
func populateEnemySpawner():	
	#grab collision shape within the play area area2d to obtain the bounds of the play area
	print("populating...")
	for i in range(enemycount):
		var randpos = rand_coor()
		print(randpos)
		var e1 = enemy.instantiate()
		enemies.append(e1)
		add_child(e1)
		e1.global_position = randpos
		add_child(e1)
		
func rand_coor()-> Vector2:
	var topleft = $"Play Area/topLeftBound".global_position
	print(topleft)
	var topright = $"Play Area/topRightBound".global_position
	print(topright)
	var botleft = $"Play Area/botLeftBound".global_position
	print(botleft)
	var botright = $"Play Area/botRightBound".global_position
	print(botright)
	var randx = randf_range(topleft.x,topright.x)
	var randy = randf_range(topleft.y,botleft.y)
	return Vector2(randx,randy)
	
	
func lockRoom()->void:
	#add possible barriers corresponding to open doors
	#reactivate collisions to lock a player and enemies in a room
	print("locking room")
	if connectedRooms[Vector2(0,-1)] != null:
		print("top door is now locked")
		$"TopBarrier".setBarrier()
		$Walls/TopNoDoor.set_disabled(false)
	if connectedRooms[Vector2(0,1)] != null:
		print("bot door is now locked")
		$"BotBarrier".setBarrier()
		$Walls/BottomNoDoor.set_disabled(false)
	if connectedRooms[Vector2(1,0)] != null:
		print("right door is now locked")
		$"RightBarrier".setBarrier()
		$Walls/RightNoDoor.set_disabled(false)
	if connectedRooms[Vector2(-1,0)] != null:
		print("left door is now locked")
		$"LeftBarrier".setBarrier()
		$Walls/LeftNoDoor.set_disabled(false)
	else:
		pass

func unlockRoom()->void:
	#upon wave clear room should unlock	
	print("Unlocking room")	
	pass
	
func wakeEnemies()->void:
	print(enemies)
	if(!enemies.is_empty()):
		print("waking up enemies")
		for i in enemies:
			i.awake = true
			print(i.awake)
	
func setupRoom()->void:
	#this function shall spawn whatever a room requires of it
	#pos represents the position of a marker on a room where the type of room will be printed in low opacity for test purposes
	var pos = $TEMP.global_position
	var text_Color = Color(144, 238, 144,.5)
	
	match rType:
		roomType.BATTLE:
			populateEnemySpawner()
			#not printing where can be seen
			draw_string(ThemeDB.fallback_font, pos, "BATTLE", HORIZONTAL_ALIGNMENT_CENTER, -1, 16, text_Color)
		roomType.SHOP:
			print("This is the shop")	
			draw_string(ThemeDB.fallback_font, pos, "SHOP", HORIZONTAL_ALIGNMENT_CENTER, -1, 16, text_Color)
			#insantiate a shop for the player to spend currency to upgrade
		roomType.REST:
			print("This is a rest stop")
			draw_string(ThemeDB.fallback_font, pos, "REST", HORIZONTAL_ALIGNMENT_CENTER, -1, 16, text_Color)
			#should give the player a choice to upgrade or heal themselves
		roomType.BOSS:
			#lockRoom()
			draw_string(ThemeDB.fallback_font, pos, "BOSS", HORIZONTAL_ALIGNMENT_CENTER, -1, 16, text_Color)
			#spawn a boss and a boss health bar	
		roomType.START:
			#where the player begins
			draw_string(ThemeDB.fallback_font, pos, "START", HORIZONTAL_ALIGNMENT_CENTER, 10, 30, text_Color)
			
		roomType.ROOM:
			draw_string(ThemeDB.fallback_font, pos, "ROOM", HORIZONTAL_ALIGNMENT_CENTER, -1, 16, text_Color)
			#a room of ROOM type shouldnt happen this is a check for if the generator didnt mess up
			pass
		_:
			print("Unknown state")

func set_Rtype(tag:int)->void:
	rType = tag
	pass
	
#error the kill is being registered multiple times instead of once
#accurately grabbing the enemy and removing it from the array of enemies but 1 kill removes all enemies for some reason
func on_kill(enemy)->void:
	print(enemy)
	print(enemies)
	var index = enemies.find(enemy)
	print(index)
	if index != -1:
		print("removing") 
		print(enemies[index])
		enemies.remove_at(index)
	else:
		print("error")
	
	if enemies.is_empty():
		print("there are no enemies in this room")
		unlockRoom()
	
	


	
