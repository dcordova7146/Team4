extends Area2D

func _ready():
	$Portal.play()


func _on_body_entered(body: Node2D) -> void:
	Events.teleporter_entered.emit(self)
