#Diego Cordova 
class_name Room
extends Node2D

const SIZE: Vector2 = Vector2(258 * 1.2, 115 * 1.2) #edit by karwei to optimize room gen
var connections: int = 0
@export var enemycount: int = 3
@onready var playArea: Node2D = $"Play Area"
@onready var type_label: Label = $TypeLabel
var enemies_inside: Array[Skull] = []
@export var warning: Resource
## Array of enemies and their corresponding weights.
@export var enemies_possible: Array[ChanceRow]
 
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
enum roomType {
	BATTLE = 2,
	SHOP = 3,
	REST = 4,
	BOSS = 5,
	START = 1,
	ROOM = 0
}
@export var rType: roomType = roomType.ROOM

func _ready() -> void:
	#Events.dungeon_complete.connect(on_Dungeon_Complete)
	setupRoom()
	
#Emit room entered signal if body entered is the player.
#function is used to talk to the camera to lock it to a room instead of free roam camera
func on_Dungeon_Complete()->void:
	#print("called?")
	updateRoom()
	#setupRoom()
	

func _on_play_area_body_entered(_body: Node2D) -> void:
	#print("Room entered")
	Events.room_entered.emit(self) 
	match rType:
		roomType.BATTLE:
			print("This is a battle room")
			wakeEnemies()
			# Don't lock room if there's no enemies inside.
			# (i.e. after the room was already cleared before.)
			if not enemies_inside.is_empty():
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

func _on_play_area_body_exited(_body: Node2D) -> void:
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
		($TopDoor as Node2D).visible = true
		($Walls/TopNoDoor as CollisionShape2D).set_deferred("disabled", true)
		($"TopBarrier" as Barrier).removeBarrier()
		
func openBot()-> void:
	if($Walls/BottomNoDoor):
		($Walls/BottomNoDoor as CollisionShape2D).set_deferred("disabled", true)
		($BotDoor as Node2D).visible = true
		($"BotBarrier" as Barrier).removeBarrier()
	
func openRight()-> void:
	if($Walls/RightNoDoor):
		($Walls/RightNoDoor as CollisionShape2D).set_deferred("disabled", true)
		($RightDoor as Node2D).visible = true
		($"RightBarrier" as Barrier).removeBarrier()
		
func openLeft()-> void:
	if($Walls/LeftNoDoor):
		($Walls/LeftNoDoor as CollisionShape2D).set_deferred("disabled", true)
		($LeftDoor as Node2D).visible = true
		($"LeftBarrier" as Barrier).removeBarrier()
		
func populateEnemySpawner() -> void:
	#grab collision shape within the play area area2d to obtain the bounds of the play area
	print("populating...")
	var total_weight: float = 0.0
	for chance_row: ChanceRow in enemies_possible:
		total_weight += chance_row.chance
	
	#iterate for amount of enemies we have alloted in one room
	for i: int in range(enemycount):
		# Randomly choose an enemy type.
		var offset: float = 0
		var enemy_scene: PackedScene
		var rng: float = randf()
		for chance_row: ChanceRow in enemies_possible:
			if rng < chance_row.chance + offset:
				enemy_scene = chance_row.scene
				break
			offset += chance_row.chance
			
		var instance: Skull = enemy_scene.instantiate()
		add_enemy(instance)
		instance.set_deferred("global_position", get_random_position())


## Add an enemy.
func add_enemy(new_enemy: Skull) -> void:
	new_enemy.defeated.connect(on_kill)
	enemies_inside.append(new_enemy)
	call_deferred("add_child", new_enemy)


## Returns a random position in the predetermined bounds of the room.
func get_random_position()-> Vector2:
	var topleft: Vector2 = ($"Play Area/topLeftBound" as Marker2D).global_position
	var topright: Vector2 = ($"Play Area/topRightBound" as Marker2D).global_position
	var botleft: Vector2 = ($"Play Area/botLeftBound" as Marker2D).global_position
	var botright: Vector2 = ($"Play Area/botRightBound" as Marker2D).global_position
	var randx: float = randf_range(topleft.x,topright.x)
	var randy: float = randf_range(topleft.y,botleft.y)
	return Vector2(randx,randy)
	
	
func lockRoom() -> void:
	#add possible barriers corresponding to open doors
	#reactivate collisions to lock a player and enemies in a room
	print("locking room")
	if connectedRooms[Vector2(0,-1)] != null:
		print("top door is now locked")
		($"TopBarrier" as Barrier).setBarrier()
		($Walls/TopNoDoor as CollisionShape2D).set_deferred("disabled", false)
	if connectedRooms[Vector2(0,1)] != null:
		print("bot door is now locked")
		($"BotBarrier" as Barrier).setBarrier()
		($Walls/BottomNoDoor as CollisionShape2D).set_deferred("disabled", false)
	if connectedRooms[Vector2(1,0)] != null:
		print("right door is now locked")
		($"RightBarrier" as Barrier).setBarrier()
		($Walls/RightNoDoor as CollisionShape2D).set_deferred("disabled", false)
	if connectedRooms[Vector2(-1,0)] != null:
		print("left door is now locked")
		($"LeftBarrier" as Barrier).setBarrier()
		($Walls/LeftNoDoor as CollisionShape2D).set_deferred("disabled", false)
	else:
		pass

func unlockRoom()->void:
	#upon wave clear room should unlock	
	print("Unlocking room")	
	updateRoom()
	
func wakeEnemies()->void:
	for enemy: Skull in enemies_inside:
		enemy.awake = true
	
func setupRoom()->void:
	#this function shall spawn whatever a room requires of it
	match rType:
		roomType.BATTLE:
			populateEnemySpawner()
			type_label.text = "⚔ Battle"
		roomType.SHOP:
			type_label.text = "💰 Shop"
			# insantiate a shop for the player to spend currency to upgrade
		roomType.REST:
			type_label.text = "🏕 Rest"
			# should give the player a choice to upgrade or heal themselves
		roomType.BOSS:
			# lockRoom()
			type_label.text = "👿 Boss"
			# spawn a boss and a boss health bar
		roomType.START:
			# where the player begins
			type_label.text = "🏁 Start"
		roomType.ROOM:
			#a room of ROOM type shouldnt happen this is a check for if the generator didnt mess up
			type_label.text = "Room"
		_:
			print("Unknown state")

func set_Rtype(tag: roomType) -> void:
	rType = tag
	pass
	
#error the kill is being registered multiple times instead of once
#accurately grabbing the enemy and removing it from the array of enemies but 1 kill removes all enemies for some reason
func on_kill(defeated_enemy: Skull) -> void:
	var index: int = enemies_inside.find(defeated_enemy)
	if index != -1:
		enemies_inside.remove_at(index)
	else:
		pass
	
	if enemies_inside.is_empty():
		unlockRoom()
