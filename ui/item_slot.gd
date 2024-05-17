class_name ItemSlot
extends PanelContainer
## UI display of an item. Holds an amount of an item.

var item: Artifact = null:
	set(data):
		if data:
			item = data
			texture_rect.texture = data.icon
			count = 1
var count: int = 0:
	set(new_count):
		count = new_count
		label.text = str(count)

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label
