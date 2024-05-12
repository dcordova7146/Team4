extends AbstractItem


# Called when the node enters the scene tree for the first time.
func _ready():
	resource = ResourceDirectory.get_resource("Artificial Blood")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_player_entered(body):
	if (body is Player) and (is_in_group("artifacts")):
		visible = false
		collision.disabled = true
		body.obtain_artifact(resource)
		call_deferred("reparent", body)
		Events.gain_money.emit(25)
