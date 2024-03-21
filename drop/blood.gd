extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	area_entered.connect(on_area_entered)

func on_area_entered(area):
	queue_free()
