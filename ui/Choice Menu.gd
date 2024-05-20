## Diego C, Karwei K
extends HBoxContainer

var player: Player

func _ready() -> void:
	Events.connect("choiceBegun", present_choice)

## Pause and show.
func present_choice(body: Node2D) -> void:
	player = body
	get_tree().paused = true
	visible = true


## Hide and unpause.
func hide_choice() -> void:
	visible = false
	get_tree().paused = false


## Give player 15 blood.
func _on_left_button_down() -> void:
	hide_choice()
	player.blood_count += 15


## Give player max lives.
func _on_right_button_down() -> void:
	hide_choice()
	for i: int in player.max_lives:
		player._gain_life()
