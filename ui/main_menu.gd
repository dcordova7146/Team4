## Contributors: Karwai
class_name MainMenu 
extends CanvasLayer
## The main menu, which is the first screen displayed.

signal new_game_requested(seed: int)
signal settings_menu_opened

@onready var seed_input: LineEdit = %SeedTextInput

## RegEx for number-only strings.
var number_regex: RegEx = RegEx.new()
## The text of the seed input before it's changed.
var _old_text: String = ""


func _ready() -> void:
	# Create a RegEx for a string of only digits.
	number_regex.compile("^\\d*$")
	start()


## Focus the start button.
func start() -> void:
	show()
	($Buttons/StartButton as Button).grab_focus()


## Hide and request a new game with a seed.
func _on_start_button_pressed() -> void:
	hide()
	# Get seed from text input.
	var text: String = seed_input.text
	# If blank, use a random seed.
	var dungeon_seed: int = (
			randi_range(0, 1_000_000)
			if text == ""
			else int(text)
	)
	new_game_requested.emit(dungeon_seed)


func _on_settings_button_pressed() -> void:
	settings_menu_opened.emit()


## Exit the game when "Quit" pressed.
func _on_quit_to_desktop_button_pressed() -> void:
	get_tree().quit()


## Disallow input of non-digit characters in seed text input field.
func _on_seed_text_input_text_changed(new_text: String) -> void:
	if number_regex.search(new_text):
		_old_text = new_text
	else:
		seed_input.text = _old_text
		seed_input.caret_column = seed_input.text.length()
