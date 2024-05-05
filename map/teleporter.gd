extends Area2D

@onready var portal: AnimatedSprite2D = $Portal

func _ready() -> void:
	portal.play()


func _on_body_entered(_body: Node2D) -> void:
	Events.teleporter_entered.emit(self)
