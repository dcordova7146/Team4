extends Sprite2D
class_name AbstractItem

@onready var area:Area2D = $Area2D
@onready var collision: CollisionShape2D = $Area2D/CollisionShape2D
@export var resource: Artifact = null:
	
	set(data):
		resource = data
		if data != null:
			texture = data.icon
			#resource.connect()

#test stack functionality and picking up artifacts		
func _ready():
	#pass
	#resource = ResourceDirectory.get_resource("Vitamins")
	resource = SqLiteController.selectRandomArtifact()


func item_effect()->void:
	print("item passive in effect")

##pickup item call to send item to inventory
##add the item as a child of the player to grant the player the items effect
func _on_player_entered(body)->void:
	if (body is Player) and (is_in_group("artifacts")):
		visible = false
		collision.disabled = true
		body.obtain_artifact(resource)
		call_deferred("reparent", body)
		#queue_free()
		

