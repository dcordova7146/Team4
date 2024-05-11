extends HBoxContainer

@onready var slots = get_children()

#iterate through all slots in inventory until an empty slot is found insert the obtained artifact into the next open slot
func add_artifact(name)->void:
	print("adding item")
	for itemSlot in slots:
		if itemSlot.resource == null:
			itemSlot.resource = name
			return
