extends Skull

@onready var on_hit: AnimationPlayer = $on_hit

func _ready() -> void:
	# Initialize health and speed
	health = 99999999999
	speed = 0
	health_bar.max_value = health
	print("Dummy")

func take_damage(damage_total: float) -> void:
	Events.health_changed.emit(global_position, -damage_total)
	on_hit.play("onHit")
	
