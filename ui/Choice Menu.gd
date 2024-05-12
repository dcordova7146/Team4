extends HBoxContainer

#@onready var player: Player = preload("/Player")
# Called when the node enters the scene tree for the first time.
var player
func _ready():
	visible = false
	Events.connect("choiceBegun", choose)

#on body entered of campfire obtain signal to turn on visibility of menu
func choose(body):
	player = body
	print("choice begun")
	get_tree().paused = true
	visible = true
	
func chosen(modifier: String):
	visible = false
	if modifier == "blood":
		print("player chose 15 blood")
		player.gain_blood_count(15)
		
	if modifier == "hearts":
		print("player chose full heal")
		for i in player.max_lives:
			player._gain_life()
	get_tree().paused = false
	

func _on_left_button_down():
	chosen("blood")


func _on_right_button_down():
	chosen("hearts")
