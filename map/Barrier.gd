class_name Barrier
extends Sprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

#plays and stops playing barrier animation called from room script which knows which barriers to activate
func setBarrier() -> void:
	set_visible(true)
	animation_player.play("barrier")

func removeBarrier() -> void:
	set_visible(false)
