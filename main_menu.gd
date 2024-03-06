## Contributors: Karwai

class_name MainMenu 
extends CanvasLayer
## The main menu, which is the first screen displayed.

signal start_game
signal settings_menu_opened


func _ready() -> void:
	start()


## Focus the start button.
func start() -> void:
	show()
	($Buttons/StartButton as Button).grab_focus()


## Hide the menu when "Start" button pressed.
func _on_start_button_pressed() -> void:
	hide()
	start_game.emit()


func _on_settings_button_pressed() -> void:
	settings_menu_opened.emit()


## Exit the game when "Quit" pressed.
func _on_quit_to_desktop_button_pressed() -> void:
	get_tree().quit()
