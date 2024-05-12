extends AbstractItem


# Called when the node enters the scene tree for the first time.
func _ready():
	resource = ResourceDirectory.get_resource("Shower in a Can")

func _on_player_entered(body):
	if (body is Player) and (is_in_group("artifacts")):
		visible = false
		collision.disabled = true
		body.obtain_artifact(resource)
		call_deferred("reparent", body)
		if(body.max_lives > 1):
			Events.dangerous_healing.emit()
		else:
			print("Max health is 1")
