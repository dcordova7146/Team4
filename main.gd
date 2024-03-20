## Contributors: Karwai

extends Node
## The main scene, holding all other nodes.

## Change main viewport cull mask to hide sprite intended only for minimap.
func _ready() -> void:
	var viewport: Viewport = get_viewport()
	viewport.canvas_cull_mask = 4294967291

## Create a new game instance and listen for restart/quit events.
func start_game() -> void:
	var game: PackedScene = preload("res://map/dungeon.tscn")
	var game_instance: Dungeon = game.instantiate()
	if game_instance != null:
		add_child(game_instance)
		game_instance.game_restarted.connect(start_game)
		game_instance.game_exited_to_menu.connect(show_main_menu)


## Show the main menu.
func show_main_menu() -> void:
	($MainMenu as MainMenu).start()


## Open settings menu.
func _on_main_menu_settings_menu_opened() -> void:
	var settings: PackedScene = preload("res://ui/settings_menu.tscn")
	var settings_instance: SettingsMenu = settings.instantiate()
	if settings_instance != null:
		add_child(settings_instance)
		settings_instance.settings_menu_closed.connect(show_main_menu)
