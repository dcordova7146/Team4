## Karwai K.
extends Node2D
## A simple 2D circle.

@export var size: float = 10.0
@export var color: Color = Color.RED


func _draw() -> void:
	draw_circle(position, size, color)
