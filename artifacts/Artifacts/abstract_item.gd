extends Sprite2D
class_name AbstractItem

var resource: Artifact = null:
	set(data):
		resource = data
		if data != null:
			texture = data.icon
			#resource.connect()
		
func _ready():
	#pass
	resource = ResourceDirectory.get_resource("Vitamins")

func item_effect()->void:
	print("item passive in effect")

##pickup item call to send item to inventory
##add the item as a child of the player to grant the player the items effect
func _on_player_entered(body)->void:
	if body is Player:
		body.obtain_artifact(resource)
		call_deferred("reparent", body)
		queue_free()

