class_name HUD
extends CanvasLayer

@onready var lives: Meter = $TopLeft/Lives
@onready var loaded_bullets: Meter = $LowerLeft/LoadedBullets
@onready var reserved_bullets: Label = $LowerLeft/Weapon/ReservedBullets
@onready var weapon_equipped: TextureRect = $LowerLeft/Weapon/WeaponEquipped/TextureRect
@onready var seed_label: Label = $SeedLabel
## Reticle sprite atlas.
static var bullets: Texture2D = load("res://ui/bullets.png")

var active_weapon: Gun

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.lives_changed.connect(_on_lives_changed)
	Events.active_weapon_changed.connect(_on_active_weapon_changed)


## Redraw HUD life bar with given values.
func _on_lives_changed(current_lives: int, max_lives: int) -> void:
	lives.update(current_lives, max_lives)


## Reflect the number of loaded bullets in the meter.
func _update_loaded_bullets() -> void:
	loaded_bullets.update(
			active_weapon.loaded_bullet_count,
			active_weapon.loaded_bullet_count_max
	)


## Reflect the number of loaded bullets in the meter.
func _update_reserved_bullets() -> void:
	reserved_bullets.text = ("%d/%d" % [
			active_weapon.reserve_bullet_count,
			active_weapon.reserve_bullet_count_max,
	])

## Reflect the status of a given weapon.
func _on_active_weapon_changed(new_weapon: Gun) -> void:
	# Stop listening to changes on old weapon.
	if active_weapon and active_weapon.is_bullet_finite:
		active_weapon.loaded_bullet_count_changed.disconnect(_update_loaded_bullets)
		active_weapon.reserve_bullet_count_changed.disconnect(_update_reserved_bullets)
	
	active_weapon = new_weapon
	# Only monitor changes on weapon whose bullet counts will change.
	if active_weapon.is_bullet_finite:
		# Reflect status of new weapon.
		_update_loaded_bullets()
		_update_reserved_bullets()
		# Listen to changes on new weapon.
		active_weapon.loaded_bullet_count_changed.connect(_update_loaded_bullets)
		active_weapon.reserve_bullet_count_changed.connect(_update_reserved_bullets)
	else:
		# Don't show loaded bullets since they are irrelevant.
		loaded_bullets.visible = false
		reserved_bullets.text = "∞/∞"
	# Show weapon equipped.
	weapon_equipped.texture = new_weapon.sprite_2d.texture


## Get a texture cropped from a given region of a given texture.
static func get_cropped_texture(texture: Texture2D, region: Rect2) -> AtlasTexture:
	var atlas: AtlasTexture = AtlasTexture.new()
	atlas.set_atlas(texture)
	atlas.set_region(region)
	return atlas
