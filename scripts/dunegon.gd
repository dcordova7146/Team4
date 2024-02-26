extends Node2D

var dungeon = {}
var roomScene = preload("res://scenes/room.tscn")
@onready var spawn = $Spawn

func _ready():
	dungeon = GenerateDungeon.generate(0)
	visualize()

func visualize():
	for i in range(0, spawn.get_child_count()):
		spawn.get_child(i).queue_free()
		
	for i in dungeon.keys():
		var temp = roomScene.instantiate()
		spawn.add_child(temp)
		temp.z_index = 1
		temp.position = i *10
		


func _on_button_pressed():
	randomize()
	dungeon = GenerateDungeon.generate(randi_range(-1000,1000))
	visualize()
