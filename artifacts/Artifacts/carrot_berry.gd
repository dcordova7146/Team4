extends AbstractItem


func activate(_player: Player) -> void:
	Events.range_multiplier.emit(10.0)
