extends Node
## The main scene, holding all other nodes.


## Create a new game instance and listen for restart/quit events.
func start_game() -> void:
	var game: PackedScene = preload("res://scenes/test_dungeon.tscn")
	var game_instance := game.instantiate() as TestDungeon
	if game_instance != null:
		add_child(game_instance)
		game_instance.game_restarted.connect(start_game)
		game_instance.game_exited_to_menu.connect(show_main_menu)


## Show the main menu.
func show_main_menu() -> void:
	($MainMenu as MainMenu).start()


## Open settings menu.
func _on_main_menu_settings_menu_opened() -> void:
	var settings: PackedScene = preload("res://scenes/settings_menu.tscn")
	var settings_instance := settings.instantiate() as SettingsMenu
	if settings_instance != null:
		add_child(settings_instance)
		settings_instance.settings_menu_closed.connect(show_main_menu)
