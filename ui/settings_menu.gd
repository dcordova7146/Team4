## Contributors: Karwai

class_name SettingsMenu
extends CanvasLayer
## The settings menu, containing controls to configure the game.

signal settings_menu_closed

@onready var FullscreenButton: CheckButton = $Root/Scroll/Inputs/FullscreenButton
@onready var ResolutionButton: OptionButton = $Root/Scroll/Inputs/ResolutionButton
@onready var BackButton: Button = $Root/Nav/BackButton

## Relect the current settings and focus the back button.
func _ready() -> void:
	
	FullscreenButton.set_pressed_no_signal(
			get_tree().root.mode == Window.MODE_EXCLUSIVE_FULLSCREEN
	)
	
	reflect_window_resolution()
	# Also reflect the resolution when it changes.
	get_tree().root.size_changed.connect(reflect_window_resolution)
	
	BackButton.grab_focus()


## Close settings menu.
func _on_back_button_pressed() -> void:
	settings_menu_closed.emit()
	queue_free()


## Toggle fullscreen mode.
func _on_fullscreen_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		get_tree().root.mode = Window.MODE_EXCLUSIVE_FULLSCREEN
	else:
		get_tree().root.mode = Window.MODE_WINDOWED


## Change resolution.
func _on_resolution_button_item_selected(index: int) -> void:
	var prop: String = (
			"size"
			if get_tree().root.mode == Window.MODE_WINDOWED
			else "content_scale_size"
	)
	match index:
		0:
			get_tree().root.set(prop, Vector2(1280, 720))
		1:
			get_tree().root.set(prop, Vector2(1920, 1080))
		

## Reflect the resolution of the viewport in the resolution button.
func reflect_window_resolution() -> void:
	var prop: String = (
			"size"
			if get_tree().root.mode == Window.MODE_WINDOWED
			else "content_scale_size"
	)
	var size: Vector2 = get_tree().root.get(prop)
	match size:
		Vector2(1280, 720):
			ResolutionButton.select(0)
		Vector2(1920, 1080):
			ResolutionButton.select(1)
		_:
			var text: String = "%d×%d" % [size.x, size.y]
			if ResolutionButton.item_count < 3:
				ResolutionButton.add_item(text, 2)
				ResolutionButton.set_item_disabled(2, true)
			else:
				ResolutionButton.set_item_text(2, text)
			ResolutionButton.select(2)
