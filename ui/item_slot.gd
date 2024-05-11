extends PanelContainer

@onready var box = $box

var resource: Artifact = null:
	set(data):
		resource = data
		
		if data != null:
			box.texture = data.icon
		else:
			box.texture = data
