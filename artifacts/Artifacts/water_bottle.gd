extends AbstractItem


func activate(_player: Player) -> void:
	Events.hydration.emit()
