class_name Life
extends StaticBody2D
## A heart shape that collides with the player.


## Draw as a heart shape.
func _draw() -> void:
	Lives.draw_heart(self, 20.0, Vector2(-10, -10))
