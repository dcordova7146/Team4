extends HBoxContainer

@onready var slots:Array = get_children()
@onready var slotScene = preload("res://ui/item_slot.tscn")
@onready var toAdd: bool = true
#iterate through all slots in inventory until an empty slot is found insert the obtained artifact into the next open slot

func add_artifact(name:Artifact)->void:
	toAdd = true
	#slots = get_children()
	for i in slots:
		if i.resource == name:
			i.updateStack()
			toAdd = false
	
	if toAdd:
		var newSlot = slotScene.instantiate()
		self.add_child(newSlot)
		slots = get_children()
		for itemSlot in slots:
			if itemSlot.resource == null:
				itemSlot.resource = name

