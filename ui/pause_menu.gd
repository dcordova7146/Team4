## Contributors: Karwai

extends CanvasLayer
## Menu that appears when the game is paused.

signal game_restarted(use_random: bool)
signal game_exited_to_menu

@onready var buttons: VBoxContainer = $Buttons
@onready var label: Label = $PauseLabel


## Listen to player death event.
func _ready() -> void:
	Events.player_died.connect(_on_player_died)


## Pause game logic and display menu with given message. 
##
## Only affects nodes whose process mode is explictly "Pausable",
## as the main scene's process mode is "Always".
func pause(message: String = "Paused") -> void:
	get_tree().paused = true
	label.text = message
	show()
	# Focus the first non-disabled button.
	for i: int in buttons.get_child_count():
		var button: Button = buttons.get_child(i)
		if not button.disabled:
			button.grab_focus()
			break
	

## Hide self and unpause game. 
func resume() -> void:
	hide()
	get_tree().paused = false


## Pause/Unpause in response to corresponding hotkey.
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_resume"):
		if visible:
			resume()
		else:
			pause()


## Unpause when "Resume" button pressed.
func _on_resume_button_pressed() -> void:
	resume()


## Unpause, then hand off restart to parent node.
func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	game_restarted.emit(false)


func _on_restart_random_button_pressed() -> void:
	get_tree().paused = false
	game_restarted.emit(true)


## Unpause, then hand off quit-to-menu to parent node.
func _on_quit_to_menu_button_pressed() -> void:
	get_tree().paused = false
	game_exited_to_menu.emit()


## Exit game.
func _on_quit_to_desktop_button_pressed() -> void:
	get_tree().quit()


## Pause game with "Game Over!" message and disable resume button.
func _on_player_died() -> void:
	var resume_button: Button = $Buttons/ResumeButton
	resume_button.disabled = true
	pause("Game Over!")
