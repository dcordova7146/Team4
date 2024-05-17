extends AbstractItem


func activate(player: Player) -> void:
	if player.max_lives > 1:
		Events.dangerous_healing.emit()
	else:
		print("Max health is 1")
