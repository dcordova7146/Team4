class_name Door
extends Node2D
## Door of a room.

## Sprite of the barrier warning.
@onready var barrier_sprite: Sprite2D = $BarrierSprite
## Sprite of the door. Not present if sealed.
@onready var door_sprite: Sprite2D = $DoorSprite
## Animation player of barrier. For bobbing the sprite up and down.
@onready var animation_player: AnimationPlayer = $BarrierSprite/AnimationPlayer
## Collision shape. Only active if door closed or sealed.
@onready var collision_shape: CollisionShape2D = $StaticBody2D/CollisionShape2D
## Texture to set sprite if not sealed.
var sprite_texture: CompressedTexture2D
## Scale to set on sprite so doors can be flipped.
var sprite_scale: Vector2
## Door is disabled, and cannot be opened (i.e. a wall).
var sealed: bool = false
## Hide barrier sprite and disable collision.
## Has no effect if sealed.
## Returns true if successful, false otherwise.
var locked: bool = false:
	set(new_locked):
		if sealed:
			return false
		locked = new_locked
		barrier_sprite.visible = locked
		collision_shape.set_deferred("disabled", not locked)
		return true


func _ready() -> void:
	# If sealed, the sprite will not be set and can't be opened,
	# effectively becoming a wall.
	if sealed:
		collision_shape.disabled = false
	else:
		door_sprite.texture = sprite_texture
		door_sprite.scale = sprite_scale
	# Set the collision shape to the size of the texture.
	var shape: RectangleShape2D = RectangleShape2D.new()
	shape.size = sprite_texture.get_size()
	collision_shape.shape = shape
	# Move barrier up and down.
	animation_player.play("barrier")
