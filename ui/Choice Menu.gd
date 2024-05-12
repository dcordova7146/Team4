extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	

#on body entered of campfire obtain signal to turn on visibility of menu
func choose():
	get_tree().paused = true
	visible = true
	
func chosen():
	visible = false
	get_tree().paused = false
	
func _on_leftchoice_mouse_entered():
	#display description of item within 
	pass # Replace with function body.

func _on_leftchoice_mouse_exited():
	#remove display
	pass # Replace with function body.

func _on_rightchoice_mouse_entered():
	#display description of item within 
	pass # Replace with function body.

func _on_rightchoice_mouse_exited():
	#remove display
	pass # Replace with function body.
