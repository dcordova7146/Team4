extends Sprite2D
class_name AbstractItem

var resource: Artifact = null:
	set(data):
		resource = data
		if data != null:
			texture = data.icon
		
func _ready():
	#pass
	resource = ResourceDirectory.get_resource("Vitamins")
