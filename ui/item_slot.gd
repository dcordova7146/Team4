extends PanelContainer

@onready var box = $box
@onready var count = $Label
@onready var stack = 0

#set the resource inside the artifact to data
var resource: Artifact = null:
	set(data):
		resource = data
		
		if data != null:
			box.texture = data.icon
			updateStack()
		else:
			box.texture = data

func updateStack()->void:
	print("update stack")
	stack += 1
	count.text = str(stack)
