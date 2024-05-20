## Karwei K
extends Node2D
## A simple 2D circle for representing nodes on the map.

@export var size: float = 10.0
@export var color: Color = Color.RED


func _draw() -> void:
	draw_circle(position, size, color)
