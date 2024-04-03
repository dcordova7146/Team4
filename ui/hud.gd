extends CanvasLayer

@onready var lives: Meter = $Lives


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.lives_changed.connect(_on_lives_changed)


## Redraw HUD life bar with given values.
func _on_lives_changed(current_lives: int, max_lives: int) -> void:
	lives.update(current_lives, max_lives)
