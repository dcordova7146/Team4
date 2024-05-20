# Diego Cordova, Karwai Kang
class_name Room
extends Node2D

## Determines the behavior upon entering.
enum RoomType {
	BATTLE = 2,
	SHOP = 3,
	REST = 4,
	BOSS = 5,
	## Where the player begins.
	START = 1,
	ROOM = 0
}
## Size of the sprite.
const WIDTH: int = 320
const HEIGHT: int = 160
const WALL: int = 12
const SIZE: Vector2 = Vector2(
		WIDTH,
		HEIGHT
)
const SIZE_DOOR: int = 40
## Number of enemies to spawn.
@export var enemy_count: int = 3
## Array of enemies and their corresponding weights.
@export var enemies_possible: Array[ChanceRow]
## Scene of door.
@export var door_scene: PackedScene
## Sprite of a horizontal door.
@export var door_sprite_horizontal: CompressedTexture2D
## Sprite of a vertical door.
@export var door_sprite_vertical: CompressedTexture2D
## Scene of a teleporter.
@export var teleporter_scene: PackedScene
## Number of rooms connected to it.
var connections: int = 0
## Enemies inside it.
var enemies_inside: Array[Skull] = []
## Doors of the room.
var doors: Array[Door]
## Label describing the controls. Only visible in starting room.
@onready var explanation_label: Label = $ExplanationLabel
## Walls
@onready var walls: StaticBody2D = $Walls
## Collision shape of the area.
@onready var area_shape: CollisionShape2D = $Area2D/CollisionShape2D
## Boss enemy scene.
@onready var boss_skull: PackedScene = preload("res://enemy/skull_queen.tscn")
## Campfire scene.
@onready var campfire: PackedScene = preload("res://map/camp.tscn")
## Shop mat scene.
@onready var shop: PackedScene = preload("res://drop/shop_mat.tscn")
## all related trap prefabs 
@onready var x_prefab: PackedScene = preload("res://map/trap/x_prefab.tscn")
@onready var o_prefab: PackedScene = preload("res://map/trap/o_prefab.tscn")
@onready var l_prefab: PackedScene = preload("res://map/trap/[]_prefab.tscn")
var trap_prefabs: Array[PackedScene]
## Rooms connected to this room. Have doorways to them and vice-versa.
var connected_rooms: Dictionary = {
	Vector2.UP: null,
	Vector2.RIGHT: null,
	Vector2.DOWN: null,
	Vector2.LEFT: null
}
## Type of the room.
var room_type: RoomType = RoomType.ROOM
## Whether enemies have been spawned in the room.
var entered: bool = false


func _ready() -> void:
	#ready the trap prefab array with the 3 varieties of trap layout patterns
	trap_prefabs.append(x_prefab)
	trap_prefabs.append(o_prefab)
	trap_prefabs.append(l_prefab)
	# Set area.
	var shape: RectangleShape2D = RectangleShape2D.new()
	shape.size = Vector2(
			WIDTH - 2 * WALL,
			HEIGHT - 2 * WALL
	)
	area_shape.shape = shape
	# Create walls.
	var polygon: PackedVector2Array = PackedVector2Array([
			Vector2(WIDTH / -2, HEIGHT / -2),
			Vector2(SIZE_DOOR / -2, HEIGHT / -2),
			Vector2(SIZE_DOOR / -2, HEIGHT / -2 + WALL),
			Vector2(WIDTH / -2 + WALL, HEIGHT / -2 + WALL),
			Vector2(WIDTH / -2 + WALL, SIZE_DOOR / -2),
			Vector2(WIDTH / -2, SIZE_DOOR / -2),
	])
	create_wall(polygon)
	create_wall(polygon * Transform2D(Vector2.LEFT, Vector2.DOWN, Vector2.ZERO))
	create_wall(polygon * Transform2D(Vector2.LEFT, Vector2.UP, Vector2.ZERO))
	create_wall(polygon * Transform2D(Vector2.RIGHT, Vector2.UP, Vector2.ZERO))
	# Create doors.
	create_door(
			Vector2(0, HEIGHT / -2 + WALL / 2),
			door_sprite_horizontal,
			connected_rooms[Vector2.UP] == null
	)
	create_door(
			Vector2(WIDTH / 2 - WALL / 2, 0),
			door_sprite_vertical,
			connected_rooms[Vector2.RIGHT] == null
	)
	create_door(
			Vector2(0, HEIGHT / 2 - WALL / 2),
			door_sprite_horizontal,
			connected_rooms[Vector2.DOWN] == null, Vector2(1, -1)
	)
	create_door(
			Vector2(WIDTH / -2 + WALL / 2, 0),
			door_sprite_vertical,
			connected_rooms[Vector2.LEFT] == null, Vector2(-1, 1)
	)


func create_wall(polygon: PackedVector2Array) -> void:
	var collision: CollisionPolygon2D = CollisionPolygon2D.new()
	collision.polygon = polygon
	walls.add_child(collision)


func create_door(
		door_position: Vector2,
		texture: CompressedTexture2D,
		sealed: bool = false,
		door_scale: Vector2 = Vector2.ONE
	) -> void:
	var door: Door = door_scene.instantiate()
	door.position = door_position
	door.sprite_texture = texture
	door.sprite_scale = door_scale
	door.sealed = sealed
	add_child(door)
	doors.append(door)


## Update the connected rooms based on room generation.
## In order to make traversal more interesting not all adjacent rooms are connected
func connect_rooms(room2: Room, direction: Vector2) -> void:
	connected_rooms[direction] = room2
	room2.connected_rooms[-direction] = Room
	connections += 1
	room2.connections += 1


## Open all doors.
func open_doors() -> void:
	for door: Door in doors:
		door.locked = false


func spawn_enemies() -> void:
	#var total_weight: float = 0.0
	#for chance_row: ChanceRow in enemies_possible:
		#total_weight += chance_row.chance
	
	#iterate for amount of enemies we have alloted in one room
	for i: int in range(enemy_count):
		# Randomly choose an enemy type.
		var offset: float = 0
		var enemy_scene: PackedScene
		for chance_row: ChanceRow in enemies_possible:
			if randf() < chance_row.chance + offset:
				enemy_scene = chance_row.scene
				break
			offset += chance_row.chance
		var instance: Skull = enemy_scene.instantiate()
		add_enemy(instance)
		instance.set_deferred("position", get_random_position())

## coin flip on a room generation if heads pick between 3 different trap layouts
func spawn_Trap() -> void:
	if randi_range(0,1) == 1:
		var trap_instance: Node
		var random_index: int = randi_range(1,3)
		match random_index:
			1: trap_instance = trap_prefabs[0].instantiate()
			2: trap_instance = trap_prefabs[1].instantiate()
			3: trap_instance = trap_prefabs[2].instantiate()
		call_deferred("add_child", trap_instance)


## Spawn a boss.
## TODO and a boss health bar.
func spawn_boss() -> void:
	var instance: Skull = boss_skull.instantiate()
	add_enemy(instance)


## Give player choice to upgrade or heal themselves.
func spawn_camp() -> void:
	var campInstance: Node2D = campfire.instantiate()
	call_deferred("add_child", campInstance)

## Spawn a shop for the player to spend currency.
func spawn_shop() -> void:
	var shopInstance: Node2D = shop.instantiate()
	call_deferred("add_child", shopInstance)


## Add an enemy.
func add_enemy(new_enemy: Skull) -> void:
	new_enemy.defeated.connect(_on_enemy_defeated)
	enemies_inside.append(new_enemy)
	call_deferred("add_child", new_enemy)


## Returns a random position in the predetermined bounds of the room.
func get_random_position() -> Vector2:
	var size_x: float = WIDTH - 2 * WALL
	var size_y: float = HEIGHT - 2 * WALL
	var random_x: float = randf_range(0, size_x - 4)
	var random_y: float = randf_range(0, size_y - 4)
	return Vector2(random_x - size_x / 2, random_y - size_y / 2)


## Add barriers at doors, locking player and enemies.
func barricade_doors() -> void:
	for door: Door in doors:
		door.locked = true


## Wake all enemies inside.
func wake_enemies() -> void:
	for enemy: Skull in enemies_inside:
		enemy.awake = true

## Moved room population from dungeon creation to instead occur on entering a room for optimization purposes
func _on_play_area_body_entered(_body: Node2D) -> void:
	# Tell camera to move to room.
	Events.room_entered.emit(self)
	# Don't do anything if already entered.
	if entered:
		return
	match room_type:
		RoomType.BATTLE:
			barricade_doors()
			spawn_enemies()
			spawn_Trap()
		RoomType.SHOP:
			spawn_shop()
		RoomType.REST:
			spawn_camp()
		RoomType.BOSS:
			barricade_doors()
			spawn_boss()
		RoomType.START:
			explanation_label.show()
		RoomType.ROOM:
			push_error("Invalid room type ROOM")
		_:
			push_error("Unknown room type ", room_type)
	entered = true


func _on_play_area_body_exited(_body: Node2D) -> void:
	open_doors()


## Remove enemy from list and update doors if empty.
func _on_enemy_defeated(defeated_enemy: Skull) -> void:
	var index: int = enemies_inside.find(defeated_enemy)
	if index != -1:
		enemies_inside.remove_at(index)
	# Unlock upon wave clear.
	if enemies_inside.is_empty():
		open_doors()
	# Spawn teleporter to new dungeon.
	if room_type == RoomType.BOSS and enemies_inside.is_empty(): 
		var new_teleporter: Node2D = teleporter_scene.instantiate()
		new_teleporter.name = "DungeonTeleporter"
		call_deferred("add_child", new_teleporter)
