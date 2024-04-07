extends Node2D

@onready var on_hit_animation = $dummy


func take_damage(damage_total: float) -> void:
	Events.health_changed.emit(global_position, -damage_total)
	on_hit_animation.play("dummy_hit")
