extends CanvasLayer
## The main menu, which is the first screen displayed.

signal start_game


## Hide the menu when "Start" button pressed.
func _on_start_button_pressed() -> void:
	hide()
	start_game.emit()


## Exit the game when "Quit" pressed.
func _on_quit_to_desktop_button_pressed() -> void:
	get_tree().quit()
