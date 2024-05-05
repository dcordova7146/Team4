## Contributors: Karwai

class_name SettingsMenu
extends CanvasLayer
## The settings menu, containing controls to configure the game.

signal settings_menu_closed

@onready var FullscreenButton: CheckButton = $Root/Scroll/Inputs/FullscreenButton
@onready var ResolutionButton: OptionButton = $Root/Scroll/Inputs/ResolutionButton
@onready var BackButton: Button = $Root/Nav/BackButton
@onready var reticles: HBoxContainer = %Reticles

func _ready() -> void:
	_create_reticle_buttons()
	_reflect_current_settings()
	## Focus the back button.
	BackButton.grab_focus()


## Create buttons to change the appearance of the mouse cursor.
func _create_reticle_buttons() -> void:
	# Add to button group, turning them into radio buttons. 
	var button_group: ButtonGroup = ButtonGroup.new()
	for index: int in range(Main.RETICLE_COUNT):
		var checkbox: CheckBox = CheckBox.new()
		checkbox.button_group = button_group
		checkbox.icon = Main.get_reticle_image(index)
		checkbox.pressed.connect(_on_reticle_button_pressed.bind(index))
		reticles.add_child(checkbox)


## Reflect the actual settings of the game in the inputs.
func _reflect_current_settings() -> void:
	FullscreenButton.set_pressed_no_signal(
			get_tree().root.mode == Window.MODE_EXCLUSIVE_FULLSCREEN
	)
	_reflect_window_resolution()
	# Also reflect the resolution when it changes.
	get_tree().root.size_changed.connect(_reflect_window_resolution)


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


## Change the reticle depending on the reticle button pressed.
func _on_reticle_button_pressed(index: int) -> void:
	Main.set_reticle(index)


## Reflect the resolution of the viewport in the resolution button.
func _reflect_window_resolution() -> void:
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
