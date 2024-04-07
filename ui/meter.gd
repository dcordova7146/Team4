@tool
class_name Meter
extends BoxContainer
## A sort of progress bar for displaying discrete values.

## Max value.
@export var max_value: int = 10
## Current value.
@export var value: int = 5
## Texture of filled value.
@export var texture_filled: Texture2D = load("res://tempAssets/drops/heart.png")
## Texture of empty value.
@export var texture_empty: Texture2D = load("res://tempAssets/drops/heart_empty.png")


## Change both value and max value and reflect them visually.
func update(new_current_value: int, new_max_value: int) -> void:
	value = new_current_value
	max_value = new_max_value
	# Remove the current children.
	while get_child_count() > 0:
		remove_child(get_child(0))
	# Add new children to represent new health state.
	for i: int in range(max_value):
		var texture: Texture2D = (
				texture_filled 
				if i < value
				else texture_empty
		)
		var texture_rect: TextureRect = TextureRect.new()
		texture_rect.texture = texture
		add_child(texture_rect)
