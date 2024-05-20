## Diego C
extends Area2D

@onready var portal: AnimatedSprite2D = $Portal

## play the animation for a teleporter
func _ready() -> void:
	portal.play()

## activate the teleporter 
func _on_body_entered(_body: Node2D) -> void:
	Events.teleporter_entered.emit(self)
