extends AbstractItem


# Called when the node enters the scene tree for the first time.
func _ready():
	resource = ResourceDirectory.get_resource("Plan Z")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_entered(body):
	if (body is Player) and (is_in_group("artifacts")):
		visible = false
		collision.disabled = true
		body.obtain_artifact(resource)
		call_deferred("reparent", body)
		Events.speed_multiplier.emit(15.0)
		Events.damage_multiplier.emit(15.0)
		Events.pierce_modifier.emit()
		Events.reload_speed_multiplier.emit(15.0)
		Events.range_multiplier.emit(15.0)
		Events.bullet_size_multiplier.emit(15.0)
