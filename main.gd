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
	($MainMenu as CanvasLayer).show()
