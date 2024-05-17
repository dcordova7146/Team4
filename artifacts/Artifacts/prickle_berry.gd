extends AbstractItem


func activate(_player: Player) -> void:
	Events.pierce_modifier.emit()
