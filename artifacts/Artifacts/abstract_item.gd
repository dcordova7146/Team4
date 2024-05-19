class_name AbstractItem
extends Sprite2D

@onready var collision: CollisionShape2D = $Area2D/CollisionShape2D
@export var artifact_name: String:
	set(new_name):
		if SqLiteController.artifacts.has(new_name):
			artifact_name = new_name
			_resource = SqLiteController.artifacts[artifact_name]
			texture = _resource.icon
var _resource: Artifact


func activate(_player: Player) -> void:
	pass


## Move to given player node and add associated artifact to inventory.
## add the item as a child of the player to grant the player the items effect
func _on_player_entered(player: Player) -> void:
	if is_in_group("artifacts"):
		visible = false
		collision.set_deferred("disabled", true)
		player.obtain_artifact(_resource)
		call_deferred("reparent", player)
		activate(player)
