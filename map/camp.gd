extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("fire")

func _on_area_2d_body_entered(body):
	if body in is_in_group("Player"):
		
