## Contributors: Karwai

extends CanvasLayer
## Menu that appears when the game is paused.

signal game_restarted
signal game_exited_to_menu


## Pause game logic.
##
## Only affects nodes whose process mode is explictly "Pausable",
## as the main scene's process mode is "Always".
func pause() -> void:
	get_tree().paused = true;
	show()
	# Focus the first button.
	($Buttons/ResumeButton as Button).grab_focus()
	

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
	game_restarted.emit()


## Unpause, then hand off quit-to-menu to parent node.
func _on_quit_to_menu_button_pressed() -> void:
	get_tree().paused = false
	game_exited_to_menu.emit()


## Exit game.
func _on_quit_to_desktop_button_pressed() -> void:
	get_tree().quit()
