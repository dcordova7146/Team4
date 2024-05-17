class_name AbstractItem
extends Sprite2D

@onready var collision: CollisionShape2D = $Area2D/CollisionShape2D
@export var resource: Artifact = null:
	set(data):
		resource = data
		if data != null:
			texture = data.icon


func activate(_player: Player) -> void:
	pass


## Pickup item call to send item to inventory
## add the item as a child of the player to grant the player the items effect
func _on_player_entered(player: Player) -> void:
	if is_in_group("artifacts"):
		visible = false
		collision.set_deferred("disabled", true)
		player.obtain_artifact(resource)
		call_deferred("reparent", player)
		activate(player)
