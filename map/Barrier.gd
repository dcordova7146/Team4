extends Sprite2D

#plays and stops playing barrier animation called from room script which knows which barriers to activate
func setBarrier()->void:
	print("Setting barrier")
	set_visible(true)
	$AnimationPlayer.play("barrier")

func removeBarrier()->void:
	print("Removing barrier")
	set_visible(false)
	$AnimationPlayer.stop()
