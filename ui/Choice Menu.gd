extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	Events.connect("choiceBegun", choose)

#on body entered of campfire obtain signal to turn on visibility of menu
func choose():
	print("choice begun")
	get_tree().paused = true
	visible = true
	
func chosen(modifier: String):
	visible = false
	if modifier == "blood":
		print("player chose 15 blood")
		
	if modifier == "hearts":
		print("player chose full heal")
		
	get_tree().paused = false
	

func _on_left_button_down():
	chosen("blood")


func _on_right_button_down():
	chosen("hearts")
