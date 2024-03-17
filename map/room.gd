#Diego Cordova 
class_name Room
extends Node2D

const SIZE: Vector2 = Vector2(258 * 1.2, 115 * 1.2) #edit by karwei to optimize room gen
var connections: int = 0
#@onready var topCollision: = $Walls/TopNoDoor
#@onready var botCollision: = $Walls/BottomNoDoor
#@onready var leftCollision: = $Walls/LeftNoDoor
#@onready var rightCollision: = $Walls/RightNoDoor
#@onready var topDoor: = $TopDoor
#@onready var botDoor: = $BotDoor
#@onready var leftDoor: = $LeftDoor
#@onready var rightDoor: = $RightDoor

#enum direction{ 
	#up = Vector2(0,-1), 
	#down = Vector2(0,1),
	#left = Vector2(-1,0),
	#right = Vector2(1,0)
#}
#@export var rType: RoomType.zero #naming the current room type to abstract it and make the room type modifiable 
#ie: creating your own path as long as a room exists next to one you can use an item to dig through thus changing the type of the room and flexibility in traversing room
#might have to either use room scanner signals for the above or make a neighbors var

#connected rooms dictionary has a direction and details if a room is actually connected to it once again not all adjacent rooms are connected
@export var connectedRooms: Dictionary = {
	Vector2(1,0): null, 
	Vector2(-1,0): null, 
	Vector2(0,1): null, 
	Vector2(0,-1): null 
}
#wip function for future
#physics process would allow the possibility of changing the room type and create openings through actions/events
#func _physics_process(delta):
	#match rType:

#ready is called when an object is added to the scene tree	
func _ready():
	updateRoom()

#Emit room entered signal if body entered is the player.
#function is used to talk to the camera to lock it to a room instead of free roam camera
#camera is currently work in progress
func _on_play_area_body_entered(body: Node2D) -> void:
	print("HI")
	Events.room_entered.emit(self)

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
func _on_north_area_entered(area):
	if area.is_in_group("RoomScanners") and connectedRooms[Vector2(1,0)] != null:
		print("room is connected")
		
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

func openBot()-> void:
	if($Walls/BottomNoDoor):
		$Walls/BottomNoDoor.set_disabled(true)
		$BotDoor.visible = true
	
func openRight()-> void:
	if($Walls/RightNoDoor):
		$Walls/RightNoDoor.set_disabled(true)
		$RightDoor.visible = true
	
func openLeft()-> void:
	if($Walls/LeftNoDoor):
		$Walls/LeftNoDoor.set_disabled(true)
		$LeftDoor.visible = true
	
