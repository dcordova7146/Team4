extends AbstractItem


func activate(_player: Player) -> void:
	Events.damage_multiplier.emit(10.0)
