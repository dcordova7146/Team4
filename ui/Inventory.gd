class_name Inventory
extends HBoxContainer

@export var slot_scene: PackedScene
var slots: Array[ItemSlot]

## Iterate through all slots in inventory until an empty slot is found.
## Insert the obtained artifact into the next open slot.
##
## Returns true if new slot added; false otherwise.
func add_artifact(artifact: Artifact) -> bool:
	# Add to existing stack if it already exists.
	for slot: ItemSlot in slots:
		if slot.item == artifact:
			slot.count += 1
			return false
	# if not found, add slot and place in inventory
	var new_slot: ItemSlot = slot_scene.instantiate()
	add_child(new_slot)
	new_slot.item = artifact
	slots.append(new_slot)
	return true
