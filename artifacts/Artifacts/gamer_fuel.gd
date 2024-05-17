extends AbstractItem


func activate(_player: Player) -> void:
	Events.speed_multiplier.emit(5.0)
