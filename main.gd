## Contributors: Karwai
class_name Main
extends Node
## The main scene, holding all other nodes.

## Size of a reticle sprite image in pixels.
const RETICLE_SIZE: int = 64
## Number of reticle sprite images in the reticle atlas.
const RETICLE_COUNT: int = 4
## Reticle sprite atlas.
static var reticle: Texture2D = load("res://ui/reticle.png")

func _ready() -> void:
	# Change main viewport cull mask to hide sprite intended only for minimap.
	var viewport: Viewport = get_viewport()
	viewport.canvas_cull_mask = 4294967291
	# Use the first reticle.
	set_reticle(0)

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


## Get an individual reticle image from the reticle atlas image.
static func get_reticle_image(index: int) -> Resource:
	var atlas: AtlasTexture = AtlasTexture.new()
	atlas.set_atlas(reticle)
	var region_rect: Rect2 = Rect2(
			index * RETICLE_SIZE, 0, RETICLE_SIZE, RETICLE_SIZE
	)
	atlas.set_region(region_rect)
	return atlas


## Change the mouse cursor's appearance to a reticle.
static func set_reticle(type: int) -> void:
	var image = get_reticle_image(type)
	var hotspot: Vector2 = Vector2(RETICLE_SIZE / 2, RETICLE_SIZE / 2)
	Input.set_custom_mouse_cursor(
			image,
			Input.CursorShape.CURSOR_ARROW,
			hotspot
	)
