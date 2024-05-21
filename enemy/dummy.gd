## Diego C
extends Skull

#@onready var on_hit: AnimationPlayer = $on_hit
	
## create a dummy with an "infinite amount of health" 
## overload the ready function to use only the necessary stats
func _ready() -> void:
	# Initialize health and speed
	health = 99999999999
	speed = 0
	health_bar.max_value = health

## overload physics to ignore the skulls natural chase state
func _physics_process(_delta: float) -> void:
	pass

## overload the take_damage function from skull parent class
func take_damage(damage_total: float) -> void:
	Events.health_changed.emit(global_position, -damage_total)
	on_hit_animation.play("onHit")
	
